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
                xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
                xmlns:dct="http://purl.org/dc/terms/"
                xmlns:ows="http://www.opengis.net/ows"
                exclude-result-prefixes="csw dct">
  <xsl:output method="text" indent="no" encoding="UTF-8"/>
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
        <xsl:apply-templates select="//csw:Record/dct:references"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="//csw:Record/dct:references">
    <xsl:value-of select="."/>
     <xsl:text>&#x2714;</xsl:text>
     <xsl:value-of select="@scheme"/>
     <xsl:text>&#x2715;</xsl:text>
  </xsl:template>
</xsl:stylesheet>
