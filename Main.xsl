<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:date="http://exslt.org/dates-and-times"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:rtf="http://www.cambridgedocs.com/namespace/fo/rtf"
    xmlns:saxon="http://saxon.sf.net/"
    xmlns:stext="http://nwalsh.com/xslt/ext/com.nwalsh.saxon.TextFactory"
    xmlns:xtext="com.nwalsh.xalan.Text" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    xmlns="http://docbook.org/ns/docbook"
    xmlns:lxslt="http://xml.apache.org/xslt"
    extension-element-prefixes="stext xtext"
    version="1.0">
 
    <!-- Импорт оригинального стиля -->
    <xsl:import href="./docbook-xsl-1.79.1/fo/profile-docbook.xsl"/>
    
    <!-- Поддержка подсветки синтаксиса -->
    <xsl:import  href="./docbook-xsl-1.79.1/fo/highlight.xsl"/>
    <xsl:param name="highlight.source" select="1"/>
    
    <xsl:template name="article.titlepage.verso"/>
    <xsl:template name="article.titlepage.before.verso"/>
    
    <xsl:template match="graphic">
        <xsl:choose>
            <xsl:when test="parent::inlineequation">
                <xsl:call-template name="process.image"/>
            </xsl:when>
            <xsl:otherwise>
                <fo:block>
                    
                    <xsl:attribute name="text-align">
                        <xsl:choose>
                            <xsl:when test="@align != ''">
                                <xsl:value-of select="@align"/>
                            </xsl:when>
                            <xsl:otherwise>left</xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    
                    <xsl:call-template name="process.image"/>
                </fo:block>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    
    <!-- Формируем верхний колонтитул -->
    <xsl:template name="header.content">
        <xsl:variable name="titleabbrev" select="(//article/articleinfo/copyright)[1]"/>
        
        <fo:block-container absolute-position="fixed" top="0.9cm" left="0.50cm" right="0cm">
            <fo:block text-align="left" margin-top="0.45cm">
                <fo:external-graphic src="/HabrahabrArticle/logo.png" width="15%" height="auto" 
                    content-width="30%" content-height="scale-to-fit"/>
            </fo:block>
            
            <fo:block text-align="right" margin-top="-1.8cm" margin-right="2.5cm" font-size="8pt"
                font-family="{$title.fontset}" font-weight="normal" font-style="italic">
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
    
    <!-- Настройка локализации. Влияет на текст, который формируется автоматически - такой как Глава, Книга и т.п -->
	<xsl:param name="l10n.gentext.default.language" select="'ru'"/>

    <!-- Указываем формат листа бумаги -->
	<xsl:param name="paper.type" select="'A4'"/>
    <xsl:param name= "page.margin.top">0.6in</xsl:param>  

	<!-- Печать с двух сторон листа или нет -->
	<xsl:param name="double.sided" select="0"/>
	
	<!-- Сами правила переноса настраиваются в fo процессоре-->
	<xsl:param name="hyphenate">false</xsl:param> 

	<!--  Шрифт, который будет использоваться для формирования документа -->
	<xsl:param name="body.font.family" select="'Arial'"/>

	<!-- Размер шрифта для основного текста -->
	<xsl:param name="body.font.master">10</xsl:param>
	
	<!-- Параметры основного текста -->
	<xsl:template match="para">
	    <fo:block 
			start-indent="0cm" 
			end-indent="0cm" 
			line-height="18pt" 
			text-align-last="left"> 
	        <xsl:apply-templates/>
		</fo:block>
	</xsl:template>
    
        

	<!-- Задем параметры титула для Chapter -->
	<xsl:template match="title" mode="article.titlepage.recto.auto.mode">
		<fo:block xsl:use-attribute-sets="section.title.properties" 
			color="#4900db" 
			font-size="24pt" 
			line-height="24pt" 
			space-after="1em">
			<xsl:call-template   name="component.title">
				<xsl:with-param name="node"
					select="ancestor-or-self::article[1]"/>
			</xsl:call-template>
		</fo:block>
	</xsl:template>
    
    

	<!-- Шрифт monospace, который будет использован для формирования блоков <programlisting> <screen> и т.п -->
	<xsl:param name="monospace.font.family">Arial</xsl:param>

	<!-- Шрифт для заголовков -->
	<xsl:param name="title.font.family">Arial</xsl:param>

	<!-- Шрифт для символов-->
	<xsl:param name="symbol.font.family">Symbol</xsl:param> 

	<!-- Структура оглавления -->
	<xsl:param name="generate.toc">
/appendix toc,title
article   title
article/appendix  nop
book      nop
/chapter  nop
part      nop
preface  nop
reference nop
/sect1    nop
/sect2    nop
/sect3    nop
/sect4    nop
/sect5    nop
/section  nop
set       nop
	</xsl:param>

  <!--Автонумерация глав-->
	<xsl:param name="section.autolabel" select="'1'"/>
	<xsl:param name="section.label.includes.component.label" select="1"/>
	<xsl:param name="chapter.autolabel" select="1"/>
   
	<!--Формат заголовков -->
	<xsl:attribute-set name="section.title.level1.properties">
		<xsl:attribute name="font-size">
			<xsl:value-of select="$body.font.master * 2.0"/>
			<xsl:text>pt</xsl:text>
		</xsl:attribute>
		<xsl:attribute name="line-height">24pt</xsl:attribute>
	    <xsl:attribute name="space-after">0.8em</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="section.title.level2.properties">
		<xsl:attribute name="font-size">
			<xsl:value-of select="$body.font.master * 1.4"/>
			<xsl:text>pt</xsl:text>
		</xsl:attribute>
		<xsl:attribute name="line-height">18pt</xsl:attribute>
	    <xsl:attribute name="space-after">0.6em</xsl:attribute>
	    <xsl:attribute name="space-after">0.6em</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="section.title.level3.properties">
		<xsl:attribute name="font-size">
			<xsl:value-of select="$body.font.master * 1.2"/>
			<xsl:text>pt</xsl:text>
			<xsl:attribute name="line-height">18pt</xsl:attribute>
		</xsl:attribute>
	    <xsl:attribute name="space-before">0.4em</xsl:attribute>
	    <xsl:attribute name="space-after">0.4em</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="section.title.level4.properties">
		<xsl:attribute name="font-size">
			<xsl:value-of select="$body.font.master * 1.0"/>
			<xsl:text>pt</xsl:text>
		</xsl:attribute>
		<xsl:attribute name="line-height">18pt</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	    <xsl:attribute name="space-after">0.2em</xsl:attribute>
	    <xsl:attribute name="space-after">0.2em</xsl:attribute>
	</xsl:attribute-set>
	
	<!-- Вставил 5 уровень заголовков на всякий случай -->
	<!--  
	<xsl:attribute-set name="section.title.level5.properties">
		<xsl:attribute name="font-size">
			<xsl:value-of select="$body.font.master * 1.0"/>
			<xsl:text>pt</xsl:text>
			<xsl:attribute name="line-height">18pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:attribute>
	</xsl:attribute-set>
	-->
		
	<!-- Общие правила для разделов -->
	<xsl:attribute-set name="section.title.properties">
		<xsl:attribute name="font-family">
			<xsl:value-of select="$title.font.family"/>
		</xsl:attribute>
		<xsl:attribute name="color">#4900db</xsl:attribute>
		<!-- <xsl:attribute name="space-before.minimum">1.8em</xsl:attribute>
		<xsl:attribute name="space-before.optimum">2em</xsl:attribute>
		<xsl:attribute name="space-before.maximum">2.2em</xsl:attribute> -->
		<xsl:attribute name="text-align">left</xsl:attribute>
		<xsl:attribute name="start-indent">
		<xsl:value-of select="$title.margin.left"/>
		</xsl:attribute>
	</xsl:attribute-set>
    
   
	<!-- Местоположение подписей к элементам -->
	<xsl:param name="formal.title.placement"> figure after table before example after </xsl:param>

	<!-- Стиль оформления подписей -->
	<xsl:attribute-set name="formal.title.properties" use-attribute-sets="normal.para.spacing">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="color">#4900db</xsl:attribute>
		<xsl:attribute name="text-align">left</xsl:attribute>
		<xsl:attribute name="font-size">
			<xsl:value-of select="$body.font.master * 1"/>
			<xsl:text>pt</xsl:text>
		</xsl:attribute>
		<xsl:attribute name="keep-together.within-column">always</xsl:attribute>
		<!-- Пока оставлю блок выравнивания -->
		<!--  
		<xsl:attribute name="space-after.minimum">0.4em</xsl:attribute>
		<xsl:attribute name="space-after.optimum">0.6em</xsl:attribute>
		<xsl:attribute name="space-after.maximum">0.8em</xsl:attribute>
		<xsl:attribute name="line-height">18pt</xsl:attribute>
		-->
	</xsl:attribute-set>
      
    <!-- подпись к рисункам и ссылкам к рисункам -->
 <xsl:param name="local.l10n.xml" select="document('')"/>
 <l:i18n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0">
   <l:l10n language="ru">
   	
     <l:context name="title">
       <l:template name="figure" text="Рис. %n. %t"/>
     	<l:template name="table" text=""/>
     </l:context>   
     
     <l:context name="xref-number-and-title">
       <l:template name="figure" text="«Рис. %n. »"/>
     	<l:template name="table" text="«the table titled &#8220;%t&#8221;»"/>
     </l:context> 
     
     <l:context name="xref-number-and-title">
       <l:template name="ulink" text="%t"/>
     </l:context>
   	
   	<l:context name="title-numbered"> 
   		<l:template name="chapter" text="%n.&#160;%t"/>
   	</l:context>
   	
   	<l:context name="title-numbered"> 
   		<l:template name="sect1" text="Раздел %n. %t"/>
   		<l:template name="sect2" text="Раздел %n. %t"/>
   		<l:template name="sect3" text="Раздел %n. %t"/>
   	</l:context>
  </l:l10n>
 </l:i18n> 
	
 <!-- Показывать значок для примечания  -->
 <xsl:param name="admon.graphics" select="1"></xsl:param>
 
 <!-- Расширение картинки -->
 <xsl:param name="admon.graphics.extension">.png</xsl:param>
 
 <!-- Директория для поиска. Картинки должны иметь определенные названия. -->
 <xsl:param name="admon.graphics.path">../styles/company/fo/</xsl:param>
 
</xsl:stylesheet>