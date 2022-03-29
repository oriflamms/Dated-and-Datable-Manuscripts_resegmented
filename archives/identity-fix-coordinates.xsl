<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all"
    xmlns:tei="http://www.tei-c.org/ns/1.0" version="3.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    <xsl:strip-space elements="*"/>
    <xsl:output indent="no" method="text"/>
    <xsl:variable name="documents" select="collection('zones?select=*.xml;recurse=yes')"/>
    <xsl:variable name="edition" select="document('./texts/mss-dates-w.xml')"/>
    
<xsl:template match="/">
    <xsl:apply-templates select="TEI/facsimile"/>
</xsl:template>
    
    <xsl:template match="facsimile">
        <xsl:variable name="image-filename" select="surface/graphic/@url"/>
        <xsl:variable name="Tk-n" select="@xml:id"/>
        <xsl:variable name="Tk-TextRegion" select="count(surface/zone[@rendition='TextRegion'])"/>
        <xsl:variable name="Tk-Line" select="count(surface//zone[@rendition='Line'])"/>
        <xsl:variable name="ed-text" select="$edition//TEI/text/body/p[pb/@facs=$image-filename]"/>
        <xsl:variable name="ed-n" select="$ed-text/milestone[@unit='surface']/@n"/>
        <xsl:variable name="ed-cb" select="count($ed-text//cb)"/>
        <xsl:variable name="ed-lb" select="count($ed-text//lb)"/>
        
        <xsl:value-of select="$image-filename"/>
        <xsl:text>&#x09;</xsl:text>
        <xsl:value-of select="$Tk-n"/>
        <xsl:text>&#x09;</xsl:text>
        <xsl:value-of select="$Tk-TextRegion"/>
        <xsl:text>&#x09;</xsl:text>
        <xsl:value-of select="$Tk-Line"/>
        <xsl:text>&#x09;</xsl:text>
        <xsl:value-of select="$ed-n"/>
        <xsl:text>&#x09;</xsl:text>
        <xsl:value-of select="$ed-cb"/>
        <xsl:text>&#x09;</xsl:text>
        <xsl:value-of select="$ed-lb"/>
        <xsl:text>&#x09;</xsl:text>
        <xsl:value-of select="concat($Tk-TextRegion - $ed-cb, '_', $Tk-Line - $ed-lb)"/>
        <xsl:text>&#x0A;</xsl:text>
        
    </xsl:template>

 <!--   <xsl:template match="/">
        <xsl:for-each select="$documents">
            <xsl:variable name="document" select="."/>
            <xsl:variable name="filename">
                <xsl:analyze-string select="document-uri(.)" regex="^(.*)/([^/]+)\.[^/]+$">
                    <xsl:matching-substring>
                        <xsl:value-of select="regex-group(2)"/>
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </xsl:variable>
            <xsl:variable name="result-filename" select="concat('zones-fix/', $filename, '.xml')"/>
            <xsl:result-document href="{$result-filename}">
                <xsl:apply-templates select="$document/TEI"/>
            </xsl:result-document>
            <!-\- <xsl:value-of select="$filename"/><xsl:text>     </xsl:text>
                <xsl:value-of select="$result-filename"/>
                <xsl:text>
</xsl:text>
 -\->
        </xsl:for-each>
    </xsl:template>

-->
 <!--   <xsl:template match="@* | node()" mode="#all">
        <xsl:choose>
            <xsl:when test="matches(name(.), '^(part|instant|anchored|default|full|status)$')"/>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()" mode="#current"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
-->
 <!--   <xsl:template match="revisionDesc">
        <xsl:copy>
            <xsl:apply-templates/>
            <xsl:element name="change" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="when" select="current-date()"/>
                <xsl:text>Fix @ulx, @lrx, @uly, @lry for zones[@type="page|colum|line"]</xsl:text>
            </xsl:element>
        </xsl:copy>
    </xsl:template>
-->
   <!-- <xsl:template match="zone">
        <xsl:choose>
            <xsl:when test="@type = 'page'">
                <xsl:copy>
                    <xsl:apply-templates select="@ulx | @uly | @type | @xml:id | @points"/>
                    <xsl:attribute name="lrx">
                        <xsl:value-of select="2 * @lrx"/>
                    </xsl:attribute>
                    <xsl:attribute name="lry">
                        <xsl:value-of select="2 * @lry"/>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:copy>
            </xsl:when>
            <xsl:when test="@type = 'column' or @type = 'line'">
          <xsl:choose>
              <xsl:when test="@type='line' and contains(@xml:id, '+')"/>
          <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@type | @xml:id | @points"/>
                    <xsl:variable name="min-ulx" select="min(.//zone[@type = 'word']/@ulx)"/>
                    <xsl:variable name="min-uly" select="min(.//zone[@type = 'word']/@uly)"/>
                    <xsl:variable name="max-lrx" select="max(.//zone[@type = 'word']/@lrx)"/>
                    <xsl:variable name="max-lry" select="max(.//zone[@type = 'word']/@lry)"/>
                    <xsl:attribute name="ulx" select="$min-ulx"/>
                    <xsl:attribute name="uly" select="$min-uly"/>
                    <xsl:attribute name="lrx" select="$max-lrx"/>
                    <xsl:attribute name="lry" select="$max-lry"/>

                    <xsl:apply-templates/>
                </xsl:copy>
              </xsl:otherwise>
          </xsl:choose>
            </xsl:when>
            <xsl:when test="@type = 'word'">
                <xsl:copy>
                    <xsl:apply-templates select="@*|node()"/>
                    </xsl:copy>
            </xsl:when>
            <xsl:when test="@type = 'character'">
                <xsl:choose>
                    <xsl:when test="contains(@xml:id,'+')"/>
                        
                    <xsl:otherwise>
                        <xsl:copy-of select="."/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
                
        </xsl:choose>
    </xsl:template>
-->
</xsl:stylesheet>
