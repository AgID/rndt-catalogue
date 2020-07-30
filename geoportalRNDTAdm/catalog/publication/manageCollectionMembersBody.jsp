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
<%@page import="com.esri.gpt.framework.context.RequestContext"%>
<%@page import="com.esri.gpt.framework.security.principal.Publisher"%>
	<%
		RequestContext context = null;
			context = RequestContext.extract(request);
			Publisher p = new Publisher(context);
			if (p.getIsAdministrator()) {
			} else {
				response.sendRedirect("../main/home.page");
			}		
	%>

<% // manageCollectionMembersBody.jsp - manage user roles (JSF body) %>
<%@ taglib prefix="f" uri="http://java.sun.com/jsf/core" %>
<%@ taglib prefix="h" uri="http://java.sun.com/jsf/html" %>
<%@ taglib prefix="gpt" uri="http://www.esri.com/tags-gpt"%>


<link rel="stylesheet" href="<%=request.getContextPath()%>/catalog/js/jquery-ui-1.11.4/jquery-ui.css">
<script src="<%=request.getContextPath()%>/catalog/js/v1/jquery-2.1.3.min.js"></script>
<script src="<%=request.getContextPath()%>/catalog/js/jquery-ui-1.11.4/jquery-ui.js"></script>
<style type="text/css">
	#hint{
		cursor:pointer;
	}
	.tooltip{
		margin:8px;
		padding:2px;
		border:1px solid blue;
		background-color:beige;
		position: absolute;
		z-index: 2;
	}
</style>
<script>
         //Variable for selected Collection
	var curID='';
	var curTitle='';
        
        //Function to check data value from insert dialog
        function validateInsert(){ 
            //Ok can insert
            if (document.getElementById('insert_update:IDForm').value!='' && document.getElementById('insert_update:TitleForm').value!='') { 
                return true; 
            } else { 
                //Show message 
                showMessage(document.getElementById('s2').value,document.getElementById('s9').value);
                return false;  
            } 
        } 
        
        //Function to replace string
        function replaceAll(find, replace, str) {
            return str.replace(new RegExp(find, 'g'), replace);
        }
        //Function to check delete collection
        function validate() { 
            //Check if one collection is selected
            if (curID!='' && curTitle!='') { 
                //Set hidden parameter value
                document.getElementById('azioni:IDC').value = curID;
                document.getElementById('azioni:TITLEC').value = curTitle;
                //Show message for confirm delete
                var numeroRisorse = document.getElementById('s6').value;
                if (document.getElementById("hiddenForm:hidden_numeroRisorse").value!="0"){
                    numeroRisorse = document.getElementById('s8').value;
                    numeroRisorse = replaceAll("\\{0\\}",document.getElementById("hiddenForm:hidden_numeroRisorse").value,numeroRisorse );
                }
                confirmDelete(numeroRisorse,document.getElementById('s10').value);
                return true; 

            } else { 
                //Show message for select one collection
                showMessage(document.getElementById('s7').value,document.getElementById('s9').value);
                return false;
            } 
        } 
        
        //Function to display dialog for insert one collection
        function showInsertForm(){ 
            //Setting value for dialog
            document.getElementById('insert_update').style.visibility="visible";
            document.getElementById('insert_update:IDForm').value = "";
            document.getElementById('insert_update:TitleForm').value = "";
            document.getElementById('insert_update:IDForm').disabled=false;
            
            //Setting dialog value
            var dialogDiv = $('#change_data');
            dialogDiv.attr("Title", document.getElementById('s14').value);
            $("#change_data").dialog({
                autoOpen: false,
                height: 200,
                width: 300,
                modal: true,
                buttons: [{
                    text: "Add",
                    "id": "btnOk",
                    click: function () {
                        if (validateInsert()) document.getElementById("insert_update:ButtonFormadd").click();
                        },

                    }, {
                    text: "Cancel",
                    "id": "btnCancelAdd",
                    click: function () {
                        //cancelCallback();
                        dialogDiv.dialog( "close" );
                        }
                    }],
                close: function () {
                    //do something
                    dialogDiv.dialog( "close" );
                }    
            });
            $("#btnOk").html('<span class="ui-button-text">'+ document.getElementById('s11').value +'</span>')            
            $("#btnCancelAdd").html('<span class="ui-button-text">'+ document.getElementById('s16').value +'</span>')            
            dialogDiv.dialog("open");
        }
        
        //Function for update the collection selected
        function  showUpdateForm(){ 
            //Check if one collection is selected
            if (curID!='' && curTitle!='') { 
                //Setting hidden parameter
                document.getElementById('insert_update:IDForm').value = curID;
                document.getElementById('insert_update:IDFormUpdate').value = curID;
                document.getElementById('insert_update:IDForm').disabled=true;
                document.getElementById('insert_update:TitleForm').value = curTitle;
                document.getElementById('insert_update').style.visibility="visible";
                document.getElementById('insert_update:IDForm').readonly=true;
                var dialogDiv = $('#change_data');
                dialogDiv.attr("Title", document.getElementById('s15').value);
                $("#change_data").dialog({
                    autoOpen: false,
                    height: 200,
                    width: 300,
                    modal: true,
                    buttons: [{
                        text: "Update",
                        "id": "btnOkUpd",
                        click: function () {
                            document.getElementById("insert_update:ButtonFormUpdate").click();
                            },

                        }, {
                        text: "Cancel",
                        "id": "btnCancelUpd",
                        click: function () {
                            //cancelCallback();
                            dialogDiv.dialog( "close" );
                            }
                        }],
                    close: function () {
                        //do something
                        dialogDiv.dialog( "close" );
                    }    
                });
                $("#btnOkUpd").html('<span class="ui-button-text">'+ document.getElementById('s12').value +'</span>')            
                $("#btnCancelUpd").html('<span class="ui-button-text">'+ document.getElementById('s16').value +'</span>')            
                dialogDiv.dialog("open");
            } else { 
                //Show message for select one collection
                showMessage(document.getElementById('s7').value,"Messaggio");
            }
        }
        
        //Function executed on load page for select row
        function addOnclickToDatatableRows() {
			
             //gets all the generated rows in the html table
            var trs = document.getElementById("formResource:resourceTable").rows;
            //on every row, add onclick function (this is what you're looking for)
            for (var i = 0; trs.length > i; i++) {
                var riga=trs[i];
                for (var j = 0;riga.cells.length > j; j++) {
                    //riga.cells[j].onclick = new Function("rowOnclick(this);");
                    $(riga.cells[j]).bind({
                        mousemove : changeTooltipPosition,
                        mouseenter : showTooltip,
                        mouseleave: hideTooltip,
                    });
                }
            }
 
            trs = document.getElementById("formPricipale:collectionTable").rows;
             //on every row, add onclick function (this is what you're looking for)
             for (var i = 0; trs.length > i; i++) {
                 var riga=trs[i];
                 for (var j = 0;riga.cells.length > j; j++) {
                    //riga.cells[j].onclick = new Function("rowOnclick(this);");
                    $(riga.cells[j]).bind({
                        mousemove : changeTooltipPosition,
                        mouseenter : showTooltip,
                        mouseleave: hideTooltip,
                        click:rowOnclickV
                     });
                 }
             }
             curID=document.getElementById("hiddenForm:hidden_localSelectedID").value;
             curTitle=document.getElementById("hiddenForm:hidden_localSelectedTitle").value;
             if (curID!="") findRow();
            
            /*var table = document.getElementById('formPricipale:collectionTable');
            var headers = table.getElementsByTagName('th');
            headers[0].width="10%";
            headers[1].width="90%";
               
            table = document.getElementById('formResource:resourceTable');
            headers = table.getElementsByTagName('th');
            headers[0].width="10%";
            headers[1].width="90%";*/
        }
        
	var changeTooltipPosition = function(event) {
	  $('div.tooltip').css({top: (event.pageY + 8), left: (event.pageX - 8)});
	};
 
	var showTooltip = function(event) {
	  $('div.tooltip').remove();
          var valore="";
            for( var x = 0 ; x < this.childNodes.length ; x++ ){
                try {
                    if (this.childNodes[x].id.indexOf('hidden_id_1')>-1){
                        valore=this.childNodes[x].value;
                    }
                    if (this.childNodes[x].id.indexOf('hidden_title_2')>-1){
                        valore=this.childNodes[x].value;
                    }
                } catch(err) {
                }  
            }
   	  $('<div class="tooltip">' + valore + '</div>')
            .appendTo('body');
	  changeTooltipPosition(event);
	};
 
	var hideTooltip = function() {
	   $('div.tooltip').remove();
	};
 
    
        //Function for find the row on the table that contains curID
        function findRow(){
            var trs = document.getElementById("formPricipale:collectionTable").rows;
            //on every row, add onclick function (this is what you're looking for)
            for (var i = 0; trs.length > i; i++) {
                var riga=trs[i];
                var trovato=false
                for (var j = 0;riga.cells.length > j; j++) {
                    for( var x = 0 ; x < riga.cells[j].childNodes.length ; x++ ){
                        try {
                            if (riga.cells[j].childNodes[x].id.indexOf('hidden_id_')>-1){
                                if (curID==riga.cells[j].childNodes[x].value){
                                    trovato=true;
                                    var cella = riga.cells[j];//.className="selectedColl";
                                    cella.style.backgroundColor="darkgray"
                                }
                            }
                        } catch(err) {
                        }  
                    }
                }
                if (trovato) {
                    //$("#formPricipale:collectionTable").rows[i].removeAttr('class');
 //                   $("#formPricipale:collectionTable").rows[i].removeClass();
                    //riga.addClass('selectedColl');
                }
            }
        }
        
        //Function to get value from the row hidden parameter
        var rowOnclickV= function rowOnclick() {
            var eleChild = this.childNodes;
            var i;
            curID='';
            curTitle='';
            this.class='selectedColl';
            for( i = 0 ; i < eleChild.length ; i++ ){
                if (eleChild[i].id.indexOf('hidden_id_')>-1){
                    curID=eleChild[i].value;
                }
                if (eleChild[i].id.indexOf('hidden_title_')>-1){
                    curTitle=eleChild[i].value;
                }
                if (eleChild[i].id.indexOf('show_')>-1){
                   eleChild[i].click();
                }
            }
        };
        
        window.onload=addOnclickToDatatableRows;
        
        //Function to show message
        function showMessage(stringa,titolo){
            $("#messaggi_from_server").empty();
            $("#messaggi_from_server").append("<span class='label label-important'>"+stringa+'</span>');
            var dialogDiv = $('#messaggi_from_server');
            document.getElementById('messaggi_from_server').style.visibility="visible";
            dialogDiv.attr("Title",titolo);
            $("#messaggi_from_server").dialog({
                autoOpen: false,
                height: 200,
                width: 300,
                modal: true,
                buttons: {
                    "Ok": function() {
                        dialogDiv.dialog( "close" );
                    }
                }
            });
            dialogDiv.dialog("open");
        }
        
        //Function to show confirm message
        function confirmDelete(stringa,titolo){
            $("#messaggi_from_server").empty();
            $("#messaggi_from_server").append("<span class='label label-important'>"+stringa+'</span>');
            var dialogDiv = $('#messaggi_from_server');
            document.getElementById('messaggi_from_server').style.visibility="visible";
            dialogDiv.attr("Title",titolo);
            $("#messaggi_from_server").dialog({
                autoOpen: false,
                height: 200,
                width: 300,
                modal: true,
                   buttons: [{
                        text: "Ok",
                        click: function () {
                            document.getElementById('azioni:cancellaDato').click();
                            dialogDiv.dialog( "close" );
                            },

                        }, {
                        text: "Cancel",
                        "id": "btnCancelCancel",
                        click: function () {
                            //cancelCallback();
                            dialogDiv.dialog( "close" );
                            }
                        }],
                    close: function () {
                        //do something
                        dialogDiv.dialog( "close" );
                    }    
                });
                $("#btnCancelCancel").html('<span class="ui-button-text">'+ document.getElementById('s16').value +'</span>')            
                dialogDiv.dialog("open");
            }
</script>
        
<% // records section %>
<h:form id="hiddenForm" style="display:none">
	<h:inputHidden id="btn_Role" value="#{PageContext.roleMap['gptAdministrator']}"/>
    <h:commandButton id="btnLoad" value="Load" style="visibility:hidden" action="#{Collection.refreshData}" />
    <h:inputHidden id='hidden_localSelectedID' value='#{Collection.localSelectedID}'/>
    <h:inputHidden id='hidden_localSelectedTitle' value='#{Collection.localSelectedTitle}'/>
    <h:inputHidden id='hidden_numeroRisorse' value='#{CollectionData.numDati}'/>
</h:form>

<h:panelGrid columns="2"  >
    <h:panelGroup id="primoGruppo">
        <h2><h:outputText value="#{gptMsg['catalog.publication.manage.collection.members.name']}" /></h2>
        <div style="height:330px; width:300px; overflow-x:auto;overflow-y:auto;">
            <h:form id="formPricipale">
                <h:dataTable value="#{Collection.collectionList}" var="o"
                    styleClass="gridC"
                    id="collectionTable"
                    rowClasses="rowOdd,rowEven"
                    columnClasses=",actionColumnStyle,,,,,,,"
                    cellspacing="0"
                    cellpadding="2">
                    <h:column>
                        <f:facet name="header">
                            <h:outputText value="#{gptMsg['catalog.publication.manage.collection.members.caption.ID']}" />
                        </f:facet>
                        <h:inputHidden id='hidden_id_1' value='#{o.ID}'/>
                        <h:inputHidden id='hidden_title_1' value='#{o.TITLE}'/>
                        <h:commandLink style="text-decoration: none;color: black;" id="show_1" action="#{CollectionData.showSomething}">
                            <f:setPropertyActionListener target="#{CollectionData.idPadre}" value="#{o.ID}" />
                            <f:setPropertyActionListener target="#{Collection.localSelectedID}" value="#{o.ID}" />
                            <f:setPropertyActionListener target="#{Collection.localSelectedTitle}" value="#{o.TITLE}" />
                            <f:setPropertyActionListener target="#{Collection.message}" value="" />
                        </h:commandLink>
                        <h:outputText id="nome_1" value="#{o.IDTrunched}" />
                    </h:column>

                    <h:column>
                        <f:facet name="header">
                            <h:outputText value="#{gptMsg['catalog.publication.manage.collection.members.caption.title']}" />
                        </f:facet>
                        <h:inputHidden id='hidden_id_2' value='#{o.ID}'/>
                        <h:inputHidden id='hidden_title_2' value='#{o.TITLE}'/>
                        <h:commandLink style="text-decoration: none;color: black;" id="show_2" action="#{CollectionData.showSomething}">
                            <f:setPropertyActionListener target="#{CollectionData.idPadre}" value="#{o.ID}" />
                            <f:setPropertyActionListener target="#{Collection.localSelectedID}" value="#{o.ID}" />
                            <f:setPropertyActionListener target="#{Collection.localSelectedTitle}" value="#{o.TITLE}" />
                            <f:setPropertyActionListener target="#{Collection.message}" value="" />
                        </h:commandLink>
                        <h:outputText id="nome_2" value="#{o.TITLE}" />
                     </h:column>
                </h:dataTable>
            </h:form>
        </div>
    </h:panelGroup >


    <h:panelGroup id="secondoGruppo">
        <h2><h:outputText value="#{gptMsg['catalog.publication.manage.collection.members.resourcename']} (#{CollectionData.numDati})" /></h2>
        <div style="height:330px; width:500px; overflow-x:auto;overflow-y:auto;">
            <h:form id="formResource">
                <h:dataTable value="#{CollectionData.collectionList}" var="o"
                    styleClass="gridC"
                    id="resourceTable"
                    rowClasses="rowOdd,rowEven"
                    columnClasses=",actionColumnStyle,,,,,,,"
                    cellspacing="0"
                    cellpadding="2">
                    <h:column>
                        <f:facet name="header">
                            <h:outputText value="#{gptMsg['catalog.publication.manage.collection.members.caption.ID']}" />
                        </f:facet>
                        <h:inputHidden id='hidden_id_1' value='#{o.ID}'/>
                        <h:inputHidden id='hidden_title_1' value='#{o.TITLE}'/>
                        <h:outputText value="#{o.IDTrunched}"/>
                    </h:column>
                    <h:column>
                        <f:facet name="header">
                            <h:outputText value="#{gptMsg['catalog.publication.manage.collection.members.caption.title']}" />
                        </f:facet>
                        <h:inputHidden id='hidden_id_2' value='#{o.ID}'/>
                        <h:inputHidden id='hidden_title_2' value='#{o.TITLE}'/>
                        <h:outputText value="#{o.TITLE}"/>
                    </h:column>
                </h:dataTable>
            </h:form>
        </div>
    </h:panelGroup >
</h:panelGrid>

<br>

<h:inputHidden id="SHOW" value="#{Collection.show}" />
<h:inputHidden id="s1" value="#{gptMsg['catalog.publication.manage.collection.members.message1']}"/>
<h:inputHidden id="s2" value="#{gptMsg['catalog.publication.manage.collection.members.message2']}"/>
<h:inputHidden id="s3" value="#{gptMsg['catalog.publication.manage.collection.members.message3']}"/>
<h:inputHidden id="s4" value="#{gptMsg['catalog.publication.manage.collection.members.message4']}"/>
<h:inputHidden id="s5" value="#{gptMsg['catalog.publication.manage.collection.members.message5']}"/>
<h:inputHidden id="s6" value="#{gptMsg['catalog.publication.manage.collection.members.message6']}"/>
<h:inputHidden id="s7" value="#{gptMsg['catalog.publication.manage.collection.members.message7']}"/>
<h:inputHidden id="s8" value="#{gptMsg['catalog.publication.manage.collection.members.message8']}"/>
<h:inputHidden id="s9" value="#{gptMsg['catalog.publication.manage.collection.members.message9']}"/>
<h:inputHidden id="s10" value="#{gptMsg['catalog.publication.manage.collection.members.message10']}"/>
<h:inputHidden id="s11" value="#{gptMsg['catalog.publication.manage.collection.members.message11']}"/>
<h:inputHidden id="s12" value="#{gptMsg['catalog.publication.manage.collection.members.message12']}"/>
<h:inputHidden id="s13" value="#{gptMsg['catalog.publication.manage.collection.members.message13']}"/>
<h:inputHidden id="s14" value="#{gptMsg['catalog.publication.manage.collection.members.message14']}"/>
<h:inputHidden id="s15" value="#{gptMsg['catalog.publication.manage.collection.members.message15']}"/>
<h:inputHidden id="s16" value="#{gptMsg['catalog.general.dialog.cancel']}"/>

<h:form id="azioni">
    <h:inputHidden  id="IDC" value="#{Collection.localID}" />
    <h:inputHidden  id="TITLEC" value="#{Collection.localTitle}" />
    <h:inputHidden  id="MESSAGGIO" value="#{Collection.message}" />
    <div align="center">
        <h:commandButton type="button"  value="#{gptMsg['catalog.publication.manage.collection.members.message11']}" action="null"  onclick="showInsertForm();"  />
        <h:commandButton type="button" value="#{gptMsg['catalog.publication.manage.collection.members.message12']}" action="null"  onclick="showUpdateForm();"  />
        <h:commandButton type="button" value="#{gptMsg['catalog.publication.manage.collection.members.message13']}" action="#{Collection.deleteCollection}"  onclick="validate();"  />
    </div>
    <h:commandButton style="visibility:hidden" value="Delete" id="cancellaDato" action="#{Collection.deleteCollection}"  />
</h:form>


<div id="change_data" name="change_data" style="background-color:graytext; visibility:hidden;display: none; ">
    <h:form id="insert_update" style="visibility: hidden">
            <table>
            <tr>
                <td><h:outputText value="ID:"/></td>
                    <td><h:inputText id="IDForm" maxlength="38" size="20" value="#{Collection.localID}" />
                        <h:inputHidden id="IDFormUpdate" value="#{Collection.localUpdateID}" />
                    </td>
            </tr>
            <tr>
                    <td><h:outputText value="Nome :"/></td>
                    <td><h:inputText id="TitleForm"  maxlength="128"  size="20" value="#{Collection.localTitle}" /></td>
            </tr>
            </table>

            <h:commandButton id="ButtonFormadd"  style="visibility:hidden" value="Add" action="#{Collection.addAction}" onclick="validateInsert();" />
            <h:commandButton id="ButtonFormUpdate" style="visibility:hidden" value="Update" action="#{Collection.updateCollection}" onclick="validateInsert();" />
    </h:form>
</div>


<div id="messaggi_from_server" name="messaggi_from_server" style="background-color:gainsboro; visibility:hidden;display: none; ">

</div>

<h:panelGroup rendered="#{Collection.show}">
    <script>
        var stringa="";
        switch (document.getElementById('azioni:MESSAGGIO').value) {
            case "1":
                stringa=document.getElementById('s1').value;
                break;
            case "2":
                stringa=document.getElementById('s2').value;
                break;
            case "3":
                stringa=document.getElementById('s3').value;
                break;
            case "4":
                stringa=document.getElementById('s4').value;
                break;
            case "5":
                stringa=document.getElementById('s5').value;
                break;
         }
           if (stringa !='') showMessage(stringa,"Messaggio");
	</script>

</h:panelGroup>
