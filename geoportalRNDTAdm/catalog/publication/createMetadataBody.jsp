<%--
 See the NOTICE file distributed with
 this work for additional information regarding copyright ownership.
 Esri Inc. licenses this file to You under the Apache License, Version 2.0
 (the "License"); you may not use this file except in compliance with
 the License.  You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
--%>
<% // createMetadataBody.jsp - Create metadata page (JSF body) %>
<%@ taglib prefix="f" uri="http://java.sun.com/jsf/core" %>
<%@ taglib prefix="h" uri="http://java.sun.com/jsf/html" %>



<div class="container">
<h1 class="title_custom"><%=com.esri.gpt.framework.jsf.PageContext.extractMessageBroker(
                                                                          ).retrieveMessage("catalog.publication.createMetadata.caption")%></h1>

<h:form id="frmCreateMetadata" styleClass="fixedWidth">
<h:inputHidden value="#{EditMetadataController.prepareView}"/>

<% // prompt %>
<h:outputText escape="false" styleClass="prompt"
  value="#{gptMsg['catalog.publication.createMetadata.prompt']}"/>


  <div class="row">
    <div class="col-md-12">
        <div class="form-group">
          <% // on behalf of  - Esri Italy: disabled %>
		    <%--
          <h:outputLabel for="onBehalfOf" styleClass="requiredField"
            value="#{gptMsg['catalog.publication.uploadMetadata.label.onBehalfOf']}"/>
          <h:selectOneMenu id="onBehalfOf" styleClass="form-control customInput"
            value="#{EditMetadataController.selectablePublishers.selectedKey}">
            <f:selectItems value="#{EditMetadataController.selectablePublishers.items}"/>
          </h:selectOneMenu>
		    --%>
        </div>
        <div class="form-group">
        <% // schema %>
          <h:outputText styleClass="requiredField"
            value="#{gptMsg['catalog.publication.createMetadata.label.schema']}"/>
          <h:selectOneRadio id="schema" layout="pageDirection" styleClass="customRadio_inputSelect"
            value="#{EditMetadataController.createSchemaKey}">
            <f:selectItems value="#{EditMetadataController.createSchemaItems}"/>
          </h:selectOneRadio>

        </div>
        <div class="form-group">
        <% // submit button %>
          <h:outputText value=""/>
          <h:commandButton
            id="submit"
            value="#{gptMsg['catalog.publication.createMetadata.button.submit']}"
            action="#{EditMetadataController.getNavigationOutcome}"
            actionListener="#{EditMetadataController.processAction}">
            <f:attribute name="command" value="create"/>
          </h:commandButton>
        </div>


  
</h:form>
</div>
