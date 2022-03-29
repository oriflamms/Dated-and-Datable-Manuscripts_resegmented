<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.loc.gov/standards/alto/ns-v4#"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- Removals -->
    <xsl:template match="tei:note"/>
    <xsl:template match="tei:bibl"/>
    <xsl:template match="tei:supplied"/>
    
    <!-- Normalisations -->
    <xsl:template match="text()">
        <xsl:value-of select='translate(lower-case(normalize-unicode(translate(., "δꝛſ", "drs"), "nfkd")),
            "&apos;’",
            ""
            )'/>
    </xsl:template>
    
    <!-- TODO -->
    <!-- quid de del? -->
    
    
</xsl:stylesheet>