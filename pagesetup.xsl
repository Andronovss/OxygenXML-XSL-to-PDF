<?xml version="1.0"?> 
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  version="1.0">
  
  <!-- Формируем верхний колонтитул -->
  <xsl:template name="header.content">
    <xsl:variable name="titleabbrev" select="(//book/title)[1]"/>
    
    <fo:block-container absolute-position="fixed" top="0.9cm" left="0.50cm" right="0cm">
      <fo:block text-align="left" margin-top="0.45cm">
        <fo:external-graphic src="url('../styles/images/logo.png')" width="15%" height="auto" 
          content-width="30%" content-height="scale-to-fit"/>
      </fo:block>
      
      <fo:block text-align="right" margin-top="-1.2cm" margin-right="2.5cm" font-size="8pt"
        font-family="{$title.fontset}">
        <xsl:value-of select="$titleabbrev"/>
      </fo:block>
      
    </fo:block-container>
  </xsl:template>

  <!-- Формируем нижний колонтитул -->
  <xsl:attribute-set name="footer.content.properties">
    <xsl:attribute name="font-size">8pt</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="margin-bottom">-1cm</xsl:attribute>
  </xsl:attribute-set>
  
  <xsl:template name="footer.content">
    <xsl:param name="pageclass" select="''"/>
    <xsl:param name="sequence" select="''"/>
    <xsl:param name="position" select="''"/>
    <xsl:param name="gentext-key" select="''"/>
    
    <fo:block margin-left="-0.5cm" margin-bottom="1.1cm">
      <xsl:choose>
        <xsl:when test="$pageclass = 'titlepage'">
        </xsl:when>
        <!-- Не титульная страница -->
        <xsl:otherwise>       
          <xsl:choose>
            <xsl:when test="$double.sided = 0">
              <!-- Одностраничный документ -->
              <xsl:choose>
                <xsl:when test="$position = 'left'">
                  <fo:page-number/>
                </xsl:when>
              </xsl:choose>
            </xsl:when>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </fo:block>
  </xsl:template>
</xsl:stylesheet>