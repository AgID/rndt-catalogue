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
                LOGGER.finest("Fallito inserimento statistiche");//added by Esri Italy
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

            // note that all the elements in the expression are prefixed with our namespace mapping!
            XPathExpression expr = xpath.compile("/gmd:MD_Metadata/gmd:hierarchyLevel/gmd:MD_ScopeCode");

            // assuming you've got your XML document in a variable named doc...
            NodeList nodeList = (NodeList) expr.evaluate(document, XPathConstants.NODESET);
            if (nodeList.getLength() > 0) {
                retJson.Hier = nodeList.item(0).getTextContent();
            }

            //Responsabile prendo solo il primo
            expr = xpath.compile("/gmd:MD_Metadata/gmd:identificationInfo/*/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString");
            // assuming you've got your XML document in a variable named doc...
            nodeList = (NodeList) expr.evaluate(document, XPathConstants.NODESET);
            if (nodeList.getLength() > 0) {
                retJson.Resp = nodeList.item(0).getTextContent();
            }

            //Topic 
            expr = xpath.compile("/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:topicCategory/gmd:MD_TopicCategoryCode");
            // assuming you've got your XML document in a variable named doc...
            nodeList = (NodeList) expr.evaluate(document, XPathConstants.NODESET);
            for (int i = 0; i < nodeList.getLength(); i++) {
                retJson.elencoTopic.add(nodeList.item(i).getTextContent());
            }
            //Service Type 
            ///gmd:MD_Metadata/gmd:identificationInfo/srv:SV_ServiceIdentification/srv:serviceType/gco:LocalName
            expr = xpath.compile("/gmd:MD_Metadata/gmd:identificationInfo/srv:SV_ServiceIdentification/srv:serviceType/gco:LocalName");
            nodeList = (NodeList) expr.evaluate(document, XPathConstants.NODESET);
            for (int i = 0; i < nodeList.getLength(); i++) {
                retJson.elencoServiceType.add(nodeList.item(i).getTextContent());
            }
            //Tassonomia INSPIRE/ISO
            expr = xpath.compile("/gmd:MD_Metadata/gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:descriptiveKeywords[count(gmd:MD_Keywords/gmd:thesaurusName) = 0]/gmd:MD_Keywords/gmd:keyword/gco:CharacterString");
            ///expr = xpath.compile("/gmd:MD_Metadata/gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword/gco:CharacterString");
            nodeList = (NodeList) expr.evaluate(document, XPathConstants.NODESET);
            for (int i = 0; i < nodeList.getLength(); i++) {
                if (lstISO.contains(nodeList.item(i).getTextContent())) retJson.elencoTassonomiaISO.add(nodeList.item(i).getTextContent());
            }
            
            
            
            //Inspire Theme  dovrei prendere solo quello con GEMET
            //a[b/c/@d = 'text1' and b/c/@d = 'text4']/b/c[@d = 'text5']/@e
            //gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:thesaurusName/gmd:CI_Citation/gmd:title/gco:CharacterString
            //expr = xpath.compile("/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:thesaurusName/gmd:CI_Citation/gmd:title[contains(gco:CharacterString, 'GEMET - INSPIRE themes')]/../../../gmd:keyword/gco:CharacterString");
            expr = xpath.compile("/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords[gmd:thesaurusName/gmd:CI_Citation/gmd:title/gco:CharacterString = 'GEMET - INSPIRE themes, version 1.0']/gmd:keyword/gco:CharacterString");
            nodeList = (NodeList) expr.evaluate(document, XPathConstants.NODESET);
            for (int i = 0; i < nodeList.getLength(); i++) {

                retJson.elencoTemiInspire.add(nodeList.item(i).getTextContent());
            }

        } catch (Exception e) {
            LOGGER.finest(e.getMessage());//added by Esri Italy
        }
        return retJson;
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
            LOGGER.finest("Errore: non posso continuare con la trasformazione");
            LOGGER.finest(ex.getMessage());
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
