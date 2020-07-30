<%--========================================-->
<%--This file has been changed by Esri Italy-->
<%--========================================-->

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
<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="tiles" uri="http://struts.apache.org/tags-tiles"  %>
<%@taglib uri="http://www.esri.com/tags-gpt" prefix="gpt" %>

<gpt:jscriptVariable quoted="true" value="#{SearchFilterSpatial.mvsUrl}" variableName="mainGptMvsUrl" id="cmPlGptMvsUrl"/>

<f:verbatim>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<link rel="search" type="application/opensearchdescription+xml" 
  title="<%=com.esri.gpt.framework.jsf.PageContext.extract().getResourceMessage("catalog.openSearch.shortName")%>"
  href="<%=request.getContextPath()%>/openSearchDescription" />

 <!--//Esri Italy October 2016: This part is used to select the language from a dropdown menu -->  
<link rel="stylesheet" href="<%=request.getContextPath()%>/catalog/js/jquery-ui-1.11.4/jquery-eu-cookie-law-popup.css">
<script src="<%=request.getContextPath()%>/catalog/js/v1/jquery-2.1.3.min.js"></script>
<script src="<%=request.getContextPath()%>/catalog/js/jquery-ui-1.11.4/jquery-eu-cookie-law-popup.js"></script>


<link rel="stylesheet" href="<%=request.getContextPath()%>/catalog/js/bootstrap/css/bootstrap.min.css">

<script src="<%=request.getContextPath()%>/catalog/js/bootstrap/js/bootstrap.min.js"></script>

<script>

function setCookie(cname, cvalue, exdays) {
    var d = new Date();
    d.setTime(d.getTime() + (exdays*24*60*60*1000));
    var expires = "expires="+ d.toUTCString();
    document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
}


$(document).ready(function(){
	var height = $(document).height();
	setInterval(function(){
		var height2 = $(document).height();
		if(height != height2){
			height=height2;
			setCookie("iframeHeightGeoportal",document.body.offsetHeight,1);
		}
	}, 500);
	
	setCookie("iframeHeightGeoportal",document.body.offsetHeight,1);
	
	setInterval(function(){window.parent.postMessage(document.body.offsetHeight,"*")},500);
});


</script>

<style type="text/css"> 
/* Resets */
nav a { 
    text-decoration: none;
    font: 12px/1 Verdana;
    color: #000;
	float: right;
    display: block; }
nav a:hover { text-decoration: underline; }
nav ul { 
    list-style: none;
    margin: 0;
	float: right;
    padding: 0; }
nav ul li { margin: 0; padding: 0; }

/* Top-level menu */
nav > ul > li { 
    float: left;
    position: relative; }
nav > ul > li > a { 
    border-left: 1px solid #000;
    display: block;}
nav > ul > li:first-child { margin: 0; }
nav > ul > li:first-child a { border: 0; }

/* Dropdown Menu */
nav ul li ul { 
    position: absolute;
    background: #ccc;
    width: 100%; 
    margin: 0;
    padding: 0;
    display: none; }
nav ul li ul li { 
    text-align: center;
    width: 100%; }
nav ul li ul a { padding: 0px 0; }
nav ul li:hover ul { display: block; }
  </style>

<script type="text/javascript">
function createCookie(name, value, days) {
    var expires;
    if (days) {
        var date = new Date();
        date.setTime(date.getTime()+(days*24*60*60*1000));
        expires = "; expires="+date.toGMTString();
    }
    else {
        expires = "";
    }
    document.cookie = name+"="+value+expires+"; path=/";
	document.location.href=document.location.href;
}

// Read cookie
function readCookie(name) {
    var nameEQ = name + "=";
    var ca = document.cookie.split(';');
    for(var i=0;i < ca.length;i++) {
        var c = ca[i];
        while (c.charAt(0) === ' ') {
            c = c.substring(1,c.length);
        }
        if (c.indexOf(nameEQ) === 0) {
            return c.substring(nameEQ.length,c.length);
        }
    }
    return 'it';
}

function eraseCookie(name) {
    createCookie(name,"",-1);
}

// End Esri Italy (function for language choice)

$(document).ready(function(){
	$("#cmPlPgpGptMessages span").each(function (i) {
		var htmlStr = $(this).html();
		$(this).html(htmlStr.replace(/&lt;br \/&gt;/g,'<br />'));
	});

// Esri Italy October 2016: This part is to handle language choice
		if ($(".eupopup").length > 0) {
/*
 * TOLTO COOCKIE NICOL
 		$(document).euCookieLawPopup().init({
			'info' : 'YOU_CAN_ADD_MORE_SETTINGS_HERE',
			'popupTitle' : '<%=com.esri.gpt.framework.jsf.PageContext.extract().getResourceMessage("catalog.openSearch.shortName")%>:',
			'popupText' : ' <%=com.esri.gpt.framework.jsf.PageContext.extract().getResourceMessage("catalog.openSearch.shortName")%>'
		});*/
	}

	$("#nav_eng").hide();
	$("#nav_it").hide();
	if ((document.location.href.indexOf("search.page") !== -1)||(document.location.href.indexOf("browse.page") !== -1)){
		if (readCookie('geoportalLocale')== 'it') {
			$("#nav_it").show();
			$("#nav_eng").hide();
		}else if (readCookie('geoportalLocale')== 'en') {
			$("#nav_eng").show();
			$("#nav_it").hide();
		} 
	}

//End Esri Italy
});

function openHelp(sTitle, sKey) {
	var sUrl = "<%=request.getContextPath()%>/webhelp/index.jsp";
	var sLang= "<%=com.esri.gpt.framework.jsf.PageContext.extract().getLanguage()%>";
	var sVers= "<%=com.esri.gpt.framework.jsf.PageContext.extract().getVersion()%>";
	if (sKey) sUrl += "?cmd="+sKey;
	if (sLang) {
	  if (sKey) {
	    sUrl += "&";
	  } else {
	    sUrl += "?";
	  }
	  sUrl += "lang="+sLang;
	}
	if (sVers) {
	  if (sKey || sLang) {
	    sUrl += "&";
	  } else {
	    sUrl += "?";
	  }
	  sUrl += "vers="+sVers;
	}
	var sOpt = "left=10,top=10,width=770,height=450";
	sOpt += ",toolbar=0,location=0,directories=0,status=0,resizable=yes,scrollbars=yes";
	var winHelp = window.open(sUrl,sTitle,sOpt);
	winHelp.focus();
}

function mainOpenHelp() {
	openHelp("GPT_Help", "toc");
}

function mainOpenInternalLink(oLink,sHref) {
	if (oLink && oLink.href && sHref) {
		oLink.href = "<%=request.getContextPath()%>/"+sHref;
	}
}

function mainOpenPageHelp() {
	openHelp("GPT_Context_Help", "<%=com.esri.gpt.framework.jsf.PageContext.extract().getPageId()%>");
}
// Global variable to be used for map viewer
var mainGptMapViewer = new GptMapViewer(mainGptMvsUrl);

/**
 * Opens the map viewer
 * @returns false always
 */
function mainOpenDefaultMapViewer() {
	if(!GptUtils.exists(mainGptMapViewer) || !GptUtils.exists(mainGptMapViewer.openDefaultMap)) {
		return false;
	}
	var win = mainGptMapViewer.openDefaultMap();
	if(GptUtils.exists(win) && GptUtils.exists(win.focus)) {
		win.focus();
	}
	return false;
}

</script>
</f:verbatim>