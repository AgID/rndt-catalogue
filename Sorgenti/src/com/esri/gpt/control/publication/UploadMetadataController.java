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
package com.esri.gpt.control.publication;

import com.esri.gpt.catalog.gxe.GxeDefinition;
import com.esri.gpt.catalog.management.MmdEnums;
import com.esri.gpt.catalog.publication.ProcessedRecord;
import com.esri.gpt.catalog.publication.ProcessingContext;
import com.esri.gpt.catalog.publication.ProcessorFactory;
import com.esri.gpt.catalog.publication.ResourceProcessor;
import com.esri.gpt.catalog.publication.UploadRequest;
import com.esri.gpt.catalog.publication.ValidationRequest;
import com.esri.gpt.catalog.schema.MetadataDocument;
import com.esri.gpt.catalog.schema.Schema;
import com.esri.gpt.catalog.schema.ValidationException;
import com.esri.gpt.control.publication.controlMetadata.ControlMetadataDocument;
import com.esri.gpt.control.view.SelectablePublishers;
import com.esri.gpt.framework.context.RequestContext;
import com.esri.gpt.framework.http.HttpClientRequest;
import com.esri.gpt.framework.jsf.BaseActionListener;
import com.esri.gpt.framework.jsf.MessageBroker;
import com.esri.gpt.framework.security.principal.Publisher;
import com.esri.gpt.framework.util.ResourcePath;
import com.esri.gpt.framework.util.UuidUtil;
import com.esri.gpt.framework.util.Val;
import com.helger.schematron.svrl.SVRLFailedAssert;
import java.io.ByteArrayInputStream;

import java.io.File;

import java.io.IOException;
import java.io.InputStream;

import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.text.MessageFormat;
import java.util.ArrayList;

import javax.faces.application.FacesMessage;
import javax.faces.component.UIComponent;
import javax.faces.event.AbortProcessingException;
import javax.faces.event.ActionEvent;
import javax.servlet.http.HttpServletRequest;
import javax.xml.transform.stream.StreamSource;

import org.apache.commons.fileupload.FileItem;

/**
 * Handles a metadata file upload action.
 */
public class UploadMetadataController extends BaseActionListener {

    /**
     * class variables =========================================================
     */
    public static final String SPECIFICATIONMETHOD_BROWSE = "browse";
    public static final String SPECIFICATIONMETHOD_EXPLICIT = "explicit";

    /**
     * instance variables ======================================================
     */
    private String explicitPath = "";
    private UploadOptions options;
    private SelectablePublishers selectablePublishers;
    private boolean asDraft;
    /*ESRI ITALIA 14/03/2017 check per la sovrascrittura del metadato*/

    private boolean replaceIfExist;

    /**
     * constructors ============================================================
     */
    /**
     * Default constructor.
     */
    public UploadMetadataController() {
        selectablePublishers = new SelectablePublishers();
    }

    /**
     * properties ==============================================================
     */
    /**
     * Gets the flag indicating if the user can publish on behalf of another.
     *
     * @return truw id proxy publishing is enabled
     */
    public boolean getCanPublishAsProxy() {
        return true;
    }

    /**
     * Gets the explicit path of the file to upload.
     * <br/>The explicit path can be a URL or a path recognized on the server.
     *
     * @return the explicit path
     */
    public String getExplicitPath() {
        return this.explicitPath;
    }

    /**
     * Sets the explicit path of the file to upload.
     * <br/>The explicit path can be a URL or a path recognized on the server.
     *
     * @param path the explicit path
     */
    public void setExplicitPath(String path) {
        this.explicitPath = Val.chkStr(path);
    }

    /**
     * Gets the upload options.
     *
     * @return the upload options
     */
    public UploadOptions getOptions() {
        return this.options;
    }

    /**
     * Sets the upload options.
     *
     * @param options the upload options
     */
    public void setOptions(UploadOptions options) {
        this.options = options;
    }

    /**
     * Gets list of selectable publishers.
     *
     * @return the list of selectable publishers
     */
    public SelectablePublishers getSelectablePublishers() {
        return selectablePublishers;
    }

    /**
     * Gets the file specification method.
     *
     * @return the file specification method
     */
    public String getSpecificationMethod() {
        return this.getOptions().getSpecificationMethod();
    }

    /**
     * Sets the file specification method.
     *
     * @param method the file specification method
     */
    public void setSpecificationMethod(String method) {
        this.getOptions().setSpecificationMethod(method);
    }

    /**
     * Gets the style attribute for "browse" specificication panel.
     *
     * @return the style (display none or block)
     */
    public String getStyleForBrowseMethod() {
        if (getSpecificationMethod().equals(UploadMetadataController.SPECIFICATIONMETHOD_BROWSE)) {
            return "display: block;";
        } else {
            return "display: none;";
        }
    }

    /**
     * Gets the style attribute for "explicit" specificication panel.
     *
     * @return the style (display none or block)
     */
    public String getStyleForExplicitMethod() {
        if (getSpecificationMethod().equals(UploadMetadataController.SPECIFICATIONMETHOD_EXPLICIT)) {
            return "display: block;";
        } else {
            return "display: none;";
        }
    }

    public boolean getAsDraft() {
        return asDraft;
    }

    public void setAsDraft(boolean asDraft) {
        this.asDraft = asDraft;
    }

    /*ESRI ITALIA 14/03/2017 gestione del flag per la sovrascrittura del metadato*/
    public boolean getReplaceIfExist() {
        return replaceIfExist;
    }

    public void setReplaceIfExist(boolean _replaceIfExist) {
        this.replaceIfExist = _replaceIfExist;
    }
    /*ESRI ITALIA 14/03/2017 gestione del flag per la sovrascrittura del metadato*/

    /**
     * methods =================================================================
     */

    /**
     * Adds a summary message and a list of errors for each processed record
     * that failed.
     *
     * @param context the processing context
     * @param msgBroker the message broker
     * @param resourceKey the resource key associated with the status type
     * @param statusType the sstatus type
     * @param count the count associated with the status type
     */
    private void addErrorMessages(ProcessingContext context, MessageBroker msgBroker,
            String resourceKey, ProcessedRecord.StatusType statusType, int count) {

        Object[] parameters = new Integer[]{count};
        String msg = msgBroker.retrieveMessage(resourceKey);
        msg = MessageFormat.format(msg, parameters);
        FacesMessage fm = new FacesMessage(FacesMessage.SEVERITY_ERROR, msg, null);
        msgBroker.addMessage(fm);
        for (ProcessedRecord processedRecord : context.getProcessedRecords()) {
            if (processedRecord.getStatusType().equals(statusType) && (processedRecord.getExceptions() != null)) {
                StringBuilder sb = new StringBuilder();
                sb.append(processedRecord.getSourceUri());
                if (processedRecord.getExceptions() != null) {
                    for (String error : processedRecord.getExceptions()) {
                        sb.append("<br />").append(error);
                    }
                }
                fm = new FacesMessage(FacesMessage.SEVERITY_ERROR, sb.toString(), null);
                msgBroker.addMessage(fm);
            }
        }

    }

    /**
     * Adds a summary message and a list processed records for a processd status
     * type.
     *
     * @param context the processing context
     * @param msgBroker the message broker
     * @param resourceKey the resource key associated with the status type
     * @param statusType the sstatus type
     * @param count the count associated with the status type
     */
    private void addSummaryMessage(ProcessingContext context, MessageBroker msgBroker,
            String resourceKey, ProcessedRecord.StatusType statusType, int count) {
        Object[] parameters = new Integer[]{count};
        String msg = msgBroker.retrieveMessage(resourceKey);
        msg = MessageFormat.format(msg, parameters);
        StringBuilder sb = new StringBuilder(msg);
        for (ProcessedRecord processedRecord : context.getProcessedRecords()) {
            if (processedRecord.getStatusType().equals(statusType)) {
                sb.append("<br />").append(processedRecord.getSourceUri());
            }
        }
        if (sb.length() > 0) {
            FacesMessage fm = new FacesMessage(FacesMessage.SEVERITY_INFO, sb.toString(), null);
            msgBroker.addMessage(fm);
        }
    }

    /**
     * Extracts the file item placed in the HTTP servlet request by the
     * MultipartFilter.
     *
     * @return the uploaded file item (null if none)
     */
    private FileItem extractFileItem() {
        FileItem item = null;
        HttpServletRequest httpReq = getContextBroker().extractHttpServletRequest();
        if (httpReq != null) {
            Object oFile = httpReq.getAttribute("upload:uploadXml");
            if ((oFile != null) && (oFile instanceof FileItem)) {
                item = (FileItem) oFile;
            }
        }
        return item;
    }

    /**
     * Extracts the XML string associated with an uploaded multipath file item.
     *
     * @return the XML string (null if none)
     * @throws UnsupportedEncodingException (should never be thrown)
     */
    private String extractItemXml(FileItem item) throws UnsupportedEncodingException {
        String xml = null;
        if (item != null) {
            xml = Val.chkStr(Val.removeBOM(item.getString("UTF-8")));
        }
        return xml;
    }

    /**
     * Fired when the getPrepareView() property is accessed.
     * <br/>This event is triggered from the page during the render response
     * phase of the JSF cycle.
     *
     * @param context the context associated with the active request
     * @throws Exception if an exception occurs
     */
    @Override
    protected void onPrepareView(RequestContext context) throws Exception {
        getSelectablePublishers().build(context, false);
    }

    /**
     * Handles a metadata file upload action.
     * <br/>This is the default entry point for a sub-class of
     * BaseActionListener.
     * <br/>This BaseActionListener handles the JSF processAction method and
     * invokes the processSubAction method of the sub-class.
     *
     * @param event the associated JSF action event
     * @param context the context associated with the active request
     * @throws AbortProcessingException if processing should be aborted
     * @throws Exception if an exception occurs
     */
    @Override
    protected void processSubAction(ActionEvent event, RequestContext context)
            throws AbortProcessingException, Exception {

	//20131002-ricompilato con Java7
        // initialize
        MessageBroker msgBroker = extractMessageBroker();
        String sFileName = "";
        String sXml = "";
        UIComponent component = event.getComponent();
        String sCommand = Val.chkStr((String) component.getAttributes().get("command"));
        boolean bValidateOnly = sCommand.equalsIgnoreCase("validate");
        //Added by ESRI Italy: aggiunta gestione comando "recognize"
        boolean bRecognized = sCommand.equalsIgnoreCase("recognize");
        boolean bIsBrowse = this.getSpecificationMethod().equals(UploadMetadataController.SPECIFICATIONMETHOD_BROWSE);
        String sExplicitPath = this.getExplicitPath();
        
        try {
            InputStream fileVal = null;
            // upload a single file from disk
            if (bIsBrowse) {
                FileItem item = extractFileItem();
                if (item != null) {
                    sFileName = Val.chkStr(item.getName());
                    if (sFileName.length() > 0) {
                        File file = new File(sFileName);
                        
                        sFileName = file.getName();
                    }
                    sXml = extractItemXml(item);
                    fileVal = new ByteArrayInputStream(sXml.getBytes("UTF-8"));
                }
                if (sFileName.length() > 0) {
                    FacesMessage fm = new FacesMessage(FacesMessage.SEVERITY_WARN, sFileName, null);
                    msgBroker.addMessage(fm);
                }
                
                ControlMetadataDocument controlMetadata = new ControlMetadataDocument(context,sXml);

                if (sFileName.length() == 0) {
                    msgBroker.addErrorMessage("publication.uploadMetadata.err.file.required");
                } else if (sXml.length() == 0) {
                    msgBroker.addErrorMessage("publication.uploadMetadata.err.file.empty");
                } /**
                 * ***************************Added By ESRI Italy****************
                 */
                /**
                 * Gestione riconoscimento schema: il nome dello standard
                 * riconosciuto viene visualizzato
                 */
                else if (bRecognized) {
                    MetadataDocument doc = new MetadataDocument();
                    Schema schema = doc.evaluateSchema(context, sXml, true);
                    String[] recSchema = {msgBroker.retrieveMessage(schema.getLabel().getResourceKey())};
                    msgBroker.addSuccessMessage("catalog.mdParam.schema.recognizedSchema", recSchema);

                } else if (bValidateOnly) {
                    ValidationRequest request = new ValidationRequest(context, sFileName, sXml);
                    /**
                     * ***************************Added By ESRI Italy****************
                     */
                    /**
                     * Gestione riconoscimento schema: il nome dello standard
                     * riconosciuto viene visualizzato
                     */
                    MetadataDocument doc = new MetadataDocument();
                    Schema schema = doc.prepareForPublication(request);
                    String[] recSchema = {msgBroker.retrieveMessage(schema.getLabel().getResourceKey())};
                    msgBroker.addSuccessMessage("catalog.mdParam.schema.recognizedSchema", recSchema);
                    request.verify();
                    

                    // check for a defined GXE based Geoportal XML editor
                    GxeDefinition gxeDefinition = schema.getGxeEditorDefinition();
                    if (gxeDefinition != null) {
                        context.getServletRequest().setAttribute("gxeDefinitionKey", gxeDefinition.getKey());
                        context.getServletRequest().setAttribute("gxeDefinitionLocation", gxeDefinition.getFileLocation());

                        String sEsriDocID = request.getPublicationRecord().getUuid();
                        if (UuidUtil.isUuid(sEsriDocID)) {
                            context.getServletRequest().setAttribute("gxeOpenDocumentId", sEsriDocID);
                        }
                    }
                    
                    String fileSch = schema.getSchematronSch();
                    if(!controlMetadata.getStatus()){
                        ArrayList<String> errorMessage = controlMetadata.getErrorMessage();
                        errorMessage.forEach((error) -> {
                            msgBroker.addErrorMessage(error);
                        });
                    }else if (!fileSch.isEmpty()){
                        ResourcePath rp = new ResourcePath();
                        URL url = rp.makeUrl(fileSch);
                        InputStream is  = url.openStream();
                        fromMaven OUT = new fromMaven();
                        OUT.setFile(is, fileVal);
                        OUT.execute();
                        if (OUT.failedList.isEmpty()) {
                            msgBroker.addSuccessMessage("catalog.publication.success.validated");
                            //msgBroker.addMessage(new FacesMessage(FacesMessage.SEVERITY_INFO, "Validazione Schematron Ok!", null));
                        } else {
                            for (SVRLFailedAssert failedAssert : OUT.failedList) {
                                msgBroker.addMessage(new FacesMessage(FacesMessage.SEVERITY_ERROR, "Errore: " + failedAssert.getText(), null));
                            }
                        }
                    } else {
                        msgBroker.addSuccessMessage("catalog.publication.success.validated");
                    }
                }else {
                    Publisher publisher = getSelectablePublishers().selectedAsPublisher(context, false);
                    UploadRequest request = new UploadRequest(context, publisher, sFileName, sXml);
                    request.setRetryAsDraft(getAsDraft());
                    request.setReplaceIfExist(this.getReplaceIfExist());
                    MetadataDocument doc = new MetadataDocument();
                    Schema schema = doc.evaluateSchema(context, sXml, true);
                    String fileSch = schema.getSchematronSch();
                    boolean continua=true;
                    if (!fileSch.isEmpty()){
                        fromMaven OUT = new fromMaven();
                        ResourcePath rp = new ResourcePath();
                        URL url = rp.makeUrl(fileSch);
                        InputStream is  = url.openStream();

                        OUT.setFile(is, fileVal);
                        OUT.execute();
                        continua=(OUT.failedList.isEmpty());
                        for (SVRLFailedAssert failedAssert : OUT.failedList) {
                            msgBroker.addMessage(new FacesMessage(FacesMessage.SEVERITY_ERROR,"Errore: " + failedAssert.getText(), null));
                        }

                    }else if(!controlMetadata.getStatus()){
                        ArrayList<String> errorMessage = controlMetadata.getErrorMessage();
                        errorMessage.forEach((error) -> {
                            msgBroker.addErrorMessage(error);
                        });
                    }
                    if (continua) {
                        msgBroker.addMessage(new FacesMessage(FacesMessage.SEVERITY_INFO, "Validazione Schematron Ok!", null));
                        request.publish();
                        /**
                         * ***************************Added By ESRI Italy****************
                         */
                        /**
                         * Gestione riconoscimento schema: il nome dello
                         * standard riconosciuto viene visualizzato
                         */

                        String[] recSchema = {msgBroker.retrieveMessage(schema.getLabel().getResourceKey())};
                        msgBroker.addSuccessMessage("catalog.mdParam.schema.recognizedSchema", recSchema);

                        if (request.getPublicationRecord().getWasDocumentUnchanged()) {
                            msgBroker.addSuccessMessage("publication.success.unchanged");
                        } else if (request.getPublicationRecord().getWasDocumentReplaced()) {
                            msgBroker.addSuccessMessage("publication.success.replaced");
                        } else if (request.getPublicationRecord().getWasDocumentAsDraftWithErrors()) {
                            msgBroker.addSuccessMessage("publication.success.draftByError");
                        } else if (request.getPublicationRecord().getWasDocumentNotReplaced()) {
                            msgBroker.addErrorMessage("publication.success.documentNotInsert");
                         } else {
                            msgBroker.addSuccessMessage("publication.success.created");
                        }
                    } else {
                        if (request.getRetryAsDraft()){
                            //Ci sono errori sullo schematron ma devo comunque pubblicare in bozza.
                            request.publishSchematronError();                       
                            String[] recSchema = {msgBroker.retrieveMessage(schema.getLabel().getResourceKey())};
                            msgBroker.addSuccessMessage("catalog.mdParam.schema.recognizedSchema", recSchema);

                            if (request.getPublicationRecord().getWasDocumentUnchanged()) {
                                msgBroker.addSuccessMessage("publication.success.unchanged");
                            } else if (request.getPublicationRecord().getWasDocumentReplaced()) {
                                msgBroker.addSuccessMessage("publication.success.replaced");
                            } else if (request.getPublicationRecord().getWasDocumentAsDraftWithErrors()) {
                                msgBroker.addSuccessMessage("publication.success.draftByError");
                            } else if (request.getPublicationRecord().getWasDocumentNotReplaced()) {
                                msgBroker.addErrorMessage("publication.success.documentNotInsert");
                            } else {
                                msgBroker.addSuccessMessage("publication.success.created");
                            }
                        }
                    }
                        

                }

                // handle an empty explicit url or network path  
            } else if (sExplicitPath.length() == 0) {
                msgBroker.addErrorMessage("publication.uploadMetadata.err.file.required");

                // process an explicit url or network path 
            } else {
                FacesMessage fm = new FacesMessage(FacesMessage.SEVERITY_WARN, sExplicitPath, null);
                msgBroker.addMessage(fm);

                sFileName = sExplicitPath;
                // Modified by Esri Italy: set to true to overcome control on owner/publisher useful for enableEditForAdministrator flag
                // Publisher publisher = getSelectablePublishers().selectedAsPublisher(context,false);
                Publisher publisher = getSelectablePublishers().selectedAsPublisher(context, true);
                HttpClientRequest httpClient = HttpClientRequest.newRequest();

                ProcessingContext pContext = new ProcessingContext(context, publisher, httpClient, null, bValidateOnly);
                pContext.setMessageBroker(msgBroker);
                ProcessorFactory factory = new ProcessorFactory();
                ResourceProcessor processor = factory.interrogate(pContext, sExplicitPath);

                if (processor == null) {
                    throw new IOException("Unable to process resource.");
                }
                processor.process();
                boolean wasSingleSource = pContext.getWasSingleSource();

                // summary messages
                if (bValidateOnly) {

                    if (wasSingleSource && (pContext.getNumberValidated() == 1)) {
                        msgBroker.addSuccessMessage("catalog.publication.success.validated");
                    } else if (pContext.getNumberValidated() > 0) {
                        addSummaryMessage(pContext, msgBroker, "catalog.publication.uploadMetadata.summary.valid",
                                ProcessedRecord.StatusType.VALIDATED, pContext.getNumberValidated());
                    }
                    if (wasSingleSource && (pContext.getNumberFailed() == 1)) {
                        Exception lastException = pContext.getLastException();
                        if (pContext.getLastException() != null) {
                            throw lastException;
                        } else {
                            // TODO message here ??
                        }
                    } else if (pContext.getNumberFailed() > 0) {
                        addErrorMessages(pContext, msgBroker, "catalog.publication.uploadMetadata.summary.invalid",
                                ProcessedRecord.StatusType.FAILED, pContext.getNumberFailed());
                    }
                    if ((pContext.getNumberValidated() == 0) && (pContext.getNumberFailed() == 0)) {
                        msgBroker.addErrorMessage("catalog.publication.uploadMetadata.summary.valid", new Integer[]{0});
                    }

                    // publication related messages  
                } else {

                    if (wasSingleSource && (pContext.getNumberCreated() == 1)) {
                        msgBroker.addSuccessMessage("publication.success.created");
                    } else if (pContext.getNumberCreated() > 0) {
                        addSummaryMessage(pContext, msgBroker, "catalog.publication.uploadMetadata.summary.created",
                                ProcessedRecord.StatusType.CREATED, pContext.getNumberCreated());
                    }
                    if (wasSingleSource && (pContext.getNumberReplaced() == 1)) {
                        msgBroker.addSuccessMessage("publication.success.replaced");
                    } else if (pContext.getNumberReplaced() > 0) {
                        addSummaryMessage(pContext, msgBroker, "catalog.publication.uploadMetadata.summary.replaced",
                                ProcessedRecord.StatusType.REPLACED, pContext.getNumberReplaced());
                    }
                    if (wasSingleSource && (pContext.getNumberUnchanged() == 1)) {
                        msgBroker.addSuccessMessage("publication.success.unchanged");
                    } else if (pContext.getNumberUnchanged() > 0) {
                        addSummaryMessage(pContext, msgBroker, "catalog.publication.uploadMetadata.summary.unchanged",
                                ProcessedRecord.StatusType.UNCHNAGED, pContext.getNumberUnchanged());
                    }
                    if (pContext.getNumberDeleted() > 0) {
                        addSummaryMessage(pContext, msgBroker, "catalog.publication.uploadMetadata.summary.deleted",
                                ProcessedRecord.StatusType.DELETED, pContext.getNumberDeleted());
                    }

                    if (wasSingleSource && (pContext.getNumberFailed() == 1)) {
                        Exception lastException = pContext.getLastException();
                        if (pContext.getLastException() != null) {
                            throw lastException;
                        } else {
                            // TODO message here ??
                        }
                    } else if (pContext.getNumberFailed() > 0) {
                        addErrorMessages(pContext, msgBroker, "catalog.publication.uploadMetadata.summary.failed",
                                ProcessedRecord.StatusType.FAILED, pContext.getNumberFailed());
                    }

                }

            }

            // handle a validation exception
        } catch (ValidationException e) {

            String sKey = e.getKey();
            if (sKey.length() > 0) {
                String sMsg = sKey;
                Schema schema = context.getCatalogConfiguration().getConfiguredSchemas().get(sKey);
                if (schema != null) {
                    if (schema.getLabel() != null) {
                        String sResKey = schema.getLabel().getResourceKey();
                        if (sResKey.length() > 0) {
                            sMsg = extractMessageBroker().retrieveMessage(sResKey) + " (" + sKey + ")";
                        }
                    }
                }
                FacesMessage fm = new FacesMessage(FacesMessage.SEVERITY_WARN, " - " + sMsg, null);
                extractMessageBroker().addMessage(fm);
            }

            e.getValidationErrors().buildMessages(msgBroker, true);

            // handle remaining exceptions
        } catch (Exception e) {

      // there seems to be no good exception related to a file that is simply
            // not an XML file, a message containing "content is not allowed in prolog"
            // seems to be the best guess at the moment
            String sMsg = e.toString().toLowerCase();
            if (sMsg.indexOf("content is not allowed in prolog") != -1) {
                msgBroker.addErrorMessage("publication.uploadMetadata.err.file.prolog");
            } else {
                throw e;
            }

        }

    }

    /**
     * inner classes ===========================================================
     */

    /**
     * Stores session based upload options for the controller.
     */
    public static class UploadOptions {

        private String specificationMethod = UploadMetadataController.SPECIFICATIONMETHOD_BROWSE;

        /**
         * Gets the file specification method.
         *
         * @return the file specification method
         */
        public String getSpecificationMethod() {
            return this.specificationMethod;
        }

        /**
         * Sets the file specification method.
         *
         * @param method the file specification method
         */
        public void setSpecificationMethod(String method) {
            this.specificationMethod = Val.chkStr(method);
            if (!this.specificationMethod.equals(UploadMetadataController.SPECIFICATIONMETHOD_EXPLICIT)) {
                this.specificationMethod = UploadMetadataController.SPECIFICATIONMETHOD_BROWSE;
            }
        }

    }

}
