<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all"
    xmlns:tei="http://www.tei-c.org/ns/1.0" version="3.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    <xsl:strip-space elements="*"/>
    <xsl:output indent="yes" method="xml"/>
    <xsl:variable name="documents" select="collection('../zones?select=*.xml;recurse=yes')"/>
<!--    <xsl:variable name="edition" select="document('./texts/mss-dates-w.xml')"/>-->
    

    <xsl:template match="/">
        <xsl:for-each select="$documents">
<!--            <xsl:variable name="document" select="."/>-->
            <xsl:variable name="filename">
                <xsl:analyze-string select="document-uri(.)" regex="^(.*)/([^/]+)\.[^/]+$">
                    <xsl:matching-substring>
                        <xsl:value-of select="regex-group(2)"/>
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </xsl:variable>
            <xsl:variable name="result-filename" select="concat('zones-fix3/', $filename, '.xml')"/>
            <xsl:result-document href="{$result-filename}">
                <xsl:apply-templates select="./TEI"/>
            </xsl:result-document>
            <!-- <xsl:value-of select="$filename"/><xsl:text>     </xsl:text>
                <xsl:value-of select="$result-filename"/>
                <xsl:text>
</xsl:text>
 -->
        </xsl:for-each>
    </xsl:template>





    <xsl:template match="@* | node()" mode="#all">
        <xsl:choose>
            <xsl:when test="matches(name(.), '^(part|instant|anchored|default|full|status)$')"/>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()" mode="#current"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="zone[@type='column']">
       
        <xsl:variable name="x">
            <xsl:analyze-string select="@points" regex="\s?([0-9]+),">
                <xsl:matching-substring>
                    <ab xmlns="http://www.tei-c.org/ns/1.0" ><xsl:value-of select="regex-group(1)"/></ab>
                </xsl:matching-substring>
            </xsl:analyze-string>
        </xsl:variable>
        <xsl:variable name="y">
            <xsl:analyze-string select="@points" regex=",([0-9]+)\s?">
                <xsl:matching-substring>
                    <ab xmlns="http://www.tei-c.org/ns/1.0" ><xsl:value-of select="regex-group(1)"/></ab>
                </xsl:matching-substring>
            </xsl:analyze-string>
        </xsl:variable>
        
        
        <zone xmlns="http://www.tei-c.org/ns/1.0" type="column">
            <xsl:attribute name="xml:id" select="@xml:id"/>
            <xsl:attribute name="points" select="@points"/>
            <xsl:attribute name="ulx" select="min($x//ab)"></xsl:attribute>
            <xsl:attribute name="uly" select="min($y//ab)"></xsl:attribute>
            <xsl:attribute name="lrx" select="max($x//ab)"></xsl:attribute>
            <xsl:attribute name="lry" select="max($y//ab)"></xsl:attribute>
            
            <xsl:apply-templates/>
            
        </zone>
    </xsl:template>
    
    
 
</xsl:stylesheet>
