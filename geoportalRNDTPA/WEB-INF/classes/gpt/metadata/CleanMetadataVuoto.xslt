<?xml version="1.0" encoding="utf-8"?>
<!-- Created with Liquid XML Studio Designer Edition 8.1.5.2538 (http://www.liquid-technologies.com) -->
<!-- Prologo XML -->
<xsl:stylesheet version="1.0" 
xmlns="http://www.isotc211.org/2005/gmd" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xsi:schemaLocation=" http://www.isotc211.org/2005/gmd http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/gmd/gmd.xsd" 
xmlns:gsr="http://www.isotc211.org/2005/gsr" 
xmlns:xlink="http://www.w3.org/1999/xlink" 
xmlns:gts="http://www.isotc211.org/2005/gts" 
xmlns:gmd="http://www.isotc211.org/2005/gmd" 
xmlns:gco="http://www.isotc211.org/2005/gco" 
xmlns:gml="http://www.opengis.net/gml/3.2" 
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
xmlns:gss="http://www.isotc211.org/2005/gss" 
xmlns:srv="http://www.isotc211.org/2005/srv"
xmlns:dcat="http://www.w3.org/ns/dcat#" 
xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
xmlns:gfc="http://www.isotc211.org/2005/gfc"
>
    <xsl:output method="xml" />
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
