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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:gml="http://www.opengis.net/gml/3.2" xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gmx="http://www.isotc211.org/2005/gmx" xmlns:gmi="http://www.isotc211.org/2005/gmi" xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:srv="http://www.isotc211.org/2005/srv">
	<xsl:output indent="yes" method="html" omit-xml-declaration="yes"/>
	<xsl:template match="/gmd:MD_Metadata|/gmi:MI_Metadata">
		<style>
			.iso_section_title {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 12pt; font-weight: bold; color: #333333}
			.iso_body {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10pt; line-height: 16pt; color: #333333}
			.iso_body .toolbarTitle {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 14pt; color: #333333; margin:0px;}
			.iso_body .headTitle {  font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 11pt; color: #333333; font-weight: bold}
			.iso_body dl {margin-left: 20px;}
			.iso_body em {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10pt; font-weight: bold; color: #333333}
			.iso_body a:link {color: #B66B36; text-decoration: underline}
			.iso_body a:visited {color: #B66B36; text-decoration: underline}
			.iso_body a:hover {color: #4E6816; text-decoration: underline}
			.iso_body li {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10pt; line-height: 14pt; color: #333333}
			hr { background-color: #CCCCCC; border: 0 none; height: 1px; }
			
			.linkRNDT{padding-left: 15px;font-size: 12px;text-transform: initial;}	
		</style>
		<script type="text/javascript">
			var mdeEnvelopeIds = new Array('envelope_west','envelope_south','envelope_east','envelope_north');
		</script>


		<div class="iso_body">
			<xsl:call-template name="Page_Title"/>
			<xsl:call-template name="Metadata_Info"/>
			<xsl:call-template name="reference_System"/>

			<xsl:call-template name="Identification_Info"/>
			<xsl:if test="count(/gmd:MD_Metadata/gmd:distributionInfo) +  count(/gmi:MI_Metadata/gmd:distributionInfo)>0">
				<xsl:call-template name="Distribution_Info"/>
			</xsl:if>
			<xsl:if test="count(/gmd:MD_Metadata/gmd:dataQualityInfo) +  count(/gmi:MI_Metadata/gmd:dataQualityInfo)>0">
				<xsl:call-template name="Data_Quality_Info"/>
			</xsl:if>
			<xsl:if test="count(/gmi:MI_Metadata/gmi:acquisitionInformation)>0">
				<xsl:call-template name="Acquisition_Info"/>
			</xsl:if>
<!--
			<xsl:call-template name="Google_Dataset"/>
-->
		</div>
	</xsl:template>
	<xsl:template name="Page_Title">
		<h1 class="toolbarTitle">
			<xsl:value-of select="/*[self::gmd:MD_Metadata or self::gmi:MI_Metadata]/gmd:identificationInfo/*[self::gmd:MD_DataIdentification or self::srv:SV_ServiceIdentification]/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString"/>
		</h1>
			<a class="linkRNDT">
				<xsl:attribute name="href">
						<xsl:value-of select="translate(concat('https://geodati.gov.it/geoportale/visualizzazione-metadati/scheda-metadati/?uuid=', /*[self::gmd:MD_Metadata or self::gmi:MI_Metadata]/gmd:fileIdentifier),'&#xA;&#xD;&#x9;&#x20;','')"/>
				</xsl:attribute>
				<xsl:attribute name="target">
						<xsl:value-of select="'_blank'"/>
				</xsl:attribute>
				Visualizza questa pagina nel portale RNDT
			</a>		
		<xsl:text disable-output-escaping="yes"><![CDATA[<hr/>]]></xsl:text>
	</xsl:template>
	<xsl:template name="Metadata_Info">
		<div class="iso_section_title">
			<xsl:call-template name="get_property">
				<xsl:with-param name="key">catalog.mdParam.rndt.general.caption</xsl:with-param>
			</xsl:call-template>
		</div>
		<dl>
			<xsl:for-each select="/*[self::gmd:MD_Metadata or self::gmi:MI_Metadata]/gmd:fileIdentifier">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.rndt.general.<xsl:value-of select="local-name()"/>
							</xsl:with-param>
						</xsl:call-template>
						<xsl:text>&#x20;</xsl:text>
					</em>
					<xsl:value-of select="/*[self::gmd:MD_Metadata or self::gmi:MI_Metadata]/gmd:fileIdentifier/gco:CharacterString"/>
				</dt>
			</xsl:for-each>
			<xsl:if test="count(/*[self::gmd:MD_Metadata or self::gmi:MI_Metadata]/gmd:language) > 0">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.inspire.general.metadataLanguage</xsl:with-param>
						</xsl:call-template>
						<xsl:text>&#x20;</xsl:text>
					</em>
					<xsl:choose>
						<xsl:when test=" string-length(/*[self::gmd:MD_Metadata or self::gmi:MI_Metadata]/gmd:language/gmd:LanguageCode/@codeListValue) > 0">
							<xsl:call-template name="get_property">
								<xsl:with-param name="key">catalog.mdCode.language.iso639_2.<xsl:value-of select="/*[self::gmd:MD_Metadata or self::gmi:MI_Metadata]/gmd:language/gmd:LanguageCode/@codeListValue"/>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="/*[self::gmd:MD_Metadata or self::gmi:MI_Metadata]/gmd:language/gco:CharacterString"/>
						</xsl:otherwise>
					</xsl:choose>
				</dt>
			</xsl:if>
			<xsl:if test="count(/*[self::gmd:MD_Metadata or self::gmi:MI_Metadata]/gmd:characterSet) > 0">
				<dt>

					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.general.characterSet</xsl:with-param>
						</xsl:call-template>
						<xsl:text>&#x20;</xsl:text>
					</em>
					<xsl:value-of select="/*[self::gmd:MD_Metadata or self::gmi:MI_Metadata]/gmd:characterSet"/>
				</dt>
			</xsl:if>
			<xsl:if test="/*[self::gmd:MD_Metadata or self::gmi:MI_Metadata]/gmd:parentIdentifier">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.rndt.general.<xsl:value-of select="local-name(/*[self::gmd:MD_Metadata or self::gmi:MI_Metadata]/gmd:parentIdentifier)"/>
							</xsl:with-param>
						</xsl:call-template>
						<xsl:text>&#x20;</xsl:text>
					</em>
					<xsl:value-of select="/*[self::gmd:MD_Metadata or self::gmi:MI_Metadata]/gmd:parentIdentifier/gco:CharacterString"/>
				</dt>
			</xsl:if>
			<xsl:if test="/*[self::gmd:MD_Metadata or self::gmi:MI_Metadata]/gmd:hierarchyLevel/gmd:MD_ScopeCode">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.rndt.general.hierarchyLevel</xsl:with-param>
						</xsl:call-template>
						<xsl:text>&#x20;</xsl:text>
					</em>
					<xsl:call-template name="get_property">
						<xsl:with-param name="key">catalog.mdCode.scope.<xsl:value-of select="/*[self::gmd:MD_Metadata or self::gmi:MI_Metadata]/gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue"/>
						</xsl:with-param>
					</xsl:call-template>
				</dt>
			</xsl:if>
			<xsl:if test="/*[self::gmd:MD_Metadata or self::gmi:MI_Metadata]/gmd:hierarchyLevelName/gco:CharacterString">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.rndt.general.hierarchyLevelName</xsl:with-param>
						</xsl:call-template>
						<xsl:text>&#x20;</xsl:text>
					</em>
					<xsl:value-of select="/*[self::gmd:MD_Metadata or self::gmi:MI_Metadata]/gmd:hierarchyLevelName/gco:CharacterString"/>
				</dt>
			</xsl:if>
			<xsl:for-each select="/*[self::gmd:MD_Metadata or self::gmi:MI_Metadata]/gmd:contact">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.rndt.general.contact.caption</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
					<xsl:apply-templates select="gmd:CI_ResponsibleParty"/>
				</dt>
			</xsl:for-each>
			<xsl:if test="/*[self::gmd:MD_Metadata or self::gmi:MI_Metadata]/gmd:dateStamp">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.general.metadataDateStamp</xsl:with-param>
						</xsl:call-template>
						<xsl:text>&#x20;</xsl:text>
					</em>
					<xsl:value-of select="/*[self::gmd:MD_Metadata or self::gmi:MI_Metadata]/gmd:dateStamp/gco:Date"/>
				</dt>
			</xsl:if>
			<xsl:if test="/*[self::gmd:MD_Metadata or self::gmi:MI_Metadata]/gmd:metadataStandardName">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.rndt.general.standardName</xsl:with-param>
						</xsl:call-template>
						<xsl:text>&#x20;</xsl:text>
					</em>
					<xsl:value-of select="/*[self::gmd:MD_Metadata or self::gmi:MI_Metadata]/gmd:metadataStandardName/gco:CharacterString | /*[self::gmd:MD_Metadata or self::gmi:MI_Metadata]/gmd:metadataStandardName/gmx:Anchor"/>
				</dt>
			</xsl:if>
			<xsl:if test="/*[self::gmd:MD_Metadata or self::gmi:MI_Metadata]/gmd:metadataStandardVersion">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.rndt.general.standardVersion</xsl:with-param>
						</xsl:call-template>
						<xsl:text>&#x20;</xsl:text>
					</em>
					<xsl:value-of select="/*[self::gmd:MD_Metadata or self::gmi:MI_Metadata]/gmd:metadataStandardVersion/gco:CharacterString"/>
				</dt>
			</xsl:if>
		</dl>
	</xsl:template>
	<xsl:template name="reference_System">
		<div class="iso_section_title">
			<xsl:call-template name="get_property">
				<xsl:with-param name="key">catalog.mdParam.referenceSystemInfo.caption</xsl:with-param>
			</xsl:call-template>
		</div>
		<dl>
			<xsl:if test="/*[self::gmd:MD_Metadata or self::gmi:MI_Metadata]/gmd:referenceSystemInfo">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.referenceSystemInfo.caption</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
					<xsl:value-of select="/*[self::gmd:MD_Metadata or self::gmi:MI_Metadata]/gmd:referenceSystemInfo/gmd:MD_ReferenceSystem/gmd:referenceSystemIdentifier/gmd:RS_Identifier/gmd:code/gco:CharacterString | /*[self::gmd:MD_Metadata or self::gmi:MI_Metadata]/gmd:referenceSystemInfo/gmd:MD_ReferenceSystem/gmd:referenceSystemIdentifier/gmd:RS_Identifier/gmd:code/gmx:Anchor"/>
				</dt>
			</xsl:if>
		</dl>
	</xsl:template>
	<xsl:template name="Dati_Raster">
		<div class="iso_section_title">
			<xsl:call-template name="get_property">
				<xsl:with-param name="key">catalog.mdParam.rndt.raster.caption</xsl:with-param>
			</xsl:call-template>
		</div>
		<dl>
			<dt>
				<em>
					<xsl:call-template name="get_property">
						<xsl:with-param name="key">catalog.mdParam.rndt.raster.contentinfo.attribute</xsl:with-param>
					</xsl:call-template>
					<xsl:text>&#x20;</xsl:text>
				</em>
				<xsl:value-of select="/gmd:MD_Metadata/gmd:contentInfo/gmd:MD_ImageDescription/gmd:attributeDescription/gco:RecordType"/>
			</dt>
			<dt>
				<em>
					<xsl:call-template name="get_property">
						<xsl:with-param name="key">catalog.mdParam.rndt.raster.contentinfo.contenttype</xsl:with-param>
					</xsl:call-template>
					<xsl:text>&#x20;</xsl:text>
				</em>
				<xsl:value-of select="/gmd:MD_Metadata/gmd:contentInfo/gmd:MD_ImageDescription/gmd:contentType/gmd:MD_CoverageContentTypeCode"/>
			</dt>
			<xsl:if test="/gmd:MD_Metadata/gmd:contentInfo/gmd:MD_ImageDescription/gmd:dimension">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.rndt.raster.contentinfo.dimension</xsl:with-param>
						</xsl:call-template>
						<xsl:text>&#x20;</xsl:text>
					</em>
					<xsl:value-of select="/gmd:MD_Metadata/gmd:contentInfo/gmd:MD_ImageDescription/gmd:dimension/gmd:MD_Band/gmd:bitsPerValue/gco:Integer"/>
				</dt>
			</xsl:if>
			<xsl:if test="/gmd:MD_Metadata/gmd:contentInfo/gmd:MD_ImageDescription/gmd:triangulationIndicator/gco:Boolean">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.rndt.raster.contentinfo.triangulation</xsl:with-param>
						</xsl:call-template>
						<xsl:text>&#x20;</xsl:text>
					</em>
					<xsl:value-of select="/gmd:MD_Metadata/gmd:contentInfo/gmd:MD_ImageDescription/gmd:triangulationIndicator/gco:Boolean"/>
				</dt>
			</xsl:if> 

			<xsl:if test="/gmd:MD_Metadata/gmd:spatialRepresentationInfo/*[self::gmd:MD_Georectified or self::gmd:MD_Georeferenceable]">

				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.rndt.raster.spatial.numberdimension</xsl:with-param>
						</xsl:call-template>
						<xsl:text>&#x20;</xsl:text>
					</em>
					<xsl:value-of select="/*[self::gmd:MD_Metadata or self::gmi:MI_Metadata]/gmd:spatialRepresentationInfo/*[self::gmd:MD_Georectified or self::gmd:MD_Georeferenceable]/gmd:numberOfDimensions/gco:Integer"/>
				</dt>

				<xsl:for-each select="/gmd:MD_Metadata/gmd:spatialRepresentationInfo/*[self::gmd:MD_Georectified or self::gmd:MD_Georeferenceable]/gmd:axisDimensionProperties">

					<dt>
						<em>
							<xsl:call-template name="get_property">
								<xsl:with-param name="key">catalog.mdParam.rndt.raster.spatial.properties.name</xsl:with-param>
							</xsl:call-template>
							<xsl:text>&#x20;</xsl:text>
						</em>
						<xsl:value-of select="./gmd:MD_Dimension/gmd:dimensionName/gmd:MD_DimensionNameTypeCode"/>
					</dt>
					<dt>
						<em>
							<xsl:call-template name="get_property">
								<xsl:with-param name="key">catalog.mdParam.rndt.raster.spatial.properties.measure</xsl:with-param>
							</xsl:call-template>
							<xsl:text>&#x20;</xsl:text>
						</em>
						<xsl:value-of select="./gmd:MD_Dimension/gmd:dimensionSize/gco:Integer"/>
					</dt>
					<xsl:if test="/*[self::gmd:MD_Metadata or self::gmi:MI_Metadata]/gmd:spatialRepresentationInfo/*[self::gmd:MD_Georectified or self::gmd:MD_Georeferenceable]/gmd:axisDimensionProperties/gmd:MD_Dimension/gmd:resolution/gco:Measure">
						<dt>
							<em>
								<xsl:call-template name="get_property">
									<xsl:with-param name="key">catalog.mdParam.rndt.raster.spatial.properties.resolution</xsl:with-param>
								</xsl:call-template>
								<xsl:text>&#x20;</xsl:text>
							</em>
							<xsl:value-of select="./gmd:MD_Dimension/gmd:resolution/gco:Measure"/>
						</dt>
					</xsl:if>
				</xsl:for-each>
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.rndt.raster.spatial.cellgeometry</xsl:with-param>
						</xsl:call-template>
						<xsl:text>&#x20;</xsl:text>
					</em>
					<xsl:value-of select="/*[self::gmd:MD_Metadata or self::gmi:MI_Metadata]/gmd:spatialRepresentationInfo/*[self::gmd:MD_Georectified or self::gmd:MD_Georeferenceable]/gmd:cellGeometry/gmd:MD_CellGeometryCode"/>
				</dt>
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.rndt.raster.spatial.transformation</xsl:with-param>
						</xsl:call-template>
						<xsl:text>&#x20;</xsl:text>
					</em>
					<xsl:value-of select="/*[self::gmd:MD_Metadata or self::gmi:MI_Metadata]/gmd:spatialRepresentationInfo/*[self::gmd:MD_Georectified or self::gmd:MD_Georeferenceable]/gmd:transformationParameterAvailability/gco:Boolean"/>
				</dt>


				<xsl:if test="/*[self::gmd:MD_Metadata or self::gmi:MI_Metadata]/gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:checkPointDescription/gco:CharacterString">
					<dt>
						<em>
							<xsl:call-template name="get_property">
								<xsl:with-param name="key">catalog.mdParam.rndt.raster.spatial.georectified.checkavail</xsl:with-param>
							</xsl:call-template>
							<xsl:text>&#x20;</xsl:text>
						</em>
						<xsl:value-of select="/*[self::gmd:MD_Metadata or self::gmi:MI_Metadata]/gmd:spatialRepresentationInfo/*[self::gmd:MD_Georectified or self::gmd:MD_Georeferenceable]/gmd:checkPointAvailability/gco:Boolean"/>
					</dt>
					<dt>
						<em>
							<xsl:call-template name="get_property">
								<xsl:with-param name="key">catalog.mdParam.rndt.raster.spatial.georectified.checkdescr</xsl:with-param>
							</xsl:call-template>
							<xsl:text>&#x20;</xsl:text>
						</em>
						<xsl:value-of select="/*[self::gmd:MD_Metadata or self::gmi:MI_Metadata]/gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:checkPointDescription/gco:CharacterString"/>
					</dt>
				</xsl:if>

				<xsl:for-each select="/*[self::gmd:MD_Metadata or self::gmi:MI_Metadata]/gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:cornerPoints">
					<dt>
						<em>
							<xsl:call-template name="get_property">
								<xsl:with-param name="key">catalog.mdParam.rndt.raster.spatial.georectified.cornerPoint.id</xsl:with-param>
							</xsl:call-template>
							<xsl:text>&#x20;</xsl:text>
						</em>
						<xsl:value-of select="./gml:Point/@gml:id"/>
					</dt>
					<xsl:if test="./gml:Point/gml:name">
						<dt>
							<em>
								<xsl:call-template name="get_property">
									<xsl:with-param name="key">catalog.mdParam.rndt.raster.spatial.georectified.cornerPoint.name</xsl:with-param>
								</xsl:call-template>
								<xsl:text>&#x20;</xsl:text>
							</em>
							<xsl:value-of select="./gml:Point/gml:name"/>
						</dt>
					</xsl:if>
					<dt>
						<em>
							<xsl:call-template name="get_property">
								<xsl:with-param name="key">catalog.mdParam.rndt.raster.spatial.georectified.cornerPoint.position</xsl:with-param>
							</xsl:call-template>
							<xsl:text>&#x20;</xsl:text>
						</em>
						<xsl:value-of select="./gml:Point/gml:coordinates"/>
					</dt>
				</xsl:for-each>
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.rndt.raster.spatial.georectified.pixelpoint</xsl:with-param>
						</xsl:call-template>
						<xsl:text>&#x20;</xsl:text>
					</em>
					<xsl:apply-templates select="/gmd:MD_Metadata/gmd:spatialRepresentationInfo/gmd:MD_Georectified/gmd:pointInPixel/gmd:MD_PixelOrientationCode"/>
				</dt>   

				<xsl:if test="/*[self::gmd:MD_Metadata or self::gmi:MI_Metadata]/gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable">
					<dt>
						<em>
							<xsl:call-template name="get_property">
								<xsl:with-param name="key">catalog.mdParam.rndt.raster.spatial.georeferenceable.controlavail</xsl:with-param>
							</xsl:call-template>
							<xsl:text>&#x20;</xsl:text>
						</em>
						<xsl:value-of select="/gmd:MD_Metadata/gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/gmd:controlPointAvailability/gco:Boolean"/>
					</dt>
					<dt>
						<em>
							<xsl:call-template name="get_property">
								<xsl:with-param name="key">catalog.mdParam.rndt.raster.spatial.georeferenceable.orientavail</xsl:with-param>
							</xsl:call-template>
							<xsl:text>&#x20;</xsl:text>
						</em>
						<xsl:value-of select="/gmd:MD_Metadata/gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/gmd:orientationParameterAvailability/gco:Boolean"/>
					</dt>
					<dt>
						<em>
							<xsl:call-template name="get_property">
								<xsl:with-param name="key">catalog.mdParam.rndt.raster.spatial.georeferenceable.parameter</xsl:with-param>
							</xsl:call-template>
							<xsl:text>&#x20;</xsl:text>
						</em>
						<xsl:value-of select="/gmd:MD_Metadata/gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/gmd:georeferencedParameters/gco:Record"/>
					</dt>

				</xsl:if>
			</xsl:if> 


		</dl>
	</xsl:template>
	<xsl:template name="Identification_Info">
		<xsl:for-each select="/*[self::gmd:MD_Metadata or self::gmi:MI_Metadata]/gmd:identificationInfo">
			<xsl:if test="gmd:MD_DataIdentification">
				<div class="iso_section_title">
					<xsl:call-template name="get_property">
						<xsl:with-param name="key">catalog.mdParam.identificationDati.caption</xsl:with-param>
					</xsl:call-template>
				</div>
				<xsl:apply-templates select="gmd:MD_DataIdentification"/>
			</xsl:if>
			<xsl:if test="srv:SV_ServiceIdentification">
				<div class="iso_section_title">
					<xsl:call-template name="get_property">
						<xsl:with-param name="key">catalog.iso19139.MD_Metadata.MD_ServiceIdentification</xsl:with-param>
					</xsl:call-template>
				</div>
				<xsl:apply-templates select="srv:SV_ServiceIdentification"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="gmd:MD_DataIdentification | srv:SV_ServiceIdentification">
		<dl>
			<xsl:if test="gmd:citation/gmd:CI_Citation/gmd:identifier/gmd:MD_Identifier">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.rndt.identification.datasetIdentifier</xsl:with-param>
						</xsl:call-template>
						<xsl:text>&#x20;</xsl:text>
					</em>
					<xsl:apply-templates select="gmd:citation/gmd:CI_Citation/gmd:identifier/gmd:MD_Identifier/gmd:code/gco:CharacterString"/>
				</dt>
			</xsl:if>
			<xsl:if test="gmd:citation/gmd:CI_Citation/gmd:identifier/gmd:RS_Identifier">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.rndt.identification.datasetIdentifier</xsl:with-param>
						</xsl:call-template>
						<xsl:text>&#x20;</xsl:text>
					</em>
					<xsl:apply-templates select="gmd:citation/gmd:CI_Citation/gmd:identifier/gmd:RS_Identifier/gmd:code/gco:CharacterString"/>
				</dt>
			</xsl:if>

			<xsl:if test="gmd:citation/gmd:CI_Citation/gmd:series/gmd:CI_Series/gmd:issueIdentification">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.rndt.identification.parentIdentifier</xsl:with-param>
						</xsl:call-template>
						<xsl:text>&#x20;</xsl:text>
					</em>
					<xsl:apply-templates select="gmd:citation/gmd:CI_Citation/gmd:series/gmd:CI_Series/gmd:issueIdentification/gco:CharacterString"/>
				</dt>
			</xsl:if>

			<xsl:for-each select="gmd:abstract">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.identification.abstract</xsl:with-param>
						</xsl:call-template>
						<xsl:text>&#x20;</xsl:text>
					</em>
					<xsl:value-of select="gco:CharacterString"/>
				</dt>
			</xsl:for-each>
			<xsl:for-each select="gmd:purpose">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.iso19139.AbstractMD_Identification.<xsl:value-of select="local-name()"/>
							</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
					<xsl:value-of select="gco:CharacterString"/>
				</dt>
			</xsl:for-each>
			<xsl:for-each select="gmd:language">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.rndt.identification.language</xsl:with-param>
						</xsl:call-template>
						<xsl:text>&#x20;</xsl:text>
					</em>
					<xsl:choose>
						<xsl:when test=" string-length(gmd:LanguageCode/@codeListValue) > 0">
							<xsl:call-template name="get_property">
								<xsl:with-param name="key">catalog.mdCode.language.iso639_2.<xsl:value-of select="gmd:LanguageCode/@codeListValue"/>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="gco:CharacterString"/>
						</xsl:otherwise>
					</xsl:choose>
				</dt>
			</xsl:for-each>
			<xsl:for-each select="gmd:characterSet">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.general.characterSetData</xsl:with-param>
						</xsl:call-template>
						<xsl:text>&#x20;</xsl:text>
					</em>
					<xsl:choose>
						<xsl:when test=" string-length(/*[self::gmd:MD_Metadata or self::gmi:MI_Metadata]/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:characterSet) > 0">
							<xsl:call-template name="get_property">
								<xsl:with-param name="key">catalog.mdCode.characterSet.<xsl:value-of select="gmd:MD_CharacterSetCode/@codeListValue"/>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="/*[self::gmd:MD_Metadata or self::gmi:MI_Metadata]/gmd:characterSet"/>
						</xsl:otherwise>
					</xsl:choose>
				</dt>
			</xsl:for-each>

			<xsl:if test="gmd:graphicOverview">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.iso19139.MD_Metadata.section.identification.graphicOverview</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
				</dt>
				<dt>
					<xsl:apply-templates select="gmd:graphicOverview/gmd:MD_BrowseGraphic"/>
				</dt>
			</xsl:if>
			<xsl:if test="gmd:citation">
				<!--        <dt>
          <em>
            <xsl:call-template name="get_property">
              <xsl:with-param name="key">catalog.mdParam.rndt.identification.caption</xsl:with-param>
            </xsl:call-template><xsl:text>:&#x20;</xsl:text> </em>
        </dt>-->
				<dt>
					<xsl:apply-templates select="gmd:citation/gmd:CI_Citation"/>
				</dt>
			</xsl:if>


			<xsl:if test="gmd:pointOfContact">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.rndt.identification.pointOfContact.caption</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
				</dt>
				<dt>
					<xsl:apply-templates select="gmd:pointOfContact/gmd:CI_ResponsibleParty"/>
				</dt>
			</xsl:if>

			<xsl:if test="gmd:citation/gmd:CI_Citation/gmd:presentationForm">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.rndt.identification.presentationForm</xsl:with-param>
						</xsl:call-template>
						<xsl:text>&#x20;</xsl:text>
					</em>
					<xsl:apply-templates select="gmd:citation/gmd:CI_Citation/gmd:presentationForm/gmd:CI_PresentationFormCode"/>
				</dt>
			</xsl:if>

			<xsl:for-each  select="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceMaintenance/gmd:MD_MaintenanceInformation/gmd:maintenanceAndUpdateFrequency/gmd:MD_MaintenanceFrequencyCode">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.rndt.maintenance.code</xsl:with-param>
						</xsl:call-template>
						<xsl:text>&#x20;</xsl:text>
					</em>
					<xsl:call-template name="get_property">
						<xsl:with-param name="key">catalog.mdCode.rndt.MD_MaintenanceFrequencyCode.<xsl:value-of select="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceMaintenance/gmd:MD_MaintenanceInformation/gmd:maintenanceAndUpdateFrequency/gmd:MD_MaintenanceFrequencyCode/@codeListValue"/>
						</xsl:with-param>
					</xsl:call-template>
				</dt>
			</xsl:for-each >


			<xsl:if test="gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode/@codeListValue">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.rndt.identification.resolution.representationType</xsl:with-param>
						</xsl:call-template>
						<xsl:text>&#x20;</xsl:text>
					</em>
					<xsl:call-template name="get_property">
						<xsl:with-param name="key">catalog.mdCode.rndt.MD_SpatialRepresentationTypeCode.<xsl:value-of select="gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode/@codeListValue"/>
						</xsl:with-param>
					</xsl:call-template>
				</dt>
			</xsl:if>
			<xsl:if test="gmd:spatialResolution/gmd:MD_Resolution/gmd:equivalentScale">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.iso19139.MD_Resolution.equivalentScale</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
					<xsl:text>1:</xsl:text>
					<xsl:value-of select="gmd:spatialResolution/gmd:MD_Resolution/gmd:equivalentScale"/>
				</dt>
			</xsl:if>
			<xsl:if test="gmd:topicCategory/gmd:MD_TopicCategoryCode">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.rndt.identification.topics.title</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
					<xsl:for-each select="gmd:topicCategory/gmd:MD_TopicCategoryCode">
						<dt>
							<xsl:call-template name="get_property">
								<xsl:with-param name="key">catalog.mdCode.rndt.MD_TopicCategoryCode.<xsl:value-of select="."/>
								</xsl:with-param>
							</xsl:call-template>
						</dt>
					</xsl:for-each>					  
				</dt>
			</xsl:if>
			<xsl:if test="gmd:descriptiveKeywords">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.rndt.identification.categorieskeywords.keywords.caption</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
				</dt>
				<dt>
					<xsl:apply-templates select="gmd:descriptiveKeywords/gmd:MD_Keywords"/>
				</dt>
			</xsl:if>
			<xsl:if test="gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.rndt.extent.envelope.caption</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
				</dt>
				<dt>
					<xsl:apply-templates select="gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox"/>
				</dt>
			</xsl:if>
			<xsl:if test="gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.iso19139.EX_Extent.temporalElement</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
				</dt>
				<dt>
					<xsl:apply-templates select="gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod"/>
				</dt>
			</xsl:if>
			<xsl:if test="srv:serviceType/gco:LocalName">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.rndt.identification.serviceType</xsl:with-param>
						</xsl:call-template>
						<xsl:text>&#x20;</xsl:text>
					</em>
					<xsl:call-template name="get_property">
						<xsl:with-param name="key">catalog.mdCode.rndt.serviceType.<xsl:value-of select="srv:serviceType/gco:LocalName"/>
						</xsl:with-param>
					</xsl:call-template>
				</dt>
			</xsl:if>
			<xsl:for-each select="srv:serviceTypeVersion/gco:CharacterString">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.rndt.identification.serviceType</xsl:with-param>
						</xsl:call-template>
						<xsl:text>&#x20;</xsl:text>
					</em>

					<xsl:call-template name="get_property">
						<xsl:with-param name="key">catalog.mdParam.inspire.identification.<xsl:value-of select="."/>
						</xsl:with-param>
					</xsl:call-template>
				</dt>
			</xsl:for-each>
			<xsl:if test="srv:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.iso19139.EX_Extent.geographicElement</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
				</dt>
				<dt>
					<xsl:apply-templates select="srv:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox"/>
				</dt>
			</xsl:if>

			<xsl:for-each select="srv:couplingType/srv:SV_CouplingType">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.rndt.identification.serviceType.caption</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
					<xsl:call-template name="get_property">
						<xsl:with-param name="key">catalog.mdCode.rndt.couplingType.<xsl:value-of select="./@codeListValue"/>
						</xsl:with-param>
					</xsl:call-template>

				</dt>
			</xsl:for-each>
			<xsl:for-each select="srv:containsOperations/srv:SV_OperationMetadata">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.rndt.containsoperations.caption</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
				</dt>
				<dt>
					<xsl:apply-templates select="."/>
				</dt>
			</xsl:for-each>

			<xsl:if test="gmd:supplementalInformation/gco:CharacterString | gmd:citation/gmd:CI_Citation/gmd:otherCitationDetails/gco:CharacterString">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.rndt.identification.details.caption</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
				</dt>
				<dt>
					<xsl:apply-templates select="gmd:citation/gmd:CI_Citation/gmd:otherCitationDetails/gco:CharacterString"/>
					<br />
					<br />
					<xsl:apply-templates select="gmd:supplementalInformation/gco:CharacterString"/>
				</dt>
			</xsl:if>

			<xsl:for-each select="gmd:resourceConstraints/gmd:MD_Constraints">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.iso19139.MD_Constraints.useLimitation</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
					<xsl:value-of select="gmd:useLimitation/gco:CharacterString"/>
				</dt>
			</xsl:for-each>
			<xsl:for-each select="gmd:resourceConstraints/gmd:MD_LegalConstraints">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.iso19139.MD_LegalConstraints</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
				</dt>
				<dt>
					<xsl:apply-templates select="."/>
				</dt>
			</xsl:for-each>
			<xsl:for-each select="gmd:resourceConstraints/gmd:MD_SecurityConstraints">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.iso19139.MD_SecurityConstraints</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
				</dt>
				<dt>
					<xsl:apply-templates select="."/>
				</dt>
			</xsl:for-each>
		</dl>
	</xsl:template>

	<!-- CI_ResponsibleParty -->
	<xsl:template match="gmd:citedResponsibleParty/gmd:CI_ResponsibleParty | gmd:pointOfContact/gmd:CI_ResponsibleParty | gmd:CI_ResponsibleParty">
		<dl>
			<xsl:for-each select="gmd:individualName">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.iso19139.CI_ResponsibleParty.<xsl:value-of select="local-name()"/>
							</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
					<xsl:value-of select="gco:CharacterString"/>
				</dt>
			</xsl:for-each>
			<xsl:for-each select="gmd:organisationName">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.iso19139.CI_ResponsibleParty.<xsl:value-of select="local-name()"/>
							</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
					<xsl:value-of select="gco:CharacterString"/>
				</dt>
			</xsl:for-each>
			<xsl:for-each select="gmd:positionName">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.iso19139.CI_ResponsibleParty.<xsl:value-of select="local-name()"/>
							</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
					<xsl:value-of select="gco:CharacterString"/>
				</dt>
			</xsl:for-each>
			<xsl:for-each select="gmd:role">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.iso19139.CI_ResponsibleParty.<xsl:value-of select="local-name()"/>
							</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
					<xsl:call-template name="get_property">
						<xsl:with-param name="key">catalog.iso19139.CI_RoleCode.<xsl:value-of select="gmd:CI_RoleCode/@codeListValue"/>
						</xsl:with-param>
					</xsl:call-template>
				</dt>
			</xsl:for-each>
			<xsl:for-each select="gmd:contactInfo">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.iso19139.CI_ResponsibleParty.contactInfo</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
					<xsl:apply-templates select="gmd:CI_Contact"/>
				</dt>
			</xsl:for-each>
		</dl>
	</xsl:template>

	<!-- gmd:CI_Citation -->
	<xsl:template match="*[self::gmd:citation or self::gmd:specification or self::gmi:citation]/gmd:CI_Citation">
		<em>
			<xsl:call-template name="get_property">
				<xsl:with-param name="key">catalog.schedaMetadati.information</xsl:with-param>
			</xsl:call-template>
			<xsl:text>:&#x20;</xsl:text>
		</em>
		<dl>
			<xsl:for-each select="gmd:title">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.iso19139.CI_Citation.<xsl:value-of select="local-name()"/>
							</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
					<xsl:value-of select="gco:CharacterString"/>
				</dt>
			</xsl:for-each>
			<xsl:for-each select="gmd:alternativeTitle | gmd:alternateTitle">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.iso19139.CI_Citation.<xsl:value-of select="local-name()"/>
							</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
					<xsl:value-of select="gco:CharacterString"/>
				</dt>
			</xsl:for-each>
			<xsl:for-each select="gmd:date">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.iso19139.CI_Citation.<xsl:value-of select="local-name()"/>
							</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
				</dt>
				<dt>
					<xsl:apply-templates select="gmd:CI_Date"/>
				</dt>
			</xsl:for-each>
			<xsl:for-each select="gmd:edition">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.iso19139.CI_Citation.<xsl:value-of select="local-name()"/>
							</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
					<xsl:value-of select="gco:CharacterString"/>
				</dt>
			</xsl:for-each>
			<xsl:for-each select="gmd:editionDate">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.iso19139.CI_Citation.<xsl:value-of select="local-name()"/>
							</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
					<xsl:value-of select="gco:Date"/>
				</dt>
			</xsl:for-each>

			<xsl:if test="gmd:citedResponsibleParty">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.rndt.identification.contact.caption</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
					<xsl:apply-templates select="gmd:citedResponsibleParty/gmd:CI_ResponsibleParty"/>
				</dt>
			</xsl:if>
			<!--
      <xsl:for-each select="gmd:identifier | gmi:identifier">
        <dt>
          <em>
            <xsl:call-template name="get_property">
              <xsl:with-param name="key">catalog.mdParam.rndt.identification.datasetIdentifier</xsl:with-param>
            </xsl:call-template> <xsl:text>&#x20;</xsl:text> </em>
          <xsl:apply-templates select="gmd:MD_Identifier/gmd:code/gco:CharacterString"/>
        </dt>
      </xsl:for-each>
	  -->
		</dl>
	</xsl:template>


	<xsl:template match="gmd:CI_Date">
		<dl>
			<dt>
				<em>
					<xsl:call-template name="get_property">
						<xsl:with-param name="key">catalog.iso19139.CI_Date.date</xsl:with-param>
					</xsl:call-template>
					<xsl:text>&#x20;</xsl:text>
				</em>
				<xsl:if test="gmd:date/gco:Date">
					<xsl:value-of select="gmd:date/gco:Date"/>
				</xsl:if>
				<xsl:if test="gmd:date/gco:DateTime">
					<xsl:value-of select="gmd:date/gco:DateTime"/>
				</xsl:if>
			</dt>
			<dt>
				<em>
					<xsl:call-template name="get_property">
						<xsl:with-param name="key">catalog.iso19139.CI_Date.dateType</xsl:with-param>
					</xsl:call-template>
					<xsl:text>&#x20;</xsl:text>
				</em>
				<xsl:call-template name="get_property">
					<xsl:with-param name="key">catalog.iso19139.CI_DateTypeCode.<xsl:value-of select="gmd:dateType/gmd:CI_DateTypeCode/@codeListValue"/>
					</xsl:with-param>
				</xsl:call-template>
			</dt>
		</dl>
	</xsl:template>
	<xsl:template match="gmd:contactInfo/gmd:CI_Contact | gmd:CI_Contact">
		<dl>
			<xsl:if test="gmd:phone/gmd:CI_Telephone/gmd:voice">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.rndt.general.contact.organizationInfo.phoneNumber</xsl:with-param>
						</xsl:call-template>
						<xsl:text>&#x20;</xsl:text>
					</em>
					<xsl:value-of select="gmd:phone/gmd:CI_Telephone/gmd:voice/gco:CharacterString"/>
				</dt>
			</xsl:if>
			<xsl:if test="gmd:phone/gmd:CI_Telephone/gmd:facsimile">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.iso19139.CI_Telephone.facsimile</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
					<xsl:value-of select="gmd:phone/gmd:CI_Telephone/gmd:facsimile/gco:CharacterString"/>
				</dt>
			</xsl:if>
			<xsl:if test="gmd:address/gmd:CI_Address/gmd:deliveryPoint">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.iso19139.CI_Address.deliveryPoint</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
					<xsl:value-of select="gmd:address/gmd:CI_Address/gmd:deliveryPoint"/>
				</dt>
			</xsl:if>
			<xsl:if test="gmd:address/gmd:CI_Address/gmd:city">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.iso19139.CI_Address.city</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
					<xsl:value-of select="gmd:address/gmd:CI_Address/gmd:city"/>
				</dt>
			</xsl:if>
			<xsl:if test="gmd:address/gmd:CI_Address/gmd:administrativeArea">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.iso19139.CI_Address.administrativeArea</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
					<xsl:value-of select="gmd:address/gmd:CI_Address/gmd:administrativeArea"/>
				</dt>
			</xsl:if>
			<xsl:if test="gmd:address/gmd:CI_Address/gmd:postalCode">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.iso19139.CI_Address.postalCode</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
					<xsl:value-of select="gmd:address/gmd:CI_Address/gmd:postalCode"/>
				</dt>
			</xsl:if>
			<xsl:if test="gmd:address/gmd:CI_Address/gmd:country">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.iso19139.CI_Address.country</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
					<xsl:value-of select="gmd:address/gmd:CI_Address/gmd:country"/>
				</dt>
			</xsl:if>
			<xsl:if test="gmd:address/gmd:CI_Address/gmd:electronicMailAddress">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.rndt.general.contact.organizationInfo.email</xsl:with-param>
						</xsl:call-template>
						<xsl:text>&#x20;</xsl:text>
					</em>
					<a>
						<xsl:attribute name="href">mailto:<xsl:value-of select="gmd:address/gmd:CI_Address/gmd:electronicMailAddress"/>
						</xsl:attribute>
						<xsl:value-of select="gmd:address/gmd:CI_Address/gmd:electronicMailAddress"/>
					</a>
				</dt>
			</xsl:if>
			<xsl:if test="gmd:onlineResource">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.rndt.general.contact.organizationInfo.onlineResource</xsl:with-param>
						</xsl:call-template>
						<xsl:text>&#x20;</xsl:text>
					</em>
					<a>
						<xsl:attribute name="href">
							<xsl:value-of select="gmd:onlineResource/gmd:CI_OnlineResource/gmd:linkage/gmd:URL"/>
						</xsl:attribute>
						<xsl:value-of select="gmd:onlineResource/gmd:CI_OnlineResource/gmd:linkage/gmd:URL"/>
					</a>
				</dt>
			</xsl:if>
			<xsl:if test="gmd:onlineResource/protocol">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.rndt.general.contact.organizationInfo.onlineResource.protocol</xsl:with-param>
						</xsl:call-template>
						<xsl:text>&#x20;</xsl:text>
					</em>
					<xsl:value-of select="gmd:onlineResource/protocol/gco:CharacterString | gmd:onlineResource/protocol/gmx:Anchor"/>
				</dt>
			</xsl:if>
			<xsl:if test="gmd:onlineResource/applicationProfile">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.rndt.general.contact.organizationInfo.onlineResource.applicationProfile</xsl:with-param>
						</xsl:call-template>
						<xsl:text>&#x20;</xsl:text>
					</em>
					<xsl:value-of select="gmd:onlineResource/applicationProfile/gco:CharacterString | gmd:onlineResource/applicationProfile/gmx:Anchor"/>
				</dt>
			</xsl:if>
			<xsl:if test="gmd:onlineResource/description">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.rndt.general.contact.organizationInfo.onlineResource.description</xsl:with-param>
						</xsl:call-template>
						<xsl:text>&#x20;</xsl:text>
					</em>
					<xsl:value-of select="gmd:onlineResource/description/gco:CharacterString | gmd:onlineResource/description/gmx:Anchor"/>
				</dt>
			</xsl:if>
		</dl>
	</xsl:template>
	<xsl:template match="gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox | srv:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox">
		<dl>
			<dt>
				<em>
					<xsl:call-template name="get_property">
						<xsl:with-param name="key">catalog.iso19139.EX_GeographicBoundingBox.westBoundLongitude</xsl:with-param>
					</xsl:call-template>
					<xsl:text>&#x20;</xsl:text>
				</em>
				<span id="mdDetails:envelope_west">
					<xsl:value-of select="gmd:westBoundLongitude/gco:Decimal"/>
				</span>
			</dt>
			<dt>
				<em>
					<xsl:call-template name="get_property">
						<xsl:with-param name="key">catalog.iso19139.EX_GeographicBoundingBox.eastBoundLongitude</xsl:with-param>
					</xsl:call-template>
					<xsl:text>&#x20;</xsl:text>
				</em>
				<span id="mdDetails:envelope_east">
					<xsl:value-of select="gmd:eastBoundLongitude/gco:Decimal"/>
				</span>
			</dt>
			<dt>
				<em>
					<xsl:call-template name="get_property">
						<xsl:with-param name="key">catalog.iso19139.EX_GeographicBoundingBox.northBoundLatitude</xsl:with-param>
					</xsl:call-template>
					<xsl:text>&#x20;</xsl:text>
				</em>
				<span id="mdDetails:envelope_north">
					<xsl:value-of select="gmd:northBoundLatitude/gco:Decimal"/>
				</span>
			</dt>
			<dt>
				<em>
					<xsl:call-template name="get_property">
						<xsl:with-param name="key">catalog.iso19139.EX_GeographicBoundingBox.southBoundLatitude</xsl:with-param>
					</xsl:call-template>
					<xsl:text>&#x20;</xsl:text>
				</em>
				<span id="mdDetails:envelope_south">
					<xsl:value-of select="gmd:southBoundLatitude/gco:Decimal"/>
				</span>
			</dt>
		</dl>
	</xsl:template>

	<xsl:template match="gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod">
		<dl>
			<dt>
				<em>
					<xsl:call-template name="get_property">
						<xsl:with-param name="key">catalog.iso19139.EX_TemporalExtent.beginPosition</xsl:with-param>
					</xsl:call-template>
					<xsl:text>&#x20;</xsl:text>
				</em>
				<span id="mdDetails:envelope_west">
					<xsl:value-of select="gml:beginPosition"/>
				</span>
			</dt>
			<dt>
				<em>
					<xsl:call-template name="get_property">
						<xsl:with-param name="key">catalog.iso19139.EX_TemporalExtent.endPosition</xsl:with-param>
					</xsl:call-template>
					<xsl:text>&#x20;</xsl:text>
				</em>
				<span id="mdDetails:envelope_east">
					<xsl:value-of select="gml:endPosition"/>
				</span>
			</dt>
		</dl>
	</xsl:template>
	<xsl:template match="gmd:extent/gmd:EX_Extent/gmd:verticalElement/gmd:EX_VerticalExtent">
		<dl>
			<dt>
				<em>
					<xsl:call-template name="get_property">
						<xsl:with-param name="key">catalog.mdParam.rndt.extent.vertical.minimum</xsl:with-param>
					</xsl:call-template>
					<xsl:text>:&#x20;</xsl:text>
				</em>
				<span id="mdDetails:envelope_west">
					<xsl:value-of select="gmd:minimumValue/gco:Real"/>
				</span>
			</dt>
			<dt>
				<em>
					<xsl:call-template name="get_property">
						<xsl:with-param name="key">catalog.mdParam.rndt.extent.vertical.maximum</xsl:with-param>
					</xsl:call-template>
					<xsl:text>:&#x20;</xsl:text>
				</em>
				<span id="mdDetails:envelope_east">
					<xsl:value-of select="gmd:maximumValue/gco:Real"/>
				</span>
			</dt>
			<dt>
				<em>
					<xsl:call-template name="get_property">
						<xsl:with-param name="key">catalog.mdParam.rndt.extent.vertical.verticalCRS</xsl:with-param>
					</xsl:call-template>
					<xsl:text>:&#x20;</xsl:text>
				</em>
				<span id="mdDetails:envelope_east">
					<xsl:value-of select="gmd:verticalCRS/@href"/>
				</span>
			</dt>
		</dl>
	</xsl:template>
	<xsl:template match="gmd:descriptiveKeywords/gmd:MD_Keywords">
		<dl>
			<xsl:for-each select="gmd:keyword/gco:CharacterString | gmd:keyword/gmx:Anchor">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.rndt.identification.keyword.free.singlekeyword</xsl:with-param>
						</xsl:call-template>
						<xsl:text>&#x20;</xsl:text>
					</em>
					<xsl:value-of select="."/>
				</dt>
			</xsl:for-each>
			<xsl:if test="gmd:thesaurusName/gmd:CI_Citation/gmd:title/gco:CharacterString | gmd:thesaurusName/gmd:CI_Citation/gmd:title/gmx:Anchor">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.rdnt.raster.hint.keywordTypeISDAT</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
					<xsl:apply-templates select="gmd:thesaurusName/gmd:CI_Citation"/>
				</dt>
			</xsl:if>
		</dl>
	</xsl:template>
	<xsl:template match="gmd:MD_LegalConstraints | gmd:resourceConstraints/gmd:MD_LegalConstraints">
		<dl>
			<xsl:for-each select="gmd:accessConstraints">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.iso19139.MD_LegalConstraints.accessConstraints</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
					<xsl:call-template name="get_property">
						<xsl:with-param name="key">catalog.iso19139.MD_RestrictionCode.<xsl:value-of select="gmd:accessConstraints/gmd:MD_RestrictionCode/@codeListValue"/>
						</xsl:with-param>
					</xsl:call-template>
				</dt>
			</xsl:for-each>
			<xsl:if test="gmd:useConstraints">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.rndt.constraints.use</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
					<xsl:call-template name="get_property">
						<xsl:with-param name="key">catalog.iso19139.MD_RestrictionCode.<xsl:value-of select="gmd:useConstraints/gmd:MD_RestrictionCode/@codeListValue"/>
						</xsl:with-param>
					</xsl:call-template>
				</dt>
			</xsl:if>
			<xsl:if test="gmd:otherConstraints">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.iso19139.MD_LegalConstraints.otherConstraints</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
					<xsl:value-of select="gmd:otherConstraints/gco:CharacterString"/>
				</dt>
			</xsl:if>
		</dl>
	</xsl:template>
	<xsl:template match="gmd:MD_SecurityConstraints">
		<dl>
			<xsl:if test="gmd:classification">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.iso19139.MD_SecurityConstraints.classification</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
					<xsl:value-of select="gmd:classification/gmd:MD_ClassificationCode/@codeListValue"/>
				</dt>
			</xsl:if>
			<xsl:if test="gmd:userNote">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.iso19139.MD_SecurityConstraints.userNote</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
					<xsl:value-of select="gmd:userNote/gco:CharacterString"/>
				</dt>
			</xsl:if>
			<xsl:if test="gmd:classificationSystem">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.iso19139.MD_SecurityConstraints.classificationSystem</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
					<xsl:value-of select="gmd:classificationSystem/gco:CharacterString"/>
				</dt>
			</xsl:if>
			<xsl:if test="gmd:handlingDescription">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.iso19139.MD_SecurityConstraints.handlingDescription</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
					<xsl:value-of select="gmd:handlingDescription/gco:CharacterString"/>
				</dt>
			</xsl:if>
		</dl>
	</xsl:template>
	<xsl:template name="Distribution_Info">
		<div class="iso_section_title">
			<xsl:call-template name="get_property">
				<xsl:with-param name="key">catalog.iso19139.MD_Distribution</xsl:with-param>
			</xsl:call-template>
		</div>
		<dl>
			<xsl:for-each select="/*[self::gmd:MD_Metadata or self::gmi:MI_Metadata]/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.iso19139.MD_Distribution.distributionFormat</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
				</dt>
				<dt>
					<xsl:apply-templates select="."/>
				</dt>
			</xsl:for-each>
			<xsl:for-each select="/*[self::gmd:MD_Metadata or self::gmi:MI_Metadata]/gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.iso19139.MD_Distribution.transferOptions</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
				</dt>
				<dt>
					<xsl:apply-templates select="gmd:CI_OnlineResource"/>
				</dt>
			</xsl:for-each>
			<xsl:for-each select="/*[self::gmd:MD_Metadata or self::gmi:MI_Metadata]/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.iso19139.MD_Distribution.distributor</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
				</dt>
				<dt>
					<xsl:apply-templates select="."/>
				</dt>
			</xsl:for-each>
		</dl>
	</xsl:template>

	<xsl:template name="Data_Quality_Info">
		<div class="iso_section_title">
			<xsl:call-template name="get_property">
				<xsl:with-param name="key">catalog.iso19139.MD_Metadata.dataQualityInfo</xsl:with-param>
			</xsl:call-template>
		</div>
		<dl>
			<xsl:if test="/*[self::gmd:MD_Metadata or self::gmi:MI_Metadata]/gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:scope/gmd:DQ_Scope/gmd:level/gmd:MD_ScopeCode">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.LivelloDiQualita.caption</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
					<xsl:call-template name="get_property">
						<xsl:with-param name="key">catalog.mdCode.rndt.MD_ScopeCode.<xsl:value-of select="/*[self::gmd:MD_Metadata or self::gmi:MI_Metadata]/gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:scope/gmd:DQ_Scope/gmd:level/gmd:MD_ScopeCode/@codeListValue"/>
						</xsl:with-param>
					</xsl:call-template>
				</dt>
			</xsl:if>
			<xsl:for-each select="/*[self::gmd:MD_Metadata or self::gmi:MI_Metadata]/gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result">
				<xsl:if test="gmd:DQ_ConformanceResult">
					<dt>
						<em>
							<xsl:call-template name="get_property">
								<xsl:with-param name="key">catalog.iso19139.DQ_ConformanceResult</xsl:with-param>
							</xsl:call-template>
							<xsl:text>:&#x20;</xsl:text>
						</em>
					</dt>
					<dt>
						<xsl:apply-templates select="gmd:DQ_ConformanceResult"/>
					</dt>
				</xsl:if>
			</xsl:for-each>
			<xsl:for-each select="/*[self::gmd:MD_Metadata or self::gmi:MI_Metadata]/gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_AbsoluteExternalPositionalAccuracy/gmd:result">
				<xsl:if test="gmd:DQ_QuantitativeResult">
					<dt>
						<em>
							<xsl:call-template name="get_property">
								<xsl:with-param name="key">catalog.mdParam.rndt.dataQuality.positionalAccuracy.caption</xsl:with-param>
							</xsl:call-template>
							<xsl:text>:&#x20;</xsl:text>
						</em>
					</dt>
					<dt>
						<xsl:apply-templates select="gmd:DQ_QuantitativeResult"/>
					</dt>
				</xsl:if>
			</xsl:for-each>
			<xsl:for-each select="/*[self::gmd:MD_Metadata or self::gmi:MI_Metadata]/gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_TopologicalConsistency/gmd:result">
				<xsl:if test="gmd:DQ_QuantitativeResult">
					<dt>
						<em>
							<xsl:call-template name="get_property">
								<xsl:with-param name="key">catalog.mdParam.rndt.dataQuality.topologicalConsistency.caption</xsl:with-param>
							</xsl:call-template>
							<xsl:text>:&#x20;</xsl:text>
						</em>
					</dt>
					<dt>
						<xsl:apply-templates select="../gmd:DQ_TopologicalConsistency"/>
					</dt>
				</xsl:if>
			</xsl:for-each>
			<xsl:for-each select="/*[self::gmd:MD_Metadata or self::gmi:MI_Metadata]/gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/gmd:LI_Lineage/gmd:statement">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.rndt.dataQuality.lineage</xsl:with-param>
						</xsl:call-template>
						<xsl:text>&#x20;</xsl:text>
					</em>
					<xsl:value-of select="/*[self::gmd:MD_Metadata or self::gmi:MI_Metadata]/gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/gmd:LI_Lineage/gmd:statement/gco:CharacterString"/>
				</dt>
			</xsl:for-each>
		</dl>
	</xsl:template>


	<xsl:template match="gmd:DQ_QuantitativeResult">
		<dl>
			<xsl:if test="gmd:value/gco:Record/gco:Real">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.rndt.dataQuality.positionalAccuracy.value</xsl:with-param>
						</xsl:call-template>
						<xsl:text>&#x20;</xsl:text>
					</em>
					<xsl:value-of select="."/>
					<xsl:value-of select="/gmd:MD_Metadata/gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_AbsoluteExternalPositionalAccuracy/gmd:result/gmd:DQ_QuantitativeResult/gmd:valueUnit/gml:BaseUnit/gml:identifier"/> 
				</dt>
			</xsl:if>
		</dl>
	</xsl:template>
	<xsl:template match="gmd:DQ_ConformanceResult">
		<dl>

			<!--         <xsl:choose>
            <xsl:when test="gmd:pass/@gco:nilReason='unknown'">
              <xsl:call-template name="get_property">
                <xsl:with-param name="key">catalog.mdCode.language.iso639_2.<xsl:value-of select="/*[self::gmd:MD_Metadata or self::gmi:MI_Metadata]/gmd:language/gmd:LanguageCode/@codeListValue"/>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="/*[self::gmd:MD_Metadata or self::gmi:MI_Metadata]/gmd:language/gco:CharacterString"/>
            </xsl:otherwise>
          </xsl:choose>
-->

			<xsl:if test="gmd:pass">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.iso19139.DQ_ConformanceResult.pass.Boolean</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
					<xsl:choose>
						<xsl:when test="gmd:pass/@gco:nilReason='unknown'">
							<xsl:call-template name="get_property">
								<xsl:with-param name="key">catalog.mdParam.rndt.dataQuality.conformity.degree.notEvaluated</xsl:with-param>
							</xsl:call-template>
							<!--<xsl:with-param name="key">catalog.mdParam.rndt.dataQuality.conformity.degree.notEvaluated</xsl:with-param>-->
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="gmd:pass"/>
						</xsl:otherwise>
					</xsl:choose>
				</dt>
			</xsl:if>



			<xsl:if test="gmd:explanation">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.rndt.dataQuality.conformity.explanation</xsl:with-param>
						</xsl:call-template>
						<xsl:text>&#x20;</xsl:text>
					</em>
					<xsl:value-of select="gmd:explanation/gco:CharacterString"/>
				</dt>
			</xsl:if>
			<xsl:if test="gmd:specification">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.inspire.conformity.caption</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
				</dt>
				<dt>
					<xsl:apply-templates select="gmd:specification/gmd:CI_Citation"/>
				</dt>
			</xsl:if>
		</dl>
	</xsl:template>

	<xsl:template match="gmd:DQ_TopologicalConsistency">
		<dl>
			<xsl:if test="gmd:nameOfMeasure">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.rndt.dataQuality.topologicalConsistency.nameOfMeasure</xsl:with-param>
						</xsl:call-template>
						<xsl:text>&#x20;</xsl:text>
					</em>
					<xsl:value-of select="gmd:nameOfMeasure/gco:CharacterString"/> 
				</dt>
			</xsl:if>
			<xsl:if test="gmd:evaluationMethodType">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.rndt.dataQuality.topologicalConsistency.evaluationMethodType</xsl:with-param>
						</xsl:call-template>
						<xsl:text>&#x20;</xsl:text>
					</em>
					<xsl:value-of select="gmd:evaluationMethodType/gmd:DQ_EvaluationMethodTypeCode"/> 
				</dt>
			</xsl:if>		
			<xsl:if test="gmd:evaluationMethodDescription">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.rndt.dataQuality.topologicalConsistency.evaluationMethodDescription</xsl:with-param>
						</xsl:call-template>
						<xsl:text>&#x20;</xsl:text>
					</em>
					<xsl:value-of select="gmd:evaluationMethodType/gmd:DQ_EvaluationMethodDescription/gco:CharacterString"/> 
				</dt>
			</xsl:if>				
			<xsl:if test="gmd:dateTime">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.rndt.dataQuality.topologicalConsistency.dateTime</xsl:with-param>
						</xsl:call-template>
						<xsl:text>&#x20;</xsl:text>
					</em>
					<xsl:value-of select="gmd:dateTime/gco:DateTime"/> 
				</dt>
			</xsl:if>		
			<xsl:if test="gmd:result">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.rndt.dataQuality.topologicalConsistency.value</xsl:with-param>
						</xsl:call-template>
						<xsl:text>&#x20;</xsl:text>
					</em>
					<xsl:value-of select="gmd:DQ_QuantitativeResult/gmd:value/gco:Record"/> 
				</dt>
			</xsl:if>
		</dl>
	</xsl:template>
	
	<xsl:template match="gmd:specification/gmd:CI_Citation">
		<dl>
			<xsl:if test="gmd:title">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.rndt.dataQuality.conformity.title</xsl:with-param>
						</xsl:call-template>
						<xsl:text>&#x20;</xsl:text>
					</em>
					<xsl:value-of select="gmd:title/gco:CharacterString | gmd:title/gmx:Anchor"/>
				</dt>
			</xsl:if>
			<xsl:for-each select="gmd:date">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.iso19139.CI_Citation.<xsl:value-of select="local-name()"/>
							</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
				</dt>
				<dt>
					<xsl:apply-templates select="gmd:CI_Date"/>
				</dt>
			</xsl:for-each>
		</dl>
	</xsl:template>

	<xsl:template match="gmd:thesaurusName/gmd:CI_Citation">
		<dl>
			<xsl:if test="gmd:title">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.rndt.dataQuality.conformity.title</xsl:with-param>
						</xsl:call-template>
						<xsl:text>&#x20;</xsl:text>
					</em>
					<xsl:value-of select="gmd:title/gco:CharacterString | gmd:title/gmx:Anchor"/>
				</dt>
			</xsl:if>
			<xsl:for-each select="gmd:date">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.iso19139.CI_Citation.<xsl:value-of select="local-name()"/>
							</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
				</dt>
				<dt>
					<xsl:apply-templates select="gmd:CI_Date"/>
				</dt>
			</xsl:for-each>
		</dl>
	</xsl:template>

	<xsl:template match="/*[self::gmd:MD_Metadata or self::gmi:MI_Metadata]/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor">
		<dl>
			<xsl:for-each select="gmd:MD_Distributor/gmd:distributorFormat">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.iso19139.MD_Distributor.distributorFormat</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
				</dt>
				<dt>
					<xsl:apply-templates select="."/>
				</dt>
			</xsl:for-each>
			<xsl:for-each select="gmd:MD_Distributor/gmd:distributorTransferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.iso19139.CI_OnlineResource</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
				</dt>
				<dt>
					<xsl:apply-templates select="gmd:CI_OnlineResource"/>
				</dt>
			</xsl:for-each>
			<xsl:for-each select="gmd:MD_Distributor/gmd:distributorContact">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.iso19139.MD_Distributor.distributorContact</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
				</dt>
				<dt>
					<xsl:apply-templates select="gmd:CI_ResponsibleParty"/>
				</dt>
			</xsl:for-each>
		</dl>
	</xsl:template>


	<xsl:template match="gmd:CI_OnlineResource | srv:connectPoint/gmd:CI_OnlineResource">
		<dl>
			<xsl:if test="gmd:linkage/gmd:URL">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.iso19139.CI_OnlineResource.linkage</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
					<a>
						<xsl:attribute name="href">
							<xsl:value-of select="gmd:linkage/gmd:URL"/>
						</xsl:attribute>
						<xsl:value-of select="gmd:linkage/gmd:URL"/>
					</a>
				</dt>
			</xsl:if>
			<xsl:for-each select="gmd:protocol">
				<xsl:if test="gmd:protocol">
					<dt>
						<em>
							<xsl:call-template name="get_property">
								<xsl:with-param name="key">catalog.iso19139.CI_OnlineResource.protocol</xsl:with-param>
							</xsl:call-template>
							<xsl:text>:&#x20;</xsl:text>
						</em>
						<xsl:value-of select="gmd:protocol"/>
					</dt>
				</xsl:if>
			</xsl:for-each>
			<xsl:for-each select="gmd:applicationProfile">
				<xsl:if test="gmd:applicationProfile">
					<dt>
						<em>
							<xsl:call-template name="get_property">
								<xsl:with-param name="key">catalog.iso19139.CI_OnlineResource.applicationProfile</xsl:with-param>
							</xsl:call-template>
							<xsl:text>:&#x20;</xsl:text>
						</em>
						<xsl:value-of select="gmd:applicationProfile"/>
					</dt>
				</xsl:if>
			</xsl:for-each>
			<xsl:for-each select="gmd:name">
				<xsl:if test="gmd:name">
					<dt>
						<em>
							<xsl:call-template name="get_property">
								<xsl:with-param name="key">catalog.iso19139.CI_OnlineResource.name</xsl:with-param>
							</xsl:call-template>
							<xsl:text>:&#x20;</xsl:text>
						</em>
						<xsl:value-of select="gmd:name"/>
					</dt>
				</xsl:if>
			</xsl:for-each>
			<xsl:for-each select="gmd:description">
				<xsl:if test="gmd:description">
					<dt>
						<em>
							<xsl:call-template name="get_property">
								<xsl:with-param name="key">catalog.iso19139.CI_OnlineResource.description</xsl:with-param>
							</xsl:call-template>
							<xsl:text>:&#x20;</xsl:text>
						</em>
						<xsl:value-of select="gmd:description"/>
					</dt>
				</xsl:if>
			</xsl:for-each>
			<xsl:for-each select="gmd:function">
				<xsl:if test="gmd:function">
					<dt>
						<em>
							<xsl:call-template name="get_property">
								<xsl:with-param name="key">catalog.iso19139.CI_OnlineResource.function</xsl:with-param>
							</xsl:call-template>
							<xsl:text>:&#x20;</xsl:text>
						</em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.iso19139.CI_OnLineFunctionCode.<xsl:value-of select="gmd:CI_OnLineFunctionCode/@codeListValue"/>
							</xsl:with-param>
						</xsl:call-template>
					</dt>
				</xsl:if>
			</xsl:for-each>
		</dl>
	</xsl:template>


	<xsl:template match="*[self::gmd:MD_Metadata or self::gmi:MI_Metadata]/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat">
		<dl>
			<xsl:if test="gmd:MD_Format/gmd:name | gmd:MD_Format/gmx:Anchor">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.iso19139.MD_Format.name</xsl:with-param>
						</xsl:call-template>
						<xsl:text>&#x20;</xsl:text>
					</em>
					<xsl:value-of select="gmd:MD_Format/gmd:name | gmd:MD_Format/gmx:Anchor"/>
				</dt>
			</xsl:if>
			<xsl:if test="gmd:MD_Format/gmd:version">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.iso19139.MD_Format.version</xsl:with-param>
						</xsl:call-template>
						<xsl:text>&#x20;</xsl:text>
					</em>
					<xsl:value-of select="gmd:MD_Format/gmd:version"/>
				</dt>
			</xsl:if>
			<xsl:if test="gmd:MD_Format/gmd:amendmentNumber">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.iso19139.MD_Format.amendmentNumber</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
					<xsl:value-of select="gmd:MD_Format/gmd:amendmentNumber"/>
				</dt>
			</xsl:if>
			<xsl:if test="gmd:MD_Format/gmd:specification">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.iso19139.MD_Format.specification</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
					<xsl:value-of select="gmd:MD_Format/gmd:specification"/>
				</dt>
			</xsl:if>
			<xsl:if test="gmd:MD_Format/gmd:fileDecompressionTechnique">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.iso19139.MD_Format.fileDecompressionTechnique</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
					<xsl:value-of select="gmd:MD_Format/gmd:fileDecompressionTechnique"/>
				</dt>
			</xsl:if>
			<xsl:if test="gmd:MD_Format/gmd:formatDistributor">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.iso19139.MD_Format.formatDistributor</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
					<xsl:apply-templates select="gmd:MD_Format/gmd:formatDistributor"/>
				</dt>
			</xsl:if>
		</dl>
	</xsl:template>


	<xsl:template match="srv:containsOperations/srv:SV_OperationMetadata">
		<dl>
			<xsl:if test="srv:operationName/gco:CharacterString">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.rndt.identification.containsoperations.operationname</xsl:with-param>
						</xsl:call-template>
						<xsl:text>&#x20;</xsl:text>
					</em>
					<xsl:value-of select="srv:operationName/gco:CharacterString"/>
				</dt>
			</xsl:if>
			<xsl:for-each select="srv:DCP">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.iso19139.SV_PlatformSpecificServiceSpecification.DCP</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
					<xsl:call-template name="get_property">
						<xsl:with-param name="key">catalog.iso19139.DCPList.<xsl:value-of select="srv:DCPList/@codeListValue"/>
						</xsl:with-param>
					</xsl:call-template>
				</dt>
			</xsl:for-each>
			<xsl:if test="srv:operationDescription/gco:CharacterString">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.iso19139.SV_OperationMetadata.operationDescription</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
					<xsl:value-of select="srv:operationDescription/gco:CharacterString"/>
				</dt>
			</xsl:if>
			<xsl:for-each select="srv:connectPoint/gmd:CI_OnlineResource">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.rndt.identification.containsoperations.connectpoint</xsl:with-param>
						</xsl:call-template>
						<xsl:text>&#x20;</xsl:text>
					</em>
				</dt>
				<dt>
					<xsl:apply-templates select="."/>
				</dt>
			</xsl:for-each>
		</dl>
	</xsl:template>

	<xsl:template match="gmd:graphicOverview/gmd:MD_BrowseGraphic">
		<dl>
			<xsl:if test="gmd:fileName">
				<dt>
					<img>
						<xsl:attribute name="src">
							<xsl:value-of select="gmd:fileName/gco:CharacterString"/>
						</xsl:attribute>
						<xsl:attribute name="alt">
							<xsl:value-of select="gmd:fileName/gco:CharacterString"/>
						</xsl:attribute>
					</img>
					<xsl:text disable-output-escaping="yes"><![CDATA[</img>]]></xsl:text>
				</dt>
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.rndt.identification.thumbnail.url</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
					<xsl:value-of select="gmd:fileName/gco:CharacterString"/>
				</dt>
			</xsl:if>
			<xsl:if test="gmd:fileType">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.rndt.identification.thumbnail.type</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
					<xsl:value-of select="gmd:fileType"/>
				</dt>
			</xsl:if>
			<xsl:if test="gmd:fileDescription">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.mdParam.rndt.identification.thumbnail.description</xsl:with-param>
						</xsl:call-template>
						<xsl:text>:&#x20;</xsl:text>
					</em>
					<xsl:value-of select="gmd:fileDescription"/>
				</dt>
			</xsl:if>
		</dl>
	</xsl:template>


	<!-- ISO19115-2 -->
	<!-- Acquisition Information -->
	<xsl:template name="Acquisition_Info">
		<div class="iso_section_title">
			<xsl:call-template name="get_property">
				<xsl:with-param name="key">catalog.iso19139-2.MI_Metadata.section.acquisition</xsl:with-param>
			</xsl:call-template>
		</div>
		<dl>
			<xsl:for-each select="/gmi:MI_Metadata/gmi:acquisitionInformation/gmi:MI_AcquisitionInformation">
				<dt>
					<em>
						<xsl:call-template name="get_property">
							<xsl:with-param name="key">catalog.iso19139-2.MI_Metadata.acquisition</xsl:with-param>
						</xsl:call-template> (<xsl:value-of select="position()"/>)<xsl:text>:&#x20;</xsl:text>
					</em>
				</dt>
				<dl>
					<dt>
						<!-- gmi:acquisitionRequirement -->
						<em>
							<xsl:call-template name="get_property">
								<xsl:with-param name="key">catalog.iso19139-2.MI_Metadata.section.acuisition.requirement</xsl:with-param>
							</xsl:call-template>
							<xsl:text>&#x20;</xsl:text>
						</em>
						<dl>            
							<xsl:for-each select="gmi:acquisitionRequirement/gmi:MI_Requirement">
								<dt>
									<em>
										<xsl:call-template name="get_property">
											<xsl:with-param name="key">catalog.iso19139-2.MI_Metadata.section.acuisition.requirement</xsl:with-param>
										</xsl:call-template> (<xsl:value-of select="position()"/>)<xsl:text>:&#x20;</xsl:text>
									</em>
									<dl>
										<dt>
											<xsl:apply-templates select="."/>
										</dt>
									</dl>
								</dt>
							</xsl:for-each>
						</dl>

						<!-- gmi:objective -->
						<em>
							<xsl:call-template name="get_property">
								<xsl:with-param name="key">catalog.iso19139-2.MI_Metadata.section.acuisition.objective</xsl:with-param>
							</xsl:call-template>
							<xsl:text>&#x20;</xsl:text>
						</em>
						<dl>            
							<xsl:for-each select="gmi:objective/gmi:MI_Objective">
								<dt>
									<em>
										<xsl:call-template name="get_property">
											<xsl:with-param name="key">catalog.iso19139-2.MI_Metadata.section.acuisition.objective</xsl:with-param>
										</xsl:call-template> (<xsl:value-of select="position()"/>)<xsl:text>:&#x20;</xsl:text>
									</em>
									<dl>
										<dt>
											<xsl:apply-templates select="."/>
										</dt>
									</dl>
								</dt>
							</xsl:for-each>
						</dl>

						<!-- gmi:instrument -->
						<em>
							<xsl:call-template name="get_property">
								<xsl:with-param name="key">catalog.iso19139-2.MI_Metadata.section.acuisition.instrument</xsl:with-param>
							</xsl:call-template>
							<xsl:text>&#x20;</xsl:text>
						</em>
						<dl>            
							<xsl:for-each select="gmi:objective/gmi:MI_Objective">
								<dt>
									<em>
										<xsl:call-template name="get_property">
											<xsl:with-param name="key">catalog.iso19139-2.MI_Metadata.section.acuisition.instrument</xsl:with-param>
										</xsl:call-template> (<xsl:value-of select="position()"/>)<xsl:text>:&#x20;</xsl:text>
									</em>
									<dl>
										<dt>
											<xsl:apply-templates select="."/>
										</dt>
									</dl>
								</dt>
							</xsl:for-each>
						</dl>

						<!-- gmi:acquisitionPlan -->
						<em>
							<xsl:call-template name="get_property">
								<xsl:with-param name="key">catalog.iso19139-2.MI_Metadata.section.acuisition.plan</xsl:with-param>
							</xsl:call-template>
							<xsl:text>&#x20;</xsl:text>
						</em>
						<dl>            
							<xsl:for-each select="gmi:acquisitionPlan/gmi:MI_Plan">
								<dt>
									<em>
										<xsl:call-template name="get_property">
											<xsl:with-param name="key">catalog.iso19139-2.MI_Metadata.section.acuisition.plan</xsl:with-param>
										</xsl:call-template> (<xsl:value-of select="position()"/>)<xsl:text>:&#x20;</xsl:text>
									</em>
									<dl>
										<dt>
											<xsl:apply-templates select="."/>
										</dt>
									</dl>
								</dt>
							</xsl:for-each>
						</dl>

						<!-- gmi:operation -->
						<em>
							<xsl:call-template name="get_property">
								<xsl:with-param name="key">catalog.iso19139-2.MI_Metadata.section.acuisition.operation</xsl:with-param>
							</xsl:call-template>
							<xsl:text>&#x20;</xsl:text>
						</em>
						<dl>            
							<xsl:for-each select="gmi:operation/gmi:MI_Operation">
								<dt>
									<em>
										<xsl:call-template name="get_property">
											<xsl:with-param name="key">catalog.iso19139-2.MI_Metadata.section.acuisition.operation</xsl:with-param>
										</xsl:call-template> (<xsl:value-of select="position()"/>)<xsl:text>:&#x20;</xsl:text>
									</em>
									<dl>
										<dt>
											<xsl:apply-templates select="."/>
										</dt>
									</dl>
								</dt>
							</xsl:for-each>
						</dl>

						<!-- gmi:platform -->
						<em>
							<xsl:call-template name="get_property">
								<xsl:with-param name="key">catalog.iso19139-2.MI_Metadata.section.acuisition.platform</xsl:with-param>
							</xsl:call-template>
							<xsl:text>&#x20;</xsl:text>
						</em>
						<dl>            
							<xsl:for-each select="gmi:platform/gmi:MI_Platform">
								<dt>
									<em>
										<xsl:call-template name="get_property">
											<xsl:with-param name="key">catalog.iso19139-2.MI_Metadata.section.acuisition.platform</xsl:with-param>
										</xsl:call-template> (<xsl:value-of select="position()"/>)<xsl:text>:&#x20;</xsl:text>
									</em>
									<dl>
										<dt>
											<xsl:apply-templates select="."/>
										</dt>
									</dl>
								</dt>
							</xsl:for-each>
						</dl>
					</dt>
				</dl>

			</xsl:for-each>
		</dl>
	</xsl:template>


	<xsl:template match="gmd:RS_Identifier | gmi:identifier/gmd:MD_Identifier">
		<dt>
			<em>
				<xsl:call-template name="get_property">
					<xsl:with-param name="key">catalog.iso19139.XTN_Identification.citation.RS_Identifier</xsl:with-param>
				</xsl:call-template>
				<xsl:text>:&#x20;</xsl:text>
			</em>
			<xsl:apply-templates select="gmd:RS_Identifier/gmd:code/gco:CharacterString"/>

			<dl>
				<xsl:if test="gmd:code/gco:CharacterString">
					<dt>
						<em>
							<xsl:call-template name="get_property">
								<xsl:with-param name="key">catalog.iso19139.RS_Identifier.code</xsl:with-param>
							</xsl:call-template>
							<xsl:text>:&#x20;</xsl:text>
						</em>
						<xsl:value-of select="gmd:code/gco:CharacterString"/>
					</dt>
				</xsl:if>
				<xsl:if test="gmd:codeSpace/gco:CharacterString">
					<dt>
						<em>
							<xsl:call-template name="get_property">
								<xsl:with-param name="key">catalog.iso19139.RS_Identifier.codeSpace</xsl:with-param>
							</xsl:call-template>
							<xsl:text>:&#x20;</xsl:text>
						</em>
						<xsl:value-of select="gmd:codeSpace/gco:CharacterString"/>
					</dt>
				</xsl:if>
			</dl>
		</dt>
	</xsl:template>

	<xsl:template match="gmi:requestor">
		<dt>
			<em>
				<xsl:call-template name="get_property">
					<xsl:with-param name="key">catalog.iso19139-2.MI_Metadata.acquisition.requirement.requestor</xsl:with-param>
				</xsl:call-template>
				<xsl:text>&#x20;</xsl:text>
			</em>
			<xsl:apply-templates select="gmd:CI_ResponsibleParty"/>
		</dt>
	</xsl:template>

	<xsl:template match="gmi:recipient">
		<dt>
			<em>
				<xsl:call-template name="get_property">
					<xsl:with-param name="key">catalog.iso19139-2.MI_Metadata.acquisition.requirement.recipient</xsl:with-param>
				</xsl:call-template>
				<xsl:text>&#x20;</xsl:text>
			</em>
			<xsl:apply-templates select="gmd:CI_ResponsibleParty"/>
		</dt>
	</xsl:template>

	<xsl:template match="gmi:priority">
		<xsl:if test="gmi:MI_PriorityCode">
			<dt>
				<em>
					<xsl:call-template name="get_property">
						<xsl:with-param name="key">catalog.iso19139-2.MI_Metadata.acquisition.requirement.priority</xsl:with-param>
					</xsl:call-template>
					<xsl:text>:&#x20;</xsl:text>
				</em>
				<xsl:call-template name="get_property">
					<xsl:with-param name="key">catalog.iso19139-2.MI_Metadata.acquisition.requirement.priorityCode.<xsl:value-of select="gmi:MI_PriorityCode/@codeListValue"/>
					</xsl:with-param>
				</xsl:call-template>
			</dt>
		</xsl:if>
	</xsl:template>


	<xsl:template match="gmi:requestedDate">
		<xsl:if test="gmi:MI_RequestedDate">
			<dt>
				<em>
					<xsl:call-template name="get_property">
						<xsl:with-param name="key">catalog.iso19139-2.MI_Metadata.acquisition.requirement.requestedDate</xsl:with-param>
					</xsl:call-template>
					<xsl:text>:&#x20;</xsl:text>
				</em>

				<dl>
					<xsl:if test="gmi:MI_RequestedDate/gmi:requestedDateOfCollection/gco:DateTime">
						<dt>
							<em>
								<xsl:call-template name="get_property">
									<xsl:with-param name="key">catalog.iso19139-2.MI_Metadata.acquisition.requirement.requestedDate.requestedDateOfCollection</xsl:with-param>
								</xsl:call-template>
								<xsl:text>:&#x20;</xsl:text>
							</em>
							<xsl:value-of select="gmi:MI_RequestedDate/gmi:requestedDateOfCollection/gco:DateTime"/>
						</dt>
					</xsl:if>
					<xsl:if test="gmi:MI_RequestedDate/gmi:latestAcceptableDate/gco:DateTime">
						<dt>
							<em>
								<xsl:call-template name="get_property">
									<xsl:with-param name="key">catalog.iso19139-2.MI_Metadata.acquisition.requirement.requestedDate.latestAcceptableDate</xsl:with-param>
								</xsl:call-template>
								<xsl:text>:&#x20;</xsl:text>
							</em>
							<xsl:value-of select="gmi:MI_RequestedDate/gmi:latestAcceptableDate/gco:DateTime"/>
						</dt>
					</xsl:if>
				</dl>
			</dt>
		</xsl:if>
	</xsl:template>  


	<xsl:template match="gmi:expiryDate">
		<dt>
			<em>
				<xsl:call-template name="get_property">
					<xsl:with-param name="key">catalog.iso19139-2.MI_Metadata.acquisition.requirement.expiryDate</xsl:with-param>
				</xsl:call-template>
				<xsl:text>:&#x20;</xsl:text>
			</em>

			<xsl:value-of select="gco:DateTime"/>
		</dt>
	</xsl:template> 

	<!--  Objective Type Code -->
	<xsl:template match="gmi:type">
		<xsl:if test="gmi:ObjectiveTypeCode ">
			<dt>
				<em>
					<xsl:call-template name="get_property">
						<xsl:with-param name="key">catalog.iso19139-2.MI_Metadata.acquisition.objective.type</xsl:with-param>
					</xsl:call-template>
					<xsl:text>:&#x20;</xsl:text>
				</em>
				<xsl:call-template name="get_property">
					<xsl:with-param name="key">catalog.iso19139-2.MI_Metadata.acquisition.objective<xsl:value-of select="gmi:ObjectiveTypeCode/@codeListValue"/>
					</xsl:with-param>
				</xsl:call-template>
			</dt>
		</xsl:if>
	</xsl:template>

	<xsl:template match="gmi:MI_Operation/gmi:description | gmi:MI_Platform/gmi:description">
		<dt>
			<em>
				<xsl:call-template name="get_property">
					<xsl:with-param name="key">catalog.iso19139-2.MI_Metadata.acuisition.operation.description</xsl:with-param>
				</xsl:call-template>
				<xsl:text>:&#x20;</xsl:text>
			</em>

			<xsl:value-of select="gco:CharacterString"/>
		</dt>
	</xsl:template>

	<xsl:template match="gmi:MI_Instrument/gmi:description">
		<dt>
			<em>
				<xsl:call-template name="get_property">
					<xsl:with-param name="key">catalog.iso19139-2.MI_Metadata.acuisition.instrument.description</xsl:with-param>
				</xsl:call-template>
				<xsl:text>:&#x20;</xsl:text>
			</em>

			<xsl:value-of select="gco:CharacterString"/>
		</dt>
	</xsl:template>


	<xsl:template match="gmi:trigger">
		<xsl:if test="gmi:MI_TriggerCode">
			<dt>
				<em>
					<xsl:call-template name="get_property">
						<xsl:with-param name="key">catalog.iso19139-2.MI_Metadata.acquisition.event.trigger</xsl:with-param>
					</xsl:call-template>
					<xsl:text>:&#x20;</xsl:text>
				</em>
				<xsl:call-template name="get_property">
					<xsl:with-param name="key">catalog.iso19139-2.MI_Metadata.acquisition.event.triggerCode.<xsl:value-of select="gmi:MI_TriggerCode/@codeListValue"/>
					</xsl:with-param>
				</xsl:call-template>
			</dt>
		</xsl:if>
	</xsl:template>

	<xsl:template match="gmi:context">
		<xsl:if test="gmi:MI_ContextCode">
			<dt>
				<em>
					<xsl:call-template name="get_property">
						<xsl:with-param name="key">catalog.iso19139-2.MI_Metadata.acquisition.event.context</xsl:with-param>
					</xsl:call-template>
					<xsl:text>:&#x20;</xsl:text>
				</em>
				<xsl:call-template name="get_property">
					<xsl:with-param name="key">catalog.iso19139-2.MI_Metadata.acquisition.event.contextCode.<xsl:value-of select="gmi:MI_ContextCode/@codeListValue"/>
					</xsl:with-param>
				</xsl:call-template>
			</dt>
		</xsl:if>
	</xsl:template>

	<xsl:template match="gmi:sequence">
		<xsl:if test="gmi:MI_SequenceCode">
			<dt>
				<em>
					<xsl:call-template name="get_property">
						<xsl:with-param name="key">catalog.iso19139-2.MI_Metadata.acquisition.event.sequence</xsl:with-param>
					</xsl:call-template>
					<xsl:text>:&#x20;</xsl:text>
				</em>
				<xsl:call-template name="get_property">
					<xsl:with-param name="key">catalog.iso19139-2.MI_Metadata.acquisition.event.sequenceCode.<xsl:value-of select="gmi:MI_SequenceCode/@codeListValue"/>
					</xsl:with-param>
				</xsl:call-template>
			</dt>
		</xsl:if>
	</xsl:template>

	<xsl:template match="gmi:function">
		<dt>
			<em>
				<xsl:call-template name="get_property">
					<xsl:with-param name="key">catalog.iso19139-2.MI_Metadata.acquisition.objective.function</xsl:with-param>
				</xsl:call-template>
				<xsl:text>:&#x20;</xsl:text>
			</em>

			<xsl:value-of select="gco:CharacterString"/>
		</dt>
	</xsl:template>

	<xsl:template match="gmi:status">
		<xsl:if test="gmd:MD_ProgressCode">

			<dt>
				<em>
					<xsl:call-template name="get_property">
						<xsl:with-param name="key">catalog.iso19139.MD_ProgressCode</xsl:with-param>
					</xsl:call-template>
					<xsl:text>:&#x20;</xsl:text>
				</em>
				<xsl:call-template name="get_property">
					<xsl:with-param name="key">catalog.iso19139.MD_ProgressCode.<xsl:value-of select="gmd:MD_ProgressCode/@codeListValue"/>
					</xsl:with-param>
				</xsl:call-template>
			</dt>
			<!-- this is here to get the contact info to properly show up after the status info. not sure why this is needed -->
			<dt/>
		</xsl:if>
	</xsl:template>
	
	<!-- Template per Google Dataset Search -->
	<xsl:template name="Google_Dataset">
	<!-- Variabili -->

		<xsl:variable name="urlSito" select="'https://geodati.gov.it/resource/id/'" /> 
		<xsl:variable name="urlSameAs" select="'https://geodati.gov.it/geoportale/visualizzazione-metadati/scheda-metadati?uuid='" /> 
		<xsl:variable name="fileId" select="/gmd:MD_Metadata/gmd:fileIdentifier/gco:CharacterString" /> 
		<xsl:variable name="title" select="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString" /> 

		<xsl:variable name="datePub" select="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:dateType/gmd:CI_DateTypeCode[@codeListValue='publication']/../../gmd:date/gco:Date" />
		<xsl:variable name="dateCre" select="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:dateType/gmd:CI_DateTypeCode[@codeListValue='creation']/../../gmd:date/gco:Date" />
		<xsl:variable name="dateRev" select="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:dateType/gmd:CI_DateTypeCode[@codeListValue='revision']/../../gmd:date/gco:Date" />
		<xsl:variable name="responsible" select="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString" />
		<xsl:variable name="abstract" select="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:abstract/gco:CharacterString" /> 
		<xsl:variable name="email" select="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty[1]/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress/gco:CharacterString" />
		<xsl:variable name="site" select="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:onlineResource/gmd:CI_OnlineResource/gmd:linkage/gmd:URL" />	
		<xsl:variable name="dataId" select="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:identifier/gmd:MD_Identifier/gmd:code/gco:CharacterString | /gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:identifier/gmd:RS_Identifier/gmd:code/gco:CharacterString" />
		<xsl:variable name="keywords">
			<xsl:for-each select="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword" >
				<xsl:choose>
					<xsl:when test="position() = 1">
						<xsl:value-of select="gco:CharacterString"/>
					</xsl:when>
					<xsl:otherwise>
						,<xsl:value-of select="gco:CharacterString"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:variable> 	

		<xsl:variable name="boxWest" select="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:westBoundLongitude/gco:Decimal" />
		<xsl:variable name="boxEast" select="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:eastBoundLongitude/gco:Decimal" />		
		<xsl:variable name="boxSouth" select="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:southBoundLatitude/gco:Decimal" />		
		<xsl:variable name="boxNorth" select="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:northBoundLatitude/gco:Decimal" />
		<xsl:variable name="urls" select="/gmd:MD_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:linkage/gmd:URL" />
		<xsl:variable name="thumbnailUrl" select="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:graphicOverview/gmd:MD_BrowseGraphic[1]/gmd:fileName/gco:CharacterString" />
		<xsl:variable name="temporalCoverageStart" select="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:beginPosition" />
		<xsl:variable name="temporalCoverageEnd" select="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:endPosition" />
		<xsl:variable name="alternateName" select="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:identifier/gmd:RS_Identifier/gmd:code/gco:CharacterString" />
		<xsl:variable name="license" select="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/gmd:MD_Constraints/gmd:useLimitation/gco:CharacterString" />
		
		<!-- Fine variabili -->

		<!-- Snippet package/snippets/altmetric_indexing.html start -->
		<link rel="canonical" href="{concat($urlSito, $fileId)}"/>
		<xsl:text disable-output-escaping="yes"><![CDATA[</link>]]></xsl:text>

		<meta name="citation_title" content="{$title}"/>
		<xsl:text disable-output-escaping="yes"><![CDATA[</meta>]]></xsl:text>

		<xsl:choose>
			<xsl:when test="$datePub">
				<meta name="citation_online_date" content="{$datePub}"/>
			</xsl:when>
			<xsl:when test="$dateRev">
				<meta name="citation_online_date" content="{$dateRev}"/>
			</xsl:when>
			<xsl:when test="$dateCre">
				<meta name="citation_online_date" content="{$dateCre}"/>
			</xsl:when>
			<xsl:otherwise>
				<meta name="citation_online_date" content="'30/04/2018"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text disable-output-escaping="yes"><![CDATA[</meta>]]></xsl:text>

		<meta name="citation_publisher" content="{$responsible}"/>
		<xsl:text disable-output-escaping="yes"><![CDATA[</meta>]]></xsl:text>

		<!-- Snippet package/snippets/altmetric_indexing.html end -->


		<!-- Snippet package/snippets/schemaorg_indexing.html start -->
		<script type="application/ld+json">
		[{
			"@context": "http://schema.org/",
			"@type": "Organization",
			"url": "https://geodati.gov.it/",
			"logo": "https://geodati.gov.it/geoportale/templates/rndt/images/logo.png"
		},
		{
			"@context":"http://schema.org",
			"@type":"Dataset",
			"@id":"<xsl:value-of select="concat($urlSito, $fileId)" />",
			"name":"<xsl:call-template name="escapeString"><xsl:with-param name="s" select="$title"/></xsl:call-template>",
			"description":"<xsl:call-template name="escapeString"><xsl:with-param name="s" select="$abstract"/></xsl:call-template>",
			<xsl:if test="$thumbnailUrl">
				"thumbnailUrl": "<xsl:value-of select="$thumbnailUrl" />",	
			</xsl:if>
			"publisher":{"@type":"Organization","name":"<xsl:value-of select="$responsible" />", "email": "mailto:<xsl:value-of select="$email" />"
			<xsl:if test="$site">
				, "url":"<xsl:value-of select="$site" />"
			</xsl:if>},
			<xsl:if test="$datePub">
				"datePublished" : "<xsl:value-of select="$datePub" />",	
			</xsl:if>
			<xsl:if test="$dateCre">
				"dateCreated": "<xsl:value-of select="$dateCre" />",	
			</xsl:if>
			<xsl:if test="$dateRev">
				"dateModified": "<xsl:value-of select="$dateRev" />",	
			</xsl:if>

			"url":"<xsl:value-of select="concat($urlSito, $fileId)" />",
			"identifier": {
			"@type": "PropertyValue",
			"value":  "<xsl:value-of select="$dataId" />"
			},
			"sameAs":"<xsl:value-of select="concat($urlSameAs, $fileId)" />",
			"keywords":"<xsl:value-of select="translate($keywords,'&#xA;&#xD;&#x9;', '')" />",
			"spatial":[{"@type":"Place","geo":{"@type":"GeoShape","box":"<xsl:value-of select="concat($boxSouth, ' ', $boxEast, ' ', $boxNorth, ' ', $boxWest)" />"}}],
			"distribution":[
				<xsl:for-each select="/gmd:MD_Metadata/gmd:distributionInfo/gmd:MD_Distribution">
				<xsl:if test="not(position() = 1)">
					,
				</xsl:if>
				{
					  "@type":"DataDownload",
					  "fileFormat":"<xsl:value-of select="./gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString" />",
					  "contentUrl":"<xsl:value-of select=".//gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:linkage/gmd:URL"/>"
				}
				</xsl:for-each>
			],
			
			<xsl:if test="$temporalCoverageStart">
				"temporalCoverage" : "<xsl:value-of select="concat($temporalCoverageStart, '/', $temporalCoverageEnd)" />",	
			</xsl:if>
			<xsl:if test="$alternateName">
				"alternateName" : "<xsl:value-of select="$alternateName" />",	
			</xsl:if>
			<xsl:if test="$license">
				"license" : { 
					"@type": "Dataset",
					"text": "<xsl:call-template name="escapeString"><xsl:with-param name="s" select="$license"/></xsl:call-template>"
				},
			</xsl:if>

			"includedInDataCatalog":{"@type":"DataCatalog","name":"RNDT - Repertorio Nazionale dei Dati Territoriali","url":"https://geodati.gov.it"}
		}]
		</script>

		<!-- Snippet package/snippets/schemaorg_indexing.html end -->

	</xsl:template>

<!-- template for escaping text -->
	<xsl:template name="escapeString">
		<xsl:param name="s" select="''"/>
		<xsl:param name="encoded" select="''"/>
		
		<xsl:variable name="z" select="translate($s, '&#xA;&#x9;&#xD;', '  ')"/>
		<xsl:choose>
			<xsl:when test="$z = ''">
				<xsl:value-of select="$encoded"/>
			</xsl:when>
			<xsl:when test="contains($z, '&quot;')">
				
				<xsl:call-template name="escapeString">
					<xsl:with-param name="s" select="substring-after($z,'&quot;')"/>
					<xsl:with-param name="encoded"
						select="concat($encoded,substring-before($z,'&quot;'),'\&quot;')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<!--        <xsl:call-template name="removeBreaks"><xsl:with-param name="s" select="concat($encoded, $s)"/></xsl:call-template> -->
				<xsl:value-of select="normalize-space(concat($encoded, $z))"/>
				
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!--                     -->
	<!--   Properties        -->
	<!--                     -->
	<xsl:template name="get_property">
		<xsl:param name="key"/>
		<!-- Converted parameters from gpt.properties -->
		<xsl:choose>
			<xsl:when test='$key = &quot;catalog.agportal.citation.publInfo.publicationDate&quot; '>i18n.catalog.agportal.citation.publInfo.publicationDate</xsl:when>
			<xsl:when test='$key = &quot;catalog.agportal.citation.publInfo.publish&quot; '>i18n.catalog.agportal.citation.publInfo.publish</xsl:when>
			<xsl:when test='$key = &quot;catalog.agportal.citation.resource&quot; '>i18n.catalog.agportal.citation.resource</xsl:when>
			<xsl:when test='$key = &quot;catalog.agportal.citation.website&quot; '>i18n.catalog.agportal.citation.website</xsl:when>
			<xsl:when test='$key = &quot;catalog.agportal.description.abstract&quot; '>i18n.catalog.agportal.description.abstract</xsl:when>
			<xsl:when test='$key = &quot;catalog.agportal.envelope.east&quot; '>i18n.catalog.agportal.envelope.east</xsl:when>
			<xsl:when test='$key = &quot;catalog.agportal.envelope.north&quot; '>i18n.catalog.agportal.envelope.north</xsl:when>
			<xsl:when test='$key = &quot;catalog.agportal.envelope.south&quot; '>i18n.catalog.agportal.envelope.south</xsl:when>
			<xsl:when test='$key = &quot;catalog.agportal.envelope.west&quot; '>i18n.catalog.agportal.envelope.west</xsl:when>
			<xsl:when test='$key = &quot;catalog.agportal.identification.caption&quot; '>i18n.catalog.agportal.identification.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.agportal.identification.title&quot; '>i18n.catalog.agportal.identification.title</xsl:when>
			<xsl:when test='$key = &quot;catalog.ags.namegeneration.wcs&quot; '>i18n.catalog.ags.namegeneration.wcs</xsl:when>
			<xsl:when test='$key = &quot;catalog.ags.namegeneration.wfs&quot; '>i18n.catalog.ags.namegeneration.wfs</xsl:when>
			<xsl:when test='$key = &quot;catalog.ags.namegeneration.wms&quot; '>i18n.catalog.ags.namegeneration.wms</xsl:when>
			<xsl:when test='$key = &quot;catalog.asn.comment.addComment&quot; '>i18n.catalog.asn.comment.addComment</xsl:when>
			<xsl:when test='$key = &quot;catalog.asn.comment.caption&quot; '>i18n.catalog.asn.comment.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.asn.comment.deletePrompt&quot; '>i18n.catalog.asn.comment.deletePrompt</xsl:when>
			<xsl:when test='$key = &quot;catalog.asn.comment.deleteTip&quot; '>i18n.catalog.asn.comment.deleteTip</xsl:when>
			<xsl:when test='$key = &quot;catalog.asn.comment.disabledComment&quot; '>i18n.catalog.asn.comment.disabledComment</xsl:when>
			<xsl:when test='$key = &quot;catalog.asn.comment.disableTip&quot; '>i18n.catalog.asn.comment.disableTip</xsl:when>
			<xsl:when test='$key = &quot;catalog.asn.comment.editedTip&quot; '>i18n.catalog.asn.comment.editedTip</xsl:when>
			<xsl:when test='$key = &quot;catalog.asn.comment.editTip&quot; '>i18n.catalog.asn.comment.editTip</xsl:when>
			<xsl:when test='$key = &quot;catalog.asn.comment.emptyComment&quot; '>i18n.catalog.asn.comment.emptyComment</xsl:when>
			<xsl:when test='$key = &quot;catalog.asn.comment.enableTip&quot; '>i18n.catalog.asn.comment.enableTip</xsl:when>
			<xsl:when test='$key = &quot;catalog.asn.comment.more&quot; '>i18n.catalog.asn.comment.more</xsl:when>
			<xsl:when test='$key = &quot;catalog.asn.comment.postComment&quot; '>i18n.catalog.asn.comment.postComment</xsl:when>
			<xsl:when test='$key = &quot;catalog.asn.rating.caption&quot; '>i18n.catalog.asn.rating.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.asn.rating.deleteTip&quot; '>i18n.catalog.asn.rating.deleteTip</xsl:when>
			<xsl:when test='$key = &quot;catalog.asn.rating.downTip&quot; '>i18n.catalog.asn.rating.downTip</xsl:when>
			<xsl:when test='$key = &quot;catalog.asn.rating.switchTip&quot; '>i18n.catalog.asn.rating.switchTip</xsl:when>
			<xsl:when test='$key = &quot;catalog.asn.rating.totalDownTip&quot; '>i18n.catalog.asn.rating.totalDownTip</xsl:when>
			<xsl:when test='$key = &quot;catalog.asn.rating.totalUpTip&quot; '>i18n.catalog.asn.rating.totalUpTip</xsl:when>
			<xsl:when test='$key = &quot;catalog.asn.rating.upTip&quot; '>i18n.catalog.asn.rating.upTip</xsl:when>
			<xsl:when test='$key = &quot;catalog.asn.rating.youCan&quot; '>i18n.catalog.asn.rating.youCan</xsl:when>
			<xsl:when test='$key = &quot;catalog.asn.rating.youVoted&quot; '>i18n.catalog.asn.rating.youVoted</xsl:when>
			<xsl:when test='$key = &quot;catalog.asn.rating.youVotedDownTip&quot; '>i18n.catalog.asn.rating.youVotedDownTip</xsl:when>
			<xsl:when test='$key = &quot;catalog.asn.rating.youVotedUpTip&quot; '>i18n.catalog.asn.rating.youVotedUpTip</xsl:when>
			<xsl:when test='$key = &quot;catalog.browse.caption&quot; '>i18n.catalog.browse.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.browse.filter&quot; '>i18n.catalog.browse.filter</xsl:when>
			<xsl:when test='$key = &quot;catalog.browse.filter.clear&quot; '>i18n.catalog.browse.filter.clear</xsl:when>
			<xsl:when test='$key = &quot;catalog.browse.menuCaption&quot; '>i18n.catalog.browse.menuCaption</xsl:when>
			<xsl:when test='$key = &quot;catalog.browse.noItemSelected&quot; '>i18n.catalog.browse.noItemSelected</xsl:when>
			<xsl:when test='$key = &quot;catalog.browse.noResults&quot; '>i18n.catalog.browse.noResults</xsl:when>
			<xsl:when test='$key = &quot;catalog.browse.page.first&quot; '>i18n.catalog.browse.page.first</xsl:when>
			<xsl:when test='$key = &quot;catalog.browse.page.last&quot; '>i18n.catalog.browse.page.last</xsl:when>
			<xsl:when test='$key = &quot;catalog.browse.pageSummaryPattern&quot; '>i18n.catalog.browse.pageSummaryPattern</xsl:when>
			<xsl:when test='$key = &quot;catalog.browse.prompt&quot; '>i18n.catalog.browse.prompt</xsl:when>
			<xsl:when test='$key = &quot;catalog.browse.summaryPattern&quot; '>i18n.catalog.browse.summaryPattern</xsl:when>
			<xsl:when test='$key = &quot;catalog.browse.summaryPattern.filtered&quot; '>i18n.catalog.browse.summaryPattern.filtered</xsl:when>
			<xsl:when test='$key = &quot;catalog.browse.toc.browseCatalog&quot; '>i18n.catalog.browse.toc.browseCatalog</xsl:when>
			<xsl:when test='$key = &quot;catalog.browse.toc.browseResource&quot; '>i18n.catalog.browse.toc.browseResource</xsl:when>
			<xsl:when test='$key = &quot;catalog.cart.caption&quot; '>i18n.catalog.cart.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.cart.check.tip&quot; '>i18n.catalog.cart.check.tip</xsl:when>
			<xsl:when test='$key = &quot;catalog.cart.clear&quot; '>i18n.catalog.cart.clear</xsl:when>
			<xsl:when test='$key = &quot;catalog.cart.close&quot; '>i18n.catalog.cart.close</xsl:when>
			<xsl:when test='$key = &quot;catalog.cart.isfull&quot; '>i18n.catalog.cart.isfull</xsl:when>
			<xsl:when test='$key = &quot;catalog.cart.item.count&quot; '>i18n.catalog.cart.item.count</xsl:when>
			<xsl:when test='$key = &quot;catalog.cart.item.count.one&quot; '>i18n.catalog.cart.item.count.one</xsl:when>
			<xsl:when test='$key = &quot;catalog.cart.max.tip&quot; '>i18n.catalog.cart.max.tip</xsl:when>
			<xsl:when test='$key = &quot;catalog.cart.menuCaption&quot; '>i18n.catalog.cart.menuCaption</xsl:when>
			<xsl:when test='$key = &quot;catalog.cart.menuCaption.count&quot; '>i18n.catalog.cart.menuCaption.count</xsl:when>
			<xsl:when test='$key = &quot;catalog.cart.process&quot; '>i18n.catalog.cart.process</xsl:when>
			<xsl:when test='$key = &quot;catalog.cart.prompt&quot; '>i18n.catalog.cart.prompt</xsl:when>
			<xsl:when test='$key = &quot;catalog.cart.remove.tip&quot; '>i18n.catalog.cart.remove.tip</xsl:when>
			<xsl:when test='$key = &quot;catalog.com.esri.gpt.framework.adhoc.events.DayOfTheMonthEvent&quot; '>i18n.catalog.com.esri.gpt.framework.adhoc.events.DayOfTheMonthEvent</xsl:when>
			<xsl:when test='$key = &quot;catalog.com.esri.gpt.framework.adhoc.events.DayOfTheWeekEvent&quot; '>i18n.catalog.com.esri.gpt.framework.adhoc.events.DayOfTheWeekEvent</xsl:when>
			<xsl:when test='$key = &quot;catalog.com.esri.gpt.framework.adhoc.events.DayOfTheWeekInTheMonthEvent&quot; '>i18n.catalog.com.esri.gpt.framework.adhoc.events.DayOfTheWeekInTheMonthEvent</xsl:when>
			<xsl:when test='$key = &quot;catalog.com.esri.gpt.framework.adhoc.events.FRIDAY&quot; '>i18n.catalog.com.esri.gpt.framework.adhoc.events.FRIDAY</xsl:when>
			<xsl:when test='$key = &quot;catalog.com.esri.gpt.framework.adhoc.events.MONDAY&quot; '>i18n.catalog.com.esri.gpt.framework.adhoc.events.MONDAY</xsl:when>
			<xsl:when test='$key = &quot;catalog.com.esri.gpt.framework.adhoc.events.SATURDAY&quot; '>i18n.catalog.com.esri.gpt.framework.adhoc.events.SATURDAY</xsl:when>
			<xsl:when test='$key = &quot;catalog.com.esri.gpt.framework.adhoc.events.SpecTimeEvent&quot; '>i18n.catalog.com.esri.gpt.framework.adhoc.events.SpecTimeEvent</xsl:when>
			<xsl:when test='$key = &quot;catalog.com.esri.gpt.framework.adhoc.events.SUNDAY&quot; '>i18n.catalog.com.esri.gpt.framework.adhoc.events.SUNDAY</xsl:when>
			<xsl:when test='$key = &quot;catalog.com.esri.gpt.framework.adhoc.events.THURSDAY&quot; '>i18n.catalog.com.esri.gpt.framework.adhoc.events.THURSDAY</xsl:when>
			<xsl:when test='$key = &quot;catalog.com.esri.gpt.framework.adhoc.events.TimeOfTheDayEvent&quot; '>i18n.catalog.com.esri.gpt.framework.adhoc.events.TimeOfTheDayEvent</xsl:when>
			<xsl:when test='$key = &quot;catalog.com.esri.gpt.framework.adhoc.events.TUEASDAY&quot; '>i18n.catalog.com.esri.gpt.framework.adhoc.events.TUEASDAY</xsl:when>
			<xsl:when test='$key = &quot;catalog.com.esri.gpt.framework.adhoc.events.WEDNESDAY&quot; '>i18n.catalog.com.esri.gpt.framework.adhoc.events.WEDNESDAY</xsl:when>
			<xsl:when test='$key = &quot;catalog.content.about.caption&quot; '>i18n.catalog.content.about.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.content.about.menuCaption&quot; '>i18n.catalog.content.about.menuCaption</xsl:when>
			<xsl:when test='$key = &quot;catalog.content.about.statement&quot; '>i18n.catalog.content.about.statement</xsl:when>
			<xsl:when test='$key = &quot;catalog.content.about.version&quot; '>i18n.catalog.content.about.version</xsl:when>
			<xsl:when test='$key = &quot;catalog.content.disclaimer.caption&quot; '>i18n.catalog.content.disclaimer.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.content.disclaimer.statement&quot; '>i18n.catalog.content.disclaimer.statement</xsl:when>
			<xsl:when test='$key = &quot;catalog.content.footer.statement&quot; '>i18n.catalog.content.footer.statement</xsl:when>
			<xsl:when test='$key = &quot;catalog.content.privacy.caption&quot; '>i18n.catalog.content.privacy.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.content.privacy.statement&quot; '>i18n.catalog.content.privacy.statement</xsl:when>
			<xsl:when test='$key = &quot;catalog.download.buton.action.caption&quot; '>i18n.catalog.download.buton.action.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.download.buton.clearSelection.caption&quot; '>i18n.catalog.download.buton.clearSelection.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.download.buton.deactivate.caption&quot; '>i18n.catalog.download.buton.deactivate.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.download.buton.drawPolygon.caption&quot; '>i18n.catalog.download.buton.drawPolygon.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.download.caption&quot; '>i18n.catalog.download.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.download.email&quot; '>i18n.catalog.download.email</xsl:when>
			<xsl:when test='$key = &quot;catalog.download.feature.dgn&quot; '>i18n.catalog.download.feature.dgn</xsl:when>
			<xsl:when test='$key = &quot;catalog.download.feature.dwg&quot; '>i18n.catalog.download.feature.dwg</xsl:when>
			<xsl:when test='$key = &quot;catalog.download.feature.dxf&quot; '>i18n.catalog.download.feature.dxf</xsl:when>
			<xsl:when test='$key = &quot;catalog.download.feature.gdb&quot; '>i18n.catalog.download.feature.gdb</xsl:when>
			<xsl:when test='$key = &quot;catalog.download.feature.shp&quot; '>i18n.catalog.download.feature.shp</xsl:when>
			<xsl:when test='$key = &quot;catalog.download.featureFormat&quot; '>i18n.catalog.download.featureFormat</xsl:when>
			<xsl:when test='$key = &quot;catalog.download.menuCaption&quot; '>i18n.catalog.download.menuCaption</xsl:when>
			<xsl:when test='$key = &quot;catalog.download.msg.confirmation&quot; '>i18n.catalog.download.msg.confirmation</xsl:when>
			<xsl:when test='$key = &quot;catalog.download.msg.downloadComplete&quot; '>i18n.catalog.download.msg.downloadComplete</xsl:when>
			<xsl:when test='$key = &quot;catalog.download.msg.enterEmail&quot; '>i18n.catalog.download.msg.enterEmail</xsl:when>
			<xsl:when test='$key = &quot;catalog.download.msg.selectRegion&quot; '>i18n.catalog.download.msg.selectRegion</xsl:when>
			<xsl:when test='$key = &quot;catalog.download.msg.stepOne&quot; '>i18n.catalog.download.msg.stepOne</xsl:when>
			<xsl:when test='$key = &quot;catalog.download.msg.stepOneMsg&quot; '>i18n.catalog.download.msg.stepOneMsg</xsl:when>
			<xsl:when test='$key = &quot;catalog.download.msg.stepThree&quot; '>i18n.catalog.download.msg.stepThree</xsl:when>
			<xsl:when test='$key = &quot;catalog.download.msg.stepTwo&quot; '>i18n.catalog.download.msg.stepTwo</xsl:when>
			<xsl:when test='$key = &quot;catalog.download.msg.stepTwoMsg&quot; '>i18n.catalog.download.msg.stepTwoMsg</xsl:when>
			<xsl:when test='$key = &quot;catalog.download.outputFileFormat&quot; '>i18n.catalog.download.outputFileFormat</xsl:when>
			<xsl:when test='$key = &quot;catalog.download.outputFormat.acad&quot; '>i18n.catalog.download.outputFormat.acad</xsl:when>
			<xsl:when test='$key = &quot;catalog.download.outputFormat.gml&quot; '>i18n.catalog.download.outputFormat.gml</xsl:when>
			<xsl:when test='$key = &quot;catalog.download.outputFormat.gmlsf&quot; '>i18n.catalog.download.outputFormat.gmlsf</xsl:when>
			<xsl:when test='$key = &quot;catalog.download.outputFormat.igds&quot; '>i18n.catalog.download.outputFormat.igds</xsl:when>
			<xsl:when test='$key = &quot;catalog.download.outputFormat.mif&quot; '>i18n.catalog.download.outputFormat.mif</xsl:when>
			<xsl:when test='$key = &quot;catalog.download.projection&quot; '>i18n.catalog.download.projection</xsl:when>
			<xsl:when test='$key = &quot;catalog.download.projection.102113&quot; '>i18n.catalog.download.projection.102113</xsl:when>
			<xsl:when test='$key = &quot;catalog.download.projection.32610&quot; '>i18n.catalog.download.projection.32610</xsl:when>
			<xsl:when test='$key = &quot;catalog.download.projection.4326&quot; '>i18n.catalog.download.projection.4326</xsl:when>
			<xsl:when test='$key = &quot;catalog.download.projection.54004&quot; '>i18n.catalog.download.projection.54004</xsl:when>
			<xsl:when test='$key = &quot;catalog.download.raster.bmp&quot; '>i18n.catalog.download.raster.bmp</xsl:when>
			<xsl:when test='$key = &quot;catalog.download.raster.gdb&quot; '>i18n.catalog.download.raster.gdb</xsl:when>
			<xsl:when test='$key = &quot;catalog.download.raster.gif&quot; '>i18n.catalog.download.raster.gif</xsl:when>
			<xsl:when test='$key = &quot;catalog.download.raster.grd&quot; '>i18n.catalog.download.raster.grd</xsl:when>
			<xsl:when test='$key = &quot;catalog.download.raster.img&quot; '>i18n.catalog.download.raster.img</xsl:when>
			<xsl:when test='$key = &quot;catalog.download.raster.jp2&quot; '>i18n.catalog.download.raster.jp2</xsl:when>
			<xsl:when test='$key = &quot;catalog.download.raster.jpg&quot; '>i18n.catalog.download.raster.jpg</xsl:when>
			<xsl:when test='$key = &quot;catalog.download.raster.png&quot; '>i18n.catalog.download.raster.png</xsl:when>
			<xsl:when test='$key = &quot;catalog.download.raster.tif&quot; '>i18n.catalog.download.raster.tif</xsl:when>
			<xsl:when test='$key = &quot;catalog.download.rasterFormat&quot; '>i18n.catalog.download.rasterFormat</xsl:when>
			<xsl:when test='$key = &quot;catalog.esriItaliaAdd.general.gescrisiPubblica&quot; '>i18n.catalog.esriItaliaAdd.general.gescrisiPubblica</xsl:when>
			<xsl:when test='$key = &quot;catalog.esriItaliaAdd.manageMetadataBody.dateE&quot; '>i18n.catalog.esriItaliaAdd.manageMetadataBody.dateE</xsl:when>
			<xsl:when test='$key = &quot;catalog.esriItaliaAdd.manageMetadataBody.dateTra&quot; '>i18n.catalog.esriItaliaAdd.manageMetadataBody.dateTra</xsl:when>
			<xsl:when test='$key = &quot;catalog.esriItaliaAdd.manageMetadataBody.textTitleDoc&quot; '>i18n.catalog.esriItaliaAdd.manageMetadataBody.textTitleDoc</xsl:when>
			<xsl:when test='$key = &quot;catalog.esriItaliaAdd.manageMetadataBody.textUUID&quot; '>i18n.catalog.esriItaliaAdd.manageMetadataBody.textUUID</xsl:when>
			<xsl:when test='$key = &quot;catalog.esriItaliaAdd.manageMetadataBody.title&quot; '>i18n.catalog.esriItaliaAdd.manageMetadataBody.title</xsl:when>
			<xsl:when test='$key = &quot;catalog.esriItaliaAdd.uploadMetadataBody.title&quot; '>i18n.catalog.esriItaliaAdd.uploadMetadataBody.title</xsl:when>
			<xsl:when test='$key = &quot;catalog.extent.limitamm&quot; '>i18n.catalog.extent.limitamm</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.citeinfo&quot; '>i18n.catalog.fgdc.citeinfo</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.citeinfo.edition&quot; '>i18n.catalog.fgdc.citeinfo.edition</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.citeinfo.geoform&quot; '>i18n.catalog.fgdc.citeinfo.geoform</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.citeinfo.geoform.option.atlas&quot; '>i18n.catalog.fgdc.citeinfo.geoform.option.atlas</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.citeinfo.geoform.option.audio&quot; '>i18n.catalog.fgdc.citeinfo.geoform.option.audio</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.citeinfo.geoform.option.diagram&quot; '>i18n.catalog.fgdc.citeinfo.geoform.option.diagram</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.citeinfo.geoform.option.document&quot; '>i18n.catalog.fgdc.citeinfo.geoform.option.document</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.citeinfo.geoform.option.globe&quot; '>i18n.catalog.fgdc.citeinfo.geoform.option.globe</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.citeinfo.geoform.option.map&quot; '>i18n.catalog.fgdc.citeinfo.geoform.option.map</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.citeinfo.geoform.option.model&quot; '>i18n.catalog.fgdc.citeinfo.geoform.option.model</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.citeinfo.geoform.option.multiMediaPresentation&quot; '>i18n.catalog.fgdc.citeinfo.geoform.option.multiMediaPresentation</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.citeinfo.geoform.option.profile&quot; '>i18n.catalog.fgdc.citeinfo.geoform.option.profile</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.citeinfo.geoform.option.rasterDigitalData&quot; '>i18n.catalog.fgdc.citeinfo.geoform.option.rasterDigitalData</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.citeinfo.geoform.option.remoteSensingImage&quot; '>i18n.catalog.fgdc.citeinfo.geoform.option.remoteSensingImage</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.citeinfo.geoform.option.section&quot; '>i18n.catalog.fgdc.citeinfo.geoform.option.section</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.citeinfo.geoform.option.spreadsheet&quot; '>i18n.catalog.fgdc.citeinfo.geoform.option.spreadsheet</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.citeinfo.geoform.option.tabularDigitalData&quot; '>i18n.catalog.fgdc.citeinfo.geoform.option.tabularDigitalData</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.citeinfo.geoform.option.vectorDigitalData&quot; '>i18n.catalog.fgdc.citeinfo.geoform.option.vectorDigitalData</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.citeinfo.geoform.option.video&quot; '>i18n.catalog.fgdc.citeinfo.geoform.option.video</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.citeinfo.geoform.option.view&quot; '>i18n.catalog.fgdc.citeinfo.geoform.option.view</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.citeinfo.lworkcit&quot; '>i18n.catalog.fgdc.citeinfo.lworkcit</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.citeinfo.onlink&quot; '>i18n.catalog.fgdc.citeinfo.onlink</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.citeinfo.origin&quot; '>i18n.catalog.fgdc.citeinfo.origin</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.citeinfo.othercit&quot; '>i18n.catalog.fgdc.citeinfo.othercit</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.citeinfo.pubdate&quot; '>i18n.catalog.fgdc.citeinfo.pubdate</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.citeinfo.pubinfo&quot; '>i18n.catalog.fgdc.citeinfo.pubinfo</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.citeinfo.pubinfo.publish&quot; '>i18n.catalog.fgdc.citeinfo.pubinfo.publish</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.citeinfo.pubinfo.pubplace&quot; '>i18n.catalog.fgdc.citeinfo.pubinfo.pubplace</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.citeinfo.pubtime&quot; '>i18n.catalog.fgdc.citeinfo.pubtime</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.citeinfo.serinfo&quot; '>i18n.catalog.fgdc.citeinfo.serinfo</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.citeinfo.serinfo.issue&quot; '>i18n.catalog.fgdc.citeinfo.serinfo.issue</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.citeinfo.serinfo.sername&quot; '>i18n.catalog.fgdc.citeinfo.serinfo.sername</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.citeinfo.title&quot; '>i18n.catalog.fgdc.citeinfo.title</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.cntaddr&quot; '>i18n.catalog.fgdc.cntaddr</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.cntaddr.address&quot; '>i18n.catalog.fgdc.cntaddr.address</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.cntaddr.addrtype&quot; '>i18n.catalog.fgdc.cntaddr.addrtype</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.cntaddr.addrtype.mailing&quot; '>i18n.catalog.fgdc.cntaddr.addrtype.mailing</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.cntaddr.addrtype.mailingAndPhysical&quot; '>i18n.catalog.fgdc.cntaddr.addrtype.mailingAndPhysical</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.cntaddr.addrtype.physical&quot; '>i18n.catalog.fgdc.cntaddr.addrtype.physical</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.cntaddr.city&quot; '>i18n.catalog.fgdc.cntaddr.city</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.cntaddr.country&quot; '>i18n.catalog.fgdc.cntaddr.country</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.cntaddr.postal&quot; '>i18n.catalog.fgdc.cntaddr.postal</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.cntaddr.state&quot; '>i18n.catalog.fgdc.cntaddr.state</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.cntinfo&quot; '>i18n.catalog.fgdc.cntinfo</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.cntinfo.cntemail&quot; '>i18n.catalog.fgdc.cntinfo.cntemail</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.cntinfo.cntfax&quot; '>i18n.catalog.fgdc.cntinfo.cntfax</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.cntinfo.cntinst&quot; '>i18n.catalog.fgdc.cntinfo.cntinst</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.cntinfo.cntpos&quot; '>i18n.catalog.fgdc.cntinfo.cntpos</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.cntinfo.cnttdd&quot; '>i18n.catalog.fgdc.cntinfo.cnttdd</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.cntinfo.cntvoice&quot; '>i18n.catalog.fgdc.cntinfo.cntvoice</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.cntinfo.hours&quot; '>i18n.catalog.fgdc.cntinfo.hours</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.cntinfo.section.address&quot; '>i18n.catalog.fgdc.cntinfo.section.address</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.cntinfo.section.hoursAndInstructions&quot; '>i18n.catalog.fgdc.cntinfo.section.hoursAndInstructions</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.cntinfo.section.phoneAndEmail&quot; '>i18n.catalog.fgdc.cntinfo.section.phoneAndEmail</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.cntinfo.section.position&quot; '>i18n.catalog.fgdc.cntinfo.section.position</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.cntinfo.section.primary&quot; '>i18n.catalog.fgdc.cntinfo.section.primary</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.cntorgp&quot; '>i18n.catalog.fgdc.cntorgp</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.cntorgp.cntorg&quot; '>i18n.catalog.fgdc.cntorgp.cntorg</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.cntorgp.cntper&quot; '>i18n.catalog.fgdc.cntorgp.cntper</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.cntperp&quot; '>i18n.catalog.fgdc.cntperp</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.cntperp.cntorg&quot; '>i18n.catalog.fgdc.cntperp.cntorg</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.cntperp.cntper&quot; '>i18n.catalog.fgdc.cntperp.cntper</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual&quot; '>i18n.catalog.fgdc.dataqual</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.attracc&quot; '>i18n.catalog.fgdc.dataqual.attracc</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.attracc.attraccr&quot; '>i18n.catalog.fgdc.dataqual.attracc.attraccr</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.attracc.qattracc&quot; '>i18n.catalog.fgdc.dataqual.attracc.qattracc</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.attracc.qattracc.attracce&quot; '>i18n.catalog.fgdc.dataqual.attracc.qattracc.attracce</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.attracc.qattracc.attraccv&quot; '>i18n.catalog.fgdc.dataqual.attracc.qattracc.attraccv</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.cloud&quot; '>i18n.catalog.fgdc.dataqual.cloud</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.cloud.tip&quot; '>i18n.catalog.fgdc.dataqual.cloud.tip</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.complete&quot; '>i18n.catalog.fgdc.dataqual.complete</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.lineage&quot; '>i18n.catalog.fgdc.dataqual.lineage</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.lineage.procstep&quot; '>i18n.catalog.fgdc.dataqual.lineage.procstep</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.lineage.procstep.proccont&quot; '>i18n.catalog.fgdc.dataqual.lineage.procstep.proccont</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.lineage.procstep.procdate&quot; '>i18n.catalog.fgdc.dataqual.lineage.procstep.procdate</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.lineage.procstep.procdesc&quot; '>i18n.catalog.fgdc.dataqual.lineage.procstep.procdesc</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.lineage.procstep.proctime&quot; '>i18n.catalog.fgdc.dataqual.lineage.procstep.proctime</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.lineage.procstep.srcprod&quot; '>i18n.catalog.fgdc.dataqual.lineage.procstep.srcprod</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.lineage.procstep.srcused&quot; '>i18n.catalog.fgdc.dataqual.lineage.procstep.srcused</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.lineage.srcinfo&quot; '>i18n.catalog.fgdc.dataqual.lineage.srcinfo</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.lineage.srcinfo.srccite&quot; '>i18n.catalog.fgdc.dataqual.lineage.srcinfo.srccite</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.lineage.srcinfo.srccitea&quot; '>i18n.catalog.fgdc.dataqual.lineage.srcinfo.srccitea</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.lineage.srcinfo.srccontr&quot; '>i18n.catalog.fgdc.dataqual.lineage.srcinfo.srccontr</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.lineage.srcinfo.srcscale&quot; '>i18n.catalog.fgdc.dataqual.lineage.srcinfo.srcscale</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.lineage.srcinfo.srcscale.tip&quot; '>i18n.catalog.fgdc.dataqual.lineage.srcinfo.srcscale.tip</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.lineage.srcinfo.srctime&quot; '>i18n.catalog.fgdc.dataqual.lineage.srcinfo.srctime</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.lineage.srcinfo.srctime.srccurr&quot; '>i18n.catalog.fgdc.dataqual.lineage.srcinfo.srctime.srccurr</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.lineage.srcinfo.typesrc&quot; '>i18n.catalog.fgdc.dataqual.lineage.srcinfo.typesrc</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.logic&quot; '>i18n.catalog.fgdc.dataqual.logic</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.posacc&quot; '>i18n.catalog.fgdc.dataqual.posacc</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.posacc.horizpa&quot; '>i18n.catalog.fgdc.dataqual.posacc.horizpa</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.posacc.horizpa.horizpar&quot; '>i18n.catalog.fgdc.dataqual.posacc.horizpa.horizpar</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.posacc.horizpa.qhorizpa&quot; '>i18n.catalog.fgdc.dataqual.posacc.horizpa.qhorizpa</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.posacc.horizpa.qhorizpa.horizpae&quot; '>i18n.catalog.fgdc.dataqual.posacc.horizpa.qhorizpa.horizpae</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.posacc.horizpa.qhorizpa.horizpav&quot; '>i18n.catalog.fgdc.dataqual.posacc.horizpa.qhorizpa.horizpav</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.posacc.vertacc&quot; '>i18n.catalog.fgdc.dataqual.posacc.vertacc</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.posacc.vertacc.qvertpa&quot; '>i18n.catalog.fgdc.dataqual.posacc.vertacc.qvertpa</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.posacc.vertacc.qvertpa.vertacce&quot; '>i18n.catalog.fgdc.dataqual.posacc.vertacc.qvertpa.vertacce</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.posacc.vertacc.qvertpa.vertaccv&quot; '>i18n.catalog.fgdc.dataqual.posacc.vertacc.qvertpa.vertaccv</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.posacc.vertacc.vertaccr&quot; '>i18n.catalog.fgdc.dataqual.posacc.vertacc.vertaccr</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.section.attracc&quot; '>i18n.catalog.fgdc.dataqual.section.attracc</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.section.cloud&quot; '>i18n.catalog.fgdc.dataqual.section.cloud</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.section.complete&quot; '>i18n.catalog.fgdc.dataqual.section.complete</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.section.lineage&quot; '>i18n.catalog.fgdc.dataqual.section.lineage</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.section.lineage.procstep&quot; '>i18n.catalog.fgdc.dataqual.section.lineage.procstep</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.section.lineage.srcinfo&quot; '>i18n.catalog.fgdc.dataqual.section.lineage.srcinfo</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.section.logic&quot; '>i18n.catalog.fgdc.dataqual.section.logic</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.section.posacc&quot; '>i18n.catalog.fgdc.dataqual.section.posacc</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.srccurr.option.groundCondition&quot; '>i18n.catalog.fgdc.dataqual.srccurr.option.groundCondition</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.srccurr.option.publicationDate&quot; '>i18n.catalog.fgdc.dataqual.srccurr.option.publicationDate</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.typesrc.option.audiocassette&quot; '>i18n.catalog.fgdc.dataqual.typesrc.option.audiocassette</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.typesrc.option.cartridgeTape&quot; '>i18n.catalog.fgdc.dataqual.typesrc.option.cartridgeTape</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.typesrc.option.cdrom&quot; '>i18n.catalog.fgdc.dataqual.typesrc.option.cdrom</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.typesrc.option.chart&quot; '>i18n.catalog.fgdc.dataqual.typesrc.option.chart</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.typesrc.option.computerProgram&quot; '>i18n.catalog.fgdc.dataqual.typesrc.option.computerProgram</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.typesrc.option.disc&quot; '>i18n.catalog.fgdc.dataqual.typesrc.option.disc</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.typesrc.option.electronicBulletinBoard&quot; '>i18n.catalog.fgdc.dataqual.typesrc.option.electronicBulletinBoard</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.typesrc.option.electronicMailSystem&quot; '>i18n.catalog.fgdc.dataqual.typesrc.option.electronicMailSystem</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.typesrc.option.filmstrip&quot; '>i18n.catalog.fgdc.dataqual.typesrc.option.filmstrip</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.typesrc.option.magneticTape&quot; '>i18n.catalog.fgdc.dataqual.typesrc.option.magneticTape</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.typesrc.option.microfiche&quot; '>i18n.catalog.fgdc.dataqual.typesrc.option.microfiche</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.typesrc.option.microfilm&quot; '>i18n.catalog.fgdc.dataqual.typesrc.option.microfilm</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.typesrc.option.online&quot; '>i18n.catalog.fgdc.dataqual.typesrc.option.online</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.typesrc.option.paper&quot; '>i18n.catalog.fgdc.dataqual.typesrc.option.paper</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.typesrc.option.physicalModel&quot; '>i18n.catalog.fgdc.dataqual.typesrc.option.physicalModel</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.typesrc.option.stableBaseMaterial&quot; '>i18n.catalog.fgdc.dataqual.typesrc.option.stableBaseMaterial</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.typesrc.option.transparency&quot; '>i18n.catalog.fgdc.dataqual.typesrc.option.transparency</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.typesrc.option.videocassette&quot; '>i18n.catalog.fgdc.dataqual.typesrc.option.videocassette</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.typesrc.option.videodisc&quot; '>i18n.catalog.fgdc.dataqual.typesrc.option.videodisc</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.dataqual.typesrc.option.videotape&quot; '>i18n.catalog.fgdc.dataqual.typesrc.option.videotape</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.distinfo&quot; '>i18n.catalog.fgdc.distinfo</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.distinfo.availabl&quot; '>i18n.catalog.fgdc.distinfo.availabl</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.distinfo.custom&quot; '>i18n.catalog.fgdc.distinfo.custom</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.distinfo.distliab&quot; '>i18n.catalog.fgdc.distinfo.distliab</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.distinfo.resdesc&quot; '>i18n.catalog.fgdc.distinfo.resdesc</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.distinfo.section.availability&quot; '>i18n.catalog.fgdc.distinfo.section.availability</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.distinfo.section.description&quot; '>i18n.catalog.fgdc.distinfo.section.description</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.distinfo.section.distributor&quot; '>i18n.catalog.fgdc.distinfo.section.distributor</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.distinfo.section.orderProcess&quot; '>i18n.catalog.fgdc.distinfo.section.orderProcess</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.distinfo.section.prerequisites&quot; '>i18n.catalog.fgdc.distinfo.section.prerequisites</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.distinfo.stdorder&quot; '>i18n.catalog.fgdc.distinfo.stdorder</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.distinfo.techpreq&quot; '>i18n.catalog.fgdc.distinfo.techpreq</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.eainfo&quot; '>i18n.catalog.fgdc.eainfo</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.eainfo.overview&quot; '>i18n.catalog.fgdc.eainfo.overview</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.eainfo.overview.eadetcit&quot; '>i18n.catalog.fgdc.eainfo.overview.eadetcit</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.eainfo.overview.eaover&quot; '>i18n.catalog.fgdc.eainfo.overview.eaover</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.general.date.notComplete&quot; '>i18n.catalog.fgdc.general.date.notComplete</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.general.date.present&quot; '>i18n.catalog.fgdc.general.date.present</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.general.date.unpublishedMaterial&quot; '>i18n.catalog.fgdc.general.date.unpublishedMaterial</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.general.format.date.tip&quot; '>i18n.catalog.fgdc.general.format.date.tip</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.general.format.time.tip&quot; '>i18n.catalog.fgdc.general.format.time.tip</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.general.freeText&quot; '>i18n.catalog.fgdc.general.freeText</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.general.none&quot; '>i18n.catalog.fgdc.general.none</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.general.number.greaterThanZero.tip&quot; '>i18n.catalog.fgdc.general.number.greaterThanZero.tip</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.general.other&quot; '>i18n.catalog.fgdc.general.other</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.general.unknown&quot; '>i18n.catalog.fgdc.general.unknown</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.general.validate.date&quot; '>i18n.catalog.fgdc.general.validate.date</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo&quot; '>i18n.catalog.fgdc.idinfo</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.accconst&quot; '>i18n.catalog.fgdc.idinfo.accconst</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.browse&quot; '>i18n.catalog.fgdc.idinfo.browse</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.browse.browsed&quot; '>i18n.catalog.fgdc.idinfo.browse.browsed</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.browse.browsen&quot; '>i18n.catalog.fgdc.idinfo.browse.browsen</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.browse.browset&quot; '>i18n.catalog.fgdc.idinfo.browse.browset</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.citation&quot; '>i18n.catalog.fgdc.idinfo.citation</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.crossref&quot; '>i18n.catalog.fgdc.idinfo.crossref</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.datacred&quot; '>i18n.catalog.fgdc.idinfo.datacred</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.descript&quot; '>i18n.catalog.fgdc.idinfo.descript</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.descript.abstract&quot; '>i18n.catalog.fgdc.idinfo.descript.abstract</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.descript.purpose&quot; '>i18n.catalog.fgdc.idinfo.descript.purpose</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.descript.supplinf&quot; '>i18n.catalog.fgdc.idinfo.descript.supplinf</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.keywords&quot; '>i18n.catalog.fgdc.idinfo.keywords</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.keywords.label.delimited&quot; '>i18n.catalog.fgdc.idinfo.keywords.label.delimited</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.keywords.label.isoTopic&quot; '>i18n.catalog.fgdc.idinfo.keywords.label.isoTopic</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.keywords.label.isoTopic.thesaursus&quot; '>i18n.catalog.fgdc.idinfo.keywords.label.isoTopic.thesaursus</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.keywords.label.isoTopics&quot; '>i18n.catalog.fgdc.idinfo.keywords.label.isoTopics</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.keywords.label.thesaursus&quot; '>i18n.catalog.fgdc.idinfo.keywords.label.thesaursus</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.keywords.place&quot; '>i18n.catalog.fgdc.idinfo.keywords.place</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.keywords.placekt.gnis&quot; '>i18n.catalog.fgdc.idinfo.keywords.placekt.gnis</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.keywords.stratum&quot; '>i18n.catalog.fgdc.idinfo.keywords.stratum</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.keywords.temporal&quot; '>i18n.catalog.fgdc.idinfo.keywords.temporal</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.keywords.theme&quot; '>i18n.catalog.fgdc.idinfo.keywords.theme</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.keywords.themekt.isoTopicCategory&quot; '>i18n.catalog.fgdc.idinfo.keywords.themekt.isoTopicCategory</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.native&quot; '>i18n.catalog.fgdc.idinfo.native</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.ptcontac&quot; '>i18n.catalog.fgdc.idinfo.ptcontac</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.secinfo&quot; '>i18n.catalog.fgdc.idinfo.secinfo</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.secinfo.secclass&quot; '>i18n.catalog.fgdc.idinfo.secinfo.secclass</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.secinfo.secclass.option.confidential&quot; '>i18n.catalog.fgdc.idinfo.secinfo.secclass.option.confidential</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.secinfo.secclass.option.restricted&quot; '>i18n.catalog.fgdc.idinfo.secinfo.secclass.option.restricted</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.secinfo.secclass.option.secret&quot; '>i18n.catalog.fgdc.idinfo.secinfo.secclass.option.secret</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.secinfo.secclass.option.sensitive&quot; '>i18n.catalog.fgdc.idinfo.secinfo.secclass.option.sensitive</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.secinfo.secclass.option.topSecret&quot; '>i18n.catalog.fgdc.idinfo.secinfo.secclass.option.topSecret</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.secinfo.secclass.option.unclassified&quot; '>i18n.catalog.fgdc.idinfo.secinfo.secclass.option.unclassified</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.secinfo.sechandl&quot; '>i18n.catalog.fgdc.idinfo.secinfo.sechandl</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.secinfo.secsys&quot; '>i18n.catalog.fgdc.idinfo.secinfo.secsys</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.section.additional&quot; '>i18n.catalog.fgdc.idinfo.section.additional</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.section.citation&quot; '>i18n.catalog.fgdc.idinfo.section.citation</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.section.constraints&quot; '>i18n.catalog.fgdc.idinfo.section.constraints</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.section.descript&quot; '>i18n.catalog.fgdc.idinfo.section.descript</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.section.keywords&quot; '>i18n.catalog.fgdc.idinfo.section.keywords</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.section.ptcontac&quot; '>i18n.catalog.fgdc.idinfo.section.ptcontac</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.section.spdom&quot; '>i18n.catalog.fgdc.idinfo.section.spdom</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.section.timeAndStatus&quot; '>i18n.catalog.fgdc.idinfo.section.timeAndStatus</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.spdom&quot; '>i18n.catalog.fgdc.idinfo.spdom</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.spdom.bounding&quot; '>i18n.catalog.fgdc.idinfo.spdom.bounding</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.spdom.bounding.eastbc&quot; '>i18n.catalog.fgdc.idinfo.spdom.bounding.eastbc</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.spdom.bounding.northbc&quot; '>i18n.catalog.fgdc.idinfo.spdom.bounding.northbc</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.spdom.bounding.southbc&quot; '>i18n.catalog.fgdc.idinfo.spdom.bounding.southbc</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.spdom.bounding.westbc&quot; '>i18n.catalog.fgdc.idinfo.spdom.bounding.westbc</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.status&quot; '>i18n.catalog.fgdc.idinfo.status</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.status.progress&quot; '>i18n.catalog.fgdc.idinfo.status.progress</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.status.progress.option.complete&quot; '>i18n.catalog.fgdc.idinfo.status.progress.option.complete</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.status.progress.option.inWork&quot; '>i18n.catalog.fgdc.idinfo.status.progress.option.inWork</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.status.progress.option.planned&quot; '>i18n.catalog.fgdc.idinfo.status.progress.option.planned</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.status.update&quot; '>i18n.catalog.fgdc.idinfo.status.update</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.status.update.option.annually&quot; '>i18n.catalog.fgdc.idinfo.status.update.option.annually</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.status.update.option.asNeeded&quot; '>i18n.catalog.fgdc.idinfo.status.update.option.asNeeded</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.status.update.option.continual&quot; '>i18n.catalog.fgdc.idinfo.status.update.option.continual</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.status.update.option.daily&quot; '>i18n.catalog.fgdc.idinfo.status.update.option.daily</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.status.update.option.irregular&quot; '>i18n.catalog.fgdc.idinfo.status.update.option.irregular</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.status.update.option.monthly&quot; '>i18n.catalog.fgdc.idinfo.status.update.option.monthly</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.status.update.option.nonePlanned&quot; '>i18n.catalog.fgdc.idinfo.status.update.option.nonePlanned</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.status.update.option.unknown&quot; '>i18n.catalog.fgdc.idinfo.status.update.option.unknown</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.status.update.option.weekly&quot; '>i18n.catalog.fgdc.idinfo.status.update.option.weekly</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.timeperd&quot; '>i18n.catalog.fgdc.idinfo.timeperd</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.timeperd.current&quot; '>i18n.catalog.fgdc.idinfo.timeperd.current</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.timeperd.current.option.groundCondition&quot; '>i18n.catalog.fgdc.idinfo.timeperd.current.option.groundCondition</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.timeperd.current.option.publicationDate&quot; '>i18n.catalog.fgdc.idinfo.timeperd.current.option.publicationDate</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.idinfo.useconst&quot; '>i18n.catalog.fgdc.idinfo.useconst</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.metadata.section.dataqual&quot; '>i18n.catalog.fgdc.metadata.section.dataqual</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.metadata.section.distinfo&quot; '>i18n.catalog.fgdc.metadata.section.distinfo</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.metadata.section.eainfo&quot; '>i18n.catalog.fgdc.metadata.section.eainfo</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.metadata.section.idinfo&quot; '>i18n.catalog.fgdc.metadata.section.idinfo</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.metadata.section.metainfo&quot; '>i18n.catalog.fgdc.metadata.section.metainfo</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.metadata.section.spdoinfo&quot; '>i18n.catalog.fgdc.metadata.section.spdoinfo</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.metadata.section.spref&quot; '>i18n.catalog.fgdc.metadata.section.spref</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.metainfo&quot; '>i18n.catalog.fgdc.metainfo</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.metainfo.metac&quot; '>i18n.catalog.fgdc.metainfo.metac</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.metainfo.metd&quot; '>i18n.catalog.fgdc.metainfo.metd</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.metainfo.metextns&quot; '>i18n.catalog.fgdc.metainfo.metextns</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.metainfo.metextns.metprof&quot; '>i18n.catalog.fgdc.metainfo.metextns.metprof</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.metainfo.metextns.onlink&quot; '>i18n.catalog.fgdc.metainfo.metextns.onlink</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.metainfo.metfrd&quot; '>i18n.catalog.fgdc.metainfo.metfrd</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.metainfo.metrd&quot; '>i18n.catalog.fgdc.metainfo.metrd</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.metainfo.metsi&quot; '>i18n.catalog.fgdc.metainfo.metsi</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.metainfo.metsi.metsc&quot; '>i18n.catalog.fgdc.metainfo.metsi.metsc</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.metainfo.metsi.metscs&quot; '>i18n.catalog.fgdc.metainfo.metsi.metscs</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.metainfo.metsi.metshd&quot; '>i18n.catalog.fgdc.metainfo.metsi.metshd</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.metainfo.metstdn&quot; '>i18n.catalog.fgdc.metainfo.metstdn</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.metainfo.metstdv&quot; '>i18n.catalog.fgdc.metainfo.metstdv</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.metainfo.mettc&quot; '>i18n.catalog.fgdc.metainfo.mettc</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.metainfo.mettc.option.localTime&quot; '>i18n.catalog.fgdc.metainfo.mettc.option.localTime</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.metainfo.mettc.option.localTimeFactor&quot; '>i18n.catalog.fgdc.metainfo.mettc.option.localTimeFactor</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.metainfo.mettc.option.universalTime&quot; '>i18n.catalog.fgdc.metainfo.mettc.option.universalTime</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.metainfo.metuc&quot; '>i18n.catalog.fgdc.metainfo.metuc</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.metainfo.section.additional&quot; '>i18n.catalog.fgdc.metainfo.section.additional</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.metainfo.section.contact&quot; '>i18n.catalog.fgdc.metainfo.section.contact</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.metainfo.section.dates&quot; '>i18n.catalog.fgdc.metainfo.section.dates</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.metainfo.section.standard&quot; '>i18n.catalog.fgdc.metainfo.section.standard</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref&quot; '>i18n.catalog.fgdc.spref</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.altdatum.option.navd88&quot; '>i18n.catalog.fgdc.spref.altdatum.option.navd88</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.altdatum.option.ngvd29&quot; '>i18n.catalog.fgdc.spref.altdatum.option.ngvd29</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.depthdn.option.1&quot; '>i18n.catalog.fgdc.spref.depthdn.option.1</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.depthdn.option.10&quot; '>i18n.catalog.fgdc.spref.depthdn.option.10</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.depthdn.option.11&quot; '>i18n.catalog.fgdc.spref.depthdn.option.11</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.depthdn.option.12&quot; '>i18n.catalog.fgdc.spref.depthdn.option.12</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.depthdn.option.13&quot; '>i18n.catalog.fgdc.spref.depthdn.option.13</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.depthdn.option.14&quot; '>i18n.catalog.fgdc.spref.depthdn.option.14</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.depthdn.option.15&quot; '>i18n.catalog.fgdc.spref.depthdn.option.15</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.depthdn.option.16&quot; '>i18n.catalog.fgdc.spref.depthdn.option.16</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.depthdn.option.17&quot; '>i18n.catalog.fgdc.spref.depthdn.option.17</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.depthdn.option.18&quot; '>i18n.catalog.fgdc.spref.depthdn.option.18</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.depthdn.option.19&quot; '>i18n.catalog.fgdc.spref.depthdn.option.19</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.depthdn.option.2&quot; '>i18n.catalog.fgdc.spref.depthdn.option.2</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.depthdn.option.20&quot; '>i18n.catalog.fgdc.spref.depthdn.option.20</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.depthdn.option.21&quot; '>i18n.catalog.fgdc.spref.depthdn.option.21</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.depthdn.option.22&quot; '>i18n.catalog.fgdc.spref.depthdn.option.22</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.depthdn.option.23&quot; '>i18n.catalog.fgdc.spref.depthdn.option.23</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.depthdn.option.24&quot; '>i18n.catalog.fgdc.spref.depthdn.option.24</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.depthdn.option.25&quot; '>i18n.catalog.fgdc.spref.depthdn.option.25</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.depthdn.option.26&quot; '>i18n.catalog.fgdc.spref.depthdn.option.26</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.depthdn.option.27&quot; '>i18n.catalog.fgdc.spref.depthdn.option.27</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.depthdn.option.28&quot; '>i18n.catalog.fgdc.spref.depthdn.option.28</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.depthdn.option.29&quot; '>i18n.catalog.fgdc.spref.depthdn.option.29</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.depthdn.option.3&quot; '>i18n.catalog.fgdc.spref.depthdn.option.3</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.depthdn.option.30&quot; '>i18n.catalog.fgdc.spref.depthdn.option.30</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.depthdn.option.31&quot; '>i18n.catalog.fgdc.spref.depthdn.option.31</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.depthdn.option.32&quot; '>i18n.catalog.fgdc.spref.depthdn.option.32</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.depthdn.option.33&quot; '>i18n.catalog.fgdc.spref.depthdn.option.33</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.depthdn.option.34&quot; '>i18n.catalog.fgdc.spref.depthdn.option.34</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.depthdn.option.35&quot; '>i18n.catalog.fgdc.spref.depthdn.option.35</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.depthdn.option.36&quot; '>i18n.catalog.fgdc.spref.depthdn.option.36</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.depthdn.option.4&quot; '>i18n.catalog.fgdc.spref.depthdn.option.4</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.depthdn.option.5&quot; '>i18n.catalog.fgdc.spref.depthdn.option.5</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.depthdn.option.6&quot; '>i18n.catalog.fgdc.spref.depthdn.option.6</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.depthdn.option.7&quot; '>i18n.catalog.fgdc.spref.depthdn.option.7</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.depthdn.option.8&quot; '>i18n.catalog.fgdc.spref.depthdn.option.8</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.depthdn.option.9&quot; '>i18n.catalog.fgdc.spref.depthdn.option.9</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.ellips.option.clarke1866&quot; '>i18n.catalog.fgdc.spref.ellips.option.clarke1866</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.ellips.option.grs80&quot; '>i18n.catalog.fgdc.spref.ellips.option.grs80</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.geogunit.option.decimalDegrees&quot; '>i18n.catalog.fgdc.spref.geogunit.option.decimalDegrees</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.geogunit.option.decimalMinutes&quot; '>i18n.catalog.fgdc.spref.geogunit.option.decimalMinutes</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.geogunit.option.decimalSeconds&quot; '>i18n.catalog.fgdc.spref.geogunit.option.decimalSeconds</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.geogunit.option.degreesAndDecimalMinutes&quot; '>i18n.catalog.fgdc.spref.geogunit.option.degreesAndDecimalMinutes</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.geogunit.option.degreesMinutesAndDecimalSeconds&quot; '>i18n.catalog.fgdc.spref.geogunit.option.degreesMinutesAndDecimalSeconds</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.geogunit.option.grads&quot; '>i18n.catalog.fgdc.spref.geogunit.option.grads</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.geogunit.option.radians&quot; '>i18n.catalog.fgdc.spref.geogunit.option.radians</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.horizdn.option.nad27&quot; '>i18n.catalog.fgdc.spref.horizdn.option.nad27</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.horizdn.option.nad83&quot; '>i18n.catalog.fgdc.spref.horizdn.option.nad83</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.horizsys&quot; '>i18n.catalog.fgdc.spref.horizsys</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.horizsys.geodetic&quot; '>i18n.catalog.fgdc.spref.horizsys.geodetic</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.horizsys.geodetic.denflat&quot; '>i18n.catalog.fgdc.spref.horizsys.geodetic.denflat</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.horizsys.geodetic.ellips&quot; '>i18n.catalog.fgdc.spref.horizsys.geodetic.ellips</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.horizsys.geodetic.horizdn&quot; '>i18n.catalog.fgdc.spref.horizsys.geodetic.horizdn</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.horizsys.geodetic.semiaxis&quot; '>i18n.catalog.fgdc.spref.horizsys.geodetic.semiaxis</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.horizsys.geograph&quot; '>i18n.catalog.fgdc.spref.horizsys.geograph</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.horizsys.geograph.geogunit&quot; '>i18n.catalog.fgdc.spref.horizsys.geograph.geogunit</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.horizsys.geograph.latres&quot; '>i18n.catalog.fgdc.spref.horizsys.geograph.latres</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.horizsys.geograph.longres&quot; '>i18n.catalog.fgdc.spref.horizsys.geograph.longres</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.horizsys.local&quot; '>i18n.catalog.fgdc.spref.horizsys.local</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.horizsys.local.localdes&quot; '>i18n.catalog.fgdc.spref.horizsys.local.localdes</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.horizsys.local.localgeo&quot; '>i18n.catalog.fgdc.spref.horizsys.local.localgeo</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.units.option.feet&quot; '>i18n.catalog.fgdc.spref.units.option.feet</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.units.option.meters&quot; '>i18n.catalog.fgdc.spref.units.option.meters</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.vertdef&quot; '>i18n.catalog.fgdc.spref.vertdef</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.vertdef.altsys&quot; '>i18n.catalog.fgdc.spref.vertdef.altsys</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.vertdef.altsys.altdatum&quot; '>i18n.catalog.fgdc.spref.vertdef.altsys.altdatum</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.vertdef.altsys.altenc&quot; '>i18n.catalog.fgdc.spref.vertdef.altsys.altenc</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.vertdef.altsys.altenc.option.attribute&quot; '>i18n.catalog.fgdc.spref.vertdef.altsys.altenc.option.attribute</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.vertdef.altsys.altenc.option.explicit&quot; '>i18n.catalog.fgdc.spref.vertdef.altsys.altenc.option.explicit</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.vertdef.altsys.altenc.option.implicit&quot; '>i18n.catalog.fgdc.spref.vertdef.altsys.altenc.option.implicit</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.vertdef.altsys.altres&quot; '>i18n.catalog.fgdc.spref.vertdef.altsys.altres</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.vertdef.altsys.altunits&quot; '>i18n.catalog.fgdc.spref.vertdef.altsys.altunits</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.vertdef.depthsys&quot; '>i18n.catalog.fgdc.spref.vertdef.depthsys</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.vertdef.depthsys.depthdn&quot; '>i18n.catalog.fgdc.spref.vertdef.depthsys.depthdn</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.vertdef.depthsys.depthdu&quot; '>i18n.catalog.fgdc.spref.vertdef.depthsys.depthdu</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.vertdef.depthsys.depthem&quot; '>i18n.catalog.fgdc.spref.vertdef.depthsys.depthem</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.vertdef.depthsys.depthem.option.attribute&quot; '>i18n.catalog.fgdc.spref.vertdef.depthsys.depthem.option.attribute</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.vertdef.depthsys.depthem.option.explicit&quot; '>i18n.catalog.fgdc.spref.vertdef.depthsys.depthem.option.explicit</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.vertdef.depthsys.depthem.option.implicit&quot; '>i18n.catalog.fgdc.spref.vertdef.depthsys.depthem.option.implicit</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.spref.vertdef.depthsys.depthres&quot; '>i18n.catalog.fgdc.spref.vertdef.depthsys.depthres</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.timeinfo&quot; '>i18n.catalog.fgdc.timeinfo</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.timeinfo.begdate&quot; '>i18n.catalog.fgdc.timeinfo.begdate</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.timeinfo.begtime&quot; '>i18n.catalog.fgdc.timeinfo.begtime</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.timeinfo.caldate&quot; '>i18n.catalog.fgdc.timeinfo.caldate</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.timeinfo.enddate&quot; '>i18n.catalog.fgdc.timeinfo.enddate</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.timeinfo.endtime&quot; '>i18n.catalog.fgdc.timeinfo.endtime</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.timeinfo.mdattim&quot; '>i18n.catalog.fgdc.timeinfo.mdattim</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.timeinfo.option.present&quot; '>i18n.catalog.fgdc.timeinfo.option.present</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.timeinfo.option.unknown&quot; '>i18n.catalog.fgdc.timeinfo.option.unknown</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.timeinfo.rngdates&quot; '>i18n.catalog.fgdc.timeinfo.rngdates</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.timeinfo.sngdate&quot; '>i18n.catalog.fgdc.timeinfo.sngdate</xsl:when>
			<xsl:when test='$key = &quot;catalog.fgdc.timeinfo.time&quot; '>i18n.catalog.fgdc.timeinfo.time</xsl:when>
			<xsl:when test='$key = &quot;catalog.gemet.cancel&quot; '>i18n.catalog.gemet.cancel</xsl:when>
			<xsl:when test='$key = &quot;catalog.gemet.connectingMessage&quot; '>i18n.catalog.gemet.connectingMessage</xsl:when>
			<xsl:when test='$key = &quot;catalog.gemet.dialogHelp&quot; '>i18n.catalog.gemet.dialogHelp</xsl:when>
			<xsl:when test='$key = &quot;catalog.gemet.dialogTitle&quot; '>i18n.catalog.gemet.dialogTitle</xsl:when>
			<xsl:when test='$key = &quot;catalog.gemet.find&quot; '>i18n.catalog.gemet.find</xsl:when>
			<xsl:when test='$key = &quot;catalog.gemet.lblErrorKeywordEmpty&quot; '>i18n.catalog.gemet.lblErrorKeywordEmpty</xsl:when>
			<xsl:when test='$key = &quot;catalog.gemet.ok&quot; '>i18n.catalog.gemet.ok</xsl:when>
			<xsl:when test='$key = &quot;catalog.gemet.queryGemet&quot; '>i18n.catalog.gemet.queryGemet</xsl:when>
			<xsl:when test='$key = &quot;catalog.gemet.queryGemet.alt&quot; '>i18n.catalog.gemet.queryGemet.alt</xsl:when>
			<xsl:when test='$key = &quot;catalog.gemet.search&quot; '>i18n.catalog.gemet.search</xsl:when>
			<xsl:when test='$key = &quot;catalog.gemet.search&quot; '>i18n.catalog.gemet.search</xsl:when>
			<xsl:when test='$key = &quot;catalog.gemet.wordNotFound&quot; '>i18n.catalog.gemet.wordNotFound</xsl:when>
			<xsl:when test='$key = &quot;catalog.gemini.MD_Metadata.hierarchyLevel&quot; '>i18n.catalog.gemini.MD_Metadata.hierarchyLevel</xsl:when>
			<xsl:when test='$key = &quot;catalog.gemini.schema.dataset&quot; '>i18n.catalog.gemini.schema.dataset</xsl:when>
			<xsl:when test='$key = &quot;catalog.gemini.schema.services&quot; '>i18n.catalog.gemini.schema.services</xsl:when>
			<xsl:when test='$key = &quot;catalog.general.datepicker.clearStatus&quot; '>i18n.catalog.general.datepicker.clearStatus</xsl:when>
			<xsl:when test='$key = &quot;catalog.general.datepicker.clearText&quot; '>i18n.catalog.general.datepicker.clearText</xsl:when>
			<xsl:when test='$key = &quot;catalog.general.datepicker.closeStatus&quot; '>i18n.catalog.general.datepicker.closeStatus</xsl:when>
			<xsl:when test='$key = &quot;catalog.general.datepicker.closeText&quot; '>i18n.catalog.general.datepicker.closeText</xsl:when>
			<xsl:when test='$key = &quot;catalog.general.datepicker.currentStatus&quot; '>i18n.catalog.general.datepicker.currentStatus</xsl:when>
			<xsl:when test='$key = &quot;catalog.general.datepicker.currentText&quot; '>i18n.catalog.general.datepicker.currentText</xsl:when>
			<xsl:when test='$key = &quot;catalog.general.datepicker.dateStatus&quot; '>i18n.catalog.general.datepicker.dateStatus</xsl:when>
			<xsl:when test='$key = &quot;catalog.general.datepicker.dayNames&quot; '>i18n.catalog.general.datepicker.dayNames</xsl:when>
			<xsl:when test='$key = &quot;catalog.general.datepicker.dayNamesMin&quot; '>i18n.catalog.general.datepicker.dayNamesMin</xsl:when>
			<xsl:when test='$key = &quot;catalog.general.datepicker.dayNamesShort&quot; '>i18n.catalog.general.datepicker.dayNamesShort</xsl:when>
			<xsl:when test='$key = &quot;catalog.general.datepicker.dayStatus&quot; '>i18n.catalog.general.datepicker.dayStatus</xsl:when>
			<xsl:when test='$key = &quot;catalog.general.datepicker.initStatus&quot; '>i18n.catalog.general.datepicker.initStatus</xsl:when>
			<xsl:when test='$key = &quot;catalog.general.datepicker.monthNames&quot; '>i18n.catalog.general.datepicker.monthNames</xsl:when>
			<xsl:when test='$key = &quot;catalog.general.datepicker.monthStatus&quot; '>i18n.catalog.general.datepicker.monthStatus</xsl:when>
			<xsl:when test='$key = &quot;catalog.general.datepicker.nextStatus&quot; '>i18n.catalog.general.datepicker.nextStatus</xsl:when>
			<xsl:when test='$key = &quot;catalog.general.datepicker.nextText&quot; '>i18n.catalog.general.datepicker.nextText</xsl:when>
			<xsl:when test='$key = &quot;catalog.general.datepicker.prevStatus&quot; '>i18n.catalog.general.datepicker.prevStatus</xsl:when>
			<xsl:when test='$key = &quot;catalog.general.datepicker.prevText&quot; '>i18n.catalog.general.datepicker.prevText</xsl:when>
			<xsl:when test='$key = &quot;catalog.general.datepicker.weakHeader&quot; '>i18n.catalog.general.datepicker.weakHeader</xsl:when>
			<xsl:when test='$key = &quot;catalog.general.datepicker.weakStatus&quot; '>i18n.catalog.general.datepicker.weakStatus</xsl:when>
			<xsl:when test='$key = &quot;catalog.general.datepicker.yearStatus&quot; '>i18n.catalog.general.datepicker.yearStatus</xsl:when>
			<xsl:when test='$key = &quot;catalog.general.designOnly&quot; '>i18n.catalog.general.designOnly</xsl:when>
			<xsl:when test='$key = &quot;catalog.general.dialog.cancel&quot; '>i18n.catalog.general.dialog.cancel</xsl:when>
			<xsl:when test='$key = &quot;catalog.general.dialog.ok&quot; '>i18n.catalog.general.dialog.ok</xsl:when>
			<xsl:when test='$key = &quot;catalog.general.inputDateFormat&quot; '>i18n.catalog.general.inputDateFormat</xsl:when>
			<xsl:when test='$key = &quot;catalog.general.inputLatitudeFormat&quot; '>i18n.catalog.general.inputLatitudeFormat</xsl:when>
			<xsl:when test='$key = &quot;catalog.general.inputLongitudeFormat&quot; '>i18n.catalog.general.inputLongitudeFormat</xsl:when>
			<xsl:when test='$key = &quot;catalog.general.map.deactivate&quot; '>i18n.catalog.general.map.deactivate</xsl:when>
			<xsl:when test='$key = &quot;catalog.general.map.drawInputEnvelope&quot; '>i18n.catalog.general.map.drawInputEnvelope</xsl:when>
			<xsl:when test='$key = &quot;catalog.general.map.drawInputEnvelope&quot; '>i18n.catalog.general.map.drawInputEnvelope</xsl:when>
			<xsl:when test='$key = &quot;catalog.general.map.drawInputEnvelope&quot; '>i18n.catalog.general.map.drawInputEnvelope</xsl:when>
			<xsl:when test='$key = &quot;catalog.general.map.locate&quot; '>i18n.catalog.general.map.locate</xsl:when>
			<xsl:when test='$key = &quot;catalog.general.map.useMap&quot; '>i18n.catalog.general.map.useMap</xsl:when>
			<xsl:when test='$key = &quot;catalog.general.map.zoomToInputEnvelope&quot; '>i18n.catalog.general.map.zoomToInputEnvelope</xsl:when>
			<xsl:when test='$key = &quot;catalog.general.map.zoomToInputEnvelope&quot; '>i18n.catalog.general.map.zoomToInputEnvelope</xsl:when>
			<xsl:when test='$key = &quot;catalog.general.map.zoomToInputEnvelope&quot; '>i18n.catalog.general.map.zoomToInputEnvelope</xsl:when>
			<xsl:when test='$key = &quot;catalog.general.map.zoomToWorld&quot; '>i18n.catalog.general.map.zoomToWorld</xsl:when>
			<xsl:when test='$key = &quot;catalog.general.map.zoomToWorld&quot; '>i18n.catalog.general.map.zoomToWorld</xsl:when>
			<xsl:when test='$key = &quot;catalog.general.map.zoomToWorld&quot; '>i18n.catalog.general.map.zoomToWorld</xsl:when>
			<xsl:when test='$key = &quot;catalog.general.pageCursor.first&quot; '>i18n.catalog.general.pageCursor.first</xsl:when>
			<xsl:when test='$key = &quot;catalog.general.pageCursor.first.alt&quot; '>i18n.catalog.general.pageCursor.first.alt</xsl:when>
			<xsl:when test='$key = &quot;catalog.general.pageCursor.last&quot; '>i18n.catalog.general.pageCursor.last</xsl:when>
			<xsl:when test='$key = &quot;catalog.general.pageCursor.last.alt&quot; '>i18n.catalog.general.pageCursor.last.alt</xsl:when>
			<xsl:when test='$key = &quot;catalog.general.pageCursor.next&quot; '>i18n.catalog.general.pageCursor.next</xsl:when>
			<xsl:when test='$key = &quot;catalog.general.pageCursor.next.alt&quot; '>i18n.catalog.general.pageCursor.next.alt</xsl:when>
			<xsl:when test='$key = &quot;catalog.general.pageCursor.nomatch&quot; '>i18n.catalog.general.pageCursor.nomatch</xsl:when>
			<xsl:when test='$key = &quot;catalog.general.pageCursor.pagesPrefix.alt&quot; '>i18n.catalog.general.pageCursor.pagesPrefix.alt</xsl:when>
			<xsl:when test='$key = &quot;catalog.general.pageCursor.previous&quot; '>i18n.catalog.general.pageCursor.previous</xsl:when>
			<xsl:when test='$key = &quot;catalog.general.pageCursor.previous.alt&quot; '>i18n.catalog.general.pageCursor.previous.alt</xsl:when>
			<xsl:when test='$key = &quot;catalog.general.pageCursor.results&quot; '>i18n.catalog.general.pageCursor.results</xsl:when>
			<xsl:when test='$key = &quot;catalog.general.pageCursor.resultsPerPage&quot; '>i18n.catalog.general.pageCursor.resultsPerPage</xsl:when>
			<xsl:when test='$key = &quot;catalog.general.requiredFieldNote&quot; '>i18n.catalog.general.requiredFieldNote</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc&quot; '>i18n.catalog.gxe.dc</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.abstract&quot; '>i18n.catalog.gxe.dc.abstract</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.accessRights&quot; '>i18n.catalog.gxe.dc.accessRights</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.accrualMethod&quot; '>i18n.catalog.gxe.dc.accrualMethod</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.accrualPeriodicity&quot; '>i18n.catalog.gxe.dc.accrualPeriodicity</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.accrualPolicy&quot; '>i18n.catalog.gxe.dc.accrualPolicy</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.alternative&quot; '>i18n.catalog.gxe.dc.alternative</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.audience&quot; '>i18n.catalog.gxe.dc.audience</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.available&quot; '>i18n.catalog.gxe.dc.available</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.bibliographicCitation&quot; '>i18n.catalog.gxe.dc.bibliographicCitation</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.conformsTo&quot; '>i18n.catalog.gxe.dc.conformsTo</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.contributor&quot; '>i18n.catalog.gxe.dc.contributor</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.coverage&quot; '>i18n.catalog.gxe.dc.coverage</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.created&quot; '>i18n.catalog.gxe.dc.created</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.creator&quot; '>i18n.catalog.gxe.dc.creator</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.date&quot; '>i18n.catalog.gxe.dc.date</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.dateAccepted&quot; '>i18n.catalog.gxe.dc.dateAccepted</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.dateCopyrighted&quot; '>i18n.catalog.gxe.dc.dateCopyrighted</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.dateSubmitted&quot; '>i18n.catalog.gxe.dc.dateSubmitted</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.description&quot; '>i18n.catalog.gxe.dc.description</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.educationLevel&quot; '>i18n.catalog.gxe.dc.educationLevel</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.extent&quot; '>i18n.catalog.gxe.dc.extent</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.format&quot; '>i18n.catalog.gxe.dc.format</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.hasFormat&quot; '>i18n.catalog.gxe.dc.hasFormat</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.hasPart&quot; '>i18n.catalog.gxe.dc.hasPart</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.hasVersion&quot; '>i18n.catalog.gxe.dc.hasVersion</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.identifier&quot; '>i18n.catalog.gxe.dc.identifier</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.instructionalMethod&quot; '>i18n.catalog.gxe.dc.instructionalMethod</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.isFormatOf&quot; '>i18n.catalog.gxe.dc.isFormatOf</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.isPartOf&quot; '>i18n.catalog.gxe.dc.isPartOf</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.isReferencedBy&quot; '>i18n.catalog.gxe.dc.isReferencedBy</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.isReplacedBy&quot; '>i18n.catalog.gxe.dc.isReplacedBy</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.isRequiredBy&quot; '>i18n.catalog.gxe.dc.isRequiredBy</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.issued&quot; '>i18n.catalog.gxe.dc.issued</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.isVersionOf&quot; '>i18n.catalog.gxe.dc.isVersionOf</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.language&quot; '>i18n.catalog.gxe.dc.language</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.license&quot; '>i18n.catalog.gxe.dc.license</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.mediator&quot; '>i18n.catalog.gxe.dc.mediator</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.medium&quot; '>i18n.catalog.gxe.dc.medium</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.modified&quot; '>i18n.catalog.gxe.dc.modified</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.provenance&quot; '>i18n.catalog.gxe.dc.provenance</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.publisher&quot; '>i18n.catalog.gxe.dc.publisher</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.references&quot; '>i18n.catalog.gxe.dc.references</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.relation&quot; '>i18n.catalog.gxe.dc.relation</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.replaces&quot; '>i18n.catalog.gxe.dc.replaces</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.requires&quot; '>i18n.catalog.gxe.dc.requires</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.rights&quot; '>i18n.catalog.gxe.dc.rights</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.rightsHolder&quot; '>i18n.catalog.gxe.dc.rightsHolder</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.section.accrual&quot; '>i18n.catalog.gxe.dc.section.accrual</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.section.audience&quot; '>i18n.catalog.gxe.dc.section.audience</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.section.coverage&quot; '>i18n.catalog.gxe.dc.section.coverage</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.section.dates&quot; '>i18n.catalog.gxe.dc.section.dates</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.section.format&quot; '>i18n.catalog.gxe.dc.section.format</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.section.other&quot; '>i18n.catalog.gxe.dc.section.other</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.section.relation&quot; '>i18n.catalog.gxe.dc.section.relation</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.section.resource&quot; '>i18n.catalog.gxe.dc.section.resource</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.section.rights&quot; '>i18n.catalog.gxe.dc.section.rights</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.section.roles&quot; '>i18n.catalog.gxe.dc.section.roles</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.source&quot; '>i18n.catalog.gxe.dc.source</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.spatial&quot; '>i18n.catalog.gxe.dc.spatial</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.subject&quot; '>i18n.catalog.gxe.dc.subject</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.tableOfContents&quot; '>i18n.catalog.gxe.dc.tableOfContents</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.temporal&quot; '>i18n.catalog.gxe.dc.temporal</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.title&quot; '>i18n.catalog.gxe.dc.title</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.type&quot; '>i18n.catalog.gxe.dc.type</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dc.valid&quot; '>i18n.catalog.gxe.dc.valid</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dialog.anchor.metadata&quot; '>i18n.catalog.gxe.dialog.anchor.metadata</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dialog.cancel&quot; '>i18n.catalog.gxe.dialog.cancel</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dialog.close&quot; '>i18n.catalog.gxe.dialog.close</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dialog.create&quot; '>i18n.catalog.gxe.dialog.create</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dialog.createTitle&quot; '>i18n.catalog.gxe.dialog.createTitle</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dialog.download&quot; '>i18n.catalog.gxe.dialog.download</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dialog.edit&quot; '>i18n.catalog.gxe.dialog.edit</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dialog.genericError&quot; '>i18n.catalog.gxe.dialog.genericError</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dialog.import&quot; '>i18n.catalog.gxe.dialog.import</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dialog.invalidResponse&quot; '>i18n.catalog.gxe.dialog.invalidResponse</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dialog.loading&quot; '>i18n.catalog.gxe.dialog.loading</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dialog.noDefinedTypes&quot; '>i18n.catalog.gxe.dialog.noDefinedTypes</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dialog.noMetadata&quot; '>i18n.catalog.gxe.dialog.noMetadata</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dialog.ok&quot; '>i18n.catalog.gxe.dialog.ok</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dialog.save&quot; '>i18n.catalog.gxe.dialog.save</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dialog.saveDraft&quot; '>i18n.catalog.gxe.dialog.saveDraft</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dialog.selectImportFile&quot; '>i18n.catalog.gxe.dialog.selectImportFile</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dialog.view&quot; '>i18n.catalog.gxe.dialog.view</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.dialog.viewXml&quot; '>i18n.catalog.gxe.dialog.viewXml</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.general.button.clearMessages&quot; '>i18n.catalog.gxe.general.button.clearMessages</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.general.button.moveSectionDown&quot; '>i18n.catalog.gxe.general.button.moveSectionDown</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.general.button.moveSectionLeft&quot; '>i18n.catalog.gxe.general.button.moveSectionLeft</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.general.button.moveSectionRight&quot; '>i18n.catalog.gxe.general.button.moveSectionRight</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.general.button.moveSectionUp&quot; '>i18n.catalog.gxe.general.button.moveSectionUp</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.general.button.removeSection&quot; '>i18n.catalog.gxe.general.button.removeSection</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.general.button.repeatSection&quot; '>i18n.catalog.gxe.general.button.repeatSection</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.general.choose&quot; '>i18n.catalog.gxe.general.choose</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.general.choose.none&quot; '>i18n.catalog.gxe.general.choose.none</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.general.client.error&quot; '>i18n.catalog.gxe.general.client.error</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.general.client.loading&quot; '>i18n.catalog.gxe.general.client.loading</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.general.client.saving.title&quot; '>i18n.catalog.gxe.general.client.saving.title</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.general.iso8601.tip&quot; '>i18n.catalog.gxe.general.iso8601.tip</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.general.more&quot; '>i18n.catalog.gxe.general.more</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.general.validate.date&quot; '>i18n.catalog.gxe.general.validate.date</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.general.validate.empty&quot; '>i18n.catalog.gxe.general.validate.empty</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.general.validate.format&quot; '>i18n.catalog.gxe.general.validate.format</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.general.validate.integer&quot; '>i18n.catalog.gxe.general.validate.integer</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.general.validate.iso8601&quot; '>i18n.catalog.gxe.general.validate.iso8601</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.general.validate.number&quot; '>i18n.catalog.gxe.general.validate.number</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.general.validate.ok&quot; '>i18n.catalog.gxe.general.validate.ok</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.general.validate.other&quot; '>i18n.catalog.gxe.general.validate.other</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.general.validate.valid&quot; '>i18n.catalog.gxe.general.validate.valid</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.rdf&quot; '>i18n.catalog.gxe.rdf</xsl:when>
			<xsl:when test='$key = &quot;catalog.gxe.rdf.Descriprion&quot; '>i18n.catalog.gxe.rdf.Descriprion</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.history.manage.message.err.atLeast&quot; '>i18n.catalog.harvest.history.manage.message.err.atLeast</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.history.manage.message.err.selection&quot; '>i18n.catalog.harvest.history.manage.message.err.selection</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.biota.caption&quot; '>i18n.catalog.harvest.iso.biota.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.biota.code&quot; '>i18n.catalog.harvest.iso.biota.code</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.biota.description&quot; '>i18n.catalog.harvest.iso.biota.description</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.boundaries.caption&quot; '>i18n.catalog.harvest.iso.boundaries.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.boundaries.code&quot; '>i18n.catalog.harvest.iso.boundaries.code</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.boundaries.description&quot; '>i18n.catalog.harvest.iso.boundaries.description</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.caption&quot; '>i18n.catalog.harvest.iso.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.climatologyMeteorologyAtmosphere.caption&quot; '>i18n.catalog.harvest.iso.climatologyMeteorologyAtmosphere.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.climatologyMeteorologyAtmosphere.code&quot; '>i18n.catalog.harvest.iso.climatologyMeteorologyAtmosphere.code</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.climatologyMeteorologyAtmosphere.description&quot; '>i18n.catalog.harvest.iso.climatologyMeteorologyAtmosphere.description</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.column.code&quot; '>i18n.catalog.harvest.iso.column.code</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.column.description&quot; '>i18n.catalog.harvest.iso.column.description</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.column.name&quot; '>i18n.catalog.harvest.iso.column.name</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.economy.caption&quot; '>i18n.catalog.harvest.iso.economy.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.economy.code&quot; '>i18n.catalog.harvest.iso.economy.code</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.economy.description&quot; '>i18n.catalog.harvest.iso.economy.description</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.elevation.caption&quot; '>i18n.catalog.harvest.iso.elevation.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.elevation.code&quot; '>i18n.catalog.harvest.iso.elevation.code</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.elevation.description&quot; '>i18n.catalog.harvest.iso.elevation.description</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.environment.caption&quot; '>i18n.catalog.harvest.iso.environment.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.environment.code&quot; '>i18n.catalog.harvest.iso.environment.code</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.environment.description&quot; '>i18n.catalog.harvest.iso.environment.description</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.examples&quot; '>i18n.catalog.harvest.iso.examples</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.farming.caption&quot; '>i18n.catalog.harvest.iso.farming.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.farming.code&quot; '>i18n.catalog.harvest.iso.farming.code</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.farming.description&quot; '>i18n.catalog.harvest.iso.farming.description</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.geoscientificInformation.caption&quot; '>i18n.catalog.harvest.iso.geoscientificInformation.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.geoscientificInformation.code&quot; '>i18n.catalog.harvest.iso.geoscientificInformation.code</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.geoscientificInformation.description&quot; '>i18n.catalog.harvest.iso.geoscientificInformation.description</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.health.caption&quot; '>i18n.catalog.harvest.iso.health.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.health.code&quot; '>i18n.catalog.harvest.iso.health.code</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.health.description&quot; '>i18n.catalog.harvest.iso.health.description</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.imageryBaseMapsEarthCover.caption&quot; '>i18n.catalog.harvest.iso.imageryBaseMapsEarthCover.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.imageryBaseMapsEarthCover.code&quot; '>i18n.catalog.harvest.iso.imageryBaseMapsEarthCover.code</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.imageryBaseMapsEarthCover.description&quot; '>i18n.catalog.harvest.iso.imageryBaseMapsEarthCover.description</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.inlandWaters.caption&quot; '>i18n.catalog.harvest.iso.inlandWaters.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.inlandWaters.code&quot; '>i18n.catalog.harvest.iso.inlandWaters.code</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.inlandWaters.description&quot; '>i18n.catalog.harvest.iso.inlandWaters.description</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.intelligenceMilitary.caption&quot; '>i18n.catalog.harvest.iso.intelligenceMilitary.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.intelligenceMilitary.code&quot; '>i18n.catalog.harvest.iso.intelligenceMilitary.code</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.intelligenceMilitary.description&quot; '>i18n.catalog.harvest.iso.intelligenceMilitary.description</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.location.caption&quot; '>i18n.catalog.harvest.iso.location.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.location.code&quot; '>i18n.catalog.harvest.iso.location.code</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.location.description&quot; '>i18n.catalog.harvest.iso.location.description</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.oceans.caption&quot; '>i18n.catalog.harvest.iso.oceans.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.oceans.code&quot; '>i18n.catalog.harvest.iso.oceans.code</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.oceans.description&quot; '>i18n.catalog.harvest.iso.oceans.description</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.planningCadastre.caption&quot; '>i18n.catalog.harvest.iso.planningCadastre.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.planningCadastre.code&quot; '>i18n.catalog.harvest.iso.planningCadastre.code</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.planningCadastre.description&quot; '>i18n.catalog.harvest.iso.planningCadastre.description</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.society.caption&quot; '>i18n.catalog.harvest.iso.society.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.society.code&quot; '>i18n.catalog.harvest.iso.society.code</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.society.description&quot; '>i18n.catalog.harvest.iso.society.description</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.structure.caption&quot; '>i18n.catalog.harvest.iso.structure.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.structure.code&quot; '>i18n.catalog.harvest.iso.structure.code</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.structure.description&quot; '>i18n.catalog.harvest.iso.structure.description</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.transportation.caption&quot; '>i18n.catalog.harvest.iso.transportation.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.transportation.code&quot; '>i18n.catalog.harvest.iso.transportation.code</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.transportation.description&quot; '>i18n.catalog.harvest.iso.transportation.description</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.utilitiesCommunication.caption&quot; '>i18n.catalog.harvest.iso.utilitiesCommunication.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.utilitiesCommunication.code&quot; '>i18n.catalog.harvest.iso.utilitiesCommunication.code</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.iso.utilitiesCommunication.description&quot; '>i18n.catalog.harvest.iso.utilitiesCommunication.description</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.lookup.caption&quot; '>i18n.catalog.harvest.lookup.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.lookup.introduction&quot; '>i18n.catalog.harvest.lookup.introduction</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.lookup.keywords.biota&quot; '>i18n.catalog.harvest.lookup.keywords.biota</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.lookup.keywords.boundaries&quot; '>i18n.catalog.harvest.lookup.keywords.boundaries</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.lookup.keywords.climatologyMeteorologyAtmosphere&quot; '>i18n.catalog.harvest.lookup.keywords.climatologyMeteorologyAtmosphere</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.lookup.keywords.economy&quot; '>i18n.catalog.harvest.lookup.keywords.economy</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.lookup.keywords.elevation&quot; '>i18n.catalog.harvest.lookup.keywords.elevation</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.lookup.keywords.environment&quot; '>i18n.catalog.harvest.lookup.keywords.environment</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.lookup.keywords.farming&quot; '>i18n.catalog.harvest.lookup.keywords.farming</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.lookup.keywords.geoscientificInformation&quot; '>i18n.catalog.harvest.lookup.keywords.geoscientificInformation</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.lookup.keywords.health&quot; '>i18n.catalog.harvest.lookup.keywords.health</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.lookup.keywords.imageryBaseMapsEarthCover&quot; '>i18n.catalog.harvest.lookup.keywords.imageryBaseMapsEarthCover</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.lookup.keywords.inlandWaters&quot; '>i18n.catalog.harvest.lookup.keywords.inlandWaters</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.lookup.keywords.location&quot; '>i18n.catalog.harvest.lookup.keywords.location</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.lookup.keywords.oceans&quot; '>i18n.catalog.harvest.lookup.keywords.oceans</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.lookup.keywords.planningCadastre&quot; '>i18n.catalog.harvest.lookup.keywords.planningCadastre</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.lookup.keywords.society&quot; '>i18n.catalog.harvest.lookup.keywords.society</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.lookup.keywords.structure&quot; '>i18n.catalog.harvest.lookup.keywords.structure</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.lookup.keywords.transportation&quot; '>i18n.catalog.harvest.lookup.keywords.transportation</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.lookup.keywords.utilitiesCommunication&quot; '>i18n.catalog.harvest.lookup.keywords.utilitiesCommunication</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.action&quot; '>i18n.catalog.harvest.manage.action</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.action.delete&quot; '>i18n.catalog.harvest.manage.action.delete</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.action.delete.confirm&quot; '>i18n.catalog.harvest.manage.action.delete.confirm</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.action.delete.tip&quot; '>i18n.catalog.harvest.manage.action.delete.tip</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.action.edit&quot; '>i18n.catalog.harvest.manage.action.edit</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.action.edit.tip&quot; '>i18n.catalog.harvest.manage.action.edit.tip</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.action.execute&quot; '>i18n.catalog.harvest.manage.action.execute</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.action.harvest.cancel&quot; '>i18n.catalog.harvest.manage.action.harvest.cancel</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.action.harvest.cancel.confirm&quot; '>i18n.catalog.harvest.manage.action.harvest.cancel.confirm</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.action.harvest.cancel.tip&quot; '>i18n.catalog.harvest.manage.action.harvest.cancel.tip</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.action.harvest.full&quot; '>i18n.catalog.harvest.manage.action.harvest.full</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.action.harvest.full.tip&quot; '>i18n.catalog.harvest.manage.action.harvest.full.tip</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.action.harvest.now&quot; '>i18n.catalog.harvest.manage.action.harvest.now</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.action.harvest.now.tip&quot; '>i18n.catalog.harvest.manage.action.harvest.now.tip</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.action.harvest.sync&quot; '>i18n.catalog.harvest.manage.action.harvest.sync</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.action.harvest.sync.confirm&quot; '>i18n.catalog.harvest.manage.action.harvest.sync.confirm</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.action.harvest.sync.tip&quot; '>i18n.catalog.harvest.manage.action.harvest.sync.tip</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.action.history&quot; '>i18n.catalog.harvest.manage.action.history</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.action.history.tip&quot; '>i18n.catalog.harvest.manage.action.history.tip</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.action.owner&quot; '>i18n.catalog.harvest.manage.action.owner</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.addTime.button&quot; '>i18n.catalog.harvest.manage.addTime.button</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.back&quot; '>i18n.catalog.harvest.manage.back</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.caption&quot; '>i18n.catalog.harvest.manage.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.create.caption&quot; '>i18n.catalog.harvest.manage.create.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.create.subMenuCaption&quot; '>i18n.catalog.harvest.manage.create.subMenuCaption</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.alias&quot; '>i18n.catalog.harvest.manage.edit.alias</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.atomType&quot; '>i18n.catalog.harvest.manage.edit.atomType</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.atomType.agp&quot; '>i18n.catalog.harvest.manage.edit.atomType.agp</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.atomType.agp2&quot; '>i18n.catalog.harvest.manage.edit.atomType.agp2</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.atomType.file&quot; '>i18n.catalog.harvest.manage.edit.atomType.file</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.atomType.openSearch&quot; '>i18n.catalog.harvest.manage.edit.atomType.openSearch</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.button.submit&quot; '>i18n.catalog.harvest.manage.edit.button.submit</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.button.submit.create&quot; '>i18n.catalog.harvest.manage.edit.button.submit.create</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.button.submit.createclose&quot; '>i18n.catalog.harvest.manage.edit.button.submit.createclose</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.button.submit.update&quot; '>i18n.catalog.harvest.manage.edit.button.submit.update</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.button.submit.updateclose&quot; '>i18n.catalog.harvest.manage.edit.button.submit.updateclose</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.caption&quot; '>i18n.catalog.harvest.manage.edit.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.cswProfile&quot; '>i18n.catalog.harvest.manage.edit.cswProfile</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.databaseName&quot; '>i18n.catalog.harvest.manage.edit.databaseName</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.dcat.format&quot; '>i18n.catalog.harvest.manage.edit.dcat.format</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.dest.caption&quot; '>i18n.catalog.harvest.manage.edit.dest.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.dest.f&quot; '>i18n.catalog.harvest.manage.edit.dest.f</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.dest.f.err&quot; '>i18n.catalog.harvest.manage.edit.dest.f.err</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.dest.h&quot; '>i18n.catalog.harvest.manage.edit.dest.h</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.dest.h.err&quot; '>i18n.catalog.harvest.manage.edit.dest.h.err</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.dest.o&quot; '>i18n.catalog.harvest.manage.edit.dest.o</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.dest.o.err&quot; '>i18n.catalog.harvest.manage.edit.dest.o.err</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.dest.p&quot; '>i18n.catalog.harvest.manage.edit.dest.p</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.dest.p.err&quot; '>i18n.catalog.harvest.manage.edit.dest.p.err</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.dest.u&quot; '>i18n.catalog.harvest.manage.edit.dest.u</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.dest.u.err&quot; '>i18n.catalog.harvest.manage.edit.dest.u.err</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.err.databaseNameReq&quot; '>i18n.catalog.harvest.manage.edit.err.databaseNameReq</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.err.emptyFormat&quot; '>i18n.catalog.harvest.manage.edit.err.emptyFormat</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.err.hostUrlReq&quot; '>i18n.catalog.harvest.manage.edit.err.hostUrlReq</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.err.invalidFormat&quot; '>i18n.catalog.harvest.manage.edit.err.invalidFormat</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.err.invXml&quot; '>i18n.catalog.harvest.manage.edit.err.invXml</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.err.nameReq&quot; '>i18n.catalog.harvest.manage.edit.err.nameReq</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.err.notXml&quot; '>i18n.catalog.harvest.manage.edit.err.notXml</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.err.portNumberInv&quot; '>i18n.catalog.harvest.manage.edit.err.portNumberInv</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.err.portNumberReq&quot; '>i18n.catalog.harvest.manage.edit.err.portNumberReq</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.err.prefixReq&quot; '>i18n.catalog.harvest.manage.edit.err.prefixReq</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.err.serviceNameReq&quot; '>i18n.catalog.harvest.manage.edit.err.serviceNameReq</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.err.setReq&quot; '>i18n.catalog.harvest.manage.edit.err.setReq</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.err.soapUrl&quot; '>i18n.catalog.harvest.manage.edit.err.soapUrl</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.example&quot; '>i18n.catalog.harvest.manage.edit.example</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.format.sgml&quot; '>i18n.catalog.harvest.manage.edit.format.sgml</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.format.xml&quot; '>i18n.catalog.harvest.manage.edit.format.xml</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.frequency.adhoc&quot; '>i18n.catalog.harvest.manage.edit.frequency.adhoc</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.frequency.biweekly&quot; '>i18n.catalog.harvest.manage.edit.frequency.biweekly</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.frequency.caption&quot; '>i18n.catalog.harvest.manage.edit.frequency.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.frequency.dayly&quot; '>i18n.catalog.harvest.manage.edit.frequency.dayly</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.frequency.hourly&quot; '>i18n.catalog.harvest.manage.edit.frequency.hourly</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.frequency.monthly&quot; '>i18n.catalog.harvest.manage.edit.frequency.monthly</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.frequency.once&quot; '>i18n.catalog.harvest.manage.edit.frequency.once</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.frequency.periodical&quot; '>i18n.catalog.harvest.manage.edit.frequency.periodical</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.frequency.skip&quot; '>i18n.catalog.harvest.manage.edit.frequency.skip</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.frequency.weekly&quot; '>i18n.catalog.harvest.manage.edit.frequency.weekly</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.hostUrl&quot; '>i18n.catalog.harvest.manage.edit.hostUrl</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.info.caption&quot; '>i18n.catalog.harvest.manage.edit.info.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.info.choice.cancelSync&quot; '>i18n.catalog.harvest.manage.edit.info.choice.cancelSync</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.info.choice.caption&quot; '>i18n.catalog.harvest.manage.edit.info.choice.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.info.choice.fullSync&quot; '>i18n.catalog.harvest.manage.edit.info.choice.fullSync</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.info.choice.incSync&quot; '>i18n.catalog.harvest.manage.edit.info.choice.incSync</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.info.status.canceled&quot; '>i18n.catalog.harvest.manage.edit.info.status.canceled</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.info.status.caption&quot; '>i18n.catalog.harvest.manage.edit.info.status.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.info.status.none&quot; '>i18n.catalog.harvest.manage.edit.info.status.none</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.info.status.running&quot; '>i18n.catalog.harvest.manage.edit.info.status.running</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.info.status.scheduled&quot; '>i18n.catalog.harvest.manage.edit.info.status.scheduled</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.info.status.submitted&quot; '>i18n.catalog.harvest.manage.edit.info.status.submitted</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.name&quot; '>i18n.catalog.harvest.manage.edit.name</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.notification.caption&quot; '>i18n.catalog.harvest.manage.edit.notification.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.notification.no&quot; '>i18n.catalog.harvest.manage.edit.notification.no</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.notification.yes&quot; '>i18n.catalog.harvest.manage.edit.notification.yes</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.portNumber&quot; '>i18n.catalog.harvest.manage.edit.portNumber</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.prefix&quot; '>i18n.catalog.harvest.manage.edit.prefix</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.protocol.agp&quot; '>i18n.catalog.harvest.manage.edit.protocol.agp</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.protocol.agp2agp&quot; '>i18n.catalog.harvest.manage.edit.protocol.agp2agp</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.protocol.ags2agp&quot; '>i18n.catalog.harvest.manage.edit.protocol.ags2agp</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.protocol.any&quot; '>i18n.catalog.harvest.manage.edit.protocol.any</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.protocol.arcgis&quot; '>i18n.catalog.harvest.manage.edit.protocol.arcgis</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.protocol.arcims&quot; '>i18n.catalog.harvest.manage.edit.protocol.arcims</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.protocol.asDraft&quot; '>i18n.catalog.harvest.manage.edit.protocol.asDraft</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.protocol.atom&quot; '>i18n.catalog.harvest.manage.edit.protocol.atom</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.protocol.autoApprove&quot; '>i18n.catalog.harvest.manage.edit.protocol.autoApprove</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.protocol.csw&quot; '>i18n.catalog.harvest.manage.edit.protocol.csw</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.protocol.dcat&quot; '>i18n.catalog.harvest.manage.edit.protocol.dcat</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.protocol.oai&quot; '>i18n.catalog.harvest.manage.edit.protocol.oai</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.protocol.resource&quot; '>i18n.catalog.harvest.manage.edit.protocol.resource</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.protocol.robots.mode.always&quot; '>i18n.catalog.harvest.manage.edit.protocol.robots.mode.always</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.protocol.robots.mode.caption&quot; '>i18n.catalog.harvest.manage.edit.protocol.robots.mode.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.protocol.robots.mode.inherit&quot; '>i18n.catalog.harvest.manage.edit.protocol.robots.mode.inherit</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.protocol.robots.mode.never&quot; '>i18n.catalog.harvest.manage.edit.protocol.robots.mode.never</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.protocol.syncOptions&quot; '>i18n.catalog.harvest.manage.edit.protocol.syncOptions</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.protocol.thredds&quot; '>i18n.catalog.harvest.manage.edit.protocol.thredds</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.protocol.updateContent&quot; '>i18n.catalog.harvest.manage.edit.protocol.updateContent</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.protocol.updateDefinition&quot; '>i18n.catalog.harvest.manage.edit.protocol.updateDefinition</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.protocol.waf&quot; '>i18n.catalog.harvest.manage.edit.protocol.waf</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.protocol.z3950&quot; '>i18n.catalog.harvest.manage.edit.protocol.z3950</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.protocolType&quot; '>i18n.catalog.harvest.manage.edit.protocolType</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.purpose.findable&quot; '>i18n.catalog.harvest.manage.edit.purpose.findable</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.purpose.searchable&quot; '>i18n.catalog.harvest.manage.edit.purpose.searchable</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.purpose.synchronizable&quot; '>i18n.catalog.harvest.manage.edit.purpose.synchronizable</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.purpose.title&quot; '>i18n.catalog.harvest.manage.edit.purpose.title</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.repositoryId&quot; '>i18n.catalog.harvest.manage.edit.repositoryId</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.repositoryUuid&quot; '>i18n.catalog.harvest.manage.edit.repositoryUuid</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.restUrl&quot; '>i18n.catalog.harvest.manage.edit.restUrl</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.rootFolder&quot; '>i18n.catalog.harvest.manage.edit.rootFolder</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.serviceName&quot; '>i18n.catalog.harvest.manage.edit.serviceName</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.set&quot; '>i18n.catalog.harvest.manage.edit.set</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.soapUrl&quot; '>i18n.catalog.harvest.manage.edit.soapUrl</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.src.ags2agp.caption&quot; '>i18n.catalog.harvest.manage.edit.src.ags2agp.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.src.caption&quot; '>i18n.catalog.harvest.manage.edit.src.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.src.h&quot; '>i18n.catalog.harvest.manage.edit.src.h</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.src.h.err&quot; '>i18n.catalog.harvest.manage.edit.src.h.err</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.src.m&quot; '>i18n.catalog.harvest.manage.edit.src.m</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.src.m.err&quot; '>i18n.catalog.harvest.manage.edit.src.m.err</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.src.m.err.less&quot; '>i18n.catalog.harvest.manage.edit.src.m.err.less</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.src.p&quot; '>i18n.catalog.harvest.manage.edit.src.p</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.src.p.err&quot; '>i18n.catalog.harvest.manage.edit.src.p.err</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.src.q&quot; '>i18n.catalog.harvest.manage.edit.src.q</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.src.q.err&quot; '>i18n.catalog.harvest.manage.edit.src.q.err</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.src.rest&quot; '>i18n.catalog.harvest.manage.edit.src.rest</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.src.soap.err&quot; '>i18n.catalog.harvest.manage.edit.src.soap.err</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.src.soap&quot; '>i18n.catalog.harvest.manage.edit.src.soap</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.src.u&quot; '>i18n.catalog.harvest.manage.edit.src.u</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.src.u.err&quot; '>i18n.catalog.harvest.manage.edit.src.u.err</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.syncCanceled&quot; '>i18n.catalog.harvest.manage.edit.syncCanceled</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.syncRunning&quot; '>i18n.catalog.harvest.manage.edit.syncRunning</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.syncRunningStats&quot; '>i18n.catalog.harvest.manage.edit.syncRunningStats</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.syncSubmitted&quot; '>i18n.catalog.harvest.manage.edit.syncSubmitted</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.testConnection&quot; '>i18n.catalog.harvest.manage.edit.testConnection</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.userName&quot; '>i18n.catalog.harvest.manage.edit.userName</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.userPassword&quot; '>i18n.catalog.harvest.manage.edit.userPassword</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.wafNote&quot; '>i18n.catalog.harvest.manage.edit.wafNote</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.edit.z3950format&quot; '>i18n.catalog.harvest.manage.edit.z3950format</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.extdlg.button.cancel&quot; '>i18n.catalog.harvest.manage.extdlg.button.cancel</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.extdlg.button.ok&quot; '>i18n.catalog.harvest.manage.extdlg.button.ok</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.extdlg.from&quot; '>i18n.catalog.harvest.manage.extdlg.from</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.extdlg.max&quot; '>i18n.catalog.harvest.manage.extdlg.max</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.extdlg.title&quot; '>i18n.catalog.harvest.manage.extdlg.title</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.extdlg.type&quot; '>i18n.catalog.harvest.manage.extdlg.type</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.extdlg.type.from&quot; '>i18n.catalog.harvest.manage.extdlg.type.from</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.extdlg.type.full&quot; '>i18n.catalog.harvest.manage.extdlg.type.full</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.extdlg.type.now&quot; '>i18n.catalog.harvest.manage.extdlg.type.now</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.harvestDate&quot; '>i18n.catalog.harvest.manage.harvestDate</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.headeraction&quot; '>i18n.catalog.harvest.manage.headeraction</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.history.actions&quot; '>i18n.catalog.harvest.manage.history.actions</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.history.actions.delete&quot; '>i18n.catalog.harvest.manage.history.actions.delete</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.history.actions.delete.confirm&quot; '>i18n.catalog.harvest.manage.history.actions.delete.confirm</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.history.actions.delete.tip&quot; '>i18n.catalog.harvest.manage.history.actions.delete.tip</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.history.actions.execute&quot; '>i18n.catalog.harvest.manage.history.actions.execute</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.history.actions.viewreport&quot; '>i18n.catalog.harvest.manage.history.actions.viewreport</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.history.actions.viewreport.tip&quot; '>i18n.catalog.harvest.manage.history.actions.viewreport.tip</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.history.caption&quot; '>i18n.catalog.harvest.manage.history.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.history.date&quot; '>i18n.catalog.harvest.manage.history.date</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.history.harvested&quot; '>i18n.catalog.harvest.manage.history.harvested</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.history.headeraction&quot; '>i18n.catalog.harvest.manage.history.headeraction</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.history.message.deleted&quot; '>i18n.catalog.harvest.manage.history.message.deleted</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.history.message.readingError&quot; '>i18n.catalog.harvest.manage.history.message.readingError</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.history.published&quot; '>i18n.catalog.harvest.manage.history.published</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.history.reportUuid&quot; '>i18n.catalog.harvest.manage.history.reportUuid</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.history.repository&quot; '>i18n.catalog.harvest.manage.history.repository</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.history.repositoryName&quot; '>i18n.catalog.harvest.manage.history.repositoryName</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.history.repositoryProtocol&quot; '>i18n.catalog.harvest.manage.history.repositoryProtocol</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.history.repositoryUrl&quot; '>i18n.catalog.harvest.manage.history.repositoryUrl</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.history.repositoryUuid&quot; '>i18n.catalog.harvest.manage.history.repositoryUuid</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.history.search.button&quot; '>i18n.catalog.harvest.manage.history.search.button</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.history.search.fromDate&quot; '>i18n.catalog.harvest.manage.history.search.fromDate</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.history.search.toDate&quot; '>i18n.catalog.harvest.manage.history.search.toDate</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.history.search.uuid&quot; '>i18n.catalog.harvest.manage.history.search.uuid</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.history.validated&quot; '>i18n.catalog.harvest.manage.history.validated</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.hostUrl&quot; '>i18n.catalog.harvest.manage.hostUrl</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.inputDate&quot; '>i18n.catalog.harvest.manage.inputDate</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.localId&quot; '>i18n.catalog.harvest.manage.localId</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.menuCaption&quot; '>i18n.catalog.harvest.manage.menuCaption</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.message.canceled&quot; '>i18n.catalog.harvest.manage.message.canceled</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.message.create&quot; '>i18n.catalog.harvest.manage.message.create</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.message.create.2&quot; '>i18n.catalog.harvest.manage.message.create.2</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.message.deleted&quot; '>i18n.catalog.harvest.manage.message.deleted</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.message.err.atLeast&quot; '>i18n.catalog.harvest.manage.message.err.atLeast</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.message.err.duplicatedUrl&quot; '>i18n.catalog.harvest.manage.message.err.duplicatedUrl</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.message.err.idInv&quot; '>i18n.catalog.harvest.manage.message.err.idInv</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.message.err.missing&quot; '>i18n.catalog.harvest.manage.message.err.missing</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.message.err.selection&quot; '>i18n.catalog.harvest.manage.message.err.selection</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.message.harvested&quot; '>i18n.catalog.harvest.manage.message.harvested</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.message.harvested.none&quot; '>i18n.catalog.harvest.manage.message.harvested.none</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.message.synchronized&quot; '>i18n.catalog.harvest.manage.message.synchronized</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.message.synchronized.none&quot; '>i18n.catalog.harvest.manage.message.synchronized.none</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.message.update&quot; '>i18n.catalog.harvest.manage.message.update</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.message.update.2&quot; '>i18n.catalog.harvest.manage.message.update.2</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.message.willBeGenerated&quot; '>i18n.catalog.harvest.manage.message.willBeGenerated</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.name&quot; '>i18n.catalog.harvest.manage.name</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.nextHarvestDate&quot; '>i18n.catalog.harvest.manage.nextHarvestDate</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.report.back&quot; '>i18n.catalog.harvest.manage.report.back</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.report.caption&quot; '>i18n.catalog.harvest.manage.report.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.report.details&quot; '>i18n.catalog.harvest.manage.report.details</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.report.summary&quot; '>i18n.catalog.harvest.manage.report.summary</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.report.xsltparam.errorsLimitation&quot; '>i18n.catalog.harvest.manage.report.xsltparam.errorsLimitation</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.report.xsltparam.parameter&quot; '>i18n.catalog.harvest.manage.report.xsltparam.parameter</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.report.xsltparam.publishError&quot; '>i18n.catalog.harvest.manage.report.xsltparam.publishError</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.report.xsltparam.publishStatus&quot; '>i18n.catalog.harvest.manage.report.xsltparam.publishStatus</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.report.xsltparam.recordsLimitation&quot; '>i18n.catalog.harvest.manage.report.xsltparam.recordsLimitation</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.report.xsltparam.sourceUri&quot; '>i18n.catalog.harvest.manage.report.xsltparam.sourceUri</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.report.xsltparam.statusFailed&quot; '>i18n.catalog.harvest.manage.report.xsltparam.statusFailed</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.report.xsltparam.statusOk&quot; '>i18n.catalog.harvest.manage.report.xsltparam.statusOk</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.report.xsltparam.validationError&quot; '>i18n.catalog.harvest.manage.report.xsltparam.validationError</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.report.xsltparam.validationStatus&quot; '>i18n.catalog.harvest.manage.report.xsltparam.validationStatus</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.report.xsltparam.value&quot; '>i18n.catalog.harvest.manage.report.xsltparam.value</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.search.button&quot; '>i18n.catalog.harvest.manage.search.button</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.search.dueOnly&quot; '>i18n.catalog.harvest.manage.search.dueOnly</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.search.fromDate&quot; '>i18n.catalog.harvest.manage.search.fromDate</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.search.harvestFromDate&quot; '>i18n.catalog.harvest.manage.search.harvestFromDate</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.search.harvestToDate&quot; '>i18n.catalog.harvest.manage.search.harvestToDate</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.search.host&quot; '>i18n.catalog.harvest.manage.search.host</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.search.localId&quot; '>i18n.catalog.harvest.manage.search.localId</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.search.name&quot; '>i18n.catalog.harvest.manage.search.name</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.search.toDate&quot; '>i18n.catalog.harvest.manage.search.toDate</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.search.type&quot; '>i18n.catalog.harvest.manage.search.type</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.search.uuid&quot; '>i18n.catalog.harvest.manage.search.uuid</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.subMenuCaption&quot; '>i18n.catalog.harvest.manage.subMenuCaption</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.test.err.agp2agp.connect&quot; '>i18n.catalog.harvest.manage.test.err.agp2agp.connect</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.test.err.agp2agp.dst.nocredentials&quot; '>i18n.catalog.harvest.manage.test.err.agp2agp.dst.nocredentials</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.test.err.agp2agp.dst.nohost&quot; '>i18n.catalog.harvest.manage.test.err.agp2agp.dst.nohost</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.test.err.agp2agp.src.nocredentials&quot; '>i18n.catalog.harvest.manage.test.err.agp2agp.src.nocredentials</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.test.err.agp2agp.src.nohost&quot; '>i18n.catalog.harvest.manage.test.err.agp2agp.src.nohost</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.test.err.agp2agp.src.noquery&quot; '>i18n.catalog.harvest.manage.test.err.agp2agp.src.noquery</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.test.err.HarvestConnectionException&quot; '>i18n.catalog.harvest.manage.test.err.HarvestConnectionException</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.test.err.HarvestInvalidArgumentException&quot; '>i18n.catalog.harvest.manage.test.err.HarvestInvalidArgumentException</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.test.err.HarvestInvalidDatabaseName&quot; '>i18n.catalog.harvest.manage.test.err.HarvestInvalidDatabaseName</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.test.err.HarvestInvalidPortNo&quot; '>i18n.catalog.harvest.manage.test.err.HarvestInvalidPortNo</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.test.err.HarvestInvalidPrefix&quot; '>i18n.catalog.harvest.manage.test.err.HarvestInvalidPrefix</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.test.err.HarvestInvalidResponseException&quot; '>i18n.catalog.harvest.manage.test.err.HarvestInvalidResponseException</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.test.err.HarvestInvalidServiceName&quot; '>i18n.catalog.harvest.manage.test.err.HarvestInvalidServiceName</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.test.err.HarvestInvalidSet&quot; '>i18n.catalog.harvest.manage.test.err.HarvestInvalidSet</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.test.err.HarvestInvalidSourceURI&quot; '>i18n.catalog.harvest.manage.test.err.HarvestInvalidSourceURI</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.test.err.HarvestInvalidUrl&quot; '>i18n.catalog.harvest.manage.test.err.HarvestInvalidUrl</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.test.err.HarvestInvalidUserName&quot; '>i18n.catalog.harvest.manage.test.err.HarvestInvalidUserName</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.test.err.HarvestInvalidUserPassword&quot; '>i18n.catalog.harvest.manage.test.err.HarvestInvalidUserPassword</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.test.err.HarvestTimeoutException&quot; '>i18n.catalog.harvest.manage.test.err.HarvestTimeoutException</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.test.msg.agp2agp.arcgis.forbiden&quot; '>i18n.catalog.harvest.manage.test.msg.agp2agp.arcgis.forbiden</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.test.msg.agp2agp.button.fetchFolders&quot; '>i18n.catalog.harvest.manage.test.msg.agp2agp.button.fetchFolders</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.test.msg.agp2agp.button.fetchOwners&quot; '>i18n.catalog.harvest.manage.test.msg.agp2agp.button.fetchOwners</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.test.msg.agp2agp.button.testClient&quot; '>i18n.catalog.harvest.manage.test.msg.agp2agp.button.testClient</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.test.msg.agp2agp.button.testQuery&quot; '>i18n.catalog.harvest.manage.test.msg.agp2agp.button.testQuery</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.test.msg.agp2agp.confirmed&quot; '>i18n.catalog.harvest.manage.test.msg.agp2agp.confirmed</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.test.msg.agp2agp.cross.forbiden&quot; '>i18n.catalog.harvest.manage.test.msg.agp2agp.cross.forbiden</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.test.msg.agp2agp.foldersDialog.alert&quot; '>i18n.catalog.harvest.manage.test.msg.agp2agp.foldersDialog.alert</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.test.msg.agp2agp.foldersDialog.button.close&quot; '>i18n.catalog.harvest.manage.test.msg.agp2agp.foldersDialog.button.close</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.test.msg.agp2agp.foldersDialog.caption&quot; '>i18n.catalog.harvest.manage.test.msg.agp2agp.foldersDialog.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.test.msg.agp2agp.norecords&quot; '>i18n.catalog.harvest.manage.test.msg.agp2agp.norecords</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.test.msg.agp2agp.ownersDialog.alert&quot; '>i18n.catalog.harvest.manage.test.msg.agp2agp.ownersDialog.alert</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.test.msg.agp2agp.ownersDialog.button.close&quot; '>i18n.catalog.harvest.manage.test.msg.agp2agp.ownersDialog.button.close</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.test.msg.agp2agp.ownersDialog.button.search&quot; '>i18n.catalog.harvest.manage.test.msg.agp2agp.ownersDialog.button.search</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.test.msg.agp2agp.ownersDialog.caption&quot; '>i18n.catalog.harvest.manage.test.msg.agp2agp.ownersDialog.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.test.msg.agp2agp.ownersDialog.lblSearch&quot; '>i18n.catalog.harvest.manage.test.msg.agp2agp.ownersDialog.lblSearch</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.test.msg.agp2agp.success&quot; '>i18n.catalog.harvest.manage.test.msg.agp2agp.success</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.test.success&quot; '>i18n.catalog.harvest.manage.test.success</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.timeDialog.button.add&quot; '>i18n.catalog.harvest.manage.timeDialog.button.add</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.timeDialog.button.close&quot; '>i18n.catalog.harvest.manage.timeDialog.button.close</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.timeDialog.caption&quot; '>i18n.catalog.harvest.manage.timeDialog.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.timeDialog.dateStyle.date.label&quot; '>i18n.catalog.harvest.manage.timeDialog.dateStyle.date.label</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.timeDialog.dateStyle.pattern.label&quot; '>i18n.catalog.harvest.manage.timeDialog.dateStyle.pattern.label</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.timeDialog.timeInput.label&quot; '>i18n.catalog.harvest.manage.timeDialog.timeInput.label</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.timeDialog.timeSpecDate.label&quot; '>i18n.catalog.harvest.manage.timeDialog.timeSpecDate.label</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.type&quot; '>i18n.catalog.harvest.manage.type</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.updateDate&quot; '>i18n.catalog.harvest.manage.updateDate</xsl:when>
			<xsl:when test='$key = &quot;catalog.harvest.manage.uuid&quot; '>i18n.catalog.harvest.manage.uuid</xsl:when>
			<xsl:when test='$key = &quot;catalog.help.menuCaption&quot; '>i18n.catalog.help.menuCaption</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.addRole.self&quot; '>i18n.catalog.identity.addRole.self</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.addRole.success&quot; '>i18n.catalog.identity.addRole.success</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.changePassword.button.submit&quot; '>i18n.catalog.identity.changePassword.button.submit</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.changePassword.caption&quot; '>i18n.catalog.identity.changePassword.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.changePassword.err.confirm&quot; '>i18n.catalog.identity.changePassword.err.confirm</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.changePassword.err.new&quot; '>i18n.catalog.identity.changePassword.err.new</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.changePassword.err.old&quot; '>i18n.catalog.identity.changePassword.err.old</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.changePassword.label.confirm&quot; '>i18n.catalog.identity.changePassword.label.confirm</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.changePassword.label.new&quot; '>i18n.catalog.identity.changePassword.label.new</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.changePassword.label.old&quot; '>i18n.catalog.identity.changePassword.label.old</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.changePassword.label.username&quot; '>i18n.catalog.identity.changePassword.label.username</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.changePassword.menuCaption&quot; '>i18n.catalog.identity.changePassword.menuCaption</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.changePassword.prompt&quot; '>i18n.catalog.identity.changePassword.prompt</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.changePassword.success&quot; '>i18n.catalog.identity.changePassword.success</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.deleteUser.self&quot; '>i18n.catalog.identity.deleteUser.self</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.deleteUser.success&quot; '>i18n.catalog.identity.deleteUser.success</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.encryptPassword.button.submit&quot; '>i18n.catalog.identity.encryptPassword.button.submit</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.encryptPassword.caption&quot; '>i18n.catalog.identity.encryptPassword.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.encryptPassword.label.input&quot; '>i18n.catalog.identity.encryptPassword.label.input</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.encryptPassword.label.output&quot; '>i18n.catalog.identity.encryptPassword.label.output</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.encryptPassword.notAuthorized&quot; '>i18n.catalog.identity.encryptPassword.notAuthorized</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.feedback.button.submit&quot; '>i18n.catalog.identity.feedback.button.submit</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.feedback.caption&quot; '>i18n.catalog.identity.feedback.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.feedback.email.body&quot; '>i18n.catalog.identity.feedback.email.body</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.feedback.email.subject&quot; '>i18n.catalog.identity.feedback.email.subject</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.feedback.err.body&quot; '>i18n.catalog.identity.feedback.err.body</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.feedback.err.email&quot; '>i18n.catalog.identity.feedback.err.email</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.feedback.label.body&quot; '>i18n.catalog.identity.feedback.label.body</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.feedback.label.email&quot; '>i18n.catalog.identity.feedback.label.email</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.feedback.label.name&quot; '>i18n.catalog.identity.feedback.label.name</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.feedback.menuCaption&quot; '>i18n.catalog.identity.feedback.menuCaption</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.feedback.prompt&quot; '>i18n.catalog.identity.feedback.prompt</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.feedback.success&quot; '>i18n.catalog.identity.feedback.success</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.forgotPassword.button.forgotUsername&quot; '>i18n.catalog.identity.forgotPassword.button.forgotUsername</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.forgotPassword.button.submit&quot; '>i18n.catalog.identity.forgotPassword.button.submit</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.forgotPassword.caption&quot; '>i18n.catalog.identity.forgotPassword.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.forgotPassword.email.body&quot; '>i18n.catalog.identity.forgotPassword.email.body</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.forgotPassword.email.subject&quot; '>i18n.catalog.identity.forgotPassword.email.subject</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.forgotPassword.err.denied&quot; '>i18n.catalog.identity.forgotPassword.err.denied</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.forgotPassword.menuCaption&quot; '>i18n.catalog.identity.forgotPassword.menuCaption</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.forgotPassword.prompt&quot; '>i18n.catalog.identity.forgotPassword.prompt</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.forgotPassword.success&quot; '>i18n.catalog.identity.forgotPassword.success</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.general.passwordPolicy&quot; '>i18n.catalog.identity.general.passwordPolicy</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.general.passwordPolicy.strong&quot; '>i18n.catalog.identity.general.passwordPolicy.strong</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.general.usernamePolicy&quot; '>i18n.catalog.identity.general.usernamePolicy</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.login.button.submit&quot; '>i18n.catalog.identity.login.button.submit</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.login.caption&quot; '>i18n.catalog.identity.login.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.login.err.denied&quot; '>i18n.catalog.identity.login.err.denied</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.login.menuCaption&quot; '>i18n.catalog.identity.login.menuCaption</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.login.prompt&quot; '>i18n.catalog.identity.login.prompt</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.login.success&quot; '>i18n.catalog.identity.login.success</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.logout.menuCaption&quot; '>i18n.catalog.identity.logout.menuCaption</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.myLicenses.caption&quot; '>i18n.catalog.identity.myLicenses.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.myProfile.button.submit&quot; '>i18n.catalog.identity.myProfile.button.submit</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.myProfile.caption&quot; '>i18n.catalog.identity.myProfile.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.myProfile.menuCaption&quot; '>i18n.catalog.identity.myProfile.menuCaption</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.myProfile.prompt&quot; '>i18n.catalog.identity.myProfile.prompt</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.myProfile.success&quot; '>i18n.catalog.identity.myProfile.success</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.profile.err.confirm&quot; '>i18n.catalog.identity.profile.err.confirm</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.profile.err.email&quot; '>i18n.catalog.identity.profile.err.email</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.profile.err.password&quot; '>i18n.catalog.identity.profile.err.password</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.profile.err.userExists&quot; '>i18n.catalog.identity.profile.err.userExists</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.profile.err.username&quot; '>i18n.catalog.identity.profile.err.username</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.profile.label.affiliation&quot; '>i18n.catalog.identity.profile.label.affiliation</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.profile.label.city&quot; '>i18n.catalog.identity.profile.label.city</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.profile.label.confirm&quot; '>i18n.catalog.identity.profile.label.confirm</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.profile.label.country&quot; '>i18n.catalog.identity.profile.label.country</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.profile.label.displayName&quot; '>i18n.catalog.identity.profile.label.displayName</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.profile.label.email&quot; '>i18n.catalog.identity.profile.label.email</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.profile.label.firstName&quot; '>i18n.catalog.identity.profile.label.firstName</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.profile.label.jobTitle&quot; '>i18n.catalog.identity.profile.label.jobTitle</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.profile.label.lastName&quot; '>i18n.catalog.identity.profile.label.lastName</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.profile.label.organization&quot; '>i18n.catalog.identity.profile.label.organization</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.profile.label.password&quot; '>i18n.catalog.identity.profile.label.password</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.profile.label.phone&quot; '>i18n.catalog.identity.profile.label.phone</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.profile.label.postalCode&quot; '>i18n.catalog.identity.profile.label.postalCode</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.profile.label.stateOrProv&quot; '>i18n.catalog.identity.profile.label.stateOrProv</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.profile.label.street&quot; '>i18n.catalog.identity.profile.label.street</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.profile.label.username&quot; '>i18n.catalog.identity.profile.label.username</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.profile.label.website&quot; '>i18n.catalog.identity.profile.label.website</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.removeRole.self&quot; '>i18n.catalog.identity.removeRole.self</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.removeRole.success&quot; '>i18n.catalog.identity.removeRole.success</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.userRegistration.button.submit&quot; '>i18n.catalog.identity.userRegistration.button.submit</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.userRegistration.caption&quot; '>i18n.catalog.identity.userRegistration.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.userRegistration.menuCaption&quot; '>i18n.catalog.identity.userRegistration.menuCaption</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.userRegistration.prompt&quot; '>i18n.catalog.identity.userRegistration.prompt</xsl:when>
			<xsl:when test='$key = &quot;catalog.identity.userRegistration.success&quot; '>i18n.catalog.identity.userRegistration.success</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.AbstractDQ_Element&quot; '>i18n.catalog.iso19139.AbstractDQ_Element</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.AbstractDQ_Element.dateTime&quot; '>i18n.catalog.iso19139.AbstractDQ_Element.dateTime</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.AbstractDQ_Element.evaluationMethodDescription&quot; '>i18n.catalog.iso19139.AbstractDQ_Element.evaluationMethodDescription</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.AbstractDQ_Element.evaluationMethodType&quot; '>i18n.catalog.iso19139.AbstractDQ_Element.evaluationMethodType</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.AbstractDQ_Element.evaluationProcedure&quot; '>i18n.catalog.iso19139.AbstractDQ_Element.evaluationProcedure</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.AbstractDQ_Element.measureDescription&quot; '>i18n.catalog.iso19139.AbstractDQ_Element.measureDescription</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.AbstractDQ_Element.measureIdentification&quot; '>i18n.catalog.iso19139.AbstractDQ_Element.measureIdentification</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.AbstractDQ_Element.nameOfMeasure&quot; '>i18n.catalog.iso19139.AbstractDQ_Element.nameOfMeasure</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.AbstractDQ_Element.result&quot; '>i18n.catalog.iso19139.AbstractDQ_Element.result</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.AbstractDS_Aggregate&quot; '>i18n.catalog.iso19139.AbstractDS_Aggregate</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.AbstractDS_Aggregate.composedOf&quot; '>i18n.catalog.iso19139.AbstractDS_Aggregate.composedOf</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.AbstractDS_Aggregate.seriesMetadata&quot; '>i18n.catalog.iso19139.AbstractDS_Aggregate.seriesMetadata</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.AbstractDS_Aggregate.subset&quot; '>i18n.catalog.iso19139.AbstractDS_Aggregate.subset</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.AbstractDS_Aggregate.superset&quot; '>i18n.catalog.iso19139.AbstractDS_Aggregate.superset</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.AbstractEX_GeographicExtent&quot; '>i18n.catalog.iso19139.AbstractEX_GeographicExtent</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.AbstractEX_GeographicExtent.extentTypeCode&quot; '>i18n.catalog.iso19139.AbstractEX_GeographicExtent.extentTypeCode</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.AbstractMD_Identification&quot; '>i18n.catalog.iso19139.AbstractMD_Identification</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.AbstractMD_Identification.abstract&quot; '>i18n.catalog.iso19139.AbstractMD_Identification.abstract</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.AbstractMD_Identification.aggregationInfo&quot; '>i18n.catalog.iso19139.AbstractMD_Identification.aggregationInfo</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.AbstractMD_Identification.citation&quot; '>i18n.catalog.iso19139.AbstractMD_Identification.citation</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.AbstractMD_Identification.credit&quot; '>i18n.catalog.iso19139.AbstractMD_Identification.credit</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.AbstractMD_Identification.descriptiveKeywords&quot; '>i18n.catalog.iso19139.AbstractMD_Identification.descriptiveKeywords</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.AbstractMD_Identification.graphicOverview&quot; '>i18n.catalog.iso19139.AbstractMD_Identification.graphicOverview</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.AbstractMD_Identification.pointOfContact&quot; '>i18n.catalog.iso19139.AbstractMD_Identification.pointOfContact</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.AbstractMD_Identification.purpose&quot; '>i18n.catalog.iso19139.AbstractMD_Identification.purpose</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.AbstractMD_Identification.resourceConstraints&quot; '>i18n.catalog.iso19139.AbstractMD_Identification.resourceConstraints</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.AbstractMD_Identification.resourceFormat&quot; '>i18n.catalog.iso19139.AbstractMD_Identification.resourceFormat</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.AbstractMD_Identification.resourceMaintenance&quot; '>i18n.catalog.iso19139.AbstractMD_Identification.resourceMaintenance</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.AbstractMD_Identification.resourceSpecificUsage&quot; '>i18n.catalog.iso19139.AbstractMD_Identification.resourceSpecificUsage</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.AbstractMD_Identification.status&quot; '>i18n.catalog.iso19139.AbstractMD_Identification.status</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.AbstractRS_ReferenceSystem&quot; '>i18n.catalog.iso19139.AbstractRS_ReferenceSystem</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.AbstractRS_ReferenceSystem.domainOfValidity&quot; '>i18n.catalog.iso19139.AbstractRS_ReferenceSystem.domainOfValidity</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.AbstractRS_ReferenceSystem.name&quot; '>i18n.catalog.iso19139.AbstractRS_ReferenceSystem.name</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.AbstractTimePrimitive&quot; '>i18n.catalog.iso19139.AbstractTimePrimitive</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_Address&quot; '>i18n.catalog.iso19139.CI_Address</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_Address.administrativeArea&quot; '>i18n.catalog.iso19139.CI_Address.administrativeArea</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_Address.city&quot; '>i18n.catalog.iso19139.CI_Address.city</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_Address.country&quot; '>i18n.catalog.iso19139.CI_Address.country</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_Address.deliveryPoint&quot; '>i18n.catalog.iso19139.CI_Address.deliveryPoint</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_Address.electronicMailAddress&quot; '>i18n.catalog.iso19139.CI_Address.electronicMailAddress</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_Address.postalCode&quot; '>i18n.catalog.iso19139.CI_Address.postalCode</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_Citation&quot; '>i18n.catalog.iso19139.CI_Citation</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_Citation.alternateTitle&quot; '>i18n.catalog.iso19139.CI_Citation.alternateTitle</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_Citation.citedResponsibleParty&quot; '>i18n.catalog.iso19139.CI_Citation.citedResponsibleParty</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_Citation.date&quot; '>i18n.catalog.iso19139.CI_Citation.date</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_Citation.edition&quot; '>i18n.catalog.iso19139.CI_Citation.edition</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_Citation.editionDate&quot; '>i18n.catalog.iso19139.CI_Citation.editionDate</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_Citation.identifier&quot; '>i18n.catalog.iso19139.CI_Citation.identifier</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_Citation.ISBN&quot; '>i18n.catalog.iso19139.CI_Citation.ISBN</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_Citation.ISSN&quot; '>i18n.catalog.iso19139.CI_Citation.ISSN</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_Citation.otherCitationDetails&quot; '>i18n.catalog.iso19139.CI_Citation.otherCitationDetails</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_Citation.presentationForm&quot; '>i18n.catalog.iso19139.CI_Citation.presentationForm</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_Citation.series&quot; '>i18n.catalog.iso19139.CI_Citation.series</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_Citation.specification.date&quot; '>i18n.catalog.iso19139.CI_Citation.specification.date</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_Citation.specification.title&quot; '>i18n.catalog.iso19139.CI_Citation.specification.title</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_Citation.title&quot; '>i18n.catalog.iso19139.CI_Citation.title</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_Contact&quot; '>i18n.catalog.iso19139.CI_Contact</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_Contact.address&quot; '>i18n.catalog.iso19139.CI_Contact.address</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_Contact.contactInstructions&quot; '>i18n.catalog.iso19139.CI_Contact.contactInstructions</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_Contact.hoursOfService&quot; '>i18n.catalog.iso19139.CI_Contact.hoursOfService</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_Contact.onlineResource&quot; '>i18n.catalog.iso19139.CI_Contact.onlineResource</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_Contact.phone&quot; '>i18n.catalog.iso19139.CI_Contact.phone</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_Date&quot; '>i18n.catalog.iso19139.CI_Date</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_Date.date&quot; '>i18n.catalog.iso19139.CI_Date.date</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_Date.dateType&quot; '>i18n.catalog.iso19139.CI_Date.dateType</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_DateTypeCode&quot; '>i18n.catalog.iso19139.CI_DateTypeCode</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_DateTypeCode.creation&quot; '>i18n.catalog.iso19139.CI_DateTypeCode.creation</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_DateTypeCode.publication&quot; '>i18n.catalog.iso19139.CI_DateTypeCode.publication</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_DateTypeCode.revision&quot; '>i18n.catalog.iso19139.CI_DateTypeCode.revision</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_OnLineFunctionCode&quot; '>i18n.catalog.iso19139.CI_OnLineFunctionCode</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_OnLineFunctionCode.caption&quot; '>i18n.catalog.iso19139.CI_OnLineFunctionCode.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_OnLineFunctionCode.download&quot; '>i18n.catalog.iso19139.CI_OnLineFunctionCode.download</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_OnLineFunctionCode.information&quot; '>i18n.catalog.iso19139.CI_OnLineFunctionCode.information</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_OnLineFunctionCode.offlineAccess&quot; '>i18n.catalog.iso19139.CI_OnLineFunctionCode.offlineAccess</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_OnLineFunctionCode.order&quot; '>i18n.catalog.iso19139.CI_OnLineFunctionCode.order</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_OnLineFunctionCode.search&quot; '>i18n.catalog.iso19139.CI_OnLineFunctionCode.search</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_OnlineResource&quot; '>i18n.catalog.iso19139.CI_OnlineResource</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_OnlineResource.applicationProfile&quot; '>i18n.catalog.iso19139.CI_OnlineResource.applicationProfile</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_OnlineResource.description&quot; '>i18n.catalog.iso19139.CI_OnlineResource.description</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_OnlineResource.function&quot; '>i18n.catalog.iso19139.CI_OnlineResource.function</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_OnlineResource.linkage&quot; '>i18n.catalog.iso19139.CI_OnlineResource.linkage</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_OnlineResource.name&quot; '>i18n.catalog.iso19139.CI_OnlineResource.name</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_OnlineResource.protocol&quot; '>i18n.catalog.iso19139.CI_OnlineResource.protocol</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_PresentationFormCode&quot; '>i18n.catalog.iso19139.CI_PresentationFormCode</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_PresentationFormCode.documentDigital&quot; '>i18n.catalog.iso19139.CI_PresentationFormCode.documentDigital</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_PresentationFormCode.documentHardcopy&quot; '>i18n.catalog.iso19139.CI_PresentationFormCode.documentHardcopy</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_PresentationFormCode.imageDigital&quot; '>i18n.catalog.iso19139.CI_PresentationFormCode.imageDigital</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_PresentationFormCode.imageHardcopy&quot; '>i18n.catalog.iso19139.CI_PresentationFormCode.imageHardcopy</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_PresentationFormCode.mapDigital&quot; '>i18n.catalog.iso19139.CI_PresentationFormCode.mapDigital</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_PresentationFormCode.mapHardcopy&quot; '>i18n.catalog.iso19139.CI_PresentationFormCode.mapHardcopy</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_PresentationFormCode.modelDigital&quot; '>i18n.catalog.iso19139.CI_PresentationFormCode.modelDigital</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_PresentationFormCode.modelHardcopy&quot; '>i18n.catalog.iso19139.CI_PresentationFormCode.modelHardcopy</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_PresentationFormCode.profileDigital&quot; '>i18n.catalog.iso19139.CI_PresentationFormCode.profileDigital</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_PresentationFormCode.profileHardcopy&quot; '>i18n.catalog.iso19139.CI_PresentationFormCode.profileHardcopy</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_PresentationFormCode.tableDigital&quot; '>i18n.catalog.iso19139.CI_PresentationFormCode.tableDigital</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_PresentationFormCode.tableHardcopy&quot; '>i18n.catalog.iso19139.CI_PresentationFormCode.tableHardcopy</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_PresentationFormCode.videoDigital&quot; '>i18n.catalog.iso19139.CI_PresentationFormCode.videoDigital</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_PresentationFormCode.videoHardcopy&quot; '>i18n.catalog.iso19139.CI_PresentationFormCode.videoHardcopy</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_ResponsibleParty&quot; '>i18n.catalog.iso19139.CI_ResponsibleParty</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_ResponsibleParty.contactInfo&quot; '>i18n.catalog.iso19139.CI_ResponsibleParty.contactInfo</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_ResponsibleParty.individualName&quot; '>i18n.catalog.iso19139.CI_ResponsibleParty.individualName</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_ResponsibleParty.organisationName&quot; '>i18n.catalog.schedaMetadati.NomeEnte</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_ResponsibleParty.positionIn&quot; '>i18n.catalog.iso19139.CI_ResponsibleParty.positionIn</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_ResponsibleParty.positionName&quot; '>i18n.catalog.iso19139.CI_ResponsibleParty.positionName</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_ResponsibleParty.referName&quot; '>i18n.catalog.iso19139.CI_ResponsibleParty.referName</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_ResponsibleParty.role&quot; '>i18n.catalog.iso19139.CI_ResponsibleParty.role</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_RoleCode&quot; '>i18n.catalog.iso19139.CI_RoleCode</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_RoleCode.author&quot; '>i18n.catalog.iso19139.CI_RoleCode.author</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_RoleCode.caption&quot; '>i18n.catalog.iso19139.CI_RoleCode.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_RoleCode.custodian&quot; '>i18n.catalog.iso19139.CI_RoleCode.custodian</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_RoleCode.distributor&quot; '>i18n.catalog.iso19139.CI_RoleCode.distributor</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_RoleCode.originator&quot; '>i18n.catalog.iso19139.CI_RoleCode.originator</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_RoleCode.owner&quot; '>i18n.catalog.iso19139.CI_RoleCode.owner</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_RoleCode.pointOfContact&quot; '>i18n.catalog.iso19139.CI_RoleCode.pointOfContact</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_RoleCode.principalInvestigator&quot; '>i18n.catalog.iso19139.CI_RoleCode.principalInvestigator</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_RoleCode.processor&quot; '>i18n.catalog.iso19139.CI_RoleCode.processor</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_RoleCode.publisher&quot; '>i18n.catalog.iso19139.CI_RoleCode.publisher</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_RoleCode.resourceProvider&quot; '>i18n.catalog.iso19139.CI_RoleCode.resourceProvider</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_RoleCode.user&quot; '>i18n.catalog.iso19139.CI_RoleCode.user</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_Series&quot; '>i18n.catalog.iso19139.CI_Series</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_Series.issueIdentification&quot; '>i18n.catalog.iso19139.CI_Series.issueIdentification</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_Series.name&quot; '>i18n.catalog.iso19139.CI_Series.name</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_Series.page&quot; '>i18n.catalog.iso19139.CI_Series.page</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_Telephone&quot; '>i18n.catalog.iso19139.CI_Telephone</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_Telephone.facsimile&quot; '>i18n.catalog.iso19139.CI_Telephone.facsimile</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.CI_Telephone.voice&quot; '>i18n.catalog.iso19139.CI_Telephone.voice</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DCPList&quot; '>i18n.catalog.iso19139.DCPList</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DCPList.COM&quot; '>i18n.catalog.iso19139.DCPList.COM</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DCPList.CORBA&quot; '>i18n.catalog.iso19139.DCPList.CORBA</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DCPList.JAVA&quot; '>i18n.catalog.iso19139.DCPList.JAVA</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DCPList.SQL&quot; '>i18n.catalog.iso19139.DCPList.SQL</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DCPList.WebServices&quot; '>i18n.catalog.iso19139.DCPList.WebServices</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DCPList.XML&quot; '>i18n.catalog.iso19139.DCPList.XML</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DQ_AbsoluteExternalPositionalAccuracy&quot; '>i18n.catalog.iso19139.DQ_AbsoluteExternalPositionalAccuracy</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DQ_AccuracyOfATimeMeasurement&quot; '>i18n.catalog.iso19139.DQ_AccuracyOfATimeMeasurement</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DQ_CompletenessCommission&quot; '>i18n.catalog.iso19139.DQ_CompletenessCommission</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DQ_CompletenessOmission&quot; '>i18n.catalog.iso19139.DQ_CompletenessOmission</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DQ_ConceptualConsistency&quot; '>i18n.catalog.iso19139.DQ_ConceptualConsistency</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DQ_ConformanceResult&quot; '>i18n.catalog.schedaMetadati.Conformita</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DQ_ConformanceResult.explanation&quot; '>i18n.catalog.iso19139.DQ_ConformanceResult.explanation</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DQ_ConformanceResult.pass&quot; '>i18n.catalog.iso19139.DQ_ConformanceResult.pass</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DQ_ConformanceResult.pass.Boolean&quot; '>i18n.catalog.schedaMetadati.gradoConformita</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DQ_ConformanceResult.pass.Boolean.false&quot; '>i18n.catalog.iso19139.DQ_ConformanceResult.pass.Boolean.false</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DQ_ConformanceResult.pass.Boolean.true&quot; '>i18n.catalog.iso19139.DQ_ConformanceResult.pass.Boolean.true</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DQ_ConformanceResult.specification&quot; '>i18n.catalog.iso19139.DQ_ConformanceResult.specification</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DQ_DataQuality&quot; '>i18n.catalog.iso19139.DQ_DataQuality</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DQ_DataQuality.lineage&quot; '>i18n.catalog.iso19139.DQ_DataQuality.lineage</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DQ_DataQuality.report&quot; '>i18n.catalog.iso19139.DQ_DataQuality.report</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DQ_DataQuality.scope&quot; '>i18n.catalog.iso19139.DQ_DataQuality.scope</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DQ_DomainConsistency&quot; '>i18n.catalog.iso19139.DQ_DomainConsistency</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DQ_FormatConsistency&quot; '>i18n.catalog.iso19139.DQ_FormatConsistency</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DQ_GriddedDataPositionalAccuracy&quot; '>i18n.catalog.iso19139.DQ_GriddedDataPositionalAccuracy</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DQ_NonQuantitiveAttributeAccuracy&quot; '>i18n.catalog.iso19139.DQ_NonQuantitiveAttributeAccuracy</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DQ_QuantitativeAttributeAccuracy&quot; '>i18n.catalog.iso19139.DQ_QuantitativeAttributeAccuracy</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DQ_QuantitativeResult&quot; '>i18n.catalog.iso19139.DQ_QuantitativeResult</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DQ_QuantitativeResult.errorStatistic&quot; '>i18n.catalog.iso19139.DQ_QuantitativeResult.errorStatistic</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DQ_QuantitativeResult.value&quot; '>i18n.catalog.iso19139.DQ_QuantitativeResult.value</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DQ_QuantitativeResult.valueType&quot; '>i18n.catalog.iso19139.DQ_QuantitativeResult.valueType</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DQ_QuantitativeResult.valueUnit&quot; '>i18n.catalog.iso19139.DQ_QuantitativeResult.valueUnit</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DQ_RelativeInternalPositionalAccuracy&quot; '>i18n.catalog.iso19139.DQ_RelativeInternalPositionalAccuracy</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DQ_Scope&quot; '>i18n.catalog.iso19139.DQ_Scope</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DQ_Scope.extent&quot; '>i18n.catalog.iso19139.DQ_Scope.extent</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DQ_Scope.level&quot; '>i18n.catalog.iso19139.DQ_Scope.level</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DQ_Scope.levelDescription&quot; '>i18n.catalog.iso19139.DQ_Scope.levelDescription</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DQ_TemporalAccuracy&quot; '>i18n.catalog.iso19139.DQ_TemporalAccuracy</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DQ_TemporalConsistency&quot; '>i18n.catalog.iso19139.DQ_TemporalConsistency</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DQ_TemporalValidity&quot; '>i18n.catalog.iso19139.DQ_TemporalValidity</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DQ_ThematicAccuracy&quot; '>i18n.catalog.iso19139.DQ_ThematicAccuracy</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DQ_ThematicClassificationCorrectness&quot; '>i18n.catalog.iso19139.DQ_ThematicClassificationCorrectness</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DQ_TopologicalConsistency&quot; '>i18n.catalog.iso19139.DQ_TopologicalConsistency</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DS_Association&quot; '>i18n.catalog.iso19139.DS_Association</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DS_AssociationTypeCode&quot; '>i18n.catalog.iso19139.DS_AssociationTypeCode</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DS_AssociationTypeCode.crossReference&quot; '>i18n.catalog.iso19139.DS_AssociationTypeCode.crossReference</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DS_AssociationTypeCode.largerWorkCitation&quot; '>i18n.catalog.iso19139.DS_AssociationTypeCode.largerWorkCitation</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DS_AssociationTypeCode.partOfSeamlessDatabase&quot; '>i18n.catalog.iso19139.DS_AssociationTypeCode.partOfSeamlessDatabase</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DS_AssociationTypeCode.source&quot; '>i18n.catalog.iso19139.DS_AssociationTypeCode.source</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DS_AssociationTypeCode.stereoMate&quot; '>i18n.catalog.iso19139.DS_AssociationTypeCode.stereoMate</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DS_DataSet&quot; '>i18n.catalog.iso19139.DS_DataSet</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DS_DataSet.has&quot; '>i18n.catalog.iso19139.DS_DataSet.has</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DS_DataSet.partOf&quot; '>i18n.catalog.iso19139.DS_DataSet.partOf</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DS_InitiativeTypeCode&quot; '>i18n.catalog.iso19139.DS_InitiativeTypeCode</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DS_InitiativeTypeCode.campaign&quot; '>i18n.catalog.iso19139.DS_InitiativeTypeCode.campaign</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DS_InitiativeTypeCode.collection&quot; '>i18n.catalog.iso19139.DS_InitiativeTypeCode.collection</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DS_InitiativeTypeCode.exercise&quot; '>i18n.catalog.iso19139.DS_InitiativeTypeCode.exercise</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DS_InitiativeTypeCode.experiment&quot; '>i18n.catalog.iso19139.DS_InitiativeTypeCode.experiment</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DS_InitiativeTypeCode.investigation&quot; '>i18n.catalog.iso19139.DS_InitiativeTypeCode.investigation</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DS_InitiativeTypeCode.mission&quot; '>i18n.catalog.iso19139.DS_InitiativeTypeCode.mission</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DS_InitiativeTypeCode.operation&quot; '>i18n.catalog.iso19139.DS_InitiativeTypeCode.operation</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DS_InitiativeTypeCode.platform&quot; '>i18n.catalog.iso19139.DS_InitiativeTypeCode.platform</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DS_InitiativeTypeCode.process&quot; '>i18n.catalog.iso19139.DS_InitiativeTypeCode.process</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DS_InitiativeTypeCode.program&quot; '>i18n.catalog.iso19139.DS_InitiativeTypeCode.program</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DS_InitiativeTypeCode.project&quot; '>i18n.catalog.iso19139.DS_InitiativeTypeCode.project</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DS_InitiativeTypeCode.sensor&quot; '>i18n.catalog.iso19139.DS_InitiativeTypeCode.sensor</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DS_InitiativeTypeCode.study&quot; '>i18n.catalog.iso19139.DS_InitiativeTypeCode.study</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DS_InitiativeTypeCode.task&quot; '>i18n.catalog.iso19139.DS_InitiativeTypeCode.task</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.DS_InitiativeTypeCode.trial&quot; '>i18n.catalog.iso19139.DS_InitiativeTypeCode.trial</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.EX_Extent&quot; '>i18n.catalog.iso19139.EX_Extent</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.EX_Extent.description&quot; '>i18n.catalog.iso19139.EX_Extent.description</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.EX_Extent.geographicElement&quot; '>i18n.catalog.iso19139.EX_Extent.geographicElement</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.EX_Extent.temporalElement&quot; '>i18n.catalog.iso19139.EX_Extent.temporalElement</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.EX_Extent.verticalElement&quot; '>i18n.catalog.iso19139.EX_Extent.verticalElement</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.EX_GeographicBoundingBox&quot; '>i18n.catalog.iso19139.EX_GeographicBoundingBox</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.EX_GeographicBoundingBox.eastBoundLongitude&quot; '>i18n.catalog.iso19139.EX_GeographicBoundingBox.eastBoundLongitude</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.EX_GeographicBoundingBox.northBoundLatitude&quot; '>i18n.catalog.iso19139.EX_GeographicBoundingBox.northBoundLatitude</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.EX_GeographicBoundingBox.southBoundLatitude&quot; '>i18n.catalog.iso19139.EX_GeographicBoundingBox.southBoundLatitude</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.EX_GeographicBoundingBox.westBoundLongitude&quot; '>i18n.catalog.iso19139.EX_GeographicBoundingBox.westBoundLongitude</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.EX_GeographicDescription&quot; '>i18n.catalog.iso19139.EX_GeographicDescription</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.EX_GeographicDescription.geographicIdentifier&quot; '>i18n.catalog.iso19139.EX_GeographicDescription.geographicIdentifier</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.EX_GeographicExtent&quot; '>i18n.catalog.iso19139.EX_GeographicExtent</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.EX_TemporalExtent&quot; '>i18n.catalog.iso19139.EX_TemporalExtent</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.EX_TemporalExtent.beginPosition&quot; '>i18n.catalog.iso19139.EX_TemporalExtent.beginPosition</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.EX_TemporalExtent.endPosition&quot; '>i18n.catalog.iso19139.EX_TemporalExtent.endPosition</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.EX_TemporalExtent.extent&quot; '>i18n.catalog.iso19139.EX_TemporalExtent.extent</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.EX_VerticalExtent&quot; '>i18n.catalog.iso19139.EX_VerticalExtent</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.EX_VerticalExtent.maximumValue&quot; '>i18n.catalog.iso19139.EX_VerticalExtent.maximumValue</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.EX_VerticalExtent.minimumValue&quot; '>i18n.catalog.iso19139.EX_VerticalExtent.minimumValue</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.EX_VerticalExtent.verticalCRS&quot; '>i18n.catalog.iso19139.EX_VerticalExtent.verticalCRS</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.EX_VerticalExtent.verticalCRS.href&quot; '>i18n.catalog.iso19139.EX_VerticalExtent.verticalCRS.href</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.gco.CodeListValue.codeList&quot; '>i18n.catalog.iso19139.gco.CodeListValue.codeList</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.gco.CodeListValue.codeListValue&quot; '>i18n.catalog.iso19139.gco.CodeListValue.codeListValue</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.gco.CodeListValue.codeSpace&quot; '>i18n.catalog.iso19139.gco.CodeListValue.codeSpace</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.gco.ObjectIdentification.id&quot; '>i18n.catalog.iso19139.gco.ObjectIdentification.id</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.gco.ObjectIdentification.uuid&quot; '>i18n.catalog.iso19139.gco.ObjectIdentification.uuid</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.gco.ObjectReference.uuidref&quot; '>i18n.catalog.iso19139.gco.ObjectReference.uuidref</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.Length&quot; '>i18n.catalog.iso19139.Length</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.Length.ft&quot; '>i18n.catalog.iso19139.Length.ft</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.Length.km&quot; '>i18n.catalog.iso19139.Length.km</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.Length.m&quot; '>i18n.catalog.iso19139.Length.m</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.Length.mi&quot; '>i18n.catalog.iso19139.Length.mi</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.Length.uom&quot; '>i18n.catalog.iso19139.Length.uom</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.LI_Lineage&quot; '>i18n.catalog.iso19139.LI_Lineage</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.LI_Lineage.processStep&quot; '>i18n.catalog.iso19139.LI_Lineage.processStep</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.LI_Lineage.source&quot; '>i18n.catalog.iso19139.LI_Lineage.source</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.LI_Lineage.statement&quot; '>i18n.catalog.iso19139.LI_Lineage.statement</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.LI_ProcessStep&quot; '>i18n.catalog.iso19139.LI_ProcessStep</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.LI_ProcessStep.dateTime&quot; '>i18n.catalog.iso19139.LI_ProcessStep.dateTime</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.LI_ProcessStep.description&quot; '>i18n.catalog.iso19139.LI_ProcessStep.description</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.LI_ProcessStep.processor&quot; '>i18n.catalog.iso19139.LI_ProcessStep.processor</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.LI_ProcessStep.rationale&quot; '>i18n.catalog.iso19139.LI_ProcessStep.rationale</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.LI_ProcessStep.source&quot; '>i18n.catalog.iso19139.LI_ProcessStep.source</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.LI_Source&quot; '>i18n.catalog.iso19139.LI_Source</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.LI_Source.description&quot; '>i18n.catalog.iso19139.LI_Source.description</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.LI_Source.scaleDenominator&quot; '>i18n.catalog.iso19139.LI_Source.scaleDenominator</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.LI_Source.sourceCitation&quot; '>i18n.catalog.iso19139.LI_Source.sourceCitation</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.LI_Source.sourceExtent&quot; '>i18n.catalog.iso19139.LI_Source.sourceExtent</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.LI_Source.sourceReferenceSystem&quot; '>i18n.catalog.iso19139.LI_Source.sourceReferenceSystem</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.LI_Source.sourceStep&quot; '>i18n.catalog.iso19139.LI_Source.sourceStep</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.LocalisedCharacterString&quot; '>i18n.catalog.iso19139.LocalisedCharacterString</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.LocalisedCharacterString.id&quot; '>i18n.catalog.iso19139.LocalisedCharacterString.id</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.LocalisedCharacterString.locale&quot; '>i18n.catalog.iso19139.LocalisedCharacterString.locale</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.LocalisedCharacterString.textNode&quot; '>i18n.catalog.iso19139.LocalisedCharacterString.textNode</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_AggregateInformation&quot; '>i18n.catalog.iso19139.MD_AggregateInformation</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_AggregateInformation.aggregateDataSetIdentifier&quot; '>i18n.catalog.iso19139.MD_AggregateInformation.aggregateDataSetIdentifier</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_AggregateInformation.aggregateDataSetName&quot; '>i18n.catalog.iso19139.MD_AggregateInformation.aggregateDataSetName</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_AggregateInformation.associationType&quot; '>i18n.catalog.iso19139.MD_AggregateInformation.associationType</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_AggregateInformation.initiativeType&quot; '>i18n.catalog.iso19139.MD_AggregateInformation.initiativeType</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ApplicationSchemaInformation&quot; '>i18n.catalog.iso19139.MD_ApplicationSchemaInformation</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ApplicationSchemaInformation.constraintLanguage&quot; '>i18n.catalog.iso19139.MD_ApplicationSchemaInformation.constraintLanguage</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ApplicationSchemaInformation.graphicsFile&quot; '>i18n.catalog.iso19139.MD_ApplicationSchemaInformation.graphicsFile</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ApplicationSchemaInformation.name&quot; '>i18n.catalog.iso19139.MD_ApplicationSchemaInformation.name</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ApplicationSchemaInformation.schemaAscii&quot; '>i18n.catalog.iso19139.MD_ApplicationSchemaInformation.schemaAscii</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ApplicationSchemaInformation.schemaLanguage&quot; '>i18n.catalog.iso19139.MD_ApplicationSchemaInformation.schemaLanguage</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ApplicationSchemaInformation.softwareDevelopmentFile&quot; '>i18n.catalog.iso19139.MD_ApplicationSchemaInformation.softwareDevelopmentFile</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ApplicationSchemaInformation.softwareDevelopmentFileFormat&quot; '>i18n.catalog.iso19139.MD_ApplicationSchemaInformation.softwareDevelopmentFileFormat</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Band&quot; '>i18n.catalog.iso19139.MD_Band</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Band.bitsPerValue&quot; '>i18n.catalog.iso19139.MD_Band.bitsPerValue</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Band.descriptor&quot; '>i18n.catalog.iso19139.MD_Band.descriptor</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Band.maxValue&quot; '>i18n.catalog.iso19139.MD_Band.maxValue</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Band.minValue&quot; '>i18n.catalog.iso19139.MD_Band.minValue</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Band.offset&quot; '>i18n.catalog.iso19139.MD_Band.offset</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Band.peakResponse&quot; '>i18n.catalog.iso19139.MD_Band.peakResponse</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Band.scaleFactor&quot; '>i18n.catalog.iso19139.MD_Band.scaleFactor</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Band.sequenceIdentifier&quot; '>i18n.catalog.iso19139.MD_Band.sequenceIdentifier</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Band.toneGradation&quot; '>i18n.catalog.iso19139.MD_Band.toneGradation</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Band.units&quot; '>i18n.catalog.iso19139.MD_Band.units</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_BrowseGraphic&quot; '>i18n.catalog.iso19139.MD_BrowseGraphic</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_BrowseGraphic.fileDescription&quot; '>i18n.catalog.iso19139.MD_BrowseGraphic.fileDescription</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_BrowseGraphic.fileName&quot; '>i18n.catalog.iso19139.MD_BrowseGraphic.fileName</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_BrowseGraphic.fileType&quot; '>i18n.catalog.iso19139.MD_BrowseGraphic.fileType</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_CellGeometryCode&quot; '>i18n.catalog.iso19139.MD_CellGeometryCode</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_CellGeometryCode.area&quot; '>i18n.catalog.iso19139.MD_CellGeometryCode.area</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_CellGeometryCode.point&quot; '>i18n.catalog.iso19139.MD_CellGeometryCode.point</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_CharacterSetCode&quot; '>i18n.catalog.iso19139.MD_CharacterSetCode</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_CharacterSetCode.8859part1&quot; '>i18n.catalog.iso19139.MD_CharacterSetCode.8859part1</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_CharacterSetCode.8859part10&quot; '>i18n.catalog.iso19139.MD_CharacterSetCode.8859part10</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_CharacterSetCode.8859part11&quot; '>i18n.catalog.iso19139.MD_CharacterSetCode.8859part11</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_CharacterSetCode.8859part13&quot; '>i18n.catalog.iso19139.MD_CharacterSetCode.8859part13</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_CharacterSetCode.8859part14&quot; '>i18n.catalog.iso19139.MD_CharacterSetCode.8859part14</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_CharacterSetCode.8859part15&quot; '>i18n.catalog.iso19139.MD_CharacterSetCode.8859part15</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_CharacterSetCode.8859part16&quot; '>i18n.catalog.iso19139.MD_CharacterSetCode.8859part16</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_CharacterSetCode.8859part2&quot; '>i18n.catalog.iso19139.MD_CharacterSetCode.8859part2</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_CharacterSetCode.8859part3&quot; '>i18n.catalog.iso19139.MD_CharacterSetCode.8859part3</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_CharacterSetCode.8859part4&quot; '>i18n.catalog.iso19139.MD_CharacterSetCode.8859part4</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_CharacterSetCode.8859part5&quot; '>i18n.catalog.iso19139.MD_CharacterSetCode.8859part5</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_CharacterSetCode.8859part6&quot; '>i18n.catalog.iso19139.MD_CharacterSetCode.8859part6</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_CharacterSetCode.8859part7&quot; '>i18n.catalog.iso19139.MD_CharacterSetCode.8859part7</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_CharacterSetCode.8859part8&quot; '>i18n.catalog.iso19139.MD_CharacterSetCode.8859part8</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_CharacterSetCode.8859part9&quot; '>i18n.catalog.iso19139.MD_CharacterSetCode.8859part9</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_CharacterSetCode.big5&quot; '>i18n.catalog.iso19139.MD_CharacterSetCode.big5</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_CharacterSetCode.ebcdic&quot; '>i18n.catalog.iso19139.MD_CharacterSetCode.ebcdic</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_CharacterSetCode.eucJP&quot; '>i18n.catalog.iso19139.MD_CharacterSetCode.eucJP</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_CharacterSetCode.eucKR&quot; '>i18n.catalog.iso19139.MD_CharacterSetCode.eucKR</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_CharacterSetCode.GB2312&quot; '>i18n.catalog.iso19139.MD_CharacterSetCode.GB2312</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_CharacterSetCode.jis&quot; '>i18n.catalog.iso19139.MD_CharacterSetCode.jis</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_CharacterSetCode.shiftJIS&quot; '>i18n.catalog.iso19139.MD_CharacterSetCode.shiftJIS</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_CharacterSetCode.ucs2&quot; '>i18n.catalog.iso19139.MD_CharacterSetCode.ucs2</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_CharacterSetCode.ucs4&quot; '>i18n.catalog.iso19139.MD_CharacterSetCode.ucs4</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_CharacterSetCode.usAscii&quot; '>i18n.catalog.iso19139.MD_CharacterSetCode.usAscii</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_CharacterSetCode.utf16&quot; '>i18n.catalog.iso19139.MD_CharacterSetCode.utf16</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_CharacterSetCode.utf7&quot; '>i18n.catalog.iso19139.MD_CharacterSetCode.utf7</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_CharacterSetCode.utf8&quot; '>i18n.catalog.iso19139.MD_CharacterSetCode.utf8</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ClassificationCode&quot; '>i18n.catalog.iso19139.MD_ClassificationCode</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ClassificationCode.confidential&quot; '>i18n.catalog.iso19139.MD_ClassificationCode.confidential</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ClassificationCode.restricted&quot; '>i18n.catalog.iso19139.MD_ClassificationCode.restricted</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ClassificationCode.secret&quot; '>i18n.catalog.iso19139.MD_ClassificationCode.secret</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ClassificationCode.topSecret&quot; '>i18n.catalog.iso19139.MD_ClassificationCode.topSecret</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ClassificationCode.unclassified&quot; '>i18n.catalog.iso19139.MD_ClassificationCode.unclassified</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Constraints&quot; '>i18n.catalog.iso19139.MD_Constraints</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Constraints.useLimitation&quot; '>i18n.catalog.schedaMetadati.limitazioneUso</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_CoverageContentTypeCode&quot; '>i18n.catalog.iso19139.MD_CoverageContentTypeCode</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_CoverageContentTypeCode.image&quot; '>i18n.catalog.iso19139.MD_CoverageContentTypeCode.image</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_CoverageContentTypeCode.physicalMeasurement&quot; '>i18n.catalog.iso19139.MD_CoverageContentTypeCode.physicalMeasurement</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_CoverageContentTypeCode.thematicClassification&quot; '>i18n.catalog.iso19139.MD_CoverageContentTypeCode.thematicClassification</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_CoverageDescription&quot; '>i18n.catalog.iso19139.MD_CoverageDescription</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_CoverageDescription.attributeDescription&quot; '>i18n.catalog.iso19139.MD_CoverageDescription.attributeDescription</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_CoverageDescription.contentType&quot; '>i18n.catalog.iso19139.MD_CoverageDescription.contentType</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_CoverageDescription.dimension&quot; '>i18n.catalog.iso19139.MD_CoverageDescription.dimension</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_DataIdentification&quot; '>i18n.catalog.iso19139.MD_DataIdentification</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_DataIdentification.characterSet&quot; '>i18n.catalog.iso19139.MD_DataIdentification.characterSet</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_DataIdentification.environmentDescription&quot; '>i18n.catalog.iso19139.MD_DataIdentification.environmentDescription</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_DataIdentification.extent&quot; '>i18n.catalog.iso19139.MD_DataIdentification.extent</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_DataIdentification.language&quot; '>i18n.catalog.iso19139.MD_DataIdentification.language</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_DataIdentification.spatialRepresentationType&quot; '>i18n.catalog.iso19139.MD_DataIdentification.spatialRepresentationType</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_DataIdentification.spatialResolution&quot; '>i18n.catalog.iso19139.MD_DataIdentification.spatialResolution</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_DataIdentification.supplementalInformation&quot; '>i18n.catalog.iso19139.MD_DataIdentification.supplementalInformation</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_DataIdentification.topicCategory&quot; '>i18n.catalog.iso19139.MD_DataIdentification.topicCategory</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_DatatypeCode&quot; '>i18n.catalog.iso19139.MD_DatatypeCode</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_DatatypeCode.abstractClass&quot; '>i18n.catalog.iso19139.MD_DatatypeCode.abstractClass</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_DatatypeCode.aggregateClass&quot; '>i18n.catalog.iso19139.MD_DatatypeCode.aggregateClass</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_DatatypeCode.association&quot; '>i18n.catalog.iso19139.MD_DatatypeCode.association</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_DatatypeCode.characterString&quot; '>i18n.catalog.iso19139.MD_DatatypeCode.characterString</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_DatatypeCode.class&quot; '>i18n.catalog.iso19139.MD_DatatypeCode.class</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_DatatypeCode.codelist&quot; '>i18n.catalog.iso19139.MD_DatatypeCode.codelist</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_DatatypeCode.codelistElement&quot; '>i18n.catalog.iso19139.MD_DatatypeCode.codelistElement</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_DatatypeCode.datatypeClass&quot; '>i18n.catalog.iso19139.MD_DatatypeCode.datatypeClass</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_DatatypeCode.enumeration&quot; '>i18n.catalog.iso19139.MD_DatatypeCode.enumeration</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_DatatypeCode.integer&quot; '>i18n.catalog.iso19139.MD_DatatypeCode.integer</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_DatatypeCode.interfaceClass&quot; '>i18n.catalog.iso19139.MD_DatatypeCode.interfaceClass</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_DatatypeCode.metaClass&quot; '>i18n.catalog.iso19139.MD_DatatypeCode.metaClass</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_DatatypeCode.specifiedClass&quot; '>i18n.catalog.iso19139.MD_DatatypeCode.specifiedClass</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_DatatypeCode.typeClass&quot; '>i18n.catalog.iso19139.MD_DatatypeCode.typeClass</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_DatatypeCode.unionClass&quot; '>i18n.catalog.iso19139.MD_DatatypeCode.unionClass</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_DigitalTransferOptions&quot; '>i18n.catalog.iso19139.MD_DigitalTransferOptions</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_DigitalTransferOptions.offLine&quot; '>i18n.catalog.iso19139.MD_DigitalTransferOptions.offLine</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_DigitalTransferOptions.onLine&quot; '>i18n.catalog.iso19139.MD_DigitalTransferOptions.onLine</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_DigitalTransferOptions.transferSize&quot; '>i18n.catalog.iso19139.MD_DigitalTransferOptions.transferSize</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_DigitalTransferOptions.unitsOfDistribution&quot; '>i18n.catalog.iso19139.MD_DigitalTransferOptions.unitsOfDistribution</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Dimension&quot; '>i18n.catalog.iso19139.MD_Dimension</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Dimension.dimensionName&quot; '>i18n.catalog.iso19139.MD_Dimension.dimensionName</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Dimension.dimensionSize&quot; '>i18n.catalog.iso19139.MD_Dimension.dimensionSize</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Dimension.resolution&quot; '>i18n.catalog.iso19139.MD_Dimension.resolution</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_DimensionNameTypeCode&quot; '>i18n.catalog.iso19139.MD_DimensionNameTypeCode</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_DimensionNameTypeCode.column&quot; '>i18n.catalog.iso19139.MD_DimensionNameTypeCode.column</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_DimensionNameTypeCode.crossTrack&quot; '>i18n.catalog.iso19139.MD_DimensionNameTypeCode.crossTrack</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_DimensionNameTypeCode.line&quot; '>i18n.catalog.iso19139.MD_DimensionNameTypeCode.line</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_DimensionNameTypeCode.row&quot; '>i18n.catalog.iso19139.MD_DimensionNameTypeCode.row</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_DimensionNameTypeCode.sample&quot; '>i18n.catalog.iso19139.MD_DimensionNameTypeCode.sample</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_DimensionNameTypeCode.time&quot; '>i18n.catalog.iso19139.MD_DimensionNameTypeCode.time</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_DimensionNameTypeCode.track&quot; '>i18n.catalog.iso19139.MD_DimensionNameTypeCode.track</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_DimensionNameTypeCode.vertical&quot; '>i18n.catalog.iso19139.MD_DimensionNameTypeCode.vertical</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Distribution&quot; '>i18n.catalog.iso19139.MD_Distribution</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Distribution.distributionFormat&quot; '>i18n.catalog.iso19139.MD_Distribution.distributionFormat</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Distribution.distributor&quot; '>i18n.catalog.iso19139.MD_Distribution.distributor</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Distribution.transferOptions&quot; '>i18n.catalog.iso19139.MD_Distribution.transferOptions</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_DistributionUnits&quot; '>i18n.catalog.iso19139.MD_DistributionUnits</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Distributor&quot; '>i18n.catalog.iso19139.MD_Distributor</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Distributor.distributionOrderProcess&quot; '>i18n.catalog.iso19139.MD_Distributor.distributionOrderProcess</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Distributor.distributorContact&quot; '>i18n.catalog.iso19139.MD_Distributor.distributorContact</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Distributor.distributorFormat&quot; '>i18n.catalog.iso19139.MD_Distributor.distributorFormat</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Distributor.distributorTransferOptions&quot; '>i18n.catalog.iso19139.MD_Distributor.distributorTransferOptions</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ExtendedElementInformation&quot; '>i18n.catalog.iso19139.MD_ExtendedElementInformation</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ExtendedElementInformation.condition&quot; '>i18n.catalog.iso19139.MD_ExtendedElementInformation.condition</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ExtendedElementInformation.dataType&quot; '>i18n.catalog.iso19139.MD_ExtendedElementInformation.dataType</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ExtendedElementInformation.definition&quot; '>i18n.catalog.iso19139.MD_ExtendedElementInformation.definition</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ExtendedElementInformation.domainCode&quot; '>i18n.catalog.iso19139.MD_ExtendedElementInformation.domainCode</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ExtendedElementInformation.domainValue&quot; '>i18n.catalog.iso19139.MD_ExtendedElementInformation.domainValue</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ExtendedElementInformation.maximumOccurrence&quot; '>i18n.catalog.iso19139.MD_ExtendedElementInformation.maximumOccurrence</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ExtendedElementInformation.name&quot; '>i18n.catalog.iso19139.MD_ExtendedElementInformation.name</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ExtendedElementInformation.obligation&quot; '>i18n.catalog.iso19139.MD_ExtendedElementInformation.obligation</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ExtendedElementInformation.parentEntity&quot; '>i18n.catalog.iso19139.MD_ExtendedElementInformation.parentEntity</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ExtendedElementInformation.rationale&quot; '>i18n.catalog.iso19139.MD_ExtendedElementInformation.rationale</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ExtendedElementInformation.rule&quot; '>i18n.catalog.iso19139.MD_ExtendedElementInformation.rule</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ExtendedElementInformation.shortName&quot; '>i18n.catalog.iso19139.MD_ExtendedElementInformation.shortName</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ExtendedElementInformation.source&quot; '>i18n.catalog.iso19139.MD_ExtendedElementInformation.source</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_FeatureCatalogueDescription&quot; '>i18n.catalog.iso19139.MD_FeatureCatalogueDescription</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_FeatureCatalogueDescription.complianceCode&quot; '>i18n.catalog.iso19139.MD_FeatureCatalogueDescription.complianceCode</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_FeatureCatalogueDescription.featureCatalogueCitation&quot; '>i18n.catalog.iso19139.MD_FeatureCatalogueDescription.featureCatalogueCitation</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_FeatureCatalogueDescription.featureTypes&quot; '>i18n.catalog.iso19139.MD_FeatureCatalogueDescription.featureTypes</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_FeatureCatalogueDescription.includedWithDataset&quot; '>i18n.catalog.iso19139.MD_FeatureCatalogueDescription.includedWithDataset</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_FeatureCatalogueDescription.language&quot; '>i18n.catalog.iso19139.MD_FeatureCatalogueDescription.language</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Format&quot; '>i18n.catalog.iso19139.MD_Format</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Format.amendmentNumber&quot; '>i18n.catalog.iso19139.MD_Format.amendmentNumber</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Format.fileDecompressionTechnique&quot; '>i18n.catalog.iso19139.MD_Format.fileDecompressionTechnique</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Format.formatDistributor&quot; '>i18n.catalog.iso19139.MD_Format.formatDistributor</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Format.name&quot; '>i18n.catalog.iso19139.MD_Format.name</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Format.specification&quot; '>i18n.catalog.iso19139.MD_Format.specification</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Format.version&quot; '>i18n.catalog.iso19139.MD_Format.version</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_GeometricObjects&quot; '>i18n.catalog.iso19139.MD_GeometricObjects</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_GeometricObjects.geometricObjectCount&quot; '>i18n.catalog.iso19139.MD_GeometricObjects.geometricObjectCount</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_GeometricObjects.geometricObjectType&quot; '>i18n.catalog.iso19139.MD_GeometricObjects.geometricObjectType</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_GeometricObjectTypeCode&quot; '>i18n.catalog.iso19139.MD_GeometricObjectTypeCode</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_GeometricObjectTypeCode.complex&quot; '>i18n.catalog.iso19139.MD_GeometricObjectTypeCode.complex</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_GeometricObjectTypeCode.composite&quot; '>i18n.catalog.iso19139.MD_GeometricObjectTypeCode.composite</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_GeometricObjectTypeCode.curve&quot; '>i18n.catalog.iso19139.MD_GeometricObjectTypeCode.curve</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_GeometricObjectTypeCode.point&quot; '>i18n.catalog.iso19139.MD_GeometricObjectTypeCode.point</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_GeometricObjectTypeCode.solid&quot; '>i18n.catalog.iso19139.MD_GeometricObjectTypeCode.solid</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_GeometricObjectTypeCode.surface&quot; '>i18n.catalog.iso19139.MD_GeometricObjectTypeCode.surface</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Georectified&quot; '>i18n.catalog.iso19139.MD_Georectified</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Georectified.centerPoint&quot; '>i18n.catalog.iso19139.MD_Georectified.centerPoint</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Georectified.checkPointAvailability&quot; '>i18n.catalog.iso19139.MD_Georectified.checkPointAvailability</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Georectified.checkPointDescription&quot; '>i18n.catalog.iso19139.MD_Georectified.checkPointDescription</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Georectified.cornerPoints&quot; '>i18n.catalog.iso19139.MD_Georectified.cornerPoints</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Georectified.pointInPixel&quot; '>i18n.catalog.iso19139.MD_Georectified.pointInPixel</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Georectified.transformationDimensionDescription&quot; '>i18n.catalog.iso19139.MD_Georectified.transformationDimensionDescription</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Georectified.transformationDimensionMapping&quot; '>i18n.catalog.iso19139.MD_Georectified.transformationDimensionMapping</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Georeferenceable&quot; '>i18n.catalog.iso19139.MD_Georeferenceable</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Georeferenceable.controlPointAvailability&quot; '>i18n.catalog.iso19139.MD_Georeferenceable.controlPointAvailability</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Georeferenceable.georeferencedParameters&quot; '>i18n.catalog.iso19139.MD_Georeferenceable.georeferencedParameters</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Georeferenceable.orientationParameterAvailability&quot; '>i18n.catalog.iso19139.MD_Georeferenceable.orientationParameterAvailability</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Georeferenceable.orientationParameterDescription&quot; '>i18n.catalog.iso19139.MD_Georeferenceable.orientationParameterDescription</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Georeferenceable.parameterCitation&quot; '>i18n.catalog.iso19139.MD_Georeferenceable.parameterCitation</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_GridSpatialRepresentation&quot; '>i18n.catalog.iso19139.MD_GridSpatialRepresentation</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_GridSpatialRepresentation.axisDimensionProperties&quot; '>i18n.catalog.iso19139.MD_GridSpatialRepresentation.axisDimensionProperties</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_GridSpatialRepresentation.cellGeometry&quot; '>i18n.catalog.iso19139.MD_GridSpatialRepresentation.cellGeometry</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_GridSpatialRepresentation.numberOfDimensions&quot; '>i18n.catalog.iso19139.MD_GridSpatialRepresentation.numberOfDimensions</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_GridSpatialRepresentation.transformationParameterAvailability&quot; '>i18n.catalog.iso19139.MD_GridSpatialRepresentation.transformationParameterAvailability</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Identifier&quot; '>i18n.catalog.iso19139.MD_Identifier</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Identifier.authority&quot; '>i18n.catalog.iso19139.MD_Identifier.authority</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Identifier.code&quot; '>i18n.catalog.iso19139.MD_Identifier.code</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ImageDescription&quot; '>i18n.catalog.iso19139.MD_ImageDescription</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ImageDescription.attributeDescription&quot; '>i18n.catalog.iso19139.MD_ImageDescription.attributeDescription</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ImageDescription.cameraCalibrationInformationAvailability&quot; '>i18n.catalog.iso19139.MD_ImageDescription.cameraCalibrationInformationAvailability</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ImageDescription.cloudCoverPercentage&quot; '>i18n.catalog.iso19139.MD_ImageDescription.cloudCoverPercentage</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ImageDescription.compressionGenerationQuantity&quot; '>i18n.catalog.iso19139.MD_ImageDescription.compressionGenerationQuantity</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ImageDescription.contentType&quot; '>i18n.catalog.iso19139.MD_ImageDescription.contentType</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ImageDescription.dimension&quot; '>i18n.catalog.iso19139.MD_ImageDescription.dimension</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ImageDescription.filmDistortionInformationAvailability&quot; '>i18n.catalog.iso19139.MD_ImageDescription.filmDistortionInformationAvailability</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ImageDescription.illuminationAzimuthAngle&quot; '>i18n.catalog.iso19139.MD_ImageDescription.illuminationAzimuthAngle</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ImageDescription.illuminationElevationAngle&quot; '>i18n.catalog.iso19139.MD_ImageDescription.illuminationElevationAngle</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ImageDescription.imageQualityCode&quot; '>i18n.catalog.iso19139.MD_ImageDescription.imageQualityCode</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ImageDescription.imagingCondition&quot; '>i18n.catalog.iso19139.MD_ImageDescription.imagingCondition</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ImageDescription.lensDistortionInformationAvailability&quot; '>i18n.catalog.iso19139.MD_ImageDescription.lensDistortionInformationAvailability</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ImageDescription.processingLevelCode&quot; '>i18n.catalog.iso19139.MD_ImageDescription.processingLevelCode</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ImageDescription.radiometricCalibrationDataAvailability&quot; '>i18n.catalog.iso19139.MD_ImageDescription.radiometricCalibrationDataAvailability</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ImageDescription.triangulationIndicator&quot; '>i18n.catalog.iso19139.MD_ImageDescription.triangulationIndicator</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ImagingConditionCode&quot; '>i18n.catalog.iso19139.MD_ImagingConditionCode</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ImagingConditionCode.blurredImage&quot; '>i18n.catalog.iso19139.MD_ImagingConditionCode.blurredImage</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ImagingConditionCode.cloud&quot; '>i18n.catalog.iso19139.MD_ImagingConditionCode.cloud</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ImagingConditionCode.degradingObliquity&quot; '>i18n.catalog.iso19139.MD_ImagingConditionCode.degradingObliquity</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ImagingConditionCode.fog&quot; '>i18n.catalog.iso19139.MD_ImagingConditionCode.fog</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ImagingConditionCode.heavySmokeOrDust&quot; '>i18n.catalog.iso19139.MD_ImagingConditionCode.heavySmokeOrDust</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ImagingConditionCode.night&quot; '>i18n.catalog.iso19139.MD_ImagingConditionCode.night</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ImagingConditionCode.rain&quot; '>i18n.catalog.iso19139.MD_ImagingConditionCode.rain</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ImagingConditionCode.semiDarkness&quot; '>i18n.catalog.iso19139.MD_ImagingConditionCode.semiDarkness</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ImagingConditionCode.shadow&quot; '>i18n.catalog.iso19139.MD_ImagingConditionCode.shadow</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ImagingConditionCode.snow&quot; '>i18n.catalog.iso19139.MD_ImagingConditionCode.snow</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Keywords&quot; '>i18n.catalog.iso19139.MD_Keywords</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Keywords.keyword&quot; '>i18n.catalog.iso19139.MD_Keywords.keyword</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Keywords.keyword.delimited&quot; '>i18n.catalog.iso19139.MD_Keywords.keyword.delimited</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Keywords.thesaurusName&quot; '>i18n.catalog.iso19139.MD_Keywords.thesaurusName</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Keywords.type&quot; '>i18n.catalog.iso19139.MD_Keywords.type</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_KeywordTypeCode&quot; '>i18n.catalog.iso19139.MD_KeywordTypeCode</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_KeywordTypeCode.discipline&quot; '>i18n.catalog.iso19139.MD_KeywordTypeCode.discipline</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_KeywordTypeCode.place&quot; '>i18n.catalog.iso19139.MD_KeywordTypeCode.place</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_KeywordTypeCode.stratum&quot; '>i18n.catalog.iso19139.MD_KeywordTypeCode.stratum</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_KeywordTypeCode.temporal&quot; '>i18n.catalog.iso19139.MD_KeywordTypeCode.temporal</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_KeywordTypeCode.theme&quot; '>i18n.catalog.iso19139.MD_KeywordTypeCode.theme</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_LegalConstraints&quot; '>i18n.catalog.iso19139.MD_LegalConstraints</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_LegalConstraints.accessConstraints&quot; '>i18n.catalog.schedaMetadati.VincoliAccesso</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_LegalConstraints.otherConstraints&quot; '>i18n.catalog.iso19139.MD_LegalConstraints.otherConstraints</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_LegalConstraints.useConstraints&quot; '>i18n.catalog.schedaMetadati.VincoliUso</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_MaintenanceFrequencyCode&quot; '>i18n.catalog.iso19139.MD_MaintenanceFrequencyCode</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_MaintenanceFrequencyCode.annually&quot; '>i18n.catalog.iso19139.MD_MaintenanceFrequencyCode.annually</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_MaintenanceFrequencyCode.asNeeded&quot; '>i18n.catalog.iso19139.MD_MaintenanceFrequencyCode.asNeeded</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_MaintenanceFrequencyCode.biannually&quot; '>i18n.catalog.iso19139.MD_MaintenanceFrequencyCode.biannually</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_MaintenanceFrequencyCode.continual&quot; '>i18n.catalog.iso19139.MD_MaintenanceFrequencyCode.continual</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_MaintenanceFrequencyCode.daily&quot; '>i18n.catalog.iso19139.MD_MaintenanceFrequencyCode.daily</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_MaintenanceFrequencyCode.fortnightly&quot; '>i18n.catalog.iso19139.MD_MaintenanceFrequencyCode.fortnightly</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_MaintenanceFrequencyCode.irregular&quot; '>i18n.catalog.iso19139.MD_MaintenanceFrequencyCode.irregular</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_MaintenanceFrequencyCode.monthly&quot; '>i18n.catalog.iso19139.MD_MaintenanceFrequencyCode.monthly</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_MaintenanceFrequencyCode.notPlanned&quot; '>i18n.catalog.iso19139.MD_MaintenanceFrequencyCode.notPlanned</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_MaintenanceFrequencyCode.quarterly&quot; '>i18n.catalog.iso19139.MD_MaintenanceFrequencyCode.quarterly</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_MaintenanceFrequencyCode.unknown&quot; '>i18n.catalog.iso19139.MD_MaintenanceFrequencyCode.unknown</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_MaintenanceFrequencyCode.weekly&quot; '>i18n.catalog.iso19139.MD_MaintenanceFrequencyCode.weekly</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_MaintenanceInformation&quot; '>i18n.catalog.iso19139.MD_MaintenanceInformation</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_MaintenanceInformation.contact&quot; '>i18n.catalog.iso19139.MD_MaintenanceInformation.contact</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_MaintenanceInformation.dateOfNextUpdate&quot; '>i18n.catalog.iso19139.MD_MaintenanceInformation.dateOfNextUpdate</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_MaintenanceInformation.maintenanceAndUpdateFrequency&quot; '>i18n.catalog.iso19139.MD_MaintenanceInformation.maintenanceAndUpdateFrequency</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_MaintenanceInformation.maintenanceNote&quot; '>i18n.catalog.iso19139.MD_MaintenanceInformation.maintenanceNote</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_MaintenanceInformation.updateScope&quot; '>i18n.catalog.iso19139.MD_MaintenanceInformation.updateScope</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_MaintenanceInformation.updateScopeDescription&quot; '>i18n.catalog.iso19139.MD_MaintenanceInformation.updateScopeDescription</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_MaintenanceInformation.userDefinedMaintenanceFrequency&quot; '>i18n.catalog.iso19139.MD_MaintenanceInformation.userDefinedMaintenanceFrequency</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Medium&quot; '>i18n.catalog.iso19139.MD_Medium</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Medium.density&quot; '>i18n.catalog.iso19139.MD_Medium.density</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Medium.densityUnits&quot; '>i18n.catalog.iso19139.MD_Medium.densityUnits</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Medium.mediumFormat&quot; '>i18n.catalog.iso19139.MD_Medium.mediumFormat</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Medium.mediumNote&quot; '>i18n.catalog.iso19139.MD_Medium.mediumNote</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Medium.name&quot; '>i18n.catalog.iso19139.MD_Medium.name</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Medium.volumes&quot; '>i18n.catalog.iso19139.MD_Medium.volumes</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_MediumFormatCode&quot; '>i18n.catalog.iso19139.MD_MediumFormatCode</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_MediumFormatCode.cpio&quot; '>i18n.catalog.iso19139.MD_MediumFormatCode.cpio</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_MediumFormatCode.highSierra&quot; '>i18n.catalog.iso19139.MD_MediumFormatCode.highSierra</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_MediumFormatCode.iso9660&quot; '>i18n.catalog.iso19139.MD_MediumFormatCode.iso9660</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_MediumFormatCode.iso9660AppleHFS&quot; '>i18n.catalog.iso19139.MD_MediumFormatCode.iso9660AppleHFS</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_MediumFormatCode.iso9660RockRidge&quot; '>i18n.catalog.iso19139.MD_MediumFormatCode.iso9660RockRidge</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_MediumFormatCode.tar&quot; '>i18n.catalog.iso19139.MD_MediumFormatCode.tar</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_MediumNameCode&quot; '>i18n.catalog.iso19139.MD_MediumNameCode</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_MediumNameCode.1quarterInchCartridgeTape&quot; '>i18n.catalog.iso19139.MD_MediumNameCode.1quarterInchCartridgeTape</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_MediumNameCode.3480Cartridge&quot; '>i18n.catalog.iso19139.MD_MediumNameCode.3480Cartridge</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_MediumNameCode.3490Cartridge&quot; '>i18n.catalog.iso19139.MD_MediumNameCode.3490Cartridge</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_MediumNameCode.3580Cartridge&quot; '>i18n.catalog.iso19139.MD_MediumNameCode.3580Cartridge</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_MediumNameCode.3halfInchFloppy&quot; '>i18n.catalog.iso19139.MD_MediumNameCode.3halfInchFloppy</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_MediumNameCode.4mmCartridgeTape&quot; '>i18n.catalog.iso19139.MD_MediumNameCode.4mmCartridgeTape</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_MediumNameCode.5quarterInchFloppy&quot; '>i18n.catalog.iso19139.MD_MediumNameCode.5quarterInchFloppy</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_MediumNameCode.7trackTape&quot; '>i18n.catalog.iso19139.MD_MediumNameCode.7trackTape</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_MediumNameCode.8mmCartridgeTape&quot; '>i18n.catalog.iso19139.MD_MediumNameCode.8mmCartridgeTape</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_MediumNameCode.9trackType&quot; '>i18n.catalog.iso19139.MD_MediumNameCode.9trackType</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_MediumNameCode.cdRom&quot; '>i18n.catalog.iso19139.MD_MediumNameCode.cdRom</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_MediumNameCode.digitalLinearTape&quot; '>i18n.catalog.iso19139.MD_MediumNameCode.digitalLinearTape</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_MediumNameCode.dvd&quot; '>i18n.catalog.iso19139.MD_MediumNameCode.dvd</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_MediumNameCode.dvdRom&quot; '>i18n.catalog.iso19139.MD_MediumNameCode.dvdRom</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_MediumNameCode.hardcopy&quot; '>i18n.catalog.iso19139.MD_MediumNameCode.hardcopy</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_MediumNameCode.onLine&quot; '>i18n.catalog.iso19139.MD_MediumNameCode.onLine</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_MediumNameCode.satellite&quot; '>i18n.catalog.iso19139.MD_MediumNameCode.satellite</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_MediumNameCode.telephoneLink&quot; '>i18n.catalog.iso19139.MD_MediumNameCode.telephoneLink</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata&quot; '>i18n.catalog.iso19139.MD_Metadata</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.applicationSchemaInfo&quot; '>i18n.catalog.iso19139.MD_Metadata.applicationSchemaInfo</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.characterSet&quot; '>i18n.catalog.iso19139.MD_Metadata.characterSet</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.contact&quot; '>i18n.catalog.iso19139.MD_Metadata.contact</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.contact.help&quot; '>i18n.catalog.iso19139.MD_Metadata.contact.help</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.contentInfo&quot; '>i18n.catalog.iso19139.MD_Metadata.contentInfo</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.dataQualityInfo&quot; '>i18n.catalog.schedaMetadati.Qualita</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.dataSetURI&quot; '>i18n.catalog.iso19139.MD_Metadata.dataSetURI</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.dateStamp&quot; '>i18n.catalog.iso19139.MD_Metadata.dateStamp</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.describes&quot; '>i18n.catalog.iso19139.MD_Metadata.describes</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.distributionInfo&quot; '>i18n.catalog.iso19139.MD_Metadata.distributionInfo</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.featureAttribute&quot; '>i18n.catalog.iso19139.MD_Metadata.featureAttribute</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.featureType&quot; '>i18n.catalog.iso19139.MD_Metadata.featureType</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.fileIdentifier&quot; '>i18n.catalog.iso19139.MD_Metadata.fileIdentifier</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.hierarchyLevel&quot; '>i18n.catalog.iso19139.MD_Metadata.hierarchyLevel</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.hierarchyLevelName&quot; '>i18n.catalog.iso19139.MD_Metadata.hierarchyLevelName</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.identificationInfo&quot; '>i18n.catalog.iso19139.MD_Metadata.identificationInfo</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.language&quot; '>i18n.catalog.iso19139.MD_Metadata.language</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.locale&quot; '>i18n.catalog.iso19139.MD_Metadata.locale</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.MD_BrowseGraphic&quot; '>i18n.catalog.iso19139.MD_Metadata.MD_BrowseGraphic</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.MD_DataIdentification&quot; '>i18n.catalog.iso19139.MD_Metadata.MD_DataIdentification</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.MD_Identification&quot; '>i18n.catalog.iso19139.MD_Metadata.MD_Identification</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.MD_ServiceIdentification&quot; '>i18n.catalog.iso19139.MD_Metadata.MD_ServiceIdentification</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.metadataConstraints&quot; '>i18n.catalog.iso19139.MD_Metadata.metadataConstraints</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.metadataExtensionInfo&quot; '>i18n.catalog.iso19139.MD_Metadata.metadataExtensionInfo</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.metadataMaintenance&quot; '>i18n.catalog.iso19139.MD_Metadata.metadataMaintenance</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.metadataStandardName&quot; '>i18n.catalog.iso19139.MD_Metadata.metadataStandardName</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.metadataStandardVersion&quot; '>i18n.catalog.iso19139.MD_Metadata.metadataStandardVersion</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.parentIdentifier&quot; '>i18n.catalog.iso19139.MD_Metadata.parentIdentifier</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.portrayalCatalogueInfo&quot; '>i18n.catalog.iso19139.MD_Metadata.portrayalCatalogueInfo</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.propertyType&quot; '>i18n.catalog.iso19139.MD_Metadata.propertyType</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.referenceSystemInfo&quot; '>i18n.catalog.iso19139.MD_Metadata.referenceSystemInfo</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.section.distribution&quot; '>i18n.catalog.iso19139.MD_Metadata.section.distribution</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.section.identification&quot; '>i18n.catalog.iso19139.MD_Metadata.section.identification</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.section.identification.abstract&quot; '>i18n.catalog.iso19139.MD_Metadata.section.identification.abstract</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.section.identification.citation&quot; '>i18n.catalog.iso19139.MD_Metadata.section.identification.citation</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.section.identification.classification&quot; '>i18n.catalog.iso19139.MD_Metadata.section.identification.classification</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.section.identification.contact&quot; '>i18n.catalog.iso19139.MD_Metadata.section.identification.contact</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.section.identification.descriptiveKeywords&quot; '>i18n.catalog.iso19139.MD_Metadata.section.identification.descriptiveKeywords</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.section.identification.extent&quot; '>i18n.catalog.iso19139.MD_Metadata.section.identification.extent</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.section.identification.extent.geographicElement&quot; '>i18n.catalog.iso19139.MD_Metadata.section.identification.extent.geographicElement</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.section.identification.extent.temporalElement&quot; '>i18n.catalog.iso19139.MD_Metadata.section.identification.extent.temporalElement</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.section.identification.graphicOverview&quot; '>i18n.catalog.iso19139.MD_Metadata.section.identification.graphicOverview</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.section.identification.language&quot; '>i18n.catalog.iso19139.MD_Metadata.section.identification.language</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.section.identification.otherKeywords&quot; '>i18n.catalog.iso19139.MD_Metadata.section.identification.otherKeywords</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.section.identification.representation&quot; '>i18n.catalog.iso19139.MD_Metadata.section.identification.representation</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.section.identification.resource&quot; '>i18n.catalog.iso19139.MD_Metadata.section.identification.resource</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.section.identification.resourceConstraints&quot; '>i18n.catalog.iso19139.MD_Metadata.section.identification.resourceConstraints</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.section.identification.service.couplingType&quot; '>i18n.catalog.iso19139.MD_Metadata.section.identification.service.couplingType</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.section.identification.service.operatesOn&quot; '>i18n.catalog.iso19139.MD_Metadata.section.identification.service.operatesOn</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.section.identification.service.operation&quot; '>i18n.catalog.iso19139.MD_Metadata.section.identification.service.operation</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.section.identification.service.serviceType&quot; '>i18n.catalog.iso19139.MD_Metadata.section.identification.service.serviceType</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.section.metadata&quot; '>i18n.catalog.iso19139.MD_Metadata.section.metadata</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.section.metadata.contact&quot; '>i18n.catalog.iso19139.MD_Metadata.section.metadata.contact</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.section.metadata.date&quot; '>i18n.catalog.iso19139.MD_Metadata.section.metadata.date</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.section.metadata.identifier&quot; '>i18n.catalog.iso19139.MD_Metadata.section.metadata.identifier</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.section.metadata.reference&quot; '>i18n.catalog.iso19139.MD_Metadata.section.metadata.reference</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.section.metadata.standard&quot; '>i18n.catalog.iso19139.MD_Metadata.section.metadata.standard</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.section.quality&quot; '>i18n.catalog.iso19139.MD_Metadata.section.quality</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.section.quality.conformance&quot; '>i18n.catalog.iso19139.MD_Metadata.section.quality.conformance</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.section.quality.lineage&quot; '>i18n.catalog.iso19139.MD_Metadata.section.quality.lineage</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.section.quality.scope&quot; '>i18n.catalog.iso19139.MD_Metadata.section.quality.scope</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.series&quot; '>i18n.catalog.iso19139.MD_Metadata.series</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Metadata.spatialRepresentationInfo&quot; '>i18n.catalog.iso19139.MD_Metadata.spatialRepresentationInfo</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_MetadataExtensionInformation&quot; '>i18n.catalog.iso19139.MD_MetadataExtensionInformation</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_MetadataExtensionInformation.extendedElementInformation&quot; '>i18n.catalog.iso19139.MD_MetadataExtensionInformation.extendedElementInformation</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_MetadataExtensionInformation.extensionOnLineResource&quot; '>i18n.catalog.iso19139.MD_MetadataExtensionInformation.extensionOnLineResource</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ObligationCode&quot; '>i18n.catalog.iso19139.MD_ObligationCode</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ObligationCode.conditional&quot; '>i18n.catalog.iso19139.MD_ObligationCode.conditional</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ObligationCode.mandatory&quot; '>i18n.catalog.iso19139.MD_ObligationCode.mandatory</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ObligationCode.optional&quot; '>i18n.catalog.iso19139.MD_ObligationCode.optional</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_PixelOrientationCode&quot; '>i18n.catalog.iso19139.MD_PixelOrientationCode</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_PixelOrientationCode.center&quot; '>i18n.catalog.iso19139.MD_PixelOrientationCode.center</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_PixelOrientationCode.lowerLeft&quot; '>i18n.catalog.iso19139.MD_PixelOrientationCode.lowerLeft</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_PixelOrientationCode.lowerRight&quot; '>i18n.catalog.iso19139.MD_PixelOrientationCode.lowerRight</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_PixelOrientationCode.upperLeft&quot; '>i18n.catalog.iso19139.MD_PixelOrientationCode.upperLeft</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_PixelOrientationCode.upperRight&quot; '>i18n.catalog.iso19139.MD_PixelOrientationCode.upperRight</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_PortrayalCatalogueReference&quot; '>i18n.catalog.iso19139.MD_PortrayalCatalogueReference</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_PortrayalCatalogueReference.portrayalCatalogueCitation&quot; '>i18n.catalog.iso19139.MD_PortrayalCatalogueReference.portrayalCatalogueCitation</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ProgressCode&quot; '>i18n.catalog.iso19139.MD_ProgressCode</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ProgressCode.completed&quot; '>i18n.catalog.iso19139.MD_ProgressCode.completed</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ProgressCode.historicalArchive&quot; '>i18n.catalog.iso19139.MD_ProgressCode.historicalArchive</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ProgressCode.obsolete&quot; '>i18n.catalog.iso19139.MD_ProgressCode.obsolete</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ProgressCode.onGoing&quot; '>i18n.catalog.iso19139.MD_ProgressCode.onGoing</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ProgressCode.planned&quot; '>i18n.catalog.iso19139.MD_ProgressCode.planned</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ProgressCode.required&quot; '>i18n.catalog.iso19139.MD_ProgressCode.required</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ProgressCode.underDevelopment&quot; '>i18n.catalog.iso19139.MD_ProgressCode.underDevelopment</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_RangeDimension&quot; '>i18n.catalog.iso19139.MD_RangeDimension</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_RangeDimension.descriptor&quot; '>i18n.catalog.iso19139.MD_RangeDimension.descriptor</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_RangeDimension.sequenceIdentifier&quot; '>i18n.catalog.iso19139.MD_RangeDimension.sequenceIdentifier</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ReferenceSystem&quot; '>i18n.catalog.iso19139.MD_ReferenceSystem</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ReferenceSystem.referenceSystemIdentifier&quot; '>i18n.catalog.iso19139.MD_ReferenceSystem.referenceSystemIdentifier</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_RepresentativeFraction&quot; '>i18n.catalog.iso19139.MD_RepresentativeFraction</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_RepresentativeFraction.denominator&quot; '>i18n.catalog.iso19139.MD_RepresentativeFraction.denominator</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Resolution&quot; '>i18n.catalog.iso19139.MD_Resolution</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Resolution.distance&quot; '>i18n.catalog.iso19139.MD_Resolution.distance</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Resolution.equivalentScale&quot; '>i18n.catalog.iso19139.MD_Resolution.equivalentScale</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_RestrictionCode&quot; '>i18n.catalog.iso19139.MD_RestrictionCode</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_RestrictionCode.copyright&quot; '>i18n.catalog.iso19139.MD_RestrictionCode.copyright</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_RestrictionCode.intellectualPropertyRights&quot; '>i18n.catalog.iso19139.MD_RestrictionCode.intellectualPropertyRights</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_RestrictionCode.license&quot; '>i18n.catalog.iso19139.MD_RestrictionCode.license</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_RestrictionCode.otherRestrictions&quot; '>i18n.catalog.iso19139.MD_RestrictionCode.otherRestrictions</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_RestrictionCode.patent&quot; '>i18n.catalog.iso19139.MD_RestrictionCode.patent</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_RestrictionCode.patentPending&quot; '>i18n.catalog.iso19139.MD_RestrictionCode.patentPending</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_RestrictionCode.restricted&quot; '>i18n.catalog.iso19139.MD_RestrictionCode.restricted</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_RestrictionCode.trademark&quot; '>i18n.catalog.iso19139.MD_RestrictionCode.trademark</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ScopeCode&quot; '>i18n.catalog.iso19139.MD_ScopeCode</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ScopeCode.attribute&quot; '>i18n.catalog.iso19139.MD_ScopeCode.attribute</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ScopeCode.attributeType&quot; '>i18n.catalog.iso19139.MD_ScopeCode.attributeType</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ScopeCode.collectionHardware&quot; '>i18n.catalog.iso19139.MD_ScopeCode.collectionHardware</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ScopeCode.collectionSession&quot; '>i18n.catalog.iso19139.MD_ScopeCode.collectionSession</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ScopeCode.dataset&quot; '>i18n.catalog.iso19139.MD_ScopeCode.dataset</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ScopeCode.dimensionGroup&quot; '>i18n.catalog.iso19139.MD_ScopeCode.dimensionGroup</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ScopeCode.feature&quot; '>i18n.catalog.iso19139.MD_ScopeCode.feature</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ScopeCode.featureType&quot; '>i18n.catalog.iso19139.MD_ScopeCode.featureType</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ScopeCode.fieldSession&quot; '>i18n.catalog.iso19139.MD_ScopeCode.fieldSession</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ScopeCode.model&quot; '>i18n.catalog.iso19139.MD_ScopeCode.model</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ScopeCode.nonGeographicDataset&quot; '>i18n.catalog.iso19139.MD_ScopeCode.nonGeographicDataset</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ScopeCode.propertyType&quot; '>i18n.catalog.iso19139.MD_ScopeCode.propertyType</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ScopeCode.series&quot; '>i18n.catalog.iso19139.MD_ScopeCode.series</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ScopeCode.service&quot; '>i18n.catalog.iso19139.MD_ScopeCode.service</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ScopeCode.software&quot; '>i18n.catalog.iso19139.MD_ScopeCode.software</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ScopeCode.tile&quot; '>i18n.catalog.iso19139.MD_ScopeCode.tile</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ScopeDescription&quot; '>i18n.catalog.iso19139.MD_ScopeDescription</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ScopeDescription.attributeInstances&quot; '>i18n.catalog.iso19139.MD_ScopeDescription.attributeInstances</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ScopeDescription.attributes&quot; '>i18n.catalog.iso19139.MD_ScopeDescription.attributes</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ScopeDescription.dataset&quot; '>i18n.catalog.iso19139.MD_ScopeDescription.dataset</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ScopeDescription.featureInstances&quot; '>i18n.catalog.iso19139.MD_ScopeDescription.featureInstances</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ScopeDescription.features&quot; '>i18n.catalog.iso19139.MD_ScopeDescription.features</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_ScopeDescription.other&quot; '>i18n.catalog.iso19139.MD_ScopeDescription.other</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_SecurityConstraints&quot; '>i18n.catalog.iso19139.MD_SecurityConstraints</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_SecurityConstraints.classification&quot; '>i18n.catalog.iso19139.MD_SecurityConstraints.classification</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_SecurityConstraints.classificationSystem&quot; '>i18n.catalog.iso19139.MD_SecurityConstraints.classificationSystem</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_SecurityConstraints.handlingDescription&quot; '>i18n.catalog.iso19139.MD_SecurityConstraints.handlingDescription</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_SecurityConstraints.userNote&quot; '>i18n.catalog.iso19139.MD_SecurityConstraints.userNote</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_SpatialRepresentationTypeCode&quot; '>i18n.catalog.iso19139.MD_SpatialRepresentationTypeCode</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_SpatialRepresentationTypeCode.grid&quot; '>i18n.catalog.iso19139.MD_SpatialRepresentationTypeCode.grid</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_SpatialRepresentationTypeCode.stereoModel&quot; '>i18n.catalog.iso19139.MD_SpatialRepresentationTypeCode.stereoModel</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_SpatialRepresentationTypeCode.textTable&quot; '>i18n.catalog.iso19139.MD_SpatialRepresentationTypeCode.textTable</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_SpatialRepresentationTypeCode.tin&quot; '>i18n.catalog.iso19139.MD_SpatialRepresentationTypeCode.tin</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_SpatialRepresentationTypeCode.vector&quot; '>i18n.catalog.iso19139.MD_SpatialRepresentationTypeCode.vector</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_SpatialRepresentationTypeCode.video&quot; '>i18n.catalog.iso19139.MD_SpatialRepresentationTypeCode.video</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_StandardOrderProcess&quot; '>i18n.catalog.iso19139.MD_StandardOrderProcess</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_StandardOrderProcess.fees&quot; '>i18n.catalog.iso19139.MD_StandardOrderProcess.fees</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_StandardOrderProcess.orderingInstructions&quot; '>i18n.catalog.iso19139.MD_StandardOrderProcess.orderingInstructions</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_StandardOrderProcess.plannedAvailableDateTime&quot; '>i18n.catalog.iso19139.MD_StandardOrderProcess.plannedAvailableDateTime</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_StandardOrderProcess.turnaround&quot; '>i18n.catalog.iso19139.MD_StandardOrderProcess.turnaround</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_TopicCategoryCode&quot; '>i18n.catalog.iso19139.MD_TopicCategoryCode</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_TopicCategoryCode.biota&quot; '>i18n.catalog.iso19139.MD_TopicCategoryCode.biota</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_TopicCategoryCode.boundaries&quot; '>i18n.catalog.iso19139.MD_TopicCategoryCode.boundaries</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_TopicCategoryCode.climatologyMeteorologyAtmosphere&quot; '>i18n.catalog.iso19139.MD_TopicCategoryCode.climatologyMeteorologyAtmosphere</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_TopicCategoryCode.economy&quot; '>i18n.catalog.iso19139.MD_TopicCategoryCode.economy</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_TopicCategoryCode.elevation&quot; '>i18n.catalog.iso19139.MD_TopicCategoryCode.elevation</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_TopicCategoryCode.environment&quot; '>i18n.catalog.iso19139.MD_TopicCategoryCode.environment</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_TopicCategoryCode.farming&quot; '>i18n.catalog.iso19139.MD_TopicCategoryCode.farming</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_TopicCategoryCode.geoscientificInformation&quot; '>i18n.catalog.iso19139.MD_TopicCategoryCode.geoscientificInformation</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_TopicCategoryCode.health&quot; '>i18n.catalog.iso19139.MD_TopicCategoryCode.health</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_TopicCategoryCode.imageryBaseMapsEarthCover&quot; '>i18n.catalog.iso19139.MD_TopicCategoryCode.imageryBaseMapsEarthCover</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_TopicCategoryCode.inlandWaters&quot; '>i18n.catalog.iso19139.MD_TopicCategoryCode.inlandWaters</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_TopicCategoryCode.intelligenceMilitary&quot; '>i18n.catalog.iso19139.MD_TopicCategoryCode.intelligenceMilitary</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_TopicCategoryCode.location&quot; '>i18n.catalog.iso19139.MD_TopicCategoryCode.location</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_TopicCategoryCode.oceans&quot; '>i18n.catalog.iso19139.MD_TopicCategoryCode.oceans</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_TopicCategoryCode.planningCadastre&quot; '>i18n.catalog.iso19139.MD_TopicCategoryCode.planningCadastre</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_TopicCategoryCode.society&quot; '>i18n.catalog.iso19139.MD_TopicCategoryCode.society</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_TopicCategoryCode.structure&quot; '>i18n.catalog.iso19139.MD_TopicCategoryCode.structure</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_TopicCategoryCode.transportation&quot; '>i18n.catalog.iso19139.MD_TopicCategoryCode.transportation</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_TopicCategoryCode.utilitiesCommunication&quot; '>i18n.catalog.iso19139.MD_TopicCategoryCode.utilitiesCommunication</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_TopologyLevelCode&quot; '>i18n.catalog.iso19139.MD_TopologyLevelCode</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_TopologyLevelCode.abstract&quot; '>i18n.catalog.iso19139.MD_TopologyLevelCode.abstract</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_TopologyLevelCode.fullPlanarGraph&quot; '>i18n.catalog.iso19139.MD_TopologyLevelCode.fullPlanarGraph</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_TopologyLevelCode.fullSurfaceGraph&quot; '>i18n.catalog.iso19139.MD_TopologyLevelCode.fullSurfaceGraph</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_TopologyLevelCode.fullTopology3D&quot; '>i18n.catalog.iso19139.MD_TopologyLevelCode.fullTopology3D</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_TopologyLevelCode.geometryOnly&quot; '>i18n.catalog.iso19139.MD_TopologyLevelCode.geometryOnly</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_TopologyLevelCode.planarGraph&quot; '>i18n.catalog.iso19139.MD_TopologyLevelCode.planarGraph</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_TopologyLevelCode.surfaceGraph&quot; '>i18n.catalog.iso19139.MD_TopologyLevelCode.surfaceGraph</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_TopologyLevelCode.topology1D&quot; '>i18n.catalog.iso19139.MD_TopologyLevelCode.topology1D</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_TopologyLevelCode.topology3D&quot; '>i18n.catalog.iso19139.MD_TopologyLevelCode.topology3D</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Usage&quot; '>i18n.catalog.iso19139.MD_Usage</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Usage.specificUsage&quot; '>i18n.catalog.iso19139.MD_Usage.specificUsage</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Usage.usageDateTime&quot; '>i18n.catalog.iso19139.MD_Usage.usageDateTime</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Usage.userContactInfo&quot; '>i18n.catalog.iso19139.MD_Usage.userContactInfo</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_Usage.userDeterminedLimitations&quot; '>i18n.catalog.iso19139.MD_Usage.userDeterminedLimitations</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_VectorSpatialRepresentation&quot; '>i18n.catalog.iso19139.MD_VectorSpatialRepresentation</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_VectorSpatialRepresentation.geometricObjects&quot; '>i18n.catalog.iso19139.MD_VectorSpatialRepresentation.geometricObjects</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MD_VectorSpatialRepresentation.topologyLevel&quot; '>i18n.catalog.iso19139.MD_VectorSpatialRepresentation.topologyLevel</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.Multiplicity&quot; '>i18n.catalog.iso19139.Multiplicity</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.Multiplicity.range&quot; '>i18n.catalog.iso19139.Multiplicity.range</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MultiplicityRange&quot; '>i18n.catalog.iso19139.MultiplicityRange</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MultiplicityRange.lower&quot; '>i18n.catalog.iso19139.MultiplicityRange.lower</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.MultiplicityRange.upper&quot; '>i18n.catalog.iso19139.MultiplicityRange.upper</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.object.uuidref&quot; '>i18n.catalog.iso19139.object.uuidref</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.object.xlink.href&quot; '>i18n.catalog.iso19139.object.xlink.href</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.PT_FreeText&quot; '>i18n.catalog.iso19139.PT_FreeText</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.PT_FreeText.textGroup&quot; '>i18n.catalog.iso19139.PT_FreeText.textGroup</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.PT_Locale&quot; '>i18n.catalog.iso19139.PT_Locale</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.PT_Locale.characterEncoding&quot; '>i18n.catalog.iso19139.PT_Locale.characterEncoding</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.PT_Locale.country&quot; '>i18n.catalog.iso19139.PT_Locale.country</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.PT_Locale.languageCode&quot; '>i18n.catalog.iso19139.PT_Locale.languageCode</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.PT_LocaleContainer&quot; '>i18n.catalog.iso19139.PT_LocaleContainer</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.PT_LocaleContainer.date&quot; '>i18n.catalog.iso19139.PT_LocaleContainer.date</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.PT_LocaleContainer.description&quot; '>i18n.catalog.iso19139.PT_LocaleContainer.description</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.PT_LocaleContainer.locale&quot; '>i18n.catalog.iso19139.PT_LocaleContainer.locale</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.PT_LocaleContainer.localisedString&quot; '>i18n.catalog.iso19139.PT_LocaleContainer.localisedString</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.PT_LocaleContainer.responsibleParty&quot; '>i18n.catalog.iso19139.PT_LocaleContainer.responsibleParty</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.RS_Identifier&quot; '>i18n.catalog.iso19139.RS_Identifier</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.RS_Identifier.authority&quot; '>i18n.catalog.iso19139.RS_Identifier.authority</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.RS_Identifier.code&quot; '>i18n.catalog.iso19139.RS_Identifier.code</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.RS_Identifier.codeSpace&quot; '>i18n.catalog.iso19139.RS_Identifier.codeSpace</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.RS_Identifier.version&quot; '>i18n.catalog.iso19139.RS_Identifier.version</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.StandardObjectProperties&quot; '>i18n.catalog.iso19139.StandardObjectProperties</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.StandardObjectProperties.description&quot; '>i18n.catalog.iso19139.StandardObjectProperties.description</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.StandardObjectProperties.descriptionReference&quot; '>i18n.catalog.iso19139.StandardObjectProperties.descriptionReference</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.StandardObjectProperties.identifier&quot; '>i18n.catalog.iso19139.StandardObjectProperties.identifier</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.StandardObjectProperties.metaDataProperty&quot; '>i18n.catalog.iso19139.StandardObjectProperties.metaDataProperty</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.StandardObjectProperties.name&quot; '>i18n.catalog.iso19139.StandardObjectProperties.name</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_CoupledResource&quot; '>i18n.catalog.iso19139.SV_CoupledResource</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_CoupledResource.identifier&quot; '>i18n.catalog.iso19139.SV_CoupledResource.identifier</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_CoupledResource.operationName&quot; '>i18n.catalog.iso19139.SV_CoupledResource.operationName</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_CouplingType&quot; '>i18n.catalog.iso19139.SV_CouplingType</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_CouplingType.loose&quot; '>i18n.catalog.iso19139.SV_CouplingType.loose</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_CouplingType.mixed&quot; '>i18n.catalog.iso19139.SV_CouplingType.mixed</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_CouplingType.tight&quot; '>i18n.catalog.iso19139.SV_CouplingType.tight</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_Interface&quot; '>i18n.catalog.iso19139.SV_Interface</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_Interface.operation&quot; '>i18n.catalog.iso19139.SV_Interface.operation</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_Interface.theSV_Port&quot; '>i18n.catalog.iso19139.SV_Interface.theSV_Port</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_Interface.typeName&quot; '>i18n.catalog.iso19139.SV_Interface.typeName</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_Operation&quot; '>i18n.catalog.iso19139.SV_Operation</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_Operation.dependsOn&quot; '>i18n.catalog.iso19139.SV_Operation.dependsOn</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_Operation.operationName&quot; '>i18n.catalog.iso19139.SV_Operation.operationName</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_Operation.parameter&quot; '>i18n.catalog.iso19139.SV_Operation.parameter</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_OperationChain&quot; '>i18n.catalog.iso19139.SV_OperationChain</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_OperationChain.description&quot; '>i18n.catalog.iso19139.SV_OperationChain.description</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_OperationChain.name&quot; '>i18n.catalog.iso19139.SV_OperationChain.name</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_OperationChain.operation&quot; '>i18n.catalog.iso19139.SV_OperationChain.operation</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_OperationChainMetadata&quot; '>i18n.catalog.iso19139.SV_OperationChainMetadata</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_OperationChainMetadata.description&quot; '>i18n.catalog.iso19139.SV_OperationChainMetadata.description</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_OperationChainMetadata.name&quot; '>i18n.catalog.iso19139.SV_OperationChainMetadata.name</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_OperationChainMetadata.operation&quot; '>i18n.catalog.iso19139.SV_OperationChainMetadata.operation</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_OperationMetadata&quot; '>i18n.catalog.iso19139.SV_OperationMetadata</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_OperationMetadata.connectPoint&quot; '>i18n.catalog.iso19139.SV_OperationMetadata.connectPoint</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_OperationMetadata.DCP&quot; '>i18n.catalog.iso19139.SV_OperationMetadata.DCP</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_OperationMetadata.dependsOn&quot; '>i18n.catalog.iso19139.SV_OperationMetadata.dependsOn</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_OperationMetadata.invocationName&quot; '>i18n.catalog.iso19139.SV_OperationMetadata.invocationName</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_OperationMetadata.operationDescription&quot; '>i18n.catalog.iso19139.SV_OperationMetadata.operationDescription</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_OperationMetadata.operationName&quot; '>i18n.catalog.iso19139.SV_OperationMetadata.operationName</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_OperationMetadata.parameters&quot; '>i18n.catalog.iso19139.SV_OperationMetadata.parameters</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_Paramater&quot; '>i18n.catalog.iso19139.SV_Paramater</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_Paramater.description&quot; '>i18n.catalog.iso19139.SV_Paramater.description</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_Paramater.direction&quot; '>i18n.catalog.iso19139.SV_Paramater.direction</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_Paramater.name&quot; '>i18n.catalog.iso19139.SV_Paramater.name</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_Paramater.optionality&quot; '>i18n.catalog.iso19139.SV_Paramater.optionality</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_Paramater.repeatability&quot; '>i18n.catalog.iso19139.SV_Paramater.repeatability</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_Paramater.valueType&quot; '>i18n.catalog.iso19139.SV_Paramater.valueType</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_ParameterDirection&quot; '>i18n.catalog.iso19139.SV_ParameterDirection</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_PlatformNeutralServiceSpecification&quot; '>i18n.catalog.iso19139.SV_PlatformNeutralServiceSpecification</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_PlatformNeutralServiceSpecification.implSpec&quot; '>i18n.catalog.iso19139.SV_PlatformNeutralServiceSpecification.implSpec</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_PlatformNeutralServiceSpecification.name&quot; '>i18n.catalog.iso19139.SV_PlatformNeutralServiceSpecification.name</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_PlatformNeutralServiceSpecification.opModel&quot; '>i18n.catalog.iso19139.SV_PlatformNeutralServiceSpecification.opModel</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_PlatformNeutralServiceSpecification.serviceType&quot; '>i18n.catalog.iso19139.SV_PlatformNeutralServiceSpecification.serviceType</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_PlatformSpecificServiceSpecification&quot; '>i18n.catalog.iso19139.SV_PlatformSpecificServiceSpecification</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_PlatformSpecificServiceSpecification.DCP&quot; '>i18n.catalog.iso19139.SV_PlatformSpecificServiceSpecification.DCP</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_PlatformSpecificServiceSpecification.implementation&quot; '>i18n.catalog.iso19139.SV_PlatformSpecificServiceSpecification.implementation</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_PlatformSpecificServiceSpecification.implSpec&quot; '>i18n.catalog.iso19139.SV_PlatformSpecificServiceSpecification.implSpec</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_PlatformSpecificServiceSpecification.name&quot; '>i18n.catalog.iso19139.SV_PlatformSpecificServiceSpecification.name</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_PlatformSpecificServiceSpecification.opModel&quot; '>i18n.catalog.iso19139.SV_PlatformSpecificServiceSpecification.opModel</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_PlatformSpecificServiceSpecification.serviceType&quot; '>i18n.catalog.iso19139.SV_PlatformSpecificServiceSpecification.serviceType</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_Port&quot; '>i18n.catalog.iso19139.SV_Port</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_Port.theSV_Interface&quot; '>i18n.catalog.iso19139.SV_Port.theSV_Interface</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_PortSpecification&quot; '>i18n.catalog.iso19139.SV_PortSpecification</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_PortSpecification.address&quot; '>i18n.catalog.iso19139.SV_PortSpecification.address</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_PortSpecification.binding&quot; '>i18n.catalog.iso19139.SV_PortSpecification.binding</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_Service&quot; '>i18n.catalog.iso19139.SV_Service</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_Service.specification&quot; '>i18n.catalog.iso19139.SV_Service.specification</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_Service.theSV_Port&quot; '>i18n.catalog.iso19139.SV_Service.theSV_Port</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_ServiceIdentification&quot; '>i18n.catalog.iso19139.SV_ServiceIdentification</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_ServiceIdentification.accessProperties&quot; '>i18n.catalog.iso19139.SV_ServiceIdentification.accessProperties</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_ServiceIdentification.containsOperations&quot; '>i18n.catalog.iso19139.SV_ServiceIdentification.containsOperations</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_ServiceIdentification.coupledResource&quot; '>i18n.catalog.iso19139.SV_ServiceIdentification.coupledResource</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_ServiceIdentification.couplingType&quot; '>i18n.catalog.iso19139.SV_ServiceIdentification.couplingType</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_ServiceIdentification.extent&quot; '>i18n.catalog.iso19139.SV_ServiceIdentification.extent</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_ServiceIdentification.keywords&quot; '>i18n.catalog.iso19139.SV_ServiceIdentification.keywords</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_ServiceIdentification.operatesOn&quot; '>i18n.catalog.iso19139.SV_ServiceIdentification.operatesOn</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_ServiceIdentification.restrictions&quot; '>i18n.catalog.iso19139.SV_ServiceIdentification.restrictions</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_ServiceIdentification.serviceType&quot; '>i18n.catalog.iso19139.SV_ServiceIdentification.serviceType</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_ServiceIdentification.serviceTypeVersion&quot; '>i18n.catalog.iso19139.SV_ServiceIdentification.serviceTypeVersion</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_ServiceSpecification&quot; '>i18n.catalog.iso19139.SV_ServiceSpecification</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_ServiceSpecification.name&quot; '>i18n.catalog.iso19139.SV_ServiceSpecification.name</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_ServiceSpecification.opModel&quot; '>i18n.catalog.iso19139.SV_ServiceSpecification.opModel</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_ServiceSpecification.theSV_Interface&quot; '>i18n.catalog.iso19139.SV_ServiceSpecification.theSV_Interface</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_ServiceSpecification.typeSpec&quot; '>i18n.catalog.iso19139.SV_ServiceSpecification.typeSpec</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.SV_ServiceType&quot; '>i18n.catalog.iso19139.SV_ServiceType</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.TM_Primitive.indeterminatePosition&quot; '>i18n.catalog.iso19139.TM_Primitive.indeterminatePosition</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.TM_Primitive.indeterminatePosition.after&quot; '>i18n.catalog.iso19139.TM_Primitive.indeterminatePosition.after</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.TM_Primitive.indeterminatePosition.before&quot; '>i18n.catalog.iso19139.TM_Primitive.indeterminatePosition.before</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.TM_Primitive.indeterminatePosition.now&quot; '>i18n.catalog.iso19139.TM_Primitive.indeterminatePosition.now</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.TM_Primitive.indeterminatePosition.unknown&quot; '>i18n.catalog.iso19139.TM_Primitive.indeterminatePosition.unknown</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.XTN_Identification&quot; '>i18n.catalog.iso19139.XTN_Identification</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.XTN_Identification.abstract&quot; '>i18n.catalog.iso19139.XTN_Identification.abstract</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.XTN_Identification.citation.date&quot; '>i18n.catalog.iso19139.XTN_Identification.citation.date</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.XTN_Identification.citation.identifier&quot; '>i18n.catalog.iso19139.XTN_Identification.citation.identifier</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.XTN_Identification.citation.MD_Identifier&quot; '>i18n.catalog.iso19139.XTN_Identification.citation.MD_Identifier</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.XTN_Identification.citation.RS_Identifier&quot; '>i18n.catalog.iso19139.XTN_Identification.citation.RS_Identifier</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.XTN_Identification.citation.title&quot; '>i18n.catalog.iso19139.XTN_Identification.citation.title</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.XTN_Identification.language&quot; '>i18n.catalog.iso19139.XTN_Identification.language</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.XTN_Identification.spatialRepresentationType&quot; '>i18n.catalog.iso19139.XTN_Identification.spatialRepresentationType</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.XTN_Identification.spatialResolution&quot; '>i18n.catalog.iso19139.XTN_Identification.spatialResolution</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.XTN_Identification.topicCategory&quot; '>i18n.catalog.iso19139.XTN_Identification.topicCategory</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139.XTN_Scope.level&quot; '>i18n.catalog.iso19139.XTN_Scope.level</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.acquisition&quot; '>i18n.catalog.iso19139-2.MI_Metadata.acquisition</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.acquisition.event&quot; '>i18n.catalog.iso19139-2.MI_Metadata.acquisition.event</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.acquisition.event.context&quot; '>i18n.catalog.iso19139-2.MI_Metadata.acquisition.event.context</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.acquisition.event.contextCode.acquisition&quot; '>i18n.catalog.iso19139-2.MI_Metadata.acquisition.event.contextCode.acquisition</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.acquisition.event.contextCode.pass&quot; '>i18n.catalog.iso19139-2.MI_Metadata.acquisition.event.contextCode.pass</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.acquisition.event.contextCode.wayPoint&quot; '>i18n.catalog.iso19139-2.MI_Metadata.acquisition.event.contextCode.wayPoint</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.acquisition.event.sequence&quot; '>i18n.catalog.iso19139-2.MI_Metadata.acquisition.event.sequence</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.acquisition.event.sequenceCode.end&quot; '>i18n.catalog.iso19139-2.MI_Metadata.acquisition.event.sequenceCode.end</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.acquisition.event.sequenceCode.instantaneous&quot; '>i18n.catalog.iso19139-2.MI_Metadata.acquisition.event.sequenceCode.instantaneous</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.acquisition.event.sequenceCode.start&quot; '>i18n.catalog.iso19139-2.MI_Metadata.acquisition.event.sequenceCode.start</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.acquisition.event.time&quot; '>i18n.catalog.iso19139-2.MI_Metadata.acquisition.event.time</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.acquisition.event.trigger&quot; '>i18n.catalog.iso19139-2.MI_Metadata.acquisition.event.trigger</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.acquisition.event.triggerCode.automatic&quot; '>i18n.catalog.iso19139-2.MI_Metadata.acquisition.event.triggerCode.automatic</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.acquisition.event.triggerCode.manual&quot; '>i18n.catalog.iso19139-2.MI_Metadata.acquisition.event.triggerCode.manual</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.acquisition.event.triggerCode.PreProgrammed&quot; '>i18n.catalog.iso19139-2.MI_Metadata.acquisition.event.triggerCode.PreProgrammed</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.acquisition.objective.extent&quot; '>i18n.catalog.iso19139-2.MI_Metadata.acquisition.objective.extent</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.acquisition.objective.function&quot; '>i18n.catalog.iso19139-2.MI_Metadata.acquisition.objective.function</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.acquisition.objective.objectiveOccurrence&quot; '>i18n.catalog.iso19139-2.MI_Metadata.acquisition.objective.objectiveOccurrence</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.acquisition.objective.objectiveTypeCode.instantaneousCollection&quot; '>i18n.catalog.iso19139-2.MI_Metadata.acquisition.objective.objectiveTypeCode.instantaneousCollection</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.acquisition.objective.objectiveTypeCode.persistentView&quot; '>i18n.catalog.iso19139-2.MI_Metadata.acquisition.objective.objectiveTypeCode.persistentView</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.acquisition.objective.objectiveTypeCode.survey&quot; '>i18n.catalog.iso19139-2.MI_Metadata.acquisition.objective.objectiveTypeCode.survey</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.acquisition.objective.priority&quot; '>i18n.catalog.iso19139-2.MI_Metadata.acquisition.objective.priority</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.acquisition.objective.type&quot; '>i18n.catalog.iso19139-2.MI_Metadata.acquisition.objective.type</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.acquisition.operation.citation&quot; '>i18n.catalog.iso19139-2.MI_Metadata.acquisition.operation.citation</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.acquisition.operation.operationType&quot; '>i18n.catalog.iso19139-2.MI_Metadata.acquisition.operation.operationType</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.acquisition.operation.operationTypeCode&quot; '>i18n.catalog.iso19139-2.MI_Metadata.acquisition.operation.operationTypeCode</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.acquisition.operation.operationTypeCode.real&quot; '>i18n.catalog.iso19139-2.MI_Metadata.acquisition.operation.operationTypeCode.real</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.acquisition.operation.operationTypeCode.simulated&quot; '>i18n.catalog.iso19139-2.MI_Metadata.acquisition.operation.operationTypeCode.simulated</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.acquisition.operation.operationTypeCode.synthesized&quot; '>i18n.catalog.iso19139-2.MI_Metadata.acquisition.operation.operationTypeCode.synthesized</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.acquisition.plan.citation&quot; '>i18n.catalog.iso19139-2.MI_Metadata.acquisition.plan.citation</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.acquisition.plan.geometryTypeCode.areal&quot; '>i18n.catalog.iso19139-2.MI_Metadata.acquisition.plan.geometryTypeCode.areal</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.acquisition.plan.geometryTypeCode.linear&quot; '>i18n.catalog.iso19139-2.MI_Metadata.acquisition.plan.geometryTypeCode.linear</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.acquisition.plan.geometryTypeCode.point&quot; '>i18n.catalog.iso19139-2.MI_Metadata.acquisition.plan.geometryTypeCode.point</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.acquisition.plan.geometryTypeCode.strip&quot; '>i18n.catalog.iso19139-2.MI_Metadata.acquisition.plan.geometryTypeCode.strip</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.acquisition.plan.status&quot; '>i18n.catalog.iso19139-2.MI_Metadata.acquisition.plan.status</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.acquisition.platform.citation&quot; '>i18n.catalog.iso19139-2.MI_Metadata.acquisition.platform.citation</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.acquisition.platform.description&quot; '>i18n.catalog.iso19139-2.MI_Metadata.acquisition.platform.description</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.acquisition.platform.instrument&quot; '>i18n.catalog.iso19139-2.MI_Metadata.acquisition.platform.instrument</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.acquisition.platform.sponsor&quot; '>i18n.catalog.iso19139-2.MI_Metadata.acquisition.platform.sponsor</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.acquisition.requirement.expiryDate&quot; '>i18n.catalog.iso19139-2.MI_Metadata.acquisition.requirement.expiryDate</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.acquisition.requirement.priority&quot; '>i18n.catalog.iso19139-2.MI_Metadata.acquisition.requirement.priority</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.acquisition.requirement.priorityCode.critical&quot; '>i18n.catalog.iso19139-2.MI_Metadata.acquisition.requirement.priorityCode.critical</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.acquisition.requirement.priorityCode.highImportance&quot; '>i18n.catalog.iso19139-2.MI_Metadata.acquisition.requirement.priorityCode.highImportance</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.acquisition.requirement.priorityCode.lowImportance&quot; '>i18n.catalog.iso19139-2.MI_Metadata.acquisition.requirement.priorityCode.lowImportance</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.acquisition.requirement.priorityCode.mediumImportance&quot; '>i18n.catalog.iso19139-2.MI_Metadata.acquisition.requirement.priorityCode.mediumImportance</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.acquisition.requirement.recipient&quot; '>i18n.catalog.iso19139-2.MI_Metadata.acquisition.requirement.recipient</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.acquisition.requirement.requestedDate&quot; '>i18n.catalog.iso19139-2.MI_Metadata.acquisition.requirement.requestedDate</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.acquisition.requirement.requestedDate.latestAcceptableDate&quot; '>i18n.catalog.iso19139-2.MI_Metadata.acquisition.requirement.requestedDate.latestAcceptableDate</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.acquisition.requirement.requestedDate.requestedDateOfCollection&quot; '>i18n.catalog.iso19139-2.MI_Metadata.acquisition.requirement.requestedDate.requestedDateOfCollection</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.acquisition.requirement.requestor&quot; '>i18n.catalog.iso19139-2.MI_Metadata.acquisition.requirement.requestor</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.acuisition.instrument.citation&quot; '>i18n.catalog.iso19139-2.MI_Metadata.acuisition.instrument.citation</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.acuisition.instrument.description&quot; '>i18n.catalog.iso19139-2.MI_Metadata.acuisition.instrument.description</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.acuisition.instrument.type&quot; '>i18n.catalog.iso19139-2.MI_Metadata.acuisition.instrument.type</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.acuisition.operation.description&quot; '>i18n.catalog.iso19139-2.MI_Metadata.acuisition.operation.description</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.acuisition.plan.type&quot; '>i18n.catalog.iso19139-2.MI_Metadata.acuisition.plan.type</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.section.acquisition&quot; '>i18n.catalog.iso19139-2.MI_Metadata.section.acquisition</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.section.acquisition.citation&quot; '>i18n.catalog.iso19139-2.MI_Metadata.section.acquisition.citation</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.section.acuisition.instrument&quot; '>i18n.catalog.iso19139-2.MI_Metadata.section.acuisition.instrument</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.section.acuisition.objective&quot; '>i18n.catalog.iso19139-2.MI_Metadata.section.acuisition.objective</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.section.acuisition.operation&quot; '>i18n.catalog.iso19139-2.MI_Metadata.section.acuisition.operation</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.section.acuisition.plan&quot; '>i18n.catalog.iso19139-2.MI_Metadata.section.acuisition.plan</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.section.acuisition.platform&quot; '>i18n.catalog.iso19139-2.MI_Metadata.section.acuisition.platform</xsl:when>
			<xsl:when test='$key = &quot;catalog.iso19139-2.MI_Metadata.section.acuisition.requirement&quot; '>i18n.catalog.iso19139-2.MI_Metadata.section.acuisition.requirement</xsl:when>
			<xsl:when test='$key = &quot;catalog.javax.naming.directory.InvalidAttributeValueException&quot; '>i18n.catalog.javax.naming.directory.InvalidAttributeValueException</xsl:when>
			<xsl:when test='$key = &quot;catalog.json.dcat.accessLevel&quot; '>i18n.catalog.json.dcat.accessLevel</xsl:when>
			<xsl:when test='$key = &quot;catalog.json.dcat.accessLevelComment&quot; '>i18n.catalog.json.dcat.accessLevelComment</xsl:when>
			<xsl:when test='$key = &quot;catalog.json.dcat.accessURL&quot; '>i18n.catalog.json.dcat.accessURL</xsl:when>
			<xsl:when test='$key = &quot;catalog.json.dcat.bureauCode&quot; '>i18n.catalog.json.dcat.bureauCode</xsl:when>
			<xsl:when test='$key = &quot;catalog.json.dcat.contactPoint&quot; '>i18n.catalog.json.dcat.contactPoint</xsl:when>
			<xsl:when test='$key = &quot;catalog.json.dcat.dataDictionary&quot; '>i18n.catalog.json.dcat.dataDictionary</xsl:when>
			<xsl:when test='$key = &quot;catalog.json.dcat.description&quot; '>i18n.catalog.json.dcat.description</xsl:when>
			<xsl:when test='$key = &quot;catalog.json.dcat.format&quot; '>i18n.catalog.json.dcat.format</xsl:when>
			<xsl:when test='$key = &quot;catalog.json.dcat.identifier&quot; '>i18n.catalog.json.dcat.identifier</xsl:when>
			<xsl:when test='$key = &quot;catalog.json.dcat.keyword&quot; '>i18n.catalog.json.dcat.keyword</xsl:when>
			<xsl:when test='$key = &quot;catalog.json.dcat.license&quot; '>i18n.catalog.json.dcat.license</xsl:when>
			<xsl:when test='$key = &quot;catalog.json.dcat.mbox&quot; '>i18n.catalog.json.dcat.mbox</xsl:when>
			<xsl:when test='$key = &quot;catalog.json.dcat.modified&quot; '>i18n.catalog.json.dcat.modified</xsl:when>
			<xsl:when test='$key = &quot;catalog.json.dcat.programCode&quot; '>i18n.catalog.json.dcat.programCode</xsl:when>
			<xsl:when test='$key = &quot;catalog.json.dcat.publisher&quot; '>i18n.catalog.json.dcat.publisher</xsl:when>
			<xsl:when test='$key = &quot;catalog.json.dcat.spatial&quot; '>i18n.catalog.json.dcat.spatial</xsl:when>
			<xsl:when test='$key = &quot;catalog.json.dcat.temporal&quot; '>i18n.catalog.json.dcat.temporal</xsl:when>
			<xsl:when test='$key = &quot;catalog.json.dcat.title&quot; '>i18n.catalog.json.dcat.title</xsl:when>
			<xsl:when test='$key = &quot;catalog.json.dcat.webService&quot; '>i18n.catalog.json.dcat.webService</xsl:when>
			<xsl:when test='$key = &quot;catalog.main.home.caption&quot; '>i18n.catalog.main.home.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.main.home.menuCaption&quot; '>i18n.catalog.main.home.menuCaption</xsl:when>
			<xsl:when test='$key = &quot;catalog.main.home.prompt&quot; '>i18n.catalog.main.home.prompt</xsl:when>
			<xsl:when test='$key = &quot;catalog.main.home.topic.beAUser&quot; '>i18n.catalog.main.home.topic.beAUser</xsl:when>
			<xsl:when test='$key = &quot;catalog.main.home.topic.beAUser.create&quot; '>i18n.catalog.main.home.topic.beAUser.create</xsl:when>
			<xsl:when test='$key = &quot;catalog.main.home.topic.beAUser.saveSearch&quot; '>i18n.catalog.main.home.topic.beAUser.saveSearch</xsl:when>
			<xsl:when test='$key = &quot;catalog.main.home.topic.findData&quot; '>i18n.catalog.main.home.topic.findData</xsl:when>
			<xsl:when test='$key = &quot;catalog.main.home.topic.findData.downloadData&quot; '>i18n.catalog.main.home.topic.findData.downloadData</xsl:when>
			<xsl:when test='$key = &quot;catalog.main.home.topic.findData.searchData&quot; '>i18n.catalog.main.home.topic.findData.searchData</xsl:when>
			<xsl:when test='$key = &quot;catalog.main.home.topic.shareData&quot; '>i18n.catalog.main.home.topic.shareData</xsl:when>
			<xsl:when test='$key = &quot;catalog.main.home.topic.shareData.createMetadata&quot; '>i18n.catalog.main.home.topic.shareData.createMetadata</xsl:when>
			<xsl:when test='$key = &quot;catalog.main.home.topic.shareData.publishData&quot; '>i18n.catalog.main.home.topic.shareData.publishData</xsl:when>
			<xsl:when test='$key = &quot;catalog.main.home.topic.shareData.uploadData&quot; '>i18n.catalog.main.home.topic.shareData.uploadData</xsl:when>
			<xsl:when test='$key = &quot;catalog.main.home.youCanDoMore&quot; '>i18n.catalog.main.home.youCanDoMore</xsl:when>
			<xsl:when test='$key = &quot;catalog.main.home.youCanSimply&quot; '>i18n.catalog.main.home.youCanSimply</xsl:when>
			<xsl:when test='$key = &quot;catalog.manage.user.listAGroup&quot; '>i18n.catalog.manage.user.listAGroup</xsl:when>
			<xsl:when test='$key = &quot;catalog.manage.user.role.add&quot; '>i18n.catalog.manage.user.role.add</xsl:when>
			<xsl:when test='$key = &quot;catalog.manage.user.role.addConfirmation&quot; '>i18n.catalog.manage.user.role.addConfirmation</xsl:when>
			<xsl:when test='$key = &quot;catalog.manage.user.role.configurableRoles&quot; '>i18n.catalog.manage.user.role.configurableRoles</xsl:when>
			<xsl:when test='$key = &quot;catalog.manage.user.role.deleteUser&quot; '>i18n.catalog.manage.user.role.deleteUser</xsl:when>
			<xsl:when test='$key = &quot;catalog.manage.user.role.deleteUserConfirmation&quot; '>i18n.catalog.manage.user.role.deleteUserConfirmation</xsl:when>
			<xsl:when test='$key = &quot;catalog.manage.user.role.memberOf&quot; '>i18n.catalog.manage.user.role.memberOf</xsl:when>
			<xsl:when test='$key = &quot;catalog.manage.user.role.remove&quot; '>i18n.catalog.manage.user.role.remove</xsl:when>
			<xsl:when test='$key = &quot;catalog.manage.user.role.removeConfirmation&quot; '>i18n.catalog.manage.user.role.removeConfirmation</xsl:when>
			<xsl:when test='$key = &quot;catalog.manage.user.role.role&quot; '>i18n.catalog.manage.user.role.role</xsl:when>
			<xsl:when test='$key = &quot;catalog.manage.user.role.searchResults&quot; '>i18n.catalog.manage.user.role.searchResults</xsl:when>
			<xsl:when test='$key = &quot;catalog.manage.user.role.searchUser&quot; '>i18n.catalog.manage.user.role.searchUser</xsl:when>
			<xsl:when test='$key = &quot;catalog.manage.user.role.userAttributes&quot; '>i18n.catalog.manage.user.role.userAttributes</xsl:when>
			<xsl:when test='$key = &quot;catalog.manage.user.search&quot; '>i18n.catalog.manage.user.search</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.boolean.false&quot; '>i18n.catalog.mdCode.boolean.false</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.boolean.true&quot; '>i18n.catalog.mdCode.boolean.true</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.cellGeometry.area&quot; '>i18n.catalog.mdCode.cellGeometry.area</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.cellGeometry.point&quot; '>i18n.catalog.mdCode.cellGeometry.point</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.characterSet.8859part1&quot; '>i18n.catalog.mdCode.characterSet.8859part1</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.characterSet.8859part10&quot; '>i18n.catalog.mdCode.characterSet.8859part10</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.characterSet.8859part11&quot; '>i18n.catalog.mdCode.characterSet.8859part11</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.characterSet.8859part13&quot; '>i18n.catalog.mdCode.characterSet.8859part13</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.characterSet.8859part14&quot; '>i18n.catalog.mdCode.characterSet.8859part14</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.characterSet.8859part15&quot; '>i18n.catalog.mdCode.characterSet.8859part15</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.characterSet.8859part16&quot; '>i18n.catalog.mdCode.characterSet.8859part16</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.characterSet.8859part2&quot; '>i18n.catalog.mdCode.characterSet.8859part2</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.characterSet.8859part3&quot; '>i18n.catalog.mdCode.characterSet.8859part3</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.characterSet.8859part4&quot; '>i18n.catalog.mdCode.characterSet.8859part4</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.characterSet.8859part5&quot; '>i18n.catalog.mdCode.characterSet.8859part5</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.characterSet.8859part6&quot; '>i18n.catalog.mdCode.characterSet.8859part6</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.characterSet.8859part7&quot; '>i18n.catalog.mdCode.characterSet.8859part7</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.characterSet.8859part8&quot; '>i18n.catalog.mdCode.characterSet.8859part8</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.characterSet.8859part9&quot; '>i18n.catalog.mdCode.characterSet.8859part9</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.characterSet.big5&quot; '>i18n.catalog.mdCode.characterSet.big5</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.characterSet.ebcdic&quot; '>i18n.catalog.mdCode.characterSet.ebcdic</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.characterSet.eucJP&quot; '>i18n.catalog.mdCode.characterSet.eucJP</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.characterSet.eucKR&quot; '>i18n.catalog.mdCode.characterSet.eucKR</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.characterSet.GB2312&quot; '>i18n.catalog.mdCode.characterSet.GB2312</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.characterSet.jis&quot; '>i18n.catalog.mdCode.characterSet.jis</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.characterSet.shiftJIS&quot; '>i18n.catalog.mdCode.characterSet.shiftJIS</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.characterSet.ucs2&quot; '>i18n.catalog.mdCode.characterSet.ucs2</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.characterSet.ucs4&quot; '>i18n.catalog.mdCode.characterSet.ucs4</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.characterSet.usAscii&quot; '>i18n.catalog.mdCode.characterSet.usAscii</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.characterSet.utf16&quot; '>i18n.catalog.mdCode.characterSet.utf16</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.characterSet.utf7&quot; '>i18n.catalog.mdCode.characterSet.utf7</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.characterSet.utf8&quot; '>i18n.catalog.mdCode.characterSet.utf8</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.compliance.compliant&quot; '>i18n.catalog.mdCode.compliance.compliant</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.compliance.notCompliant&quot; '>i18n.catalog.mdCode.compliance.notCompliant</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.coperationDCP.COM&quot; '>i18n.catalog.mdCode.coperationDCP.COM</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.couplingType.loose&quot; '>i18n.catalog.mdCode.couplingType.loose</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.couplingType.mixed&quot; '>i18n.catalog.mdCode.couplingType.mixed</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.couplingType.tight&quot; '>i18n.catalog.mdCode.couplingType.tight</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.coverageContentType.physicalMeasurement&quot; '>i18n.catalog.mdCode.coverageContentType.physicalMeasurement</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.coverageContentType.thematicClassification&quot; '>i18n.catalog.mdCode.coverageContentType.thematicClassification</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.custodian.author&quot; '>i18n.catalog.mdCode.custodian.author</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.custodian.custodian&quot; '>i18n.catalog.mdCode.custodian.custodian</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.custodian.distributor&quot; '>i18n.catalog.mdCode.custodian.distributor</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.custodian.originator&quot; '>i18n.catalog.mdCode.custodian.originator</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.custodian.owner&quot; '>i18n.catalog.mdCode.custodian.owner</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.custodian.pointOfContact&quot; '>i18n.catalog.mdCode.custodian.pointOfContact</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.custodian.principalInvestigator&quot; '>i18n.catalog.mdCode.custodian.principalInvestigator</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.custodian.processor&quot; '>i18n.catalog.mdCode.custodian.processor</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.custodian.publisher&quot; '>i18n.catalog.mdCode.custodian.publisher</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.custodian.resourceProvider&quot; '>i18n.catalog.mdCode.custodian.resourceProvider</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.custodian.user&quot; '>i18n.catalog.mdCode.custodian.user</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.dataType.grid&quot; '>i18n.catalog.mdCode.dataType.grid</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.dataType.stereoModel&quot; '>i18n.catalog.mdCode.dataType.stereoModel</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.dataType.textTable&quot; '>i18n.catalog.mdCode.dataType.textTable</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.dataType.tin&quot; '>i18n.catalog.mdCode.dataType.tin</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.dataType.vector&quot; '>i18n.catalog.mdCode.dataType.vector</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.dataType.video&quot; '>i18n.catalog.mdCode.dataType.video</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.dateType.creation&quot; '>i18n.catalog.mdCode.dateType.creation</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.dateType.publication&quot; '>i18n.catalog.mdCode.dateType.publication</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.dateType.revision&quot; '>i18n.catalog.mdCode.dateType.revision</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.dimensionNameType.column&quot; '>i18n.catalog.mdCode.dimensionNameType.column</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.dimensionNameType.crossTrack&quot; '>i18n.catalog.mdCode.dimensionNameType.crossTrack</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.dimensionNameType.line&quot; '>i18n.catalog.mdCode.dimensionNameType.line</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.dimensionNameType.row&quot; '>i18n.catalog.mdCode.dimensionNameType.row</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.dimensionNameType.sample&quot; '>i18n.catalog.mdCode.dimensionNameType.sample</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.dimensionNameType.time&quot; '>i18n.catalog.mdCode.dimensionNameType.time</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.dimensionNameType.track&quot; '>i18n.catalog.mdCode.dimensionNameType.track</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.dimensionNameType.vertical&quot; '>i18n.catalog.mdCode.dimensionNameType.vertical</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.frequency.annually&quot; '>i18n.catalog.mdCode.frequency.annually</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.frequency.asNeeded&quot; '>i18n.catalog.mdCode.frequency.asNeeded</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.frequency.continual&quot; '>i18n.catalog.mdCode.frequency.continual</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.frequency.daily&quot; '>i18n.catalog.mdCode.frequency.daily</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.frequency.irregular&quot; '>i18n.catalog.mdCode.frequency.irregular</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.frequency.monthly&quot; '>i18n.catalog.mdCode.frequency.monthly</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.frequency.notPlanned&quot; '>i18n.catalog.mdCode.frequency.notPlanned</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.frequency.unknown&quot; '>i18n.catalog.mdCode.frequency.unknown</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.frequency.weekly&quot; '>i18n.catalog.mdCode.frequency.weekly</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.hierarchyLevel.attribute&quot; '>i18n.catalog.mdCode.hierarchyLevel.attribute</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.hierarchyLevel.attributeType&quot; '>i18n.catalog.mdCode.hierarchyLevel.attributeType</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.hierarchyLevel.collectionHardware&quot; '>i18n.catalog.mdCode.hierarchyLevel.collectionHardware</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.hierarchyLevel.collectionSession&quot; '>i18n.catalog.mdCode.hierarchyLevel.collectionSession</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.hierarchyLevel.dataset&quot; '>i18n.catalog.mdCode.hierarchyLevel.dataset</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.hierarchyLevel.dimensionGroup&quot; '>i18n.catalog.mdCode.hierarchyLevel.dimensionGroup</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.hierarchyLevel.dimentionGroup&quot; '>i18n.catalog.mdCode.hierarchyLevel.dimentionGroup</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.hierarchyLevel.feature&quot; '>i18n.catalog.mdCode.hierarchyLevel.feature</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.hierarchyLevel.featureType&quot; '>i18n.catalog.mdCode.hierarchyLevel.featureType</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.hierarchyLevel.fieldSession&quot; '>i18n.catalog.mdCode.hierarchyLevel.fieldSession</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.hierarchyLevel.model&quot; '>i18n.catalog.mdCode.hierarchyLevel.model</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.hierarchyLevel.nonGeographicDataset&quot; '>i18n.catalog.mdCode.hierarchyLevel.nonGeographicDataset</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.hierarchyLevel.propertyType&quot; '>i18n.catalog.mdCode.hierarchyLevel.propertyType</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.hierarchyLevel.series&quot; '>i18n.catalog.mdCode.hierarchyLevel.series</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.hierarchyLevel.service&quot; '>i18n.catalog.mdCode.hierarchyLevel.service</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.hierarchyLevel.software&quot; '>i18n.catalog.mdCode.hierarchyLevel.software</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.hierarchyLevel.tile&quot; '>i18n.catalog.mdCode.hierarchyLevel.tile</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.imagingCondition.blurredImage&quot; '>i18n.catalog.mdCode.imagingCondition.blurredImage</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.imagingCondition.cloud&quot; '>i18n.catalog.mdCode.imagingCondition.cloud</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.imagingCondition.degradingObliquity&quot; '>i18n.catalog.mdCode.imagingCondition.degradingObliquity</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.imagingCondition.fog&quot; '>i18n.catalog.mdCode.imagingCondition.fog</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.imagingCondition.heavySmokeOrDust&quot; '>i18n.catalog.mdCode.imagingCondition.heavySmokeOrDust</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.imagingCondition.night&quot; '>i18n.catalog.mdCode.imagingCondition.night</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.imagingCondition.rain&quot; '>i18n.catalog.mdCode.imagingCondition.rain</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.imagingCondition.semiDarkness&quot; '>i18n.catalog.mdCode.imagingCondition.semiDarkness</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.imagingCondition.shadow&quot; '>i18n.catalog.mdCode.imagingCondition.shadow</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.imagingCondition.snow&quot; '>i18n.catalog.mdCode.imagingCondition.snow</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.imagingCondition.terrainMasking&quot; '>i18n.catalog.mdCode.imagingCondition.terrainMasking</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.iso19110.CI_RoleCode.author&quot; '>i18n.catalog.mdCode.iso19110.CI_RoleCode.author</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.iso19110.CI_RoleCode.custodian&quot; '>i18n.catalog.mdCode.iso19110.CI_RoleCode.custodian</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.iso19110.CI_RoleCode.distributor&quot; '>i18n.catalog.mdCode.iso19110.CI_RoleCode.distributor</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.iso19110.CI_RoleCode.originator&quot; '>i18n.catalog.mdCode.iso19110.CI_RoleCode.originator</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.iso19110.CI_RoleCode.owner&quot; '>i18n.catalog.mdCode.iso19110.CI_RoleCode.owner</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.iso19110.CI_RoleCode.pointOfContact&quot; '>i18n.catalog.mdCode.iso19110.CI_RoleCode.pointOfContact</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.iso19110.CI_RoleCode.principalInvestigator&quot; '>i18n.catalog.mdCode.iso19110.CI_RoleCode.principalInvestigator</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.iso19110.CI_RoleCode.processor&quot; '>i18n.catalog.mdCode.iso19110.CI_RoleCode.processor</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.iso19110.CI_RoleCode.publisher&quot; '>i18n.catalog.mdCode.iso19110.CI_RoleCode.publisher</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.iso19110.CI_RoleCode.resourceProvider&quot; '>i18n.catalog.mdCode.iso19110.CI_RoleCode.resourceProvider</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.iso19110.CI_RoleCode.user&quot; '>i18n.catalog.mdCode.iso19110.CI_RoleCode.user</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.iso19110.valueTypeCode.binary&quot; '>i18n.catalog.mdCode.iso19110.valueTypeCode.binary</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.iso19110.valueTypeCode.blob&quot; '>i18n.catalog.mdCode.iso19110.valueTypeCode.blob</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.iso19110.valueTypeCode.boolean&quot; '>i18n.catalog.mdCode.iso19110.valueTypeCode.boolean</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.iso19110.valueTypeCode.character&quot; '>i18n.catalog.mdCode.iso19110.valueTypeCode.character</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.iso19110.valueTypeCode.date&quot; '>i18n.catalog.mdCode.iso19110.valueTypeCode.date</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.iso19110.valueTypeCode.double&quot; '>i18n.catalog.mdCode.iso19110.valueTypeCode.double</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.iso19110.valueTypeCode.float&quot; '>i18n.catalog.mdCode.iso19110.valueTypeCode.float</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.iso19110.valueTypeCode.geometry&quot; '>i18n.catalog.mdCode.iso19110.valueTypeCode.geometry</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.iso19110.valueTypeCode.integer&quot; '>i18n.catalog.mdCode.iso19110.valueTypeCode.integer</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.iso19110.valueTypeCode.number&quot; '>i18n.catalog.mdCode.iso19110.valueTypeCode.number</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.iso19110.valueTypeCode.OID&quot; '>i18n.catalog.mdCode.iso19110.valueTypeCode.OID</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.iso19110.valueTypeCode.single&quot; '>i18n.catalog.mdCode.iso19110.valueTypeCode.single</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.iso19110.valueTypeCode.smallinteger&quot; '>i18n.catalog.mdCode.iso19110.valueTypeCode.smallinteger</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.iso19110.valueTypeCode.string&quot; '>i18n.catalog.mdCode.iso19110.valueTypeCode.string</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.language.iso639_2.bul&quot; '>i18n.catalog.mdCode.language.iso639_2.bul</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.language.iso639_2.chi&quot; '>i18n.catalog.mdCode.language.iso639_2.chi</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.language.iso639_2.cor&quot; '>i18n.catalog.mdCode.language.iso639_2.cor</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.language.iso639_2.cym&quot; '>i18n.catalog.mdCode.language.iso639_2.cym</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.language.iso639_2.cze&quot; '>i18n.catalog.mdCode.language.iso639_2.cze</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.language.iso639_2.dan&quot; '>i18n.catalog.mdCode.language.iso639_2.dan</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.language.iso639_2.dut&quot; '>i18n.catalog.mdCode.language.iso639_2.dut</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.language.iso639_2.eng&quot; '>i18n.catalog.mdCode.language.iso639_2.eng</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.language.iso639_2.est&quot; '>i18n.catalog.mdCode.language.iso639_2.est</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.language.iso639_2.fin&quot; '>i18n.catalog.mdCode.language.iso639_2.fin</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.language.iso639_2.fre&quot; '>i18n.catalog.mdCode.language.iso639_2.fre</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.language.iso639_2.ger&quot; '>i18n.catalog.mdCode.language.iso639_2.ger</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.language.iso639_2.gla&quot; '>i18n.catalog.mdCode.language.iso639_2.gla</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.language.iso639_2.gle&quot; '>i18n.catalog.mdCode.language.iso639_2.gle</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.language.iso639_2.gle&quot; '>i18n.catalog.mdCode.language.iso639_2.gle</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.language.iso639_2.gre&quot; '>i18n.catalog.mdCode.language.iso639_2.gre</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.language.iso639_2.hun&quot; '>i18n.catalog.mdCode.language.iso639_2.hun</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.language.iso639_2.ita&quot; '>i18n.catalog.mdCode.language.iso639_2.ita</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.language.iso639_2.kor&quot; '>i18n.catalog.mdCode.language.iso639_2.kor</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.language.iso639_2.lav&quot; '>i18n.catalog.mdCode.language.iso639_2.lav</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.language.iso639_2.lit&quot; '>i18n.catalog.mdCode.language.iso639_2.lit</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.language.iso639_2.mlt&quot; '>i18n.catalog.mdCode.language.iso639_2.mlt</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.language.iso639_2.nor&quot; '>i18n.catalog.mdCode.language.iso639_2.nor</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.language.iso639_2.pol&quot; '>i18n.catalog.mdCode.language.iso639_2.pol</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.language.iso639_2.por&quot; '>i18n.catalog.mdCode.language.iso639_2.por</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.language.iso639_2.rum&quot; '>i18n.catalog.mdCode.language.iso639_2.rum</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.language.iso639_2.rus&quot; '>i18n.catalog.mdCode.language.iso639_2.rus</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.language.iso639_2.sco&quot; '>i18n.catalog.mdCode.language.iso639_2.sco</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.language.iso639_2.slo&quot; '>i18n.catalog.mdCode.language.iso639_2.slo</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.language.iso639_2.slv&quot; '>i18n.catalog.mdCode.language.iso639_2.slv</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.language.iso639_2.spa&quot; '>i18n.catalog.mdCode.language.iso639_2.spa</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.language.iso639_2.swe&quot; '>i18n.catalog.mdCode.language.iso639_2.swe</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.language.iso639_2.tur&quot; '>i18n.catalog.mdCode.language.iso639_2.tur</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCode.bessel_cassini-soldner&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCode.bessel_cassini-soldner</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCode.bessel_sanson-flamsteed&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCode.bessel_sanson-flamsteed</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCode.catasto_locale&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCode.catasto_locale</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCode.ed50&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCode.ed50</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCode.ed50_utm32n&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCode.ed50_utm32n</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCode.ed50_utm33n&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCode.ed50_utm33n</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCode.etrf00&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCode.etrf00</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCode.etrf89&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCode.etrf89</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCode.etrs89&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCode.etrs89</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCode.etrs89_etrs-laea&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCode.etrs89_etrs-laea</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCode.etrs89_etrs-lcc&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCode.etrs89_etrs-lcc</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCode.etrs89_etrs-tm32&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCode.etrs89_etrs-tm32</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCode.etrs89_etrs-tm33&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCode.etrs89_etrs-tm33</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCode.etrs89_utm-zone32N&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCode.etrs89_utm-zone32N</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCode.etrs89_utm-zone33N&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCode.etrs89_utm-zone33N</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCode.igb00&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCode.igb00</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCode.igm95&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCode.igm95</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCode.igm95_utm32n&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCode.igm95_utm32n</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCode.igm95_utm33n&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCode.igm95_utm33n</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCode.igsxx&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCode.igsxx</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCode.itrfxx&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCode.itrfxx</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCode.itrs&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCode.itrs</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCode.livellomedioaltemareesigiziali&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCode.livellomedioaltemareesigiziali</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCode.livellomediobassemareesigiziali&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCode.livellomediobassemareesigiziali</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCode.livellomediolago&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCode.livellomediolago</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCode.rete_altimetrica_nazionale&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCode.rete_altimetrica_nazionale</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCode.roma40&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCode.roma40</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCode.roma40_est&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCode.roma40_est</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCode.roma40_ovest&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCode.roma40_ovest</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCode.roma40_roma&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCode.roma40_roma</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCode.wgs84&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCode.wgs84</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCode.wgs84_3d&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCode.wgs84_3d</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCode.wgs84_utm32n&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCode.wgs84_utm32n</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCode.wgs84_utm33n&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCode.wgs84_utm33n</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCode.wgs84_utm34n&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCode.wgs84_utm34n</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCodeInspire.ETRS89-GRS80&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCodeInspire.ETRS89-GRS80</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCodeInspire.ETRS89-GRS80&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCodeInspire.ETRS89-GRS80</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCodeInspire.ETRS89-GRS80h&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCodeInspire.ETRS89-GRS80h</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCodeInspire.ETRS89-LAEA&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCodeInspire.ETRS89-LAEA</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCodeInspire.ETRS89-LCC&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCodeInspire.ETRS89-LCC</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCodeInspire.ETRS89-TM26N&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCodeInspire.ETRS89-TM26N</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCodeInspire.ETRS89-TM27N&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCodeInspire.ETRS89-TM27N</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCodeInspire.ETRS89-TM28N&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCodeInspire.ETRS89-TM28N</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCodeInspire.ETRS89-TM29N&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCodeInspire.ETRS89-TM29N</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCodeInspire.ETRS89-TM30N&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCodeInspire.ETRS89-TM30N</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCodeInspire.ETRS89-TM31N&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCodeInspire.ETRS89-TM31N</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCodeInspire.ETRS89-TM32N&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCodeInspire.ETRS89-TM32N</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCodeInspire.ETRS89-TM33N&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCodeInspire.ETRS89-TM33N</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCodeInspire.ETRS89-TM34N&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCodeInspire.ETRS89-TM34N</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCodeInspire.ETRS89-TM35N&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCodeInspire.ETRS89-TM35N</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCodeInspire.ETRS89-TM36N&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCodeInspire.ETRS89-TM36N</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCodeInspire.ETRS89-TM37N&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCodeInspire.ETRS89-TM37N</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCodeInspire.ETRS89-TM38N&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCodeInspire.ETRS89-TM38N</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCodeInspire.ETRS89-TM39N&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCodeInspire.ETRS89-TM39N</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCodeInspire.ETRS89-XYZ&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCodeInspire.ETRS89-XYZ</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCodeInspire.EVRS&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCodeInspire.EVRS</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCodeInspireH.ETRS89-GRS80&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCodeInspireH.ETRS89-GRS80</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCodeInspireH.ETRS89-GRS80-EVRS&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCodeInspireH.ETRS89-GRS80-EVRS</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCodeInspireH.ETRS89-GRS80h&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCodeInspireH.ETRS89-GRS80h</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCodeInspireH.ETRS89-LAEA&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCodeInspireH.ETRS89-LAEA</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCodeInspireH.ETRS89-LCC&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCodeInspireH.ETRS89-LCC</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCodeInspireH.ETRS89-TM26N&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCodeInspireH.ETRS89-TM26N</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCodeInspireH.ETRS89-TM27N&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCodeInspireH.ETRS89-TM27N</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCodeInspireH.ETRS89-TM28N&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCodeInspireH.ETRS89-TM28N</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCodeInspireH.ETRS89-TM29N&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCodeInspireH.ETRS89-TM29N</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCodeInspireH.ETRS89-TM30N&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCodeInspireH.ETRS89-TM30N</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCodeInspireH.ETRS89-TM31N&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCodeInspireH.ETRS89-TM31N</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCodeInspireH.ETRS89-TM32N&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCodeInspireH.ETRS89-TM32N</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCodeInspireH.ETRS89-TM33N&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCodeInspireH.ETRS89-TM33N</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCodeInspireH.ETRS89-TM34N&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCodeInspireH.ETRS89-TM34N</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCodeInspireH.ETRS89-TM35N&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCodeInspireH.ETRS89-TM35N</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCodeInspireH.ETRS89-TM36N&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCodeInspireH.ETRS89-TM36N</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCodeInspireH.ETRS89-TM37N&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCodeInspireH.ETRS89-TM37N</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCodeInspireH.ETRS89-TM38N&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCodeInspireH.ETRS89-TM38N</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCodeInspireH.ETRS89-TM39N&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCodeInspireH.ETRS89-TM39N</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCodeInspireH.ETRS89-XYZ&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCodeInspireH.ETRS89-XYZ</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.MD_ReferenceSystemCodeInspireH.EVRS&quot; '>i18n.catalog.mdCode.MD_ReferenceSystemCodeInspireH.EVRS</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.OneGeology.CI_DateTypeCode.publication&quot; '>i18n.catalog.mdCode.OneGeology.CI_DateTypeCode.publication</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.onLineFunctionCode.download&quot; '>i18n.catalog.mdCode.onLineFunctionCode.download</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.onLineFunctionCode.information&quot; '>i18n.catalog.mdCode.onLineFunctionCode.information</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.onLineFunctionCode.offlineAccess&quot; '>i18n.catalog.mdCode.onLineFunctionCode.offlineAccess</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.onLineFunctionCode.order&quot; '>i18n.catalog.mdCode.onLineFunctionCode.order</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.onLineFunctionCode.search&quot; '>i18n.catalog.mdCode.onLineFunctionCode.search</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.opendata.eurovoc.100142&quot; '>i18n.catalog.mdCode.opendata.eurovoc.100142</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.opendata.eurovoc.100143&quot; '>i18n.catalog.mdCode.opendata.eurovoc.100143</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.opendata.eurovoc.100144&quot; '>i18n.catalog.mdCode.opendata.eurovoc.100144</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.opendata.eurovoc.100145&quot; '>i18n.catalog.mdCode.opendata.eurovoc.100145</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.opendata.eurovoc.100146&quot; '>i18n.catalog.mdCode.opendata.eurovoc.100146</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.opendata.eurovoc.100147&quot; '>i18n.catalog.mdCode.opendata.eurovoc.100147</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.opendata.eurovoc.100148&quot; '>i18n.catalog.mdCode.opendata.eurovoc.100148</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.opendata.eurovoc.100149&quot; '>i18n.catalog.mdCode.opendata.eurovoc.100149</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.opendata.eurovoc.100150&quot; '>i18n.catalog.mdCode.opendata.eurovoc.100150</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.opendata.eurovoc.100151&quot; '>i18n.catalog.mdCode.opendata.eurovoc.100151</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.opendata.eurovoc.100152&quot; '>i18n.catalog.mdCode.opendata.eurovoc.100152</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.opendata.eurovoc.100153&quot; '>i18n.catalog.mdCode.opendata.eurovoc.100153</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.opendata.eurovoc.100154&quot; '>i18n.catalog.mdCode.opendata.eurovoc.100154</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.opendata.eurovoc.100155&quot; '>i18n.catalog.mdCode.opendata.eurovoc.100155</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.opendata.eurovoc.100156&quot; '>i18n.catalog.mdCode.opendata.eurovoc.100156</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.opendata.eurovoc.100157&quot; '>i18n.catalog.mdCode.opendata.eurovoc.100157</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.opendata.eurovoc.100158&quot; '>i18n.catalog.mdCode.opendata.eurovoc.100158</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.opendata.eurovoc.100159&quot; '>i18n.catalog.mdCode.opendata.eurovoc.100159</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.opendata.eurovoc.100160&quot; '>i18n.catalog.mdCode.opendata.eurovoc.100160</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.opendata.eurovoc.100161&quot; '>i18n.catalog.mdCode.opendata.eurovoc.100161</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.opendata.eurovoc.100162&quot; '>i18n.catalog.mdCode.opendata.eurovoc.100162</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.opendata.theme2.RischioAmbientale&quot; '>i18n.catalog.mdCode.opendata.theme2.RischioAmbientale</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.opendata.theme2.RischioIncendi&quot; '>i18n.catalog.mdCode.opendata.theme2.RischioIncendi</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.opendata.theme2.RischioIndustriale&quot; '>i18n.catalog.mdCode.opendata.theme2.RischioIndustriale</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.opendata.theme2.RischioMaremoto&quot; '>i18n.catalog.mdCode.opendata.theme2.RischioMaremoto</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.opendata.theme2.RischioMeteoIdro&quot; '>i18n.catalog.mdCode.opendata.theme2.RischioMeteoIdro</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.opendata.theme2.RischioNucleare&quot; '>i18n.catalog.mdCode.opendata.theme2.RischioNucleare</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.opendata.theme2.RischioSanitario&quot; '>i18n.catalog.mdCode.opendata.theme2.RischioSanitario</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.opendata.theme2.RischioSismico&quot; '>i18n.catalog.mdCode.opendata.theme2.RischioSismico</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.opendata.theme2.RischioVulcanico&quot; '>i18n.catalog.mdCode.opendata.theme2.RischioVulcanico</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.opendata.theme2.Trasparenza&quot; '>i18n.catalog.mdCode.opendata.theme2.Trasparenza</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.opendata.type.CSV&quot; '>i18n.catalog.mdCode.opendata.type.CSV</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.opendata.type.DBF&quot; '>i18n.catalog.mdCode.opendata.type.DBF</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.opendata.type.DOC&quot; '>i18n.catalog.mdCode.opendata.type.DOC</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.opendata.type.ODP&quot; '>i18n.catalog.mdCode.opendata.type.ODP</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.opendata.type.ODS&quot; '>i18n.catalog.mdCode.opendata.type.ODS</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.opendata.type.ODT&quot; '>i18n.catalog.mdCode.opendata.type.ODT</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.opendata.type.PDF&quot; '>i18n.catalog.mdCode.opendata.type.PDF</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.opendata.type.SHP&quot; '>i18n.catalog.mdCode.opendata.type.SHP</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.opendata.type.XLS&quot; '>i18n.catalog.mdCode.opendata.type.XLS</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.opendata.type.XML&quot; '>i18n.catalog.mdCode.opendata.type.XML</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.opendata.type.ZIP&quot; '>i18n.catalog.mdCode.opendata.type.ZIP</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.operationDCP.COBRA&quot; '>i18n.catalog.mdCode.operationDCP.COBRA</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.operationDCP.JAVA&quot; '>i18n.catalog.mdCode.operationDCP.JAVA</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.operationDCP.SQL&quot; '>i18n.catalog.mdCode.operationDCP.SQL</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.operationDCP.WebServices&quot; '>i18n.catalog.mdCode.operationDCP.WebServices</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.operationDCP.XML&quot; '>i18n.catalog.mdCode.operationDCP.XML</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.other&quot; '>i18n.catalog.mdCode.other</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.pointInPixel.center&quot; '>i18n.catalog.mdCode.pointInPixel.center</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.pointInPixel.lowerLeft&quot; '>i18n.catalog.mdCode.pointInPixel.lowerLeft</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.pointInPixel.lowerRight&quot; '>i18n.catalog.mdCode.pointInPixel.lowerRight</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.pointInPixel.upperLeft&quot; '>i18n.catalog.mdCode.pointInPixel.upperLeft</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.pointInPixel.upperRight&quot; '>i18n.catalog.mdCode.pointInPixel.upperRight</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.presentationForm.documentDigital&quot; '>i18n.catalog.mdCode.presentationForm.documentDigital</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.presentationForm.documentHardcopy&quot; '>i18n.catalog.mdCode.presentationForm.documentHardcopy</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.presentationForm.imageDigital&quot; '>i18n.catalog.mdCode.presentationForm.imageDigital</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.presentationForm.imageHardcopy&quot; '>i18n.catalog.mdCode.presentationForm.imageHardcopy</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.presentationForm.mapDigital&quot; '>i18n.catalog.mdCode.presentationForm.mapDigital</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.presentationForm.mapHardcopy&quot; '>i18n.catalog.mdCode.presentationForm.mapHardcopy</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.presentationForm.modelDigital&quot; '>i18n.catalog.mdCode.presentationForm.modelDigital</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.presentationForm.modelHardcopy&quot; '>i18n.catalog.mdCode.presentationForm.modelHardcopy</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.presentationForm.profileDigital&quot; '>i18n.catalog.mdCode.presentationForm.profileDigital</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.presentationForm.profileHardcopy&quot; '>i18n.catalog.mdCode.presentationForm.profileHardcopy</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.presentationForm.tableDigital&quot; '>i18n.catalog.mdCode.presentationForm.tableDigital</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.presentationForm.tableHardcopy&quot; '>i18n.catalog.mdCode.presentationForm.tableHardcopy</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.presentationForm.videoDigital&quot; '>i18n.catalog.mdCode.presentationForm.videoDigital</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.presentationForm.videoHardcopy&quot; '>i18n.catalog.mdCode.presentationForm.videoHardcopy</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.progress.completed&quot; '>i18n.catalog.mdCode.progress.completed</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.progress.inWork&quot; '>i18n.catalog.mdCode.progress.inWork</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.progress.planned&quot; '>i18n.catalog.mdCode.progress.planned</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.resourceType.urn_ogc_dataFormat_GML_2.0&quot; '>i18n.catalog.mdCode.resourceType.urn_ogc_dataFormat_GML_2.0</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.resourceType.urn_ogc_dataFormat_GML_2.1.1&quot; '>i18n.catalog.mdCode.resourceType.urn_ogc_dataFormat_GML_2.1.1</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.resourceType.urn_ogc_dataFormat_GML_2.1.2&quot; '>i18n.catalog.mdCode.resourceType.urn_ogc_dataFormat_GML_2.1.2</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.resourceType.urn_ogc_dataFormat_GML_3.0&quot; '>i18n.catalog.mdCode.resourceType.urn_ogc_dataFormat_GML_3.0</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.resourceType.urn_ogc_dataFormat_GML_3.1.1&quot; '>i18n.catalog.mdCode.resourceType.urn_ogc_dataFormat_GML_3.1.1</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.resourceType.urn_ogc_serviceType_CatalogueService_2.0.1_CORBA&quot; '>i18n.catalog.mdCode.resourceType.urn_ogc_serviceType_CatalogueService_2.0.1_CORBA</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.resourceType.urn_ogc_serviceType_CatalogueService_2.0.1_HTTP&quot; '>i18n.catalog.mdCode.resourceType.urn_ogc_serviceType_CatalogueService_2.0.1_HTTP</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.resourceType.urn_ogc_serviceType_CatalogueService_2.0.1_HTTP_ebRIM&quot; '>i18n.catalog.mdCode.resourceType.urn_ogc_serviceType_CatalogueService_2.0.1_HTTP_ebRIM</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.resourceType.urn_ogc_serviceType_CatalogueService_2.0.1_HTTP_EO&quot; '>i18n.catalog.mdCode.resourceType.urn_ogc_serviceType_CatalogueService_2.0.1_HTTP_EO</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.resourceType.urn_ogc_serviceType_CatalogueService_2.0.1_HTTP_FGDC_CSDGM&quot; '>i18n.catalog.mdCode.resourceType.urn_ogc_serviceType_CatalogueService_2.0.1_HTTP_FGDC_CSDGM</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.resourceType.urn_ogc_serviceType_CatalogueService_2.0.1_HTTP_ISO19115_19119&quot; '>i18n.catalog.mdCode.resourceType.urn_ogc_serviceType_CatalogueService_2.0.1_HTTP_ISO19115_19119</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.resourceType.urn_ogc_serviceType_CatalogueService_2.0.1_Z39.50&quot; '>i18n.catalog.mdCode.resourceType.urn_ogc_serviceType_CatalogueService_2.0.1_Z39.50</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.resourceType.urn_ogc_serviceType_CatalogueService_2.0.1_Z39.50_GEOProfile&quot; '>i18n.catalog.mdCode.resourceType.urn_ogc_serviceType_CatalogueService_2.0.1_Z39.50_GEOProfile</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.resourceType.urn_ogc_serviceType_CatalogueService_2.0.1_Z39.50_SRU&quot; '>i18n.catalog.mdCode.resourceType.urn_ogc_serviceType_CatalogueService_2.0.1_Z39.50_SRU</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.resourceType.urn_ogc_serviceType_CatalogueService_2.0.2_CORBA&quot; '>i18n.catalog.mdCode.resourceType.urn_ogc_serviceType_CatalogueService_2.0.2_CORBA</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.resourceType.urn_ogc_serviceType_CatalogueService_2.0.2_HTTP&quot; '>i18n.catalog.mdCode.resourceType.urn_ogc_serviceType_CatalogueService_2.0.2_HTTP</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.resourceType.urn_ogc_serviceType_CatalogueService_2.0.2_HTTP_ebRIM&quot; '>i18n.catalog.mdCode.resourceType.urn_ogc_serviceType_CatalogueService_2.0.2_HTTP_ebRIM</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.resourceType.urn_ogc_serviceType_CatalogueService_2.0.2_HTTP_EO&quot; '>i18n.catalog.mdCode.resourceType.urn_ogc_serviceType_CatalogueService_2.0.2_HTTP_EO</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.resourceType.urn_ogc_serviceType_CatalogueService_2.0.2_HTTP_FGDC_CSDGM&quot; '>i18n.catalog.mdCode.resourceType.urn_ogc_serviceType_CatalogueService_2.0.2_HTTP_FGDC_CSDGM</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.resourceType.urn_ogc_serviceType_CatalogueService_2.0.2_HTTP_ISO19115_19119&quot; '>i18n.catalog.mdCode.resourceType.urn_ogc_serviceType_CatalogueService_2.0.2_HTTP_ISO19115_19119</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.resourceType.urn_ogc_serviceType_CatalogueService_2.0.2_Z39.50&quot; '>i18n.catalog.mdCode.resourceType.urn_ogc_serviceType_CatalogueService_2.0.2_Z39.50</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.resourceType.urn_ogc_serviceType_CoordinateTransformationService_1.0&quot; '>i18n.catalog.mdCode.resourceType.urn_ogc_serviceType_CoordinateTransformationService_1.0</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.resourceType.urn_ogc_serviceType_CoordinateTransformationService_1.0_COM&quot; '>i18n.catalog.mdCode.resourceType.urn_ogc_serviceType_CoordinateTransformationService_1.0_COM</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.resourceType.urn_ogc_serviceType_CoordinateTransformationService_1.0_CORBA&quot; '>i18n.catalog.mdCode.resourceType.urn_ogc_serviceType_CoordinateTransformationService_1.0_CORBA</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.resourceType.urn_ogc_serviceType_CoordinateTransformationService_1.0_Java&quot; '>i18n.catalog.mdCode.resourceType.urn_ogc_serviceType_CoordinateTransformationService_1.0_Java</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.resourceType.urn_ogc_serviceType_GridCoverage_1.0_COM&quot; '>i18n.catalog.mdCode.resourceType.urn_ogc_serviceType_GridCoverage_1.0_COM</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.resourceType.urn_ogc_serviceType_GridCoverage_1.0_CORBA&quot; '>i18n.catalog.mdCode.resourceType.urn_ogc_serviceType_GridCoverage_1.0_CORBA</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.resourceType.urn_ogc_serviceType_KML_2.2&quot; '>i18n.catalog.mdCode.resourceType.urn_ogc_serviceType_KML_2.2</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.resourceType.urn_ogc_serviceType_OpenLSCoreServices_1.0&quot; '>i18n.catalog.mdCode.resourceType.urn_ogc_serviceType_OpenLSCoreServices_1.0</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.resourceType.urn_ogc_serviceType_OpenLSCoreServices_1.0_SOAP&quot; '>i18n.catalog.mdCode.resourceType.urn_ogc_serviceType_OpenLSCoreServices_1.0_SOAP</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.resourceType.urn_ogc_serviceType_OpenLSCoreServices_1.1&quot; '>i18n.catalog.mdCode.resourceType.urn_ogc_serviceType_OpenLSCoreServices_1.1</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.resourceType.urn_ogc_serviceType_SensorObservationService_1.0&quot; '>i18n.catalog.mdCode.resourceType.urn_ogc_serviceType_SensorObservationService_1.0</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.resourceType.urn_ogc_serviceType_SimpleFeatureAccess_1.0_CORBA&quot; '>i18n.catalog.mdCode.resourceType.urn_ogc_serviceType_SimpleFeatureAccess_1.0_CORBA</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.resourceType.urn_ogc_serviceType_SimpleFeatureAccess_1.1_OLE_COM&quot; '>i18n.catalog.mdCode.resourceType.urn_ogc_serviceType_SimpleFeatureAccess_1.1_OLE_COM</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.resourceType.urn_ogc_serviceType_SimpleFeatureAccess_1.1_SQL&quot; '>i18n.catalog.mdCode.resourceType.urn_ogc_serviceType_SimpleFeatureAccess_1.1_SQL</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.resourceType.urn_ogc_serviceType_SimpleFeatureAccess_1.2_SQL&quot; '>i18n.catalog.mdCode.resourceType.urn_ogc_serviceType_SimpleFeatureAccess_1.2_SQL</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.resourceType.urn_ogc_serviceType_WebCoverageService_1.0&quot; '>i18n.catalog.mdCode.resourceType.urn_ogc_serviceType_WebCoverageService_1.0</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.resourceType.urn_ogc_serviceType_WebCoverageService_1.1.0&quot; '>i18n.catalog.mdCode.resourceType.urn_ogc_serviceType_WebCoverageService_1.1.0</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.resourceType.urn_ogc_serviceType_WebFeatureService_1.0&quot; '>i18n.catalog.mdCode.resourceType.urn_ogc_serviceType_WebFeatureService_1.0</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.resourceType.urn_ogc_serviceType_WebFeatureService_1.1&quot; '>i18n.catalog.mdCode.resourceType.urn_ogc_serviceType_WebFeatureService_1.1</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.resourceType.urn_ogc_serviceType_WebMapService_1.0&quot; '>i18n.catalog.mdCode.resourceType.urn_ogc_serviceType_WebMapService_1.0</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.resourceType.urn_ogc_serviceType_WebMapService_1.1&quot; '>i18n.catalog.mdCode.resourceType.urn_ogc_serviceType_WebMapService_1.1</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.resourceType.urn_ogc_serviceType_WebMapService_1.1.1&quot; '>i18n.catalog.mdCode.resourceType.urn_ogc_serviceType_WebMapService_1.1.1</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.resourceType.urn_ogc_serviceType_WebMapService_1.3.0&quot; '>i18n.catalog.mdCode.resourceType.urn_ogc_serviceType_WebMapService_1.3.0</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.resourceType.urn_ogc_serviceType_WebMapService_Post_0.0.3&quot; '>i18n.catalog.mdCode.resourceType.urn_ogc_serviceType_WebMapService_Post_0.0.3</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.resourceType.urn_ogc_serviceType_WebProcessingService_0.4&quot; '>i18n.catalog.mdCode.resourceType.urn_ogc_serviceType_WebProcessingService_0.4</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.resourceType.urn_x_esri_specification_ServiceType_ArcGIS&quot; '>i18n.catalog.mdCode.resourceType.urn_x_esri_specification_ServiceType_ArcGIS</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.resourceType.urn_x_esri_specification_ServiceType_ArcIMS&quot; '>i18n.catalog.mdCode.resourceType.urn_x_esri_specification_ServiceType_ArcIMS</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.CI_DateTypeCode.creation&quot; '>i18n.catalog.mdCode.rndt.CI_DateTypeCode.creation</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.CI_DateTypeCode.publication&quot; '>i18n.catalog.mdCode.rndt.CI_DateTypeCode.publication</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.CI_DateTypeCode.revision&quot; '>i18n.catalog.mdCode.rndt.CI_DateTypeCode.revision</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.CI_DateTypeCode.rilievo&quot; '>i18n.catalog.mdCode.rndt.CI_DateTypeCode.rilievo</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.CI_PresentationFormCode.documentDigital&quot; '>i18n.catalog.mdCode.rndt.CI_PresentationFormCode.documentDigital</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.CI_PresentationFormCode.documentHardcopy&quot; '>i18n.catalog.mdCode.rndt.CI_PresentationFormCode.documentHardcopy</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.CI_PresentationFormCode.imageDigital&quot; '>i18n.catalog.mdCode.rndt.CI_PresentationFormCode.imageDigital</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.CI_PresentationFormCode.imageHardcopy&quot; '>i18n.catalog.mdCode.rndt.CI_PresentationFormCode.imageHardcopy</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.CI_PresentationFormCode.mapDigital&quot; '>i18n.catalog.mdCode.rndt.CI_PresentationFormCode.mapDigital</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.CI_PresentationFormCode.mapHardcopy&quot; '>i18n.catalog.mdCode.rndt.CI_PresentationFormCode.mapHardcopy</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.CI_PresentationFormCode.modelDigital&quot; '>i18n.catalog.mdCode.rndt.CI_PresentationFormCode.modelDigital</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.CI_PresentationFormCode.modelHardcopy&quot; '>i18n.catalog.mdCode.rndt.CI_PresentationFormCode.modelHardcopy</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.CI_PresentationFormCode.profileDigital&quot; '>i18n.catalog.mdCode.rndt.CI_PresentationFormCode.profileDigital</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.CI_PresentationFormCode.profileHardcopy&quot; '>i18n.catalog.mdCode.rndt.CI_PresentationFormCode.profileHardcopy</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.CI_PresentationFormCode.tableDigital&quot; '>i18n.catalog.mdCode.rndt.CI_PresentationFormCode.tableDigital</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.CI_PresentationFormCode.tableHardcopy&quot; '>i18n.catalog.mdCode.rndt.CI_PresentationFormCode.tableHardcopy</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.CI_PresentationFormCode.videoDigital&quot; '>i18n.catalog.mdCode.rndt.CI_PresentationFormCode.videoDigital</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.CI_PresentationFormCode.videoHardcopy&quot; '>i18n.catalog.mdCode.rndt.CI_PresentationFormCode.videoHardcopy</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.CI_RoleCode.author&quot; '>i18n.catalog.mdCode.rndt.CI_RoleCode.author</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.CI_RoleCode.custodian&quot; '>i18n.catalog.mdCode.rndt.CI_RoleCode.custodian</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.CI_RoleCode.distributor&quot; '>i18n.catalog.mdCode.rndt.CI_RoleCode.distributor</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.CI_RoleCode.originator&quot; '>i18n.catalog.mdCode.rndt.CI_RoleCode.originator</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.CI_RoleCode.owner&quot; '>i18n.catalog.mdCode.rndt.CI_RoleCode.owner</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.CI_RoleCode.pointOfContact&quot; '>i18n.catalog.mdCode.rndt.CI_RoleCode.pointOfContact</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.CI_RoleCode.principalInvestigator&quot; '>i18n.catalog.mdCode.rndt.CI_RoleCode.principalInvestigator</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.CI_RoleCode.processor&quot; '>i18n.catalog.mdCode.rndt.CI_RoleCode.processor</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.CI_RoleCode.publisher&quot; '>i18n.catalog.mdCode.rndt.CI_RoleCode.publisher</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.CI_RoleCode.resourceProvider&quot; '>i18n.catalog.mdCode.rndt.CI_RoleCode.resourceProvider</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.CI_RoleCode.user&quot; '>i18n.catalog.mdCode.rndt.CI_RoleCode.user</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.couplingType.loose&quot; '>i18n.catalog.mdCode.rndt.couplingType.loose</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.couplingType.mixed&quot; '>i18n.catalog.mdCode.rndt.couplingType.mixed</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.couplingType.tight&quot; '>i18n.catalog.mdCode.rndt.couplingType.tight</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.DCPList.com&quot; '>i18n.catalog.mdCode.rndt.DCPList.com</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.DCPList.corba&quot; '>i18n.catalog.mdCode.rndt.DCPList.corba</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.DCPList.java&quot; '>i18n.catalog.mdCode.rndt.DCPList.java</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.DCPList.sql&quot; '>i18n.catalog.mdCode.rndt.DCPList.sql</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.DCPList.webservices&quot; '>i18n.catalog.mdCode.rndt.DCPList.webservices</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.DCPList.xml&quot; '>i18n.catalog.mdCode.rndt.DCPList.xml</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.addresses&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.addresses</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.administrativeUnits&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.administrativeUnits</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.agriculturalAndAquacultureFacilities&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.agriculturalAndAquacultureFacilities</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.areaManagementRestrictionRegulationZonesAndReportingUnits&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.areaManagementRestrictionRegulationZonesAndReportingUnits</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.atmosphericConditions&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.atmosphericConditions</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.bioGeographicalRegions&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.bioGeographicalRegions</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.buildings&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.buildings</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.cadastralParcels&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.cadastralParcels</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.conf.addresses&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.conf.addresses</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.conf.administrativeUnits&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.conf.administrativeUnits</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.conf.agriculturalAndAquacultureFacilities&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.conf.agriculturalAndAquacultureFacilities</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.conf.areaManagementRestrictionRegulationZonesAndReportingUnits&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.conf.areaManagementRestrictionRegulationZonesAndReportingUnits</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.conf.atmosphericConditions&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.conf.atmosphericConditions</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.conf.bioGeographicalRegions&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.conf.bioGeographicalRegions</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.conf.buildings&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.conf.buildings</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.conf.cadastralParcels&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.conf.cadastralParcels</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.conf.coordinateReferenceSystems&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.conf.coordinateReferenceSystems</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.conf.elevation&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.conf.elevation</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.conf.energyResources&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.conf.energyResources</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.conf.environmentalMonitoringFacilities&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.conf.environmentalMonitoringFacilities</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.conf.geographicalGridSystems&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.conf.geographicalGridSystems</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.conf.geographicalNames&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.conf.geographicalNames</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.conf.geology&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.conf.geology</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.conf.habitatsAndBiotopes&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.conf.habitatsAndBiotopes</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.conf.humanHealthAndSafety&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.conf.humanHealthAndSafety</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.conf.hydrography&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.conf.hydrography</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.conf.landCover&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.conf.landCover</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.conf.landUser&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.conf.landUser</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.conf.meteorologicalGeographicalFeatures&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.conf.meteorologicalGeographicalFeatures</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.conf.mineralResources&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.conf.mineralResources</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.conf.naturalRiskZones&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.conf.naturalRiskZones</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.conf.oceanographicGeographicalFeatures&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.conf.oceanographicGeographicalFeatures</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.conf.orthoimagery&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.conf.orthoimagery</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.conf.populationDistributionDemography&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.conf.populationDistributionDemography</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.conf.productionAndIndustrialFacilities&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.conf.productionAndIndustrialFacilities</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.conf.protectedSites&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.conf.protectedSites</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.conf.seaRegions&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.conf.seaRegions</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.conf.soil&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.conf.soil</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.conf.speciesDistribution&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.conf.speciesDistribution</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.conf.statisticalUnits&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.conf.statisticalUnits</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.conf.transportNetworks&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.conf.transportNetworks</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.conf.utilityAndGovernmentService&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.conf.utilityAndGovernmentService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.coordinateReferenceSystems&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.coordinateReferenceSystems</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.elevation&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.elevation</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.energyResources&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.energyResources</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.environmentalMonitoringFacilities&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.environmentalMonitoringFacilities</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.geographicalGridSystems&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.geographicalGridSystems</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.geographicalNames&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.geographicalNames</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.geology&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.geology</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.habitatsAndBiotopes&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.habitatsAndBiotopes</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.humanHealthAndSafety&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.humanHealthAndSafety</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.hydrography&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.hydrography</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.INSPIRETheme&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.INSPIRETheme</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.landCover&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.landCover</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.landUser&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.landUser</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.meteorologicalGeographicalFeatures&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.meteorologicalGeographicalFeatures</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.mineralResources&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.mineralResources</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.naturalRiskZones&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.naturalRiskZones</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.oceanographicGeographicalFeatures&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.oceanographicGeographicalFeatures</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.orthoimagery&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.orthoimagery</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.populationDistributionDemography&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.populationDistributionDemography</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.productionAndIndustrialFacilities&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.productionAndIndustrialFacilities</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.protectedSites&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.protectedSites</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.seaRegions&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.seaRegions</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.soil&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.soil</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.speciesDistribution&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.speciesDistribution</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.statisticalUnits&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.statisticalUnits</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.transportNetworks&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.transportNetworks</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.GEMET.dataTheme.utilityAndGovernmentService&quot; '>i18n.catalog.mdCode.rndt.GEMET.dataTheme.utilityAndGovernmentService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_CellGeometryCode.area&quot; '>i18n.catalog.mdCode.rndt.MD_CellGeometryCode.area</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_CellGeometryCode.point&quot; '>i18n.catalog.mdCode.rndt.MD_CellGeometryCode.point</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_ClassificationCode.confidential&quot; '>i18n.catalog.mdCode.rndt.MD_ClassificationCode.confidential</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_ClassificationCode.restricted&quot; '>i18n.catalog.mdCode.rndt.MD_ClassificationCode.restricted</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_ClassificationCode.secret&quot; '>i18n.catalog.mdCode.rndt.MD_ClassificationCode.secret</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_ClassificationCode.topSecret&quot; '>i18n.catalog.mdCode.rndt.MD_ClassificationCode.topSecret</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_ClassificationCode.unclassified&quot; '>i18n.catalog.mdCode.rndt.MD_ClassificationCode.unclassified</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_CoverageContentTypeCode.image&quot; '>i18n.catalog.mdCode.rndt.MD_CoverageContentTypeCode.image</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_CoverageContentTypeCode.physicalMeasurement&quot; '>i18n.catalog.mdCode.rndt.MD_CoverageContentTypeCode.physicalMeasurement</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_CoverageContentTypeCode.thematicClassification&quot; '>i18n.catalog.mdCode.rndt.MD_CoverageContentTypeCode.thematicClassification</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_DimensionNameTypeCode.column&quot; '>i18n.catalog.mdCode.rndt.MD_DimensionNameTypeCode.column</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_DimensionNameTypeCode.crossTrack&quot; '>i18n.catalog.mdCode.rndt.MD_DimensionNameTypeCode.crossTrack</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_DimensionNameTypeCode.line&quot; '>i18n.catalog.mdCode.rndt.MD_DimensionNameTypeCode.line</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_DimensionNameTypeCode.row&quot; '>i18n.catalog.mdCode.rndt.MD_DimensionNameTypeCode.row</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_DimensionNameTypeCode.sample&quot; '>i18n.catalog.mdCode.rndt.MD_DimensionNameTypeCode.sample</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_DimensionNameTypeCode.time&quot; '>i18n.catalog.mdCode.rndt.MD_DimensionNameTypeCode.time</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_DimensionNameTypeCode.track&quot; '>i18n.catalog.mdCode.rndt.MD_DimensionNameTypeCode.track</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_DimensionNameTypeCode.vertical&quot; '>i18n.catalog.mdCode.rndt.MD_DimensionNameTypeCode.vertical</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_MaintenanceFrequencyCode.annually&quot; '>i18n.catalog.mdCode.rndt.MD_MaintenanceFrequencyCode.annually</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_MaintenanceFrequencyCode.asNeeded&quot; '>i18n.catalog.mdCode.rndt.MD_MaintenanceFrequencyCode.asNeeded</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_MaintenanceFrequencyCode.biannually&quot; '>i18n.catalog.mdCode.rndt.MD_MaintenanceFrequencyCode.biannually</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_MaintenanceFrequencyCode.continual&quot; '>i18n.catalog.mdCode.rndt.MD_MaintenanceFrequencyCode.continual</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_MaintenanceFrequencyCode.daily&quot; '>i18n.catalog.mdCode.rndt.MD_MaintenanceFrequencyCode.daily</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_MaintenanceFrequencyCode.fortnightly&quot; '>i18n.catalog.mdCode.rndt.MD_MaintenanceFrequencyCode.fortnightly</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_MaintenanceFrequencyCode.irregular&quot; '>i18n.catalog.mdCode.rndt.MD_MaintenanceFrequencyCode.irregular</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_MaintenanceFrequencyCode.monthly&quot; '>i18n.catalog.mdCode.rndt.MD_MaintenanceFrequencyCode.monthly</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_MaintenanceFrequencyCode.notPlanned&quot; '>i18n.catalog.mdCode.rndt.MD_MaintenanceFrequencyCode.notPlanned</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_MaintenanceFrequencyCode.quarterly&quot; '>i18n.catalog.mdCode.rndt.MD_MaintenanceFrequencyCode.quarterly</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_MaintenanceFrequencyCode.unknown&quot; '>i18n.catalog.mdCode.rndt.MD_MaintenanceFrequencyCode.unknown</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_MaintenanceFrequencyCode.weekly&quot; '>i18n.catalog.mdCode.rndt.MD_MaintenanceFrequencyCode.weekly</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_PixelOrientationCode.center&quot; '>i18n.catalog.mdCode.rndt.MD_PixelOrientationCode.center</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_PixelOrientationCode.lowerLeft&quot; '>i18n.catalog.mdCode.rndt.MD_PixelOrientationCode.lowerLeft</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_PixelOrientationCode.lowerRight&quot; '>i18n.catalog.mdCode.rndt.MD_PixelOrientationCode.lowerRight</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_PixelOrientationCode.upperLeft&quot; '>i18n.catalog.mdCode.rndt.MD_PixelOrientationCode.upperLeft</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_PixelOrientationCode.upperRight&quot; '>i18n.catalog.mdCode.rndt.MD_PixelOrientationCode.upperRight</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_RestrictionCode.copyright&quot; '>i18n.catalog.mdCode.rndt.MD_RestrictionCode.copyright</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_RestrictionCode.intellectualPropertyRights&quot; '>i18n.catalog.mdCode.rndt.MD_RestrictionCode.intellectualPropertyRights</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_RestrictionCode.license&quot; '>i18n.catalog.mdCode.rndt.MD_RestrictionCode.license</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_RestrictionCode.otherRestrictions&quot; '>i18n.catalog.mdCode.rndt.MD_RestrictionCode.otherRestrictions</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_RestrictionCode.patent&quot; '>i18n.catalog.mdCode.rndt.MD_RestrictionCode.patent</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_RestrictionCode.patentPending&quot; '>i18n.catalog.mdCode.rndt.MD_RestrictionCode.patentPending</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_RestrictionCode.pubblico&quot; '>i18n.catalog.mdCode.rndt.MD_RestrictionCode.pubblico</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_RestrictionCode.restricted&quot; '>i18n.catalog.mdCode.rndt.MD_RestrictionCode.restricted</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_RestrictionCode.trademark&quot; '>i18n.catalog.mdCode.rndt.MD_RestrictionCode.trademark</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_ScopeCode.dataset&quot; '>i18n.catalog.mdCode.rndt.MD_ScopeCode.dataset</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_ScopeCode.series&quot; '>i18n.catalog.mdCode.rndt.MD_ScopeCode.series</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_ScopeCode.service&quot; '>i18n.catalog.mdCode.rndt.MD_ScopeCode.service</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_ScopeCode.tile&quot; '>i18n.catalog.mdCode.rndt.MD_ScopeCode.tile</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_SpatialRepresentationTypeCode.grid&quot; '>i18n.catalog.mdCode.rndt.MD_SpatialRepresentationTypeCode.grid</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_SpatialRepresentationTypeCode.textTable&quot; '>i18n.catalog.mdCode.rndt.MD_SpatialRepresentationTypeCode.textTable</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_SpatialRepresentationTypeCode.tin&quot; '>i18n.catalog.mdCode.rndt.MD_SpatialRepresentationTypeCode.tin</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_SpatialRepresentationTypeCode.vector&quot; '>i18n.catalog.mdCode.rndt.MD_SpatialRepresentationTypeCode.vector</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_TopicCategoryCode.biota&quot; '>i18n.catalog.mdCode.rndt.MD_TopicCategoryCode.biota</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_TopicCategoryCode.boundaries&quot; '>i18n.catalog.mdCode.rndt.MD_TopicCategoryCode.boundaries</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_TopicCategoryCode.climatologyMeteorologyAtmosphere&quot; '>i18n.catalog.mdCode.rndt.MD_TopicCategoryCode.climatologyMeteorologyAtmosphere</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_TopicCategoryCode.economy&quot; '>i18n.catalog.mdCode.rndt.MD_TopicCategoryCode.economy</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_TopicCategoryCode.elevation&quot; '>i18n.catalog.mdCode.rndt.MD_TopicCategoryCode.elevation</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_TopicCategoryCode.environment&quot; '>i18n.catalog.mdCode.rndt.MD_TopicCategoryCode.environment</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_TopicCategoryCode.farming&quot; '>i18n.catalog.mdCode.rndt.MD_TopicCategoryCode.farming</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_TopicCategoryCode.geoscientificInformation&quot; '>i18n.catalog.mdCode.rndt.MD_TopicCategoryCode.geoscientificInformation</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_TopicCategoryCode.health&quot; '>i18n.catalog.mdCode.rndt.MD_TopicCategoryCode.health</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_TopicCategoryCode.imageryBaseMapsEarthCover&quot; '>i18n.catalog.mdCode.rndt.MD_TopicCategoryCode.imageryBaseMapsEarthCover</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_TopicCategoryCode.inlandWaters&quot; '>i18n.catalog.mdCode.rndt.MD_TopicCategoryCode.inlandWaters</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_TopicCategoryCode.intelligenceMilitary&quot; '>i18n.catalog.mdCode.rndt.MD_TopicCategoryCode.intelligenceMilitary</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_TopicCategoryCode.location&quot; '>i18n.catalog.mdCode.rndt.MD_TopicCategoryCode.location</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_TopicCategoryCode.oceans&quot; '>i18n.catalog.mdCode.rndt.MD_TopicCategoryCode.oceans</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_TopicCategoryCode.planningCadastre&quot; '>i18n.catalog.mdCode.rndt.MD_TopicCategoryCode.planningCadastre</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_TopicCategoryCode.society&quot; '>i18n.catalog.mdCode.rndt.MD_TopicCategoryCode.society</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_TopicCategoryCode.structure&quot; '>i18n.catalog.mdCode.rndt.MD_TopicCategoryCode.structure</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_TopicCategoryCode.transportation&quot; '>i18n.catalog.mdCode.rndt.MD_TopicCategoryCode.transportation</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.MD_TopicCategoryCode.utilitiesCommunication&quot; '>i18n.catalog.mdCode.rndt.MD_TopicCategoryCode.utilitiesCommunication</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.serviceType.discovery&quot; '>i18n.catalog.mdCode.rndt.serviceType.discovery</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.serviceType.download&quot; '>i18n.catalog.mdCode.rndt.serviceType.download</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.serviceType.invoke&quot; '>i18n.catalog.mdCode.rndt.serviceType.invoke</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.serviceType.other&quot; '>i18n.catalog.mdCode.rndt.serviceType.other</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.serviceType.transformation&quot; '>i18n.catalog.mdCode.rndt.serviceType.transformation</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.rndt.serviceType.view&quot; '>i18n.catalog.mdCode.rndt.serviceType.view</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.scope.attribute&quot; '>i18n.catalog.mdCode.scope.attribute</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.scope.attributeType&quot; '>i18n.catalog.mdCode.scope.attributeType</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.scope.collectionHardware&quot; '>i18n.catalog.mdCode.scope.collectionHardware</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.scope.collectionSession&quot; '>i18n.catalog.mdCode.scope.collectionSession</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.scope.dataset&quot; '>i18n.catalog.mdCode.scope.dataset</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.scope.dimensionGroup&quot; '>i18n.catalog.mdCode.scope.dimensionGroup</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.scope.feature&quot; '>i18n.catalog.mdCode.scope.feature</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.scope.featureType&quot; '>i18n.catalog.mdCode.scope.featureType</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.scope.fieldSession&quot; '>i18n.catalog.mdCode.scope.fieldSession</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.scope.model&quot; '>i18n.catalog.mdCode.scope.model</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.scope.nonGeographicDataset&quot; '>i18n.catalog.mdCode.scope.nonGeographicDataset</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.scope.propertyType&quot; '>i18n.catalog.mdCode.scope.propertyType</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.scope.series&quot; '>i18n.catalog.mdCode.scope.series</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.scope.service&quot; '>i18n.catalog.mdCode.scope.service</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.scope.software&quot; '>i18n.catalog.mdCode.scope.software</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.scope.tile&quot; '>i18n.catalog.mdCode.scope.tile</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.status.completed&quot; '>i18n.catalog.mdCode.status.completed</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.status.historicalArchive&quot; '>i18n.catalog.mdCode.status.historicalArchive</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.status.obsolete&quot; '>i18n.catalog.mdCode.status.obsolete</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.status.onGoing&quot; '>i18n.catalog.mdCode.status.onGoing</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.status.planned&quot; '>i18n.catalog.mdCode.status.planned</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.status.required&quot; '>i18n.catalog.mdCode.status.required</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.status.underDevelopment&quot; '>i18n.catalog.mdCode.status.underDevelopment</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.topic.biota&quot; '>i18n.catalog.mdCode.topic.biota</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.topic.boundaries&quot; '>i18n.catalog.mdCode.topic.boundaries</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.topic.climatologyMeteorologyAtmosphere&quot; '>i18n.catalog.mdCode.topic.climatologyMeteorologyAtmosphere</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.topic.economy&quot; '>i18n.catalog.mdCode.topic.economy</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.topic.elevation&quot; '>i18n.catalog.mdCode.topic.elevation</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.topic.environment&quot; '>i18n.catalog.mdCode.topic.environment</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.topic.farming&quot; '>i18n.catalog.mdCode.topic.farming</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.topic.geoscientificInformation&quot; '>i18n.catalog.mdCode.topic.geoscientificInformation</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.topic.health&quot; '>i18n.catalog.mdCode.topic.health</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.topic.imageryBaseMapsEarthCover&quot; '>i18n.catalog.mdCode.topic.imageryBaseMapsEarthCover</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.topic.inlandWaters&quot; '>i18n.catalog.mdCode.topic.inlandWaters</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.topic.intelligenceMilitary&quot; '>i18n.catalog.mdCode.topic.intelligenceMilitary</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.topic.location&quot; '>i18n.catalog.mdCode.topic.location</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.topic.oceans&quot; '>i18n.catalog.mdCode.topic.oceans</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.topic.planningCadastre&quot; '>i18n.catalog.mdCode.topic.planningCadastre</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.topic.society&quot; '>i18n.catalog.mdCode.topic.society</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.topic.structure&quot; '>i18n.catalog.mdCode.topic.structure</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.topic.transportation&quot; '>i18n.catalog.mdCode.topic.transportation</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.topic.utilitiesCommunication&quot; '>i18n.catalog.mdCode.topic.utilitiesCommunication</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.unitOfMeasure.feet&quot; '>i18n.catalog.mdCode.unitOfMeasure.feet</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.unitOfMeasure.meters&quot; '>i18n.catalog.mdCode.unitOfMeasure.meters</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.unitOfMeasure.millimeters&quot; '>i18n.catalog.mdCode.unitOfMeasure.millimeters</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.yesOrNo.no&quot; '>i18n.catalog.mdCode.yesOrNo.no</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdCode.yesOrNo.yes&quot; '>i18n.catalog.mdCode.yesOrNo.yes</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.citation.caption&quot; '>i18n.catalog.mdParam.citation.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.citation.edition&quot; '>i18n.catalog.mdParam.citation.edition</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.citation.originator&quot; '>i18n.catalog.mdParam.citation.originator</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.citation.presentationForm&quot; '>i18n.catalog.mdParam.citation.presentationForm</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.citation.publicationDate&quot; '>i18n.catalog.mdParam.citation.publicationDate</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.citation.publicationPlace&quot; '>i18n.catalog.mdParam.citation.publicationPlace</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.citation.publisher&quot; '>i18n.catalog.mdParam.citation.publisher</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.constraint.caption&quot; '>i18n.catalog.mdParam.constraint.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.constraint.metadata.caption&quot; '>i18n.catalog.mdParam.constraint.metadata.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.constraint.metadataAccessibility&quot; '>i18n.catalog.mdParam.constraint.metadataAccessibility</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.constraint.metadataClassification&quot; '>i18n.catalog.mdParam.constraint.metadataClassification</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.constraint.metadataClassificationSystem&quot; '>i18n.catalog.mdParam.constraint.metadataClassificationSystem</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.constraint.metadataReleasability&quot; '>i18n.catalog.mdParam.constraint.metadataReleasability</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.constraint.metadataUseLimitation&quot; '>i18n.catalog.mdParam.constraint.metadataUseLimitation</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.constraint.none.caption&quot; '>i18n.catalog.mdParam.constraint.none.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.constraint.resourceAccessibility&quot; '>i18n.catalog.mdParam.constraint.resourceAccessibility</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.constraint.resourceClassification&quot; '>i18n.catalog.mdParam.constraint.resourceClassification</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.constraint.resourceClassificationSystem&quot; '>i18n.catalog.mdParam.constraint.resourceClassificationSystem</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.constraint.resourceReleasability&quot; '>i18n.catalog.mdParam.constraint.resourceReleasability</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.constraint.resourceUseLimitation&quot; '>i18n.catalog.mdParam.constraint.resourceUseLimitation</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.constraint.security.caption&quot; '>i18n.catalog.mdParam.constraint.security.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.contact.address.address&quot; '>i18n.catalog.mdParam.contact.address.address</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.contact.address.city&quot; '>i18n.catalog.mdParam.contact.address.city</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.contact.address.country&quot; '>i18n.catalog.mdParam.contact.address.country</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.contact.address.postalCode&quot; '>i18n.catalog.mdParam.contact.address.postalCode</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.contact.address.state&quot; '>i18n.catalog.mdParam.contact.address.state</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.contact.caption&quot; '>i18n.catalog.mdParam.contact.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.contact.email&quot; '>i18n.catalog.mdParam.contact.email</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.contact.faxNumber&quot; '>i18n.catalog.mdParam.contact.faxNumber</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.contact.onlineResource&quot; '>i18n.catalog.mdParam.contact.onlineResource</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.contact.organization&quot; '>i18n.catalog.mdParam.contact.organization</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.contact.person&quot; '>i18n.catalog.mdParam.contact.person</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.contact.phoneNumber&quot; '>i18n.catalog.mdParam.contact.phoneNumber</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.contact.position&quot; '>i18n.catalog.mdParam.contact.position</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.contentInfo.caption&quot; '>i18n.catalog.mdParam.contentInfo.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.contentInfo.coverageDescription.caption&quot; '>i18n.catalog.mdParam.contentInfo.coverageDescription.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.contentInfo.coverageDescription.contentType&quot; '>i18n.catalog.mdParam.contentInfo.coverageDescription.contentType</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.contentInfo.featureCatalogDescription.caption&quot; '>i18n.catalog.mdParam.contentInfo.featureCatalogDescription.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.contentInfo.featureCatalogDescription.complianceCode&quot; '>i18n.catalog.mdParam.contentInfo.featureCatalogDescription.complianceCode</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.contentInfo.featureCatalogDescription.includedWithDataset&quot; '>i18n.catalog.mdParam.contentInfo.featureCatalogDescription.includedWithDataset</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.contentInfo.featureCatalogDescription.language&quot; '>i18n.catalog.mdParam.contentInfo.featureCatalogDescription.language</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.contentInfo.imageDescription.caption&quot; '>i18n.catalog.mdParam.contentInfo.imageDescription.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.contentInfo.imageDescription.cloudCoverPercentage&quot; '>i18n.catalog.mdParam.contentInfo.imageDescription.cloudCoverPercentage</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.contentInfo.imageDescription.compressionGenerationQuantity&quot; '>i18n.catalog.mdParam.contentInfo.imageDescription.compressionGenerationQuantity</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.contentInfo.imageDescription.illuminationAzimuthAngle&quot; '>i18n.catalog.mdParam.contentInfo.imageDescription.illuminationAzimuthAngle</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.contentInfo.imageDescription.illuminationElevationAngle&quot; '>i18n.catalog.mdParam.contentInfo.imageDescription.illuminationElevationAngle</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.contentInfo.imageDescription.imageQualityCode&quot; '>i18n.catalog.mdParam.contentInfo.imageDescription.imageQualityCode</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.contentInfo.imageDescription.imagingCondition&quot; '>i18n.catalog.mdParam.contentInfo.imageDescription.imagingCondition</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.contentInfo.imageDescription.processingLevelCode&quot; '>i18n.catalog.mdParam.contentInfo.imageDescription.processingLevelCode</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.contentInfo.resourceType&quot; '>i18n.catalog.mdParam.contentInfo.resourceType</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.contentType.caption&quot; '>i18n.catalog.mdParam.contentType.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.contentType.content&quot; '>i18n.catalog.mdParam.contentType.content</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.contentType.content.application&quot; '>i18n.catalog.mdParam.contentType.content.application</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.contentType.content.clearinghouse&quot; '>i18n.catalog.mdParam.contentType.content.clearinghouse</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.contentType.content.downloadableData&quot; '>i18n.catalog.mdParam.contentType.content.downloadableData</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.contentType.content.geographicActivities&quot; '>i18n.catalog.mdParam.contentType.content.geographicActivities</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.contentType.content.geographicService&quot; '>i18n.catalog.mdParam.contentType.content.geographicService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.contentType.content.liveData&quot; '>i18n.catalog.mdParam.contentType.content.liveData</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.contentType.content.mapFiles&quot; '>i18n.catalog.mdParam.contentType.content.mapFiles</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.contentType.content.offlineData&quot; '>i18n.catalog.mdParam.contentType.content.offlineData</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.contentType.content.other&quot; '>i18n.catalog.mdParam.contentType.content.other</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.contentType.content.staticMapImage&quot; '>i18n.catalog.mdParam.contentType.content.staticMapImage</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.contentType.content.unknown&quot; '>i18n.catalog.mdParam.contentType.content.unknown</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.copyFrom.field&quot; '>i18n.catalog.mdParam.copyFrom.field</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.coupledresource.caption&quot; '>i18n.catalog.mdParam.coupledresource.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.data.caption&quot; '>i18n.catalog.mdParam.data.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.data.distance&quot; '>i18n.catalog.mdParam.data.distance</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.data.equivalentScale&quot; '>i18n.catalog.mdParam.data.equivalentScale</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.data.format&quot; '>i18n.catalog.mdParam.data.format</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.data.scale&quot; '>i18n.catalog.mdParam.data.scale</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.data.scale.note&quot; '>i18n.catalog.mdParam.data.scale.note</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.data.type&quot; '>i18n.catalog.mdParam.data.type</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.dataEStandard.caption&quot; '>i18n.catalog.mdParam.dataEStandard.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.dataQualityInfo.caption&quot; '>i18n.catalog.mdParam.dataQualityInfo.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.dataQualityInfo.lineage&quot; '>i18n.catalog.mdParam.dataQualityInfo.lineage</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.dataQualityInfo.scope&quot; '>i18n.catalog.mdParam.dataQualityInfo.scope</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.dataQualityInfo.scope.attribute&quot; '>i18n.catalog.mdParam.dataQualityInfo.scope.attribute</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.dataQualityInfo.scope.attributeType&quot; '>i18n.catalog.mdParam.dataQualityInfo.scope.attributeType</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.dataQualityInfo.scope.collectionHardware&quot; '>i18n.catalog.mdParam.dataQualityInfo.scope.collectionHardware</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.dataQualityInfo.scope.collectionSession&quot; '>i18n.catalog.mdParam.dataQualityInfo.scope.collectionSession</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.dataQualityInfo.scope.dataset&quot; '>i18n.catalog.mdParam.dataQualityInfo.scope.dataset</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.dataQualityInfo.scope.dimensionGroup&quot; '>i18n.catalog.mdParam.dataQualityInfo.scope.dimensionGroup</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.dataQualityInfo.scope.feature&quot; '>i18n.catalog.mdParam.dataQualityInfo.scope.feature</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.dataQualityInfo.scope.featureType&quot; '>i18n.catalog.mdParam.dataQualityInfo.scope.featureType</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.dataQualityInfo.scope.fieldSession&quot; '>i18n.catalog.mdParam.dataQualityInfo.scope.fieldSession</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.dataQualityInfo.scope.model&quot; '>i18n.catalog.mdParam.dataQualityInfo.scope.model</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.dataQualityInfo.scope.nonGeographicDataset&quot; '>i18n.catalog.mdParam.dataQualityInfo.scope.nonGeographicDataset</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.dataQualityInfo.scope.propertyType&quot; '>i18n.catalog.mdParam.dataQualityInfo.scope.propertyType</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.dataQualityInfo.scope.series&quot; '>i18n.catalog.mdParam.dataQualityInfo.scope.series</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.dataQualityInfo.scope.service&quot; '>i18n.catalog.mdParam.dataQualityInfo.scope.service</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.dataQualityInfo.scope.software&quot; '>i18n.catalog.mdParam.dataQualityInfo.scope.software</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.dataQualityInfo.scope.tile&quot; '>i18n.catalog.mdParam.dataQualityInfo.scope.tile</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.datasetInfo.caption&quot; '>i18n.catalog.mdParam.datasetInfo.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.datasetInfo.datasetCharacterset&quot; '>i18n.catalog.mdParam.datasetInfo.datasetCharacterset</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.datasetInfo.datasetLanguage&quot; '>i18n.catalog.mdParam.datasetInfo.datasetLanguage</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.DatiSpaziali.caption&quot; '>i18n.catalog.mdParam.DatiSpaziali.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.description.abstract&quot; '>i18n.catalog.mdParam.description.abstract</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.description.caption&quot; '>i18n.catalog.mdParam.description.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.description.purpose&quot; '>i18n.catalog.mdParam.description.purpose</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.distribution.caption&quot; '>i18n.catalog.mdParam.distribution.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.distribution.format.name&quot; '>i18n.catalog.mdParam.distribution.format.name</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.distribution.format.version&quot; '>i18n.catalog.mdParam.distribution.format.version</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.distribution.transferOptions.onLine.function&quot; '>i18n.catalog.mdParam.distribution.transferOptions.onLine.function</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.distribution.transferOptions.onLine.linkage&quot; '>i18n.catalog.mdParam.distribution.transferOptions.onLine.linkage</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.envelope.caption&quot; '>i18n.catalog.mdParam.envelope.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.envelope.east&quot; '>i18n.catalog.mdParam.envelope.east</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.envelope.north&quot; '>i18n.catalog.mdParam.envelope.north</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.envelope.south&quot; '>i18n.catalog.mdParam.envelope.south</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.envelope.west&quot; '>i18n.catalog.mdParam.envelope.west</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.general.caption&quot; '>i18n.catalog.mdParam.general.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.general.characterSet&quot; '>i18n.catalog.mdParam.general.characterSet</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.general.custodian&quot; '>i18n.catalog.mdParam.general.custodian</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.general.fileIdentifier&quot; '>i18n.catalog.mdParam.general.fileIdentifier</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.general.hierarchyLevel&quot; '>i18n.catalog.mdParam.general.hierarchyLevel</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.general.hierarchyLevelName&quot; '>i18n.catalog.mdParam.general.hierarchyLevelName</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.general.individualName&quot; '>i18n.catalog.mdParam.general.individualName</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.general.metadataCharacterset&quot; '>i18n.catalog.mdParam.general.metadataCharacterset</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.general.metadataDateStamp&quot; '>i18n.catalog.mdParam.general.metadataDateStamp</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.general.metadataLanguage&quot; '>i18n.catalog.mdParam.general.metadataLanguage</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.general.organization&quot; '>i18n.catalog.mdParam.general.organization</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.general.parentIdentifier&quot; '>i18n.catalog.mdParam.general.parentIdentifier</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.general.positionName&quot; '>i18n.catalog.mdParam.general.positionName</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.general.publishedDocId&quot; '>i18n.catalog.mdParam.general.publishedDocId</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.identification.abstract&quot; '>i18n.catalog.mdParam.identification.abstract</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.identification.caption&quot; '>i18n.catalog.mdParam.identification.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.identification.citationDate.caption&quot; '>i18n.catalog.mdParam.identification.citationDate.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.identification.datasetCreationDate&quot; '>i18n.catalog.mdParam.identification.datasetCreationDate</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.identification.datasetIdentifier&quot; '>i18n.catalog.mdParam.identification.datasetIdentifier</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.identification.datasetPublicationDate&quot; '>i18n.catalog.mdParam.identification.datasetPublicationDate</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.identification.datasetRevisionDate&quot; '>i18n.catalog.mdParam.identification.datasetRevisionDate</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.identification.datasetVersion&quot; '>i18n.catalog.mdParam.identification.datasetVersion</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.identification.dataType&quot; '>i18n.catalog.mdParam.identification.dataType</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.identification.dateType&quot; '>i18n.catalog.mdParam.identification.dateType</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.identification.equivalentScale&quot; '>i18n.catalog.mdParam.identification.equivalentScale</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.identification.initiallyProg&quot; '>i18n.catalog.mdParam.identification.initiallyProg</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.identification.program&quot; '>i18n.catalog.mdParam.identification.program</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.identification.program_no&quot; '>i18n.catalog.mdParam.identification.program_no</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.identification.publisher&quot; '>i18n.catalog.mdParam.identification.publisher</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.identification.responsibleParty.caption&quot; '>i18n.catalog.mdParam.identification.responsibleParty.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.identification.service.connectPoint&quot; '>i18n.catalog.mdParam.identification.service.connectPoint</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.identification.service.couplingType&quot; '>i18n.catalog.mdParam.identification.service.couplingType</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.identification.service.operationDCP&quot; '>i18n.catalog.mdParam.identification.service.operationDCP</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.identification.service.operationName&quot; '>i18n.catalog.mdParam.identification.service.operationName</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.identification.service.parameters&quot; '>i18n.catalog.mdParam.identification.service.parameters</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.identification.service.parameters.attributeType&quot; '>i18n.catalog.mdParam.identification.service.parameters.attributeType</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.identification.service.parameters.name&quot; '>i18n.catalog.mdParam.identification.service.parameters.name</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.identification.service.parameters.optionality&quot; '>i18n.catalog.mdParam.identification.service.parameters.optionality</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.identification.service.parameters.repeatability&quot; '>i18n.catalog.mdParam.identification.service.parameters.repeatability</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.identification.service.parameters.valueType&quot; '>i18n.catalog.mdParam.identification.service.parameters.valueType</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.identification.service.serviceType&quot; '>i18n.catalog.mdParam.identification.service.serviceType</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.identification.spatialRepresentationType&quot; '>i18n.catalog.mdParam.identification.spatialRepresentationType</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.identification.status&quot; '>i18n.catalog.mdParam.identification.status</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.identification.status.caption&quot; '>i18n.catalog.mdParam.identification.status.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.identification.title&quot; '>i18n.catalog.mdParam.identification.title</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.identificationDati.caption&quot; '>i18n.catalog.mdParam.identificationDati.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.identificationService.caption&quot; '>i18n.catalog.mdParam.identificationService.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.conformity.caption&quot; '>i18n.catalog.schedaMetadati.Conformita</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.conformity.date&quot; '>i18n.catalog.mdParam.inspire.conformity.date</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.conformity.date.creation&quot; '>i18n.catalog.mdParam.inspire.conformity.date.creation</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.conformity.date.publication&quot; '>i18n.catalog.mdParam.inspire.conformity.date.publication</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.conformity.date.revision&quot; '>i18n.catalog.mdParam.inspire.conformity.date.revision</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.conformity.degree&quot; '>i18n.catalog.mdParam.inspire.conformity.degree</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.conformity.degree.conformant&quot; '>i18n.catalog.mdParam.inspire.conformity.degree.conformant</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.conformity.degree.notConformant&quot; '>i18n.catalog.mdParam.inspire.conformity.degree.notConformant</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.conformity.degree.notEvaluated&quot; '>i18n.catalog.mdParam.inspire.conformity.degree.notEvaluated</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.conformity.title&quot; '>i18n.catalog.mdParam.inspire.conformity.title</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.constraints.accesAndUse&quot; '>i18n.catalog.mdParam.inspire.constraints.accesAndUse</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.constraints.accesAndUse.noCondition&quot; '>i18n.catalog.mdParam.inspire.constraints.accesAndUse.noCondition</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.constraints.accesAndUse.unknownCondition&quot; '>i18n.catalog.mdParam.inspire.constraints.accesAndUse.unknownCondition</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.constraints.caption&quot; '>i18n.catalog.mdParam.inspire.constraints.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.constraints.contitions.free.label&quot; '>i18n.catalog.mdParam.inspire.constraints.contitions.free.label</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.constraints.contitions.label&quot; '>i18n.catalog.mdParam.inspire.constraints.contitions.label</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.constraints.contitions.predefined.label&quot; '>i18n.catalog.mdParam.inspire.constraints.contitions.predefined.label</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.constraints.limitations.label&quot; '>i18n.catalog.mdParam.inspire.constraints.limitations.label</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.constraints.publicAccess&quot; '>i18n.catalog.mdParam.inspire.constraints.publicAccess</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.constraints.publicAccess.confidentialityOfCommercial&quot; '>i18n.catalog.mdParam.inspire.constraints.publicAccess.confidentialityOfCommercial</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.constraints.publicAccess.confidentialityOfPersonalData&quot; '>i18n.catalog.mdParam.inspire.constraints.publicAccess.confidentialityOfPersonalData</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.constraints.publicAccess.confidentialityOfProceedings&quot; '>i18n.catalog.mdParam.inspire.constraints.publicAccess.confidentialityOfProceedings</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.constraints.publicAccess.courseOfJustice&quot; '>i18n.catalog.mdParam.inspire.constraints.publicAccess.courseOfJustice</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.constraints.publicAccess.intellectualProperty&quot; '>i18n.catalog.mdParam.inspire.constraints.publicAccess.intellectualProperty</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.constraints.publicAccess.interestsOrProtection&quot; '>i18n.catalog.mdParam.inspire.constraints.publicAccess.interestsOrProtection</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.constraints.publicAccess.internationalRelations&quot; '>i18n.catalog.mdParam.inspire.constraints.publicAccess.internationalRelations</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.constraints.publicAccess.noLimitations&quot; '>i18n.catalog.mdParam.inspire.constraints.publicAccess.noLimitations</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.constraints.publicAccess.protectionOfEnvironment&quot; '>i18n.catalog.mdParam.inspire.constraints.publicAccess.protectionOfEnvironment</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.contact.caption&quot; '>i18n.catalog.mdParam.inspire.contact.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.contact.email&quot; '>i18n.catalog.mdParam.inspire.contact.email</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.contact.organization&quot; '>i18n.catalog.mdParam.inspire.contact.organization</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.contact.position&quot; '>i18n.catalog.mdParam.inspire.contact.position</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.contact.position.author&quot; '>i18n.catalog.mdParam.inspire.contact.position.author</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.contact.position.custodian&quot; '>i18n.catalog.mdParam.inspire.contact.position.custodian</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.contact.position.distributor&quot; '>i18n.catalog.mdParam.inspire.contact.position.distributor</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.contact.position.originator&quot; '>i18n.catalog.mdParam.inspire.contact.position.originator</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.contact.position.owner&quot; '>i18n.catalog.mdParam.inspire.contact.position.owner</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.contact.position.pointOfContact&quot; '>i18n.catalog.mdParam.inspire.contact.position.pointOfContact</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.contact.position.principalInvestigator&quot; '>i18n.catalog.mdParam.inspire.contact.position.principalInvestigator</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.contact.position.processor&quot; '>i18n.catalog.mdParam.inspire.contact.position.processor</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.contact.position.publisher&quot; '>i18n.catalog.mdParam.inspire.contact.position.publisher</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.contact.position.resourceProvider&quot; '>i18n.catalog.mdParam.inspire.contact.position.resourceProvider</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.contact.position.user&quot; '>i18n.catalog.mdParam.inspire.contact.position.user</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.dataQualityInfo.caption&quot; '>i18n.catalog.mdParam.inspire.dataQualityInfo.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.dataQualityInfo.distance&quot; '>i18n.catalog.mdParam.inspire.dataQualityInfo.distance</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.dataQualityInfo.equivalentScale&quot; '>i18n.catalog.mdParam.inspire.dataQualityInfo.equivalentScale</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.dataQualityInfo.equivalentScale.hint&quot; '>i18n.catalog.mdParam.inspire.dataQualityInfo.equivalentScale.hint</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.dataQualityInfo.lineage&quot; '>i18n.catalog.mdParam.inspire.dataQualityInfo.lineage</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.dataQualityInfo.spatialResolution&quot; '>i18n.catalog.mdParam.inspire.dataQualityInfo.spatialResolution</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.dataQualityInfo.unitOfMeasure&quot; '>i18n.catalog.mdParam.inspire.dataQualityInfo.unitOfMeasure</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.datasetInfo.datasetLanguage&quot; '>i18n.catalog.mdParam.inspire.datasetInfo.datasetLanguage</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.distribution.transferOptions.onLine.linkage&quot; '>i18n.catalog.mdParam.inspire.distribution.transferOptions.onLine.linkage</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.distribution.transferOptions.onLine.linkage.testBtn&quot; '>i18n.catalog.mdParam.inspire.distribution.transferOptions.onLine.linkage.testBtn</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.envelope.caption&quot; '>i18n.catalog.mdParam.inspire.envelope.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.envelope.east&quot; '>i18n.catalog.mdParam.inspire.envelope.east</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.envelope.north&quot; '>i18n.catalog.mdParam.inspire.envelope.north</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.envelope.south&quot; '>i18n.catalog.mdParam.inspire.envelope.south</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.envelope.west&quot; '>i18n.catalog.mdParam.inspire.envelope.west</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.general.caption&quot; '>i18n.catalog.mdParam.inspire.general.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.general.contact.email&quot; '>i18n.catalog.mdParam.inspire.general.contact.email</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.general.contact.organization&quot; '>i18n.catalog.mdParam.inspire.general.contact.organization</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.general.contact.role&quot; '>i18n.catalog.mdParam.inspire.general.contact.role</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.general.fileIdentifier&quot; '>i18n.catalog.mdParam.inspire.general.fileIdentifier</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.general.metadataDateStamp&quot; '>i18n.catalog.mdParam.inspire.general.metadataDateStamp</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.general.metadataLanguage&quot; '>i18n.catalog.mdParam.inspire.general.metadataLanguage</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.general.metadataPointOfContact.caption&quot; '>i18n.catalog.mdParam.inspire.general.metadataPointOfContact.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.abstract&quot; '>i18n.catalog.mdParam.inspire.identification.abstract</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.caption&quot; '>i18n.catalog.mdParam.inspire.identification.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.datasetIdentifier&quot; '>i18n.catalog.mdParam.inspire.identification.datasetIdentifier</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.discovery&quot; '>i18n.catalog.mdParam.inspire.identification.discovery</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.download&quot; '>i18n.catalog.mdParam.inspire.identification.download</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.hierarchyLevel&quot; '>i18n.catalog.mdParam.inspire.identification.hierarchyLevel</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.invoke&quot; '>i18n.catalog.mdParam.inspire.identification.invoke</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.other&quot; '>i18n.catalog.mdParam.inspire.identification.other</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.chainDefinitionService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.chainDefinitionService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.comEncodingService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.comEncodingService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.comGeographicCompressionService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.comGeographicCompressionService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.comGeographicFormatConversionService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.comGeographicFormatConversionService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.comMessagingService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.comMessagingService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.comRemoteFileAndExecutableManagement&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.comRemoteFileAndExecutableManagement</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.comService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.comService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.comTransferService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.comTransferService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.humanCatalogueViewer&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.humanCatalogueViewer</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.humanChainDefinitionEditor&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.humanChainDefinitionEditor</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.humanFeatureGeneralizationEditor&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.humanFeatureGeneralizationEditor</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.humanGeographicDataStructureViewer&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.humanGeographicDataStructureViewer</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.humanGeographicFeatureEditor&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.humanGeographicFeatureEditor</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.humanGeographicSpreadsheetViewer&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.humanGeographicSpreadsheetViewer</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.humanGeographicSymbolEditor&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.humanGeographicSymbolEditor</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.humanGeographicViewer&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.humanGeographicViewer</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.humanInteractionService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.humanInteractionService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.humanServiceEditor&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.humanServiceEditor</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.humanWorkflowEnactmentManager&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.humanWorkflowEnactmentManager</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.infoCatalogueService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.infoCatalogueService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.infoCoverageAccessService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.infoCoverageAccessService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.infoFeatureAccessService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.infoFeatureAccessService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.infoFeatureTypeService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.infoFeatureTypeService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.infoGazetteerService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.infoGazetteerService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.infoManagementService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.infoManagementService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.infoMapAccessService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.infoMapAccessService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.infoOrderHandlingService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.infoOrderHandlingService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.infoProductAccessService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.infoProductAccessService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.infoRegistryService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.infoRegistryService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.infoSensorDescriptionService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.infoSensorDescriptionService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.infoStandingOrderService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.infoStandingOrderService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.metadataGeographicAnnotationService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.metadataGeographicAnnotationService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.metadataProcessingService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.metadataProcessingService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.metadataStatisticalCalculationService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.metadataStatisticalCalculationService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.spatialCoordinateConversionService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.spatialCoordinateConversionService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.spatialCoordinateTransformationService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.spatialCoordinateTransformationService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.spatialCoverageVectorConversionService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.spatialCoverageVectorConversionService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.spatialDimensionMeasurementService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.spatialDimensionMeasurementService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.spatialFeatureGeneralizationService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.spatialFeatureGeneralizationService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.spatialFeatureManipulationService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.spatialFeatureManipulationService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.spatialFeatureMatchingService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.spatialFeatureMatchingService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.spatialImageCoordinateConversionService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.spatialImageCoordinateConversionService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.spatialImageGeometryModelConversionService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.spatialImageGeometryModelConversionService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.spatialOrthorectificationService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.spatialOrthorectificationService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.spatialPositioningService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.spatialPositioningService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.spatialProcessingService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.spatialProcessingService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.spatialProximityAnalysisService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.spatialProximityAnalysisService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.spatialRectificationService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.spatialRectificationService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.spatialRouteDeterminationService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.spatialRouteDeterminationService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.spatialSamplingService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.spatialSamplingService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.spatialSensorGeometryModelAdjustmentService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.spatialSensorGeometryModelAdjustmentService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.spatialSubsettingService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.spatialSubsettingService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.spatialTilingChangeService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.spatialTilingChangeService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.subscriptionService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.subscriptionService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.taskManagementService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.taskManagementService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.temporalProcessingService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.temporalProcessingService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.temporalProximityAnalysisService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.temporalProximityAnalysisService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.temporalReferenceSystemTransformationService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.temporalReferenceSystemTransformationService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.temporalSamplingService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.temporalSamplingService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.temporalSubsettingService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.temporalSubsettingService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.thematicChangeDetectionService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.thematicChangeDetectionService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.thematicClassificationService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.thematicClassificationService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.thematicFeatureGeneralizationService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.thematicFeatureGeneralizationService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.thematicGeocodingService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.thematicGeocodingService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.thematicGeographicInformationExtractionService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.thematicGeographicInformationExtractionService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.thematicGeoparsingService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.thematicGeoparsingService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.thematicGoparameterCalculationService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.thematicGoparameterCalculationService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.thematicImageManipulationService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.thematicImageManipulationService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.thematicImageProcessingService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.thematicImageProcessingService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.thematicImageSynthesisService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.thematicImageSynthesisService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.thematicImageUnderstandingService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.thematicImageUnderstandingService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.thematicMultibandImageManipulationService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.thematicMultibandImageManipulationService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.thematicObjectDetectionService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.thematicObjectDetectionService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.thematicProcessingService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.thematicProcessingService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.thematicReducedResolutionGenerationService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.thematicReducedResolutionGenerationService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.thematicSpatialCountingService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.thematicSpatialCountingService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.thematicSubsettingService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.thematicSubsettingService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.servicetype.workflowEnactmentService&quot; '>i18n.catalog.mdParam.inspire.identification.servicetype.workflowEnactmentService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.title&quot; '>i18n.catalog.mdParam.inspire.identification.title</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.transformation&quot; '>i18n.catalog.mdParam.inspire.identification.transformation</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.identification.view&quot; '>i18n.catalog.mdParam.inspire.identification.view</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.keyword.caption&quot; '>i18n.catalog.mdParam.inspire.keyword.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.keyword.dataTheme&quot; '>i18n.catalog.mdParam.inspire.keyword.dataTheme</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.keyword.dataTheme.addresses&quot; '>i18n.catalog.mdParam.inspire.keyword.dataTheme.addresses</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.keyword.dataTheme.administrativeUnits&quot; '>i18n.catalog.mdParam.inspire.keyword.dataTheme.administrativeUnits</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.keyword.dataTheme.agriculturalAndAquacultureFacilities&quot; '>i18n.catalog.mdParam.inspire.keyword.dataTheme.agriculturalAndAquacultureFacilities</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.keyword.dataTheme.areaManagementRestrictionRegulationZonesAndReportingUnits&quot; '>i18n.catalog.mdParam.inspire.keyword.dataTheme.areaManagementRestrictionRegulationZonesAndReportingUnits</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.keyword.dataTheme.atmosphericConditions&quot; '>i18n.catalog.mdParam.inspire.keyword.dataTheme.atmosphericConditions</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.keyword.dataTheme.bioGeographicalRegions&quot; '>i18n.catalog.mdParam.inspire.keyword.dataTheme.bioGeographicalRegions</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.keyword.dataTheme.buildings&quot; '>i18n.catalog.mdParam.inspire.keyword.dataTheme.buildings</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.keyword.dataTheme.cadastralParcels&quot; '>i18n.catalog.mdParam.inspire.keyword.dataTheme.cadastralParcels</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.keyword.dataTheme.coordinateReferenceSystems&quot; '>i18n.catalog.mdParam.inspire.keyword.dataTheme.coordinateReferenceSystems</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.keyword.dataTheme.elevation&quot; '>i18n.catalog.mdParam.inspire.keyword.dataTheme.elevation</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.keyword.dataTheme.energyResources&quot; '>i18n.catalog.mdParam.inspire.keyword.dataTheme.energyResources</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.keyword.dataTheme.environmentalMonitoringFacilities&quot; '>i18n.catalog.mdParam.inspire.keyword.dataTheme.environmentalMonitoringFacilities</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.keyword.dataTheme.geographicalGridSystems&quot; '>i18n.catalog.mdParam.inspire.keyword.dataTheme.geographicalGridSystems</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.keyword.dataTheme.geographicalNames&quot; '>i18n.catalog.mdParam.inspire.keyword.dataTheme.geographicalNames</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.keyword.dataTheme.geology&quot; '>i18n.catalog.mdParam.inspire.keyword.dataTheme.geology</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.keyword.dataTheme.habitatsAndBiotopes&quot; '>i18n.catalog.mdParam.inspire.keyword.dataTheme.habitatsAndBiotopes</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.keyword.dataTheme.humanHealthAndSafety&quot; '>i18n.catalog.mdParam.inspire.keyword.dataTheme.humanHealthAndSafety</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.keyword.dataTheme.hydrography&quot; '>i18n.catalog.mdParam.inspire.keyword.dataTheme.hydrography</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.keyword.dataTheme.label&quot; '>i18n.catalog.mdParam.inspire.keyword.dataTheme.label</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.keyword.dataTheme.landCover&quot; '>i18n.catalog.mdParam.inspire.keyword.dataTheme.landCover</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.keyword.dataTheme.landUser&quot; '>i18n.catalog.mdParam.inspire.keyword.dataTheme.landUser</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.keyword.dataTheme.meteorologicalGeographicalFeatures&quot; '>i18n.catalog.mdParam.inspire.keyword.dataTheme.meteorologicalGeographicalFeatures</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.keyword.dataTheme.mineralResources&quot; '>i18n.catalog.mdParam.inspire.keyword.dataTheme.mineralResources</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.keyword.dataTheme.naturalRiskZones&quot; '>i18n.catalog.mdParam.inspire.keyword.dataTheme.naturalRiskZones</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.keyword.dataTheme.oceanographicGeographicalFeatures&quot; '>i18n.catalog.mdParam.inspire.keyword.dataTheme.oceanographicGeographicalFeatures</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.keyword.dataTheme.orthoimagery&quot; '>i18n.catalog.mdParam.inspire.keyword.dataTheme.orthoimagery</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.keyword.dataTheme.populationDistributionDemography&quot; '>i18n.catalog.mdParam.inspire.keyword.dataTheme.populationDistributionDemography</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.keyword.dataTheme.productionAndIndustrialFacilities&quot; '>i18n.catalog.mdParam.inspire.keyword.dataTheme.productionAndIndustrialFacilities</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.keyword.dataTheme.protectedSites&quot; '>i18n.catalog.mdParam.inspire.keyword.dataTheme.protectedSites</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.keyword.dataTheme.seaRegions&quot; '>i18n.catalog.mdParam.inspire.keyword.dataTheme.seaRegions</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.keyword.dataTheme.service.label&quot; '>i18n.catalog.mdParam.inspire.keyword.dataTheme.service.label</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.keyword.dataTheme.soil&quot; '>i18n.catalog.mdParam.inspire.keyword.dataTheme.soil</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.keyword.dataTheme.speciesDistribution&quot; '>i18n.catalog.mdParam.inspire.keyword.dataTheme.speciesDistribution</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.keyword.dataTheme.statisticalUnits&quot; '>i18n.catalog.mdParam.inspire.keyword.dataTheme.statisticalUnits</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.keyword.dataTheme.transportNetworks&quot; '>i18n.catalog.mdParam.inspire.keyword.dataTheme.transportNetworks</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.keyword.dataTheme.transportNetworks1&quot; '>i18n.catalog.mdParam.inspire.keyword.dataTheme.transportNetworks1</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.keyword.dataTheme.utilityAndGovernmentService&quot; '>i18n.catalog.mdParam.inspire.keyword.dataTheme.utilityAndGovernmentService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.keyword.gemet.concept&quot; '>i18n.catalog.mdParam.inspire.keyword.gemet.concept</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.keyword.gemet.concept.keyword&quot; '>i18n.catalog.mdParam.inspire.keyword.gemet.concept.keyword</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.keyword.gemetKeyword&quot; '>i18n.catalog.mdParam.inspire.keyword.gemetKeyword</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.keyword.isoServiceCategory&quot; '>i18n.catalog.mdParam.inspire.keyword.isoServiceCategory</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.keyword.keywordValue&quot; '>i18n.catalog.mdParam.inspire.keyword.keywordValue</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.keyword.keywordValue.label&quot; '>i18n.catalog.mdParam.inspire.keyword.keywordValue.label</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.keyword.referenceDate&quot; '>i18n.catalog.mdParam.inspire.keyword.referenceDate</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.keyword.referenceDateType.caption&quot; '>i18n.catalog.mdParam.inspire.keyword.referenceDateType.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.keyword.referenceDateType.creation&quot; '>i18n.catalog.mdParam.inspire.keyword.referenceDateType.creation</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.keyword.referenceDateType.publication&quot; '>i18n.catalog.mdParam.inspire.keyword.referenceDateType.publication</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.keyword.referenceDateType.revision&quot; '>i18n.catalog.mdParam.inspire.keyword.referenceDateType.revision</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.keyword.servicetype&quot; '>i18n.catalog.mdParam.inspire.keyword.servicetype</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.keyword.title&quot; '>i18n.catalog.mdParam.inspire.keyword.title</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.temporal.caption&quot; '>i18n.catalog.mdParam.inspire.temporal.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.temporal.dateOfCreation&quot; '>i18n.catalog.mdParam.inspire.temporal.dateOfCreation</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.temporal.dateOfLastRevision&quot; '>i18n.catalog.mdParam.inspire.temporal.dateOfLastRevision</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.temporal.dateOfPublication&quot; '>i18n.catalog.mdParam.inspire.temporal.dateOfPublication</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.temporal.dateOfPublication.hint&quot; '>i18n.catalog.mdParam.inspire.temporal.dateOfPublication.hint</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.temporal.extent&quot; '>i18n.catalog.mdParam.inspire.temporal.extent</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.temporal.extent.begin&quot; '>i18n.catalog.mdParam.inspire.temporal.extent.begin</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.temporal.extent.end&quot; '>i18n.catalog.mdParam.inspire.temporal.extent.end</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.theme.caption&quot; '>i18n.catalog.mdParam.inspire.theme.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.inspire.theme.topics&quot; '>i18n.catalog.mdParam.inspire.theme.topics</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.abstract&quot; '>i18n.catalog.mdParam.iso19110.featuretype.abstract</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.caption&quot; '>i18n.catalog.mdParam.iso19110.featuretype.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.definition&quot; '>i18n.catalog.mdParam.iso19110.featuretype.definition</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute.binding&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute.binding</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute.caption&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute.cardinality&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute.cardinality</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute.constraint&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute.constraint</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute.definition&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute.definition</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute.listedvalue.caption&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute.listedvalue.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute.listedvalue.code&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute.listedvalue.code</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute.listedvalue.definition&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute.listedvalue.definition</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute.listedvalue.label&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute.listedvalue.label</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute.listedvalue1.caption&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute.listedvalue1.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute.listedvalue10.caption&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute.listedvalue10.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute.listedvalue2.caption&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute.listedvalue2.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute.listedvalue3.caption&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute.listedvalue3.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute.listedvalue4.caption&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute.listedvalue4.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute.listedvalue5.caption&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute.listedvalue5.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute.listedvalue6.caption&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute.listedvalue6.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute.listedvalue7.caption&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute.listedvalue7.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute.listedvalue8.caption&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute.listedvalue8.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute.listedvalue9.caption&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute.listedvalue9.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute.name&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute.name</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute.sceltatipoattributo.caption&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute.sceltatipoattributo.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute.value.alias&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute.value.alias</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute.value.caption&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute.value.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute.value.valuelength&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute.value.valuelength</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute.value.valuePrecision&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute.value.valuePrecision</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute.value.valueScale&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute.value.valueScale</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute.value.valueType&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute.value.valueType</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute.valuemeasurementunit&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute.valuemeasurementunit</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute1.caption&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute1.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute10.caption&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute10.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute11.caption&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute11.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute12.caption&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute12.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute13.caption&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute13.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute14.caption&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute14.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute15.caption&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute15.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute16.caption&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute16.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute17.caption&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute17.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute18.caption&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute18.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute19.caption&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute19.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute2.caption&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute2.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute20.caption&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute20.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute21.caption&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute21.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute22.caption&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute22.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute23.caption&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute23.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute24.caption&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute24.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute25.caption&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute25.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute26.caption&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute26.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute27.caption&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute27.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute28.caption&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute28.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute29.caption&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute29.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute3.caption&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute3.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute30.caption&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute30.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute31.caption&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute31.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute32.caption&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute32.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute33.caption&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute33.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute34.caption&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute34.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute35.caption&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute35.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute36.caption&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute36.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute37.caption&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute37.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute38.caption&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute38.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute39.caption&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute39.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute4.caption&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute4.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute40.caption&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute40.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute5.caption&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute5.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute6.caption&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute6.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute7.caption&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute7.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute8.caption&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute8.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featureattribute9.caption&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featureattribute9.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.featurecatalogue&quot; '>i18n.catalog.mdParam.iso19110.featuretype.featurecatalogue</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.featuretype.name&quot; '>i18n.catalog.mdParam.iso19110.featuretype.name</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.general.caption&quot; '>i18n.catalog.mdParam.iso19110.general.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.general.fileIdentifier&quot; '>i18n.catalog.mdParam.iso19110.general.fileIdentifier</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.general.linkedRecord&quot; '>i18n.catalog.mdParam.iso19110.general.linkedRecord</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.general.name&quot; '>i18n.catalog.mdParam.iso19110.general.name</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.general.producer.caption&quot; '>i18n.catalog.mdParam.iso19110.general.producer.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.general.producer.organization&quot; '>i18n.catalog.mdParam.iso19110.general.producer.organization</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.general.producer.role&quot; '>i18n.catalog.mdParam.iso19110.general.producer.role</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.general.scope&quot; '>i18n.catalog.mdParam.iso19110.general.scope</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.general.versionDate&quot; '>i18n.catalog.mdParam.iso19110.general.versionDate</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.iso19110.general.versionNumber&quot; '>i18n.catalog.mdParam.iso19110.general.versionNumber</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.keywords.caption&quot; '>i18n.catalog.mdParam.keywords.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.keywords.place&quot; '>i18n.catalog.mdParam.keywords.place</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.keywords.theme&quot; '>i18n.catalog.mdParam.keywords.theme</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.keywords.theme.reference&quot; '>i18n.catalog.mdParam.keywords.theme.reference</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.KeywordsAltriTemi.caption&quot; '>i18n.catalog.mdParam.KeywordsAltriTemi.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.LivelloDiQualita.caption&quot; '>i18n.catalog.schedaMetadati.LivelloDiQualita</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.constraints.limitations.english&quot; '>i18n.catalog.mdParam.OneGeology.constraints.limitations.english</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.constraints.other.english&quot; '>i18n.catalog.mdParam.OneGeology.constraints.other.english</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.coupledResource.caption&quot; '>i18n.catalog.mdParam.OneGeology.coupledResource.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.dataQuality.lineage.digitizingMethod&quot; '>i18n.catalog.mdParam.OneGeology.dataQuality.lineage.digitizingMethod</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.dataQuality.lineage.digitizingMethod.english&quot; '>i18n.catalog.mdParam.OneGeology.dataQuality.lineage.digitizingMethod.english</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.dataQuality.lineage.english&quot; '>i18n.catalog.mdParam.OneGeology.dataQuality.lineage.english</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.dataQuality.lineage.geological&quot; '>i18n.catalog.mdParam.OneGeology.dataQuality.lineage.geological</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.dataQuality.lineage.sourcedate&quot; '>i18n.catalog.mdParam.OneGeology.dataQuality.lineage.sourcedate</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.dataQuality.lineage.sourcedatetype&quot; '>i18n.catalog.mdParam.OneGeology.dataQuality.lineage.sourcedatetype</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.dataQuality.lineage.sourcedescription&quot; '>i18n.catalog.mdParam.OneGeology.dataQuality.lineage.sourcedescription</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.dataQuality.lineage.sourcedescription.english&quot; '>i18n.catalog.mdParam.OneGeology.dataQuality.lineage.sourcedescription.english</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.dataQuality.lineage.sourceScale&quot; '>i18n.catalog.mdParam.OneGeology.dataQuality.lineage.sourceScale</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.dataQuality.lineage.sourcetitle&quot; '>i18n.catalog.mdParam.OneGeology.dataQuality.lineage.sourcetitle</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.dataQuality.lineage.sourcetitle.english&quot; '>i18n.catalog.mdParam.OneGeology.dataQuality.lineage.sourcetitle.english</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.dataQuality.lineage.topographic&quot; '>i18n.catalog.mdParam.OneGeology.dataQuality.lineage.topographic</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.dataQuality.lineage.topographicsourcedate&quot; '>i18n.catalog.mdParam.OneGeology.dataQuality.lineage.topographicsourcedate</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.dataQuality.lineage.topographicsourcedatetype&quot; '>i18n.catalog.mdParam.OneGeology.dataQuality.lineage.topographicsourcedatetype</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.dataQuality.lineage.topographicsourcescale&quot; '>i18n.catalog.mdParam.OneGeology.dataQuality.lineage.topographicsourcescale</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.dataQuality.lineage.topographicsourcetitle.english&quot; '>i18n.catalog.mdParam.OneGeology.dataQuality.lineage.topographicsourcetitle.english</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.dataQuality.lineage.topographicsourcetitle&quot; '>i18n.catalog.mdParam.OneGeology.dataQuality.lineage.topographicsourcetitle</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.dataQuality.lineage.topologicalsourcedescription.english&quot; '>i18n.catalog.mdParam.OneGeology.dataQuality.lineage.topologicalsourcedescription.english</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.dataQuality.lineage.topologicalsourcedescription&quot; '>i18n.catalog.mdParam.OneGeology.dataQuality.lineage.topologicalsourcedescription</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.general.standardVersion.metadataStandardName&quot; '>i18n.catalog.mdParam.OneGeology.general.standardVersion.metadataStandardName</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.general.standardVersion.metadataStandardVersion&quot; '>i18n.catalog.mdParam.OneGeology.general.standardVersion.metadataStandardVersion</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.abstract.czech&quot; '>i18n.catalog.mdParam.OneGeology.identification.abstract.czech</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.abstract.danish&quot; '>i18n.catalog.mdParam.OneGeology.identification.abstract.danish</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.abstract.deutsche&quot; '>i18n.catalog.mdParam.OneGeology.identification.abstract.deutsche</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.abstract.english&quot; '>i18n.catalog.mdParam.OneGeology.identification.abstract.english</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.abstract.estonian&quot; '>i18n.catalog.mdParam.OneGeology.identification.abstract.estonian</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.abstract.finnish&quot; '>i18n.catalog.mdParam.OneGeology.identification.abstract.finnish</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.abstract.french&quot; '>i18n.catalog.mdParam.OneGeology.identification.abstract.french</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.abstract.greek&quot; '>i18n.catalog.mdParam.OneGeology.identification.abstract.greek</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.abstract.hungarian&quot; '>i18n.catalog.mdParam.OneGeology.identification.abstract.hungarian</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.abstract.italian&quot; '>i18n.catalog.mdParam.OneGeology.identification.abstract.italian</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.abstract.norwegian&quot; '>i18n.catalog.mdParam.OneGeology.identification.abstract.norwegian</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.abstract.polish&quot; '>i18n.catalog.mdParam.OneGeology.identification.abstract.polish</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.abstract.portuguese&quot; '>i18n.catalog.mdParam.OneGeology.identification.abstract.portuguese</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.abstract.slovak&quot; '>i18n.catalog.mdParam.OneGeology.identification.abstract.slovak</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.abstract.slovenian&quot; '>i18n.catalog.mdParam.OneGeology.identification.abstract.slovenian</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.abstract.spanish&quot; '>i18n.catalog.mdParam.OneGeology.identification.abstract.spanish</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.abstract.swedish&quot; '>i18n.catalog.mdParam.OneGeology.identification.abstract.swedish</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.coupledResource.identifier&quot; '>i18n.catalog.mdParam.OneGeology.identification.coupledResource.identifier</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.coupledResource.ScopedName&quot; '>i18n.catalog.mdParam.OneGeology.identification.coupledResource.ScopedName</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.datasetIdentifier.CodeSpace&quot; '>i18n.catalog.mdParam.OneGeology.identification.datasetIdentifier.CodeSpace</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.keyword.otherLanguages&quot; '>i18n.catalog.mdParam.OneGeology.identification.keyword.otherLanguages</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.keyword.thesaurus&quot; '>i18n.catalog.mdParam.OneGeology.identification.keyword.thesaurus</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.keyword.thesaurus.keyword.czech&quot; '>i18n.catalog.mdParam.OneGeology.identification.keyword.thesaurus.keyword.czech</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.keyword.thesaurus.keyword.danish&quot; '>i18n.catalog.mdParam.OneGeology.identification.keyword.thesaurus.keyword.danish</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.keyword.thesaurus.keyword.deutsche&quot; '>i18n.catalog.mdParam.OneGeology.identification.keyword.thesaurus.keyword.deutsche</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.keyword.thesaurus.keyword.english&quot; '>i18n.catalog.mdParam.OneGeology.identification.keyword.thesaurus.keyword.english</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.keyword.thesaurus.keyword.estonian&quot; '>i18n.catalog.mdParam.OneGeology.identification.keyword.thesaurus.keyword.estonian</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.keyword.thesaurus.keyword.finnish&quot; '>i18n.catalog.mdParam.OneGeology.identification.keyword.thesaurus.keyword.finnish</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.keyword.thesaurus.keyword.french&quot; '>i18n.catalog.mdParam.OneGeology.identification.keyword.thesaurus.keyword.french</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.keyword.thesaurus.keyword.greek&quot; '>i18n.catalog.mdParam.OneGeology.identification.keyword.thesaurus.keyword.greek</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.keyword.thesaurus.keyword.hungarian&quot; '>i18n.catalog.mdParam.OneGeology.identification.keyword.thesaurus.keyword.hungarian</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.keyword.thesaurus.keyword.italian&quot; '>i18n.catalog.mdParam.OneGeology.identification.keyword.thesaurus.keyword.italian</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.keyword.thesaurus.keyword.norwegian&quot; '>i18n.catalog.mdParam.OneGeology.identification.keyword.thesaurus.keyword.norwegian</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.keyword.thesaurus.keyword.polish&quot; '>i18n.catalog.mdParam.OneGeology.identification.keyword.thesaurus.keyword.polish</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.keyword.thesaurus.keyword.portuguese&quot; '>i18n.catalog.mdParam.OneGeology.identification.keyword.thesaurus.keyword.portuguese</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.keyword.thesaurus.keyword.slovak&quot; '>i18n.catalog.mdParam.OneGeology.identification.keyword.thesaurus.keyword.slovak</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.keyword.thesaurus.keyword.slovenian&quot; '>i18n.catalog.mdParam.OneGeology.identification.keyword.thesaurus.keyword.slovenian</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.keyword.thesaurus.keyword.spanish&quot; '>i18n.catalog.mdParam.OneGeology.identification.keyword.thesaurus.keyword.spanish</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.keyword.thesaurus.keyword.swedish&quot; '>i18n.catalog.mdParam.OneGeology.identification.keyword.thesaurus.keyword.swedish</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.keyword.thesaurusOneGeology.caption&quot; '>i18n.catalog.mdParam.OneGeology.identification.keyword.thesaurusOneGeology.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.otherAbstract&quot; '>i18n.catalog.mdParam.OneGeology.identification.otherAbstract</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.pointOfContact.organization.english&quot; '>i18n.catalog.mdParam.OneGeology.identification.pointOfContact.organization.english</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.pointOfContact.organizationInfo.country.english&quot; '>i18n.catalog.mdParam.OneGeology.identification.pointOfContact.organizationInfo.country.english</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.pointOfContact.organizationInfo.country&quot; '>i18n.catalog.mdParam.OneGeology.identification.pointOfContact.organizationInfo.country</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.software.english&quot; '>i18n.catalog.mdParam.OneGeology.identification.software.english</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.software.sec&quot; '>i18n.catalog.mdParam.OneGeology.identification.software.sec</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.software&quot; '>i18n.catalog.mdParam.OneGeology.identification.software</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.title.czech&quot; '>i18n.catalog.mdParam.OneGeology.identification.title.czech</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.title.danish&quot; '>i18n.catalog.mdParam.OneGeology.identification.title.danish</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.title.deutsche&quot; '>i18n.catalog.mdParam.OneGeology.identification.title.deutsche</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.title.english&quot; '>i18n.catalog.mdParam.OneGeology.identification.title.english</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.title.estonian&quot; '>i18n.catalog.mdParam.OneGeology.identification.title.estonian</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.title.finnish&quot; '>i18n.catalog.mdParam.OneGeology.identification.title.finnish</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.title.french&quot; '>i18n.catalog.mdParam.OneGeology.identification.title.french</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.title.greek&quot; '>i18n.catalog.mdParam.OneGeology.identification.title.greek</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.title.hungarian&quot; '>i18n.catalog.mdParam.OneGeology.identification.title.hungarian</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.title.italian&quot; '>i18n.catalog.mdParam.OneGeology.identification.title.italian</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.title.norwegian&quot; '>i18n.catalog.mdParam.OneGeology.identification.title.norwegian</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.title.polish&quot; '>i18n.catalog.mdParam.OneGeology.identification.title.polish</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.title.portuguese&quot; '>i18n.catalog.mdParam.OneGeology.identification.title.portuguese</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.title.slovak&quot; '>i18n.catalog.mdParam.OneGeology.identification.title.slovak</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.title.slovenian&quot; '>i18n.catalog.mdParam.OneGeology.identification.title.slovenian</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.title.spanish&quot; '>i18n.catalog.mdParam.OneGeology.identification.title.spanish</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.identification.title.swedish&quot; '>i18n.catalog.mdParam.OneGeology.identification.title.swedish</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.maintenance.note.english&quot; '>i18n.catalog.mdParam.OneGeology.maintenance.note.english</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.maintenance.note&quot; '>i18n.catalog.mdParam.OneGeology.maintenance.note</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.OneGeology.date&quot; '>i18n.catalog.mdParam.OneGeology.OneGeology.date</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.OneGeology.title&quot; '>i18n.catalog.mdParam.OneGeology.OneGeology.title</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.otherTitles.caption&quot; '>i18n.catalog.mdParam.OneGeology.otherTitles.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.referenceSystemInfo.code&quot; '>i18n.catalog.mdParam.OneGeology.referenceSystemInfo.code</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.Onegeology.referenceSystemInfo.codeSpace&quot; '>i18n.catalog.mdParam.Onegeology.referenceSystemInfo.codeSpace</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.Onegeology.referenceSystemInfo.version&quot; '>i18n.catalog.mdParam.Onegeology.referenceSystemInfo.version</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.referenceSystemInfo&quot; '>i18n.catalog.mdParam.OneGeology.referenceSystemInfo</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.spatialRepresentationInfo.vectorSpatialRepresentation.topologylevelcode&quot; '>i18n.catalog.mdParam.OneGeology.spatialRepresentationInfo.vectorSpatialRepresentation.topologylevelcode</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.spatialRepresentationInfo.vectorSpatialRepresentation.topologylevelcode.abstract&quot; '>i18n.catalog.mdParam.OneGeology.spatialRepresentationInfo.vectorSpatialRepresentation.topologylevelcode.abstract</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.spatialRepresentationInfo.vectorSpatialRepresentation.topologylevelcode.fullPlanarGraph&quot; '>i18n.catalog.mdParam.OneGeology.spatialRepresentationInfo.vectorSpatialRepresentation.topologylevelcode.fullPlanarGraph</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.spatialRepresentationInfo.vectorSpatialRepresentation.topologylevelcode.fullSurfaceGraph&quot; '>i18n.catalog.mdParam.OneGeology.spatialRepresentationInfo.vectorSpatialRepresentation.topologylevelcode.fullSurfaceGraph</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.spatialRepresentationInfo.vectorSpatialRepresentation.topologylevelcode.fullTopology3D&quot; '>i18n.catalog.mdParam.OneGeology.spatialRepresentationInfo.vectorSpatialRepresentation.topologylevelcode.fullTopology3D</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.spatialRepresentationInfo.vectorSpatialRepresentation.topologylevelcode.geometryOnly&quot; '>i18n.catalog.mdParam.OneGeology.spatialRepresentationInfo.vectorSpatialRepresentation.topologylevelcode.geometryOnly</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.spatialRepresentationInfo.vectorSpatialRepresentation.topologylevelcode.nonPlanarGraph&quot; '>i18n.catalog.mdParam.OneGeology.spatialRepresentationInfo.vectorSpatialRepresentation.topologylevelcode.nonPlanarGraph</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.spatialRepresentationInfo.vectorSpatialRepresentation.topologylevelcode.planarGraph&quot; '>i18n.catalog.mdParam.OneGeology.spatialRepresentationInfo.vectorSpatialRepresentation.topologylevelcode.planarGraph</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.OneGeology.spatialRepresentationInfo.vectorSpatialRepresentation.topologylevelcode.surfaceGraph&quot; '>i18n.catalog.mdParam.OneGeology.spatialRepresentationInfo.vectorSpatialRepresentation.topologylevelcode.surfaceGraph</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.opendata.categories.caption&quot; '>i18n.catalog.mdParam.opendata.categories.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.opendata.distribution.about&quot; '>i18n.catalog.mdParam.opendata.distribution.about</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.opendata.distribution.accessURL&quot; '>i18n.catalog.mdParam.opendata.distribution.accessURL</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.opendata.distribution.byteSize&quot; '>i18n.catalog.mdParam.opendata.distribution.byteSize</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.opendata.distribution.caption&quot; '>i18n.catalog.mdParam.opendata.distribution.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.opendata.distribution.format&quot; '>i18n.catalog.mdParam.opendata.distribution.format</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.opendata.distribution.hint&quot; '>i18n.catalog.mdParam.opendata.distribution.hint</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.opendata.distribution.modified&quot; '>i18n.catalog.mdParam.opendata.distribution.modified</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.opendata.distribution.resource&quot; '>i18n.catalog.mdParam.opendata.distribution.resource</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.opendata.distribution.title&quot; '>i18n.catalog.mdParam.opendata.distribution.title</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.opendata.distributiongroup.caption&quot; '>i18n.catalog.mdParam.opendata.distributiongroup.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.opendata.identification.about&quot; '>i18n.catalog.mdParam.opendata.identification.about</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.opendata.identification.abstract&quot; '>i18n.catalog.mdParam.opendata.identification.abstract</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.opendata.identification.caption&quot; '>i18n.catalog.mdParam.opendata.identification.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.opendata.identification.creator&quot; '>i18n.catalog.mdParam.opendata.identification.creator</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.opendata.identification.email&quot; '>i18n.catalog.mdParam.opendata.identification.email</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.opendata.identification.language&quot; '>i18n.catalog.mdParam.opendata.identification.language</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.opendata.identification.license&quot; '>i18n.catalog.mdParam.opendata.identification.license</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.opendata.identification.license.freetext&quot; '>i18n.catalog.mdParam.opendata.identification.license.freetext</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.opendata.identification.license.freetext.caption&quot; '>i18n.catalog.mdParam.opendata.identification.license.freetext.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.opendata.identification.license.predefined&quot; '>i18n.catalog.mdParam.opendata.identification.license.predefined</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.opendata.identification.license.predefined.caption&quot; '>i18n.catalog.mdParam.opendata.identification.license.predefined.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.opendata.identification.license.predefined.CC0&quot; '>i18n.catalog.mdParam.opendata.identification.license.predefined.CC0</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.opendata.identification.license.predefined.CC4&quot; '>i18n.catalog.mdParam.opendata.identification.license.predefined.CC4</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.opendata.identification.license.predefined.CC-BY&quot; '>i18n.catalog.mdParam.opendata.identification.license.predefined.CC-BY</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.opendata.identification.license.predefined.CC-BY-SA&quot; '>i18n.catalog.mdParam.opendata.identification.license.predefined.CC-BY-SA</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.opendata.identification.license.predefined.CC-BY-SA-NC&quot; '>i18n.catalog.mdParam.opendata.identification.license.predefined.CC-BY-SA-NC</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.opendata.identification.license.predefined.IODL1.0&quot; '>i18n.catalog.mdParam.opendata.identification.license.predefined.IODL1.0</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.opendata.identification.license.predefined.IODL2.0&quot; '>i18n.catalog.mdParam.opendata.identification.license.predefined.IODL2.0</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.opendata.identification.license.predefined.IsaMetadata&quot; '>i18n.catalog.mdParam.opendata.identification.license.predefined.IsaMetadata</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.opendata.identification.license.predefined.ODbL&quot; '>i18n.catalog.mdParam.opendata.identification.license.predefined.ODbL</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.opendata.identification.modified&quot; '>i18n.catalog.mdParam.opendata.identification.modified</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.opendata.identification.resourceIdentifier&quot; '>i18n.catalog.mdParam.opendata.identification.resourceIdentifier</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.opendata.identification.resourceURL&quot; '>i18n.catalog.mdParam.opendata.identification.resourceURL</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.opendata.identification.title&quot; '>i18n.catalog.mdParam.opendata.identification.title</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.opendata.keyword&quot; '>i18n.catalog.mdParam.opendata.keyword</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.opendata.keyword.caption&quot; '>i18n.catalog.mdParam.opendata.keyword.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.opendata.maintheme&quot; '>i18n.catalog.mdParam.opendata.maintheme</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.opendata.publishing.caption&quot; '>i18n.catalog.mdParam.opendata.publishing.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.opendata.publishing.email&quot; '>i18n.catalog.mdParam.opendata.publishing.email</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.opendata.publishing.issued&quot; '>i18n.catalog.mdParam.opendata.publishing.issued</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.opendata.publishing.name&quot; '>i18n.catalog.mdParam.opendata.publishing.name</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.opendata.theme&quot; '>i18n.catalog.mdParam.opendata.theme</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.opendata.theme.caption&quot; '>i18n.catalog.mdParam.opendata.theme.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.operatesOn&quot; '>i18n.catalog.mdParam.operatesOn</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.portrayalCatalogueInfo.caption&quot; '>i18n.catalog.mdParam.portrayalCatalogueInfo.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.referenceSystemInfo.caption&quot; '>i18n.catalog.mdParam.referenceSystemInfo.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.referenceSystemInfo.code&quot; '>i18n.catalog.mdParam.referenceSystemInfo.code</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.referenceSystemInfo.codespace&quot; '>i18n.catalog.mdParam.referenceSystemInfo.codespace</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.atleastonedate.hint&quot; '>i18n.catalog.mdParam.rndt.atleastonedate.hint</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.constraints.access&quot; '>i18n.catalog.mdParam.rndt.constraints.access</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.constraints.caption&quot; '>i18n.catalog.mdParam.rndt.constraints.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.constraints.conditions.caption&quot; '>i18n.catalog.mdParam.rndt.constraints.conditions.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.constraints.conditions.free.caption&quot; '>i18n.catalog.mdParam.rndt.constraints.conditions.free.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.constraints.conditions.predefined.caption&quot; '>i18n.catalog.mdParam.rndt.constraints.conditions.predefined.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.constraints.conditions.public.caption&quot; '>i18n.catalog.mdParam.rndt.constraints.conditions.public.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.constraints.limitations&quot; '>i18n.catalog.mdParam.rndt.constraints.limitations</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.constraints.limitations.caption&quot; '>i18n.catalog.mdParam.rndt.constraints.limitations.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.constraints.limitations.freetext.caption&quot; '>i18n.catalog.mdParam.rndt.constraints.limitations.freetext.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.constraints.limitations.freetext&quot; '>i18n.catalog.mdParam.rndt.constraints.limitations.freetext</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.constraints.limitations.predefined.caption&quot; '>i18n.catalog.mdParam.rndt.constraints.limitations.predefined.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.constraints.limitations.predefined.NoApplicableConditions&quot; '>i18n.catalog.mdParam.rndt.constraints.limitations.predefined.NoApplicableConditions</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.constraints.limitations.predefined.UnknownConditions&quot; '>i18n.catalog.mdParam.rndt.constraints.limitations.predefined.UnknownConditions</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.constraints.limitations.predefined&quot; '>i18n.catalog.mdParam.rndt.constraints.limitations.predefined</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.constraints.other&quot; '>i18n.catalog.mdParam.rndt.constraints.other</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.constraints.security&quot; '>i18n.catalog.mdParam.rndt.constraints.security</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.constraints.service.caption&quot; '>i18n.catalog.mdParam.rndt.constraints.service.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.constraints.use&quot; '>i18n.catalog.schedaMetadati.VincoliFruibilita</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.containsoperations.caption&quot; '>i18n.catalog.mdParam.rndt.containsoperations.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.containsoperations_other.caption&quot; '>i18n.catalog.mdParam.rndt.containsoperations_other.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.dataQuality.caption&quot; '>i18n.catalog.mdParam.rndt.dataQuality.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.dataQuality.conformity.caption&quot; '>i18n.catalog.mdParam.rndt.dataQuality.conformity.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.dataQuality.conformity.caption_1&quot; '>i18n.catalog.mdParam.rndt.dataQuality.conformity.caption_1</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.dataQuality.conformity.caption_2d&quot; '>i18n.catalog.mdParam.rndt.dataQuality.conformity.caption_2d</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.dataQuality.conformity.caption_2s&quot; '>i18n.catalog.mdParam.rndt.dataQuality.conformity.caption_2s</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.dataQuality.conformity.caption_3&quot; '>i18n.catalog.mdParam.rndt.dataQuality.conformity.caption_3</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.dataQuality.conformity.caption_3s&quot; '>i18n.catalog.mdParam.rndt.dataQuality.conformity.caption_3s</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.dataQuality.conformity.date&quot; '>i18n.catalog.mdParam.rndt.dataQuality.conformity.date</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.dataQuality.conformity.date.inspire&quot; '>i18n.catalog.mdParam.rndt.dataQuality.conformity.date.inspire</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.dataQuality.conformity.date.inspireService&quot; '>i18n.catalog.mdParam.rndt.dataQuality.conformity.date.inspireService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.dataQuality.conformity.dateType&quot; '>i18n.catalog.mdParam.rndt.dataQuality.conformity.dateType</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.dataQuality.conformity.degree&quot; '>i18n.catalog.mdParam.rndt.dataQuality.conformity.degree</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.dataQuality.conformity.degree.conformant&quot; '>i18n.catalog.mdParam.rndt.dataQuality.conformity.degree.conformant</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.dataQuality.conformity.degree.notConformant&quot; '>i18n.catalog.mdParam.rndt.dataQuality.conformity.degree.notConformant</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.dataQuality.conformity.degree.notEvaluated&quot; '>i18n.catalog.mdParam.rndt.dataQuality.conformity.degree.notEvaluated</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.dataQuality.conformity.explanation&quot; '>i18n.catalog.mdParam.rndt.dataQuality.conformity.explanation</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.dataQuality.conformity.hint&quot; '>i18n.catalog.mdParam.rndt.dataQuality.conformity.hint</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.dataQuality.conformity.title&quot; '>i18n.catalog.mdParam.rndt.dataQuality.conformity.title</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.dataQuality.conformity.title.inspire&quot; '>i18n.catalog.mdParam.rndt.dataQuality.conformity.title.inspire</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.dataQuality.conformity.title.inspireDiscover&quot; '>i18n.catalog.mdParam.rndt.dataQuality.conformity.title.inspireDiscover</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.dataQuality.conformity.title.inspireDownload&quot; '>i18n.catalog.mdParam.rndt.dataQuality.conformity.title.inspireDownload</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.dataQuality.conformity.title.inspireInvoke&quot; '>i18n.catalog.mdParam.rndt.dataQuality.conformity.title.inspireInvoke</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.dataQuality.conformity.title.inspireService&quot; '>i18n.catalog.mdParam.rndt.dataQuality.conformity.title.inspireService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.dataQuality.conformity.title.inspireTransformation&quot; '>i18n.catalog.mdParam.rndt.dataQuality.conformity.title.inspireTransformation</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.dataQuality.conformity.title.inspireView&quot; '>i18n.catalog.mdParam.rndt.dataQuality.conformity.title.inspireView</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.dataQuality.conformity.titleINSPIRE&quot; '>i18n.catalog.mdParam.rndt.dataQuality.conformity.titleINSPIRE</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.dataQuality.level&quot; '>i18n.catalog.mdParam.rndt.dataQuality.level</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.dataQuality.level.hint&quot; '>i18n.catalog.mdParam.rndt.dataQuality.level.hint</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.dataQuality.lineage&quot; '>i18n.catalog.mdParam.rndt.dataQuality.lineage</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.dataQuality.positionalAccuracy.caption&quot; '>i18n.catalog.mdParam.rndt.dataQuality.positionalAccuracy.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.dataQuality.positionalAccuracy.value&quot; '>i18n.catalog.mdParam.rndt.dataQuality.positionalAccuracy.value</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.dataQuality.positionalAccuracy.valueUnit&quot; '>i18n.catalog.mdParam.rndt.dataQuality.positionalAccuracy.valueUnit</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.dataQuality.positionalAccuracy.valueUnit.m&quot; '>i18n.catalog.mdParam.rndt.dataQuality.positionalAccuracy.valueUnit.m</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.general.contact.organizationInfo.onlineResource.protocol&quot; '>i18n.catalog.mdParam.rndt.dataset.protocol</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.general.contact.organizationInfo.onlineResource.applicationProfile&quot; '>i18n.catalog.mdParam.rndt.dataset.applicationProfile</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.general.contact.organizationInfo.onlineResource.description&quot; '>i18n.catalog.mdParam.rndt.dataset.description</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.dataQuality.topologicalConsistency.caption&quot; '>i18n.catalog.iso19139.DQ_TopologicalConsistency</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.dataQuality.topologicalConsistency.nameOfMeasure&quot; '>i18n.catalog.iso19139.AbstractDQ_Element.nameOfMeasure</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.dataQuality.topologicalConsistency.evaluationMethodType&quot; '>i18n.catalog.iso19139.AbstractDQ_Element.evaluationMethodType</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.dataQuality.topologicalConsistency.evaluationMethodDescription&quot; '>i18n.catalog.iso19139.AbstractDQ_Element.evaluationMethodDescription</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.dataQuality.topologicalConsistency.dateTime&quot; '>i18n.catalog.iso19139.AbstractDQ_Element.dateTime</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.dataQuality.topologicalConsistency.value&quot; '>i18n.catalog.mdParam.referenceSystemInfo.caption.measurement.valore</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.dataQuality.service.caption&quot; '>i18n.catalog.mdParam.rndt.dataQuality.service.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.distribution.caption&quot; '>i18n.catalog.mdParam.rndt.distribution.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.distribution.distributor.caption&quot; '>i18n.catalog.mdParam.rndt.distribution.distributor.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.distribution.distributor.individual&quot; '>i18n.catalog.mdParam.rndt.distribution.distributor.individual</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.distribution.distributor.organization&quot; '>i18n.catalog.mdParam.rndt.distribution.distributor.organization</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.distribution.distributor.organizationInfo.caption&quot; '>i18n.catalog.mdParam.rndt.distribution.distributor.organizationInfo.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.distribution.distributor.organizationInfo.email&quot; '>i18n.catalog.mdParam.rndt.distribution.distributor.organizationInfo.email</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.distribution.distributor.organizationInfo.onlineResource&quot; '>i18n.catalog.mdParam.rndt.distribution.distributor.organizationInfo.onlineResource</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.distribution.distributor.organizationInfo.onlineResource.hint&quot; '>i18n.catalog.mdParam.rndt.distribution.distributor.organizationInfo.onlineResource.hint</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.distribution.distributor.organizationInfo.phoneNumber&quot; '>i18n.catalog.mdParam.rndt.distribution.distributor.organizationInfo.phoneNumber</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.distribution.distributor.position&quot; '>i18n.catalog.mdParam.rndt.distribution.distributor.position</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.distribution.distributor.role&quot; '>i18n.catalog.mdParam.rndt.distribution.distributor.role</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.distribution.format.caption&quot; '>i18n.catalog.mdParam.rndt.distribution.format.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.distribution.format.name&quot; '>i18n.catalog.mdParam.rndt.distribution.format.name</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.distribution.format.version&quot; '>i18n.catalog.mdParam.rndt.distribution.format.version</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.distribution.onlineResource&quot; '>i18n.catalog.mdParam.rndt.distribution.onlineResource</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.distribution.onlineresource.caption&quot; '>i18n.catalog.mdParam.rndt.distribution.onlineresource.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.distribution.protocol&quot; '>i18n.catalog.mdParam.rndt.distribution.protocol</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.distribution.protocol.AUDIO&quot; '>i18n.catalog.mdParam.rndt.distribution.protocol.AUDIO</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.distribution.protocol.DATASET&quot; '>i18n.catalog.mdParam.rndt.distribution.protocol.DATASET</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.distribution.protocol.DOCS&quot; '>i18n.catalog.mdParam.rndt.distribution.protocol.DOCS</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.distribution.protocol.DOWNLOAD-DATA&quot; '>i18n.catalog.mdParam.rndt.distribution.protocol.DOWNLOAD-DATA</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.distribution.protocol.KML-2.2.0&quot; '>i18n.catalog.mdParam.rndt.distribution.protocol.KML-2.2.0</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.distribution.protocol.LINK&quot; '>i18n.catalog.mdParam.rndt.distribution.protocol.LINK</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.distribution.protocol.METEO&quot; '>i18n.catalog.mdParam.rndt.distribution.protocol.METEO</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.distribution.protocol.OFFLINE-DATA&quot; '>i18n.catalog.mdParam.rndt.distribution.protocol.OFFLINE-DATA</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.distribution.protocol.REST-GP&quot; '>i18n.catalog.mdParam.rndt.distribution.protocol.REST-GP</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.distribution.protocol.REST-IMAGE&quot; '>i18n.catalog.mdParam.rndt.distribution.protocol.REST-IMAGE</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.distribution.protocol.REST-MAP&quot; '>i18n.catalog.mdParam.rndt.distribution.protocol.REST-MAP</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.distribution.protocol.STATIC-IMAGE&quot; '>i18n.catalog.mdParam.rndt.distribution.protocol.STATIC-IMAGE</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.distribution.protocol.STATIC-MAP&quot; '>i18n.catalog.mdParam.rndt.distribution.protocol.STATIC-MAP</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.distribution.protocol.VIDEO&quot; '>i18n.catalog.mdParam.rndt.distribution.protocol.VIDEO</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.distribution.protocol.WCS-1.1.2&quot; '>i18n.catalog.mdParam.rndt.distribution.protocol.WCS-1.1.2</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.distribution.protocol.WCS-2.0.0&quot; '>i18n.catalog.mdParam.rndt.distribution.protocol.WCS-2.0.0</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.distribution.protocol.WEBAPP&quot; '>i18n.catalog.mdParam.rndt.distribution.protocol.WEBAPP</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.distribution.protocol.WFS-1.1.0&quot; '>i18n.catalog.mdParam.rndt.distribution.protocol.WFS-1.1.0</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.distribution.protocol.WFS-2.0.0&quot; '>i18n.catalog.mdParam.rndt.distribution.protocol.WFS-2.0.0</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.distribution.protocol.WMS-1.1.1&quot; '>i18n.catalog.mdParam.rndt.distribution.protocol.WMS-1.1.1</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.distribution.protocol.WMS-1.3.0&quot; '>i18n.catalog.mdParam.rndt.distribution.protocol.WMS-1.3.0</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.distribution.protocol.WMTS-1.0.0&quot; '>i18n.catalog.mdParam.rndt.distribution.protocol.WMTS-1.0.0</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.empty&quot; '>i18n.catalog.mdParam.rndt.empty</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.extent.caption&quot; '>i18n.catalog.mdParam.rndt.extent.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.extent.envelope.caption&quot; '>i18n.catalog.mdParam.rndt.extent.envelope.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.extent.envelope.east&quot; '>i18n.catalog.mdParam.rndt.extent.envelope.east</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.extent.envelope.north&quot; '>i18n.catalog.mdParam.rndt.extent.envelope.north</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.extent.envelope.south&quot; '>i18n.catalog.mdParam.rndt.extent.envelope.south</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.extent.envelope.west&quot; '>i18n.catalog.mdParam.rndt.extent.envelope.west</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.extent.temporal.begin&quot; '>i18n.catalog.mdParam.rndt.extent.temporal.begin</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.extent.temporal.caption&quot; '>i18n.catalog.mdParam.rndt.extent.temporal.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.extent.temporal.end&quot; '>i18n.catalog.mdParam.rndt.extent.temporal.end</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.extent.vertical.caption&quot; '>i18n.catalog.mdParam.rndt.extent.vertical.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.extent.vertical.maximum&quot; '>i18n.catalog.mdParam.rndt.extent.vertical.maximum</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.extent.vertical.minimum&quot; '>i18n.catalog.mdParam.rndt.extent.vertical.minimum</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.extent.vertical.verticalCRS&quot; '>i18n.catalog.mdParam.rndt.extent.vertical.verticalCRS</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.gemet.date&quot; '>i18n.catalog.mdParam.rndt.gemet.date</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.gemet.title&quot; '>i18n.catalog.mdParam.rndt.gemet.title</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.general.caption&quot; '>i18n.catalog.mdParam.rndt.general.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.general.contact.caption&quot; '>i18n.catalog.mdParam.rndt.general.contact.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.general.contact.creatore.caption&quot; '>i18n.catalog.mdParam.rndt.general.contact.creatore.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.general.contact.creatore.individual&quot; '>i18n.catalog.mdParam.rndt.general.contact.creatore.individual</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.general.contact.creatore.organization&quot; '>i18n.catalog.mdParam.rndt.general.contact.creatore.organization</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.general.contact.creatore.organizationInfo.caption&quot; '>i18n.catalog.mdParam.rndt.general.contact.creatore.organizationInfo.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.general.contact.creatore.organizationInfo.email&quot; '>i18n.catalog.mdParam.rndt.general.contact.creatore.organizationInfo.email</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.general.contact.creatore.organizationInfo.onlineResource&quot; '>i18n.catalog.mdParam.rndt.general.contact.creatore.organizationInfo.onlineResource</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.general.contact.creatore.organizationInfo.onlineResource.hint&quot; '>i18n.catalog.mdParam.rndt.general.contact.creatore.organizationInfo.onlineResource.hint</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.general.contact.creatore.organizationInfo.phoneNumber&quot; '>i18n.catalog.mdParam.rndt.general.contact.creatore.organizationInfo.phoneNumber</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.general.contact.creatore.position&quot; '>i18n.catalog.mdParam.rndt.general.contact.creatore.position</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.general.contact.creatore.role&quot; '>i18n.catalog.mdParam.rndt.general.contact.creatore.role</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.general.contact.individual&quot; '>i18n.catalog.mdParam.rndt.general.contact.individual</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.general.contact.organization&quot; '>i18n.catalog.mdParam.rndt.general.contact.organization</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.general.contact.organizationInfo.caption&quot; '>i18n.catalog.mdParam.rndt.general.contact.organizationInfo.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.general.contact.organizationInfo.email&quot; '>i18n.catalog.mdParam.rndt.general.contact.organizationInfo.email</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.general.contact.organizationInfo.onlineResource&quot; '>i18n.catalog.mdParam.rndt.general.contact.organizationInfo.onlineResource</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.general.contact.organizationInfo.onlineResource.hint&quot; '>i18n.catalog.mdParam.rndt.general.contact.organizationInfo.onlineResource.hint</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.general.contact.organizationInfo.phoneNumber&quot; '>i18n.catalog.mdParam.rndt.general.contact.organizationInfo.phoneNumber</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.general.contact.position&quot; '>i18n.catalog.mdParam.rndt.general.contact.position</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.general.contact.role&quot; '>i18n.catalog.mdParam.rndt.general.contact.role</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.general.datestamp&quot; '>i18n.catalog.mdParam.rndt.general.datestamp</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.general.fileIdentifier&quot; '>i18n.catalog.mdParam.rndt.general.fileIdentifier</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.general.hierarchyLevel&quot; '>i18n.catalog.mdParam.rndt.general.hierarchyLevel</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.general.hierarchyLevelName&quot; '>i18n.catalog.mdParam.rndt.general.hierarchyLevelName</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.general.language&quot; '>i18n.catalog.mdParam.rndt.general.language</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.general.parentIdentifier&quot; '>i18n.catalog.mdParam.rndt.general.parentIdentifier</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.general.standardName&quot; '>i18n.catalog.mdParam.rndt.general.standardName</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.general.standardVersion&quot; '>i18n.catalog.mdParam.rndt.general.standardVersion</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.general.standardVersion.metadataStandardName&quot; '>i18n.catalog.mdParam.rndt.general.standardVersion.metadataStandardName</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.general.standardVersion.metadataStandardVersion&quot; '>i18n.catalog.mdParam.rndt.general.standardVersion.metadataStandardVersion</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.abstract&quot; '>i18n.catalog.mdParam.rndt.identification.abstract</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.caption&quot; '>i18n.catalog.mdParam.rndt.identification.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.categorieskeywords.caption&quot; '>i18n.catalog.mdParam.rndt.identification.categorieskeywords.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.categorieskeywords.categories.caption&quot; '>i18n.catalog.mdParam.rndt.identification.categorieskeywords.categories.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.categorieskeywords.keywords.caption&quot; '>i18n.catalog.mdParam.rndt.identification.categorieskeywords.keywords.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.contact.caption&quot; '>i18n.catalog.mdParam.rndt.identification.contact.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.contact.individual&quot; '>i18n.catalog.mdParam.rndt.identification.contact.individual</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.contact.organization&quot; '>i18n.catalog.mdParam.rndt.identification.contact.organization</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.contact.organizationInfo.caption&quot; '>i18n.catalog.mdParam.rndt.identification.contact.organizationInfo.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.contact.organizationInfo.email&quot; '>i18n.catalog.mdParam.rndt.identification.contact.organizationInfo.email</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.contact.organizationInfo.onlineResource&quot; '>i18n.catalog.mdParam.rndt.identification.contact.organizationInfo.onlineResource</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.contact.organizationInfo.onlineResource.hint&quot; '>i18n.catalog.mdParam.rndt.identification.contact.organizationInfo.onlineResource.hint</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.contact.organizationInfo.phoneNumber&quot; '>i18n.catalog.mdParam.rndt.identification.contact.organizationInfo.phoneNumber</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.contact.position&quot; '>i18n.catalog.mdParam.rndt.identification.contact.position</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.contact.role&quot; '>i18n.catalog.mdParam.rndt.identification.contact.role</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.contact1.caption&quot; '>i18n.catalog.mdParam.rndt.identification.contact1.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.contact2.caption&quot; '>i18n.catalog.mdParam.rndt.identification.contact2.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.contact3.caption&quot; '>i18n.catalog.mdParam.rndt.identification.contact3.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.contactother.caption&quot; '>i18n.catalog.mdParam.rndt.identification.contactother.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.containsoperations.connectpoint&quot; '>i18n.catalog.mdParam.rndt.identification.containsoperations.connectpoint</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.containsoperations.DCP&quot; '>i18n.catalog.mdParam.rndt.identification.containsoperations.DCP</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.containsoperations.invocationName&quot; '>i18n.catalog.mdParam.rndt.identification.containsoperations.invocationName</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.containsoperations.invocationName.hint&quot; '>i18n.catalog.mdParam.rndt.identification.containsoperations.invocationName.hint</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.containsoperations.operationname&quot; '>i18n.catalog.mdParam.rndt.identification.containsoperations.operationname</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.coupledresource.caption&quot; '>i18n.catalog.mdParam.rndt.identification.coupledresource.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.coupledresource.couplingType&quot; '>i18n.catalog.mdParam.rndt.identification.coupledresource.couplingType</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.coupledresource.operateson.operatesOn&quot; '>i18n.catalog.mdParam.rndt.identification.coupledresource.operateson.operatesOn</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.coupledresource.operateson.operatesOn.hint&quot; '>i18n.catalog.mdParam.rndt.identification.coupledresource.operateson.operatesOn.hint</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.coupledresource.operateson.operatesOnUUID&quot; '>i18n.catalog.mdParam.rndt.identification.coupledresource.operateson.operatesOnUUID</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.datacontacts.caption&quot; '>i18n.catalog.mdParam.rndt.identification.datacontacts.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.datasetIdentifier&quot; '>i18n.catalog.mdParam.rndt.identification.datasetIdentifier</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.date&quot; '>i18n.catalog.mdParam.rndt.identification.date</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.date.creation&quot; '>i18n.catalog.mdParam.rndt.identification.date.creation</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.date.publication&quot; '>i18n.catalog.mdParam.rndt.identification.date.publication</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.date.revision&quot; '>i18n.catalog.mdParam.rndt.identification.date.revision</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.date.rilievo&quot; '>i18n.catalog.mdParam.rndt.identification.date.rilievo</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.details.caption&quot; '>i18n.catalog.mdParam.rndt.identification.details.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.keyword.free.caption&quot; '>i18n.catalog.mdParam.rndt.identification.keyword.free.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.keyword.free.keyword&quot; '>i18n.catalog.mdParam.rndt.identification.keyword.free.keyword</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.keyword.free.singlekeyword&quot; '>i18n.catalog.mdParam.rndt.identification.keyword.free.singlekeyword</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.keyword.gemet.caption&quot; '>i18n.catalog.mdParam.rndt.identification.keyword.gemet.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.keyword.gemet.date&quot; '>i18n.catalog.mdParam.rndt.identification.keyword.gemet.date</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.keyword.gemet.dateType&quot; '>i18n.catalog.mdParam.rndt.identification.keyword.gemet.dateType</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.keyword.gemet.keyword&quot; '>i18n.catalog.mdParam.rndt.identification.keyword.gemet.keyword</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.keyword.gemet.title&quot; '>i18n.catalog.mdParam.rndt.identification.keyword.gemet.title</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.keyword.gemet.title.gemetDate&quot; '>i18n.catalog.mdParam.rndt.identification.keyword.gemet.title.gemetDate</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.keyword.gemet.title.gemetTitle&quot; '>i18n.catalog.mdParam.rndt.identification.keyword.gemet.title.gemetTitle</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.keyword.service.caption&quot; '>i18n.catalog.mdParam.rndt.identification.keyword.service.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.keyword.servicecategory&quot; '>i18n.catalog.mdParam.rndt.identification.keyword.servicecategory</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.keyword.thesaurus.caption&quot; '>i18n.catalog.mdParam.rndt.identification.keyword.thesaurus.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.keyword.thesaurus.date&quot; '>i18n.catalog.mdParam.rndt.identification.keyword.thesaurus.date</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.keyword.thesaurus.dateType&quot; '>i18n.catalog.mdParam.rndt.identification.keyword.thesaurus.dateType</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.keyword.thesaurus.keyword&quot; '>i18n.catalog.mdParam.rndt.identification.keyword.thesaurus.keyword</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.keyword.thesaurus.title&quot; '>i18n.catalog.mdParam.rndt.identification.keyword.thesaurus.title</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.keyword.thesaurusgemet.caption&quot; '>i18n.catalog.mdParam.rndt.identification.keyword.thesaurusgemet.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.language&quot; '>i18n.catalog.mdParam.rndt.identification.language</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.otherDetails&quot; '>i18n.catalog.mdParam.rndt.identification.otherDetails</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.parentIdentifier&quot; '>i18n.catalog.mdParam.rndt.identification.parentIdentifier</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.pointOfContact.caption&quot; '>i18n.catalog.mdParam.rndt.identification.pointOfContact.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.pointOfContact.individual&quot; '>i18n.catalog.mdParam.rndt.identification.pointOfContact.individual</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.pointOfContact.organization&quot; '>i18n.catalog.mdParam.rndt.identification.pointOfContact.organization</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.pointOfContact.organizationInfo.caption&quot; '>i18n.catalog.mdParam.rndt.identification.pointOfContact.organizationInfo.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.pointOfContact.organizationInfo.email&quot; '>i18n.catalog.mdParam.rndt.identification.pointOfContact.organizationInfo.email</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.pointOfContact.organizationInfo.onlineResource&quot; '>i18n.catalog.mdParam.rndt.identification.pointOfContact.organizationInfo.onlineResource</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.pointOfContact.organizationInfo.onlineResource.hint&quot; '>i18n.catalog.mdParam.rndt.identification.pointOfContact.organizationInfo.onlineResource.hint</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.pointOfContact.organizationInfo.phoneNumber&quot; '>i18n.catalog.mdParam.rndt.identification.pointOfContact.organizationInfo.phoneNumber</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.pointOfContact.position&quot; '>i18n.catalog.mdParam.rndt.identification.pointOfContact.position</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.pointOfContact.role&quot; '>i18n.catalog.mdParam.rndt.identification.pointOfContact.role</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.pointOfContactother.caption&quot; '>i18n.catalog.mdParam.rndt.identification.pointOfContactother.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.presentationForm&quot; '>i18n.catalog.mdParam.rndt.identification.presentationForm</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.resolution&quot; '>i18n.catalog.mdParam.rndt.identification.resolution</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.resolution.caption&quot; '>i18n.catalog.mdParam.rndt.identification.resolution.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.resolution.distance&quot; '>i18n.catalog.mdParam.rndt.identification.resolution.distance</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.resolution.equivalentScale&quot; '>i18n.catalog.mdParam.rndt.identification.resolution.equivalentScale</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.resolution.equivalentScale.hint&quot; '>i18n.catalog.mdParam.rndt.identification.resolution.equivalentScale.hint</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.resolution.representationType&quot; '>i18n.catalog.mdParam.rndt.identification.resolution.representationType</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.resolution.spatialResolution&quot; '>i18n.catalog.mdParam.rndt.identification.resolution.spatialResolution</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.service&quot; '>i18n.catalog.mdParam.rndt.identification.service</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.service.caption&quot; '>i18n.catalog.mdParam.rndt.identification.service.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.service.categorieskeywords.caption&quot; '>i18n.catalog.mdParam.rndt.identification.service.categorieskeywords.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.service.title&quot; '>i18n.catalog.mdParam.rndt.identification.service.title</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicecontacts.caption&quot; '>i18n.catalog.mdParam.rndt.identification.servicecontacts.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.serviceType&quot; '>i18n.catalog.mdParam.rndt.identification.serviceType</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.serviceType.caption&quot; '>i18n.catalog.mdParam.rndt.identification.serviceType.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.chainDefinitionService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.chainDefinitionService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.comEncodingService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.comEncodingService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.comGeographicCompressionService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.comGeographicCompressionService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.comGeographicFormatConversionService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.comGeographicFormatConversionService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.comMessagingService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.comMessagingService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.comRemoteFileAndExecutableManagement&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.comRemoteFileAndExecutableManagement</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.comService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.comService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.comTransferService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.comTransferService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.humanCatalogueViewer&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.humanCatalogueViewer</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.humanChainDefinitionEditor&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.humanChainDefinitionEditor</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.humanFeatureGeneralizationEditor&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.humanFeatureGeneralizationEditor</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.humanGeographicDataStructureViewer&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.humanGeographicDataStructureViewer</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.humanGeographicFeatureEditor&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.humanGeographicFeatureEditor</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.humanGeographicSpreadsheetViewer&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.humanGeographicSpreadsheetViewer</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.humanGeographicSymbolEditor&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.humanGeographicSymbolEditor</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.humanGeographicViewer&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.humanGeographicViewer</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.humanInteractionService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.humanInteractionService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.humanServiceEditor&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.humanServiceEditor</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.humanWorkflowEnactmentManager&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.humanWorkflowEnactmentManager</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.infoCatalogueService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.infoCatalogueService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.infoCoverageAccessService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.infoCoverageAccessService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.infoFeatureAccessService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.infoFeatureAccessService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.infoFeatureTypeService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.infoFeatureTypeService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.infoGazetteerService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.infoGazetteerService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.infoManagementService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.infoManagementService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.infoMapAccessService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.infoMapAccessService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.infoOrderHandlingService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.infoOrderHandlingService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.infoProductAccessService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.infoProductAccessService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.infoRegistryService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.infoRegistryService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.infoSensorDescriptionService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.infoSensorDescriptionService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.infoStandingOrderService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.infoStandingOrderService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.metadataGeographicAnnotationService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.metadataGeographicAnnotationService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.metadataProcessingService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.metadataProcessingService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.metadataStatisticalCalculationService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.metadataStatisticalCalculationService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.spatialCoordinateConversionService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.spatialCoordinateConversionService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.spatialCoordinateTransformationService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.spatialCoordinateTransformationService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.spatialCoverageVectorConversionService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.spatialCoverageVectorConversionService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.spatialDimensionMeasurementService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.spatialDimensionMeasurementService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.spatialFeatureGeneralizationService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.spatialFeatureGeneralizationService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.spatialFeatureManipulationService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.spatialFeatureManipulationService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.spatialFeatureMatchingService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.spatialFeatureMatchingService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.spatialImageCoordinateConversionService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.spatialImageCoordinateConversionService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.spatialImageGeometryModelConversionService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.spatialImageGeometryModelConversionService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.spatialOrthorectificationService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.spatialOrthorectificationService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.spatialPositioningService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.spatialPositioningService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.spatialProcessingService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.spatialProcessingService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.spatialProximityAnalysisService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.spatialProximityAnalysisService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.spatialRectificationService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.spatialRectificationService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.spatialRouteDeterminationService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.spatialRouteDeterminationService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.spatialSamplingService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.spatialSamplingService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.spatialSensorGeometryModelAdjustmentService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.spatialSensorGeometryModelAdjustmentService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.spatialSubsettingService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.spatialSubsettingService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.spatialTilingChangeService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.spatialTilingChangeService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.subscriptionService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.subscriptionService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.taskManagementService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.taskManagementService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.temporalProcessingService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.temporalProcessingService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.temporalProximityAnalysisService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.temporalProximityAnalysisService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.temporalReferenceSystemTransformationService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.temporalReferenceSystemTransformationService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.temporalSamplingService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.temporalSamplingService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.temporalSubsettingService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.temporalSubsettingService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.thematicChangeDetectionService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.thematicChangeDetectionService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.thematicClassificationService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.thematicClassificationService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.thematicFeatureGeneralizationService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.thematicFeatureGeneralizationService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.thematicGeocodingService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.thematicGeocodingService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.thematicGeographicInformationExtractionService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.thematicGeographicInformationExtractionService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.thematicGeoparsingService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.thematicGeoparsingService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.thematicGoparameterCalculationService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.thematicGoparameterCalculationService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.thematicImageManipulationService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.thematicImageManipulationService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.thematicImageProcessingService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.thematicImageProcessingService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.thematicImageSynthesisService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.thematicImageSynthesisService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.thematicImageUnderstandingService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.thematicImageUnderstandingService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.thematicMultibandImageManipulationService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.thematicMultibandImageManipulationService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.thematicObjectDetectionService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.thematicObjectDetectionService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.thematicProcessingService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.thematicProcessingService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.thematicReducedResolutionGenerationService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.thematicReducedResolutionGenerationService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.thematicSpatialCountingService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.thematicSpatialCountingService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.thematicSubsettingService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.thematicSubsettingService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.servicetype.workflowEnactmentService&quot; '>i18n.catalog.mdParam.rndt.identification.servicetype.workflowEnactmentService</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.supplementalInformation&quot; '>i18n.catalog.mdParam.rndt.identification.supplementalInformation</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.thumbnail.caption&quot; '>i18n.catalog.mdParam.rndt.identification.thumbnail.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.thumbnail.description&quot; '>i18n.catalog.schedaMetadati.thumbnail.description</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.thumbnail.type&quot; '>i18n.catalog.schedaMetadati.thumbnail.type</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.thumbnail.url&quot; '>i18n.catalog.schedaMetadati.thumbnail.url</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.title&quot; '>i18n.catalog.mdParam.rndt.identification.title</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.topics&quot; '>i18n.catalog.mdParam.rndt.identification.topics</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.maintenance.caption&quot; '>i18n.catalog.mdParam.rndt.maintenance.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.maintenance.code&quot; '>i18n.catalog.mdParam.rndt.maintenance.code</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.maintenance.code_no&quot; '>i18n.catalog.mdParam.rndt.maintenance.code_no</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.raster.caption&quot; '>i18n.catalog.mdParam.rndt.raster.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.raster.contentinfo.attribute&quot; '>i18n.catalog.mdParam.rndt.raster.contentinfo.attribute</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.raster.contentinfo.caption&quot; '>i18n.catalog.mdParam.rndt.raster.contentinfo.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.raster.contentinfo.contenttype&quot; '>i18n.catalog.mdParam.rndt.raster.contentinfo.contenttype</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.raster.contentinfo.dimension&quot; '>i18n.catalog.mdParam.rndt.raster.contentinfo.dimension</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.raster.contentinfo.triangulation&quot; '>i18n.catalog.mdParam.rndt.raster.contentinfo.triangulation</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.raster.contentinfo.triangulation.false&quot; '>i18n.catalog.mdParam.rndt.raster.contentinfo.triangulation.false</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.raster.contentinfo.triangulation.true&quot; '>i18n.catalog.mdParam.rndt.raster.contentinfo.triangulation.true</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.raster.spatial.caption&quot; '>i18n.catalog.mdParam.rndt.raster.spatial.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.raster.spatial.cellgeometry&quot; '>i18n.catalog.mdParam.rndt.raster.spatial.cellgeometry</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.raster.spatial.dimensions.caption&quot; '>i18n.catalog.mdParam.rndt.raster.spatial.dimensions.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.raster.spatial.georectified.caption&quot; '>i18n.catalog.mdParam.rndt.raster.spatial.georectified.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.raster.spatial.georectified.checkavail&quot; '>i18n.catalog.mdParam.rndt.raster.spatial.georectified.checkavail</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.raster.spatial.georectified.checkavail.false&quot; '>i18n.catalog.mdParam.rndt.raster.spatial.georectified.checkavail.false</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.raster.spatial.georectified.checkavail.true&quot; '>i18n.catalog.mdParam.rndt.raster.spatial.georectified.checkavail.true</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.raster.spatial.georectified.checkdescr&quot; '>i18n.catalog.mdParam.rndt.raster.spatial.georectified.checkdescr</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.raster.spatial.georectified.checkdescr.hint&quot; '>i18n.catalog.mdParam.rndt.raster.spatial.georectified.checkdescr.hint</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.raster.spatial.georectified.corner.hint&quot; '>i18n.catalog.mdParam.rndt.raster.spatial.georectified.corner.hint</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.raster.spatial.georectified.cornerhighleft&quot; '>i18n.catalog.mdParam.rndt.raster.spatial.georectified.cornerhighleft</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.raster.spatial.georectified.cornerlowright&quot; '>i18n.catalog.mdParam.rndt.raster.spatial.georectified.cornerlowright</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.raster.spatial.georectified.pixelpoint&quot; '>i18n.catalog.mdParam.rndt.raster.spatial.georectified.pixelpoint</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.raster.spatial.georectified.cornerPoint.id&quot; '>i18n.catalog.mdParam.rndt.raster.spatial.georectified.cornerPoint.id</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.raster.spatial.georectified.cornerPoint.name&quot; '>i18n.catalog.mdParam.rndt.raster.spatial.georectified.cornerPoint.name</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.raster.spatial.georectified.cornerPoint.position&quot; '>i18n.catalog.mdParam.rndt.raster.spatial.georectified.cornerPoint.position</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.raster.spatial.georeferenceable.caption&quot; '>i18n.catalog.mdParam.rndt.raster.spatial.georeferenceable.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.raster.spatial.georeferenceable.controlavail&quot; '>i18n.catalog.mdParam.rndt.raster.spatial.georeferenceable.controlavail</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.raster.spatial.georeferenceable.controlavail.false&quot; '>i18n.catalog.mdParam.rndt.raster.spatial.georeferenceable.controlavail.false</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.raster.spatial.georeferenceable.controlavail.true&quot; '>i18n.catalog.mdParam.rndt.raster.spatial.georeferenceable.controlavail.true</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.raster.spatial.georeferenceable.orientavail&quot; '>i18n.catalog.mdParam.rndt.raster.spatial.georeferenceable.orientavail</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.raster.spatial.georeferenceable.orientavail.false&quot; '>i18n.catalog.mdParam.rndt.raster.spatial.georeferenceable.orientavail.false</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.raster.spatial.georeferenceable.orientavail.true&quot; '>i18n.catalog.mdParam.rndt.raster.spatial.georeferenceable.orientavail.true</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.raster.spatial.georeferenceable.parameter&quot; '>i18n.catalog.mdParam.rndt.raster.spatial.georeferenceable.parameter</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.raster.spatial.numberdimension&quot; '>i18n.catalog.mdParam.rndt.raster.spatial.numberdimension</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.raster.spatial.properties.caption&quot; '>i18n.catalog.mdParam.rndt.raster.spatial.properties.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.raster.spatial.properties.measure&quot; '>i18n.catalog.mdParam.rndt.raster.spatial.properties.measure</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.raster.spatial.properties.name&quot; '>i18n.catalog.mdParam.rndt.raster.spatial.properties.name</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.raster.spatial.properties.resolution&quot; '>i18n.catalog.mdParam.rndt.raster.spatial.properties.resolution</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.raster.spatial.transformation&quot; '>i18n.catalog.mdParam.rndt.raster.spatial.transformation</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.raster.spatial.transformation.false&quot; '>i18n.catalog.mdParam.rndt.raster.spatial.transformation.false</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.raster.spatial.transformation.true&quot; '>i18n.catalog.mdParam.rndt.raster.spatial.transformation.true</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.referenceSystemInfo.caption&quot; '>i18n.catalog.mdParam.rndt.referenceSystemInfo.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.referenceSystemInfo.code&quot; '>i18n.catalog.mdParam.rndt.referenceSystemInfo.code</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.rilievo.hint&quot; '>i18n.catalog.mdParam.rndt.rilievo.hint</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.temporalElement.BeginEnd&quot; '>i18n.catalog.mdParam.rndt.temporalElement.BeginEnd</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.agportal.iteminfo&quot; '>i18n.catalog.mdParam.schema.agportal.iteminfo</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.dc&quot; '>i18n.catalog.mdParam.schema.dc</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.dcat&quot; '>i18n.catalog.mdParam.schema.dcat</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.dcat.accessLevel&quot; '>i18n.catalog.mdParam.schema.dcat.accessLevel</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.dcat.accessLevel.nonPublic&quot; '>i18n.catalog.mdParam.schema.dcat.accessLevel.nonPublic</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.dcat.accessLevel.public&quot; '>i18n.catalog.mdParam.schema.dcat.accessLevel.public</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.dcat.accessLevel.restrictedPublic&quot; '>i18n.catalog.mdParam.schema.dcat.accessLevel.restrictedPublic</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.dcat.accrualPeriodicity&quot; '>i18n.catalog.mdParam.schema.dcat.accrualPeriodicity</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.dcat.bureauCode&quot; '>i18n.catalog.mdParam.schema.dcat.bureauCode</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.dcat.contactPoint&quot; '>i18n.catalog.mdParam.schema.dcat.contactPoint</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.dcat.contactPoint.fn&quot; '>i18n.catalog.mdParam.schema.dcat.contactPoint.fn</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.dcat.contactPoint.hasEmail&quot; '>i18n.catalog.mdParam.schema.dcat.contactPoint.hasEmail</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.dcat.dataQuality&quot; '>i18n.catalog.mdParam.schema.dcat.dataQuality</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.dcat.dataset&quot; '>i18n.catalog.mdParam.schema.dcat.dataset</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.dcat.date&quot; '>i18n.catalog.mdParam.schema.dcat.date</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.dcat.distribution&quot; '>i18n.catalog.mdParam.schema.dcat.distribution</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.dcat.distribution.accessURL&quot; '>i18n.catalog.mdParam.schema.dcat.distribution.accessURL</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.dcat.distribution.description&quot; '>i18n.catalog.mdParam.schema.dcat.distribution.description</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.dcat.distribution.downloadURL&quot; '>i18n.catalog.mdParam.schema.dcat.distribution.downloadURL</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.dcat.distribution.format&quot; '>i18n.catalog.mdParam.schema.dcat.distribution.format</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.dcat.distribution.mediaType&quot; '>i18n.catalog.mdParam.schema.dcat.distribution.mediaType</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.dcat.distribution.title&quot; '>i18n.catalog.mdParam.schema.dcat.distribution.title</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.dcat.eastBoundLongitude&quot; '>i18n.catalog.mdParam.schema.dcat.eastBoundLongitude</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.dcat.isPartOf&quot; '>i18n.catalog.mdParam.schema.dcat.isPartOf</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.dcat.landingPage&quot; '>i18n.catalog.mdParam.schema.dcat.landingPage</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.dcat.language&quot; '>i18n.catalog.mdParam.schema.dcat.language</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.dcat.license&quot; '>i18n.catalog.mdParam.schema.dcat.license</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.dcat.northBoundLatitude&quot; '>i18n.catalog.mdParam.schema.dcat.northBoundLatitude</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.dcat.primaryITInvestmentUII&quot; '>i18n.catalog.mdParam.schema.dcat.primaryITInvestmentUII</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.dcat.programCode&quot; '>i18n.catalog.mdParam.schema.dcat.programCode</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.dcat.publisher.name&quot; '>i18n.catalog.mdParam.schema.dcat.publisher.name</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.dcat.publisher.subOrganizationOf&quot; '>i18n.catalog.mdParam.schema.dcat.publisher.subOrganizationOf</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.dcat.references&quot; '>i18n.catalog.mdParam.schema.dcat.references</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.dcat.rights&quot; '>i18n.catalog.mdParam.schema.dcat.rights</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.dcat.southBoundLatitude&quot; '>i18n.catalog.mdParam.schema.dcat.southBoundLatitude</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.dcat.temporal&quot; '>i18n.catalog.mdParam.schema.dcat.temporal</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.dcat.theme&quot; '>i18n.catalog.mdParam.schema.dcat.theme</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.dcat.westBoundLongitude&quot; '>i18n.catalog.mdParam.schema.dcat.westBoundLongitude</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.esriarcgis&quot; '>i18n.catalog.mdParam.schema.esriarcgis</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.esriiso&quot; '>i18n.catalog.mdParam.schema.esriiso</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.fgdc&quot; '>i18n.catalog.mdParam.schema.fgdc</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.fgdc.bestpractice&quot; '>i18n.catalog.mdParam.schema.fgdc.bestpractice</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.fgdc.minimum&quot; '>i18n.catalog.mdParam.schema.fgdc.minimum</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.inspire.coregeog&quot; '>i18n.catalog.mdParam.schema.inspire.coregeog</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.inspire.services&quot; '>i18n.catalog.mdParam.schema.inspire.services</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.iso19115-2.coregeog&quot; '>i18n.catalog.mdParam.schema.iso19115-2.coregeog</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.iso19139&quot; '>i18n.catalog.mdParam.schema.iso19139</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.iso19139.coregeog&quot; '>i18n.catalog.mdParam.schema.iso19139.coregeog</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.iso19139.services&quot; '>i18n.catalog.mdParam.schema.iso19139.services</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.nap.data&quot; '>i18n.catalog.mdParam.schema.nap.data</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.nap.services&quot; '>i18n.catalog.mdParam.schema.nap.services</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.new_acq&quot; '>i18n.catalog.mdParam.schema.new_acq</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.OneGeology.dataset&quot; '>i18n.catalog.mdParam.schema.OneGeology.dataset</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.OneGeology.service&quot; '>i18n.catalog.mdParam.schema.OneGeology.service</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.recognizedSchema&quot; '>i18n.catalog.mdParam.schema.recognizedSchema</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.rndt.dataset&quot; '>i18n.catalog.mdParam.schema.rndt.dataset</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.RNDT.dataset2&quot; '>i18n.catalog.mdParam.schema.RNDT.dataset2</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.rndt.nuoveacq&quot; '>i18n.catalog.mdParam.schema.rndt.nuoveacq</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.rndt.raster&quot; '>i18n.catalog.mdParam.schema.rndt.raster</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.rndt.series&quot; '>i18n.catalog.mdParam.schema.rndt.series</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.rndt.services&quot; '>i18n.catalog.mdParam.schema.rndt.services</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.RNDT2_0.dataset&quot; '>i18n.catalog.mdParam.schema.RNDT2_0.dataset</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.RNDT2_0.series&quot; '>i18n.catalog.mdParam.schema.RNDT2_0.series</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.RNDT2_0.service&quot; '>i18n.catalog.mdParam.schema.RNDT2_0.service</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.rndt-nuovo.dataset&quot; '>i18n.catalog.mdParam.schema.rndt.dataset</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.rndt-nuovo.series&quot; '>i18n.catalog.mdParam.schema.rndt-nuovo.series</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.rndt-nuovo.raster&quot; '>i18n.catalog.mdParam.schema.rndt-nuovo.raster</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.schema.rndt-nuovo.services&quot; '>i18n.catalog.mdParam.schema.rndt-nuovo.services</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.service.identification.status.caption&quot; '>i18n.catalog.mdParam.service.identification.status.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.spatialRepresentationInfo.caption&quot; '>i18n.catalog.mdParam.spatialRepresentationInfo.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.spatialRepresentationInfo.cellGeometry&quot; '>i18n.catalog.mdParam.spatialRepresentationInfo.cellGeometry</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.spatialRepresentationInfo.centerPoint&quot; '>i18n.catalog.mdParam.spatialRepresentationInfo.centerPoint</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.spatialRepresentationInfo.checkPointAvailability&quot; '>i18n.catalog.mdParam.spatialRepresentationInfo.checkPointAvailability</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.spatialRepresentationInfo.checkPointDescription&quot; '>i18n.catalog.mdParam.spatialRepresentationInfo.checkPointDescription</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.spatialRepresentationInfo.cornerPoints&quot; '>i18n.catalog.mdParam.spatialRepresentationInfo.cornerPoints</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.spatialRepresentationInfo.dimensionNameType&quot; '>i18n.catalog.mdParam.spatialRepresentationInfo.dimensionNameType</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.spatialRepresentationInfo.dimensionSize&quot; '>i18n.catalog.mdParam.spatialRepresentationInfo.dimensionSize</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.spatialRepresentationInfo.georectified.caption&quot; '>i18n.catalog.mdParam.spatialRepresentationInfo.georectified.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.spatialRepresentationInfo.gridded.caption&quot; '>i18n.catalog.mdParam.spatialRepresentationInfo.gridded.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.spatialRepresentationInfo.numberOfDimensions&quot; '>i18n.catalog.mdParam.spatialRepresentationInfo.numberOfDimensions</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.spatialRepresentationInfo.pointInPixel&quot; '>i18n.catalog.mdParam.spatialRepresentationInfo.pointInPixel</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.spatialRepresentationInfo.resolution&quot; '>i18n.catalog.mdParam.spatialRepresentationInfo.resolution</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.spatialRepresentationInfo.resolution.units&quot; '>i18n.catalog.mdParam.spatialRepresentationInfo.resolution.units</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.spatialRepresentationInfo.transformationDimensionDescription&quot; '>i18n.catalog.mdParam.spatialRepresentationInfo.transformationDimensionDescription</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.spatialRepresentationInfo.transformationDimensionMapping&quot; '>i18n.catalog.mdParam.spatialRepresentationInfo.transformationDimensionMapping</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.spatialRepresentationInfo.transformationParameterAvailability&quot; '>i18n.catalog.mdParam.spatialRepresentationInfo.transformationParameterAvailability</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.standard.caption&quot; '>i18n.catalog.mdParam.standard.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.standard.name&quot; '>i18n.catalog.mdParam.standard.name</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.standard.version&quot; '>i18n.catalog.mdParam.standard.version</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.theme.caption&quot; '>i18n.catalog.mdParam.theme.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.theme.topic&quot; '>i18n.catalog.mdParam.theme.topic</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.theme.topics&quot; '>i18n.catalog.mdParam.theme.topics</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.thumbnail.caption&quot; '>i18n.catalog.mdParam.thumbnail.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.thumbnail.description&quot; '>i18n.catalog.mdParam.thumbnail.description</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.thumbnail.type&quot; '>i18n.catalog.mdParam.thumbnail.type</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.thumbnail.url&quot; '>i18n.catalog.mdParam.thumbnail.url</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.timePeriod.beginDate&quot; '>i18n.catalog.mdParam.timePeriod.beginDate</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.timePeriod.caption&quot; '>i18n.catalog.mdParam.timePeriod.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.timePeriod.endDate&quot; '>i18n.catalog.mdParam.timePeriod.endDate</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.vertical.caption&quot; '>i18n.catalog.mdParam.vertical.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.vertical.maximumValue&quot; '>i18n.catalog.mdParam.vertical.maximumValue</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.vertical.minimumValue&quot; '>i18n.catalog.mdParam.vertical.minimumValue</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdValidation.envelopeIsInvalid&quot; '>i18n.catalog.mdValidation.envelopeIsInvalid</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdValidation.isInvalid&quot; '>i18n.catalog.mdValidation.isInvalid</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdValidation.isRequired&quot; '>i18n.catalog.mdValidation.isRequired</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdValidation.parentChild&quot; '>i18n.catalog.mdValidation.parentChild</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdValidation.titleIsRequired&quot; '>i18n.catalog.mdValidation.titleIsRequired</xsl:when>
			<xsl:when test='$key = &quot;catalog.menu.menuitem.launchMapViewer&quot; '>i18n.catalog.menu.menuitem.launchMapViewer</xsl:when>
			<xsl:when test='$key = &quot;catalog.migrate.migrateData.label.dbjndi&quot; '>i18n.catalog.migrate.migrateData.label.dbjndi</xsl:when>
			<xsl:when test='$key = &quot;catalog.migrate.migrateData.label.dbname&quot; '>i18n.catalog.migrate.migrateData.label.dbname</xsl:when>
			<xsl:when test='$key = &quot;catalog.migrate.migrateData.label.dbpassword&quot; '>i18n.catalog.migrate.migrateData.label.dbpassword</xsl:when>
			<xsl:when test='$key = &quot;catalog.migrate.migrateData.label.dbusername&quot; '>i18n.catalog.migrate.migrateData.label.dbusername</xsl:when>
			<xsl:when test='$key = &quot;catalog.migrate.migrateData.label.jdbcdriver&quot; '>i18n.catalog.migrate.migrateData.label.jdbcdriver</xsl:when>
			<xsl:when test='$key = &quot;catalog.migrate.migrateData.label.jdbcurl&quot; '>i18n.catalog.migrate.migrateData.label.jdbcurl</xsl:when>
			<xsl:when test='$key = &quot;catalog.migrate.migrateData.label.tablePrefix&quot; '>i18n.catalog.migrate.migrateData.label.tablePrefix</xsl:when>
			<xsl:when test='$key = &quot;catalog.migration.migrateData.button.submit&quot; '>i18n.catalog.migration.migrateData.button.submit</xsl:when>
			<xsl:when test='$key = &quot;catalog.migration.migrateData.caption&quot; '>i18n.catalog.migration.migrateData.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.migration.migrateData.label.onBehalfOf&quot; '>i18n.catalog.migration.migrateData.label.onBehalfOf</xsl:when>
			<xsl:when test='$key = &quot;catalog.new_acq.XTN_Identification.citation.date&quot; '>i18n.catalog.new_acq.XTN_Identification.citation.date</xsl:when>
			<xsl:when test='$key = &quot;catalog.opendata.download&quot; '>i18n.catalog.opendata.download</xsl:when>
			<xsl:when test='$key = &quot;catalog.opendata.downloadCSV&quot; '>i18n.catalog.opendata.downloadCSV</xsl:when>
			<xsl:when test='$key = &quot;catalog.opendata.downloadDBF&quot; '>i18n.catalog.opendata.downloadDBF</xsl:when>
			<xsl:when test='$key = &quot;catalog.opendata.downloadDOC&quot; '>i18n.catalog.opendata.downloadDOC</xsl:when>
			<xsl:when test='$key = &quot;catalog.opendata.downloadPDF&quot; '>i18n.catalog.opendata.downloadPDF</xsl:when>
			<xsl:when test='$key = &quot;catalog.opendata.downloadXLS&quot; '>i18n.catalog.opendata.downloadXLS</xsl:when>
			<xsl:when test='$key = &quot;catalog.opendata.downloadXML&quot; '>i18n.catalog.opendata.downloadXML</xsl:when>
			<xsl:when test='$key = &quot;catalog.opendata.downloadXML&quot; '>i18n.catalog.opendata.downloadXML</xsl:when>
			<xsl:when test='$key = &quot;catalog.opendata.downloadXML&quot; '>i18n.catalog.opendata.downloadXML</xsl:when>
			<xsl:when test='$key = &quot;catalog.opendata.downloadXML&quot; '>i18n.catalog.opendata.downloadXML</xsl:when>
			<xsl:when test='$key = &quot;catalog.opendata.downloadZIP&quot; '>i18n.catalog.opendata.downloadZIP</xsl:when>
			<xsl:when test='$key = &quot;catalog.openProvider.google&quot; '>i18n.catalog.openProvider.google</xsl:when>
			<xsl:when test='$key = &quot;catalog.openProvider.prompt&quot; '>i18n.catalog.openProvider.prompt</xsl:when>
			<xsl:when test='$key = &quot;catalog.openProvider.twitter&quot; '>i18n.catalog.openProvider.twitter</xsl:when>
			<xsl:when test='$key = &quot;catalog.openProvider.yahoo&quot; '>i18n.catalog.openProvider.yahoo</xsl:when>
			<xsl:when test='$key = &quot;catalog.openSearch.description&quot; '>i18n.catalog.openSearch.description</xsl:when>
			<xsl:when test='$key = &quot;catalog.openSearch.shortName&quot; '>i18n.catalog.openSearch.shortName</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.addMetadata.button.submit&quot; '>i18n.catalog.publication.addMetadata.button.submit</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.addMetadata.caption&quot; '>i18n.catalog.publication.addMetadata.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.addMetadata.command&quot; '>i18n.catalog.publication.addMetadata.command</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.addMetadata.command.edit&quot; '>i18n.catalog.publication.addMetadata.command.edit</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.addMetadata.command.register&quot; '>i18n.catalog.publication.addMetadata.command.register</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.addMetadata.command.upload&quot; '>i18n.catalog.publication.addMetadata.command.upload</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.addMetadata.prompt&quot; '>i18n.catalog.publication.addMetadata.prompt</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.addMetadata.subMenuCaption&quot; '>i18n.catalog.publication.addMetadata.subMenuCaption</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.createMetadata.button.submit&quot; '>i18n.catalog.publication.createMetadata.button.submit</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.createMetadata.button.submitDraft&quot; '>i18n.catalog.publication.createMetadata.button.submitDraft</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.createMetadata.caption&quot; '>i18n.catalog.publication.createMetadata.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.createMetadata.err.noSchemaSelected&quot; '>i18n.catalog.publication.createMetadata.err.noSchemaSelected</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.createMetadata.label.schema&quot; '>i18n.catalog.publication.createMetadata.label.schema</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.createMetadata.prompt&quot; '>i18n.catalog.publication.createMetadata.prompt</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.createMetadata.subMenuCaption&quot; '>i18n.catalog.publication.createMetadata.subMenuCaption</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.editMetadata.button.saveAsDraft&quot; '>i18n.catalog.publication.editMetadata.button.saveAsDraft</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.editMetadata.button.submit&quot; '>i18n.catalog.publication.editMetadata.button.submit</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.editMetadata.button.test.service&quot; '>i18n.catalog.publication.editMetadata.button.test.service</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.editMetadata.button.validate&quot; '>i18n.catalog.publication.editMetadata.button.validate</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.editMetadata.caption&quot; '>i18n.catalog.publication.editMetadata.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.editMetadata.prompt&quot; '>i18n.catalog.publication.editMetadata.prompt</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.editMetadata.text.test.service&quot; '>i18n.catalog.publication.editMetadata.text.test.service</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manage.collection.members.caption&quot; '>i18n.catalog.publication.manage.collection.members.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manage.collection.members.caption.ID&quot; '>i18n.catalog.publication.manage.collection.members.caption.ID</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manage.collection.members.caption.title&quot; '>i18n.catalog.publication.manage.collection.members.caption.title</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manage.collection.members.message1&quot; '>i18n.catalog.publication.manage.collection.members.message1</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manage.collection.members.message10&quot; '>i18n.catalog.publication.manage.collection.members.message10</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manage.collection.members.message11&quot; '>i18n.catalog.publication.manage.collection.members.message11</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manage.collection.members.message12&quot; '>i18n.catalog.publication.manage.collection.members.message12</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manage.collection.members.message13&quot; '>i18n.catalog.publication.manage.collection.members.message13</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manage.collection.members.message14&quot; '>i18n.catalog.publication.manage.collection.members.message14</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manage.collection.members.message15&quot; '>i18n.catalog.publication.manage.collection.members.message15</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manage.collection.members.message2&quot; '>i18n.catalog.publication.manage.collection.members.message2</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manage.collection.members.message3&quot; '>i18n.catalog.publication.manage.collection.members.message3</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manage.collection.members.message4&quot; '>i18n.catalog.publication.manage.collection.members.message4</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manage.collection.members.message5&quot; '>i18n.catalog.publication.manage.collection.members.message5</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manage.collection.members.message6&quot; '>i18n.catalog.publication.manage.collection.members.message6</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manage.collection.members.message7&quot; '>i18n.catalog.publication.manage.collection.members.message7</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manage.collection.members.message8&quot; '>i18n.catalog.publication.manage.collection.members.message8</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manage.collection.members.message9&quot; '>i18n.catalog.publication.manage.collection.members.message9</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manage.collection.members.name&quot; '>i18n.catalog.publication.manage.collection.members.name</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manage.collection.members.resourcename&quot; '>i18n.catalog.publication.manage.collection.members.resourcename</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manage.collections&quot; '>i18n.catalog.publication.manage.collections</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manage.user.role.caption&quot; '>i18n.catalog.publication.manage.user.role.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manage.user.role.subMenuCaption&quot; '>i18n.catalog.publication.manage.user.role.subMenuCaption</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.acl.clear&quot; '>i18n.catalog.publication.manageMetadata.acl.clear</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.acl.clear.tip&quot; '>i18n.catalog.publication.manageMetadata.acl.clear.tip</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.action.acl&quot; '>i18n.catalog.publication.manageMetadata.action.acl</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.action.applyToAll.confirm&quot; '>i18n.catalog.publication.manageMetadata.action.applyToAll.confirm</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.action.askDelete&quot; '>i18n.catalog.publication.manageMetadata.action.askDelete</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.action.delete&quot; '>i18n.catalog.publication.manageMetadata.action.delete</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.action.delete.confirm&quot; '>i18n.catalog.publication.manageMetadata.action.delete.confirm</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.action.delete.tip&quot; '>i18n.catalog.publication.manageMetadata.action.delete.tip</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.action.dontShareWith&quot; '>i18n.catalog.publication.manageMetadata.action.dontShareWith</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.action.download.frame&quot; '>i18n.catalog.publication.manageMetadata.action.download.frame</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.action.download.tip&quot; '>i18n.catalog.publication.manageMetadata.action.download.tip</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.action.Duplicate&quot; '>i18n.catalog.publication.manageMetadata.action.Duplicate</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.action.Duplicate&quot; '>i18n.catalog.publication.manageMetadata.action.Duplicate</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.action.Duplicate.err.tooManyRecords&quot; '>i18n.catalog.publication.manageMetadata.action.Duplicate.err.tooManyRecords</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.action.Duplicate.err.tooManyRecords&quot; '>i18n.catalog.publication.manageMetadata.action.Duplicate.err.tooManyRecords</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.action.edit.tip&quot; '>i18n.catalog.publication.manageMetadata.action.edit.tip</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.action.err.draftUnaltered&quot; '>i18n.catalog.publication.manageMetadata.action.err.draftUnaltered</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.action.err.noneSelected&quot; '>i18n.catalog.publication.manageMetadata.action.err.noneSelected</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.action.findparent.tip&quot; '>i18n.catalog.publication.manageMetadata.action.findparent.tip</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.action.logigErase&quot; '>i18n.catalog.publication.manageMetadata.action.logigErase</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.action.register.tip&quot; '>i18n.catalog.publication.manageMetadata.action.register.tip</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.action.setApproved&quot; '>i18n.catalog.publication.manageMetadata.action.setApproved</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.action.setDisapproved&quot; '>i18n.catalog.publication.manageMetadata.action.setDisapproved</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.action.setEditable&quot; '>i18n.catalog.publication.manageMetadata.action.setEditable</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.action.setIncomplete&quot; '>i18n.catalog.publication.manageMetadata.action.setIncomplete</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.action.setPosted&quot; '>i18n.catalog.publication.manageMetadata.action.setPosted</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.action.setReviewed&quot; '>i18n.catalog.publication.manageMetadata.action.setReviewed</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.action.shareWith&quot; '>i18n.catalog.publication.manageMetadata.action.shareWith</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.action.showharvested.tip&quot; '>i18n.catalog.publication.manageMetadata.action.showharvested.tip</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.action.success&quot; '>i18n.catalog.publication.manageMetadata.action.success</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.action.success.delete&quot; '>i18n.catalog.publication.manageMetadata.action.success.delete</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.action.TakeInCharge&quot; '>i18n.catalog.publication.manageMetadata.action.TakeInCharge</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.action.transfer&quot; '>i18n.catalog.publication.manageMetadata.action.transfer</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.action.view.tip&quot; '>i18n.catalog.publication.manageMetadata.action.view.tip</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.button.applyToAll&quot; '>i18n.catalog.publication.manageMetadata.button.applyToAll</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.button.executeAction&quot; '>i18n.catalog.publication.manageMetadata.button.executeAction</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.button.search&quot; '>i18n.catalog.publication.manageMetadata.button.search</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.caption&quot; '>i18n.catalog.publication.manageMetadata.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.collection.any&quot; '>i18n.catalog.publication.manageMetadata.collection.any</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.header.access&quot; '>i18n.catalog.publication.manageMetadata.header.access</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.header.action&quot; '>i18n.catalog.publication.manageMetadata.header.action</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.header.check.tip&quot; '>i18n.catalog.publication.manageMetadata.header.check.tip</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.header.download&quot; '>i18n.catalog.publication.manageMetadata.header.download</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.header.method&quot; '>i18n.catalog.publication.manageMetadata.header.method</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.header.owner&quot; '>i18n.catalog.publication.manageMetadata.header.owner</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.header.status&quot; '>i18n.catalog.publication.manageMetadata.header.status</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.header.title&quot; '>i18n.catalog.publication.manageMetadata.header.title</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.header.updateDate&quot; '>i18n.catalog.publication.manageMetadata.header.updateDate</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.header.uuid&quot; '>i18n.catalog.publication.manageMetadata.header.uuid</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.label.acl&quot; '>i18n.catalog.publication.manageMetadata.label.acl</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.label.action&quot; '>i18n.catalog.publication.manageMetadata.label.action</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.label.alias&quot; '>i18n.catalog.publication.manageMetadata.label.alias</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.label.collection&quot; '>i18n.catalog.publication.manageMetadata.label.collection</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.label.fromDate&quot; '>i18n.catalog.publication.manageMetadata.label.fromDate</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.label.method&quot; '>i18n.catalog.publication.manageMetadata.label.method</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.label.owner&quot; '>i18n.catalog.publication.manageMetadata.label.owner</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.label.restricted&quot; '>i18n.catalog.publication.manageMetadata.label.restricted</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.label.siteuuid&quot; '>i18n.catalog.publication.manageMetadata.label.siteuuid</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.label.status&quot; '>i18n.catalog.publication.manageMetadata.label.status</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.label.title&quot; '>i18n.catalog.publication.manageMetadata.label.title</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.label.toDate&quot; '>i18n.catalog.publication.manageMetadata.label.toDate</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.label.transfer&quot; '>i18n.catalog.publication.manageMetadata.label.transfer</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.label.unrestricted&quot; '>i18n.catalog.publication.manageMetadata.label.unrestricted</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.label.uuid&quot; '>i18n.catalog.publication.manageMetadata.label.uuid</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.menuCaption&quot; '>i18n.catalog.publication.manageMetadata.menuCaption</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.method.any&quot; '>i18n.catalog.publication.manageMetadata.method.any</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.method.batch&quot; '>i18n.catalog.publication.manageMetadata.method.batch</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.method.editor&quot; '>i18n.catalog.publication.manageMetadata.method.editor</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.method.harvester&quot; '>i18n.catalog.publication.manageMetadata.method.harvester</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.method.other&quot; '>i18n.catalog.publication.manageMetadata.method.other</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.method.registration&quot; '>i18n.catalog.publication.manageMetadata.method.registration</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.method.seditor&quot; '>i18n.catalog.publication.manageMetadata.method.seditor</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.method.upload&quot; '>i18n.catalog.publication.manageMetadata.method.upload</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.owner.any&quot; '>i18n.catalog.publication.manageMetadata.owner.any</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.prompt.acl&quot; '>i18n.catalog.publication.manageMetadata.prompt.acl</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.prompt.transfer&quot; '>i18n.catalog.publication.manageMetadata.prompt.transfer</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.sharing.collection.label&quot; '>i18n.catalog.publication.manageMetadata.sharing.collection.label</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.sharing.collection.popup&quot; '>i18n.catalog.publication.manageMetadata.sharing.collection.popup</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.sharing.collection.prompt&quot; '>i18n.catalog.publication.manageMetadata.sharing.collection.prompt</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.status.any&quot; '>i18n.catalog.publication.manageMetadata.status.any</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.status.approved&quot; '>i18n.catalog.publication.manageMetadata.status.approved</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.status.disapproved&quot; '>i18n.catalog.publication.manageMetadata.status.disapproved</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.status.disapprovedOld&quot; '>i18n.catalog.publication.manageMetadata.status.disapprovedOld</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.status.draft&quot; '>i18n.catalog.publication.manageMetadata.status.draft</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.status.incomplete&quot; '>i18n.catalog.publication.manageMetadata.status.incomplete</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.status.incompleteOld&quot; '>i18n.catalog.publication.manageMetadata.status.incompleteOld</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.status.posted&quot; '>i18n.catalog.publication.manageMetadata.status.posted</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.status.reviewed&quot; '>i18n.catalog.publication.manageMetadata.status.reviewed</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.manageMetadata.subMenuCaption&quot; '>i18n.catalog.publication.manageMetadata.subMenuCaption</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.success.created&quot; '>i18n.catalog.publication.success.created</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.success.documentNotInsert&quot; '>i18n.catalog.publication.success.documentNotInsert</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.success.draftByError&quot; '>i18n.catalog.publication.success.draftByError</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.success.draftSaved&quot; '>i18n.catalog.publication.success.draftSaved</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.success.replaced&quot; '>i18n.catalog.publication.success.replaced</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.success.unchanged&quot; '>i18n.catalog.publication.success.unchanged</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.success.validated&quot; '>i18n.catalog.publication.success.validated</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.uploadMetadata.button.asDraft&quot; '>i18n.catalog.publication.uploadMetadata.button.asDraft</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.uploadMetadata.button.recognize&quot; '>i18n.catalog.publication.uploadMetadata.button.recognize</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.uploadMetadata.button.submit&quot; '>i18n.catalog.publication.uploadMetadata.button.submit</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.uploadMetadata.button.validate&quot; '>i18n.catalog.publication.uploadMetadata.button.validate</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.uploadMetadata.caption&quot; '>i18n.catalog.publication.uploadMetadata.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.uploadMetadata.err.file.empty&quot; '>i18n.catalog.publication.uploadMetadata.err.file.empty</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.uploadMetadata.err.file.prolog&quot; '>i18n.catalog.publication.uploadMetadata.err.file.prolog</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.uploadMetadata.err.file.required&quot; '>i18n.catalog.publication.uploadMetadata.err.file.required</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.uploadMetadata.label.file&quot; '>i18n.catalog.publication.uploadMetadata.label.file</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.uploadMetadata.label.onBehalfOf&quot; '>i18n.catalog.publication.uploadMetadata.label.onBehalfOf</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.uploadMetadata.label.url&quot; '>i18n.catalog.publication.uploadMetadata.label.url</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.uploadMetadata.method.browse&quot; '>i18n.catalog.publication.uploadMetadata.method.browse</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.uploadMetadata.method.explicit&quot; '>i18n.catalog.publication.uploadMetadata.method.explicit</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.uploadMetadata.prompt&quot; '>i18n.catalog.publication.uploadMetadata.prompt</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.uploadMetadata.replaceIfExist&quot; '>i18n.catalog.publication.uploadMetadata.replaceIfExist</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.uploadMetadata.subMenuCaption&quot; '>i18n.catalog.publication.uploadMetadata.subMenuCaption</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.uploadMetadata.summary.created&quot; '>i18n.catalog.publication.uploadMetadata.summary.created</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.uploadMetadata.summary.deleted&quot; '>i18n.catalog.publication.uploadMetadata.summary.deleted</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.uploadMetadata.summary.failed&quot; '>i18n.catalog.publication.uploadMetadata.summary.failed</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.uploadMetadata.summary.invalid&quot; '>i18n.catalog.publication.uploadMetadata.summary.invalid</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.uploadMetadata.summary.replaced&quot; '>i18n.catalog.publication.uploadMetadata.summary.replaced</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.uploadMetadata.summary.unchanged&quot; '>i18n.catalog.publication.uploadMetadata.summary.unchanged</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.uploadMetadata.summary.valid&quot; '>i18n.catalog.publication.uploadMetadata.summary.valid</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.validateMetadata.button.submit&quot; '>i18n.catalog.publication.validateMetadata.button.submit</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.validateMetadata.caption&quot; '>i18n.catalog.publication.validateMetadata.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.validateMetadata.caption&quot; '>i18n.catalog.publication.validateMetadata.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.validateMetadata.err.file.empty&quot; '>i18n.catalog.publication.validateMetadata.err.file.empty</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.validateMetadata.err.file.prolog&quot; '>i18n.catalog.publication.validateMetadata.err.file.prolog</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.validateMetadata.err.file.required&quot; '>i18n.catalog.publication.validateMetadata.err.file.required</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.validateMetadata.label.file&quot; '>i18n.catalog.publication.validateMetadata.label.file</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.validateMetadata.menuCaption&quot; '>i18n.catalog.publication.validateMetadata.menuCaption</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.validateMetadata.prompt&quot; '>i18n.catalog.publication.validateMetadata.prompt</xsl:when>
			<xsl:when test='$key = &quot;catalog.publication.validateMetadata.subMenuCaption&quot; '>i18n.catalog.publication.validateMetadata.subMenuCaption</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.abstract&quot; '>i18n.catalog.rdnt.dataset.hint.abstract</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.accessoOnlineD&quot; '>i18n.catalog.rdnt.dataset.hint.accessoOnlineD</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.altriVincoliVAUAV&quot; '>i18n.catalog.rdnt.dataset.hint.altriVincoliVAUAV</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.altriVincoliVAUDP&quot; '>i18n.catalog.rdnt.dataset.hint.altriVincoliVAUDP</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.categoriaISO&quot; '>i18n.catalog.rdnt.dataset.hint.categoriaISO</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.characterset&quot; '>i18n.catalog.rdnt.dataset.hint.characterset</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.coordSystemZE&quot; '>i18n.catalog.rdnt.dataset.hint.coordSystemZE</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.data&quot; '>i18n.catalog.rdnt.dataset.hint.data</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.dataCreazione&quot; '>i18n.catalog.rdnt.dataset.hint.dataCreazione</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.dataFineE&quot; '>i18n.catalog.rdnt.dataset.hint.dataFineE</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.dataInizioE&quot; '>i18n.catalog.rdnt.dataset.hint.dataInizioE</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.dataQDD1&quot; '>i18n.catalog.rdnt.dataset.hint.dataQDD1</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.dataQDD2&quot; '>i18n.catalog.rdnt.dataset.hint.dataQDD2</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.dataQDD3&quot; '>i18n.catalog.rdnt.dataset.hint.dataQDD3</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.descriptionIDR&quot; '>i18n.catalog.rdnt.dataset.hint.descriptionIDR</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.descrizioneQDD1&quot; '>i18n.catalog.rdnt.dataset.hint.descrizioneQDD1</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.descrizioneQDD2&quot; '>i18n.catalog.rdnt.dataset.hint.descrizioneQDD2</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.descrizioneQDD3&quot; '>i18n.catalog.rdnt.dataset.hint.descrizioneQDD3</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.distanzaDSCRRS&quot; '>i18n.catalog.rdnt.dataset.hint.distanzaDSCRRS</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.distributoreD&quot; '>i18n.catalog.rdnt.dataset.hint.distributoreD</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.emailD&quot; '>i18n.catalog.rdnt.dataset.hint.emailD</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.emailPOC&quot; '>i18n.catalog.rdnt.dataset.hint.emailPOC</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.emailRM&quot; '>i18n.catalog.rdnt.dataset.hint.emailRM</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.emailRR&quot; '>i18n.catalog.rdnt.dataset.hint.emailRR</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.estensioneSpazialeE&quot; '>i18n.catalog.rdnt.dataset.hint.estensioneSpazialeE</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.estensioneTemporaleE&quot; '>i18n.catalog.rdnt.dataset.hint.estensioneTemporaleE</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.estensioneVerticaleE&quot; '>i18n.catalog.rdnt.dataset.hint.estensioneVerticaleE</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.fileIdentifier&quot; '>i18n.catalog.rdnt.dataset.hint.fileIdentifier</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.formatoDistribuzioneD&quot; '>i18n.catalog.rdnt.dataset.hint.formatoDistribuzioneD</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.formatoPresentazione&quot; '>i18n.catalog.rdnt.dataset.hint.formatoPresentazione</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.frequenzaAggiornamentoM&quot; '>i18n.catalog.rdnt.dataset.hint.frequenzaAggiornamentoM</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.frequenzaAggiornamentoTabM&quot; '>i18n.catalog.rdnt.dataset.hint.frequenzaAggiornamentoTabM</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.gradoConformitaQDD1&quot; '>i18n.catalog.rdnt.dataset.hint.gradoConformitaQDD1</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.gradoConformitaQDD2&quot; '>i18n.catalog.rdnt.dataset.hint.gradoConformitaQDD2</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.gradoConformitaQDD3&quot; '>i18n.catalog.rdnt.dataset.hint.gradoConformitaQDD3</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.hierarchyLevel&quot; '>i18n.catalog.rdnt.dataset.hint.hierarchyLevel</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.identificatore&quot; '>i18n.catalog.rdnt.dataset.hint.identificatore</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.idLivelloSup&quot; '>i18n.catalog.rdnt.dataset.hint.idLivelloSup</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.immagineRiferimentoTabIDR&quot; '>i18n.catalog.rdnt.dataset.hint.immagineRiferimentoTabIDR</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.informazioniSupplementariI&quot; '>i18n.catalog.rdnt.dataset.hint.informazioniSupplementariI</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.keywordColletionAT&quot; '>i18n.catalog.rdnt.dataset.hint.keywordColletionAT</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.keywordColletionPC&quot; '>i18n.catalog.rdnt.dataset.hint.keywordColletionPC</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.keywordColletionTabAT&quot; '>i18n.catalog.rdnt.dataset.hint.keywordColletionTabAT</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.keywordColletionTabPC&quot; '>i18n.catalog.rdnt.dataset.hint.keywordColletionTabPC</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.keywordTabTG&quot; '>i18n.catalog.rdnt.dataset.hint.keywordTabTG</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.keywordTG&quot; '>i18n.catalog.rdnt.dataset.hint.keywordTG</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.keywordTypeAT&quot; '>i18n.catalog.rdnt.dataset.hint.keywordTypeAT</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.language&quot; '>i18n.catalog.rdnt.dataset.hint.language</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.latNordE&quot; '>i18n.catalog.rdnt.dataset.hint.latNordE</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.latSudE&quot; '>i18n.catalog.rdnt.dataset.hint.latSudE</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.limitiUtilizzoVI&quot; '>i18n.catalog.rdnt.dataset.hint.limitiUtilizzoVI</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.linguaL&quot; '>i18n.catalog.rdnt.dataset.hint.linguaL</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.livelloQualitaQDD&quot; '>i18n.catalog.rdnt.dataset.hint.livelloQualitaQDD</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.longEstE&quot; '>i18n.catalog.rdnt.dataset.hint.longEstE</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.longOvestE&quot; '>i18n.catalog.rdnt.dataset.hint.longOvestE</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.nomeEnteD&quot; '>i18n.catalog.rdnt.dataset.hint.nomeEnteD</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.nomeEntePOC&quot; '>i18n.catalog.rdnt.dataset.hint.nomeEntePOC</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.nomeEnteRM&quot; '>i18n.catalog.rdnt.dataset.hint.nomeEnteRM</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.nomeEnteRR&quot; '>i18n.catalog.rdnt.dataset.hint.nomeEnteRR</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.nomeFormatoD&quot; '>i18n.catalog.rdnt.dataset.hint.nomeFormatoD</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.nomeStandard&quot; '>i18n.catalog.rdnt.dataset.hint.nomeStandard</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.onlineUrlD&quot; '>i18n.catalog.rdnt.dataset.hint.onlineUrlD</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.otherCitationDetails&quot; '>i18n.catalog.rdnt.dataset.hint.otherCitationDetails</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.parentIdentifier&quot; '>i18n.catalog.rdnt.dataset.hint.parentIdentifier</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.predefinitiVI&quot; '>i18n.catalog.rdnt.dataset.hint.predefinitiVI</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.quotaMassimaE&quot; '>i18n.catalog.rdnt.dataset.hint.quotaMassimaE</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.quotaMinimaE&quot; '>i18n.catalog.rdnt.dataset.hint.quotaMinimaE</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.ruoloD&quot; '>i18n.catalog.rdnt.dataset.hint.ruoloD</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.ruoloPOC&quot; '>i18n.catalog.rdnt.dataset.hint.ruoloPOC</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.ruoloRM&quot; '>i18n.catalog.rdnt.dataset.hint.ruoloRM</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.ruoloRR&quot; '>i18n.catalog.rdnt.dataset.hint.ruoloRR</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.scalaEquivalenteRRS&quot; '>i18n.catalog.rdnt.dataset.hint.scalaEquivalenteRRS</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.setCaratteriL&quot; '>i18n.catalog.rdnt.dataset.hint.setCaratteriL</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.sistemaRiferimento&quot; '>i18n.catalog.rdnt.dataset.hint.sistemaRiferimento</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.sitoWebD&quot; '>i18n.catalog.rdnt.dataset.hint.sitoWebD</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.sitoWebPOC&quot; '>i18n.catalog.rdnt.dataset.hint.sitoWebPOC</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.sitoWebRM&quot; '>i18n.catalog.rdnt.dataset.hint.sitoWebRM</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.sitoWebRR&quot; '>i18n.catalog.rdnt.dataset.hint.sitoWebRR</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.spatialResolutionRRS&quot; '>i18n.catalog.rdnt.dataset.hint.spatialResolutionRRS</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.storiaDatoQDD&quot; '>i18n.catalog.rdnt.dataset.hint.storiaDatoQDD</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.telefonoD&quot; '>i18n.catalog.rdnt.dataset.hint.telefonoD</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.TelefonoPOC&quot; '>i18n.catalog.rdnt.dataset.hint.TelefonoPOC</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.TelefonoRM&quot; '>i18n.catalog.rdnt.dataset.hint.TelefonoRM</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.TelefonoRR&quot; '>i18n.catalog.rdnt.dataset.hint.TelefonoRR</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.temaInspireTI&quot; '>i18n.catalog.rdnt.dataset.hint.temaInspireTI</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.testoLiberoVI&quot; '>i18n.catalog.rdnt.dataset.hint.testoLiberoVI</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.tipoData&quot; '>i18n.catalog.rdnt.dataset.hint.tipoData</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.tipoDataQDD1&quot; '>i18n.catalog.rdnt.dataset.hint.tipoDataQDD1</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.tipoDataQDD2&quot; '>i18n.catalog.rdnt.dataset.hint.tipoDataQDD2</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.tipoDataQDD3&quot; '>i18n.catalog.rdnt.dataset.hint.tipoDataQDD3</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.tipoRappresentazioneRRS&quot; '>i18n.catalog.rdnt.dataset.hint.tipoRappresentazioneRRS</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.titolo&quot; '>i18n.catalog.rdnt.dataset.hint.titolo</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.titoloQDD1&quot; '>i18n.catalog.rdnt.dataset.hint.titoloQDD1</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.titoloQDD2&quot; '>i18n.catalog.rdnt.dataset.hint.titoloQDD2</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.titoloQDD3&quot; '>i18n.catalog.rdnt.dataset.hint.titoloQDD3</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.titoloSpecificaAT&quot; '>i18n.catalog.rdnt.dataset.hint.titoloSpecificaAT</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.typesIDR&quot; '>i18n.catalog.rdnt.dataset.hint.typesIDR</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.unitaMisuraDSCRRS&quot; '>i18n.catalog.rdnt.dataset.hint.unitaMisuraDSCRRS</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.unitaMisuraQDD&quot; '>i18n.catalog.rdnt.dataset.hint.unitaMisuraQDD</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.urlIDR&quot; '>i18n.catalog.rdnt.dataset.hint.urlIDR</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.valoreQDD&quot; '>i18n.catalog.rdnt.dataset.hint.valoreQDD</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.versioneFormatoD&quot; '>i18n.catalog.rdnt.dataset.hint.versioneFormatoD</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.versioneStandard&quot; '>i18n.catalog.rdnt.dataset.hint.versioneStandard</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.vincoliAccessoVAUAV&quot; '>i18n.catalog.rdnt.dataset.hint.vincoliAccessoVAUAV</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.vincoliAccessoVAUDP&quot; '>i18n.catalog.rdnt.dataset.hint.vincoliAccessoVAUDP</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.vincoliAccessoVAUP&quot; '>i18n.catalog.rdnt.dataset.hint.vincoliAccessoVAUP</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.vincoliFruibilitaVAUAV&quot; '>i18n.catalog.rdnt.dataset.hint.vincoliFruibilitaVAUAV</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.vincoliFruibilitaVAUDP&quot; '>i18n.catalog.rdnt.dataset.hint.vincoliFruibilitaVAUDP</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.vincoliFruibilitaVAUP&quot; '>i18n.catalog.rdnt.dataset.hint.vincoliFruibilitaVAUP</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.dataset.hint.vincoliSicurezzaVI&quot; '>i18n.catalog.rdnt.dataset.hint.vincoliSicurezzaVI</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.nuoveAcquisizioni.hint.abstract&quot; '>i18n.catalog.rdnt.nuoveAcquisizioni.hint.abstract</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.nuoveAcquisizioni.hint.categoriaDSCISO&quot; '>i18n.catalog.rdnt.nuoveAcquisizioni.hint.categoriaDSCISO</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.nuoveAcquisizioni.hint.emailISDC&quot; '>i18n.catalog.rdnt.nuoveAcquisizioni.hint.emailISDC</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.nuoveAcquisizioni.hint.emailRDM&quot; '>i18n.catalog.rdnt.nuoveAcquisizioni.hint.emailRDM</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.nuoveAcquisizioni.hint.estensioneSpazialeDSCE&quot; '>i18n.catalog.rdnt.nuoveAcquisizioni.hint.estensioneSpazialeDSCE</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.nuoveAcquisizioni.hint.latNordE&quot; '>i18n.catalog.rdnt.nuoveAcquisizioni.hint.latNordE</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.nuoveAcquisizioni.hint.latSudE&quot; '>i18n.catalog.rdnt.nuoveAcquisizioni.hint.latSudE</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.nuoveAcquisizioni.hint.limiteAmministrativoDSCE&quot; '>i18n.catalog.rdnt.nuoveAcquisizioni.hint.limiteAmministrativoDSCE</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.nuoveAcquisizioni.hint.linguaDSCL&quot; '>i18n.catalog.rdnt.nuoveAcquisizioni.hint.linguaDSCL</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.nuoveAcquisizioni.hint.longEstE&quot; '>i18n.catalog.rdnt.nuoveAcquisizioni.hint.longEstE</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.nuoveAcquisizioni.hint.longOvestE&quot; '>i18n.catalog.rdnt.nuoveAcquisizioni.hint.longOvestE</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.nuoveAcquisizioni.hint.nomeEnteISDC&quot; '>i18n.catalog.rdnt.nuoveAcquisizioni.hint.nomeEnteISDC</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.nuoveAcquisizioni.hint.nomeEnteRDM&quot; '>i18n.catalog.rdnt.nuoveAcquisizioni.hint.nomeEnteRDM</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.nuoveAcquisizioni.hint.predefinitiV&quot; '>i18n.catalog.rdnt.nuoveAcquisizioni.hint.predefinitiV</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.nuoveAcquisizioni.hint.programmazioneDSCP&quot; '>i18n.catalog.rdnt.nuoveAcquisizioni.hint.programmazioneDSCP</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.nuoveAcquisizioni.hint.ruoloISDC&quot; '>i18n.catalog.rdnt.nuoveAcquisizioni.hint.ruoloISDC</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.nuoveAcquisizioni.hint.ruoloRDM&quot; '>i18n.catalog.rdnt.nuoveAcquisizioni.hint.ruoloRDM</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.nuoveAcquisizioni.hint.serviziPrevistiISDC&quot; '>i18n.catalog.rdnt.nuoveAcquisizioni.hint.serviziPrevistiISDC</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.nuoveAcquisizioni.hint.sitoWebISDC&quot; '>i18n.catalog.rdnt.nuoveAcquisizioni.hint.sitoWebISDC</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.nuoveAcquisizioni.hint.sitoWebRDM&quot; '>i18n.catalog.rdnt.nuoveAcquisizioni.hint.sitoWebRDM</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.nuoveAcquisizioni.hint.spatialResolutionDSCRRS&quot; '>i18n.catalog.rdnt.nuoveAcquisizioni.hint.spatialResolutionDSCRRS</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.nuoveAcquisizioni.hint.statoDescrizioneV&quot; '>i18n.catalog.rdnt.nuoveAcquisizioni.hint.statoDescrizioneV</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.nuoveAcquisizioni.hint.telefonoISDC&quot; '>i18n.catalog.rdnt.nuoveAcquisizioni.hint.telefonoISDC</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.nuoveAcquisizioni.hint.telefonoRDM&quot; '>i18n.catalog.rdnt.nuoveAcquisizioni.hint.telefonoRDM</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.nuoveAcquisizioni.hint.testoLiberoV&quot; '>i18n.catalog.rdnt.nuoveAcquisizioni.hint.testoLiberoV</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.nuoveAcquisizioni.hint.tipoRappresentazioneDSCRRS&quot; '>i18n.catalog.rdnt.nuoveAcquisizioni.hint.tipoRappresentazioneDSCRRS</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.nuoveAcquisizioni.hint.titoloISDC&quot; '>i18n.catalog.rdnt.nuoveAcquisizioni.hint.titoloISDC</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.accessoOnlineD&quot; '>i18n.catalog.rdnt.raster.hint.accessoOnlineD</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.altriVincoliVAUAV&quot; '>i18n.catalog.rdnt.raster.hint.altriVincoliVAUAV</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.altriVincoliVAUDP&quot; '>i18n.catalog.rdnt.raster.hint.altriVincoliVAUDP</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.categoriaDSCISO&quot; '>i18n.catalog.rdnt.raster.hint.categoriaDSCISO</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.coeffiTrasformazioneGRET&quot; '>i18n.catalog.rdnt.raster.hint.coeffiTrasformazioneGRET</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.coeffiTrasformazioneGRIF&quot; '>i18n.catalog.rdnt.raster.hint.coeffiTrasformazioneGRIF</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.coordCellaAltoSinistraGRET&quot; '>i18n.catalog.rdnt.raster.hint.coordCellaAltoSinistraGRET</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.coordSystemZDSCZE&quot; '>i18n.catalog.rdnt.raster.hint.coordSystemZDSCZE</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.dataFineDSCE&quot; '>i18n.catalog.rdnt.raster.hint.dataFineDSCE</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.dataInizioDSCE&quot; '>i18n.catalog.rdnt.raster.hint.dataInizioDSCE</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.dataQDD1&quot; '>i18n.catalog.rdnt.raster.hint.dataQDD1</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.dataQDD2&quot; '>i18n.catalog.rdnt.raster.hint.dataQDD2</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.dataQDD3&quot; '>i18n.catalog.rdnt.raster.hint.dataQDD3</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.dataSpecificaISDAT&quot; '>i18n.catalog.rdnt.raster.hint.dataSpecificaISDAT</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.descrCheckPointsGRET&quot; '>i18n.catalog.rdnt.raster.hint.descrCheckPointsGRET</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.descriptionISDIDR&quot; '>i18n.catalog.rdnt.raster.hint.descriptionISDIDR</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.descrizioneQDD1&quot; '>i18n.catalog.rdnt.raster.hint.descrizioneQDD1</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.descrizioneQDD2&quot; '>i18n.catalog.rdnt.raster.hint.descrizioneQDD2</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.descrizioneQDD3&quot; '>i18n.catalog.rdnt.raster.hint.descrizioneQDD3</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.dimensionNameGRET&quot; '>i18n.catalog.rdnt.raster.hint.dimensionNameGRET</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.dimensionSizeGRET&quot; '>i18n.catalog.rdnt.raster.hint.dimensionSizeGRET</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.dispCheckPointsGRET&quot; '>i18n.catalog.rdnt.raster.hint.dispCheckPointsGRET</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.dispParOrientamentoGRIF&quot; '>i18n.catalog.rdnt.raster.hint.dispParOrientamentoGRIF</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.dispPuntiControlloGRIF&quot; '>i18n.catalog.rdnt.raster.hint.dispPuntiControlloGRIF</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.distanzaDSCRRS&quot; '>i18n.catalog.rdnt.raster.hint.distanzaDSCRRS</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.distributoreD&quot; '>i18n.catalog.rdnt.raster.hint.distributoreD</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.emailD&quot; '>i18n.catalog.rdnt.raster.hint.emailD</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.emailISDPDC&quot; '>i18n.catalog.rdnt.raster.hint.emailISDPDC</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.estensioneSpazialeDSCE&quot; '>i18n.catalog.rdnt.raster.hint.estensioneSpazialeDSCE</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.estensioneTemporaleDSCE&quot; '>i18n.catalog.rdnt.raster.hint.estensioneTemporaleDSCE</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.estensioneVerticaleDSCE&quot; '>i18n.catalog.rdnt.raster.hint.estensioneVerticaleDSCE</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.formatoDistribuzioneD&quot; '>i18n.catalog.rdnt.raster.hint.formatoDistribuzioneD</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.frequenzaAggiornamentoISDM&quot; '>i18n.catalog.rdnt.raster.hint.frequenzaAggiornamentoISDM</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.frequenzaAggiornamentoTabM&quot; '>i18n.catalog.rdnt.raster.hint.frequenzaAggiornamentoTabM</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.geometriaCellaGRET&quot; '>i18n.catalog.rdnt.raster.hint.geometriaCellaGRET</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.geometriaCellaGRIF&quot; '>i18n.catalog.rdnt.raster.hint.geometriaCellaGRIF</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.gradoConformitaQDD1&quot; '>i18n.catalog.rdnt.raster.hint.gradoConformitaQDD1</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.gradoConformitaQDD2&quot; '>i18n.catalog.rdnt.raster.hint.gradoConformitaQDD2</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.gradoConformitaQDD3&quot; '>i18n.catalog.rdnt.raster.hint.gradoConformitaQDD3</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.idGRET&quot; '>i18n.catalog.rdnt.raster.hint.idGRET</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.immagineRiferimentoTabISDIDR&quot; '>i18n.catalog.rdnt.raster.hint.immagineRiferimentoTabISDIDR</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.informazioniSupplementariDSCI&quot; '>i18n.catalog.rdnt.raster.hint.informazioniSupplementariDSCI</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.keywordISDAT&quot; '>i18n.catalog.rdnt.raster.hint.keywordISDAT</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.keywordISDPC&quot; '>i18n.catalog.rdnt.raster.hint.keywordISDPC</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.keywordISDTG&quot; '>i18n.catalog.rdnt.raster.hint.keywordISDTG</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.keywordTabISDAT&quot; '>i18n.catalog.rdnt.raster.hint.keywordTabISDAT</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.keywordTabISDPC&quot; '>i18n.catalog.rdnt.raster.hint.keywordTabISDPC</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.keywordTabISDTG&quot; '>i18n.catalog.rdnt.raster.hint.keywordTabISDTG</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.keywordTypeISDAT&quot; '>i18n.catalog.rdnt.raster.hint.keywordTypeISDAT</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.latNordDSCE&quot; '>i18n.catalog.rdnt.raster.hint.latNordDSCE</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.latSudDSCE&quot; '>i18n.catalog.rdnt.raster.hint.latSudDSCE</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.limitiUtilizzoVVDS&quot; '>i18n.catalog.rdnt.raster.hint.limitiUtilizzoVVDS</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.linguaDSCL&quot; '>i18n.catalog.rdnt.raster.hint.linguaDSCL</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.livelloQualitaQDD&quot; '>i18n.catalog.rdnt.raster.hint.livelloQualitaQDD</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.longEstDSCE&quot; '>i18n.catalog.rdnt.raster.hint.longEstDSCE</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.longOvestDSCE&quot; '>i18n.catalog.rdnt.raster.hint.longOvestDSCE</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.nomeEnteD&quot; '>i18n.catalog.rdnt.raster.hint.nomeEnteD</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.nomeEnteISDPDC&quot; '>i18n.catalog.rdnt.raster.hint.nomeEnteISDPDC</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.nomeFormatoD&quot; '>i18n.catalog.rdnt.raster.hint.nomeFormatoD</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.numeroDimensioniGRET&quot; '>i18n.catalog.rdnt.raster.hint.numeroDimensioniGRET</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.numeroDimensioniGRIF&quot; '>i18n.catalog.rdnt.raster.hint.numeroDimensioniGRIF</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.onlineUrlD&quot; '>i18n.catalog.rdnt.raster.hint.onlineUrlD</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.parGeoreferenziazioneGRIF&quot; '>i18n.catalog.rdnt.raster.hint.parGeoreferenziazioneGRIF</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.posizioneCoordGRET&quot; '>i18n.catalog.rdnt.raster.hint.posizioneCoordGRET</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.predefinitiVVDS&quot; '>i18n.catalog.rdnt.raster.hint.predefinitiVVDS</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.quotaMassimaDSCE&quot; '>i18n.catalog.rdnt.raster.hint.quotaMassimaDSCE</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.quotaMinimaDSCE&quot; '>i18n.catalog.rdnt.raster.hint.quotaMinimaDSCE</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.risoluzioneRadiometricaCDDR&quot; '>i18n.catalog.rdnt.raster.hint.risoluzioneRadiometricaCDDR</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.ruoloD&quot; '>i18n.catalog.rdnt.raster.hint.ruoloD</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.ruoloISDPDC&quot; '>i18n.catalog.rdnt.raster.hint.ruoloISDPDC</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.scalaEquivalenteDSCRRS&quot; '>i18n.catalog.rdnt.raster.hint.scalaEquivalenteDSCRRS</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.setCaratteriDSCL&quot; '>i18n.catalog.rdnt.raster.hint.setCaratteriDSCL</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.sitoWebD&quot; '>i18n.catalog.rdnt.raster.hint.sitoWebD</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.sitoWebISDPDC&quot; '>i18n.catalog.rdnt.raster.hint.sitoWebISDPDC</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.spatialResolutionDSCRRS&quot; '>i18n.catalog.rdnt.raster.hint.spatialResolutionDSCRRS</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.storiaDatoQDD&quot; '>i18n.catalog.rdnt.raster.hint.storiaDatoQDD</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.telefonoD&quot; '>i18n.catalog.rdnt.raster.hint.telefonoD</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.telefonoISDPDC&quot; '>i18n.catalog.rdnt.raster.hint.telefonoISDPDC</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.temaInspireISDTI&quot; '>i18n.catalog.rdnt.raster.hint.temaInspireISDTI</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.testoLiberoVVDS&quot; '>i18n.catalog.rdnt.raster.hint.testoLiberoVVDS</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.tipoContenutoCDDR&quot; '>i18n.catalog.rdnt.raster.hint.tipoContenutoCDDR</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.tipoDataQDD1&quot; '>i18n.catalog.rdnt.raster.hint.tipoDataQDD1</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.tipoDataQDD2&quot; '>i18n.catalog.rdnt.raster.hint.tipoDataQDD2</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.tipoDataQDD3&quot; '>i18n.catalog.rdnt.raster.hint.tipoDataQDD3</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.tipoRappresentazioneDSCRRS&quot; '>i18n.catalog.rdnt.raster.hint.tipoRappresentazioneDSCRRS</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.tipoValoriCellaCDDR&quot; '>i18n.catalog.rdnt.raster.hint.tipoValoriCellaCDDR</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.titoloQDD1&quot; '>i18n.catalog.rdnt.raster.hint.titoloQDD1</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.titoloQDD2&quot; '>i18n.catalog.rdnt.raster.hint.titoloQDD2</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.titoloQDD3&quot; '>i18n.catalog.rdnt.raster.hint.titoloQDD3</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.titoloSpecificaISDAT&quot; '>i18n.catalog.rdnt.raster.hint.titoloSpecificaISDAT</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.triangolazioneAereaCDDR&quot; '>i18n.catalog.rdnt.raster.hint.triangolazioneAereaCDDR</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.typesISDIDR&quot; '>i18n.catalog.rdnt.raster.hint.typesISDIDR</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.unitaGRET&quot; '>i18n.catalog.rdnt.raster.hint.unitaGRET</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.unitaMisuraDSCRRS&quot; '>i18n.catalog.rdnt.raster.hint.unitaMisuraDSCRRS</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.unitaMisuraQDD&quot; '>i18n.catalog.rdnt.raster.hint.unitaMisuraQDD</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.urlISDIDR&quot; '>i18n.catalog.rdnt.raster.hint.urlISDIDR</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.valoreQDD&quot; '>i18n.catalog.rdnt.raster.hint.valoreQDD</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.versioneFormatoD&quot; '>i18n.catalog.rdnt.raster.hint.versioneFormatoD</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.vincoliAccessoVAUAV&quot; '>i18n.catalog.rdnt.raster.hint.vincoliAccessoVAUAV</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.vincoliAccessoVAUDP&quot; '>i18n.catalog.rdnt.raster.hint.vincoliAccessoVAUDP</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.vincoliAccessoVAUP&quot; '>i18n.catalog.rdnt.raster.hint.vincoliAccessoVAUP</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.vincoliFruibilitaVAUAV&quot; '>i18n.catalog.rdnt.raster.hint.vincoliFruibilitaVAUAV</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.vincoliFruibilitaVAUDP&quot; '>i18n.catalog.rdnt.raster.hint.vincoliFruibilitaVAUDP</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.vincoliFruibilitaVAUP&quot; '>i18n.catalog.rdnt.raster.hint.vincoliFruibilitaVAUP</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.raster.hint.vincoliSicurezzaVVDS&quot; '>i18n.catalog.rdnt.raster.hint.vincoliSicurezzaVVDS</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.accessoOnlineD&quot; '>i18n.catalog.rdnt.servizi.hint.accessoOnlineD</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.altriVincoliVAUAV&quot; '>i18n.catalog.rdnt.servizi.hint.altriVincoliVAUAV</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.altriVincoliVAUDP&quot; '>i18n.catalog.rdnt.servizi.hint.altriVincoliVAUDP</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.caratteristicheServizioTDS&quot; '>i18n.catalog.rdnt.servizi.hint.caratteristicheServizioTDS</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.coordSystemZE&quot; '>i18n.catalog.rdnt.servizi.hint.coordSystemZE</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.dataFineE&quot; '>i18n.catalog.rdnt.servizi.hint.dataFineE</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.dataInizioE&quot; '>i18n.catalog.rdnt.servizi.hint.dataInizioE</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.dataQDD1&quot; '>i18n.catalog.rdnt.servizi.hint.dataQDD1</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.dataQDD2&quot; '>i18n.catalog.rdnt.servizi.hint.dataQDD2</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.dataQDD3&quot; '>i18n.catalog.rdnt.servizi.hint.dataQDD3</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.descriptionISDIDR&quot; '>i18n.catalog.rdnt.servizi.hint.descriptionISDIDR</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.descrizioneQDD1&quot; '>i18n.catalog.rdnt.servizi.hint.descrizioneQDD1</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.descrizioneQDD2&quot; '>i18n.catalog.rdnt.servizi.hint.descrizioneQDD2</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.descrizioneQDD3&quot; '>i18n.catalog.rdnt.servizi.hint.descrizioneQDD3</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.emailISDPOC&quot; '>i18n.catalog.rdnt.servizi.hint.emailISDPOC</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.estensioneSpazialeE&quot; '>i18n.catalog.rdnt.servizi.hint.estensioneSpazialeE</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.estensioneTemporaleE&quot; '>i18n.catalog.rdnt.servizi.hint.estensioneTemporaleE</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.estensioneVerticaleE&quot; '>i18n.catalog.rdnt.servizi.hint.estensioneVerticaleE</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.gradoConformitaQDD1&quot; '>i18n.catalog.rdnt.servizi.hint.gradoConformitaQDD1</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.gradoConformitaQDD2&quot; '>i18n.catalog.rdnt.servizi.hint.gradoConformitaQDD2</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.gradoConformitaQDD3&quot; '>i18n.catalog.rdnt.servizi.hint.gradoConformitaQDD3</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.immagineRiferimentoTabISDIDR&quot; '>i18n.catalog.rdnt.servizi.hint.immagineRiferimentoTabISDIDR</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.keywordColletionKAT&quot; '>i18n.catalog.rdnt.servizi.hint.keywordColletionKAT</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.keywordColletionKPC&quot; '>i18n.catalog.rdnt.servizi.hint.keywordColletionKPC</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.keywordColletionTabKAT&quot; '>i18n.catalog.rdnt.servizi.hint.keywordColletionTabKAT</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.keywordColletionTabKPC&quot; '>i18n.catalog.rdnt.servizi.hint.keywordColletionTabKPC</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.keywordKTG&quot; '>i18n.catalog.rdnt.servizi.hint.keywordKTG</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.keywordTabKTG&quot; '>i18n.catalog.rdnt.servizi.hint.keywordTabKTG</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.keywordTypeKAT&quot; '>i18n.catalog.rdnt.servizi.hint.keywordTypeKAT</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.latNordE&quot; '>i18n.catalog.rdnt.servizi.hint.latNordE</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.latSudE&quot; '>i18n.catalog.rdnt.servizi.hint.latSudE</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.limitiUtilizzoVI&quot; '>i18n.catalog.rdnt.servizi.hint.limitiUtilizzoVI</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.linkRisorsaTDS&quot; '>i18n.catalog.rdnt.servizi.hint.linkRisorsaTDS</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.livelloQualitaQDD&quot; '>i18n.catalog.rdnt.servizi.hint.livelloQualitaQDD</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.longEstE&quot; '>i18n.catalog.rdnt.servizi.hint.longEstE</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.longOvestE&quot; '>i18n.catalog.rdnt.servizi.hint.longOvestE</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.nomeEnteISDPOC&quot; '>i18n.catalog.rdnt.servizi.hint.nomeEnteISDPOC</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.nomeOperazioneTDS&quot; '>i18n.catalog.rdnt.servizi.hint.nomeOperazioneTDS</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.onlineUrlD&quot; '>i18n.catalog.rdnt.servizi.hint.onlineUrlD</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.piattImplementazione&quot; '>i18n.catalog.rdnt.servizi.hint.piattImplementazione</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.predefinitiVI&quot; '>i18n.catalog.rdnt.servizi.hint.predefinitiVI</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.puntoConnessioneTDS&quot; '>i18n.catalog.rdnt.servizi.hint.puntoConnessioneTDS</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.quotaMassimaE&quot; '>i18n.catalog.rdnt.servizi.hint.quotaMassimaE</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.quotaMinimaE&quot; '>i18n.catalog.rdnt.servizi.hint.quotaMinimaE</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.ruoloISDPOC&quot; '>i18n.catalog.rdnt.servizi.hint.ruoloISDPOC</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.sitoWebISDPOC&quot; '>i18n.catalog.rdnt.servizi.hint.sitoWebISDPOC</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.storiaDatoQDD&quot; '>i18n.catalog.rdnt.servizi.hint.storiaDatoQDD</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.TelefonoISDPOC&quot; '>i18n.catalog.rdnt.servizi.hint.TelefonoISDPOC</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.temaInspireKTI&quot; '>i18n.catalog.rdnt.servizi.hint.temaInspireKTI</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.testoLiberoVI&quot; '>i18n.catalog.rdnt.servizi.hint.testoLiberoVI</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.tipoDataQDD1&quot; '>i18n.catalog.rdnt.servizi.hint.tipoDataQDD1</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.tipoDataQDD2&quot; '>i18n.catalog.rdnt.servizi.hint.tipoDataQDD2</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.tipoDataQDD3&quot; '>i18n.catalog.rdnt.servizi.hint.tipoDataQDD3</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.tipoLegameTDS&quot; '>i18n.catalog.rdnt.servizi.hint.tipoLegameTDS</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.titoloQDD1&quot; '>i18n.catalog.rdnt.servizi.hint.titoloQDD1</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.titoloQDD2&quot; '>i18n.catalog.rdnt.servizi.hint.titoloQDD2</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.titoloQDD3&quot; '>i18n.catalog.rdnt.servizi.hint.titoloQDD3</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.titoloSpecificaKAT&quot; '>i18n.catalog.rdnt.servizi.hint.titoloSpecificaKAT</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.typesISDIDR&quot; '>i18n.catalog.rdnt.servizi.hint.typesISDIDR</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.urlISDIDR&quot; '>i18n.catalog.rdnt.servizi.hint.urlISDIDR</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.vincoliAccessoVAUAV&quot; '>i18n.catalog.rdnt.servizi.hint.vincoliAccessoVAUAV</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.vincoliAccessoVAUDP&quot; '>i18n.catalog.rdnt.servizi.hint.vincoliAccessoVAUDP</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.vincoliAccessoVAUP&quot; '>i18n.catalog.rdnt.servizi.hint.vincoliAccessoVAUP</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.vincoliFruibilitaVAUAV&quot; '>i18n.catalog.rdnt.servizi.hint.vincoliFruibilitaVAUAV</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.vincoliFruibilitaVAUDP&quot; '>i18n.catalog.rdnt.servizi.hint.vincoliFruibilitaVAUDP</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.vincoliFruibilitaVAUP&quot; '>i18n.catalog.rdnt.servizi.hint.vincoliFruibilitaVAUP</xsl:when>
			<xsl:when test='$key = &quot;catalog.rdnt.servizi.hint.vincoliSicurezzaVI&quot; '>i18n.catalog.rdnt.servizi.hint.vincoliSicurezzaVI</xsl:when>
			<xsl:when test='$key = &quot;catalog.resource.relationships.toc.father&quot; '>i18n.catalog.resource.relationships.toc.father</xsl:when>
			<xsl:when test='$key = &quot;catalog.resource.relationships.toc.label&quot; '>i18n.catalog.resource.relationships.toc.label</xsl:when>
			<xsl:when test='$key = &quot;catalog.resource.relationships.toc.next&quot; '>i18n.catalog.resource.relationships.toc.next</xsl:when>
			<xsl:when test='$key = &quot;catalog.resource.relationships.toc.operates-On&quot; '>i18n.catalog.resource.relationships.toc.operates-On</xsl:when>
			<xsl:when test='$key = &quot;catalog.resource.relationships.toc.operatesOn&quot; '>i18n.catalog.resource.relationships.toc.operatesOn</xsl:when>
			<xsl:when test='$key = &quot;catalog.resource.relationships.toc.previous&quot; '>i18n.catalog.resource.relationships.toc.previous</xsl:when>
			<xsl:when test='$key = &quot;catalog.resource.relationships.toc.Son-Of&quot; '>i18n.catalog.resource.relationships.toc.Son-Of</xsl:when>
			<xsl:when test='$key = &quot;catalog.resource.relationships.toc.used-By&quot; '>i18n.catalog.resource.relationships.toc.used-By</xsl:when>
			<xsl:when test='$key = &quot;catalog.resource.relationships.toc.usedBy&quot; '>i18n.catalog.resource.relationships.toc.usedBy</xsl:when>
			<xsl:when test='$key = &quot;catalog.rest.addToArcMap&quot; '>i18n.catalog.rest.addToArcMap</xsl:when>
			<xsl:when test='$key = &quot;catalog.rest.addToGlobeKml&quot; '>i18n.catalog.rest.addToGlobeKml</xsl:when>
			<xsl:when test='$key = &quot;catalog.rest.addToGlobeNmf&quot; '>i18n.catalog.rest.addToGlobeNmf</xsl:when>
			<xsl:when test='$key = &quot;catalog.rest.addToMap&quot; '>i18n.catalog.rest.addToMap</xsl:when>
			<xsl:when test='$key = &quot;catalog.rest.copyright&quot; '>i18n.catalog.rest.copyright</xsl:when>
			<xsl:when test='$key = &quot;catalog.rest.description&quot; '>i18n.catalog.rest.description</xsl:when>
			<xsl:when test='$key = &quot;catalog.rest.download&quot; '>i18n.catalog.rest.download</xsl:when>
			<xsl:when test='$key = &quot;catalog.rest.download&quot; '>i18n.catalog.rest.download</xsl:when>
			<xsl:when test='$key = &quot;catalog.rest.generator&quot; '>i18n.catalog.rest.generator</xsl:when>
			<xsl:when test='$key = &quot;catalog.rest.link&quot; '>i18n.catalog.rest.link</xsl:when>
			<xsl:when test='$key = &quot;catalog.rest.link.addToMap&quot; '>i18n.catalog.rest.link.addToMap</xsl:when>
			<xsl:when test='$key = &quot;catalog.rest.link.csv&quot; '>i18n.catalog.rest.link.csv</xsl:when>
			<xsl:when test='$key = &quot;catalog.rest.link.doc&quot; '>i18n.catalog.rest.link.doc</xsl:when>
			<xsl:when test='$key = &quot;catalog.rest.link.geojson&quot; '>i18n.catalog.rest.link.geojson</xsl:when>
			<xsl:when test='$key = &quot;catalog.rest.link.getcoverage&quot; '>i18n.catalog.rest.link.getcoverage</xsl:when>
			<xsl:when test='$key = &quot;catalog.rest.link.getmap&quot; '>i18n.catalog.rest.link.getmap</xsl:when>
			<xsl:when test='$key = &quot;catalog.rest.link.gml&quot; '>i18n.catalog.rest.link.gml</xsl:when>
			<xsl:when test='$key = &quot;catalog.rest.link.html&quot; '>i18n.catalog.rest.link.html</xsl:when>
			<xsl:when test='$key = &quot;catalog.rest.link.json&quot; '>i18n.catalog.rest.link.json</xsl:when>
			<xsl:when test='$key = &quot;catalog.rest.link.kml&quot; '>i18n.catalog.rest.link.kml</xsl:when>
			<xsl:when test='$key = &quot;catalog.rest.link.pdf&quot; '>i18n.catalog.rest.link.pdf</xsl:when>
			<xsl:when test='$key = &quot;catalog.rest.link.ppt&quot; '>i18n.catalog.rest.link.ppt</xsl:when>
			<xsl:when test='$key = &quot;catalog.rest.link.shp&quot; '>i18n.catalog.rest.link.shp</xsl:when>
			<xsl:when test='$key = &quot;catalog.rest.link.sos&quot; '>i18n.catalog.rest.link.sos</xsl:when>
			<xsl:when test='$key = &quot;catalog.rest.link.txt&quot; '>i18n.catalog.rest.link.txt</xsl:when>
			<xsl:when test='$key = &quot;catalog.rest.link.wcs&quot; '>i18n.catalog.rest.link.wcs</xsl:when>
			<xsl:when test='$key = &quot;catalog.rest.link.wfs&quot; '>i18n.catalog.rest.link.wfs</xsl:when>
			<xsl:when test='$key = &quot;catalog.rest.link.wms&quot; '>i18n.catalog.rest.link.wms</xsl:when>
			<xsl:when test='$key = &quot;catalog.rest.link.xls&quot; '>i18n.catalog.rest.link.xls</xsl:when>
			<xsl:when test='$key = &quot;catalog.rest.link.xml&quot; '>i18n.catalog.rest.link.xml</xsl:when>
			<xsl:when test='$key = &quot;catalog.rest.link.zip&quot; '>i18n.catalog.rest.link.zip</xsl:when>
			<xsl:when test='$key = &quot;catalog.rest.open&quot; '>i18n.catalog.rest.open</xsl:when>
			<xsl:when test='$key = &quot;catalog.rest.preview&quot; '>i18n.catalog.rest.preview</xsl:when>
			<xsl:when test='$key = &quot;catalog.rest.thumbNail&quot; '>i18n.catalog.rest.thumbNail</xsl:when>
			<xsl:when test='$key = &quot;catalog.rest.title&quot; '>i18n.catalog.rest.title</xsl:when>
			<xsl:when test='$key = &quot;catalog.rest.viewDetails&quot; '>i18n.catalog.rest.viewDetails</xsl:when>
			<xsl:when test='$key = &quot;catalog.rest.viewFullMetadata&quot; '>i18n.catalog.rest.viewFullMetadata</xsl:when>
			<xsl:when test='$key = &quot;catalog.rest.webapp&quot; '>i18n.catalog.rest.webapp</xsl:when>
			<xsl:when test='$key = &quot;catalog.rest.webSite&quot; '>i18n.catalog.rest.webSite</xsl:when>
			<xsl:when test='$key = &quot;catalog.rest.wfs&quot; '>i18n.catalog.rest.wfs</xsl:when>
			<xsl:when test='$key = &quot;catalog.rest.wms&quot; '>i18n.catalog.rest.wms</xsl:when>
			<xsl:when test='$key = &quot;catalog.rndt.raster.datiraster.coordinate&quot; '>i18n.catalog.rndt.raster.datiraster.coordinate</xsl:when>
			<xsl:when test='$key = &quot;catalog.rndt.raster.datiraster.id&quot; '>i18n.catalog.rndt.raster.datiraster.id</xsl:when>
			<xsl:when test='$key = &quot;catalog.rndt.raster.datiraster.nome&quot; '>i18n.catalog.rndt.raster.datiraster.nome</xsl:when>
			<xsl:when test='$key = &quot;catalog.rndt.raster.datiraster.one.coord&quot; '>i18n.catalog.rndt.raster.datiraster.one.coord</xsl:when>
			<xsl:when test='$key = &quot;catalog.role.gptAdministrator&quot; '>i18n.catalog.role.gptAdministrator</xsl:when>
			<xsl:when test='$key = &quot;catalog.role.gptForbiddenAccess&quot; '>i18n.catalog.role.gptForbiddenAccess</xsl:when>
			<xsl:when test='$key = &quot;catalog.role.gptPublisher&quot; '>i18n.catalog.role.gptPublisher</xsl:when>
			<xsl:when test='$key = &quot;catalog.role.gptRegisteredUser&quot; '>i18n.catalog.role.gptRegisteredUser</xsl:when>
			<xsl:when test='$key = &quot;catalog.sdisuite.licenseManager.caption&quot; '>i18n.catalog.sdisuite.licenseManager.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.sdisuite.licenseManager.menuCaption&quot; '>i18n.catalog.sdisuite.licenseManager.menuCaption</xsl:when>
			<xsl:when test='$key = &quot;catalog.sdisuite.licenses.menuCaption&quot; '>i18n.catalog.sdisuite.licenses.menuCaption</xsl:when>
			<xsl:when test='$key = &quot;catalog.sdisuite.menuCaption&quot; '>i18n.catalog.sdisuite.menuCaption</xsl:when>
			<xsl:when test='$key = &quot;catalog.sdisuite.securityManager.caption&quot; '>i18n.catalog.sdisuite.securityManager.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.sdisuite.securityManager.menuCaption&quot; '>i18n.catalog.sdisuite.securityManager.menuCaption</xsl:when>
			<xsl:when test='$key = &quot;catalog.sdisuite.serviceMonitor.caption&quot; '>i18n.catalog.sdisuite.serviceMonitor.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.sdisuite.serviceMonitor.menuCaption&quot; '>i18n.catalog.sdisuite.serviceMonitor.menuCaption</xsl:when>
			<xsl:when test='$key = &quot;catalog.sdisuite.smartEditor.caption&quot; '>i18n.catalog.sdisuite.smartEditor.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.sdisuite.smartEditor.menuCaption&quot; '>i18n.catalog.sdisuite.smartEditor.menuCaption</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.additionalOptions&quot; '>i18n.catalog.search.additionalOptions</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.contentDateSearch.anytime&quot; '>i18n.catalog.search.contentDateSearch.anytime</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.contentDateSearch.datePattern&quot; '>i18n.catalog.search.contentDateSearch.datePattern</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.contentDateSearch.endDate&quot; '>i18n.catalog.search.contentDateSearch.endDate</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.contentDateSearch.intersecting&quot; '>i18n.catalog.search.contentDateSearch.intersecting</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.contentDateSearch.startDate&quot; '>i18n.catalog.search.contentDateSearch.startDate</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.contentDateSearch.WindowTitle&quot; '>i18n.catalog.search.contentDateSearch.WindowTitle</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.contentDateSearch.WindowTitleRemark&quot; '>i18n.catalog.search.contentDateSearch.WindowTitleRemark</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.contentDateSearch.within&quot; '>i18n.catalog.search.contentDateSearch.within</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.datacategories.caption&quot; '>i18n.catalog.search.datacategories.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.date.2010&quot; '>i18n.catalog.search.date.2010</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.date.2011&quot; '>i18n.catalog.search.date.2011</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.date.2012&quot; '>i18n.catalog.search.date.2012</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.date.after2012&quot; '>i18n.catalog.search.date.after2012</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.date.before2010&quot; '>i18n.catalog.search.date.before2010</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.date.caption&quot; '>i18n.catalog.search.date.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.directedSearch.authenticate&quot; '>i18n.catalog.search.directedSearch.authenticate</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.directedSearch.extSite.caption&quot; '>i18n.catalog.search.directedSearch.extSite.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.directedSearch.password&quot; '>i18n.catalog.search.directedSearch.password</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.directedSearch.username&quot; '>i18n.catalog.search.directedSearch.username</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.distributedSearch.atomTitle&quot; '>i18n.catalog.search.distributedSearch.atomTitle</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.distributedSearch.ConfigTitle&quot; '>i18n.catalog.search.distributedSearch.ConfigTitle</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.distributedSearch.ConfigTitleRemark&quot; '>i18n.catalog.search.distributedSearch.ConfigTitleRemark</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.distributedSearch.configure&quot; '>i18n.catalog.search.distributedSearch.configure</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.distributedSearch.hitCountUnknown&quot; '>i18n.catalog.search.distributedSearch.hitCountUnknown</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.distributedSearch.linkLabel&quot; '>i18n.catalog.search.distributedSearch.linkLabel</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.distributedSearch.maxedSites&quot; '>i18n.catalog.search.distributedSearch.maxedSites</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.distributedSearch.results&quot; '>i18n.catalog.search.distributedSearch.results</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.distributedSearch.ridDbEntryNotFound&quot; '>i18n.catalog.search.distributedSearch.ridDbEntryNotFound</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.distributedSearch.ridEngineNotFound&quot; '>i18n.catalog.search.distributedSearch.ridEngineNotFound</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.distributedSearch.searchFailed&quot; '>i18n.catalog.search.distributedSearch.searchFailed</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.distributedSearch.searchTimeout&quot; '>i18n.catalog.search.distributedSearch.searchTimeout</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.distributedSearch.WindowTitle&quot; '>i18n.catalog.search.distributedSearch.WindowTitle</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.distributedSearch.WindowTitleRemark&quot; '>i18n.catalog.search.distributedSearch.WindowTitleRemark</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.error.maxSavedSearchesReached&quot; '>i18n.catalog.search.error.maxSavedSearchesReached</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.error.noLoadCriteria&quot; '>i18n.catalog.search.error.noLoadCriteria</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.error.searchTimeOut&quot; '>i18n.catalog.search.error.searchTimeOut</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.filterConnection.catalogUri&quot; '>i18n.catalog.search.filterConnection.catalogUri</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.filterContentTypes.application&quot; '>i18n.catalog.search.filterContentTypes.application</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.filterContentTypes.audio&quot; '>i18n.catalog.search.filterContentTypes.audio</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.filterContentTypes.clearinghouse&quot; '>i18n.catalog.search.filterContentTypes.clearinghouse</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.filterContentTypes.default&quot; '>i18n.catalog.search.filterContentTypes.default</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.filterContentTypes.document&quot; '>i18n.catalog.search.filterContentTypes.document</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.filterContentTypes.downloadableData&quot; '>i18n.catalog.search.filterContentTypes.downloadableData</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.filterContentTypes.geographicActivities&quot; '>i18n.catalog.search.filterContentTypes.geographicActivities</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.filterContentTypes.geographicService&quot; '>i18n.catalog.search.filterContentTypes.geographicService</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.filterContentTypes.liveData&quot; '>i18n.catalog.search.filterContentTypes.liveData</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.filterContentTypes.mapFiles&quot; '>i18n.catalog.search.filterContentTypes.mapFiles</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.filterContentTypes.meteo&quot; '>i18n.catalog.search.filterContentTypes.meteo</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.filterContentTypes.offlineData&quot; '>i18n.catalog.search.filterContentTypes.offlineData</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.filterContentTypes.staticImage&quot; '>i18n.catalog.search.filterContentTypes.staticImage</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.filterContentTypes.staticMapImage&quot; '>i18n.catalog.search.filterContentTypes.staticMapImage</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.filterContentTypes.title&quot; '>i18n.catalog.search.filterContentTypes.title</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.filterContentTypes.unknown&quot; '>i18n.catalog.search.filterContentTypes.unknown</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.filterContentTypes.video&quot; '>i18n.catalog.search.filterContentTypes.video</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.filterKeyword.all&quot; '>i18n.catalog.search.filterKeyword.all</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.filterKeyword.exact&quot; '>i18n.catalog.search.filterKeyword.exact</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.filterSort.areaAscending&quot; '>i18n.catalog.search.filterSort.areaAscending</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.filterSort.areaDescending&quot; '>i18n.catalog.search.filterSort.areaDescending</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.filterSort.dateAscending&quot; '>i18n.catalog.search.filterSort.dateAscending</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.filterSort.dateDescending&quot; '>i18n.catalog.search.filterSort.dateDescending</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.filterSort.Format&quot; '>i18n.catalog.search.filterSort.Format</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.filterSort.labelSort&quot; '>i18n.catalog.search.filterSort.labelSort</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.filterSort.Relevance&quot; '>i18n.catalog.search.filterSort.Relevance</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.filterSort.Title&quot; '>i18n.catalog.search.filterSort.Title</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.filterSpatial.anywhere&quot; '>i18n.catalog.search.filterSpatial.anywhere</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.filterSpatial.dataWithinExtent&quot; '>i18n.catalog.search.filterSpatial.dataWithinExtent</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.filterSpatial.extents&quot; '>i18n.catalog.search.filterSpatial.extents</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.filterSpatial.extents&quot; '>i18n.catalog.search.filterSpatial.extents</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.filterSpatial.extents.default&quot; '>i18n.catalog.search.filterSpatial.extents.default</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.filterSpatial.extents.default&quot; '>i18n.catalog.search.filterSpatial.extents.default</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.filterSpatial.maximumX&quot; '>i18n.catalog.search.filterSpatial.maximumX</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.filterSpatial.maximumY&quot; '>i18n.catalog.search.filterSpatial.maximumY</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.filterSpatial.minimumX&quot; '>i18n.catalog.search.filterSpatial.minimumX</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.filterSpatial.minimumY&quot; '>i18n.catalog.search.filterSpatial.minimumY</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.filterSpatial.title&quot; '>i18n.catalog.search.filterSpatial.title</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.filterSpatial.useGeogExtent&quot; '>i18n.catalog.search.filterSpatial.useGeogExtent</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.filterTemporal.any&quot; '>i18n.catalog.search.filterTemporal.any</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.filterTemporal.dateFrom&quot; '>i18n.catalog.search.filterTemporal.dateFrom</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.filterTemporal.dateTo&quot; '>i18n.catalog.search.filterTemporal.dateTo</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.filterTemporal.period&quot; '>i18n.catalog.search.filterTemporal.period</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.filterTemporal.title&quot; '>i18n.catalog.search.filterTemporal.title</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.filterThemeTypes.title&quot; '>i18n.catalog.search.filterThemeTypes.title</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.home.caption&quot; '>i18n.catalog.search.home.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.home.menuCaption&quot; '>i18n.catalog.search.home.menuCaption</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.inspire.caption&quot; '>i18n.catalog.search.inspire.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.liveData.basemapLabel&quot; '>i18n.catalog.search.liveData.basemapLabel</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.liveData.embed&quot; '>i18n.catalog.search.liveData.embed</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.liveData.errorMessage&quot; '>i18n.catalog.search.liveData.errorMessage</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.liveData.title&quot; '>i18n.catalog.search.liveData.title</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.liveData.tooltips&quot; '>i18n.catalog.search.liveData.tooltips</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.liveData.url&quot; '>i18n.catalog.search.liveData.url</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.liveData.WMSErrorMessage&quot; '>i18n.catalog.search.liveData.WMSErrorMessage</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.map.findPlace.invalidCoord&quot; '>i18n.catalog.search.map.findPlace.invalidCoord</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.resource.details.caption&quot; '>i18n.catalog.search.resource.details.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.resource.details.title&quot; '>i18n.catalog.search.resource.details.title</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.resource.details.togglesection&quot; '>i18n.catalog.search.resource.details.togglesection</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.resource.preview.caption&quot; '>i18n.catalog.search.resource.preview.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.resource.relationships.caption&quot; '>i18n.catalog.search.resource.relationships.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.resource.relationships.prompt&quot; '>i18n.catalog.search.resource.relationships.prompt</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.resource.relationships.title&quot; '>i18n.catalog.search.resource.relationships.title</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.resource.review.caption&quot; '>i18n.catalog.search.resource.review.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.resource.review.title&quot; '>i18n.catalog.search.resource.review.title</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.responsible.arpa&quot; '>i18n.catalog.search.responsible.arpa</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.responsible.caption&quot; '>i18n.catalog.search.responsible.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.responsible.inva&quot; '>i18n.catalog.search.responsible.inva</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.responsible.liguria&quot; '>i18n.catalog.search.responsible.liguria</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.responsible.other&quot; '>i18n.catalog.search.responsible.other</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.savedSearches.caption&quot; '>i18n.catalog.search.savedSearches.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.savedSearches.delete&quot; '>i18n.catalog.search.savedSearches.delete</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.savedSearches.noSaveName&quot; '>i18n.catalog.search.savedSearches.noSaveName</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.search.btnReset&quot; '>i18n.catalog.search.search.btnReset</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.search.btnSave&quot; '>i18n.catalog.search.search.btnSave</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.search.btnSearch&quot; '>i18n.catalog.search.search.btnSearch</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.search.lblLocator&quot; '>i18n.catalog.search.search.lblLocator</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.search.lblSearch&quot; '>i18n.catalog.search.search.lblSearch</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.search.Multilingua&quot; '>i18n.catalog.search.search.Multilingua</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.searchResult.addToArcMap&quot; '>i18n.catalog.search.searchResult.addToArcMap</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.searchResult.addToGlobeKml&quot; '>i18n.catalog.search.searchResult.addToGlobeKml</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.searchResult.addToGlobeNmf&quot; '>i18n.catalog.search.searchResult.addToGlobeNmf</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.searchResult.addToMap&quot; '>i18n.catalog.search.searchResult.addToMap</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.searchResult.altReview&quot; '>i18n.catalog.search.searchResult.altReview</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.searchResult.caption&quot; '>i18n.catalog.search.searchResult.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.searchResult.downloadSite&quot; '>i18n.catalog.search.searchResult.downloadSite</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.searchResult.labelNoResults&quot; '>i18n.catalog.search.searchResult.labelNoResults</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.searchResult.lblExpand&quot; '>i18n.catalog.search.searchResult.lblExpand</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.searchResult.lblModifySearch&quot; '>i18n.catalog.search.searchResult.lblModifySearch</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.searchResult.lblNewSearch&quot; '>i18n.catalog.search.searchResult.lblNewSearch</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.searchResult.lblSearchKeyword&quot; '>i18n.catalog.search.searchResult.lblSearchKeyword</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.searchResult.lblToggle&quot; '>i18n.catalog.search.searchResult.lblToggle</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.searchResult.metadataSite&quot; '>i18n.catalog.search.searchResult.metadataSite</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.searchResult.openResource&quot; '>i18n.catalog.search.searchResult.openResource</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.searchResult.restLabel&quot; '>i18n.catalog.search.searchResult.restLabel</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.searchResult.review0CoutLabel&quot; '>i18n.catalog.search.searchResult.review0CoutLabel</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.searchResult.reviewCountLabel&quot; '>i18n.catalog.search.searchResult.reviewCountLabel</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.searchResult.share&quot; '>i18n.catalog.search.searchResult.share</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.searchResult.viewDetails&quot; '>i18n.catalog.search.searchResult.viewDetails</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.searchResult.viewFullMetadata&quot; '>i18n.catalog.search.searchResult.viewFullMetadata</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.searchResult.zoomTo&quot; '>i18n.catalog.search.searchResult.zoomTo</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.searchResult.zoomToAOI&quot; '>i18n.catalog.search.searchResult.zoomToAOI</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.searchResult.zoomToThese&quot; '>i18n.catalog.search.searchResult.zoomToThese</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.searchSite.agsonline&quot; '>i18n.catalog.search.searchSite.agsonline</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.searchSite.agsonline.abstract&quot; '>i18n.catalog.search.searchSite.agsonline.abstract</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.searchSite.agssearch&quot; '>i18n.catalog.search.searchSite.agssearch</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.searchSite.agssearch.abstract&quot; '>i18n.catalog.search.searchSite.agssearch.abstract</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.searchSite.dataGov&quot; '>i18n.catalog.search.searchSite.dataGov</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.searchSite.dataGov.abstract&quot; '>i18n.catalog.search.searchSite.dataGov.abstract</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.searchSite.defaultsite&quot; '>i18n.catalog.search.searchSite.defaultsite</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.searchSite.defaultsite.abstract&quot; '>i18n.catalog.search.searchSite.defaultsite.abstract</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.searchSite.geoDab&quot; '>i18n.catalog.search.searchSite.geoDab</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.searchSite.geoDab.abstract&quot; '>i18n.catalog.search.searchSite.geoDab.abstract</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.searchSite.labelPrfx&quot; '>i18n.catalog.search.searchSite.labelPrfx</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.searchSite.sharepointsearch&quot; '>i18n.catalog.search.searchSite.sharepointsearch</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.searchSite.sharepointsearch.abstract&quot; '>i18n.catalog.search.searchSite.sharepointsearch.abstract</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.searchSite.youtubesearch&quot; '>i18n.catalog.search.searchSite.youtubesearch</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.searchSite.youtubesearch.abstract&quot; '>i18n.catalog.search.searchSite.youtubesearch.abstract</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.viewMetadataDetails.backToSrch&quot; '>i18n.catalog.search.viewMetadataDetails.backToSrch</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.viewMetadataDetails.caption&quot; '>i18n.catalog.search.viewMetadataDetails.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.search.viewMetadataDetails.liveData&quot; '>i18n.catalog.search.viewMetadataDetails.liveData</xsl:when>
			<xsl:when test='$key = &quot;catalog.searchCriteria.hintSearch.prompt&quot; '>i18n.catalog.searchCriteria.hintSearch.prompt</xsl:when>
			<xsl:when test='$key = &quot;catalog.searchresult.csv.header.abstract&quot; '>i18n.catalog.searchresult.csv.header.abstract</xsl:when>
			<xsl:when test='$key = &quot;catalog.searchresult.csv.header.contentType&quot; '>i18n.catalog.searchresult.csv.header.contentType</xsl:when>
			<xsl:when test='$key = &quot;catalog.searchresult.csv.header.east&quot; '>i18n.catalog.searchresult.csv.header.east</xsl:when>
			<xsl:when test='$key = &quot;catalog.searchresult.csv.header.north&quot; '>i18n.catalog.searchresult.csv.header.north</xsl:when>
			<xsl:when test='$key = &quot;catalog.searchresult.csv.header.south&quot; '>i18n.catalog.searchresult.csv.header.south</xsl:when>
			<xsl:when test='$key = &quot;catalog.searchresult.csv.header.title&quot; '>i18n.catalog.searchresult.csv.header.title</xsl:when>
			<xsl:when test='$key = &quot;catalog.searchresult.csv.header.urlToliveData&quot; '>i18n.catalog.searchresult.csv.header.urlToliveData</xsl:when>
			<xsl:when test='$key = &quot;catalog.searchresult.csv.header.urlToMetadata&quot; '>i18n.catalog.searchresult.csv.header.urlToMetadata</xsl:when>
			<xsl:when test='$key = &quot;catalog.searchresult.csv.header.urlToSiteOrDownLoad&quot; '>i18n.catalog.searchresult.csv.header.urlToSiteOrDownLoad</xsl:when>
			<xsl:when test='$key = &quot;catalog.searchresult.csv.header.west&quot; '>i18n.catalog.searchresult.csv.header.west</xsl:when>
			<xsl:when test='$key = &quot;catalog.site.anonymous&quot; '>i18n.catalog.site.anonymous</xsl:when>
			<xsl:when test='$key = &quot;catalog.site.skipToContent&quot; '>i18n.catalog.site.skipToContent</xsl:when>
			<xsl:when test='$key = &quot;catalog.site.title&quot; '>i18n.catalog.site.title</xsl:when>
			<xsl:when test='$key = &quot;catalog.site.welcome&quot; '>i18n.catalog.site.welcome</xsl:when>
			<xsl:when test='$key = &quot;catalog.TimePeriod.Unit.day&quot; '>i18n.catalog.TimePeriod.Unit.day</xsl:when>
			<xsl:when test='$key = &quot;catalog.TimePeriod.Unit.days&quot; '>i18n.catalog.TimePeriod.Unit.days</xsl:when>
			<xsl:when test='$key = &quot;catalog.TimePeriod.Unit.hour&quot; '>i18n.catalog.TimePeriod.Unit.hour</xsl:when>
			<xsl:when test='$key = &quot;catalog.TimePeriod.Unit.hours&quot; '>i18n.catalog.TimePeriod.Unit.hours</xsl:when>
			<xsl:when test='$key = &quot;catalog.TimePeriod.Unit.millisecond&quot; '>i18n.catalog.TimePeriod.Unit.millisecond</xsl:when>
			<xsl:when test='$key = &quot;catalog.TimePeriod.Unit.milliseconds&quot; '>i18n.catalog.TimePeriod.Unit.milliseconds</xsl:when>
			<xsl:when test='$key = &quot;catalog.TimePeriod.Unit.minute&quot; '>i18n.catalog.TimePeriod.Unit.minute</xsl:when>
			<xsl:when test='$key = &quot;catalog.TimePeriod.Unit.minutes&quot; '>i18n.catalog.TimePeriod.Unit.minutes</xsl:when>
			<xsl:when test='$key = &quot;catalog.TimePeriod.Unit.month&quot; '>i18n.catalog.TimePeriod.Unit.month</xsl:when>
			<xsl:when test='$key = &quot;catalog.TimePeriod.Unit.months&quot; '>i18n.catalog.TimePeriod.Unit.months</xsl:when>
			<xsl:when test='$key = &quot;catalog.TimePeriod.Unit.second&quot; '>i18n.catalog.TimePeriod.Unit.second</xsl:when>
			<xsl:when test='$key = &quot;catalog.TimePeriod.Unit.seconds&quot; '>i18n.catalog.TimePeriod.Unit.seconds</xsl:when>
			<xsl:when test='$key = &quot;catalog.TimePeriod.Unit.week&quot; '>i18n.catalog.TimePeriod.Unit.week</xsl:when>
			<xsl:when test='$key = &quot;catalog.TimePeriod.Unit.weeks&quot; '>i18n.catalog.TimePeriod.Unit.weeks</xsl:when>
			<xsl:when test='$key = &quot;catalog.widget.search.about&quot; '>i18n.catalog.widget.search.about</xsl:when>
			<xsl:when test='$key = &quot;catalog.widget.search.caption&quot; '>i18n.catalog.widget.search.caption</xsl:when>
			<xsl:when test='$key = &quot;catalog.widget.search.label&quot; '>i18n.catalog.widget.search.label</xsl:when>
			<xsl:when test='$key = &quot;catalog.widget.search.msg.noMatch&quot; '>i18n.catalog.widget.search.msg.noMatch</xsl:when>
			<xsl:when test='$key = &quot;catalog.widget.search.tip.about&quot; '>i18n.catalog.widget.search.tip.about</xsl:when>
			<xsl:when test='$key = &quot;catalog.widget.search.tip.close&quot; '>i18n.catalog.widget.search.tip.close</xsl:when>
			<xsl:when test='$key = &quot;catalog.widget.search.tip.kml&quot; '>i18n.catalog.widget.search.tip.kml</xsl:when>
			<xsl:when test='$key = &quot;catalog.widget.search.tip.rss&quot; '>i18n.catalog.widget.search.tip.rss</xsl:when>
			<xsl:when test='$key = &quot;catalog.widget.search.tip.search&quot; '>i18n.catalog.widget.search.tip.search</xsl:when>
			<xsl:when test='$key = &quot;com.esri.gpt.catalog.harvest.adhoc.timePoints.caption&quot; '>i18n.com.esri.gpt.catalog.harvest.adhoc.timePoints.caption</xsl:when>
			<xsl:when test='$key = &quot;com.esri.gpt.catalog.schema.UnrecognizedSchemaException&quot; '>i18n.com.esri.gpt.catalog.schema.UnrecognizedSchemaException</xsl:when>
			<xsl:when test='$key = &quot;com.esri.gpt.catalog.search.SearchException&quot; '>i18n.com.esri.gpt.catalog.search.SearchException</xsl:when>
			<xsl:when test='$key = &quot;com.esri.gpt.framework.security.credentials.CredentialsDeniedException&quot; '>i18n.com.esri.gpt.framework.security.credentials.CredentialsDeniedException</xsl:when>
			<xsl:when test='$key = &quot;com.esri.gpt.framework.security.identity.NotAuthorizedException&quot; '>i18n.com.esri.gpt.framework.security.identity.NotAuthorizedException</xsl:when>
			<xsl:when test='$key = &quot;fgdc.citation.onlineLinkage.resource&quot; '>i18n.fgdc.citation.onlineLinkage.resource</xsl:when>
			<xsl:when test='$key = &quot;fgdc.citation.onlineLinkage.website&quot; '>i18n.fgdc.citation.onlineLinkage.website</xsl:when>
			<xsl:when test='$key = &quot;fgdc.citation.originator&quot; '>i18n.fgdc.citation.originator</xsl:when>
			<xsl:when test='$key = &quot;fgdc.citation.publicationDate&quot; '>i18n.fgdc.citation.publicationDate</xsl:when>
			<xsl:when test='$key = &quot;fgdc.citation.publInfo.place&quot; '>i18n.fgdc.citation.publInfo.place</xsl:when>
			<xsl:when test='$key = &quot;fgdc.citation.publInfo.publish&quot; '>i18n.fgdc.citation.publInfo.publish</xsl:when>
			<xsl:when test='$key = &quot;fgdc.constraint.access&quot; '>i18n.fgdc.constraint.access</xsl:when>
			<xsl:when test='$key = &quot;fgdc.constraint.use&quot; '>i18n.fgdc.constraint.use</xsl:when>
			<xsl:when test='$key = &quot;fgdc.dataQualInfo.caption&quot; '>i18n.fgdc.dataQualInfo.caption</xsl:when>
			<xsl:when test='$key = &quot;fgdc.dataQualInfo.compRepo&quot; '>i18n.fgdc.dataQualInfo.compRepo</xsl:when>
			<xsl:when test='$key = &quot;fgdc.dataQualInfo.line.procStep1.procDate&quot; '>i18n.fgdc.dataQualInfo.line.procStep1.procDate</xsl:when>
			<xsl:when test='$key = &quot;fgdc.dataQualInfo.line.procStep1.procDesc&quot; '>i18n.fgdc.dataQualInfo.line.procStep1.procDesc</xsl:when>
			<xsl:when test='$key = &quot;fgdc.dataQualInfo.line.procStep2.procDate&quot; '>i18n.fgdc.dataQualInfo.line.procStep2.procDate</xsl:when>
			<xsl:when test='$key = &quot;fgdc.dataQualInfo.line.procStep2.procDesc&quot; '>i18n.fgdc.dataQualInfo.line.procStep2.procDesc</xsl:when>
			<xsl:when test='$key = &quot;fgdc.dataQualInfo.line.procStep3.procDate&quot; '>i18n.fgdc.dataQualInfo.line.procStep3.procDate</xsl:when>
			<xsl:when test='$key = &quot;fgdc.dataQualInfo.line.procStep3.procDesc&quot; '>i18n.fgdc.dataQualInfo.line.procStep3.procDesc</xsl:when>
			<xsl:when test='$key = &quot;fgdc.dataQualInfo.line.section&quot; '>i18n.fgdc.dataQualInfo.line.section</xsl:when>
			<xsl:when test='$key = &quot;fgdc.dataQualInfo.logiConsRepo&quot; '>i18n.fgdc.dataQualInfo.logiConsRepo</xsl:when>
			<xsl:when test='$key = &quot;fgdc.dataQualInfo.posiAccu.horiPosiAccu.horiPosiAccuRepo&quot; '>i18n.fgdc.dataQualInfo.posiAccu.horiPosiAccu.horiPosiAccuRepo</xsl:when>
			<xsl:when test='$key = &quot;fgdc.dataQualInfo.posiAccu.horiPosiAccu.quanHoriPosiAccuAsse&quot; '>i18n.fgdc.dataQualInfo.posiAccu.horiPosiAccu.quanHoriPosiAccuAsse</xsl:when>
			<xsl:when test='$key = &quot;fgdc.dataQualInfo.posiAccu.horiPosiAccu.quanHoriPosiAccuAsse.horiPosiAccuExpl&quot; '>i18n.fgdc.dataQualInfo.posiAccu.horiPosiAccu.quanHoriPosiAccuAsse.horiPosiAccuExpl</xsl:when>
			<xsl:when test='$key = &quot;fgdc.dataQualInfo.posiAccu.horiPosiAccu.quanHoriPosiAccuAsse.horiPosiAccuValu&quot; '>i18n.fgdc.dataQualInfo.posiAccu.horiPosiAccu.quanHoriPosiAccuAsse.horiPosiAccuValu</xsl:when>
			<xsl:when test='$key = &quot;fgdc.dataQualInfo.posiAccu.section&quot; '>i18n.fgdc.dataQualInfo.posiAccu.section</xsl:when>
			<xsl:when test='$key = &quot;fgdc.dataQualInfo.posiAccu.verPosiAccu.quanVertPosiAccuAsse.vertPosiAccuExpl&quot; '>i18n.fgdc.dataQualInfo.posiAccu.verPosiAccu.quanVertPosiAccuAsse.vertPosiAccuExpl</xsl:when>
			<xsl:when test='$key = &quot;fgdc.dataQualInfo.posiAccu.verPosiAccu.quanVertPosiAccuAsse.vertPosiAccuValu&quot; '>i18n.fgdc.dataQualInfo.posiAccu.verPosiAccu.quanVertPosiAccuAsse.vertPosiAccuValu</xsl:when>
			<xsl:when test='$key = &quot;fgdc.dataQualInfo.posiAccu.vertPosiAccu.vertPosiAccuRepo&quot; '>i18n.fgdc.dataQualInfo.posiAccu.vertPosiAccu.vertPosiAccuRepo</xsl:when>
			<xsl:when test='$key = &quot;fgdc.description.abstract&quot; '>i18n.fgdc.description.abstract</xsl:when>
			<xsl:when test='$key = &quot;fgdc.description.purpose&quot; '>i18n.fgdc.description.purpose</xsl:when>
			<xsl:when test='$key = &quot;fgdc.distInfo.caption&quot; '>i18n.fgdc.distInfo.caption</xsl:when>
			<xsl:when test='$key = &quot;fgdc.distInfo.distLiab&quot; '>i18n.fgdc.distInfo.distLiab</xsl:when>
			<xsl:when test='$key = &quot;fgdc.distInfo.resoDesc&quot; '>i18n.fgdc.distInfo.resoDesc</xsl:when>
			<xsl:when test='$key = &quot;fgdc.entiAndAttrInfo.caption&quot; '>i18n.fgdc.entiAndAttrInfo.caption</xsl:when>
			<xsl:when test='$key = &quot;fgdc.entiAndAttrInfo.overDesc.entiAndAttrDetaCita&quot; '>i18n.fgdc.entiAndAttrInfo.overDesc.entiAndAttrDetaCita</xsl:when>
			<xsl:when test='$key = &quot;fgdc.entiAndAttrInfo.overDesc.entiAndAttrOver&quot; '>i18n.fgdc.entiAndAttrInfo.overDesc.entiAndAttrOver</xsl:when>
			<xsl:when test='$key = &quot;fgdc.envelope.east&quot; '>i18n.fgdc.envelope.east</xsl:when>
			<xsl:when test='$key = &quot;fgdc.envelope.north&quot; '>i18n.fgdc.envelope.north</xsl:when>
			<xsl:when test='$key = &quot;fgdc.envelope.south&quot; '>i18n.fgdc.envelope.south</xsl:when>
			<xsl:when test='$key = &quot;fgdc.envelope.west&quot; '>i18n.fgdc.envelope.west</xsl:when>
			<xsl:when test='$key = &quot;fgdc.idenInfo.poinOfCont&quot; '>i18n.fgdc.idenInfo.poinOfCont</xsl:when>
			<xsl:when test='$key = &quot;fgdc.identification.caption&quot; '>i18n.fgdc.identification.caption</xsl:when>
			<xsl:when test='$key = &quot;fgdc.identification.title&quot; '>i18n.fgdc.identification.title</xsl:when>
			<xsl:when test='$key = &quot;fgdc.keywords.caption&quot; '>i18n.fgdc.keywords.caption</xsl:when>
			<xsl:when test='$key = &quot;fgdc.keywords.placeKeyword&quot; '>i18n.fgdc.keywords.placeKeyword</xsl:when>
			<xsl:when test='$key = &quot;fgdc.keywords.placeKeywordThesaurus&quot; '>i18n.fgdc.keywords.placeKeywordThesaurus</xsl:when>
			<xsl:when test='$key = &quot;fgdc.keywords.theme&quot; '>i18n.fgdc.keywords.theme</xsl:when>
			<xsl:when test='$key = &quot;fgdc.keywords.theme.reference&quot; '>i18n.fgdc.keywords.theme.reference</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.clarke1866&quot; '>i18n.fgdc.mdCode.clarke1866</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.confidential&quot; '>i18n.fgdc.mdCode.confidential</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.decimalDegrees&quot; '>i18n.fgdc.mdCode.decimalDegrees</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.decimalMinutes&quot; '>i18n.fgdc.mdCode.decimalMinutes</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.decimalSeconds&quot; '>i18n.fgdc.mdCode.decimalSeconds</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.degreesAndDecimalMinutes&quot; '>i18n.fgdc.mdCode.degreesAndDecimalMinutes</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.degreesMinutesAndDecimalSeconds&quot; '>i18n.fgdc.mdCode.degreesMinutesAndDecimalSeconds</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.frequency.annually&quot; '>i18n.fgdc.mdCode.frequency.annually</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.frequency.asNeeded&quot; '>i18n.fgdc.mdCode.frequency.asNeeded</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.frequency.continual&quot; '>i18n.fgdc.mdCode.frequency.continual</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.frequency.daily&quot; '>i18n.fgdc.mdCode.frequency.daily</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.frequency.irregular&quot; '>i18n.fgdc.mdCode.frequency.irregular</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.frequency.monthly&quot; '>i18n.fgdc.mdCode.frequency.monthly</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.frequency.notPlanned&quot; '>i18n.fgdc.mdCode.frequency.notPlanned</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.frequency.unknown&quot; '>i18n.fgdc.mdCode.frequency.unknown</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.frequency.weekly&quot; '>i18n.fgdc.mdCode.frequency.weekly</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.geodeticReferenceSystem80&quot; '>i18n.fgdc.mdCode.geodeticReferenceSystem80</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.geographicNamesInformationSystem&quot; '>i18n.fgdc.mdCode.geographicNamesInformationSystem</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.grads&quot; '>i18n.fgdc.mdCode.grads</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.none&quot; '>i18n.fgdc.mdCode.none</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.northAmericanDatumOf1927&quot; '>i18n.fgdc.mdCode.northAmericanDatumOf1927</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.northAmericanDatumOf1983&quot; '>i18n.fgdc.mdCode.northAmericanDatumOf1983</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.other&quot; '>i18n.fgdc.mdCode.other</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.other&quot; '>i18n.fgdc.mdCode.other</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.progress.completed&quot; '>i18n.fgdc.mdCode.progress.completed</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.progress.inWork&quot; '>i18n.fgdc.mdCode.progress.inWork</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.progress.planned&quot; '>i18n.fgdc.mdCode.progress.planned</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.radians&quot; '>i18n.fgdc.mdCode.radians</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.restricted&quot; '>i18n.fgdc.mdCode.restricted</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.resType.application&quot; '>i18n.fgdc.mdCode.resType.application</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.resType.clearingHouse&quot; '>i18n.fgdc.mdCode.resType.clearingHouse</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.resType.document&quot; '>i18n.fgdc.mdCode.resType.document</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.resType.downloadableData&quot; '>i18n.fgdc.mdCode.resType.downloadableData</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.resType.geographicActivies&quot; '>i18n.fgdc.mdCode.resType.geographicActivies</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.resType.geographicService&quot; '>i18n.fgdc.mdCode.resType.geographicService</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.resType.liveData&quot; '>i18n.fgdc.mdCode.resType.liveData</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.resType.mapFiles&quot; '>i18n.fgdc.mdCode.resType.mapFiles</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.resType.offlineData&quot; '>i18n.fgdc.mdCode.resType.offlineData</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.resType.staticMapImages&quot; '>i18n.fgdc.mdCode.resType.staticMapImages</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.secret&quot; '>i18n.fgdc.mdCode.secret</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.sensitive&quot; '>i18n.fgdc.mdCode.sensitive</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.topic.biota&quot; '>i18n.fgdc.mdCode.topic.biota</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.topic.boundaries&quot; '>i18n.fgdc.mdCode.topic.boundaries</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.topic.climatologyMeteorologyAtmosphere&quot; '>i18n.fgdc.mdCode.topic.climatologyMeteorologyAtmosphere</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.topic.economy&quot; '>i18n.fgdc.mdCode.topic.economy</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.topic.elevation&quot; '>i18n.fgdc.mdCode.topic.elevation</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.topic.environment&quot; '>i18n.fgdc.mdCode.topic.environment</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.topic.farming&quot; '>i18n.fgdc.mdCode.topic.farming</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.topic.geoscientificInformation&quot; '>i18n.fgdc.mdCode.topic.geoscientificInformation</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.topic.health&quot; '>i18n.fgdc.mdCode.topic.health</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.topic.imageryBaseMapsEarthCover&quot; '>i18n.fgdc.mdCode.topic.imageryBaseMapsEarthCover</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.topic.inlandWaters&quot; '>i18n.fgdc.mdCode.topic.inlandWaters</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.topic.intelligenceMilitary&quot; '>i18n.fgdc.mdCode.topic.intelligenceMilitary</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.topic.location&quot; '>i18n.fgdc.mdCode.topic.location</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.topic.oceans&quot; '>i18n.fgdc.mdCode.topic.oceans</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.topic.planningCadastre&quot; '>i18n.fgdc.mdCode.topic.planningCadastre</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.topic.society&quot; '>i18n.fgdc.mdCode.topic.society</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.topic.structure&quot; '>i18n.fgdc.mdCode.topic.structure</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.topic.transportation&quot; '>i18n.fgdc.mdCode.topic.transportation</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.topic.utilitiesCommunication&quot; '>i18n.fgdc.mdCode.topic.utilitiesCommunication</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.topSecret&quot; '>i18n.fgdc.mdCode.topSecret</xsl:when>
			<xsl:when test='$key = &quot;fgdc.mdCode.unclassified&quot; '>i18n.fgdc.mdCode.unclassified</xsl:when>
			<xsl:when test='$key = &quot;fgdc.metadata.reviewDate&quot; '>i18n.fgdc.metadata.reviewDate</xsl:when>
			<xsl:when test='$key = &quot;fgdc.metaRefe.caption&quot; '>i18n.fgdc.metaRefe.caption</xsl:when>
			<xsl:when test='$key = &quot;fgdc.metaRefe.date&quot; '>i18n.fgdc.metaRefe.date</xsl:when>
			<xsl:when test='$key = &quot;fgdc.secuInfo.secuClas&quot; '>i18n.fgdc.secuInfo.secuClas</xsl:when>
			<xsl:when test='$key = &quot;fgdc.secuInfo.secuClasSyst&quot; '>i18n.fgdc.secuInfo.secuClasSyst</xsl:when>
			<xsl:when test='$key = &quot;fgdc.secuInfo.secuHandDesc&quot; '>i18n.fgdc.secuInfo.secuHandDesc</xsl:when>
			<xsl:when test='$key = &quot;fgdc.spatRefeInfo.caption&quot; '>i18n.fgdc.spatRefeInfo.caption</xsl:when>
			<xsl:when test='$key = &quot;fgdc.spatRefeInfo.horiCoorSystDefi.geodMode&quot; '>i18n.fgdc.spatRefeInfo.horiCoorSystDefi.geodMode</xsl:when>
			<xsl:when test='$key = &quot;fgdc.spatRefeInfo.horiCoorSystDefi.geodMode.denoOfFlatRati&quot; '>i18n.fgdc.spatRefeInfo.horiCoorSystDefi.geodMode.denoOfFlatRati</xsl:when>
			<xsl:when test='$key = &quot;fgdc.spatRefeInfo.horiCoorSystDefi.geodMode.elliName&quot; '>i18n.fgdc.spatRefeInfo.horiCoorSystDefi.geodMode.elliName</xsl:when>
			<xsl:when test='$key = &quot;fgdc.spatRefeInfo.horiCoorSystDefi.geodMode.horiDatuName&quot; '>i18n.fgdc.spatRefeInfo.horiCoorSystDefi.geodMode.horiDatuName</xsl:when>
			<xsl:when test='$key = &quot;fgdc.spatRefeInfo.horiCoorSystDefi.geodMode.semiAxis&quot; '>i18n.fgdc.spatRefeInfo.horiCoorSystDefi.geodMode.semiAxis</xsl:when>
			<xsl:when test='$key = &quot;fgdc.spatRefeInfo.horiCoorSystDefi.geog.geogCoorUnit&quot; '>i18n.fgdc.spatRefeInfo.horiCoorSystDefi.geog.geogCoorUnit</xsl:when>
			<xsl:when test='$key = &quot;fgdc.spatRefeInfo.horiCoorSystDefi.geog.latiReso&quot; '>i18n.fgdc.spatRefeInfo.horiCoorSystDefi.geog.latiReso</xsl:when>
			<xsl:when test='$key = &quot;fgdc.spatRefeInfo.horiCoorSystDefi.geog.longReso&quot; '>i18n.fgdc.spatRefeInfo.horiCoorSystDefi.geog.longReso</xsl:when>
			<xsl:when test='$key = &quot;fgdc.standard.address.address&quot; '>i18n.fgdc.standard.address.address</xsl:when>
			<xsl:when test='$key = &quot;fgdc.standard.address.city&quot; '>i18n.fgdc.standard.address.city</xsl:when>
			<xsl:when test='$key = &quot;fgdc.standard.address.state&quot; '>i18n.fgdc.standard.address.state</xsl:when>
			<xsl:when test='$key = &quot;fgdc.standard.address.type&quot; '>i18n.fgdc.standard.address.type</xsl:when>
			<xsl:when test='$key = &quot;fgdc.standard.contactPerson&quot; '>i18n.fgdc.standard.contactPerson</xsl:when>
			<xsl:when test='$key = &quot;fgdc.standard.contactPosition&quot; '>i18n.fgdc.standard.contactPosition</xsl:when>
			<xsl:when test='$key = &quot;fgdc.standard.contInst&quot; '>i18n.fgdc.standard.contInst</xsl:when>
			<xsl:when test='$key = &quot;fgdc.standard.email&quot; '>i18n.fgdc.standard.email</xsl:when>
			<xsl:when test='$key = &quot;fgdc.standard.fax&quot; '>i18n.fgdc.standard.fax</xsl:when>
			<xsl:when test='$key = &quot;fgdc.standard.name&quot; '>i18n.fgdc.standard.name</xsl:when>
			<xsl:when test='$key = &quot;fgdc.standard.organization&quot; '>i18n.fgdc.standard.organization</xsl:when>
			<xsl:when test='$key = &quot;fgdc.standard.postal&quot; '>i18n.fgdc.standard.postal</xsl:when>
			<xsl:when test='$key = &quot;fgdc.standard.version&quot; '>i18n.fgdc.standard.version</xsl:when>
			<xsl:when test='$key = &quot;fgdc.standard.voiceTelephone&quot; '>i18n.fgdc.standard.voiceTelephone</xsl:when>
			<xsl:when test='$key = &quot;fgdc.status.frequency&quot; '>i18n.fgdc.status.frequency</xsl:when>
			<xsl:when test='$key = &quot;fgdc.status.progress&quot; '>i18n.fgdc.status.progress</xsl:when>
			<xsl:when test='$key = &quot;fgdc.theme.caption&quot; '>i18n.fgdc.theme.caption</xsl:when>
			<xsl:when test='$key = &quot;fgdc.theme.topics&quot; '>i18n.fgdc.theme.topics</xsl:when>
			<xsl:when test='$key = &quot;fgdc.timePeriod.beginDate&quot; '>i18n.fgdc.timePeriod.beginDate</xsl:when>
			<xsl:when test='$key = &quot;fgdc.timePeriod.catption&quot; '>i18n.fgdc.timePeriod.catption</xsl:when>
			<xsl:when test='$key = &quot;fgdc.timePeriod.currentness&quot; '>i18n.fgdc.timePeriod.currentness</xsl:when>
			<xsl:when test='$key = &quot;fgdc.timePeriod.endDate&quot; '>i18n.fgdc.timePeriod.endDate</xsl:when>
			<xsl:when test='$key = &quot;fgdc.timePeriod.multDate&quot; '>i18n.fgdc.timePeriod.multDate</xsl:when>
			<xsl:when test='$key = &quot;fgdc.timePeriod.rangOfDate&quot; '>i18n.fgdc.timePeriod.rangOfDate</xsl:when>
			<xsl:when test='$key = &quot;fgdc.timePeriod.singDate&quot; '>i18n.fgdc.timePeriod.singDate</xsl:when>
			<xsl:when test='$key = &quot;fgdc.timePeriod.singDate.caleDate&quot; '>i18n.fgdc.timePeriod.singDate.caleDate</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.general.characterSetData&quot; '>i18n.catalog.mdParam.general.characterSetData</xsl:when>
			<xsl:when test='$key = &quot;catalog.mdParam.rndt.identification.topics.title&quot; '>i18n.catalog.mdParam.rndt.identification.topics.title</xsl:when>
			<xsl:when test='$key = &quot;catalog.schedaMetadati.information&quot; '>i18n.catalog.schedaMetadati.information</xsl:when>	

		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
