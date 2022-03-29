<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all"
    xmlns:tei="http://www.tei-c.org/ns/1.0" version="3.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    <xsl:strip-space elements="*"/>
    <xsl:output indent="yes" method="xml"/>
<!--    <xsl:variable name="documents" select="collection('zones-orig?select=*.xml;recurse=yes')"/>-->
    <xsl:variable name="edition" select="document('./texts/mss-dates-w.xml')"/>

    <xsl:template match="/">
        <xsl:apply-templates select="TEI/facsimile"/>
    </xsl:template>

    <xsl:template match="facsimile">
        <xsl:variable name="Tk-facs" select="."/>
        <xsl:variable name="imagefile" select="substring-before(surface/graphic/@url, '.tif')"/>
        <xsl:variable name="word-zones-file" select="document(concat('./zones-orig/mss-dates_surf_', $imagefile, '-zones.xml'))"/>
        <xsl:variable name="edition-p" select="$edition//TEI/text/body/p[pb/@facs=concat($imagefile, '.tif')]"/>

        <xsl:call-template name="genere-zones">
            <xsl:with-param name="imagefile" select="$imagefile"/>
            <xsl:with-param name="Tk-facs" select="$Tk-facs"/>
            <xsl:with-param name="word-zones-file" select="$word-zones-file"/>
            <xsl:with-param name="edition-p" select="$edition-p"/>
        </xsl:call-template>
        <xsl:call-template name="genere-links">
            <xsl:with-param name="imagefile" select="$imagefile"/>
            <xsl:with-param name="Tk-facs"/>
            <xsl:with-param name="edition-p" select="$edition-p"/>
        </xsl:call-template>
    </xsl:template>


    <xsl:template name="genere-zones">
        <xsl:param name="imagefile"/>
        <xsl:param name="Tk-facs"/>
        <xsl:param name="word-zones-file"/>
        <xsl:param name="edition-p"/>
        <xsl:variable name="result-filename"
            select="concat('zones-fix/mss-dates_surf_', $imagefile, '-zones.xml')"/>

        <xsl:result-document href="{$result-filename}">
            <TEI xmlns="http://www.tei-c.org/ns/1.0">
                <teiHeader>
                    <fileDesc>
                        <titleStmt>
                            <title>Image zones for alignements_mss_</title>
                        </titleStmt>
                        <publicationStmt>
                            <p>Oriflamms project</p>
                        </publicationStmt>
                        <sourceDesc>
                            <p>Initially converted from A2iA image segmentation data</p>
                            <p>Manually corrected by Dominique Stutzmann</p>
                            <p>Line zones not correctly handled by the Oriflamms.exe software and redrawn with Transkribus in 2022</p>
                        </sourceDesc>
                    </fileDesc>
                    </teiHeader>
                <facsimile xml:base="img/">
                    <surface>
                        <xsl:attribute name="xml:id" select="concat('surf_', $imagefile)"></xsl:attribute>
                        <graphic>
                            <xsl:attribute name="url" select="concat($imagefile, '.tif')"></xsl:attribute>
                        </graphic>
                        <zone>
                            <xsl:attribute name="xml:id" select="concat('zone-page_', $imagefile)"/>
                            <xsl:attribute name="ulx" select="'0'"/>
                            <xsl:attribute name="uly" select="'0'"/>
                            <xsl:attribute name="lrx" select="$Tk-facs/surface/@lrx"/>
                            <xsl:attribute name="lry" select="$Tk-facs/surface/@lry"/>
                            <xsl:apply-templates select="$Tk-facs/surface/zone[@rendition='TextRegion']" mode="TextRegion">
                                <xsl:with-param name="imagefile" select="$imagefile"/>
                                <xsl:with-param name="word-zones-file" select="$word-zones-file"></xsl:with-param>
                                <xsl:with-param name="edition-p" select="$edition-p"></xsl:with-param>
                            </xsl:apply-templates>
                       </zone>
                    </surface>
                </facsimile>
            </TEI>
        </xsl:result-document>
    </xsl:template>

<xsl:template name="genere-links">
    <xsl:param name="imagefile"/>
    <xsl:param name="Tk-facs"/>
    <xsl:param name="edition-p"/>
    
    
    <xsl:variable name="result-filename"
        select="concat('img_links-fix/mss-dates_surf_', $imagefile, '-links.xml')"/>
    
    <xsl:result-document href="{$result-filename}">
        <TEI xmlns="http://www.tei-c.org/ns/1.0">
        <teiHeader>
            <fileDesc>
                <titleStmt>
                    <title>Linking data for document transcriptions and image zones (alignements_mss)</title>
                </titleStmt>
                <publicationStmt>
                    <p>Oriflamms project ((http://oriflamms.hypotheses.org))</p>
                </publicationStmt>
                <sourceDesc>
                    <p>Converted from Oriflamms XML-TEI transcription file</p>
                </sourceDesc>
            </fileDesc>
            <encodingDesc>
                <listPrefixDef>
                    <prefixDef ident="txt" matchPattern="([a-z]+)" replacementPattern="../texts/mss-dates-c.xml.xml#$1"/>
                    <prefixDef ident="img" matchPattern="([a-z]+)" replacementPattern="../zones/-zones.xml#$1"/>
                </listPrefixDef>
            </encodingDesc>
            <revisionDesc>
                <change when="2015-12-02">File created</change>
                <change when="2022-03-09">File regenerated</change>
            </revisionDesc>
        </teiHeader>
        <text>
            <body>
                <ab type="linking">
                    <linkGrp type="surfaces">
                        <link>
                            <xsl:attribute name="target" select="concat('txt:surf_', $imagefile, ' img:zone-surf_', $imagefile)"/>
                        </link>
                    </linkGrp>
                    <linkGrp type="pages">
                        <link>
                            <xsl:attribute name="target" select="concat('txt:page_', $imagefile, ' img:zone-page_', $imagefile)"/>
                        </link>
                    </linkGrp>
                    <linkGrp type="columns">
                        <xsl:apply-templates select="$edition-p//cb" mode="link"/>
                    </linkGrp>
                    <linkGrp type="lines">
                        <xsl:apply-templates select="$edition-p//lb" mode="link"/>
                    </linkGrp>
                    <linkGrp type="words">
                        <xsl:apply-templates select="$edition-p//w[not(ancestor-or-self::*[@ana='ori:align-no'])]" mode="link"/>
                    </linkGrp>
                </ab>
            </body>
        </text>
        </TEI>
    </xsl:result-document>
    
</xsl:template>

<xsl:template match="zone" mode="TextRegion">
    <xsl:param name="imagefile"/>
    <xsl:param name="edition-p"/>
    <xsl:param name="word-zones-file"/>
    <xsl:variable name="numcolonne" select="count(preceding-sibling::zone[@rendition='TextRegion']) + 1"/>
    <zone xmlns="http://www.tei-c.org/ns/1.0" type="column">
        <xsl:attribute name="xml:id" select="concat('zone-col_', $imagefile, '_', $numcolonne)"/>
        <xsl:attribute name="points" select="@points"/>
        
        <xsl:apply-templates select="zone[@rendition='Line']" mode="Line">
            <xsl:with-param name="imagefile" select="$imagefile"/>
            <xsl:with-param name="numcolonne" select="$numcolonne"/>
            <xsl:with-param name="edition-p" select="$edition-p"/>
            <xsl:with-param name="word-zones-file" select="$word-zones-file"/>
        </xsl:apply-templates>
    </zone> 
    
</xsl:template>
    
<xsl:template match="zone" mode="Line">
    <xsl:param name="imagefile"/>
    <xsl:param name="numcolonne"/>
    <xsl:param name="edition-p"/>
    <xsl:param name="word-zones-file"/>
    
    <xsl:variable name="numligne" select="count(preceding-sibling::zone[@rendition='Line']) + 1"/>
    <xsl:variable name="matching-line-id" select="concat('line_', $imagefile, '_', $numcolonne, '-', $numligne)"/>
   
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
    
   
    <zone xmlns="http://www.tei-c.org/ns/1.0" type="line">
        <xsl:attribute name="xml:id" select="concat('zone-', $matching-line-id)"/>
        <xsl:attribute name="points" select="@points"/>
        <xsl:attribute name="ulx" select="min($x//ab)"></xsl:attribute>
        <xsl:attribute name="uly" select="min($y//ab)"></xsl:attribute>
        <xsl:attribute name="lrx" select="max($x//ab)"></xsl:attribute>
        <xsl:attribute name="lry" select="max($y//ab)"></xsl:attribute>
        <xsl:apply-templates select="$edition-p//w[preceding::lb[1][@xml:id = $matching-line-id]][not(ancestor-or-self::*[@ana='ori:align-no'])]" 
                            mode="Word">
            <xsl:with-param name="imagefile" select="$imagefile"/>
            <xsl:with-param name="word-zones-file" select="$word-zones-file"/>
        </xsl:apply-templates>
    </zone>
    
    
</xsl:template>    
    
    <xsl:template match="w" mode="Word">
     <xsl:param name="imagefile"/>
     <xsl:param name="word-zones-file"/>
     <xsl:variable name="wordzone-id" select="concat('zone-word_', @xml:id)"/> 
        <!--txt:w_mss-dates_12367 img:zone-w_mss-dates_12367-->
        <!--                zone-word_  -->
     <xsl:variable name="wordzone-id-short" select="concat('zone-', @xml:id)"/>
     <zone xmlns="http://www.tei-c.org/ns/1.0">
         <xsl:for-each select="$word-zones-file//zone[@xml:id=$wordzone-id]/@*">
             <xsl:attribute name="{name()}" select="."></xsl:attribute>
         </xsl:for-each>
         <xsl:attribute name="xml:id" select="$wordzone-id-short"></xsl:attribute>
         
     </zone>
 </xsl:template>
 
    <xsl:template match="cb|lb|w" mode="link">
        <link xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="target" select="concat('txt:', @xml:id, ' img:zone-', @xml:id)"/>
        </link>
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
