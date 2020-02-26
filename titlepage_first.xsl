<?xml version="1.0"?> 
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:date="http://exslt.org/dates-and-times"
  xmlns:rtf="http://www.cambridgedocs.com/namespace/fo/rtf"
  xmlns:saxon="http://saxon.sf.net/"
  version='1.0'>
    
    <!-- Задаем параметры титульной тсраницы -->
  <xsl:template name="book.titlepage.recto">
       
    <!-- Лого для титула -->
    <fo:block 
      absolute-position="fixed" 
      top="0.9cm" 
      left="2.6cm" 
      right="0cm">
      <fo:external-graphic 
        src="url('../styles/images/title.png')" 
        width="15%" 
        height="auto" 
        content-width="30%" 
        content-height="scale-to-fit"/>
    </fo:block> 
    
    <!-- Рамка на титуле слева-->
    <fo:block-container 
      reference-orientation="90"
      absolute-position="fixed"
      bottom="0mm" 
      top="0mm" 
      left="0mm">
      <fo:block>
        <fo:table 
          table-layout="fixed" 
          border-style="none">
          <fo:table-column 
            background-color="#4900db"/>
          <fo:table-body>
            <fo:table-row>
              <fo:table-cell 
                width="297mm" 
                height="13mm">
                <fo:block></fo:block>
              </fo:table-cell>
             </fo:table-row>
          </fo:table-body>
        </fo:table>
      </fo:block>
    </fo:block-container>
    
    <!-- Рамка на титуле справа-->
    <fo:block-container 
      reference-orientation="-90"
      absolute-position="fixed"
      bottom="0mm"
      right="0mm" 
      top="0mm">
      <fo:block>
        <fo:table 
          table-layout="fixed" 
          border-style="none">
          <fo:table-column 
            background-color="#4900db"/>
          <fo:table-body>
            <fo:table-row>
              <fo:table-cell 
                width="297mm" 
                height="13mm">
                <fo:block></fo:block>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-body>
        </fo:table>
      </fo:block>
    </fo:block-container>
    
    <!-- Рамка на титуле сверху-->
    <fo:block-container 
      reference-orientation="270"
      absolute-position="fixed"
      top="0mm"
      left="13mm" 
      right="13mm">
      <fo:block>
        <fo:table 
          table-layout="fixed" 
          border-style="none">
          <fo:table-column 
            background-color="#4900db"/>
          <fo:table-body>
            <fo:table-row>
              <fo:table-cell 
                width="13mm" 
                height="271mm">
                <fo:block></fo:block>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-body>
        </fo:table>
      </fo:block>
    </fo:block-container>
    
    <!-- Рамка на титуле снизу-->
    <fo:block-container 
      reference-orientation="-270"
      absolute-position="fixed" 
      bottom="0"
      left="13mm" 
      right="13">
      <fo:block>
        <fo:table 
          table-layout="fixed" 
          border-style="none">
          <fo:table-column 
            background-color="#4900db"/>
          <fo:table-body>
            <fo:table-row>
              <fo:table-cell 
                width="13mm" 
                height="271mm">
                <fo:block></fo:block>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-body>
        </fo:table>
      </fo:block>
    </fo:block-container>
    
    <!-- Заголовок -->
    <fo:block 
      space-before="5cm" 
      left="2.6cm" 
      text-align="left" 
      hyphenate="false" 
      font-family="{$title.fontset}"
      font-size="30pt" 
      font-weight="bold" 
      color="#000000" 
      line-height="30pt">
      <xsl:apply-templates select="//book/title/node()"/>
    </fo:block>
    
    <!-- Коммент -->
    <fo:block 
      space-before="2cm" 
      text-align="left" 
      left="2.6"
      hyphenate="false" 
      font-family="{$title.fontset}"
      font-size="9pt" 
      line-height="18pt">
      <xsl:apply-templates select="//bookinfo/comment/node()"/>
    </fo:block> 
        
    <!--  Название компании и год публикации -->
    <fo:block-container 
      absolute-position="fixed" 
      top="12cm"
      left="2.6cm">
      <fo:block 
        hyphenate="false" 
        text-align="left" 
        font-family="{$title.fontset}" 
        font-size="18pt"
        font-weight="normal" 
        text-transform="uppercase" 
        line-height="30pt">
        
        <!-- Год -->
        <xsl:value-of select="//bookinfo/pubdate"/>
        
        <!-- Разделитель -->
        <xsl:value-of select="' '"/>
        
        <!-- Компания -->
        <xsl:value-of select="//bookinfo/corpauthor/node()"/>
      </fo:block>
    </fo:block-container>
    
    <!-- Через "releaseinfo" задаем фразу "Дата составления отчета:" 
    (костыль) -->
    <fo:block 
      space-before="7cm" 
      text-align="left" 
      left="2.6"
      hyphenate="false" 
      font-family="{$title.fontset}"
      font-size="9pt" 
      line-height="18pt">
      <xsl:apply-templates select="//bookinfo/releaseinfo/node()"/>
    </fo:block> 
    
    <!--  Задаем дату формирования отчета -->
    <fo:block 
      left="2.6cm" 
      hyphenate="false" 
      text-align="left"
      font-family="{$title.fontset}" 
      font-size="9pt"
      font-weight="normal" 
      line-height="18pt">
      
      <xsl:call-template name="datetime.format">
        <xsl:with-param 
          name="date" 
          select="date:date-time()"/>
        <xsl:with-param 
          name="format" 
          select="'Y-m-d H:M'"/>
      </xsl:call-template>
    </fo:block>
  </xsl:template>
   
  <xsl:template name="book.titlepage.verso" />
  <xsl:template name="book.titlepage.before.verso" />
</xsl:stylesheet>
