<?xml version="1.0" encoding="UTF-8"?>
<!-- Created with Liquid XML Studio Designer Edition 8.1.5.2538 (http://www.liquid-technologies.com) -->
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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" xmlns:ows="http://www.opengis.net/ows" xmlns:dct="http://purl.org/dc/terms/" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcmiBox="http://dublincore.org/documents/2000/07/11/dcmi-box/" xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gml="http://www.opengis.net/gml" xmlns:srv="http://www.isotc211.org/2005/srv">
    <xsl:output method="xml" indent="yes" encoding="UTF-8" omit-xml-declaration="no" />
    <xsl:template match="/">
        <xsl:choose>
            <xsl:when test="/ows:ExceptionReport">
                <exception>
                    <exceptionText>
                        <xsl:for-each select="/ows:ExceptionReport/ows:Exception">
                            <xsl:value-of select="ows:ExceptionText" />
                        </xsl:for-each>
                    </exceptionText>
                </exception>
            </xsl:when>
            <xsl:otherwise>
                <!--  Test -->
                <Records>
                    <xsl:attribute name="maxRecords">
                        <xsl:value-of select="/csw:GetRecordsResponse/csw:SearchResults/@numberOfRecordsMatched" />
                    </xsl:attribute>
                    <xsl:for-each select="/csw:GetRecordsResponse/csw:SearchResults/gmd:MD_Metadata">
                        <Record>
                            <ID>
                                <xsl:value-of select="gmd:fileIdentifier/gco:CharacterString" />
                            </ID>
                            <Title>
                                <xsl:value-of select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString|gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString" />
                            </Title>
                            <Abstract>
                                <xsl:value-of select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:abstract/gco:CharacterString|gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:abstract/gco:CharacterString" />
                            </Abstract>
                            <LowerCorner>
                                <xsl:value-of select="./gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:westBoundLongitude/gco:Decimal|./gmd:identificationInfo/srv:SV_ServiceIdentification/srv:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:westBoundLongitude/gco:Decimal" />
                                <xsl:value-of select="' '" />
                                <xsl:value-of select="./gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:southBoundLatitude/gco:Decimal|./gmd:identificationInfo/srv:SV_ServiceIdentification/srv:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:southBoundLatitude/gco:Decimal" />
                            </LowerCorner>
                            <UpperCorner>
                                <xsl:value-of select="./gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:eastBoundLongitude/gco:Decimal|./gmd:identificationInfo/srv:SV_ServiceIdentification/srv:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:eastBoundLongitude/gco:Decimal" />
                                <xsl:value-of select="' '" />
                                <xsl:value-of select="./gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:northBoundLatitude/gco:Decimal|./gmd:identificationInfo/srv:SV_ServiceIdentification/srv:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:northBoundLatitude/gco:Decimal" />
                            </UpperCorner>
                             <!--..............................................Modified by ESRI Italy........................................-->
                            <xsl:variable name="valid-Url" select="./gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource[gmd:linkage/gmd:URL!='']"/>
                            <References>
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
                            </References>
                            <xsl:value-of select="./gmd:identificationInfo/gmd:MD_DataIdentification/gmd:graphicOverview/gmd:MD_BrowseGraphic/gmd:fileName/gco:CharacterString | ./gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:graphicOverview/gmd:MD_BrowseGraphic/gmd:fileName/gco:CharacterString"/>
                  <xsl:text>&#x2714;</xsl:text>
                  <xsl:text>http://www.isotc211.org/2005/gmd/MD_BrowseGraphic/filename</xsl:text>
                  <xsl:text>&#x2715;</xsl:text>   
                            <Types>
                                   <xsl:if test="contains($valid-Url/gmd:protocol/gco:CharacterString,'WMS') or contains($valid-Url/gmd:protocol/gco:CharacterString,'REST') or contains($valid-Url/gmd:protocol/gco:CharacterString,'WFS') or contains($valid-Url/gmd:protocol/gco:CharacterString,'WCS') or contains($valid-Url/gmd:protocol/gco:CharacterString,'KML') or contains($valid-Url/gmd:protocol/gco:CharacterString,'MAP')">
                                    liveData
									<xsl:text>&#x2714;</xsl:text>
									urn:x-esri:specification:ServiceType:ArcIMS:Metadata:ContentType
									<xsl:text>&#x2715;</xsl:text>
                                    </xsl:if>
                                    <xsl:if test="contains($valid-Url/gmd:protocol/gco:CharacterString,'download')">
                                    downloadableData
									<xsl:text>&#x2714;</xsl:text>
									urn:x-esri:specification:ServiceType:ArcIMS:Metadata:ContentType
									<xsl:text>&#x2715;</xsl:text>
                                    </xsl:if>
                                    <xsl:if test="contains($valid-Url/gmd:protocol/gco:CharacterString,'DOC')">
                                    document
									<xsl:text>&#x2714;</xsl:text>
									urn:x-esri:specification:ServiceType:ArcIMS:Metadata:ContentType
									<xsl:text>&#x2715;</xsl:text>
                                    </xsl:if>
                                    <xsl:if test="contains($valid-Url/gmd:protocol/gco:CharacterString,'information')">
                                    offlineData
									<xsl:text>&#x2714;</xsl:text>
									urn:x-esri:specification:ServiceType:ArcIMS:Metadata:ContentType
									<xsl:text>&#x2715;</xsl:text>
                                    </xsl:if>
                                    <xsl:if test="contains($valid-Url/gmd:protocol/gco:CharacterString,'IMG')">
                                    staticMapImage
									<xsl:text>&#x2714;</xsl:text>
									urn:x-esri:specification:ServiceType:ArcIMS:Metadata:ContentType
									<xsl:text>&#x2715;</xsl:text>
                                    </xsl:if>
                                    <xsl:if test="contains($valid-Url/gmd:protocol/gco:CharacterString,'WEBAPP')">
                                    application
									<xsl:text>&#x2714;</xsl:text>
									urn:x-esri:specification:ServiceType:ArcIMS:Metadata:ContentType
									<xsl:text>&#x2715;</xsl:text>
                                    </xsl:if>
                                    <xsl:if test="contains($valid-Url/gmd:protocol/gco:CharacterString,'TASK')">
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
                                </Types>
                                <xsl:if test="contains($valid-Url/gmd:protocol/gco:CharacterString,'DOWNLOAD') or contains($valid-Url/gmd:protocol/gco:CharacterString,'LINK')">
                                 <Links>		
			                        <Link gptLinkTag="preview" show="false"/>
			                    </Links>
								</xsl:if>
                            <!--
							<xsl:for-each
								select="./gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource[gmd:protocol/gco:CharacterString='OGC:WMS']/gmd:linkage/gmd:URL">
								<References>
									<xsl:value-of select="." />
									<xsl:text>&#x2714;</xsl:text>
									urn:x-esri:specification:ServiceType:ArcIMS:Metadata:Server
									<xsl:text>&#x2715;</xsl:text>
								</References>
								<Types>
									liveData
									<xsl:text>&#x2714;</xsl:text>
									urn:x-esri:specification:ServiceType:ArcIMS:Metadata:ContentType
									<xsl:text>&#x2715;</xsl:text>
								</Types>
								<Type>liveData</Type>
							</xsl:for-each>
							<xsl:for-each
								select="./gmd:identificationInfo/srv:SV_ServiceIdentification/srv:containsOperations/srv:SV_OperationMetadata[srv:operationName/gco:CharacterString='GetCapabilities']/srv:connectPoint/gmd:CI_OnlineResource/gmd:linkage/gmd:URL">
								<References>
									<xsl:value-of select="." />
									<xsl:text>&#x2714;</xsl:text>
									urn:x-esri:specification:ServiceType:ArcIMS:Metadata:Server
									<xsl:text>&#x2715;</xsl:text>
								</References>
								<Types>
									liveData
									<xsl:text>&#x2714;</xsl:text>
									urn:x-esri:specification:ServiceType:ArcIMS:Metadata:ContentType
									<xsl:text>&#x2715;</xsl:text>
								</Types>
								<Type>liveData</Type>
							</xsl:for-each>
                            -->
                            <!--................................................Added By ESRI Italy................................................
                            <xsl:for-each
								select="./gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource[contains(gmd:protocol/gco:CharacterString,'OGC:WMS')]/gmd:linkage/gmd:URL">
								<References>
									<xsl:value-of select="." />
									<xsl:text>&#x2714;</xsl:text>
									urn:x-esri:specification:ServiceType:ArcIMS:Metadata:Server
									<xsl:text>&#x2715;</xsl:text>
								</References>
								<Types>
									liveData
									<xsl:text>&#x2714;</xsl:text>
									urn:x-esri:specification:ServiceType:ArcIMS:Metadata:ContentType
									<xsl:text>&#x2715;</xsl:text>
								</Types>
								<Type>liveData</Type>
							</xsl:for-each>
                            <xsl:for-each
								select="./gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource[contains(gmd:protocol/gco:CharacterString,'LINK')]/gmd:linkage/gmd:URL">
								<References>
									<xsl:value-of select="." />
									<xsl:text>&#x2714;</xsl:text>
									urn:x-esri:specification:ServiceType:ArcIMS:Metadata:Onlink
									<xsl:text>&#x2715;</xsl:text>
								</References>
								<Types>
									document
									<xsl:text>&#x2714;</xsl:text>
									urn:x-esri:specification:ServiceType:ArcIMS:Metadata:ContentType
									<xsl:text>&#x2715;</xsl:text>
								</Types>
								<Type>document</Type>
							</xsl:for-each>
                            <xsl:for-each
								select="./gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource[contains(gmd:protocol/gco:CharacterString,'DOWNLOAD')]/gmd:linkage/gmd:URL">
								<References>
									<xsl:value-of select="." />
									<xsl:text>&#x2714;</xsl:text>
									urn:x-esri:specification:ServiceType:ArcIMS:Metadata:Server
									<xsl:text>&#x2715;</xsl:text>
								</References>
                                <Types>
									downloadableData
									<xsl:text>&#x2714;</xsl:text>
									urn:x-esri:specification:ServiceType:ArcIMS:Metadata:ContentType
									<xsl:text>&#x2715;</xsl:text>
								</Types>
								<Type>downloadableData</Type>
                                <Links>		
			                        <Link gptLinkTag="preview" show="false"/>
			                    </Links>
							</xsl:for-each>
                            ................................................Added By ESRI Italy (END)................................................-->
                            <!--
                                <xsl:for-each
								select="./gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource[contains(gmd:protocol/gco:CharacterString,'DOWNLOAD') or contains(gmd:protocol/gco:CharacterString,'LINK')]/gmd:linkage/gmd:URL">
								<References>
									<xsl:value-of select="." />
									<xsl:text>&#x2714;</xsl:text>
									urn:x-esri:specification:ServiceType:ArcIMS:Metadata:Onlink
									<xsl:text>&#x2715;</xsl:text>
								</References>
								<Types>
									document
									<xsl:text>&#x2714;</xsl:text>
									urn:x-esri:specification:ServiceType:ArcIMS:Metadata:ContentType
									<xsl:text>&#x2715;</xsl:text>
								</Types>
								<Type>document</Type>
							</xsl:for-each>
                            
								<xsl:if
								test="count(./gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource[gmd:protocol/gco:CharacterString='OGC:WMS']/gmd:linkage/gmd:URL)
								+
								count(./gmd:identificationInfo/srv:SV_ServiceIdentification/srv:containsOperations/srv:SV_OperationMetadata[srv:operationName/gco:CharacterString='GetCapabilities'])>0">
								<References> <xsl:choose> <xsl:when
								test="count(./gmd:identificationInfo/srv:SV_ServiceIdentification/srv:containsOperations/srv:SV_OperationMetadata[srv:operationName/gco:CharacterString='GetCapabilities'])>0">
								<xsl:variable name="sUrl"
								select="./gmd:identificationInfo/srv:SV_ServiceIdentification/srv:containsOperations/srv:SV_OperationMetadata[srv:operationName/gco:CharacterString='GetCapabilities']/srv:connectPoint/gmd:CI_OnlineResource/gmd:linkage/gmd:URL"/>
								<xsl:variable name="sUrlUpper"
								select="translate($sUrl,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
								<xsl:value-of select="$sUrl"/> <xsl:if
								test="not(contains($sUrlUpper,'?'))"> <xsl:text>?</xsl:text>
								</xsl:if> <xsl:if
								test="not(contains($sUrlUpper,'=GETCAPABILITIES'))">
								<xsl:text>&amp;request=GetCapabilities</xsl:text> </xsl:if>
								<xsl:if test="not(contains($sUrlUpper,'=WMS'))">
								<xsl:text>&amp;service=WMS</xsl:text> </xsl:if> <xsl:if
								test="not(contains($sUrlUpper,'VERSION='))">
								<xsl:text>&amp;version=1.3.0</xsl:text> </xsl:if> </xsl:when>
								<xsl:otherwise> <xsl:value-of
								select="gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource[gmd:protocol/gco:CharacterString='OGC:WMS']/gmd:linkage/gmd:URL"/>
								</xsl:otherwise> </xsl:choose>
								<xsl:text>&#x2714;</xsl:text>urn:x-esri:specification:ServiceType:ArcIMS:Metadata:Server<xsl:text>&#x2715;</xsl:text>
								</References>
								<Types>liveData<xsl:text>&#x2714;</xsl:text>urn:x-esri:specification:ServiceType:ArcIMS:Metadata:ContentType<xsl:text>&#x2715;</xsl:text>
								</Types> <Type>liveData</Type> </xsl:if>
							-->
                        </Record>
                    </xsl:for-each>
                </Records>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
