﻿<?xml version="1.0" encoding="UTF-8"?>
<!--
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
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" xmlns:dct="http://purl.org/dc/terms/" xmlns:ows="http://www.opengis.net/ows" xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:srv="http://www.isotc211.org/2005/srv" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" exclude-result-prefixes="csw dct">
    <xsl:output method="text" indent="no" encoding="UTF-8"/>
    <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="/csw:GetRecordByIdResponse/ows:ExceptionReport">
        <exception>
          <exceptionText>
            <xsl:for-each select="/ows:ExceptionReport/ows:Exception">
              <xsl:value-of select="ows:ExceptionText"/>
            </xsl:for-each>
          </exceptionText>
        </exception>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="/csw:GetRecordByIdResponse/gmd:MD_Metadata | /csw:GetRecordByIdResponse/rdf:RDF"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="/csw:GetRecordByIdResponse/gmd:MD_Metadata | /csw:GetRecordByIdResponse/rdf:RDF">
   
             <!--..............................................Modified by ESRI Italy........................................-->
  <xsl:variable name="valid-Url" select="./gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource[gmd:linkage/gmd:URL!='']"/>
					 <xsl:for-each select="./rdf:Description/dct:references">
                        <xsl:value-of select="." />
                                <xsl:text>✔</xsl:text>
								urn:x-esri:specification:ServiceType:ArcIMS:Metadata:Server
								<xsl:text>✕</xsl:text>
                        </xsl:for-each>
                                <!--........................Link al servizio...............-->
                                <!--Questa lista serve ad ordinare i link ai servizi per tipologia-->
                            <xsl:for-each select="$valid-Url/gmd:linkage/gmd:URL[contains(translate(.,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'rest')]">
                                <xsl:value-of select="." />
                                <xsl:text>✔</xsl:text>
								urn:x-esri:specification:ServiceType:ArcIMS:Metadata:Server
								<xsl:text>✕</xsl:text>
                            </xsl:for-each>
                
                            <xsl:for-each select="$valid-Url/gmd:linkage/gmd:URL[contains(translate(.,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'wms')]">
                                <xsl:value-of select="." />
                                <xsl:text>✔</xsl:text>
								urn:x-esri:specification:ServiceType:ArcIMS:Metadata:Server
								<xsl:text>✕</xsl:text>
                            </xsl:for-each>
                            
                            <xsl:for-each select="$valid-Url/gmd:linkage/gmd:URL[contains(translate(.,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'wfs')]">
                                <xsl:value-of select="." />
                                <xsl:text>✔</xsl:text>
								urn:x-esri:specification:ServiceType:ArcIMS:Metadata:Server
								<xsl:text>✕</xsl:text>
                            </xsl:for-each>
                
                            <xsl:for-each select="$valid-Url/gmd:linkage/gmd:URL[contains(translate(.,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'wcs')]">
                                <xsl:value-of select="." />
                                <xsl:text>✔</xsl:text>
								urn:x-esri:specification:ServiceType:ArcIMS:Metadata:Server
								<xsl:text>✕</xsl:text>
                            </xsl:for-each>
                                
                            <xsl:for-each select="$valid-Url/gmd:linkage/gmd:URL[contains(translate(.,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'kml')]">
                                <xsl:value-of select="." />
                                <xsl:text>✔</xsl:text>
								urn:x-esri:specification:ServiceType:ArcIMS:Metadata:Server
								<xsl:text>✕</xsl:text>
                            </xsl:for-each>
                            
                            <xsl:for-each select="$valid-Url/gmd:linkage/gmd:URL[contains(translate(.,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'kmz')]">
                                <xsl:value-of select="." />
                                <xsl:text>✔</xsl:text>
								urn:x-esri:specification:ServiceType:ArcIMS:Metadata:Server
								<xsl:text>✕</xsl:text>
                            </xsl:for-each>
                                
                            <xsl:for-each select="./gmd:identificationInfo/srv:SV_ServiceIdentification/srv:containsOperations/srv:SV_OperationMetadata/srv:connectPoint/gmd:CI_OnlineResource/gmd:linkage/gmd:URL[contains(translate(.,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'rest')]">
                                <xsl:value-of select="." />
                                <xsl:text>✔</xsl:text>
								urn:x-esri:specification:ServiceType:ArcIMS:Metadata:Server
								<xsl:text>✕</xsl:text>
                            </xsl:for-each>
                
                            <xsl:for-each select="./gmd:identificationInfo/srv:SV_ServiceIdentification/srv:containsOperations/srv:SV_OperationMetadata/srv:connectPoint/gmd:CI_OnlineResource/gmd:linkage/gmd:URL[contains(translate(.,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'wms')]">
                                <xsl:value-of select="." />
                                <xsl:text>✔</xsl:text>
								urn:x-esri:specification:ServiceType:ArcIMS:Metadata:Server
								<xsl:text>✕</xsl:text>
                            </xsl:for-each>
                            
                            <xsl:for-each select="./gmd:identificationInfo/srv:SV_ServiceIdentification/srv:containsOperations/srv:SV_OperationMetadata/srv:connectPoint/gmd:CI_OnlineResource/gmd:linkage/gmd:URL[contains(translate(.,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'wfs')]">
                                <xsl:value-of select="." />
                                <xsl:text>✔</xsl:text>
								urn:x-esri:specification:ServiceType:ArcIMS:Metadata:Server
								<xsl:text>✕</xsl:text>
                            </xsl:for-each>
                
                            <xsl:for-each select="./gmd:identificationInfo/srv:SV_ServiceIdentification/srv:containsOperations/srv:SV_OperationMetadata/srv:connectPoint/gmd:CI_OnlineResource/gmd:linkage/gmd:URL[contains(translate(.,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'wcs')]">
                                <xsl:value-of select="." />
                                <xsl:text>✔</xsl:text>
								urn:x-esri:specification:ServiceType:ArcIMS:Metadata:Server
								<xsl:text>✕</xsl:text>
                            </xsl:for-each>
                                
                            <xsl:for-each select="./gmd:identificationInfo/srv:SV_ServiceIdentification/srv:containsOperations/srv:SV_OperationMetadata/srv:connectPoint/gmd:CI_OnlineResource/gmd:linkage/gmd:URL[contains(translate(.,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'kml')]">
                                <xsl:value-of select="." />
                                <xsl:text>✔</xsl:text>
								urn:x-esri:specification:ServiceType:ArcIMS:Metadata:Server
								<xsl:text>✕</xsl:text>
                            </xsl:for-each>
                            
                            <xsl:for-each select="./gmd:identificationInfo/srv:SV_ServiceIdentification/srv:containsOperations/srv:SV_OperationMetadata/srv:connectPoint/gmd:CI_OnlineResource/gmd:linkage/gmd:URL[contains(translate(.,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'kmz')]">
                                <xsl:value-of select="." />
                                <xsl:text>✔</xsl:text>
								urn:x-esri:specification:ServiceType:ArcIMS:Metadata:Server
								<xsl:text>✕</xsl:text>
                            </xsl:for-each>
    
                             <!--servizi generici-->
                             <xsl:for-each select="$valid-Url/gmd:linkage/gmd:URL">
                                <xsl:value-of select="." />
                                <xsl:text>✔</xsl:text>
								urn:x-esri:specification:ServiceType:ArcIMS:Metadata:Server
								<xsl:text>✕</xsl:text>
                            </xsl:for-each>
                             
                               <xsl:for-each select="./gmd:identificationInfo/srv:SV_ServiceIdentification/srv:containsOperations/srv:SV_OperationMetadata/srv:connectPoint/gmd:CI_OnlineResource/gmd:linkage/gmd:URL">
                                <xsl:value-of select="." />
                                <xsl:text>✔</xsl:text>
								urn:x-esri:specification:ServiceType:ArcIMS:Metadata:Server
								<xsl:text>✕</xsl:text>
                            </xsl:for-each>
                             <!--...........................Link al servizio END................-->
                                <xsl:for-each select="./gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:onlineResource/gmd:CI_OnlineResource/gmd:linkage/gmd:URL">
                                    <xsl:if test=".!=''">
                                        <xsl:value-of select="." />
                                        <xsl:text>✔</xsl:text>
								urn:x-esri:specification:ServiceType:ArcIMS:Metadata:Onlink
								<xsl:text>✕</xsl:text></xsl:if>
                                </xsl:for-each>
                <xsl:value-of select="./gmd:identificationInfo/gmd:MD_DataIdentification/gmd:graphicOverview/gmd:MD_BrowseGraphic/gmd:fileName/gco:CharacterString | ./gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:graphicOverview/gmd:MD_BrowseGraphic/gmd:fileName/gco:CharacterString"/>
                  <xsl:text>&#x2714;</xsl:text>
                  <xsl:text>http://www.isotc211.org/2005/gmd/MD_BrowseGraphic/filename</xsl:text>
                  <xsl:text>&#x2715;</xsl:text>   
              
                                   <xsl:if test="contains($valid-Url/gmd:protocol/gco:CharacterString,'WMS') or contains($valid-Url/gmd:protocol/gco:CharacterString,'REST') or contains($valid-Url/gmd:protocol/gco:CharacterString,'WFS') or contains($valid-Url/gmd:protocol/gco:CharacterString,'WCS') or contains($valid-Url/gmd:protocol/gco:CharacterString,'KML') or contains($valid-Url/gmd:protocol/gco:CharacterString,'MAP') or contains(./rdf:Description/dc:type,'WMS') or contains(./rdf:Description/dc:type,'REST') or contains(./rdf:Description/dc:type,'WFS') or contains(./rdf:Description/dc:type,'WCS') or contains(./rdf:Description/dc:type,'KML') or contains(./rdf:Description/dc:type,'MAP')">
                                    liveData
									<xsl:text>&#x2714;</xsl:text>
									urn:x-esri:specification:ServiceType:ArcIMS:Metadata:ContentType
									<xsl:text>&#x2715;</xsl:text>
                                    </xsl:if>
                                    <xsl:if test="contains($valid-Url/gmd:protocol/gco:CharacterString,'download') or contains(./rdf:Description/dc:type,'download')">
                                    downloadableData
									<xsl:text>&#x2714;</xsl:text>
									urn:x-esri:specification:ServiceType:ArcIMS:Metadata:ContentType
									<xsl:text>&#x2715;</xsl:text>
                                    </xsl:if>
                                    <xsl:if test="contains($valid-Url/gmd:protocol/gco:CharacterString,'DOC') or contains(./rdf:Description/dc:type,'DOC')">
                                    document
									<xsl:text>&#x2714;</xsl:text>
									urn:x-esri:specification:ServiceType:ArcIMS:Metadata:ContentType
									<xsl:text>&#x2715;</xsl:text>
                                    </xsl:if>
                                    <xsl:if test="contains($valid-Url/gmd:protocol/gco:CharacterString,'information') or contains(./rdf:Description/dc:type,'information')">
                                    offlineData
									<xsl:text>&#x2714;</xsl:text>
									urn:x-esri:specification:ServiceType:ArcIMS:Metadata:ContentType
									<xsl:text>&#x2715;</xsl:text>
                                    </xsl:if>
                                    <xsl:if test="contains($valid-Url/gmd:protocol/gco:CharacterString,'IMG') or contains(./rdf:Description/dc:type,'IMG')">
                                    staticMapImage
									<xsl:text>&#x2714;</xsl:text>
									urn:x-esri:specification:ServiceType:ArcIMS:Metadata:ContentType
									<xsl:text>&#x2715;</xsl:text>
                                    </xsl:if>
                                    <xsl:if test="contains($valid-Url/gmd:protocol/gco:CharacterString,'WEBAPP') or contains(./rdf:Description/dc:type,'WEBAPP')">
                                    application
									<xsl:text>&#x2714;</xsl:text>
									urn:x-esri:specification:ServiceType:ArcIMS:Metadata:ContentType
									<xsl:text>&#x2715;</xsl:text>
                                    </xsl:if>
                                    <xsl:if test="contains($valid-Url/gmd:protocol/gco:CharacterString,'TASK') or contains(./rdf:Description/dc:type,'TASK')">
                                    geographicActivities
									<xsl:text>&#x2714;</xsl:text>
									urn:x-esri:specification:ServiceType:ArcIMS:Metadata:ContentType
									<xsl:text>&#x2715;</xsl:text>
                                    </xsl:if>
                                    <xsl:if test="contains($valid-Url/gmd:linkage/gmd:URL,'WMS') or contains($valid-Url/gmd:linkage/gmd:URL,'REST') or contains($valid-Url/gmd:linkage/gmd:URL,'WFS') or contains($valid-Url/gmd:linkage/gmd:URL,'WCS') or contains($valid-Url/gmd:linkage/gmd:URL,'KML') or contains($valid-Url/gmd:linkage/gmd:URL,'KMZ') or contains($valid-Url/gmd:linkage/gmd:URL,'wms') or contains($valid-Url/gmd:linkage/gmd:URL,'rest') or contains($valid-Url/gmd:linkage/gmd:URL,'wfs') or contains($valid-Url/gmd:linkage/gmd:URL,'wcs') or contains($valid-Url/gmd:linkage/gmd:URL,'kml') or contains($valid-Url/gmd:linkage/gmd:URL,'kmz')">
                                    liveData
									<xsl:text>&#x2714;</xsl:text>
									urn:x-esri:specification:ServiceType:ArcIMS:Metadata:ContentType
									<xsl:text>&#x2715;</xsl:text>
									</xsl:if>
                                    <xsl:if test="contains(./gmd:identificationInfo/srv:SV_ServiceIdentification/srv:containsOperations/srv:SV_OperationMetadata/srv:connectPoint/gmd:CI_OnlineResource/gmd:linkage/gmd:URL,'WMS') or contains(./gmd:identificationInfo/srv:SV_ServiceIdentification/srv:containsOperations/srv:SV_OperationMetadata/srv:connectPoint/gmd:CI_OnlineResource/gmd:linkage/gmd:URL,'REST') or contains(./gmd:identificationInfo/srv:SV_ServiceIdentification/srv:containsOperations/srv:SV_OperationMetadata/srv:connectPoint/gmd:CI_OnlineResource/gmd:linkage/gmd:URL,'WFS') or contains(./gmd:identificationInfo/srv:SV_ServiceIdentification/srv:containsOperations/srv:SV_OperationMetadata/srv:connectPoint/gmd:CI_OnlineResource/gmd:linkage/gmd:URL,'WCS') or contains(./gmd:identificationInfo/srv:SV_ServiceIdentification/srv:containsOperations/srv:SV_OperationMetadata/srv:connectPoint/gmd:CI_OnlineResource/gmd:linkage/gmd:URL,'KML') or contains(./gmd:identificationInfo/srv:SV_ServiceIdentification/srv:containsOperations/srv:SV_OperationMetadata/srv:connectPoint/gmd:CI_OnlineResource/gmd:linkage/gmd:URL,'KMZ') or contains(./gmd:identificationInfo/srv:SV_ServiceIdentification/srv:containsOperations/srv:SV_OperationMetadata/srv:connectPoint/gmd:CI_OnlineResource/gmd:linkage/gmd:URL,'wms') or contains(./gmd:identificationInfo/srv:SV_ServiceIdentification/srv:containsOperations/srv:SV_OperationMetadata/srv:connectPoint/gmd:CI_OnlineResource/gmd:linkage/gmd:URL,'rest') or contains(./gmd:identificationInfo/srv:SV_ServiceIdentification/srv:containsOperations/srv:SV_OperationMetadata/srv:connectPoint/gmd:CI_OnlineResource/gmd:linkage/gmd:URL,'wfs') or contains(./gmd:identificationInfo/srv:SV_ServiceIdentification/srv:containsOperations/srv:SV_OperationMetadata/srv:connectPoint/gmd:CI_OnlineResource/gmd:linkage/gmd:URL,'wcs') or contains(./gmd:identificationInfo/srv:SV_ServiceIdentification/srv:containsOperations/srv:SV_OperationMetadata/srv:connectPoint/gmd:CI_OnlineResource/gmd:linkage/gmd:URL,'kml') or contains(./gmd:identificationInfo/srv:SV_ServiceIdentification/srv:containsOperations/srv:SV_OperationMetadata/srv:connectPoint/gmd:CI_OnlineResource/gmd:linkage/gmd:URL,'kmz')">
                                    liveData
									<xsl:text>&#x2714;</xsl:text>
									urn:x-esri:specification:ServiceType:ArcIMS:Metadata:ContentType
									<xsl:text>&#x2715;</xsl:text>
									</xsl:if>
                                    <xsl:if test=" contains($valid-Url/gmd:function/gmd:CI_OnLineFunctionCode,'download') or contains($valid-Url/gmd:function/gmd:CI_OnLineFunctionCode,'order')">
                                    downloadableData
									<xsl:text>&#x2714;</xsl:text>
									urn:x-esri:specification:ServiceType:ArcIMS:Metadata:ContentType
									<xsl:text>&#x2715;</xsl:text>
									</xsl:if>
                                    <xsl:if test=" contains($valid-Url/gmd:function/gmd:CI_OnLineFunctionCode,'search') or contains($valid-Url/gmd:function/gmd:CI_OnLineFunctionCode,'information')">
                                    application
									<xsl:text>&#x2714;</xsl:text>
									urn:x-esri:specification:ServiceType:ArcIMS:Metadata:ContentType
									<xsl:text>&#x2715;</xsl:text>
									</xsl:if>
                                    <xsl:if test=" contains($valid-Url/gmd:function/gmd:CI_OnLineFunctionCode,'offlineAccess') or contains($valid-Url/gmd:function/gmd:CI_OnLineFunctionCode,'offlineaccess')">
                                    offlineData
									<xsl:text>&#x2714;</xsl:text>
									urn:x-esri:specification:ServiceType:ArcIMS:Metadata:ContentType
									<xsl:text>&#x2715;</xsl:text>
									</xsl:if>
                
                                   <xsl:if test=" contains(./gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue,'series')">
                                    offlineData
									<xsl:text>&#x2714;</xsl:text>
									urn:x-esri:specification:ServiceType:ArcIMS:Metadata:ContentType
									<xsl:text>&#x2715;</xsl:text>
									</xsl:if>
                                    <xsl:if test=" contains(./gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue,'dataset')">
                                    downloadableData
									<xsl:text>&#x2714;</xsl:text>
									urn:x-esri:specification:ServiceType:ArcIMS:Metadata:ContentType
									<xsl:text>&#x2715;</xsl:text>
									</xsl:if>
                                    <xsl:if test=" contains(./gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue,'service')">
                                    liveData
									<xsl:text>&#x2714;</xsl:text>
									urn:x-esri:specification:ServiceType:ArcIMS:Metadata:ContentType
									<xsl:text>&#x2715;</xsl:text>
									</xsl:if>
  </xsl:template>
</xsl:stylesheet>
