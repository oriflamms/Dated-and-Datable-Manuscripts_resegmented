<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.loc.gov/standards/alto/ns-v4#"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:include href="common.xsl"/>
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    <xsl:strip-space elements="*"/>
    <xsl:variable name="documents" select="collection('../zones?select=*.xml;recurse=yes')"/>
    <xsl:param name="expansion" select="false()"/>
    
    <xsl:template match="/">
        <xsl:for-each select="$documents">
            <xsl:variable name="filename">
                <xsl:analyze-string select="document-uri(.)" regex="^(.*)/([^/]+)\.[^/]+$">
                    <xsl:matching-substring>
                        <xsl:value-of select="regex-group(2)"/>
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </xsl:variable>
            
            <xsl:variable name="result-filename">
                <xsl:choose>
                    <xsl:when test="$expansion">
                        <xsl:value-of select="concat('alto_expan/without-norm/lat-expan_', $filename, '.xml_alto.xml')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat('alto_abbr/without-norm/lat-abbr_', $filename, '.xml_alto.xml')"/>
                    </xsl:otherwise>
                </xsl:choose>
                
                
            </xsl:variable> 
                
            <xsl:result-document href="{$result-filename}">
                
        <xsl:apply-templates select="tei:TEI/tei:facsimile/tei:surface">
            <xsl:with-param name="result-filename"/>
        </xsl:apply-templates>
            </xsl:result-document>
        </xsl:for-each>
        
    </xsl:template>
    
    <xsl:variable name="myTexts" select="document('../texts/mss-dates-w.xml')"/>
    
    
    <xsl:template match="tei:surface">
        <xsl:param name="result-filename"/>
        
        
            
        <alto xmlns="http://www.loc.gov/standards/alto/ns-v4#"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.loc.gov/standards/alto/ns-v4# ../schema/alto.xsd">
            <Description>
                <MeasurementUnit>pixel</MeasurementUnit>
                <sourceImageInformation>
                    <fileName><xsl:value-of select="tei:graphic/@url"/></fileName>
                </sourceImageInformation>
            </Description>
            <Layout>
                <xsl:apply-templates/>
            </Layout>
            
        </alto>
    </xsl:template>
    
    <xsl:template match="tei:zone[@type='page']">
        <Page ID="{@xml:id}" PHYSICAL_IMG_NR="0" WIDTH="{@lrx}" HEIGHT="{@lry}">
            <PrintSpace HPOS="0"
                VPOS="0"
                WIDTH="{@lrx}"
                HEIGHT="{@lry}">
                <xsl:apply-templates/>
            </PrintSpace>
        </Page>
        
    </xsl:template>
    
    <xsl:template match="tei:zone[@type='column']">
        <TextBlock 
            HPOS="{@ulx}"
            VPOS="{@uly}"
            WIDTH="{@lrx - @ulx}"
            HEIGHT="{@lry - @uly}"
            ID="{@xml:id}">
            <!--Automatically create coordinates for the rectangle, Kraken needs it.-->
            <!-- <Shape><Polygon POINTS="230,520 230,4395 1462,4395 1462,520"/></Shape> -->
            <Shape>
                <xsl:element name="Polygon">
                    <xsl:attribute name="POINTS">
                        <xsl:value-of select="@ulx"/>
                        <xsl:text>,</xsl:text>
                        <xsl:value-of select="@uly"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="@lrx"/>
                        <xsl:text>,</xsl:text>
                        <xsl:value-of select="@uly"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="@lrx"/>
                        <xsl:text>,</xsl:text>
                        <xsl:value-of select="@lry"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="@ulx"/>
                        <xsl:text>,</xsl:text>
                        <xsl:value-of select="@lry"/>
                    </xsl:attribute>
                </xsl:element>
             </Shape>
            <xsl:apply-templates/>
        </TextBlock>
    </xsl:template>
    
    
    <xsl:template match="tei:zone[@type='line']">
        <xsl:variable name="myId" select="substring-after(@xml:id, 'zone-')"/>
        <xsl:variable name="myContent">
            <xsl:apply-templates select="$myTexts/descendant::tei:w[preceding::tei:lb[1]/@xml:id = $myId]"/>
        </xsl:variable>
        <TextLine ID="{@xml:id}"
            BASELINE="" 
            HPOS="{@ulx}"
            VPOS="{@uly}"
            WIDTH="{@lrx - @ulx}"
            HEIGHT="{@lry - @uly}">
            <!--<Shape><Polygon POINTS=""/></Shape>-->
            <Shape>
                <xsl:element name="Polygon">
                    <xsl:attribute name="POINTS">
                        <xsl:value-of select="@ulx"/>
                        <xsl:text>,</xsl:text>
                        <xsl:value-of select="@uly"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="@lrx"/>
                        <xsl:text>,</xsl:text>
                        <xsl:value-of select="@uly"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="@lrx"/>
                        <xsl:text>,</xsl:text>
                        <xsl:value-of select="@lry"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="@ulx"/>
                        <xsl:text>,</xsl:text>
                        <xsl:value-of select="@lry"/>
                    </xsl:attribute>
                </xsl:element>
            </Shape>
            <String CONTENT="{normalize-space($myContent)}"
                HPOS="{@ulx}"
                VPOS="{@uly}"
                WIDTH="{@lrx - @ulx}"
                HEIGHT="{@lry - @uly}"
                ></String>
        </TextLine>
        
    </xsl:template>
    
    <xsl:template match="tei:w">
        <xsl:apply-templates/>
        <xsl:text> </xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:choice">
        <xsl:choose>
            <xsl:when test="$expansion">
                <xsl:apply-templates select="tei:sic | tei:expan"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="tei:sic | tei:abbr"/>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>


</xsl:stylesheet>
