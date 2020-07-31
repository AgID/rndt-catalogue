<?xml version="1.0" encoding="UTF-8"?>
<!--
 See the NOTICE file distributed with
 this work for additional information regarding copyright ownership.
 Esri Italy licenses this file to You under the Apache License, Version 2.0
 (the "License"); you may not use this file except in compliance with
 the License.  You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.

Esri Italy 
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" indent="no" encoding="UTF-8" omit-xml-declaration="yes"/>
	<xsl:variable name="small" select="'abcdefghijklmnopqrstuvwxyz'" />
	<xsl:variable name="caps" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
	<xsl:template match="/">
		<xsl:element name="csw:GetRecords" use-attribute-sets="GetRecordsAttributes" xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" xmlns:ogc="http://www.opengis.net/ogc" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:gml="http://www.opengis.net/gml" xmlns:gmd="http://www.isotc211.org/2005/gmd">
			<csw:Query typeNames="gmd:MD_Metadata">
				<csw:ElementSetName>full</csw:ElementSetName>
				<xsl:variable name="text">
					<xsl:choose>
						<xsl:when test="normalize-space(/GetRecords/KeyWord)!=''">1</xsl:when>
						<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="live">
					<xsl:choose>
						<xsl:when test="translate(normalize-space(/GetRecords/LiveDataMap/text()),'true', 'TRUE') ='TRUE'">1</xsl:when>
						<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="area">
					<xsl:choose>
						<xsl:when test="/GetRecords/Envelope/MinX">1</xsl:when>
						<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="time">
					<xsl:choose>
						<xsl:when test="string-length(normalize-space(/GetRecords/FromDate/text())) &gt; 0">1</xsl:when>
						<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="total">
					<xsl:value-of select="$text+$area+$live+$time"/>
				</xsl:variable>
				<xsl:if test="$total>0">
					<csw:Constraint version="1.0.0">
						<ogc:Filter xmlns="http://www.opengis.net/ogc">
							<xsl:choose>
								<xsl:when test="$total>1">
									<ogc:And>
										<xsl:apply-templates select="/GetRecords/KeyWord"/>
										<xsl:apply-templates select="/GetRecords/LiveDataMap"/>
										<xsl:apply-templates select="/GetRecords/Envelope"/>
										<xsl:call-template name="tmpltDate"/>
									</ogc:And>
								</xsl:when>
								<xsl:otherwise>
									<xsl:apply-templates select="/GetRecords/KeyWord"/>
									<xsl:apply-templates select="/GetRecords/LiveDataMap"/>
									<xsl:apply-templates select="/GetRecords/Envelope"/>
									<xsl:call-template name="tmpltDate"/>
								</xsl:otherwise>
							</xsl:choose>
						</ogc:Filter>
					</csw:Constraint>
				</xsl:if>
			</csw:Query>
		</xsl:element>
	</xsl:template>

	<!-- key word search -->
	<xsl:template match="/GetRecords/KeyWord" xmlns:ogc="http://www.opengis.net/ogc">
		<xsl:if test="normalize-space(.)!=''">

			<xsl:choose>
				<xsl:when test="starts-with(translate(normalize-space(.),$caps,$small), 'title:')">
					<ogc:PropertyIsLike escapeChar="!" singleChar="#" wildCard="*">
						<ogc:PropertyName>apiso:Title</ogc:PropertyName>
						<ogc:Literal>*<xsl:value-of select="substring-after(.,'title:')"/>*</ogc:Literal>
					</ogc:PropertyIsLike>
				</xsl:when>
				<xsl:when test="starts-with(translate(normalize-space(.),$caps,$small), 'abstract:')">
					<ogc:PropertyIsLike escapeChar="!" singleChar="#" wildCard="*">
						<ogc:PropertyName>apiso:Abstract</ogc:PropertyName>
						<ogc:Literal>*<xsl:value-of select="substring-after(.,'abstract:')"/>*</ogc:Literal>
					</ogc:PropertyIsLike>
				</xsl:when>
				<!-- Esri Italy: Multilingual search -->
				<xsl:when test="starts-with(translate(normalize-space(.),$caps,$small), 'babel|')">
					<ogc:Or>
						<xsl:call-template name="tokenizeString">
							<xsl:with-param name="list" select="substring-after(.,'babel|')"/>
							<xsl:with-param name="delimiter" select="','"/>
						</xsl:call-template>
					</ogc:Or>
				</xsl:when>
				<xsl:otherwise>
					<ogc:PropertyIsLike escapeChar="!" singleChar="#" wildCard="*">
						<ogc:PropertyName>apiso:AnyText</ogc:PropertyName>
						<ogc:Literal>*<xsl:value-of select="."/>*</ogc:Literal>
					</ogc:PropertyIsLike>
				</xsl:otherwise>
			</xsl:choose>

		</xsl:if>
	</xsl:template>

	<!-- LiveDataOrMaps search -->
	<xsl:template match="/GetRecords/LiveDataMap" xmlns:ogc="http://www.opengis.net/ogc">
		<xsl:if test="translate(normalize-space(./text()),'true', 'TRUE') ='TRUE'">
			<ogc:PropertyIsEqualTo>
				<ogc:PropertyName>dc:type</ogc:PropertyName>
				<ogc:Literal>liveData</ogc:Literal>
			</ogc:PropertyIsEqualTo>
		</xsl:if>
	</xsl:template>

	<!-- envelope search -->
	<xsl:template match="/GetRecords/Envelope" xmlns:ogc="http://www.opengis.net/ogc">
		<!-- generate BBOX query if minx, miny, maxx, maxy are provided -->
		<xsl:if test="./MinX and ./MinY and ./MaxX and ./MaxY">
			<ogc:Intersects xmlns:gml="http://www.opengis.net/gml">
				<ogc:PropertyName>apiso:BoundingBox</ogc:PropertyName>
				<gml:Envelope>
					<gml:lowerCorner>
						<xsl:value-of select="MinX"/>
						<xsl:text> </xsl:text>
						<xsl:value-of select="MinY"/>
					</gml:lowerCorner>
					<gml:upperCorner>
						<xsl:value-of select="MaxX"/>
						<xsl:text> </xsl:text>
						<xsl:value-of select="MaxY"/>
					</gml:upperCorner>
				</gml:Envelope>
			</ogc:Intersects>
		</xsl:if>
	</xsl:template>

	<!--    
	<ogc:PropertyIsLessThanOrEqualTo>
		<ogc:PropertyName>apiso:TempExtent_begin</ogc:PropertyName>
		<ogc:Literal>2011-01-30T23:00:00</ogc:Literal>
	</ogc:PropertyIsLessThanOrEqualTo>
	<ogc:PropertyIsGreaterThan>
		<ogc:PropertyName>apiso:TempExtent_end</ogc:PropertyName>
		<ogc:Literal>2008-01-10T23:00:00</ogc:Literal>
	</ogc:PropertyIsGreaterThan>
-->
	<xsl:template name="tmpltDate" xmlns:ogc="http://www.opengis.net/ogc">
		<xsl:if test="string-length(normalize-space(/GetRecords/FromDate/text())) &gt; 0">
			<ogc:PropertyIsGreaterThanOrEqualTo>
				<ogc:PropertyName>Modified</ogc:PropertyName>
				<ogc:Literal>
					<xsl:value-of select="normalize-space(/GetRecords/FromDate/text())"/>
				</ogc:Literal>
			</ogc:PropertyIsGreaterThanOrEqualTo>
		</xsl:if>
		<xsl:if test="string-length(normalize-space(/GetRecords/ToDate/text())) &gt; 0">
			<ogc:PropertyIsLessThanOrEqualTo>
				<ogc:PropertyName>Modified</ogc:PropertyName>
				<ogc:Literal>
					<xsl:value-of select="normalize-space(/GetRecords/ToDate/text())"/>
				</ogc:Literal>
			</ogc:PropertyIsLessThanOrEqualTo>
		</xsl:if>
	</xsl:template>
	<!--############################################################-->
	<!--## Template to tokenize strings                           ##-->
	<!--############################################################-->
	<xsl:template name="tokenizeString" xmlns:ogc="http://www.opengis.net/ogc">
		<!--passed template parameter -->
		<xsl:param name="list"/>
		<xsl:param name="delimiter"/>
		<xsl:choose>
			<xsl:when test="contains($list, $delimiter)"> 
                                <!-- If string starts with '?' it means no data -->
                                <xsl:if test="not(starts-with(translate(substring-before($list,$delimiter), '&quot;', ''), '?'))">
                                    <ogc:PropertyIsLike wildCard="%" escapeChar="_" singleChar="\">
                                            <ogc:PropertyName>AnyText</ogc:PropertyName>
                                            <ogc:Literal>
                                                    <!-- get everything in front of the first delimiter. Elimino il doppio apice -->
                                                    <xsl:value-of select="translate(substring-before($list,$delimiter), '&quot;', '')"/>
                                            </ogc:Literal>
                                    </ogc:PropertyIsLike>
                                </xsl:if>

				<xsl:call-template name="tokenizeString">
					<!-- store anything left in another variable -->
					<xsl:with-param name="list" select="substring-after($list,$delimiter)"/>
					<xsl:with-param name="delimiter" select="$delimiter"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$list = ''">
						<xsl:text/>
					</xsl:when>
					<xsl:otherwise>
                                            <!-- If string starts with '?' it means no data -->
                                             <xsl:if test="not(starts-with(translate($list, '&quot;', ''), '?'))">
						<ogc:PropertyIsLike wildCard="%" escapeChar="_" singleChar="\">
							<ogc:PropertyName>AnyText</ogc:PropertyName>
							<ogc:Literal>
								<xsl:value-of select="translate($list, '&quot;', '')"/>
							</ogc:Literal>
						</ogc:PropertyIsLike>
                                             </xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>	

	<xsl:attribute-set name="GetRecordsAttributes">
		<xsl:attribute name="version">2.0.2</xsl:attribute>
		<xsl:attribute name="service">CSW</xsl:attribute>
		<xsl:attribute name="outputSchema">http://www.isotc211.org/2005/gmd</xsl:attribute>
		<xsl:attribute name="resultType">results</xsl:attribute>
		<xsl:attribute name="startPosition">
			<xsl:value-of select="/GetRecords/StartPosition"/>
		</xsl:attribute>
		<xsl:attribute name="maxRecords">
			<xsl:value-of select="/GetRecords/MaxRecords"/>
		</xsl:attribute>
	</xsl:attribute-set>
</xsl:stylesheet>
