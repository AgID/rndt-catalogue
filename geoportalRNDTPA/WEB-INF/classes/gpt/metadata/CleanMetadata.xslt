<?xml version="1.0" encoding="utf-8"?>
<!-- *******************************
	CleanMetadata.xml
	Foglio di stile per piccole modifiche da fare ai metadati in fase di registrazione.
	Il metadato viene registrato con queste modifiche, 
	che quindi devono essere rilette correttamente dall'editor.
******************************* -->
<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xsi:schemaLocation=" http://www.isotc211.org/2005/gmd http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/gmd/gmd.xsd " 
xmlns:gmd="http://www.isotc211.org/2005/gmd" 
xmlns:gco="http://www.isotc211.org/2005/gco" 
xmlns:gml="http://www.opengis.net/gml/3.2" 
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
exclude-result-prefixes="xsl gmd gco"
>
	<xsl:output method="xml"/>

	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"  />
		</xsl:copy>
	</xsl:template>
	
	<!--  Mette il nilReason se il pass non è valorizzato -->
	<xsl:template match="gmd:pass">
		<xsl:choose>
			<xsl:when test="./gco:Boolean">
				<gmd:pass>
					<gco:Boolean>
						<xsl:value-of select="./gco:Boolean" />
					</gco:Boolean>
				</gmd:pass>
			</xsl:when>
			<xsl:otherwise>
				<gmd:pass gco:nilReason="unknown"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>
