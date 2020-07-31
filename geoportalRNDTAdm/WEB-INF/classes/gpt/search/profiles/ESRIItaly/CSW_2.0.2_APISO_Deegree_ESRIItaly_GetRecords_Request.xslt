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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.opengis.net/cat/csw/2.0.2" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:ogc="http://www.opengis.net/ogc" xmlns:dct="http://purl.org/dc/terms/" xmlns:ows="http://www.opengis.net/ows" xmlns:gml="http://www.opengis.net/gml" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <xsl:output method="xml" indent="no" encoding="UTF-8" omit-xml-declaration="yes"/>
    <xsl:variable name="keyword" select="/GetRecords/KeyWord"/>
    <xsl:variable name="minX" select="/GetRecords/Envelope/MinX"/>
    <xsl:variable name="small" select="'abcdefghijklmnopqrstuvwxyz'" />
  <xsl:variable name="caps" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
    <xsl:template match="/">
    
        <xsl:element name="csw:GetRecords" use-attribute-sets="GetRecordsAttributes" xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" xmlns:ogc="http://www.opengis.net/ogc" xmlns:dc="http://www.purl.org/dc/elements/1.1/" xmlns:gml="http://www.opengis.net/gml" xmlns:apiso="http://www.opengis.net/cat/csw/apiso/1.0">
            <csw:Query  typeNames="gmd:MD_Metadata">
                <csw:ElementSetName typeNames="gmd:MD_Metadata">full</csw:ElementSetName>
                <xsl:if test="normalize-space($keyword)!='' or normalize-space($minX) != ''" >
                  <csw:Constraint version="1.1.0">
                    <ogc:Filter>
                        <xsl:choose>
                       <xsl:when test="normalize-space($keyword)!='' and normalize-space($minX) != ''" >
                        <ogc:And>
                            <!-- Key Word search -->
                            <xsl:apply-templates select="/GetRecords/KeyWord"/>
                           
                            <!-- LiveDataOrMaps search -->
<!--
                            <xsl:apply-templates select="/GetRecords/LiveDataMap"/>
-->
                            <!-- Envelope search, e.g. ogc:BBOX -->
                            <xsl:apply-templates select="/GetRecords/Envelope"/>
                        </ogc:And>
                       </xsl:when>
                        <xsl:when test="normalize-space($keyword)!='' or normalize-space($minX) != ''" >
                             <!-- Key Word search -->
                            <xsl:apply-templates select="/GetRecords/KeyWord"/>
                           
                            <!-- LiveDataOrMaps search -->
<!--
                            <xsl:apply-templates select="/GetRecords/LiveDataMap"/>
-->
                            <!-- Envelope search, e.g. ogc:BBOX -->
                            <xsl:apply-templates select="/GetRecords/Envelope"/>
                          </xsl:when>
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
            <ogc:PropertyIsLike wildCard="%" escapeChar="_" singleChar="\">
                <xsl:choose>
                    <xsl:when test="starts-with(translate(normalize-space(.),$caps,$small), 'title:')">
                        <ogc:PropertyName>Title</ogc:PropertyName>
                        <ogc:Literal>%<xsl:value-of select="substring-after(.,'title:')"/>%</ogc:Literal>
                    </xsl:when>
                    <xsl:when test="starts-with(translate(normalize-space(.),$caps,$small), 'abstract:')">
                        <ogc:PropertyName>Abstract</ogc:PropertyName>
                        <ogc:Literal>%<xsl:value-of select="substring-after(.,'abstract:')"/>%</ogc:Literal>
                    </xsl:when>
                    <xsl:otherwise>
                        <ogc:PropertyName>AnyText</ogc:PropertyName>
                        <ogc:Literal>%<xsl:value-of select="."/>%</ogc:Literal>
                    </xsl:otherwise>
				</xsl:choose>
            </ogc:PropertyIsLike>
        </xsl:if>
    </xsl:template>

    <!-- LiveDataOrMaps search -->
    <xsl:template match="/GetRecords/LiveDataMap" xmlns:ogc="http://www.opengis.net/ogc">
        <xsl:if test=".='True'">
            <ogc:PropertyIsEqualTo>
                <ogc:PropertyName>Format</ogc:PropertyName>
                <ogc:Literal>liveData</ogc:Literal>
            </ogc:PropertyIsEqualTo>
        </xsl:if>
    </xsl:template>

    <!-- envelope search -->
    <xsl:template match="/GetRecords/Envelope" xmlns:ogc="http://www.opengis.net/ogc">
        <!-- generate BBOX query if minx, miny, maxx, maxy are provided -->
        <xsl:if test="./MinX and ./MinY and ./MaxX and ./MaxY">
            <ogc:BBOX xmlns:gml="http://www.opengis.net/gml">
                <ogc:PropertyName>ows:BoundingBox</ogc:PropertyName><gml:Envelope><gml:lowerCorner><xsl:value-of select="MinX"/><xsl:text> </xsl:text><xsl:value-of select="MinY"/></gml:lowerCorner><gml:upperCorner><xsl:value-of select="MaxX"/><xsl:text> </xsl:text><xsl:value-of select="MaxY"/></gml:upperCorner></gml:Envelope>
            </ogc:BBOX>
        </xsl:if>
    </xsl:template>

    <!--
    <xsl:attribute-set name="GetRecordsAttributes">
		<xsl:attribute name="version">2.0.1</xsl:attribute>
		<xsl:attribute name="service">CSW</xsl:attribute>
		<xsl:attribute name="resultType">results</xsl:attribute>
		<xsl:attribute name="startPosition"><xsl:value-of select="/GetRecords/StartPosition"/></xsl:attribute>
		<xsl:attribute name="maxRecords"><xsl:value-of select="/GetRecords/MaxRecords"/></xsl:attribute>
		<xsl:attribute name="outputSchema">csw:Record</xsl:attribute>
	</xsl:attribute-set>
    -->
    <xsl:attribute-set name="GetRecordsAttributes">
		<xsl:attribute name="outputSchema">http://www.isotc211.org/2005/gmd</xsl:attribute>
        <xsl:attribute name="version">2.0.2</xsl:attribute>
        <xsl:attribute name="service">CSW</xsl:attribute>
        <xsl:attribute name="resultType">results</xsl:attribute>
        <xsl:attribute name="startPosition">
            <xsl:value-of select="/GetRecords/StartPosition"/>
        </xsl:attribute>
        <xsl:attribute name="maxRecords">
            <xsl:value-of select="/GetRecords/MaxRecords"/>
        </xsl:attribute>
    </xsl:attribute-set>
</xsl:stylesheet>