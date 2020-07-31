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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:template match="/notification">
<html>
	<body>
		Questa mail è per informarti che il catalogo <xsl:value-of select="repositoryName"/> è stato interrogato e i metadati sono stati raccolti.<br/>
		<br/>
		Puoi vedere il risultato dalla Gestione del catalogo cliccando sull'icona Storico a fianco del catalogo.
		<br/>
        <xsl:if test="normalize-space(reportLink) != ''">
          Puoi anche vedere direttamente il risultato a questo link <a href="{reportLink}"><xsl:value-of select="reportLink"/></a><br/>
          <br/>
        </xsl:if>
		Grazie.
	</body>
</html>
</xsl:template>
</xsl:stylesheet>
