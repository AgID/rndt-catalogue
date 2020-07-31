<?xml version="1.0" encoding="UTF-8"?>
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
<xsl:stylesheet version="1.0"  
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  
		xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" 
		xmlns:dct="http://purl.org/dc/terms/" 
		xmlns:ows="http://www.opengis.net/ows" 
		xmlns:dc="http://purl.org/dc/elements/1.1/" 
		xmlns:gmd="http://www.isotc211.org/2005/gmd" 
		xmlns:gco="http://www.isotc211.org/2005/gco" 
		xmlns:srv="http://www.isotc211.org/2005/srv" 
		xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
		xmlns:gfc="http://www.isotc211.org/2005/gfc"
		xmlns:dpc="http://dpc/schemas/dpc"
		xmlns:dcat="http://www.w3.org/ns/dcat#">
	<!--
		exclude-result-prefixes="csw dc dct ows">
		-->
	<xsl:output method="xml" indent="no"  encoding="UTF-8" omit-xml-declaration="yes" />
	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="/ows:ExceptionReport">
				<exception>
					<exceptionText>
						<xsl:for-each select="/ows:ExceptionReport/ows:Exception">
							<xsl:value-of select="ows:ExceptionText"/>
						</xsl:for-each>
					</exceptionText>
				</exception>
			</xsl:when>
			<xsl:otherwise>
				<Records>
					<xsl:attribute name="maxRecords">
						<xsl:value-of select="/csw:GetRecordsResponse/csw:SearchResults/@numberOfRecordsMatched"/>
					</xsl:attribute>
					<xsl:for-each select="/csw:GetRecordsResponse/csw:SearchResults/gmd:MD_Metadata | /csw:GetRecordByIdResponse/gmd:MD_Metadata | /csw:GetRecordsResponse/csw:SearchResults/rdf:RDF | /csw:GetRecordByIdResponse/rdf:RDF | /csw:GetRecordsResponse/csw:SearchResults/gfc:FC_FeatureCatalogue | csw:GetRecordByIdResponse/gfc:FC_FeatureCatalogue">
						<Record>
							<ID>
								<xsl:value-of select="./gmd:fileIdentifier/gco:CharacterString | ./rdf:Description/dc:identifier | ./dpc:fileIdentifier/gco:CharacterString | ./dcat:Dataset/dct:identifier"/>
							</ID>
							<Title>
								<xsl:value-of select="./gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString | ./gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString | ./rdf:Description/dc:title | ./gfc:name/gco:CharacterString | ./dcat:Dataset/dct:title"/>
							</Title>
							<Abstract>
								<xsl:value-of select="./gmd:identificationInfo/gmd:MD_DataIdentification/gmd:abstract/gco:CharacterString | ./gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:abstract/gco:CharacterString | ./rdf:Description/dc:description | ./gfc:scope/gco:CharacterString | ./dcat:Dataset/dct:description"/>
							</Abstract>
							<!-- If hierarchyLevel is empty then assign "dataset" -->
							<Type>
								<xsl:variable name="hlevel" select="./gmd:hierarchyLevel/gmd:MD_ScopeCode/text()[count(./gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue)=0] | ./gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue[count(./gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue)>0] | ./rdf:Description/dc:type"/>
								<xsl:if test="not($hlevel)">
									dataset
								</xsl:if>
								<xsl:if test="$hlevel">
									<xsl:value-of select="$hlevel"/>
								</xsl:if>
							</Type>
<!--
							<Type>
								<xsl:value-of select="./gmd:hierarchyLevel/gmd:MD_ScopeCode/text()[count(./gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue)=0] | ./gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue[count(./gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue)>0] | ./rdf:Description/dc:type | ./gfc:versionDate/gco:CharacterString"/>
							</Type>
-->
							<LowerCorner>
								<xsl:value-of select="./rdf:Description/ows:WGS84BoundingBox/ows:LowerCorner"/>
								<xsl:value-of select="./gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:westBoundLongitude/gco:Decimal | ./gmd:identificationInfo/srv:SV_ServiceIdentification/srv:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:westBoundLongitude/gco:Decimal"/>
								<xsl:text/>
								<xsl:value-of select="./gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:southBoundLatitude/gco:Decimal | ./gmd:identificationInfo/srv:SV_ServiceIdentification/srv:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:southBoundLatitude/gco:Decimal"/>
							</LowerCorner>

							<UpperCorner>
								<xsl:value-of select="./rdf:Description/ows:WGS84BoundingBox/ows:UpperCorner"/>
								<xsl:value-of select="./gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:eastBoundLongitude/gco:Decimal | ./gmd:identificationInfo/srv:SV_ServiceIdentification/srv:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:eastBoundLongitude/gco:Decimal"/>
								<xsl:text/>
								<xsl:value-of select="./gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:northBoundLatitude/gco:Decimal | ./gmd:identificationInfo/srv:SV_ServiceIdentification/srv:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:northBoundLatitude/gco:Decimal"/>
							</UpperCorner>

							<MaxX>
								<xsl:value-of select="./gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:eastBoundLongitude/gco:Decimal | ./gmd:identificationInfo/srv:SV_ServiceIdentification/srv:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:eastBoundLongitude/gco:Decimal"/>
								<xsl:value-of select="normalize-space(substring-before(./rdf:Description/ows:WGS84BoundingBox/ows:UpperCorner, ' '))"/>      
							</MaxX>
							<MaxY>
								<xsl:value-of select="./gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:northBoundLatitude/gco:Decimal | ./gmd:identificationInfo/srv:SV_ServiceIdentification/srv:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:northBoundLatitude/gco:Decimal"/>
								<xsl:value-of select="normalize-space(substring-after(./rdf:Description/ows:WGS84BoundingBox/ows:UpperCorner, ' '))"/>
							</MaxY>
							<MinX>
								<xsl:value-of select="./gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:westBoundLongitude/gco:Decimal | ./gmd:identificationInfo/srv:SV_ServiceIdentification/srv:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:westBoundLongitude/gco:Decimal"/>
								<xsl:value-of select="normalize-space(substring-before(./rdf:Description/ows:WGS84BoundingBox/ows:LowerCorner, ' '))"/>  
							</MinX>
							<MinY>
								<xsl:value-of select="./gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:southBoundLatitude/gco:Decimal | ./gmd:identificationInfo/srv:SV_ServiceIdentification/srv:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:southBoundLatitude/gco:Decimal"/>
								<xsl:value-of select="normalize-space(substring-after(./rdf:Description/ows:WGS84BoundingBox/ows:LowerCorner, ' '))"/>  
							</MinY>
							<ModifiedDate>
								<xsl:value-of select="./gmd:dateStamp/gco:Date | ./gmd:dateStamp/gco:DateTime | ./rdf:Description/dct:modified | ./dcat:Dataset/dct:modified"/>
							</ModifiedDate>
							<!--..............................................Modified by ESRI Italy........................................-->
							<!-- These additional fields allow for a richer JSON response -->
							<HierarchyLevel>
								<xsl:variable name="hlevel" select="./gmd:hierarchyLevel/gmd:MD_ScopeCode/text()[count(./gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue)=0] | ./gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue[count(./gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue)>0] | ./rdf:Description/dc:type"/>
								<xsl:if test="not($hlevel)">
									dataset
								</xsl:if>
								<xsl:if test="$hlevel">
									<xsl:value-of select="$hlevel"/>
								</xsl:if>
							</HierarchyLevel>
							<ResponsibleData>
								<xsl:value-of select="./gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString | ./gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString"/>
							</ResponsibleData>
							<PointOfContactName>
								<xsl:value-of select="./gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString | ./gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString"/>
							</PointOfContactName>
							<PointOfContactEmail>
								<xsl:value-of select="./gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress/gco:CharacterString | ./gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress/gco:CharacterString"/>
							</PointOfContactEmail>
							<PointOfContactTel>
								<xsl:value-of select="./gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone/gmd:voice/gco:CharacterString | ./gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone/gmd:voice/gco:CharacterString"/>
							</PointOfContactTel>
							<!-- All Keywords including INSPIRE Themes -->
							<Keywords>
								<xsl:for-each select="./gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword/gco:CharacterString | ./gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword/gco:CharacterString | ./dcat:Dataset/dcat:keyword">
									<Keyword>
										<xsl:value-of select="." />
									</Keyword>
								</xsl:for-each>
							</Keywords>                                                       
							<!-- END -->
  
							<xsl:variable name="valid-Url" select="./gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource[gmd:linkage/gmd:URL!='']"/>
							<References>
								<!-- Open Data -->
 								<xsl:for-each select="./rdf:Description/dct:references">
									<xsl:value-of select="." />
									<xsl:text>✔</xsl:text>
								urn:x-esri:specification:ServiceType:ArcIMS:Metadata:Server
									<xsl:text>✕</xsl:text>
								</xsl:for-each>

								<xsl:for-each select="./dcat:Dataset/dcat:landingPage/@rdf:resource">
									<xsl:value-of select="." />
									<xsl:text>✔</xsl:text>
								urn:x-esri:specification:ServiceType:ArcIMS:Metadata:Server
									<xsl:text>✕</xsl:text>
								</xsl:for-each>
								<!-- OPen Data END -->
							
								<!--........................Link al servizio...............-->
								<!--Questa lista serve ad ordinare i link ai servizi per tipologia. 
								Il primo link è quello che viene esaminato per cistruire la lista dei link nel Cerca, quindi 
								l'ordine è importante -->

								<!-- Link dell'url della risorsa online sia del dataset che del servizio -->
								<xsl:for-each select="$valid-Url/gmd:linkage/gmd:URL | $valid-Url/@rdf:resource">
									<xsl:value-of select="." />
									<xsl:text>✔</xsl:text>
								urn:x-esri:specification:ServiceType:ArcIMS:Metadata:Server
									<xsl:text>✕</xsl:text>
								</xsl:for-each>

								<!-- Link OpenData -->
								<xsl:for-each select="./dcat:Distribution/dcat:accessURL/@rdf:resource">
									<xsl:value-of select="." />
									<xsl:text>✔</xsl:text>
								urn:x-esri:specification:ServiceType:ArcIMS:Metadata:Server
									<xsl:text>✕</xsl:text>
								</xsl:for-each>

								<!-- Link del connectPoint di un metadato di servizio -->
								<xsl:for-each select="./gmd:identificationInfo/srv:SV_ServiceIdentification/srv:containsOperations/srv:SV_OperationMetadata/srv:connectPoint/gmd:CI_OnlineResource/gmd:linkage/gmd:URL">
									<xsl:value-of select="." />
									<xsl:text>✔</xsl:text>
								urn:x-esri:specification:ServiceType:ArcIMS:Metadata:Server
									<xsl:text>✕</xsl:text>
								</xsl:for-each>
								<!--...........................Link al servizio END................-->

								<xsl:for-each select="./gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:onlineResource/gmd:CI_OnlineResource/gmd:linkage/gmd:URL | ./gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:onlineResource/gmd:CI_OnlineResource/gmd:linkage/gmd:URL">
									<xsl:if test=".!=''">
										<xsl:value-of select="." />
										<xsl:text>✔</xsl:text>
								urn:x-esri:specification:ServiceType:ArcIMS:Metadata:Onlink
										<xsl:text>✕</xsl:text>
									</xsl:if>
								</xsl:for-each>
								<xsl:value-of select="./gmd:identificationInfo/gmd:MD_DataIdentification/gmd:graphicOverview/gmd:MD_BrowseGraphic/gmd:fileName/gco:CharacterString | ./rdf:Description/dc:relation | ./gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:graphicOverview/gmd:MD_BrowseGraphic/gmd:fileName/gco:CharacterString"/>
								<xsl:text>&#x2714;</xsl:text>
								<xsl:text>http://www.isotc211.org/2005/gmd/MD_BrowseGraphic/filename</xsl:text>
								<xsl:text>&#x2715;</xsl:text>   
							</References>

							<Types>
								<xsl:if test="contains($valid-Url/gmd:protocol/gco:CharacterString,'WMS') or contains($valid-Url/gmd:protocol/gco:CharacterString,'REST') or contains($valid-Url/gmd:protocol/gco:CharacterString,'WFS') or contains($valid-Url/gmd:protocol/gco:CharacterString,'WCS') or contains($valid-Url/gmd:protocol/gco:CharacterString,'KML') or contains($valid-Url/gmd:protocol/gco:CharacterString,'MAP') or contains(./rdf:Description/dc:type,'WMS') or contains(./rdf:Description/dc:type,'REST') or contains(./rdf:Description/dc:type,'WFS') or contains(./rdf:Description/dc:type,'WCS') or contains(./rdf:Description/dc:type,'KML') or contains(./rdf:Description/dc:type,'MAP')">
                            liveData
									<xsl:text>&#x2714;</xsl:text>
							urn:x-esri:specification:ServiceType:ArcIMS:Metadata:ContentType
									<xsl:text>&#x2715;</xsl:text>
								</xsl:if>
								<!-- OpenData is downloadable by default as far as the link is not void -->
								<xsl:if test="contains($valid-Url/gmd:protocol/gco:CharacterString,'download') or contains(./rdf:Description/dc:type,'download') or (./dcat:Distribution/dcat:accessURL/@rdf:resource != '')">
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
								<xsl:if test="contains($valid-Url/gmd:function/gmd:CI_OnLineFunctionCode,'download') or contains($valid-Url/gmd:function/gmd:CI_OnLineFunctionCode,'order')">
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
							
							<!-- Gestione link (rest, wms, wfs, zip, csv etc. ). Se il link è di download non si fa preview   -->
							<Links>
								<!-- Questi sono i link di distribuzione -->
								<xsl:for-each select="./dcat:Distribution/dcat:accessURL/@rdf:resource | ./gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:linkage/gmd:URL">
									<xsl:variable name="online-resource" select="."/>
									<xsl:variable name="protocol" select="$online-resource/../../gmd:protocol/gco:CharacterString"/>

									<xsl:choose>
										<!-- WMS -->
										<xsl:when test="contains($protocol,'WMS') or contains($online-resource,'WMS') or contains($online-resource,'wms')">
											<Link label="catalog.rest.wms">
												<xsl:value-of select="$online-resource"/> 
											</Link>
										</xsl:when>
										<!-- WFS -->
										<xsl:when test="contains($protocol,'WFS') or contains($online-resource,'WFS') or contains($online-resource,'wfs')">
											<Link label="catalog.rest.wfs">
												<xsl:value-of select="$online-resource"/> 
											</Link>
										</xsl:when>
										<!-- ZIP -->
										<xsl:when test="contains($online-resource,'.zip') or contains($online-resource,'.ZIP')">
											<Link gptLinkTag="preview" show="false1"/>
											<Link label="catalog.opendata.downloadZIP">
												<xsl:value-of select="$online-resource"/> 
											</Link>
										</xsl:when>
										<!-- CSV -->	
										<xsl:when test="contains($online-resource,'.csv') or contains($online-resource,'.CSV')">
											<Link gptLinkTag="preview" show="false2"/>
											<Link label="catalog.opendata.downloadCSV">
												<xsl:value-of select="$online-resource"/> 
											</Link>
										</xsl:when>	
										<!-- DBF -->
										<xsl:when test="contains($online-resource,'.dbf') or contains($online-resource,'.DBF')">
											<Link gptLinkTag="preview" show="false3"/>
											<Link label="catalog.opendata.downloadDBF">
												<xsl:value-of select="$online-resource"/> 
											</Link>
										</xsl:when>	
										<!-- PDF -->
										<xsl:when test="contains($online-resource,'.pdf') or contains($online-resource,'.PDF')">
											<Link gptLinkTag="preview" show="false4"/>
											<Link label="catalog.opendata.downloadPDF">
												<xsl:value-of select="$online-resource"/> 
											</Link>
										</xsl:when>	
										<!-- DOC -->
										<xsl:when test="contains($online-resource,'.doc') or contains($online-resource,'.DOC')">
											<Link gptLinkTag="preview" show="false5"/>
											<Link label="catalog.opendata.downloadDOC">
												<xsl:value-of select="$online-resource"/> 
											</Link>
										</xsl:when>
										<!-- XLS -->
										<xsl:when test="contains($online-resource,'.xls') or contains($online-resource,'.XLS')">
											<Link gptLinkTag="preview" show="false6"/>
											<Link label="catalog.opendata.downloadXLS">
												<xsl:value-of select="$online-resource"/> 
											</Link>
										</xsl:when>
										<!-- WEBAPP -->
										<xsl:when test="contains($protocol,'WEBAPP')">
											<Link gptLinkTag="preview" show="false8"/>
											<Link label="catalog.rest.webapp">
												<xsl:value-of select="$online-resource"/> 
											</Link>
										</xsl:when>
										<xsl:when test="contains($protocol,'WEBAPP')">
											<Link gptLinkTag="preview" show="false8"/>
											<Link label="catalog.rest.webapp">
												<xsl:value-of select="$online-resource"/> 
											</Link>
										</xsl:when>
										<!-- DOWNLOAD. Se non sono rientrato nei casi precedenti potrebbe comunque essere un download link.  -->										
										<xsl:when test="contains($protocol,'download') or contains($protocol,'DOWNLOAD') or contains($online-resource,'download')">
											<Link gptLinkTag="preview" show="false7"/>
											<Link label="catalog.rest.download">
												<xsl:value-of select="$online-resource"/> 
											</Link>
										</xsl:when>
									<!-- Non c'è otherwise perché non saprei cosa farci 
										<xsl:otherwise test="$online-resource != ''">
										</xsl:otherwise> -->
									</xsl:choose>

								</xsl:for-each>
								<!-- Questi sono i link del connect point per i servizi e mi servono solo per il download -->
								<xsl:if test="./gmd:identificationInfo/srv:SV_ServiceIdentification/srv:serviceType/gco:LocalName = 'download'">  
									<xsl:for-each select="./gmd:identificationInfo/srv:SV_ServiceIdentification/srv:containsOperations/srv:SV_OperationMetadata/srv:connectPoint/gmd:CI_OnlineResource/gmd:linkage/gmd:URL">
										<Link gptLinkTag="preview" show="false7"/>
										<Link label="catalog.rest.download">
											<xsl:value-of select="."/> 
										</Link>
									</xsl:for-each>
								</xsl:if>
							</Links>
						</Record>
					</xsl:for-each>

				</Records>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
