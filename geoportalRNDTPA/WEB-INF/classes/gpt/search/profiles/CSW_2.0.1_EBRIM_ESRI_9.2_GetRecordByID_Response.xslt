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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:csw="http://www.opengis.net/cat/csw"
                xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0"
                exclude-result-prefixes="csw rim">
  <xsl:output method="text" indent="no" encoding="UTF-8"/>

  <xsl:template match="/">
    <xsl:apply-templates select ="/csw:GetRecordByIdResponse/rim:Service|/csw:GetRecordByIdResponse/rim:ExtrinsicObject"/>
  </xsl:template>

  <!-- url to metadata XML -->
  <xsl:template match="/csw:GetRecordByIdResponse/rim:Service|/csw:GetRecordByIdResponse/rim:ExtrinsicObject">
    <xsl:value-of select="rim:Slot[@slotType='urn:x-esri:specification:ServiceType:ArcIMS:Metadata:Dataset:Url' and @name='http://purl.org/dc/terms/references']/rim:ValueList/rim:Value"/>
  </xsl:template>
</xsl:stylesheet>
