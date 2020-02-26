<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://docbook.org/ns/docbook"
	xmlns:fo="http://www.w3.org/1999/XSL/Format"
	version="1.0">
	
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
			text-align-last="justify" 
			space-before="1em">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	
	<!-- Задем параметры титула для Chapter -->
	<xsl:template match="title" mode="chapter.titlepage.recto.auto.mode">
		<fo:block xsl:use-attribute-sets="section.title.properties" 
			color="#4900db" 
			font-size="24pt" 
			line-height="24pt">
			<xsl:call-template   name="component.title">
				<xsl:with-param name="node"
					select="ancestor-or-self::chapter[1]"/>
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
book      toc,title
/chapter  toc,title
part      toc,title
/preface  toc,title
reference toc,title
/sect1    toc
/sect2    toc
/sect3    toc
/sect4    toc
/sect5    toc
/section  toc
set       toc,title
	</xsl:param>

	<!-- Глубина вложений секций которая отобразится в оглавлении-->
	<xsl:param name="toc.section.depth">2</xsl:param>
	
	<!-- Настраиваем положение оглавления -->
	<xsl:attribute-set name="toc.margin.properties">
		<xsl:attribute name="space-before.minimum">0.5em</xsl:attribute>
		<xsl:attribute name="space-before.optimum">1em</xsl:attribute>
		<xsl:attribute name="space-before.maximum">2em</xsl:attribute>
		<xsl:attribute name="space-after.minimum">0.5em</xsl:attribute>
		<xsl:attribute name="space-after.optimum">1em</xsl:attribute>
		<xsl:attribute name="space-after.maximum">2em</xsl:attribute>
		<xsl:attribute name="start-indent">0cm</xsl:attribute>
		<xsl:attribute name="color">#4900db</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="toc.line.properties">
		<xsl:attribute name="text-align-last">justify</xsl:attribute>
		<xsl:attribute name="text-align">left</xsl:attribute>
		<xsl:attribute name="end-indent">0.6cm</xsl:attribute>
		<xsl:attribute name="last-line-end-indent">-0.25in</xsl:attribute>
		<xsl:attribute name="line-height">14pt</xsl:attribute>
	</xsl:attribute-set>
	
	<!-- Указываем на жесткое прерывание страницы -->
	<xsl:attribute-set name="toc.margin.properties">
		<xsl:attribute name="break-after">page</xsl:attribute>
	</xsl:attribute-set>
	
	<!-- Форматируем слово "Содержание" -->
	<xsl:template name="table.of.contents.titlepage" priority="1">
		<fo:block xsl:use-attribute-sets="section.title.level1.properties"
			space-before="1pt"
			space-before.conditionality="retain"
			space-after="1pt"
			font-size="18">
			<xsl:call-template name="gentext">
				<xsl:with-param name="key" select="'TableofContents'"/>
			</xsl:call-template>
		</fo:block>
	</xsl:template>
	
	<!--Форматирование заголовков в оглавлении -->
	<xsl:template match="sect1" mode="toc">
		<fo:block>
			<xsl:attribute name="text-align-last">justify</xsl:attribute>
			<xsl:attribute name="text-align">left</xsl:attribute>
			<xsl:attribute name="start-indent">0cm</xsl:attribute>
			<xsl:attribute name="end-indent">0.6cm</xsl:attribute>
			<xsl:attribute name="last-line-end-indent">-0.25in</xsl:attribute>
			<xsl:attribute name="line-height">14pt</xsl:attribute>
			<xsl:call-template name="toc.line"/>
		</fo:block>
	</xsl:template>
	
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
	</xsl:attribute-set>
	
	<xsl:attribute-set name="section.title.level2.properties">
		<xsl:attribute name="font-size">
			<xsl:value-of select="$body.font.master * 1.4"/>
			<xsl:text>pt</xsl:text>
		</xsl:attribute>
		<xsl:attribute name="line-height">18pt</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="section.title.level3.properties">
		<xsl:attribute name="font-size">
			<xsl:value-of select="$body.font.master * 1.2"/>
			<xsl:text>pt</xsl:text>
			<xsl:attribute name="line-height">18pt</xsl:attribute>
		</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="section.title.level4.properties">
		<xsl:attribute name="font-size">
			<xsl:value-of select="$body.font.master * 1.0"/>
			<xsl:text>pt</xsl:text>
		</xsl:attribute>
		<xsl:attribute name="line-height">18pt</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
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
		<xsl:attribute name="space-after">1em</xsl:attribute>
		<xsl:attribute name="space-before">1.5em</xsl:attribute>
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
	
	<!--  Блок форматирования таблиц -->
	<xsl:attribute-set name="table.properties">
		<xsl:attribute name="start-indent">0pt</xsl:attribute>
		<xsl:attribute name="font-size">
			<xsl:choose>
				<xsl:when test="@tabstyle = 'smallfont-wide'">8pt</xsl:when>
				<xsl:otherwise>inherit</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		<xsl:attribute name="table-layout">auto</xsl:attribute>
		<xsl:attribute name="text-align">left</xsl:attribute>
		<xsl:attribute name="keep-together.within-column">auto</xsl:attribute>
		<xsl:attribute name="inline-progression-dimension">auto</xsl:attribute>
		<xsl:attribute name="line-height">10pt</xsl:attribute>
		<xsl:attribute name="space-after">1em</xsl:attribute>
		<xsl:attribute name="space-before">1.5em</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:template match="text()[parent::entry]">
		<xsl:call-template name="intersperse-with-zero-spaces">
			<xsl:with-param name="str" select="."/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template name="intersperse-with-zero-spaces">
		<xsl:param name="str"/>
		<xsl:variable name="spacechars">
			&#x9;&#xA;
			&#x2000;&#x2001;&#x2002;&#x2003;&#x2004;&#x2005;
			&#x2006;&#x2007;&#x2008;&#x2009;&#x200A;&#x200B;
		</xsl:variable>
		
		<xsl:if test="string-length($str) > 0">
			<xsl:variable name="c1"
				select="substring($str, 1, 1)"/>
			<xsl:variable name="c2"
				select="substring($str, 2, 1)"/>
						
			<xsl:value-of select="$c1"/>
			<xsl:if test="$c2 != '' and
				not(contains($spacechars, $c1) or
				contains($spacechars, $c2))">
				<xsl:text>&#x200B;​</xsl:text>
			</xsl:if>
			
			<xsl:call-template name="intersperse-with-zero-spaces">
				<xsl:with-param name="str" select="substring($str, 2)"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

 <!-- Показывать значок для примечания  -->
 <xsl:param name="admon.graphics" select="1"></xsl:param>
 
 <!-- Расширение картинки -->
 <xsl:param name="admon.graphics.extension">.png</xsl:param>
 
 <!-- Директория для поиска. Картинки должны иметь определенные названия. -->
 <xsl:param name="admon.graphics.path">../styles/company/fo/</xsl:param>
	
</xsl:stylesheet>
