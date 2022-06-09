/* See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * Esri Inc. licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.esri.gpt.catalog.arcims;

import com.esri.gpt.catalog.context.CatalogIndexException;
import com.esri.gpt.catalog.management.MmdEnums;
import com.esri.gpt.framework.collection.StringAttributeMap;
import com.esri.gpt.framework.context.RequestContext;
import com.esri.gpt.framework.security.identity.IdentityAdapter;
import com.esri.gpt.framework.security.principal.Group;
import com.esri.gpt.framework.security.principal.Publisher;
import com.esri.gpt.framework.security.principal.User;
import com.esri.gpt.framework.sql.BaseDao;
import com.esri.gpt.framework.sql.IClobMutator;
import com.esri.gpt.framework.sql.ManagedConnection;
import com.esri.gpt.framework.util.ResourcePath;
import com.esri.gpt.framework.util.Val;
import com.esri.gpt.framework.xml.DomUtil;
import java.io.IOException;
import java.io.StringReader;
import java.io.StringWriter;
import java.net.URL;
import java.sql.*;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.xml.XMLConstants;
import javax.xml.namespace.NamespaceContext;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.Templates;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathFactory;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

/**
 * Manages ArcIMS Metadata Server like tables in the absence of the metadata
 * server.
 */
public class ImsMetadataProxyDao extends BaseDao {

    /**
     * class variables =========================================================
     */
    private static final Logger LOGGER = Logger.getLogger(ImsMetadataProxyDao.class.getName());
    /**
     * instance variables ======================================================
     */
    private Publisher publisher;
    private boolean groupsLoaded;

    /**
     * constructors ============================================================
     */
    /**
     * Constructs with an associated request context.
     *
     * @param requestContext the request context
     */
    public ImsMetadataProxyDao(RequestContext requestContext, Publisher publisher) {
        super(requestContext);
        this.publisher = publisher;
    }

    /**
     * properties ==============================================================
     */
    private String getResourceTableName() {
        return getRequestContext().getCatalogConfiguration().getResourceTableName();
    }

    private String getResourceDataTableName() {
        return getRequestContext().getCatalogConfiguration().getResourceDataTableName();
    }

    /**
     * methods =================================================================
     */
    /**
     * Authorizes a request.
     *
     * @param request the underlying request
     * @param the UUID of the subject record
     * @throws ImsServiceException typically related to an authorization related
     * exception
     * @throws SQLException if a database exception occurs
     */
    private void authorize(ImsRequest request, String uuid)
            throws ImsServiceException, SQLException {

        boolean checkOwner = false;
        if (request instanceof PutMetadataRequest) {
            checkOwner = true;
        } else if (request instanceof GetDocumentRequest) {
            if (!this.publisher.getIsAdministrator()) {
                checkOwner = true;
            }
        } else if (request instanceof DeleteMetadataRequest) {
            if (!this.publisher.getIsAdministrator()) {
                checkOwner = true;
            }
        } else if (request instanceof TransferOwnershipRequest) {
            if (!this.publisher.getIsAdministrator()) {
                throw new ImsServiceException("TransferOwnershipRequest: not authorized.");
            }
        }

        if (checkOwner) {
            int ownerID = this.queryOwnerByUuid(uuid);
            if ((ownerID != -1) && (ownerID != this.publisher.getLocalID())) {
                String username = Val.chkStr(queryUsernameByID(ownerID));
                if (!belongsToTheGroup(username)) {
                    String msg = "The document is owned by another user: " + username + ", " + uuid;
                    throw new ImsServiceException(msg);
                }
            }
        }

    }

    /**
     * Deletes a record from the proxied ArcIMS metadata table.
     *
     * @param request the underlying request
     * @param uuid the UUID for the record to delete
     * @return the number of rows affected
     * @throws ImsServiceException typically related to an authorization related
     * exception
     * @throws SQLException if a database exception occurs
     */
    protected int deleteRecord(DeleteMetadataRequest request, String uuid)
            throws ImsServiceException, SQLException {
        Connection con = null;
        boolean autoCommit = true;
        PreparedStatement st = null;
        int nRows = 0;
        try {
            this.authorize(request, uuid);
            ImsMetadataAdminDao adminDao = new ImsMetadataAdminDao(getRequestContext());
            nRows = adminDao.deleteRecord(uuid);
        } catch (CatalogIndexException ex) {
            if (con != null) {
                con.rollback();
            }
            throw new ImsServiceException(ex.getMessage(), ex);
        } catch (ImsServiceException ex) {
            if (con != null) {
                con.rollback();
            }
            throw ex;
        } catch (SQLException ex) {
            if (con != null) {
                con.rollback();
            }
            throw ex;
        } finally {
            closeStatement(st);
            if (con != null) {
                con.setAutoCommit(autoCommit);
            }
        }
        return nRows;
    }

    /**
     * Determines if a document UUID exists within the proxied ArcIMS metadata
     * table.
     *
     * @param con the JDBC connection
     * @param uuid the document UUID to check
     * @return true if the document UUID exists
     * @throws SQLException if a database exception occurs
     */
    private long doesRecordExist(String table, String uuid)
            throws SQLException {
        long id = -1;
        PreparedStatement st = null;
        try {
            Connection con = returnConnection().getJdbcConnection();
            String sSql = "SELECT ID FROM " + table + " WHERE DOCUUID=?";
            logExpression(sSql);
            st = con.prepareStatement(sSql);
            st.setString(1, uuid);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                id = rs.getLong(1);
            }
        } finally {
            closeStatement(st);
        }
        return id;
    }

    /**
     * Inserts or updates a record within the proxied ArcIMS metadata table.
     *
     * @param request the underlying request
     * @param info the information for the document to be inserted
     * @return the number of rows affected
     * @throws ImsServiceException typically related to an authorization related
     * exception
     * @throws SQLException if a database exception occurs
     */
    protected int insertRecord(PutMetadataRequest request, PutMetadataInfo info)
            throws ImsServiceException, SQLException {
        Connection con = null;
        boolean autoCommit = true;
        PreparedStatement st = null;
        ResultSet rs = null;
        LOGGER.finest("Inserimento Record");//added by Esri Italy
        // initialize
        int nRows = 0;
        String sXml = info.getXml();
        String sUuid = info.getUuid();
        String sName = info.getName();
        String sThumbnailBinary = info.getThumbnailBinary();
        String sTable = this.getResourceTableName();
        String sDataTable = this.getResourceDataTableName();
        long id = doesRecordExist(sTable, sUuid);

        //modified by Esri Italy
        sXml = modifyXml(sXml);

        try {
            ManagedConnection mc = returnConnection();
            con = mc.getJdbcConnection();
            autoCommit = con.getAutoCommit();
            con.setAutoCommit(false);
            boolean isInsert = false;
            if (id < 0) {
                isInsert = true;
                // insert a record
                StringBuffer sql = new StringBuffer();
                sql.append("INSERT INTO ").append(sTable);
                sql.append(" (");
                sql.append("DOCUUID,");
                sql.append("TITLE,");
                sql.append("OWNER");
                sql.append(")");
                sql.append(" VALUES(?,?,?)");

                logExpression(sql.toString());

                st = con.prepareStatement(sql.toString());
                int n = 1;
                st.setString(n++, sUuid);
                st.setString(n++, sName);
                st.setInt(n++, this.publisher.getLocalID());
                nRows = st.executeUpdate();

                closeStatement(st);

                if (nRows > 0) {
                    if (getIsDbCaseSensitive(this.getRequestContext())) {
                        st = con.prepareStatement("SELECT id FROM " + sTable + " WHERE UPPER(docuuid)=?");
                    } else {
                        st = con.prepareStatement("SELECT id FROM " + sTable + " WHERE docuuid=?");
                    }
                    st.setString(1, sUuid.toUpperCase());
                    rs = st.executeQuery();
                    rs.next();
                    id = rs.getLong(1);
                    closeStatement(st);

                    request.setActionStatus(ImsRequest.ACTION_STATUS_OK);

                    sql = new StringBuffer();
                    sql.append("INSERT INTO ").append(sDataTable);
                    sql.append(" (DOCUUID,ID,XML)");
                    sql.append(" VALUES(?,?,?)");

                    logExpression(sql.toString());
                    st = con.prepareStatement(sql.toString());
                    st.setString(1, sUuid);
                    st.setLong(2, id);
                    st.setString(3, sXml);
                    st.executeUpdate();
                }
                /*ESRI ITALIA 14/03/2017 gestione del flag per la sovrascrittura del metadato*/
            } else if (info.getCanReplace()) {
                /*ESRI ITALIA 14/03/2017 gestione del flag per la sovrascrittura del metadato*/
                // update a record
                this.authorize(request, sUuid);
                StringBuffer sql = new StringBuffer();
                sql.append("UPDATE ").append(sTable);
                sql.append(" SET ");
                if (!request.getLockTitle()) {
                    // update title only if it's allowed to (occurs only during synchronization)
                    sql.append("TITLE=?, ");
                }
                sql.append("OWNER=?, ");
                sql.append("UPDATEDATE=?");
                sql.append(" WHERE DOCUUID=?");
                logExpression(sql.toString());

                st = con.prepareStatement(sql.toString());
                int n = 1;
                if (!request.getLockTitle()) {
                    // update title only if it's allowed to (occurs only during synchronization)
                    st.setString(n++, sName);
                }
                st.setInt(n++, this.publisher.getLocalID());
                st.setTimestamp(n++, new Timestamp(System.currentTimeMillis()));
                st.setString(n++, sUuid);
                nRows = st.executeUpdate();
                if (nRows > 0) {
                    request.setActionStatus(ImsRequest.ACTION_STATUS_REPLACED);
                }

                closeStatement(st);

                sql = new StringBuffer();
                if (doesRecordExist(sDataTable, sUuid) >= 0) {
                    sql.append("UPDATE ").append(sDataTable);
                    sql.append(" SET DOCUUID=?, XML=?, THUMBNAIL=?");
                    sql.append(" WHERE ID=?");
                } else {
                    sql.append("INSERT INTO ").append(sDataTable);
                    sql.append(" (DOCUUID, XML,THUMBNAIL,ID)");
                    sql.append(" VALUES(?,?,?,?)");
                }

                logExpression(sql.toString());
                st = con.prepareStatement(sql.toString());
                st.setString(1, sUuid);
                st.setString(2, sXml);
                st.setBytes(3, null);
                st.setLong(4, id);
                st.executeUpdate();
            } else {
                /*ESRI ITALIA 14/03/2017 gestione del flag per la sovrascrittura del metadato*/
                request.setActionStatus(ImsRequest.ACTION_STATUS_NONE_EXIST);
                /*ESRI ITALIA 14/03/2017 gestione del flag per la sovrascrittura del metadato*/
            }

            con.commit();
            try {
                StringAttributeMap params = this.getRequestContext().getCatalogConfiguration().getParameters();
                if (params.containsKey("catalog.compileStatisticOnImport")) {
                    String functionOutput = params.getValue("catalog.compileStatisticOnImport").toString();
                    if (functionOutput.equalsIgnoreCase("true")) {
                        insertStat(sUuid, isInsert, sXml, "");
                    }
                }

            } catch (Exception e) {
                LOGGER.severe("Fallito inserimento statistiche");//added by Esri Italy
            }
        } catch (ImsServiceException ex) {
            if (con != null) {
                con.rollback();
            }
            throw ex;
        } catch (SQLException ex) {
            if (con != null) {
                con.rollback();
            }
            throw ex;
        } finally {
            closeResultSet(rs);
            closeStatement(st);
            if (con != null) {
                con.setAutoCommit(autoCommit);
            }
        }

        // thumbnail binary
        if ((sThumbnailBinary != null) && (sThumbnailBinary.length() > 0)) {
            this.updateThumbnail(sThumbnailBinary, sUuid);
        }

        return nRows;
    }

    private long getIdFromTable(String tableName)
            throws SQLException {
        Connection con = null;
        boolean autoCommit = true;
        PreparedStatement st = null;
        ResultSet rs = null;
        long id = 0;
        LOGGER.finest("Max ID table:" + tableName);//added by Esri Italy
        // initialize
        try {
            ManagedConnection mc = returnConnection();
            con = mc.getJdbcConnection();
            autoCommit = con.getAutoCommit();
            con.setAutoCommit(false);
            st = con.prepareStatement("SELECT coalesce(max(ID),0) FROM " + tableName);
            rs = st.executeQuery();
            rs.next();
            id = rs.getLong(1);
            closeStatement(st);
        } catch (SQLException ex) {
            throw ex;
        } finally {
            closeResultSet(rs);
            closeStatement(st);
        }
        return id;
    }
    /*
     Procedura per l'inserimento o l'aggiornamento dei dati statistici
  
     */

    private class jsonMetadata {

        public String Hier = "";
        public String Resp = "";
        public List<String> elencoTopic = new ArrayList<String>();
        public List<String> elencoServiceType = new ArrayList<String>();
        public List<String> elencoTemiInspire = new ArrayList<String>();
        public List<String> elencoTassonomiaISO = new ArrayList<String>(); 
        public List<String> elencoPriorityDataset = new ArrayList<String>();
        public List<String> elencoOpenData = new ArrayList<String>();
    }
   

    public class NamespaceResolver implements NamespaceContext {

        //Store the source document to search the namespaces

        private Document sourceDocument;

        public NamespaceResolver(Document document) {
            sourceDocument = document;
        }

        //The lookup for the namespace uris is delegated to the stored document.
        public String getNamespaceURI(String prefix) {
            if (prefix.equals(XMLConstants.DEFAULT_NS_PREFIX)) {
                return sourceDocument.lookupNamespaceURI(null);
            } else {
                return sourceDocument.lookupNamespaceURI(prefix);
            }
        }

        public String getPrefix(String namespaceURI) {
            return sourceDocument.lookupPrefix(namespaceURI);
        }

        @SuppressWarnings("rawtypes")
        public Iterator getPrefixes(String namespaceURI) {
            return null;
        }
    }

    private jsonMetadata extactData(String sXml) {
        jsonMetadata retJson = new jsonMetadata();
        List<String> lstISO = new ArrayList<String>();
        lstISO.add("humanInteractionService");
        lstISO.add("humanCatalogueViewer");
        lstISO.add("humanGeographicViewer");
        lstISO.add("humanGeographicSpreadsheetViewer");
        lstISO.add("humanServiceEditor");
        lstISO.add("humanChainDefinitionEditor");
        lstISO.add("humanWorkflowEnactmentManager");
        lstISO.add("humanGeographicFeatureEditor");
        lstISO.add("humanGeographicSymbolEditor");
        lstISO.add("humanFeatureGeneralizationEditor");
        lstISO.add("humanGeographicDataStructureViewer");
        lstISO.add("infoManagementService");
        lstISO.add("infoFeatureAccessService");
        lstISO.add("infoMapAccessService");
        lstISO.add("infoCoverageAccessService");
        lstISO.add("infoSensorDescriptionService");
        lstISO.add("infoProductAccessService");
        lstISO.add("infoFeatureTypeService");
        lstISO.add("infoCatalogueService");
        lstISO.add("infoRegistryService");
        lstISO.add("infoGazetteerService");
        lstISO.add("infoOrderHandlingService");
        lstISO.add("infoStandingOrderService");
        lstISO.add("taskManagementService");
        lstISO.add("chainDefinitionService");
        lstISO.add("workflowEnactmentService");
        lstISO.add("subscriptionService");
        lstISO.add("spatialProcessingService");
        lstISO.add("spatialCoordinateConversionService");
        lstISO.add("spatialCoordinateTransformationService");
        lstISO.add("spatialCoverageVectorConversionService");
        lstISO.add("spatialImageCoordinateConversionService");
        lstISO.add("spatialRectificationService");
        lstISO.add("spatialOrthorectificationService");
        lstISO.add("spatialSensorGeometryModelAdjustmentService");
        lstISO.add("spatialImageGeometryModelConversionService");
        lstISO.add("spatialSubsettingService");
        lstISO.add("spatialSamplingService");
        lstISO.add("spatialTilingChangeService");
        lstISO.add("spatialDimensionMeasurementService");
        lstISO.add("spatialFeatureManipulationService");
        lstISO.add("spatialFeatureMatchingService");
        lstISO.add("spatialFeatureGeneralizationService");
        lstISO.add("spatialRouteDeterminationService");
        lstISO.add("spatialPositioningService");
        lstISO.add("spatialProximityAnalysisService");
        lstISO.add("thematicProcessingService");
        lstISO.add("thematicGoparameterCalculationServicethematicGoparameterCalculationService");
        lstISO.add("thematicClassificationService");
        lstISO.add("thematicFeatureGeneralizationService");
        lstISO.add("thematicSubsettingService");
        lstISO.add("thematicSpatialCountingService");
        lstISO.add("thematicChangeDetectionService");
        lstISO.add("thematicGeographicInformationExtractionService");
        lstISO.add("thematicImageProcessingService");
        lstISO.add("thematicReducedResolutionGenerationService");
        lstISO.add("thematicImageManipulationService");
        lstISO.add("thematicImageUnderstandingService");
        lstISO.add("thematicImageSynthesisService");
        lstISO.add("thematicMultibandImageManipulationService");
        lstISO.add("thematicObjectDetectionService");
        lstISO.add("thematicGeoparsingService");
        lstISO.add("thematicGeocodingService");
        lstISO.add("temporalProcessingService");
        lstISO.add("temporalReferenceSystemTransformationService");
        lstISO.add("temporalSubsettingService");
        lstISO.add("temporalSamplingService");
        lstISO.add("temporalProximityAnalysisService");
        lstISO.add("metadataProcessingService");
        lstISO.add("metadataStatisticalCalculationService");
        lstISO.add("metadataGeographicAnnotationService");
        lstISO.add("comService");
        lstISO.add("comEncodingService");
        lstISO.add("comTransferService");
        lstISO.add("comGeographicCompressionService");
        lstISO.add("comGeographicFormatConversionService");
        lstISO.add("comMessagingService");
        lstISO.add("comRemoteFileAndExecutableManagement");

        try {
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            factory.setNamespaceAware(true);
            DocumentBuilder builder = factory.newDocumentBuilder();
            InputSource is = new InputSource(new StringReader(sXml));
            Document document = builder.parse(is);
         
            XPathFactory xpathfactory = XPathFactory.newInstance();
            XPath xpath = xpathfactory.newXPath();
            xpath.setNamespaceContext(new NamespaceResolver(document));

            String strInserito = "";
            // Tipo metadato. Modifica: eliminati i namespaces
//            XPathExpression expr = xpath.compile("/gmd:MD_Metadata/gmd:hierarchyLevel/gmd:MD_ScopeCode");
            XPathExpression expr = xpath.compile("/*[local-name() = 'MD_Metadata']/*[local-name() = 'hierarchyLevel']/*[local-name() = 'MD_ScopeCode']");

            NodeList nodeList = (NodeList) expr.evaluate(document, XPathConstants.NODESET);
            if (nodeList.getLength() > 0) {
                
                String strAscii = nodeList.item(0).getTextContent().trim();
                // Inserisco solo se la stringa è ascii e non vuota
                if (this.isPrintable(strAscii) && strAscii.length() > 0)
                    retJson.Hier = strAscii;
            }

            //Responsabile prendo solo il primo. Modifica: eliminati i namespaces
//            expr = xpath.compile("/gmd:MD_Metadata/gmd:identificationInfo/*/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString");
            expr = xpath.compile("/*[local-name() = 'MD_Metadata']/*[local-name() = 'identificationInfo']/*/*[local-name() = 'citation']/*[local-name() = 'CI_Citation']/*[local-name() = 'citedResponsibleParty']/*[local-name() = 'CI_ResponsibleParty']/*[local-name() = 'organisationName']/*[local-name() = 'CharacterString']");

            nodeList = (NodeList) expr.evaluate(document, XPathConstants.NODESET);
            if (nodeList.getLength() > 0) {
                
                String strAscii = nodeList.item(0).getTextContent().trim();
                // Inserisco solo se la stringa è printable e non vuota
                if (this.isPrintable(strAscii) && strAscii.length() > 0)
                    retJson.Resp= strAscii;
            }

            //Topic. Modifica: eliminati i namespaces
//            expr = xpath.compile("/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:topicCategory/gmd:MD_TopicCategoryCode");
            expr = xpath.compile("/*[local-name()='MD_Metadata']/*[local-name()='identificationInfo']/*[local-name()='MD_DataIdentification']/*[local-name()='topicCategory']/*[local-name()='MD_TopicCategoryCode']");
			
            nodeList = (NodeList) expr.evaluate(document, XPathConstants.NODESET);
            for (int i = 0; i < nodeList.getLength(); i++) {
                String strAscii = nodeList.item(i).getTextContent().trim();
                // Inserisco solo se la stringa è printable e non vuota
                if (this.isPrintable(strAscii) && strAscii.length() > 0)
                    retJson.elencoTopic.add(strAscii);
            }
			
            //Service Type Modifica: eliminati i namespaces
//            expr = xpath.compile("/gmd:MD_Metadata/gmd:identificationInfo/srv:SV_ServiceIdentification/srv:serviceType/gco:LocalName");
            expr = xpath.compile("/*[local-name()='MD_Metadata']/*[local-name()='identificationInfo']/*[local-name()='SV_ServiceIdentification']/*[local-name()='serviceType']/*[local-name() = 'LocalName']");

            nodeList = (NodeList) expr.evaluate(document, XPathConstants.NODESET);
            for (int i = 0; i < nodeList.getLength(); i++) {
                
                String strAscii = nodeList.item(i).getTextContent().trim();
                // Inserisco solo se la stringa è printable e non vuota
                if (this.isPrintable(strAscii) && strAscii.length() > 0)
                    retJson.elencoServiceType.add(strAscii);
            }
			
            //Tassonomia servizi INSPIRE/ISO Modifica: eliminati i namespaces
//            expr = xpath.compile("/gmd:MD_Metadata/gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:descriptiveKeywords[count(gmd:MD_Keywords/gmd:thesaurusName) = 0]/gmd:MD_Keywords/gmd:keyword/gco:CharacterString");
            expr = xpath.compile("/*[local-name()='MD_Metadata']/*[local-name()='identificationInfo']/*[local-name()='SV_ServiceIdentification']/*[local-name()='descriptiveKeywords'][count(*[local-name()='MD_Keywords']/*[local-name()='thesaurusName']) = 0]/*[local-name()='MD_Keywords']/*[local-name()='keyword']/*[local-name() = 'CharacterString']");
 
            nodeList = (NodeList) expr.evaluate(document, XPathConstants.NODESET);
            strInserito = "";
            for (int i = 0; i < nodeList.getLength(); i++) {
                
                String strAscii = nodeList.item(i).getTextContent().trim();

                // Inserisco solo se la stringa è printable e non vuota
                if (this.isPrintable(strAscii) && strAscii.length() > 0){
                    // E poi inserisco solo se c'è nella list Iso e non è già stata inserita
                    if (lstISO.contains(strAscii) && !strInserito.contains("'"+strAscii+"'")) {
                        retJson.elencoTassonomiaISO.add(strAscii);
                        strInserito = strInserito + "'"+strAscii+"'";
                    }         
                }      
            }
            
            //Priority dataset Modifica: eliminati i namespaces
            //lista chiavi priorityDataset 
            List<String> aria = new ArrayList<String>();
            aria.add("Directive 2008/50/EC");
            aria.add("Management zones and agglomerations (Air Quality Directive)");
            aria.add("Agglomerations (Air Quality Directive)");
            aria.add("Management zones (Air Quality Directive)");
            aria.add("Model areas (Air Quality Directive)");
            aria.add("Monitoring stations (Air Quality Directive)");
            aria.add("Measurement and modelling data (Air Quality Directive)");
            aria.add("Directive 2002/49/EC");
            aria.add("Major roads, railways and air transport network (Noise Directive)");
            aria.add("Major roads (Noise Directive)");
            aria.add("Major roads, railways and air transport network (Noise Directive)");
            aria.add("Major railways (Noise Directive)");
            aria.add("Major roads, railways and air transport network (Noise Directive)");
            aria.add("Major air transport (Noise Directive)");
            aria.add("Agglomerations (Noise Directive)");
            aria.add("Population (Noise Directive)");
            aria.add("Environmental noise exposure (Noise Directive)");
            aria.add("Population - densely populated built-up areas (Noise Directive)");
            aria.add("Major roads noise exposure delineation (Noise Directive)");
            aria.add("Major railways noise exposure delineation (Noise Directive)");
            aria.add("Agglomerations - roads noise exposure delineation (Noise Directive)");
            aria.add("Agglomerations - railways noise exposure delineation (Noise Directive)");
            aria.add("Agglomerations - aircraft noise exposure delineation (Noise Directive)");
            aria.add("Agglomerations - industrial noise exposure delineation (Noise Directive)");
            aria.add("Agglomerations - noise exposure delineation (Noise Directive)");
            aria.add("Major roads noise exposure delineation day-evening-night (Noise Directive)");
            aria.add("Major roads noise exposure delineation - night (Noise Directive)");
            aria.add("Major railways noise exposure delineation day-evening-night (Noise Directive)");
            aria.add("Major railways noise exposure delineation - night (Noise Directive)");
            aria.add("Major airports noise exposure delineation day-evening-night (Noise Directive)");
            aria.add("Major airports noise exposure delineation - night (Noise Directive)");
            aria.add("Agglomerations - roads noise exposure delineation day-evening-night (Noise Directive)");
            aria.add("Agglomerations - roads noise exposure delineation - night (Noise Directive)");
            aria.add("Agglomerations - railways noise exposure delineation day-evening-night (Noise Directive)");
            aria.add("Agglomerations - railways noise exposure delineation - night (Noise Directive)");
            aria.add("Agglomerations - aircraft noise exposure delineation day-evening-night (Noise Directive)");
            aria.add("Agglomerations - aircraft noise exposure delineation - night (Noise Directive)");
            aria.add("Agglomerations - industrial noise exposure delineation day-evening-night (Noise Directive)");
            aria.add("Agglomerations - industrial noise exposure delineation - night (Noise Directive)");
            aria.add("Agglomerations - noise exposure delineation day-evening-night (Noise Directive)");
            aria.add("Agglomerations - noise exposure delineation - night (Noise Directive)");
            
            List<String> industria = new ArrayList<String>();
            industria.add("Regulation (EC) 166/2006");
            industria.add("Industrial sites - EU Registry (European Pollutant Release and Transfer Register)");
            industria.add("Sites and facilities (European Pollutant Release and Transfer Register)");
            industria.add("Actual pollutant releases (European Pollutant Release and Transfer Register)");
            industria.add("Directive 2010/75/EU");
            industria.add("Industrial sites - EU Registry (Industrial Emissions Directive)");
            industria.add("Installations (Industrial Emissions Directive)");
            industria.add("Directive 2010/75/EU");
            industria.add("Industrial sites - EU Registry (Industrial Emissions Directive)");
            industria.add("Large combustion plants (Industrial Emissions Directive)");
            industria.add("Directive 2010/75/EU");
            industria.add("Emissions (Industrial Emissions Directive)");
            industria.add("Recommendation 2014/70/EU");
            industria.add("Boreholes (Recommendation on hydraulic fracturing)");
            industria.add("Boreholes for hydraulic fracturing (Recommendation on hydraulic fracturing)");
            industria.add("Directive 2012/18/EU");
            industria.add("Establishments  involving dangerous substances (SEVESO III Directive)");

            List<String> rifiuti = new ArrayList<String>();
            rifiuti.add("Directive 1999/31/EC");
            rifiuti.add("Exempted islands and isolated settlements (Landfill of Waste Directive)");
            rifiuti.add("Landfill of waste sites (Landfill of Waste Directive)");
            rifiuti.add("Directive 2006/21/EC");
            rifiuti.add("Facilities for managing extractive waste (Extractive Waste Directive)");
            rifiuti.add("Agricultural facilities receiving sludge (Sewage Sludge Directive)");
            rifiuti.add("Directive 86/278/EEC");
            rifiuti.add("Agricultural sites where sludge is deposited (Sewage Sludge Directive)");
            rifiuti.add("Regulation (EU) 2017/852");
            rifiuti.add("Mercury storage facilities (Mercury Regulation)");

            List<String> natura = new ArrayList<String>();			   
            natura.add("Directive 92/43/EEC");
            natura.add("National legislation");
            natura.add("Directive 92/43/EEC");
            natura.add("Directive 2009/147/EC");
            natura.add("Regulation (EU) 1143/2014");
            natura.add("EEA Annual Work Programme");
            natura.add("Pan-European biogeographical regions (Habitats Directive)");
            natura.add("National biogeographical regions");
            natura.add("Habitat types and species distribution and range (Habitats Directive)");
            natura.add("Natura 2000 sites (Habitats Directive)");
            natura.add("Pan-European biogeographical regions (Birds Directive)");
            natura.add("National biogeographical regions");
            natura.add("Bird species distribution and range (Birds Directive)");
            natura.add("Natura 2000 sites (Birds Directive)");
            natura.add("Invasive alien species distribution (Invasive Alien Species Directive)");
            natura.add("Nationally designated areas - CDDA");
            natura.add("National biogeographical regions (Habitats Directive)");
            natura.add("Habitat types distribution (Habitats Directive)");
            natura.add("Habitat types range (Habitats Directive)");
            natura.add("Species distribution (Habitats Directive)");
            natura.add("Species range (Habitats Directive)");
            natura.add("National biogeographical regions (Birds Directive)");
            natura.add("Bird species distribution (Birds Directive)");
            natura.add("Birds range (Birds Directive)");
            natura.add("Habitat types distribution - sensitive (Habitats Directive)");
            natura.add("Species distribution sensitive (Habitats Directive)");
            natura.add("Bird species distribution - sensitive (Birds Directive)");
            natura.add("Birds range - sensitive (Birds Directive)");

            List<String> acqua = new ArrayList<String>();	
            acqua.add("Directive 98/83/EC");
            acqua.add("Directive 2006/7/EC");
            acqua.add("Directive 91/271/EEC");
            acqua.add("Drinking water supply zones (Drinking Water Directive)");
            acqua.add("Drinking water abstraction points (Drinking Water Directive)");
            acqua.add("Bathing water sites  (Bathing Water Directive)");
            acqua.add("Agglomerations (Urban Waste Water Treatment Directive)");
            acqua.add("Urban waste-water treatment plants (Urban Waste Water Treatment Directive)");
            acqua.add("Discharge points to receiving waters (Urban Waste Water Treatment Directive)");
            acqua.add("Sensitive areas, less sensitive areas and catchments (Urban Waste-Water Treatment Directive)");
            acqua.add("Monitoring stations (Nitrates Directive)");
            acqua.add("Nitrates vulnerable zones (Nitrates Directive)");
            acqua.add("Large water supply zones (Drinking Water Directive)");
            acqua.add("Small water supply zones (Drinking Water Directive)");
            acqua.add("Sensitive areas (Urban Waste-Water Treatment Directive)");
            acqua.add("Less sensitive areas (Urban Waste-Water Treatment Directive)");
            acqua.add("Sensitive area catchments (Urban Waste-Water Treatment Directive)");
            acqua.add("Directive 2000/60/EC");
            acqua.add("Directive 2007/60/EC");
            acqua.add("River basin districts (Water Framework Directive)");
            acqua.add("River basin districts sub-units (Water Framework Directive)");
            acqua.add("Water bodies (Water Framework Directive)");
            acqua.add("Protected areas (Water Framework Directive)");
            acqua.add("Monitoring stations (Water Framework Directive)");
            acqua.add("Areas of Potential significant flood risk (Floods Directive)");
            acqua.add("Preliminary flood risk assessment (Floods Directive)");
            acqua.add("Flooded areas (Floods Directive)");
            acqua.add("Flood risk zones (Floods Directive)");
            acqua.add("Management units (Floods Directive)");
            acqua.add("Surface water bodies (Water Framework Directive)");
            acqua.add("Groundwater bodies (Water Framework Directive)");
            acqua.add("Nitrate vulnerable zones - nutrient sensitive areas (Water Framework Directive)");
            acqua.add("Urban waste water sensitive areas - nutrient sensitive areas (Water Framework Directive)");
            acqua.add("Bathing waters - recreational waters (Water Framework Directive)");
            acqua.add("Drinking water protection areas (Water Framework Directive)");
            acqua.add("Water dependent Natura 2000 sites (Water Framework Directive)");
            acqua.add("Designated waters (Water Framework Directive)");
            acqua.add("Preliminary flood risk assessment - observed events (Floods Directive)");
            acqua.add("Preliminary flood risk assessment - potential future events (Floods Directive)");
            acqua.add("Flood hazard areas low probability scenario (Floods Directive)");
            acqua.add("Flood hazard areas medium probability scenario (Floods Directive)");
            acqua.add("Flood hazard areas high probability scenario (Floods Directive)");
            acqua.add("Flood risk zones low probability scenario (Floods Directive)");
            acqua.add("Flood risk zones medium probability scenario (Floods Directive)");
            acqua.add("Flood risk zones high probability scenario (Floods Directive)");
            acqua.add("Lakes (Water Framework Directive)");
            acqua.add("Rivers (Water Framework Directive)");
            acqua.add("Transitional waters (Water Framework Directive)");
            acqua.add("Coastal waters (Water Framework Directive)");
            acqua.add("Protection of economically significant aquatic species - shellfish designated waters (Water Framework Directive)");
            acqua.add("Protection of economically significant aquatic species - freshwater fish designated waters (Water Framework Directive)");
            acqua.add("Other protected areas (Water Framework Directive)");

            List<String> marina = new ArrayList<String>();	
            marina.add("Directive 2008/56/EC");
            marina.add("Marine regions and units (Marine Strategy Framework Directive)");
            marina.add("Marine assessment units (Marine Strategy Framework Directive)");
            marina.add("Marine regions (Marine Strategy Framework Directive)");
            marina.add("Marine reporting units (Marine Strategy Framework Directive)");
            marina.add("Marine sub-regions (Marine Strategy Framework Directive)");

//            expr = xpath.compile("/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword/*/text()");
            expr = xpath.compile("/*[local-name()='MD_Metadata']/*[local-name()='identificationInfo']/*[local-name()='MD_DataIdentification']/*[local-name()='descriptiveKeywords']/*[local-name()='MD_Keywords']/*[local-name()='keyword']/*/text()");


            nodeList = (NodeList) expr.evaluate(document, XPathConstants.NODESET);
            strInserito = "";
            for (int i = 0; i < nodeList.getLength(); i++) {
                String strAscii = nodeList.item(i).getTextContent().trim();
                // Inserisco solo se la stringa è printable e non vuota
                if (this.isPrintable(strAscii) && strAscii.length() > 0){
                    // E poi inserisco solo se non è già stata inserita e c'è in una delle liste
                    if (aria.contains(strAscii) && !strInserito.contains("'aria'")) {
                        retJson.elencoPriorityDataset.add("Aria e rumore");
                        strInserito = strInserito + "'aria'";
                    }
                    else if (industria.contains(strAscii) && !strInserito.contains("'industria'")) {
                        retJson.elencoPriorityDataset.add("Industria");
                        strInserito = strInserito + "'industria'";
                    }
                    else if (rifiuti.contains(strAscii) && !strInserito.contains("'rifiuti'")) {
                        retJson.elencoPriorityDataset.add("Rifiuti");
                        strInserito = strInserito + "'rifiuti'";
                    }
                    else if (natura.contains(strAscii) && !strInserito.contains("'natura'")) {
                        retJson.elencoPriorityDataset.add("Natura e biodiversità");
                        strInserito = strInserito + "'natura'";
                    }
                    else if (acqua.contains(strAscii) && !strInserito.contains("'acqua'")) {
                        retJson.elencoPriorityDataset.add("Acqua"); 
                        strInserito = strInserito + "'acqua'";
                    }
                    else if (marina.contains(strAscii) && !strInserito.contains("'marina'")) {
                        retJson.elencoPriorityDataset.add("Marina");
                        strInserito = strInserito + "'marina'";
                    }
                }
            }
            
            // OpenData - INIZIO -----
            //Lista chiavi opendata Modifica eliminati i namespace
            List<String> agricoltura = new ArrayList<String>();
            agricoltura.add("Impianti agricoli e di acquacoltura");
            agricoltura.add("Agricultural and aquaculture facilities");
            
            List<String> ambiente = new ArrayList<String>();
            ambiente.add("Condizioni atmosferiche");
            ambiente.add("Copertura del suolo");
            ambiente.add("Distribuzione delle specie");
            ambiente.add("Elementi geografici meteorologici");
            ambiente.add("Elementi geografici oceanografici");
            ambiente.add("Habitat e biotopi");
            ambiente.add("Idrografia");
            ambiente.add("Impianti di monitoraggio ambientale");
            ambiente.add("Regioni biogeografiche");
            ambiente.add("Regioni marine");
            ambiente.add("Risorse minerarie");
            ambiente.add("Siti protetti");
            ambiente.add("Suolo");
            ambiente.add("Utilizzo del territorio");
            ambiente.add("Zone a rischio naturale");
            ambiente.add("Zone sottoposte a gestione/limitazioni/regolamentazione e unità con obbligo di comunicare dati");
            ambiente.add("Atmospheric conditions");
            ambiente.add("Land cover");
            ambiente.add("Species distribution");
            ambiente.add("Meteorological geographical features");
            ambiente.add("Oceanographic geographical features");
            ambiente.add("Habitats and biotopes");
            ambiente.add("Hydrography");
            ambiente.add("Environmental monitoring facilities");
            ambiente.add("Bio-geographical regions");
            ambiente.add("Sea regions");
            ambiente.add("Mineral resources");
            ambiente.add("Protected sites");
            ambiente.add("Soil");
            ambiente.add("Land use");
            ambiente.add("Natural risk zones");
            ambiente.add("Area management/restriction/regulation zones and reporting units");
            
            List<String> economia = new ArrayList<String>();
            economia.add("Parcelle catastali");
            economia.add("Produzione e impianti industriali");
            economia.add("Risorse minerarie");
            economia.add("Utilizzo del territorio");
            economia.add("Cadastral parcels");
            economia.add("Production and industrial facilities");
            economia.add("Mineral resources");
            economia.add("Land use");
            
            List<String> governo = new ArrayList<String>();
            governo.add("Servizi di pubblica utilità e servizi amministrativi");
            governo.add("Unità amministrative");
            governo.add("Utility and governmental services");
            governo.add("Administrative units"); 
            
            List<String> popolazione = new ArrayList<String>();
            popolazione.add("Distribuzione della popolazione — demografia");
            popolazione.add("Unità statistiche");
            popolazione.add("Population distribution - demography");
            popolazione.add("Statistical units");
            
            List<String> regioni = new ArrayList<String>();
            regioni.add("Edifici");
            regioni.add("Elevazione");
            regioni.add("Geologia");
            regioni.add("Indirizzi");
            regioni.add("Nomi geografici");
            regioni.add("Ortoimmagini");
            regioni.add("Parcelle catastali");
            regioni.add("Sistemi di coordinate");
            regioni.add("Sistemi di griglie geografiche");
            regioni.add("Buildings");
            regioni.add("Elevation");
            regioni.add("Geology");
            regioni.add("Addresses");
            regioni.add("Geographical names");
            regioni.add("Orthoimagery");
            regioni.add("Cadastral parcels");
            regioni.add("Coordinate reference systems");
            regioni.add("Geographical grid systems");
            
            List<String> salute = new ArrayList<String>();     
            salute.add("Salute umana e sicurezza");
            salute.add("Human health and safety");    
            
            List<String> scienza = new ArrayList<String>();    
            scienza.add("Elementi geografici meteorologici");
            scienza.add("Geologia");
            scienza.add("Idrografia");
            scienza.add("Ortoimmagini");
            scienza.add("Meteorological geographical features");
            scienza.add("Geology");
            scienza.add("Hydrography");
            scienza.add("Orthoimagery");
            
            List<String> trasporti = new ArrayList<String>();    
            trasporti.add("Reti di trasporto");
            trasporti.add("Transport networks");

            // Prima verifico se è Opendata: se contiene la licenza giusta in useLimitation oppure alcune stringhe in keywords
            // Verifico useLimitation
            boolean isOpenData = false;        
//            expr = xpath.compile("/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/gmd:MD_Constraints/gmd:useLimitation/gco:CharacterString/text()");
            expr = xpath.compile("/*[local-name()='MD_Metadata']/*[local-name()='identificationInfo']/*[local-name()='MD_DataIdentification']/*[local-name()='resourceConstraints']/*[local-name()='MD_Constraints']/*[local-name()='useLimitation']/*[local-name() = 'CharacterString' ]/text()");

            nodeList = (NodeList) expr.evaluate(document, XPathConstants.NODESET);
            for (int i = 0; (i < nodeList.getLength()) && (!isOpenData); i++) {
                String strAscii = nodeList.item(i).getTextContent().trim();
                if (    (strAscii.indexOf("CC-BY")>=0) || 
                        (strAscii.indexOf("CCBY")>=0) ||
                        (strAscii.indexOf("BY SA")>=0) ||
                        (strAscii.indexOf("IODL")>=0) ||
                        (strAscii.indexOf("Italian Open Data")>=0) ||
                        (strAscii.indexOf("Creative Commons BY")>=0) ||
                        (strAscii.indexOf("Open Data")>=0) ||
                        (strAscii.indexOf("CC BY")>=0) ||
                        (strAscii.indexOf("citazione della fonte")>=0)        )
                    isOpenData = true;
            }
            // Se non ho trovato nulla verifico se ci sono specifiche parole chiave in keywords
            if (!isOpenData){
//                expr = xpath.compile("/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword/*/text()");
                expr = xpath.compile("/*[local-name()='MD_Metadata']/*[local-name()='identificationInfo']/*[local-name()='MD_DataIdentification']/*[local-name()='descriptiveKeywords']/*[local-name()='MD_Keywords']/*[local-name()='keyword']/*/text()");

                nodeList = (NodeList) expr.evaluate(document, XPathConstants.NODESET);

                for (int i = 0; (i < nodeList.getLength()) && (!isOpenData); i++) {
                    String strAscii = nodeList.item(i).getTextContent().trim().toLowerCase();
                    if (    (strAscii.indexOf("opendata")>=0) || 
                            (strAscii.indexOf("open data")>=0)   )
                        isOpenData = true;
                }
            }

            // Se è Open Data allora prendo le sole keyword dei temi INSPIRE
            if (isOpenData) {
//                expr = xpath.compile("/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords[gmd:thesaurusName/gmd:CI_Citation/gmd:title/*/text() = 'GEMET - INSPIRE themes, version 1.0']/gmd:keyword/*/text()");
                expr = xpath.compile("/*[local-name()='MD_Metadata']/*[local-name()='identificationInfo']/*[local-name()='MD_DataIdentification']/*[local-name()='descriptiveKeywords']/*[local-name()='MD_Keywords'][*[local-name()='thesaurusName']/*[local-name()='CI_Citation']/*[local-name()='title']/*/text() = 'GEMET - INSPIRE themes, version 1.0']/*[local-name()='keyword']/*/text()");

                nodeList = (NodeList) expr.evaluate(document, XPathConstants.NODESET);
                strInserito = "";
                for (int i = 0; i < nodeList.getLength(); i++) {
                    String strAscii = nodeList.item(i).getTextContent().trim();

                    // Inserisco solo se la stringa è printable e non vuota
                    if (this.isPrintable(strAscii) && strAscii.length() > 0){
                    // E poi inserisco solo se non è già stata inserita e c'è in una delle liste
                        if (agricoltura.contains(strAscii) && !strInserito.contains("'agricoltura'")) {
                            retJson.elencoOpenData.add("Agricoltura, pesca, silvicoltura e prodotti alimentari");
                            strInserito = strInserito + "'agricoltura'";
                        }
                        else if (ambiente.contains(strAscii) && !strInserito.contains("'ambiente'")) {
                            retJson.elencoOpenData.add("Ambiente");
                            strInserito = strInserito + "'ambiente'";
                        }
                        else if (economia.contains(strAscii) && !strInserito.contains("'economia'")) {
                            retJson.elencoOpenData.add("Economia");
                            strInserito = strInserito + "'economia'";
                        }
                        else if (governo.contains(strAscii) && !strInserito.contains("'governo'")) {
                            retJson.elencoOpenData.add("Governo e settore pubblico");
                            strInserito = strInserito + "'governo'";
                        }
                        else if (popolazione.contains(strAscii) && !strInserito.contains("'popolazione'")) {
                            retJson.elencoOpenData.add("Popolazione e società");
                            strInserito = strInserito + "'popolazione'";
                        }
                        else if (regioni.contains(strAscii) && !strInserito.contains("'regioni'")) {
                            retJson.elencoOpenData.add("Regioni e città");
                            strInserito = strInserito + "'regioni'";
                        }
                        else if (salute.contains(strAscii) && !strInserito.contains("'salute'")) {
                            retJson.elencoOpenData.add("Salute");
                            strInserito = strInserito + "'salute'";
                        }
                        else if (scienza.contains(strAscii) && !strInserito.contains("'scienza'")) {
                            retJson.elencoOpenData.add("Scienza e tecnologia");
                            strInserito = strInserito + "'scienza'";
                        }
                        else if (trasporti.contains(strAscii) && !strInserito.contains("'trasporti'")) {
                            retJson.elencoOpenData.add("Trasporti");
                            strInserito = strInserito + "'trasporti'";
                        }
                    }
                }
            }
            // Open Data FINE ---------------
            
            //Inspire Theme  prendo solo quello con GEMET vero Modifica tolti namespace
//            expr = xpath.compile("/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords[gmd:thesaurusName/gmd:CI_Citation/gmd:title/*/text() = 'GEMET - INSPIRE themes, version 1.0']/gmd:keyword/*/text()");
            expr = xpath.compile("/*[local-name()='MD_Metadata']/*[local-name()='identificationInfo']/*[local-name()='MD_DataIdentification']/*[local-name()='descriptiveKeywords']/*[local-name()='MD_Keywords'][*[local-name()='thesaurusName']/*[local-name()='CI_Citation']/*[local-name()='title']/*/text() = 'GEMET - INSPIRE themes, version 1.0']/*[local-name()='keyword']/*/text()");

            nodeList = (NodeList) expr.evaluate(document, XPathConstants.NODESET);
            strInserito = "";
            for (int i = 0; i < nodeList.getLength(); i++) {
                // Tolgo eventuali spazi
                String strAscii = nodeList.item(i).getTextContent().trim();

                // Inserisco solo se la stringa è "printable" (cioè ascii più le lettere accentate) e non vuota
                if (this.isPrintable(strAscii) && strAscii.length() > 0){
                    // E poi inserisco solo se non è già stata inserita e c'è in una delle liste
                    if (!strInserito.contains("'"+strAscii+"'")){
                        retJson.elencoTemiInspire.add(strAscii);
                        strInserito = strInserito + "'"+strAscii+"'";
                    }
                }
            }

        } catch (Exception e) {
            LOGGER.warning(e.getMessage());//added by Esri Italy
        }
        return retJson;
    }
    
    /** 
     * Verifica se una stringa è "stampabile" cioè se è ascii + lettere accentate (
     **/
    public static boolean isPrintable(String str) {
      if (str == null) {
          return false;
      }
      int sz = str.length();
      for (int i = 0; i < sz; i++) {
          if (isPrintable(str.charAt(i)) == false) {
              return false;
          }
      }
      return true;
  }
  
  /**
   * verifica se una stringa è ASCII o una lettera accentata italiana
   */
  public static boolean isPrintable(char ch) {
      if (ch >= 32 && ch < 127)
          return(true);
      if ( ch == 'à' || ch =='è' || ch == 'é' || ch == 'ì' || ch == 'ò' || ch == 'ù' )
        return(true);
      return(false);
  }  
    
       /** 
        * Verifica se una stringa è completamente ascii (
        **/
    public static boolean isAsciiPrintable(String str) {
      if (str == null) {
          return false;
      }
      int sz = str.length();
      for (int i = 0; i < sz; i++) {
          if (isAsciiPrintable(str.charAt(i)) == false) {
              return false;
          }
      }
      return true;
  }
  
  /**
   * <p>Checks whether the character is ASCII 7 bit printable.</p>
   *
   * <pre>
   *   CharUtils.isAsciiPrintable('a')  = true
   *   CharUtils.isAsciiPrintable('A')  = true
   *   CharUtils.isAsciiPrintable('3')  = true
   *   CharUtils.isAsciiPrintable('-')  = true
   *   CharUtils.isAsciiPrintable('\n') = false
   *   CharUtils.isAsciiPrintable('&copy;') = false
   * </pre>
   * 
   * @param ch  the character to check
   * @return true if between 32 and 126 inclusive
   */
  public static boolean isAsciiPrintable(char ch) {
      return ch >= 32 && ch < 127;
  }  
    
      
    /** 
     * insertStat
     * Inserisce i dati nelle tabelle statistiche
     * @param docUUID ID interno del documento
     * @param isInsert flag che definisce se è un inserto o un update
     * @param sXml l'XML del documento
     * @param quale la tabella su cui intervenire (stat, topic, inspire, inspireservice, service) oppure vuoto per tutte
     * @throws ImsServiceException
     * @throws SQLException 
     */
    public void insertStat(String docUUID, boolean isInsert, String sXml, String quale) throws ImsServiceException, SQLException {
        Connection con = null;
        boolean autoCommit = true;
        PreparedStatement st = null;
        ResultSet rs = null;
        LOGGER.finest("Inserimento Record");//added by Esri Italy
        // initialize
        int nRows = 0;
        String sDataTable = "gpt_resource_stat";
        try {
            ManagedConnection mc = returnConnection();
            con = mc.getJdbcConnection();
            autoCommit = con.getAutoCommit();
            con.setAutoCommit(false);
            jsonMetadata jsonData = extactData(sXml);
            StringBuffer sql = new StringBuffer();
            /** Inserimento nella tabella del tipo dato **/
            if ((quale.equalsIgnoreCase("stat")) || (quale.equals(""))) {
                if (isInsert) {

                    // insert a record
                    sql.append("INSERT INTO ").append(sDataTable);
                    sql.append(" (");
                    sql.append("DOCUUID,");
                    sql.append("ID,");
                    sql.append("HIERARCHY,");
                    sql.append("RESPONSIBLE");
                    sql.append(")");
                    sql.append(" VALUES(?,?,?,?)");

                    logExpression(sql.toString());
                    long id = getIdFromTable(sDataTable);
                    st = con.prepareStatement(sql.toString());

                    st.setString(1, docUUID);
                    st.setLong(2, id + 1);
                    st.setString(3, jsonData.Hier);
                    st.setString(4, jsonData.Resp);
                    Logger.getLogger(ImsMetadataProxyDao.class.getName()).log(Level.FINEST, "Query:" + st, (Throwable)null);
                    nRows = st.executeUpdate();
                    closeStatement(st);

                } else {
                    // insert a record
                    sql.append("UPDATE ").append(sDataTable);
                    sql.append(" SET HIERARCHY = ?,");
                    sql.append(" RESPONSIBLE = ? ");
                    sql.append(" WHERE DOCUUID = ?");
                    logExpression(sql.toString());
                    st = con.prepareStatement(sql.toString());
                    st.setString(1, jsonData.Hier);
                    st.setString(2, jsonData.Resp);
                    st.setString(3, docUUID);
                    Logger.getLogger(ImsMetadataProxyDao.class.getName()).log(Level.FINEST, "Query:" + st, (Throwable)null);
                    nRows = st.executeUpdate();
                    closeStatement(st);
                    if (nRows == 0) {
                        sql = new StringBuffer();
                        // insert a record
                        sql.append("INSERT INTO ").append(sDataTable);
                        sql.append(" (");
                        sql.append("DOCUUID,");
                        sql.append("ID,");
                        sql.append("HIERARCHY,");
                        sql.append("RESPONSIBLE");
                        sql.append(")");
                        sql.append(" VALUES(?,?,?,?)");

                        logExpression(sql.toString());
                        long id = getIdFromTable(sDataTable);
                        st = con.prepareStatement(sql.toString());
                        st.setString(1, docUUID);
                        st.setLong(2, id + 1);
                        st.setString(3, jsonData.Hier);
                        st.setString(4, jsonData.Resp);
                        Logger.getLogger(ImsMetadataProxyDao.class.getName()).log(Level.FINEST, "Query:" + st, (Throwable)null);
                        nRows = st.executeUpdate();
                        closeStatement(st);
                    }
                }
                con.commit();
            }
            long id = 0;
            /** Inserimento nella tabella della topic category **/
            if ((quale.equalsIgnoreCase("topic")) || (quale.equals(""))) {
                sql = new StringBuffer();
                sDataTable = "gpt_resource_stat_topic".toUpperCase();
                sql.append("DELETE FROM  ").append(sDataTable);
                sql.append(" WHERE DOCUUID = ?");
                logExpression(sql.toString());
                st = con.prepareStatement(sql.toString());
                st.setString(1, docUUID);
                Logger.getLogger(ImsMetadataProxyDao.class.getName()).log(Level.FINEST, "Query:" + st, (Throwable)null);
                nRows = st.executeUpdate();
                closeStatement(st);

                if (jsonData.elencoTopic != null) {
                    //Inserimento tabella statistica TOPIC
                    sDataTable = "gpt_resource_stat_topic".toUpperCase();
                    for (final String topic : jsonData.elencoTopic) {
                        // insert a record
                        sql = new StringBuffer();
                        sql.append("INSERT INTO ").append(sDataTable);
                        sql.append(" (");
                        sql.append("DOCUUID,");
                        sql.append("ID,");
                        sql.append("TOPIC");
                        sql.append(")");
                        sql.append(" VALUES(?,?,?)");

                        logExpression(sql.toString());
                        id = getIdFromTable(sDataTable);
                        st = con.prepareStatement(sql.toString());

                        st.setString(1, docUUID);
                        st.setLong(2, id + 1);
                        st.setString(3, topic);
                        Logger.getLogger(ImsMetadataProxyDao.class.getName()).log(Level.FINEST, "Query:" + st, (Throwable)null);
                        nRows = st.executeUpdate();
                        closeStatement(st);
                    }
                }
            }
            /** Inserimento nella tabella del tema INSPIRE **/
            if ((quale.equalsIgnoreCase("inspire")) || (quale.equals(""))) {
                sql = new StringBuffer();
                sDataTable = "gpt_resource_stat_inspire_theme".toUpperCase();
                sql.append("DELETE FROM  ").append(sDataTable);
                sql.append(" WHERE DOCUUID = ?");
                logExpression(sql.toString());
                st = con.prepareStatement(sql.toString());
                st.setString(1, docUUID);
                Logger.getLogger(ImsMetadataProxyDao.class.getName()).log(Level.FINEST, "Query:" + st, (Throwable)null);
                nRows = st.executeUpdate();
                closeStatement(st);

                if (jsonData.elencoTemiInspire != null) {
                    //Inserimento tabella statistica INSPIRE THEME
                    sDataTable = "gpt_resource_stat_inspire_theme".toUpperCase();
                    for (final String theme : jsonData.elencoTemiInspire) {
                        // insert a record
                        sql = new StringBuffer();
                        sql.append("INSERT INTO ").append(sDataTable);
                        sql.append(" (");
                        sql.append("DOCUUID,");
                        sql.append("ID,");
                        sql.append("INSPIRE_THEME");
                        sql.append(")");
                        sql.append(" VALUES(?,?,?)");

                        logExpression(sql.toString());
                        id = getIdFromTable(sDataTable);
                        st = con.prepareStatement(sql.toString());
                        st.setString(1, docUUID);
                        st.setLong(2, id + 1);
                        st.setString(3, theme);
                        Logger.getLogger(ImsMetadataProxyDao.class.getName()).log(Level.FINEST, "Query:" + st, (Throwable)null);
                        nRows = st.executeUpdate();
                        closeStatement(st);
                    }
                }
            }
            /** Inserimento nella tabella del tipo servizio INSPIRE **/
            if ((quale.equalsIgnoreCase("inspireservice")) || (quale.equals(""))) {
                sql = new StringBuffer();
                sDataTable = "gpt_resource_stat_inspire_service".toUpperCase();
                sql.append("DELETE FROM  ").append(sDataTable);
                sql.append(" WHERE DOCUUID = ?");
                logExpression(sql.toString());
                st = con.prepareStatement(sql.toString());
                st.setString(1, docUUID);
                Logger.getLogger(ImsMetadataProxyDao.class.getName()).log(Level.FINEST, "Query:" + st, (Throwable)null);
                nRows = st.executeUpdate();
                closeStatement(st);

                if (jsonData.elencoTassonomiaISO != null) {
                    //Inserimento tabella statistica INSPIRE THEME
                    sDataTable = "gpt_resource_stat_inspire_service".toUpperCase();
                    for (final String theme : jsonData.elencoTassonomiaISO) {
                        // insert a record
                        sql = new StringBuffer();
                        sql.append("INSERT INTO ").append(sDataTable);
                        sql.append(" (");
                        sql.append("DOCUUID,");
                        sql.append("ID,");
                        sql.append("INSPIRE_SERVICE");
                        sql.append(")");
                        sql.append(" VALUES(?,?,?)");

                        logExpression(sql.toString());
                        id = getIdFromTable(sDataTable);
                        st = con.prepareStatement(sql.toString());
                        st.setString(1, docUUID);
                        st.setLong(2, id + 1);
                        st.setString(3, theme);
                        Logger.getLogger(ImsMetadataProxyDao.class.getName()).log(Level.FINEST, "Query:" + st, (Throwable)null);
                        nRows = st.executeUpdate();
                        closeStatement(st);
                    }
                }
            }
            
            /** Inserimento nella tabella del tipo servizio  **/            
            if ((quale.equalsIgnoreCase("service")) || (quale.equals(""))) {
                sDataTable = "gpt_resource_stat_service_type".toUpperCase();
                sql = new StringBuffer();
                sql.append("DELETE FROM  ").append(sDataTable);
                sql.append(" WHERE DOCUUID = ?");
                logExpression(sql.toString());
                st = con.prepareStatement(sql.toString());
                st.setString(1, docUUID);
                Logger.getLogger(ImsMetadataProxyDao.class.getName()).log(Level.FINEST, "Query:" + st, (Throwable)null);
                nRows = st.executeUpdate();
                closeStatement(st);
                if (jsonData.elencoServiceType != null) {
                    //Inserimento tabella statistica SERVICE TYPE
                    sDataTable = "gpt_resource_stat_service_type".toUpperCase();
                    for (final String serviceT : jsonData.elencoServiceType) {
                        // insert a record
                        sql = new StringBuffer();
                        sql.append("INSERT INTO ").append(sDataTable);
                        sql.append(" (");
                        sql.append("DOCUUID,");
                        sql.append("ID,");
                        sql.append("SERVICE_TYPE");
                        sql.append(")");
                        sql.append(" VALUES(?,?,?)");

                        logExpression(sql.toString());
                        id = getIdFromTable(sDataTable);
                        st = con.prepareStatement(sql.toString());

                        st.setString(1, docUUID);
                        st.setLong(2, id + 1);
                        st.setString(3, serviceT);
                        Logger.getLogger(ImsMetadataProxyDao.class.getName()).log(Level.FINEST, "Query:" + st, (Throwable)null);
                        nRows = st.executeUpdate();
                        closeStatement(st);
                    }
                }
            }
            /** Inserimento nella tabella del tipo priority Dataset **/
            if ((quale.equalsIgnoreCase("prioritydataset")) || (quale.equals(""))) {
                sql = new StringBuffer();
                sDataTable = "gpt_resource_stat_priority_dataset".toUpperCase();
                sql.append("DELETE FROM  ").append(sDataTable);
                sql.append(" WHERE DOCUUID = ?");
                logExpression(sql.toString());
                st = con.prepareStatement(sql.toString());
                st.setString(1, docUUID);
                Logger.getLogger(ImsMetadataProxyDao.class.getName()).log(Level.FINEST, "Query new:" + st, (Throwable)null);
                nRows = st.executeUpdate();
                closeStatement(st);

                if (jsonData.elencoPriorityDataset != null) {
                    //Inserimento tabella statistica priority Dataset
                    sDataTable = "gpt_resource_stat_priority_dataset".toUpperCase();
                    for (final String theme : jsonData.elencoPriorityDataset) {
                        // insert a record
                        sql = new StringBuffer();
                        sql.append("INSERT INTO ").append(sDataTable);
                        sql.append(" (");
                        sql.append("DOCUUID,");
                        sql.append("ID,");
                        sql.append("PRIORITYDATASET");
                        sql.append(")");
                        sql.append(" VALUES(?,?,?)");

                        logExpression(sql.toString());
                        id = getIdFromTable(sDataTable);
                        st = con.prepareStatement(sql.toString());
                        st.setString(1, docUUID);
                        st.setLong(2, id + 1);
                        st.setString(3, theme);
                        Logger.getLogger(ImsMetadataProxyDao.class.getName()).log(Level.FINEST, "Query:" + st, (Throwable)null);
                        nRows = st.executeUpdate();
                        closeStatement(st);
                    }
                }
            }
            /** Inserimento nella tabella del tipo openData **/
            if ((quale.equalsIgnoreCase("opendata")) || (quale.equals(""))) {
                
                /*
                SELECT DOCUUID, 
ExtractValue(XML, "/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword/gco:CharacterString | /gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword/gmx:Anchor") OPENDATA 
from gpt_resource_data
where ExtractValue(XML, "/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword[contains(gco:CharacterString, 'opendata') or contains(gco:CharacterString, 'open data')] | /gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/gmd:MD_Constraints/gmd:useLimitation[contains(gco:CharacterString, 'CC-BY') or contains(gco:CharacterString, 'CCBY') or contains(gco:CharacterString, 'BY SA') or contains(gco:CharacterString,'IODL') or contains(gco:CharacterString,'Italian Open Data') or contains(gco:CharacterString, 'Creative Commons BY') or contains(gco:CharacterString,'Open Data') or contains(gco:CharacterString, 'CC BY') or contains(gco:CharacterString,'citazione della fonte')]") > 0
                */
                sql = new StringBuffer();
                sDataTable = "gpt_resource_stat_opendata".toUpperCase();
                sql.append("DELETE FROM  ").append(sDataTable);
                sql.append(" WHERE DOCUUID = ?");
                logExpression(sql.toString());
                st = con.prepareStatement(sql.toString());
                st.setString(1, docUUID);
                Logger.getLogger(ImsMetadataProxyDao.class.getName()).log(Level.FINEST, "Query:" + st, (Throwable)null);
                nRows = st.executeUpdate();
                closeStatement(st);

                if (jsonData.elencoOpenData != null) {
                    //Inserimento tabella statistica priority Dataset
                    sDataTable = "gpt_resource_stat_opendata".toUpperCase();
                    for (final String theme : jsonData.elencoOpenData) {
                        // insert a record
                        sql = new StringBuffer();
                        sql.append("INSERT INTO ").append(sDataTable);
                        sql.append(" (");
                        sql.append("DOCUUID,");
                        sql.append("ID,");
                        sql.append("OPENDATA");
                        sql.append(")");
                        sql.append(" VALUES(?,?,?)");

                        logExpression(sql.toString());
                        id = getIdFromTable(sDataTable);
                        st = con.prepareStatement(sql.toString());
                        st.setString(1, docUUID);
                        st.setLong(2, id + 1);
                        st.setString(3, theme);
                        Logger.getLogger(ImsMetadataProxyDao.class.getName()).log(Level.FINEST, "Query:" + st, (Throwable)null);
                        nRows = st.executeUpdate();
                        closeStatement(st);
                    }
                }
            }

            con.commit();
        } catch (SQLException ex) {
            if (con != null) {
                con.rollback();
            }
            throw ex;
        } finally {
            closeResultSet(rs);
            closeStatement(st);
            if (con != null) {
                con.setAutoCommit(autoCommit);
            }
        }

    }

    /**
     * Queries the owner id associated with a document UUID.
     *
     * @param uuid the document UUID
     * @return the owner name (empty string if not found)
     * @throws SQLException if a database exception occurs
     */
    private int queryOwnerByUsername(String username) throws SQLException {
        int ownerID = -1;
        PreparedStatement st = null;
        try {
            username = Val.chkStr(username);
            String table = this.getRequestContext().getCatalogConfiguration().getUserTableName();
            if (username.length() > 0) {
                Connection con = returnConnection().getJdbcConnection();
                StringBuilder sql = new StringBuilder();
                sql.append("SELECT USERID FROM ").append(table);
                if (getIsDbCaseSensitive(this.getRequestContext())) {
                    sql.append(" WHERE UPPER(USERNAME)=?");
                } else {
                    sql.append(" WHERE USERNAME=?");
                }
                logExpression(sql.toString());
                st = con.prepareStatement(sql.toString());
                st.setString(1, username.toUpperCase());
                ResultSet rs = st.executeQuery();
                if (rs.next()) {
                    ownerID = rs.getInt(1);
                }
            }
        } finally {
            closeStatement(st);
        }
        return ownerID;
    }

    /**
     * Queries the owner id associated with a document UUID.
     *
     * @param uuid the document UUID
     * @return the owner name (empty string if not found)
     * @throws SQLException if a database exception occurs
     */
    private int queryOwnerByUuid(String uuid) throws SQLException {
        int ownerID = -1;
        PreparedStatement st = null;
        try {
            uuid = Val.chkStr(uuid);
            if (uuid.length() > 0) {
                Connection con = returnConnection().getJdbcConnection();
                StringBuilder sql = new StringBuilder();
                sql.append("SELECT OWNER FROM ").append(getResourceTableName());
                sql.append(" WHERE DOCUUID=?");
                logExpression(sql.toString());
                st = con.prepareStatement(sql.toString());
                st.setString(1, uuid);
                ResultSet rs = st.executeQuery();
                if (rs.next()) {
                    ownerID = rs.getInt(1);
                }
            }
        } finally {
            closeStatement(st);
        }
        return ownerID;
    }

    /**
     * Queries the owner id associated with a document UUID.
     *
     * @param uuid the document UUID
     * @return the owner name (empty string if not found)
     * @throws SQLException if a database exception occurs
     */
    private String queryUsernameByID(int userID) throws SQLException {
        String username = "";
        PreparedStatement st = null;
        try {
            String table = this.getRequestContext().getCatalogConfiguration().getUserTableName();
            Connection con = returnConnection().getJdbcConnection();
            StringBuilder sql = new StringBuilder();
            sql.append("SELECT USERNAME FROM ").append(table);
            sql.append(" WHERE USERID=?");
            logExpression(sql.toString());
            st = con.prepareStatement(sql.toString());
            st.setInt(1, userID);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                username = rs.getString(1);
            }
        } finally {
            closeStatement(st);
        }
        return username;
    }

    /**
     * Reads a record from the proxied ArcIMS metadata table.
     *
     * @param request the underlying request
     * @param uuid the UUID for the record to read
     * @throws ImsServiceException typically related to an authorization related
     * exception
     * @throws SQLException if a database exception occurs
     */
    protected void readRecord(GetDocumentRequest request, String uuid)
            throws ImsServiceException, SQLException {
        PreparedStatement st = null;
        try {
            //EsriItalia 2017 Abilitazione a tutti della lettura dei dati this.authorize(request, uuid);

            ManagedConnection mc = returnConnection();
            Connection con = mc.getJdbcConnection();
            IClobMutator cm = mc.getClobMutator();

            StringBuffer sql = new StringBuffer();
            sql.append("SELECT UPDATEDATE");
            sql.append(" FROM ").append(getResourceTableName()).append(" WHERE DOCUUID=?");
            logExpression(sql.toString());
            st = con.prepareStatement(sql.toString());
            st.setString(1, uuid);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                request.setUpdateTimestamp(rs.getTimestamp(1));
                request.setActionStatus(ImsRequest.ACTION_STATUS_OK);

                closeStatement(st);

                sql = new StringBuffer();
                sql.append("SELECT XML");
                sql.append(" FROM ").append(getResourceDataTableName()).append(" WHERE DOCUUID=?");
                st = con.prepareStatement(sql.toString());
                st.setString(1, uuid);
                rs = st.executeQuery();

                if (rs.next()) {
                    request.setXml(cm.get(rs, 1));
                }
            }

        } finally {
            closeStatement(st);
        }
    }

    /**
     * Transfers ownership for a record in the proxied ArcIMS metadata table.
     *
     * @param request the underlying request
     * @param uuid the UUID for the record to read
     * @return the number of rows affected
     * @throws ImsServiceException typically related to an authorization related
     * exception
     * @throws SQLException if a database exception occurs
     */
    protected int transferOwnership(TransferOwnershipRequest request, String uuid, String newOwner)
            throws ImsServiceException, SQLException {
        PreparedStatement st = null;
        try {
            this.authorize(request, uuid);
            int ownerID = this.queryOwnerByUsername(newOwner);
            if (ownerID == -1) {
                throw new ImsServiceException("Unrecognized publisher: " + newOwner);
            }
            StringBuilder sql = new StringBuilder();
            sql.append("UPDATE ").append(this.getResourceTableName());
            sql.append(" SET OWNER=? WHERE DOCUUID=?");
            logExpression(sql.toString());
            Connection con = returnConnection().getJdbcConnection();
            st = con.prepareStatement(sql.toString());
            st.setInt(1, ownerID);
            st.setString(2, uuid);
            int nRows = st.executeUpdate();
            if (nRows > 0) {
                request.setActionStatus(ImsRequest.ACTION_STATUS_REPLACED);
            }
            return nRows;
        } finally {
            closeStatement(st);
        }
    }

    private void updateThumbnail(String base64Thumbnail, String uuid) {
        PreparedStatement st = null;
        try {
            byte[] bytes = (new sun.misc.BASE64Decoder()).decodeBuffer(base64Thumbnail);
            StringBuilder sql = new StringBuilder();
            sql.append("UPDATE ").append(this.getResourceDataTableName());
            sql.append(" SET THUMBNAIL=? WHERE DOCUUID=?");
            logExpression(sql.toString());
            Connection con = returnConnection().getJdbcConnection();
            st = con.prepareStatement(sql.toString());
            st.setBytes(1, bytes);
            st.setString(2, uuid);
            st.executeUpdate();
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error converting base64 thumbnail to bytes.", e);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error saving thumbnail blob to database.", e);
        } finally {
            closeStatement(st);
        }
    }

    /**
     * Checks if publisher belongs to the group
     *
     * @param groupName group name
     * @return <code>true</code> if publisher belongs to the group
     * @throws ImsServiceException
     * @throws SQLException
     */
    private boolean belongsToTheGroup(String groupName) throws ImsServiceException, SQLException {
        assertUserGroups();
        boolean isPartOfTheGroup = false;
        for (Group grp : publisher.getGroups().values()) {
            if (groupName.equals(grp.getName())) {
                isPartOfTheGroup = true;
                break;
            }
        }
        return isPartOfTheGroup;
    }

    /**
     * Asserts user's groups
     *
     * @throws SQLException if accessing database fails
     * @throws ImsServiceException if any other problem occurs
     */
    private void assertUserGroups() throws ImsServiceException, SQLException {
        if (!groupsLoaded) {
            if (publisher.getGroups().isEmpty()) {
                loadUserGroups(publisher);
            }
            groupsLoaded = true;
        }
    }

    /**
     * Loads user's groups
     *
     * @param user user
     * @throws SQLException if accessing database fails
     * @throws ImsServiceException if any other problem occurs
     */
    private void loadUserGroups(User user) throws SQLException, ImsServiceException {
        try {
            RequestContext requestContext = RequestContext.extract(null);
            IdentityAdapter identityAdapter = requestContext.newIdentityAdapter();
            identityAdapter.readUserGroups(user);
        } catch (Exception ex) {
            throw new ImsServiceException("Error evaluation asserting groups.");
        }
    }

    /**
     *
     * Metodo privato che consente la modifica dell'xml appena inserito
     * dall'utente Cio' e' reso necessario da alcuni problemi, ad esempio alcuni
     * tag vengono scritti anche se vuoti
     *
     * @param sXml l'xml inserito
     */
    private String modifyXml(String sXml) {
        LOGGER.finest("Elimino le sezioni vuote dall'xml...");
        URL xslt = null;
        String sXmlClean = null;
        // Modificato il 17/12/2014: non c'è bisogno del test perché comunque nel Clean ci sono i match sui tag 
//	   if(sXml.contains("<gmd:")){
        try {
            TransformerFactory tfactory = TransformerFactory.newInstance();
            xslt = (new ResourcePath()).makeUrl("gpt/metadata/CleanMetadata.xslt");
            Templates t = tfactory.newTemplates(new StreamSource(xslt.toString()));

            Transformer transformer = t.newTransformer();
            StringWriter writer = new StringWriter();
            transformer.transform(new StreamSource(new StringReader(sXml)), new StreamResult(writer));
            sXmlClean = writer.toString();
        } catch (Exception ex) {
            LOGGER.severe("Errore: non posso continuare con la trasformazione");
            LOGGER.severe(ex.getMessage());
            return sXml;
        }
        LOGGER.finest("Fatto!");
        return sXmlClean;
//	   }
//	   else
//	   {	LOGGER.finest("Il metadato non e' ISO: non posso continuare con la trasformazione");
//		   return sXml;
//	   }
    }
}
