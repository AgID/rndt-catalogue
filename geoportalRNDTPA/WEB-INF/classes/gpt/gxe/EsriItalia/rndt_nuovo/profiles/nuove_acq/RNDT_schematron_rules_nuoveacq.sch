<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	queryBinding="xslt2">

	<sch:title xmlns="http://www.w3.org/2001/XMLSchema">Schematron per profilo RNDT Nuove Acquisizioni</sch:title>
	<sch:ns prefix="gml" uri="http://www.opengis.net/gml"/>
	<sch:ns prefix="gmd" uri="http://www.isotc211.org/2005/gmd"/>
	<sch:ns prefix="gco" uri="http://www.isotc211.org/2005/gco"/>
	<sch:ns prefix="xlink" uri="http://www.w3.org/1999/xlink"/>

	<!-- ############################################ -->
	<!-- Identification                               -->
	<!-- ############################################ -->
	<sch:pattern >
		<sch:title>Testing 'Identification' elements</sch:title>
		<sch:rule context="//gmd:identificationInfo[1]/*/gmd:citation/*">
			<sch:let name="resourceTitle" value="gmd:title/*/text()"/>

			<!-- assertions and report -->
			<sch:assert test="$resourceTitle">L'elemento "Titolo" non e' presente</sch:assert>
			<sch:report test="$resourceTitle">Titolo: <sch:value-of select="$resourceTitle"/>
			</sch:report>
		</sch:rule>

	</sch:pattern>
</sch:schema>
