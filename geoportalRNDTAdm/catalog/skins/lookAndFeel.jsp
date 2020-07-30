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
<%
// Contains 'Look And Feel' declarations shared among all the pages
%>

<%
String VER = "v1";
String VER11 = "v1.1";
String VER112 = "v1.1.2";
String VER12 = "v1.2";
String VER121 = "v1.2.1";
String VER122 = "v1.2.2";
String VER123 = "v1.2.3";
String VER124 = "v1.2.4";
%>

<meta name="viewport" content="width=device-width,initial-scale=1">
<link rel="stylesheet" href="//js.arcgis.com/3.13/dijit/themes/tundra/tundra.css">
<link rel="stylesheet" type="text/css" href="//js.arcgis.com/3.12/esri/css/esri.css" />
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/catalog/skins/themes/rndt/main.css"  />
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/catalog/skins/themes/rndt/preview.css"  />
<% // Esri Italy Added grid style for collections %>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/catalog/skins/themes/rndt/grid.css"  />
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/catalog/skins/themes/rndt/metaCss.css"  />


<link rel="icon" type="image/x-icon"   href="<%=request.getContextPath()%>/catalog/images/favicon.ico" />
<link rel="shortcut icon" type="image/x-icon" href="<%=request.getContextPath()%>/catalog/images/favicon.ico" />

<% // Esri Italy deleted the locale parameter (bug)  %>
<script type="text/javascript">
  function readCookieTop(name) {
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

  djConfig = {parseOnLoad: true, locale: readCookieTop("geoportalLocale")};
</script>

<script type="text/javascript" src="<%=com.esri.gpt.framework.context.RequestContext.extract(request).getApplicationConfiguration().getInteractiveMap().getJsapiUrl()%>"></script>
<script type="text/javascript">
  esri.config.defaults.io.proxyUrl = "<%=request.getContextPath()%>/catalog/download/proxy.jsp";
</script>
<script type="text/javascript" src="<%=request.getContextPath()+"/catalog/js/" +VER+ "/GPTMapViewer.js"%>"></script>
<script type="text/javascript" src="<%=request.getContextPath()+"/catalog/js/" +VER12+ "/gpt.js"%>"></script>
<script type="text/javascript" src="<%=request.getContextPath()+"/catalog/js/" +VER+ "/Utils.js"%>"></script>
<script type="text/javascript" src="<%=request.getContextPath()+"/catalog/js/" +VER123+ "/livedata.js"%>"></script>
<script type="text/javascript" src="<%=request.getContextPath()+"/catalog/js/" +VER+ "/gpt-asn.js"%>"></script>
<script type="text/javascript" src="<%=request.getContextPath()+"/catalog/js/" +VER122+ "/gpt-browse.js"%>"></script>
<link href="https://fonts.googleapis.com/css?family=Source+Sans+Pro" rel="stylesheet">






