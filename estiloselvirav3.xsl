<?xml version="1.0" encoding="UTF-8"?>

<!-- MODIFICACION: 14-02-2022 -->

<!-- TRANSFORMACIÓN XSL DO PROXECTO E-STRELA (CIRP) -->
  <!-- Esta XSLT é de uso interno para o proxecto, realizada por Manuel Magán Abollo.
  Organización da folla:
    - Declaración da stylesheet
    - xsl:template da raíz
      * head do HTML e folla de estilos CSS
      * estrutura xeral da páxina HTML
          - div cabeceira
          - div corpo
    - Corpo da páxina
      * Migas e cabeceira visíbeis con información xeral
      * Estrutura xeral da páxina HTML, elementos l, lg e seg
      * Templates e condicións para elementos e atributos do XML
          - choice, abbr, expan, sic, corr
          - subst, add, del
          - c
          - lb, cb, pb
          - space, damage e gap
          - supplied
          - Outros
  -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei"
    version="1.0">
    <xsl:output media-type="text/html" method="html" encoding="UTF-8" indent="yes"/>


    <!-- Un strip-space * fai que se eliminen espazos que si quero respectar, e non mellora os que quero mellorar -->

  <xsl:template match="/">
    <html>
      <head>
        <title><xsl:value-of select="replace(TEI/teiHeader/fileDesc/editionStmt/@n, '-', ' ')"/> XSL</title>
        <style type="text/css">
          @font-face {
          font-family: "Junicode", "JunicodeTwoBetaRegular", "JuniusX", Times, serif;
          src: url('/.fontes/JunicodeTwoBeta-Regular.ttf');
          }

          /***** RAÍZ *****/

          html {
          margin: 0 2rem 0 2rem;
          font-family: "Junicode", "JunicodeTwoBetaRegular", "JuniusX", Times, serif;
          background-color: white;
          }


          /***** ELEMENTOS POLIVALENTES *****/

          .titulo {
          font-weight: bold;
          font-variant: small-caps;
          line-height: 10%;
          }
          .taboa {
          margin-top: 2.1rem;
          margin-bottom: 2.1rem;
          width: 100%;
          }
          .caixatexto {
          background-color: #f5f5f5;
          font-size: 93%;
          padding-left: 1rem;
          padding-right: 0.5rem;
          padding-top: 1rem;
          padding-bottom: 0.5rem;
          margin-top: 1rem;
          }

          /*** LISTAS ***/
          ul.lista {
          list-style: none; margin: 0; padding: 0;
          display: inline;
          }
          ul.lista li {
          display: inline;
          }
          ul.lista li:after {
          content: ',';
          }
          ul.lista li:last-child:after {
          content: '';
          }
          ul.lista li:last-child:before {
          content: ' e ';
          }
          ul.lista li:first-child:before {
          content: none !important;
          }
          ul.lista li:nth-last-child(2):after {
          content: none !important;
          }


          /***** NOTAS - POPUP *****/

          .nota {
          margin: 7px 0 7px 0;
          }

          .modal {
            position: fixed;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0, 0, 0, 0.5);
            opacity: 0;
            visibility: hidden;
            transform: scale(1.1);
            transition: visibility 0s linear 0.25s, opacity 0.25s 0s, transform 0.25s;
            z-index: 1000 !important;
          }
          .modal-content .nota {
            margin-bottom: .5em;
            display: block;
          }
          .modal-content {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background-color: white;
            padding: 1rem 1.5rem;
            width: 24rem;
            border-radius: 0.5rem;
            z-index: 100000 !important;
            text-align: initial;
            font-style: normal;
            }
          .close-button {
            float: right;
            width: 1.5rem;
            line-height: 1.5rem;
            text-align: center;
            cursor: pointer;
            border-radius: 0.25rem;
            background-color: lightgray;
            }
            .close-button:hover {
              background-color: darkgray;
            }
            .showmodal {
                opacity: 1;
                visibility: visible;
                transform: scale(1.0);
                transition: visibility 0s linear 0s, opacity 0.25s 0s, transform 0.25s;
            }
            .hidemodal {
                opacity: 0;
                visibility: collapse;
                transition: opacity 100s linear;
            }
            .trigger {
            display: inline-block;
            cursor: pointer;
            transition: 0.3s;
            }
            .triggertexto {
            padding: 1px 0 0 0;
            text-decoration: underline solid darkgrey;
            text-underline-offset: 0.1em;
            }
            .triggertexto:hover {
            opacity: 1;
            background-color: black;
            border-radius: 2px;
            color: white;
            font-style: normal !important;
            }
            .triggerne {
            padding: 0px 5px 0px 5px;
            background-color: #c2185b;
            opacity: 0.2;
            color: white;
            font-size: 12px;
            font-variant: small-caps;
            width: 0.5rem;
            text-align: center;
            border-radius: 2px;
            }
            .triggerne:hover {
            opacity: 1;
            }
            .triggerva {
            padding: 0px 5px 0px 5px;
            background-color: #00937D;
            opacity: 0.2;
            color: white;
            font-size: 12px;
            font-variant: small-caps;
            width: 0.5rem;
            text-align: center;
            border-radius: 2px;
            }
            .triggerva:hover {
            opacity: 1;
            }
            .triggervr {
            padding: 0px 5px 0px 5px;
            background-color: #E39D00;
            opacity: 0.2;
            color: white;
            font-size: 12px;
            font-variant: small-caps;
            width: 0.5rem;
            text-align: center;
            border-radius: 2px;
            }
            .triggervr:hover {
            opacity: 1;
            }


          /***** NOTAS - TOOLTIPS *****/

           /* Tooltip container */
          .tooltip {
            position: relative;
            display: inline-block;
            border-bottom: 1px dotted darkgrey; /* If you want dots under the hoverable text */
          }
          /* Tooltip text */
          .tooltip .tooltiptext {
            visibility: hidden;
            width: 140px;
            background-color: #444;
            color: #efefef;
            text-align: center;
            padding: 6px;
            border-radius: 6px;
            font-style: normal !important;
            box-shadow: 2px 2px 10px 0 rgba(0, 0, 0, 0.2), 0 3px 10px 0 rgba(0, 0, 0, 0.19);
            /* Position the tooltip text */
            position: absolute;
            z-index: 1;
            bottom: 150%;
            left: 50%;
            margin-left: -75px;
            font-size: 12pt !important;
            /* Fade in tooltip */
            opacity: 0;
            transition: 0.3s;
          }
          .tooltip.tooltipabbr .tooltiptext {
          width: 70px !important;
          margin-left: -38px !important;
          }
          /* Tooltip arrow */
          .tooltip .tooltiptext::after {
            content: '';
            position: absolute;
            top: 100%;
            left: 50%;
            margin-left: -5px;
            border-width: 5px;
            border-style: solid;
            border-color: #444 transparent transparent transparent;
          }
          /* Show the tooltip text when you mouse over the tooltip container */
          .tooltip:hover .tooltiptext {
            visibility: visible;
            opacity: 1;
          }

          /*** Tooltip abaixo ***/
          .tooltipabaixo {
            position: relative;
            display: inline-block;
            border-bottom: 0px dotted darkgrey;
          }
          .tooltipabaixo .tooltiptextabaixo {
            visibility: hidden;
            width: 140px;
            background-color: #444;
            color: #efefef;
            text-align: center;
            padding: 6px;
            border-radius: 6px;
            font-style: normal !important;
            box-shadow: 0 2px 4px 0 rgba(0, 0, 0, 0.2), 0 3px 10px 0 rgba(0, 0, 0, 0.19);
            /* Position the tooltip text */
              position: absolute;
              z-index: 1;
              top: 150%;
              left: 50%;
              margin-left: -60px;
              font-size: 90% !important;
              /* Fade in tooltip */
              opacity: 0;
              transition: 0.3s;
            }

            /* Tooltip arrow
          .tooltipabaixo .tooltiptextabaixo::after {
            content: '';
            position: absolute;
            bottom: 100%;
            left: 50%;
            margin-left: -5px;
            border-width: 5px;
            border-style: solid;
            border-color: transparent transparent #444 transparent;
          } */

          .tooltipabaixo:hover .tooltiptextabaixo {
            visibility: visible;
            opacity: 1;
          }

          /*** Tooltip substi ***/
          .tooltipsubsti {
            position: relative;
            display: inline-block;
            border-bottom: 1px dotted darkgrey;
          }
          .tooltipsubsti .tooltiptextsubsti {
            visibility: hidden;
            width: 200px;
            background-color: #444;
            color: #efefef;
            text-align: center;
            border-radius: 6px;
            padding: 6px;
            margin-left: 5px;
            font-style: normal !important;
            box-shadow: 0 2px 4px 0 rgba(0, 0, 0, 0.2), 0 3px 10px 0 rgba(0, 0, 0, 0.19);
            /* Position the tooltip text */
              position: absolute;
              z-index: 1;
              top: -5px;
              left: 110%;
              font-size: 90% !important;
              /* Fade in tooltip */
              opacity: 0;
              transition: 0.3s;
            }
            /* Tooltip arrow
          .tooltipsubsti .tooltiptextsubsti::after {
            content: '';
            position: absolute;
            top: 50%;
            right: 100%;
            margin-top: -5px;
            border-width: 5px;
            border-style: solid;
            border-color: transparent #444 transparent transparent;
          } */
          .tooltipsubsti:hover .tooltiptextsubsti {
            visibility: visible;
            opacity: 1;
          }


          /***** NOTAS - OUTRAS *****/

          .notasedicion {
          padding-top: 1em;
          border-top: 1px groove;
          }

          .blinkElvira {
            animation: blinkingText 2s infinite
          }
          @keyframes blinkingText{
            0%		{ background-color: #fff500;}
            10%		{ background-color: #fff759;}
            20%		{ background-color: #fff887;}
            30%		{ background-color: #fffab0;}
            40%		{ background-color: #fffdd8;}
            50%		{ background-color: rgba(55, 55, 55, 0%);}
            60%		{ background-color: #fffdd8;}
            70%		{ background-color: #fffab0;}
            80%		{ background-color: #fff887;}
            90%		{ background-color: #fff766;}
            100%	{ background-color: #fff759;}
          }

            /***** INFORMACIÓN XERAL - ESTRUTURA *****/

            .infxeral {
            padding: 0.5rem;
            margin: 0 0 0.5rem 0.5rem;
            overflow: hidden;
            }

            .infxeral2c {
            -webkit-columns: 2 20rem;
              -moz-columns: 2 20rem;
                columns: 2 20rem;
            }
            .infxeral0 {
            width: 100%;
            margin: 0 0 0 0px;
            border-collapse: separate;
            border-spacing: 0.2em;
            }
            .infxeral1 {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0.2em;
            }
            .infxeralbut {
            width: 100%;
            padding: 0.5rem 0.5rem 0.2rem 0.5rem;
            display: inline-flex;
            border-top: 1px solid #ecedef;
            cursor: pointer;
            font-weight: 600;
            font-size: 105%;
            font-stretch: semi-expanded;
            }
            .infxeralbut1 {
            width: 95%;
            }
            .infxeralbut2 {
            width: 5%;
            height: 1.3rem;
            width: 1.3rem;
            justify-content: center;
          	-ms-flex-align: center;
          	-webkit-align-items: center;
          	-webkit-box-align: center;
            }
            .infxeralbut2arr {
            transform: rotate(0deg);
            transition: transform 0.3s linear;
            }
            .infxeralbut2arrvisitado {
            transform: rotate(180deg);
            transition: transform 0.3s linear;
            }
            .infxerpech {
            border-top: 1px solid #ecedef;
            width: 100%;
            display: block;
            padding: 0.5rem 0.5rem 0.2rem 0.5rem;
            margin-top: 3px;
            }
            .infxeraltit {
            width: 30%;
            font-variant: small-caps;
            -webkit-column-break-inside: avoid;
            page-break-inside: avoid;
            break-inside: avoid;
            display: inherit;
            margin-right: 1em;
            }
            .infxeralcon {
            width: 70%;
            }
            .infxeraltr {
            display: table-row;
            list-style-type: none;
            -webkit-column-break-inside: avoid;
              page-break-inside: avoid;
               break-inside: avoid;
            margin-bottom: 0.7em;
            }
            .showdiv {
              max-height: 1000px;
              transition: all 0.5s ease-in;
              display: block;
            }
            .hidediv {
                display: none;
                max-height: 0 !important;
                transition: all 0.2s ease-out;
            }


          /***** ESTRUTURA DE VERSOS *****/

          .versos {
          font-size: 110%;
          line-height: 125%;
          z-index: 1;
          }
          .lateral1 {
          width: 10%;
          text-align: center;
          }
          .lateral2 {
          margin-right: 12px;
          width: 4%;
          text-align: center;
          vertical-align: middle;
          }
          .lateral2:first-letter {
          text-transform: capitalize;
          }
          .lateral3 {
          width: 86%;
          }
          .lat3refran {
          font-style: oblique;
          }
          .lat3refranpaleo {
          color: #AB0300;
          }
          .lat3refranpaleo .gap {
          color: #AB0300;
          }
          .lat3refranpaleo .space {
          color: #AB0300;
          }
          .num05 {
          font-size: small;
          }
          .num1234 {
          font-size: small;
          opacity: 0;
          transition: 0.2s;
          }
          .verso {
          width: 100%;
          }
          .verso:hover .num1234 {
              opacity: 1;
              font-size: small;
          }
          .versorefran {
          width: 100%;
          line-height: 115% !important;
          }


          /***** TEXTO - TIPOS DE CARACTER (c) *****/

          .expansiva {
          font-size: 120%;
          font-stretch: expanded;
          font-weight: 400;
          font-variant: small-caps;
          padding: 0;
          margin: 0;
          }
          .superindice {
          vertical-align: super;
          font-size: 80%;
          }
          .inicial {
          font-style: normal !important;
          font-stretch: semi-expanded;
          }
          .inicobra {
          font-size: 140%;
          }
          .inirefran {
          font-size: 130%;
          }
          .inirubrica {
          font-size: 120%;
          }
          .iniapertura {
          font-size: 190%;
          font-stretch: expanded !important;
          font-weight: 500;
          padding: .7px 0.5px 0.5px .7px;
          }
          .inidecorado {
          color: #FAA916;
          }
          .vermello {
          color: #b71c1c;
          }
          .azul {
          color: #083d77;
          }
          .negro {
          color: #000;
          }

          /***** TEXTO - CHOICES (choice) *****/
          .abreviatura {
          background-color: #F3E5F561;
          z-index: 10:
          }
          .desenvolvimento {
          color: #D25708FF;
          background-color: #DFDFDF5E;
          z-index: 9;
          }
          .choice {
          color: #5E0637;
          }
          .siccorr {
          color: #065E4B;
          }
          .origrel {
          border-bottom: 1px dotted #D1D0CE;
          }
          .reg {
          display: inline;
          color: #D20808DB;
          background-color: #DFDFDF5E;
          z-index: 9;
          }
          /***** .reg {
          opacity: 0;
          display: none;
          transition: 0.2s;
          }
          .origrel:hover .reg {
              opacity: 1;
              display: inline;
          }
          .origrel:hover .orig {
              opacity: 0;
              display: none;
          } *****/

          /***** TEXTO - SUBSTITUCIÓNS (subst) *****/

          .subst {
          text-decoration: inherit;
          color: inherit;
          background-color: #FFF3E0;
          font-style: normal !important;
          z-index: 0 !important;
          position: relative;
          }
          .subst .lb {
          z-index: 0;
          position: relative;
          }
          .delrasp {
          color: #7C7359;
          background-color: #FFF3E0;
          z-index: 0 !important;
          }
          .delrasppar {
          color: lightgrey;
          background-color: #FFF3E0;
          }
          .delpunto {
          text-decoration: underline dotted #111;
          background-color: #FFF3E0;
          }
          .delpuntoarriba {
          text-decoration: overline dotted #111;
          background-color: #FFF3E0;
          }
          .delrisc {
          color: inherit !important; /* antes black */
          text-decoration: line-through solid #111;
          background-color: #FFF3E0;
          }
          .addmar {
          font-style: normal;
          }
          .addaba {
          vertical-align: sub;
          font-size: smaller;
          }
          .addarr {
          vertical-align: super;
          font-size: smaller;
          }


          /***** TEXTO - SALTOS *****/

          .lb {
          padding: 0.1rem;
          color: #BDBDBD !important;
          vertical-align: baseline;
          font-size: 90%;
          font-style: normal !important;
          z-index: -10;
          position: relative;
          }
          .cb {
          padding: 0.1rem;
          /* color: #607d8b; */
          vertical-align: baseline;
          font-size: 90%;
          font-style: normal !important;
          z-index: -10;
          position: relative;
          }
          .pb {
          padding: 0.1rem;
          /* color: #607d8b; */
          vertical-align: baseline;
          font-size: 90%;
          font-style: normal !important;
          z-index: -10;
          position: relative;
          }

          /***** TEXTO - PERSOAS E LUGARES *****/

          .persname {
          color: #4527a0;
          }
          .placename {
          color: 1e88e5;
          }

          /***** TEXTO - OUTROS *****/
          .unclear {
            text-decoration: underline solid #e65100;
            z-index: 3;
          }
          .unclear, .unclear, .unclear > span {text-decoration: underline solid #e65100; }
          .unclear, .unclear, .unclear > div {text-decoration: underline solid #e65100; }

          .space {
            background-color: #FFFDF6;
          }
          .spacediv {
            /* text-align: center;
            width: 5%;
            display: inline-block;
            margin-right: 0.1rem; */
          }
          .gap {
            background-color: #FFFDF6;
            font-style: normal !important;
          }
          .damagemanchas {
            background-color: #FFFDF6;
          }
          .extratext {
            background-color: #F4F4F4;
            color: #6F6F6F;
            font-style: normal !important;
          }

          /***** OUTROS *****/

          ul {
          padding-inline-start: 20px;
          }
        </style>
      </head>
    </html>


    <!-- ESTRUTURA XERAL (1 de 2) -->
    <div class="datos">
      <xsl:apply-templates select="TEI"/>
      <!--FOLIOS VELLO <xsl:choose><xsl:when test="TEI/teiHeader/fileDesc/editionStmt/edition[@xml:id ='criti']"><xsl:if test="TEI/teiHeader/fileDesc/sourceDesc/msDesc/msContents/msItemStruct/locus"><div class="folios" style="font-size: 110%; padding-left: 1rem; margin-top: 2em"><xsl:for-each select="TEI/teiHeader/fileDesc/sourceDesc/msDesc">
            <xsl:value-of select="msIdentifier/altIdentifier/idno"/>:
            <xsl:value-of select="msContents/msItemStruct/locus"/>, <span style="text-transform: lowercase;"><xsl:value-of select="msContents/msItemStruct/title"/></span><br/>
          </xsl:for-each></div></xsl:if></xsl:when></xsl:choose> -->
          </div>
        <!--TEXTO-->
        <div class="corpo">
          <xsl:apply-templates select="TEI/text"/>
        <!--NOTAS FINAIS <div class="caixatexto" style="border: 1px solid #d0d0d0;"></div> -->
    </div>
  </xsl:template>


      <!-- VARIABEIS XERAIS -->

      <xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyzñç'" />
      <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZÑÇ'" />


      <!-- INFORMACIÓN XERAL -->

      <xsl:template match="TEI" name="infxer">
        <xsl:variable name="numerocantig" select="substring(teiHeader/fileDesc/editionStmt/@n, 4, 3)"/>

      <!--CSM-->
      <table class="infxeral0"><tr class="infxeralbut" onclick="toggleVisibility('IXcantiga'); toggleVisibilitytd('IXcantigatd');"><td class="infxeralbut1">CSM <xsl:value-of select="number($numerocantig)"/>: <xsl:value-of select="teiHeader/fileDesc/titleStmt/title[@type='short']"/></td><td class="infxeralbut2 infxeralbut2arr" id="IXcantigatd"><svg focusable="false" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M7.41 8.59L12 13.17l4.59-4.58L18 10l-6 6-6-6 1.41-1.41z"></path></svg></td></tr></table>

      <div id="IXcantiga" class="infxeral infxeral2c hidediv">
      <table class="infxeral1">
        <xsl:if test="teiHeader/fileDesc/editionStmt/edition = 'Transcrición paleográfica'">
          <tr class="infxeraltr">
            <td class="infxeraltit">Número:</td><td class="infxeralcon"><xsl:value-of select="number($numerocantig)"/></td></tr>
            <tr class="infxeraltr">
              <xsl:variable name="numeromanuscr" select="substring(teiHeader/fileDesc/sourceDesc/msDesc/msContents/msItemStruct/@n, 4, 3)"/>
              <xsl:variable name="numerom" select="teiHeader/fileDesc/sourceDesc/msDesc/msContents/msItemStruct/@n"/>
              <td class="infxeraltit">Número no manuscrito:</td><td class="infxeralcon"><xsl:choose>
                <xsl:when test="$numeromanuscr='00I'">I</xsl:when>
                <xsl:when test="$numeromanuscr='0II'">II</xsl:when>
                <xsl:when test="$numeromanuscr='III'">III</xsl:when>
                <xsl:when test="$numeromanuscr='0IV'">IV</xsl:when>
                <xsl:when test="$numeromanuscr='00V'">V</xsl:when>
                <xsl:when test="$numeromanuscr='0VI'">VI</xsl:when>
                <xsl:when test="$numeromanuscr='VII'">VII</xsl:when>
                <xsl:when test="$numeromanuscr='V2I'">VIII</xsl:when>
                <xsl:when test="$numeromanuscr='0IX'">IX</xsl:when>
                <xsl:when test="$numeromanuscr='00X'">X</xsl:when>
                <xsl:when test="$numeromanuscr='0XI'">XI</xsl:when>
                <xsl:when test="$numeromanuscr='XII'">XII</xsl:when>
                <xsl:when test="$numeromanuscr='X2I'">XIII</xsl:when>
                <xsl:when test="$numeromanuscr='XIV'">XIV</xsl:when>
                <xsl:when test="substring($numerom, 6, 1) = '0' or substring($numerom, 6, 1) = '1' or substring($numerom, 6, 1) = '2' or substring($numerom, 6, 1) = '3' or substring($numerom, 6, 1) = '4' or substring($numerom, 6, 1) = '5' or substring($numerom, 6, 1) = '6' or substring($numerom, 6, 1) = '7' or substring($numerom, 6, 1) = '8' or substring($numerom, 6, 1) = '9'"><xsl:value-of select="number($numeromanuscr)"/></xsl:when>
                </xsl:choose></td></tr>
            <tr class="infxeraltr">
              <td class="infxeraltit">Manuscrito:</td>
              <td class="infxeralcon">
              <xsl:choose>
                <xsl:when test="substring(teiHeader/fileDesc/editionStmt/@n, 1, 2) = 'To'">BNE MS 10069 (Códice de Toledo, To)</xsl:when>
                <xsl:when test="substring(teiHeader/fileDesc/editionStmt/@n, 1, 2) = 'T_'">RBME MS T.I.1 (Códice Rico do Escorial, T)</xsl:when>
                <xsl:when test="substring(teiHeader/fileDesc/editionStmt/@n, 1, 2) = 'F_'">BNCF MS B.R.20 (Códice Rico de Florencia, F)</xsl:when>
                <xsl:when test="substring(teiHeader/fileDesc/editionStmt/@n, 1, 2) = 'E_'">RBME MS B.I.2 (Códice dos Músicos, E)</xsl:when>
                <xsl:when test="substring(teiHeader/fileDesc/editionStmt/@n, 1, 2) = 'B_'">BNP COD 10991 (Cancioneiro da Biblioteca Nacional, B)</xsl:when>
              </xsl:choose></td>
              </tr>
            <tr class="infxeraltr">
              <td class="infxeraltit"><xsl:choose>
                <xsl:when test="substring(teiHeader/fileDesc/sourceDesc/msDesc/msContents/msItemStruct/locus, 1, 2) = 'f.'">Folio:</xsl:when>
                <xsl:when test="substring(teiHeader/fileDesc/sourceDesc/msDesc/msContents/msItemStruct/locus, 1, 2) = 'ff'">Folios:</xsl:when></xsl:choose></td>
              <td class="infxeralcon"><xsl:value-of select="teiHeader/fileDesc/sourceDesc/msDesc/msContents/msItemStruct/locus"/></td>
            </tr>
          </xsl:if>
        <xsl:if test="string(teiHeader/profileDesc/textClass/keywords[@scheme='tipocsm']/term)"><tr class="infxeraltr">
            <td class="infxeraltit">Tipo de cantiga:</td>
            <td class="infxeralcon"><xsl:value-of select="teiHeader/profileDesc/textClass/keywords[@scheme='tipocsm']/term"/></td>
        </tr></xsl:if>

          <xsl:if test="string(teiHeader/fileDesc/titleStmt/title[@type='incipit'])"><tr class="infxeraltr"><td class="infxeraltit">Incipit:</td><td class="infxeralcon"><xsl:value-of select="teiHeader/fileDesc/titleStmt/title[@type='incipit']"/></td></tr></xsl:if>

          <xsl:if test="string(teiHeader/fileDesc/titleStmt/title[@type='rubrica'])"><tr class="infxeraltr">
            <td class="infxeraltit">Rúbrica:</td>
            <td class="infxeralcon"><xsl:value-of select="teiHeader/fileDesc/titleStmt/title[@type='rubrica']"/></td>
          </tr></xsl:if>

          <tr class="infxeraltr">
            <xsl:choose>
              <xsl:when test="teiHeader/fileDesc/editionStmt/edition = 'Transcrición paleográfica'"><td class="infxeraltit">Edición:</td><td class="infxeralcon">Transcrición paleográfica</td></xsl:when>
              <xsl:when test="teiHeader/fileDesc/editionStmt/edition = 'Edición crítica'"><td class="infxeraltit">Edición:</td><td class="infxeralcon">Crítica</td></xsl:when>
              <xsl:when test="teiHeader/fileDesc/editionStmt/edition = 'Edición modernizada'"><td class="infxeraltit">Edición:</td><td class="infxeralcon">Versión en galego moderno</td></xsl:when>
              <xsl:when test="teiHeader/fileDesc/editionStmt/edition = 'Versión en castelán'"><td class="infxeraltit">Edición:</td><td class="infxeralcon">Versión en castelán</td></xsl:when>
            </xsl:choose>
          </tr>

          <xsl:if test="teiHeader/fileDesc/editionStmt/edition = 'Edición crítica'"><tr class="infxeraltr">
            <td class="infxeraltit">
              Localización da cantiga:
            </td>
            <td class="infxeralcon">
              <xsl:for-each select="teiHeader/fileDesc/sourceDesc/msDesc">
                <xsl:value-of select="msIdentifier/altIdentifier/idno"/>:
                <xsl:value-of select="msContents/msItemStruct/locus"/>, <xsl:value-of select="msContents/msItemStruct/title"/><br/>
              </xsl:for-each>
            </td>
          </tr></xsl:if>
        </table>
      </div>

      <!--TEMA-->
      <xsl:if test="string(teiHeader/profileDesc/textClass/keywords[@scheme='tprinci']/term) or string(teiHeader/profileDesc/textClass/keywords[@scheme='mtemati']/term) or string(teiHeader/profileDesc/textClass/keywords[@scheme='mtemati']/term) or string(teiHeader/profileDesc/textClass/keywords[@scheme='ppchave']/term)"><table class="infxeral0"><tr class="infxeralbut" onclick="toggleVisibility('IXclasificacion'); toggleVisibilitytd('IXclasificaciontd');"><td class="infxeralbut1">Información adicional</td><td class="infxeralbut2 infxeralbut2arr" id="IXclasificaciontd"><svg focusable="false" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M7.41 8.59L12 13.17l4.59-4.58L18 10l-6 6-6-6 1.41-1.41z"></path></svg></td></tr></table></xsl:if>

      <div id="IXclasificacion" class="infxeral infxeral2c hidediv">
        <table class="infxeral1">
          <xsl:if test="string(teiHeader/profileDesc/textClass/keywords[@scheme='tprinci']/term)"><tr class="infxeraltr">
              <td class="infxeraltit">Tema principal:</td>
              <td class="infxeralcon"><xsl:value-of select="teiHeader/profileDesc/textClass/keywords[@scheme='tprinci']/term"/></td>
          </tr></xsl:if>
          <xsl:if test="string(teiHeader/profileDesc/textClass/keywords[@scheme='mtemati']/term)"><tr class="infxeraltr">
              <td class="infxeraltit">Motivo temático (<small>Aarne-Thompson-Uther</small>):</td>
              <td class="infxeralcon"><xsl:value-of select="teiHeader/profileDesc/textClass/keywords[@scheme='mtemati']/term"/></td>
          </tr></xsl:if>
          <xsl:if test="string(teiHeader/profileDesc/textClass/keywords[@scheme='ppchave']/term)"><tr class="infxeraltr">
            <td class="infxeraltit">Palabras chave:</td>
            <td class="infxeralcon">
              <xsl:for-each select="teiHeader/profileDesc/textClass/keywords[@scheme='ppchave']/term">
                <xsl:if test="position() = last() and position() != 1">
                   <xsl:text> / </xsl:text>
                </xsl:if>
                <xsl:if test="position() != 1 and position() != last()">
                   <xsl:text> / </xsl:text>
                </xsl:if>
                <xsl:value-of select="."/>
              </xsl:for-each>
              </td>
            </tr>
          </xsl:if>

          <xsl:if test="string(teiHeader/profileDesc/textClass/keywords[@scheme='persona']/term)"><tr class="infxeraltr">
            <td class="infxeraltit">Personaxes principais:</td>
            <td class="infxeralcon"><xsl:for-each select="teiHeader/profileDesc/textClass/keywords[@scheme='persona']/term">
              <xsl:if test="position() = last() and position() != 1">
                 <xsl:text> / </xsl:text>
              </xsl:if>
              <xsl:if test="position() != 1 and position() != last()">
                 <xsl:text> / </xsl:text>
              </xsl:if>
              <xsl:value-of select="."/>
            </xsl:for-each></td>
          </tr>
        </xsl:if>

          <xsl:if test="string(teiHeader/profileDesc/textClass/keywords[@scheme='lugares']/term)"><tr class="infxeraltr">
            <td class="infxeraltit">Lugares:</td>
            <td class="infxeralcon"><xsl:for-each select="teiHeader/profileDesc/textClass/keywords[@scheme='lugares']/term">
              <xsl:if test="position() = last() and position() != 1">
                 <xsl:text> / </xsl:text>
              </xsl:if>
              <xsl:if test="position() != 1 and position() != last()">
                 <xsl:text> / </xsl:text>
              </xsl:if>
              <xsl:value-of select="."/>
            </xsl:for-each></td>
          </tr></xsl:if>
        </table>
      </div>

      <!--MÉTRICA-->
      <xsl:if test="string(teiHeader/profileDesc/textClass/keywords[@scheme='modestr']/term) or string(text/body/div/@rhyme)"><table class="infxeral0"><tr class="infxeralbut" onclick="toggleVisibility('IXmetrica'); toggleVisibilitytd('IXmetricatd');"><td class="infxeralbut1">Métrica</td><td class="infxeralbut2 infxeralbut2arr" id="IXmetricatd"><svg focusable="false" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M7.41 8.59L12 13.17l4.59-4.58L18 10l-6 6-6-6 1.41-1.41z"></path></svg></td></tr></table></xsl:if>
      <div id="IXmetrica" class="infxeral infxeral2c hidediv">
        <table class="infxeral1">
          <xsl:if test="string(teiHeader/profileDesc/textClass/keywords[@scheme='modestr']/term)"><tr class="infxeraltr">
            <td class="infxeraltit">Modelo estrófico:</td>
            <td class="infxeralcon"><xsl:value-of select="teiHeader/profileDesc/textClass/keywords[@scheme='modestr']/term"/></td>
          </tr></xsl:if>

          <xsl:if test="string(text/body/div[@type='cobras']/@rhyme)"><tr class="infxeraltr">
            <td class="infxeraltit">Esquema ritmático:</td>
            <td class="infxeralcon">
              <xsl:if test="//div[@type='refraninicial']/@rhyme"><xsl:value-of select="translate(text/body/div[@type='refraninicial']/@rhyme, $lowercase, $uppercase)"/> | </xsl:if><xsl:value-of select="translate(text/body/div[@type='cobras']/@rhyme, $uppercase, $lowercase)"/><xsl:value-of select="translate(text/body/lg[@type='refraninicial']/@rhyme, $lowercase, $uppercase)"/>
              </td>
          </tr></xsl:if>

          <xsl:if test="string(text/body/div[@type='cobras']/@met)"><tr class="infxeraltr">
            <xsl:variable name="mascun0" select="'m-f'" />
            <xsl:variable name="mascun1" select="'&#32;&#32;&#8217;'" />
            <td class="infxeraltit">Esquema métrico:</td>
            <td class="infxeralcon"><xsl:value-of select="translate(text/body/div[@type='cobras']/@met, $mascun0, $mascun1)"/></td>
          </tr></xsl:if>

          <tr class="infxeraltr">
            <xsl:variable name="ncobrasdemas" select="text/body/div[@type='cobras']/lg[last()]/@n" />
            <td class="infxeraltit">Número<xsl:if test="string(teiHeader/profileDesc/textClass/keywords[@scheme='tcobras']/term)"> e tipo</xsl:if> de cobras:</td>
            <td class="infxeralcon"><xsl:value-of select="$ncobrasdemas - 1"/><xsl:if test="string(teiHeader/profileDesc/textClass/keywords[@scheme='tcobras']/term)">, <xsl:value-of select="translate(teiHeader/profileDesc/textClass/keywords[@scheme='tcobras']/term, $uppercase, $lowercase)"/></xsl:if></td>
          </tr>

        </table>
      </div>

      <!--PRESENTACIÓN-->
      <xsl:if test="teiHeader/profileDesc/abstract/p"><table class="infxeral0"><tr class="infxeralbut" onclick="toggleVisibility('IXresumo'); toggleVisibilitytd('IXresumotd');"><td class="infxeralbut1">Presentación</td><td class="infxeralbut2 infxeralbut2arr" id="IXresumotd"><svg focusable="false" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M7.41 8.59L12 13.17l4.59-4.58L18 10l-6 6-6-6 1.41-1.41z"></path></svg></td></tr></table>
          <div id="IXresumo" class="infxeral hidediv">
            <table class="infxeral1"><tr class="infxeraltr"><td class="infxeralcon" style="text-align: justify;">
              <xsl:for-each select="teiHeader/profileDesc/abstract/p"><p><xsl:apply-templates select="."/></p></xsl:for-each>
            </td></tr>
          </table>
        </div>
      </xsl:if>

      <!--NOTA XERAL-->
      <xsl:if test="teiHeader/fileDesc/notesStmt/note[@type='notatext']"><table class="infxeral0"><tr class="infxeralbut" onclick="toggleVisibility('IXnotatext'); toggleVisibilitytd('IXnotatexttd');"><td class="infxeralbut1">Notas</td><td class="infxeralbut2 infxeralbut2arr" id="IXnotatexttd"><svg focusable="false" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M7.41 8.59L12 13.17l4.59-4.58L18 10l-6 6-6-6 1.41-1.41z"></path></svg></td></tr></table>
        <div id="IXnotatext" class="infxeral hidediv">
          <table class="infxeral1"><tr class="infxeraltr"><td class="infxeralcon" style="text-align: justify;"><ul>
            <xsl:for-each select="teiHeader/fileDesc/notesStmt/note[@type='notatext']">
                <li><xsl:value-of select="."/></li>
            </xsl:for-each>
          </ul></td></tr></table>
        </div>
      </xsl:if>

        <script>
          var divs = ["IXcantiga", "IXclasificacion", "IXmetrica", "IXpersonaxes", "IXapcri", "IXresumo", "IXnotatext"];
          var visibleDivId = null;

          function toggleVisibility(divId) {
            if (document.getElementById(divId).classList.contains('hidediv')) {
                document.getElementById(divId).classList.remove('hidediv');
                document.getElementById(divId).classList.add('showdiv');
              } else {
                if (document.getElementById(divId).classList.contains('showdiv')) {
                    document.getElementById(divId).classList.remove('showdiv');
                    document.getElementById(divId).classList.add('hidediv');
                }
            }
            }
            var tds = ["IXcantigatd", "IXclasificaciontd", "IXmetricatd", "IXpersonaxestd", "IXapcritd", "IXresumotd", "IXnotatexttd"];

            function toggleVisibilitytd(tdId) {
              if (document.getElementById(tdId).classList.contains('infxeralbut2arrvisitado')) {
                  document.getElementById(tdId).classList.remove('infxeralbut2arrvisitado');
                  document.getElementById(tdId).classList.add('infxeralbut2arr');
                } else {
                  if (document.getElementById(tdId).classList.contains('infxeralbut2arr')) {
                      document.getElementById(tdId).classList.remove('infxeralbut2arr');
                      document.getElementById(tdId).classList.add('infxeralbut2arrvisitado');
                  }
              }
              }
        </script>
        <div class="infxerpech"></div>
  </xsl:template>


    <!-- ESTRUTURA XERAL (2 de 2) -->

    <!-- <xsl:template match="div[@type='rubrica']">
      <table class="taboa versos" style="font-size: 110%;">
        <tr>
          <td class="lateral1">

            <xsl:variable name="targetnotaversre" select="concat('#nv#', @xml:id, '#')"/>
            <xsl:variable name="triggernevrId" select="concat('trigger_',$targetnotaversre)"/>
            <xsl:variable name="modelnevrId" select="concat('model_',$targetnotaversre)"/>
            <xsl:variable name="closenevrId" select="concat('close_',$targetnotaversre)"/>

            <xsl:if test="//note[@type='notavers'][contains($targetnotaversre, concat('#nv#', @target, '#'))]">
            <div class="trigger triggervr" id="{$triggernevrId}" title="Nota ao verso">N</div>
            </xsl:if>

            <div class="modal" id="{$modelnevrId}"><div class="modal-content">
                <span class="close-button" id="{$closenevrId}" title="Fechar">⨯</span>
                <xsl:apply-templates select="//note[@type='notavers'][contains($targetnotaversre, concat('#nv#', @target, '#'))]"/>
              </div>
              <script>
              function showmodal() {
                if (document.getElementById("<xsl:value-of select="$modelnevrId"/>").classList.contains('hidemodal')) {
                    document.getElementById("<xsl:value-of select="$modelnevrId"/>").classList.remove('hidemodal');
                  } else {
                    document.getElementById("<xsl:value-of select="$modelnevrId"/>").classList.add('showmodal');
                }
                }

              function windowOnClick(event) {
                 if (event.target === document.getElementById("<xsl:value-of select="$modelnevrId"/>")) {
                 if (document.getElementById("<xsl:value-of select="$modelnevrId"/>").classList.contains('showmodal')) {
                     document.getElementById("<xsl:value-of select="$modelnevrId"/>").classList.remove('showmodal');
                   } else {
                     document.getElementById("<xsl:value-of select="$modelnevrId"/>").classList.add('hidemodal');
                 }
                 }
              }

              function hidemodal() {
              if (document.getElementById("<xsl:value-of select="$modelnevrId"/>").classList.contains('showmodal')) {
                  document.getElementById("<xsl:value-of select="$modelnevrId"/>").classList.remove('showmodal');
                } else {
                  document.getElementById("<xsl:value-of select="$modelnevrId"/>").classList.add('hidemodal');
              }
              }

              document.getElementById("<xsl:value-of select="$triggernevrId"/>").addEventListener("click", showmodal);
              document.getElementById("<xsl:value-of select="$closenevrId"/>").addEventListener("click", hidemodal);
              window.addEventListener("click", windowOnClick);
              </script>
            </div>



            <xsl:variable name="targetpaleograre" select="concat('#pa#', '000-00', '#')"/>
            <xsl:variable name="triggernereId" select="concat('trigger_',$targetpaleograre)"/>
            <xsl:variable name="modelnereId" select="concat('model_',$targetpaleograre)"/>
            <xsl:variable name="closenereId" select="concat('close_',$targetpaleograre)"/>

            <xsl:if test="//note[@type='paleogra'][contains($targetpaleograre, concat('#pa', @target, '#'))]">
            <div class="trigger triggerne" id="{$triggernereId}" title="Nota paleográfica">P</div>
            </xsl:if>

            <div class="modal" id="{$modelnereId}"><div class="modal-content">
                <span class="close-button" id="{$closenereId}" title="Fechar">⨯</span>
                <xsl:apply-templates select="//note[@type='paleogra'][contains($targetpaleograre, concat('#pa', @target, '#'))]"/>
              </div>
              <script>
              function showmodal() {
                if (document.getElementById("<xsl:value-of select="$modelnereId"/>").classList.contains('hidemodal')) {
                    document.getElementById("<xsl:value-of select="$modelnereId"/>").classList.remove('hidemodal');
                  } else {
                    document.getElementById("<xsl:value-of select="$modelnereId"/>").classList.add('showmodal');
                }
                }

              function windowOnClick(event) {
                 if (event.target === document.getElementById("<xsl:value-of select="$modelnereId"/>")) {
                 if (document.getElementById("<xsl:value-of select="$modelnereId"/>").classList.contains('showmodal')) {
                     document.getElementById("<xsl:value-of select="$modelnereId"/>").classList.remove('showmodal');
                   } else {
                     document.getElementById("<xsl:value-of select="$modelnereId"/>").classList.add('hidemodal');
                 }
                 }
              }

              function hidemodal() {
              if (document.getElementById("<xsl:value-of select="$modelnereId"/>").classList.contains('showmodal')) {
                  document.getElementById("<xsl:value-of select="$modelnereId"/>").classList.remove('showmodal');
                } else {
                  document.getElementById("<xsl:value-of select="$modelnereId"/>").classList.add('hidemodal');
              }
              }

              document.getElementById("<xsl:value-of select="$triggernereId"/>").addEventListener("click", showmodal);
              document.getElementById("<xsl:value-of select="$closenereId"/>").addEventListener("click", hidemodal);
              window.addEventListener("click", windowOnClick);
              </script>
            </div>

            <xsl:variable name="targetvarian" select="concat('#va#', '000-00', '#')"/>
            <xsl:variable name="triggernevaId" select="concat('trigger_',$targetvarian)"/>
            <xsl:variable name="modelnevaId" select="concat('model_',$targetvarian)"/>
            <xsl:variable name="closenevaId" select="concat('close_',$targetvarian)"/>

            <xsl:if test="//note[@type='variante'][contains($targetvarian, concat('#va', @target, '#'))]">
            <div class="trigger triggerva" id="{$triggernevaId}" title="Variante">V</div>
            </xsl:if>

            <div class="modal" id="{$modelnevaId}"><div class="modal-content">
                <span class="close-button" id="{$closenevaId}" title="Fechar">⨯</span>
                <xsl:apply-templates select="//note[@type='variante'][contains($targetvarian, concat('#va', @target, '#'))]"/>
              </div>
              <script>
              function showmodal() {
                if (document.getElementById("<xsl:value-of select="$modelnevaId"/>").classList.contains('hidemodal')) {
                    document.getElementById("<xsl:value-of select="$modelnevaId"/>").classList.remove('hidemodal');
                  } else {
                    document.getElementById("<xsl:value-of select="$modelnevaId"/>").classList.add('showmodal');
                }
                }

              function windowOnClick(event) {
                 if (event.target === document.getElementById("<xsl:value-of select="$modelnevaId"/>")) {
                 if (document.getElementById("<xsl:value-of select="$modelnevaId"/>").classList.contains('showmodal')) {
                     document.getElementById("<xsl:value-of select="$modelnevaId"/>").classList.remove('showmodal');
                   } else {
                     document.getElementById("<xsl:value-of select="$modelnevaId"/>").classList.add('hidemodal');
                 }
                 }
              }

              function hidemodal() {
              if (document.getElementById("<xsl:value-of select="$modelnevaId"/>").classList.contains('showmodal')) {
                  document.getElementById("<xsl:value-of select="$modelnevaId"/>").classList.remove('showmodal');
                } else {
                  document.getElementById("<xsl:value-of select="$modelnevaId"/>").classList.add('hidemodal');
              }
              }

              document.getElementById("<xsl:value-of select="$triggernevaId"/>").addEventListener("click", showmodal);
              document.getElementById("<xsl:value-of select="$closenevaId"/>").addEventListener("click", hidemodal);
              window.addEventListener("click", windowOnClick);
              </script>
            </div>
            </td>
          <td class="lateral2"></td>

          <td class="lateral3">
            <xsl:choose>
              <xsl:when test="//TEI/teiHeader/fileDesc/editionStmt/edition = 'Transcrición paleográfica'">
                <span class="lat3refranpaleo">
                  <xsl:for-each select="p">
                    <div>
                      <xsl:apply-templates/>
                    </div>
                  </xsl:for-each>
                </span>
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates/>
              </xsl:otherwise>
            </xsl:choose>
        </td>
      </tr>
      </table>
    </xsl:template> -->

    <xsl:template match="div[@type='rubrica']">
      <table class="taboa versos" style="font-size: 110%;">
        <xsl:apply-templates/>
      </table>
    </xsl:template>

    <xsl:template match="div[@type='rubrica']/p">
      <tr>
        <td class="lateral1">

          <xsl:variable name="targetnotaversre" select="concat('#nv#', translate(@xml:id, '-', ''), '#')"/>
          <xsl:variable name="triggernevrId" select="concat('trigger_',$targetnotaversre)"/>
          <xsl:variable name="modelnevrId" select="concat('model_',$targetnotaversre)"/>
          <xsl:variable name="closenevrId" select="concat('close_',$targetnotaversre)"/>

          <xsl:if test="//note[@type='notavers'][contains($targetnotaversre, concat('#nv#', translate(@target, '-', ''), '#'))]">
          <div class="trigger triggervr" id="{$triggernevrId}" title="Nota ao verso">N</div>
          </xsl:if>

          <div class="modal" id="{$modelnevrId}"><div class="modal-content">
              <span class="close-button" id="{$closenevrId}" title="Fechar">⨯</span>
              <xsl:apply-templates select="//note[@type='notavers'][contains($targetnotaversre, concat('#nv#', translate(@target, '-', ''), '#'))]"/>
            </div>
            <script>
            function showmodal() {
              if (document.getElementById("<xsl:value-of select="$modelnevrId"/>").classList.contains('hidemodal')) {
                  document.getElementById("<xsl:value-of select="$modelnevrId"/>").classList.remove('hidemodal');
                } else {
                  document.getElementById("<xsl:value-of select="$modelnevrId"/>").classList.add('showmodal');
              }
              }

            function windowOnClick(event) {
               if (event.target === document.getElementById("<xsl:value-of select="$modelnevrId"/>")) {
               if (document.getElementById("<xsl:value-of select="$modelnevrId"/>").classList.contains('showmodal')) {
                   document.getElementById("<xsl:value-of select="$modelnevrId"/>").classList.remove('showmodal');
                 } else {
                   document.getElementById("<xsl:value-of select="$modelnevrId"/>").classList.add('hidemodal');
               }
               }
            }

            function hidemodal() {
            if (document.getElementById("<xsl:value-of select="$modelnevrId"/>").classList.contains('showmodal')) {
                document.getElementById("<xsl:value-of select="$modelnevrId"/>").classList.remove('showmodal');
              } else {
                document.getElementById("<xsl:value-of select="$modelnevrId"/>").classList.add('hidemodal');
            }
            }

            document.getElementById("<xsl:value-of select="$triggernevrId"/>").addEventListener("click", showmodal);
            document.getElementById("<xsl:value-of select="$closenevrId"/>").addEventListener("click", hidemodal);
            window.addEventListener("click", windowOnClick);
            </script>
          </div>



          <xsl:variable name="targetpaleograre" select="concat('#pa#', translate(@xml:id, '-', ''), '#')"/>
          <xsl:variable name="triggernereId" select="concat('trigger_',$targetpaleograre)"/>
          <xsl:variable name="modelnereId" select="concat('model_',$targetpaleograre)"/>
          <xsl:variable name="closenereId" select="concat('close_',$targetpaleograre)"/>

          <xsl:if test="//note[@type='paleogra'][contains($targetpaleograre, concat('#pa#', translate(@target, '-', ''), '#'))]">
          <div class="trigger triggerne" id="{$triggernereId}" title="Nota paleográfica">P</div>
          </xsl:if>

          <div class="modal" id="{$modelnereId}"><div class="modal-content">
              <span class="close-button" id="{$closenereId}" title="Fechar">⨯</span>
              <xsl:apply-templates select="//note[@type='paleogra'][contains($targetpaleograre, concat('#pa#', translate(@target, '-', ''), '#'))]"/>
            </div>
            <script>
            function showmodal() {
              if (document.getElementById("<xsl:value-of select="$modelnereId"/>").classList.contains('hidemodal')) {
                  document.getElementById("<xsl:value-of select="$modelnereId"/>").classList.remove('hidemodal');
                } else {
                  document.getElementById("<xsl:value-of select="$modelnereId"/>").classList.add('showmodal');
              }
              }

            function windowOnClick(event) {
               if (event.target === document.getElementById("<xsl:value-of select="$modelnereId"/>")) {
               if (document.getElementById("<xsl:value-of select="$modelnereId"/>").classList.contains('showmodal')) {
                   document.getElementById("<xsl:value-of select="$modelnereId"/>").classList.remove('showmodal');
                 } else {
                   document.getElementById("<xsl:value-of select="$modelnereId"/>").classList.add('hidemodal');
               }
               }
            }

            function hidemodal() {
            if (document.getElementById("<xsl:value-of select="$modelnereId"/>").classList.contains('showmodal')) {
                document.getElementById("<xsl:value-of select="$modelnereId"/>").classList.remove('showmodal');
              } else {
                document.getElementById("<xsl:value-of select="$modelnereId"/>").classList.add('hidemodal');
            }
            }

            document.getElementById("<xsl:value-of select="$triggernereId"/>").addEventListener("click", showmodal);
            document.getElementById("<xsl:value-of select="$closenereId"/>").addEventListener("click", hidemodal);
            window.addEventListener("click", windowOnClick);
            </script>
          </div>

          <xsl:variable name="targetvarian" select="concat('#va#', translate(@xml:id, '-', ''), '#')"/>
          <xsl:variable name="triggernevaId" select="concat('trigger_',$targetvarian)"/>
          <xsl:variable name="modelnevaId" select="concat('model_',$targetvarian)"/>
          <xsl:variable name="closenevaId" select="concat('close_',$targetvarian)"/>

          <xsl:if test="//note[@type='variante'][contains($targetvarian, concat('#va#', translate(@target, '-', ''), '#'))]">
          <div class="trigger triggerva" id="{$triggernevaId}" title="Variante">V</div>
          </xsl:if>

          <div class="modal" id="{$modelnevaId}"><div class="modal-content">
              <span class="close-button" id="{$closenevaId}" title="Fechar">⨯</span>
              <xsl:apply-templates select="//note[@type='variante'][contains($targetvarian, concat('#va#', translate(@target, '-', ''), '#'))]"/>
            </div>
            <script>
            function showmodal() {
              if (document.getElementById("<xsl:value-of select="$modelnevaId"/>").classList.contains('hidemodal')) {
                  document.getElementById("<xsl:value-of select="$modelnevaId"/>").classList.remove('hidemodal');
                } else {
                  document.getElementById("<xsl:value-of select="$modelnevaId"/>").classList.add('showmodal');
              }
              }

            function windowOnClick(event) {
               if (event.target === document.getElementById("<xsl:value-of select="$modelnevaId"/>")) {
               if (document.getElementById("<xsl:value-of select="$modelnevaId"/>").classList.contains('showmodal')) {
                   document.getElementById("<xsl:value-of select="$modelnevaId"/>").classList.remove('showmodal');
                 } else {
                   document.getElementById("<xsl:value-of select="$modelnevaId"/>").classList.add('hidemodal');
               }
               }
            }

            function hidemodal() {
            if (document.getElementById("<xsl:value-of select="$modelnevaId"/>").classList.contains('showmodal')) {
                document.getElementById("<xsl:value-of select="$modelnevaId"/>").classList.remove('showmodal');
              } else {
                document.getElementById("<xsl:value-of select="$modelnevaId"/>").classList.add('hidemodal');
            }
            }

            document.getElementById("<xsl:value-of select="$triggernevaId"/>").addEventListener("click", showmodal);
            document.getElementById("<xsl:value-of select="$closenevaId"/>").addEventListener("click", hidemodal);
            window.addEventListener("click", windowOnClick);
            </script>
          </div>
          </td>
        <td class="lateral2"></td>

        <td class="lateral3">
          <xsl:choose>
            <xsl:when test="//TEI/teiHeader/fileDesc/editionStmt/edition = 'Transcrición paleográfica'">
              <span class="lat3refranpaleo">
                <xsl:for-each select=".">
                  <div>
                    <xsl:apply-templates/>
                  </div>
                </xsl:for-each>
              </span>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates/>
            </xsl:otherwise>
          </xsl:choose>
      </td>
    </tr>
    </xsl:template>

    <xsl:template match="lg[@type='refraninicial' or @type='cobra']">
        <table class="taboa versos">
          <xsl:apply-templates/>
        </table>
    </xsl:template>



    <xsl:template match="lg[@type='cobra' or @type='refraninicial']/l">
      <xsl:if test="l = not(node())">
        <tr class="verso">
          <td class="lateral1">

            <xsl:variable name="targetnotaversre" select="concat('#nv#', translate(@xml:id, '-', ''), '#')"/>
            <xsl:variable name="triggernevrId" select="concat('trigger_',$targetnotaversre)"/>
            <xsl:variable name="modelnevrId" select="concat('model_',$targetnotaversre)"/>
            <xsl:variable name="closenevrId" select="concat('close_',$targetnotaversre)"/>

            <xsl:if test="//note[@type='notavers'][contains($targetnotaversre, concat('#nv#', translate(@target, '-', ''), '#'))]">
            <div class="trigger triggervr" id="{$triggernevrId}" title="Nota ao verso">N</div>
            </xsl:if>

            <div class="modal" id="{$modelnevrId}"><div class="modal-content">
              <span class="close-button" id="{$closenevrId}" title="Fechar">⨯</span>
              <xsl:apply-templates select="//note[@type='notavers'][contains($targetnotaversre, concat('#nv#', translate(@target, '-', ''), '#'))]"/>
            </div>
            <script>
              function showmodal() {
                if (document.getElementById("<xsl:value-of select="$modelnevrId"/>").classList.contains('hidemodal')) {
                    document.getElementById("<xsl:value-of select="$modelnevrId"/>").classList.remove('hidemodal');
                  } else {
                    document.getElementById("<xsl:value-of select="$modelnevrId"/>").classList.add('showmodal');
                }
                }

              function windowOnClick(event) {
                 if (event.target === document.getElementById("<xsl:value-of select="$modelnevrId"/>")) {
                 if (document.getElementById("<xsl:value-of select="$modelnevrId"/>").classList.contains('showmodal')) {
                     document.getElementById("<xsl:value-of select="$modelnevrId"/>").classList.remove('showmodal');
                   } else {
                     document.getElementById("<xsl:value-of select="$modelnevrId"/>").classList.add('hidemodal');
                 }
                 }
              }

              function hidemodal() {
              if (document.getElementById("<xsl:value-of select="$modelnevrId"/>").classList.contains('showmodal')) {
                  document.getElementById("<xsl:value-of select="$modelnevrId"/>").classList.remove('showmodal');
                } else {
                  document.getElementById("<xsl:value-of select="$modelnevrId"/>").classList.add('hidemodal');
              }
              }

              document.getElementById("<xsl:value-of select="$triggernevrId"/>").addEventListener("click", showmodal);
              document.getElementById("<xsl:value-of select="$closenevrId"/>").addEventListener("click", hidemodal);
              window.addEventListener("click", windowOnClick);
            </script>
          </div>



          <xsl:variable name="targetpaleograre" select="concat('#pa#', translate(@xml:id, '-', ''), '#')"/>
          <xsl:variable name="triggernereId" select="concat('trigger_',$targetpaleograre)"/>
          <xsl:variable name="modelnereId" select="concat('model_',$targetpaleograre)"/>
          <xsl:variable name="closenereId" select="concat('close_',$targetpaleograre)"/>

          <xsl:if test="//note[@type='paleogra'][contains($targetpaleograre, concat('#pa#', translate(@target, '-', ''), '#'))]">
            <div class="trigger triggerne" id="{$triggernereId}" title="Nota paleográfica">P</div>
          </xsl:if>

          <div class="modal" id="{$modelnereId}"><div class="modal-content">
              <span class="close-button" id="{$closenereId}" title="Fechar">⨯</span>
              <xsl:apply-templates select="//note[@type='paleogra'][contains($targetpaleograre, concat('#pa#', translate(@target, '-', ''), '#'))]"/>
            </div>
            <script>
              function showmodal() {
                if (document.getElementById("<xsl:value-of select="$modelnereId"/>").classList.contains('hidemodal')) {
                    document.getElementById("<xsl:value-of select="$modelnereId"/>").classList.remove('hidemodal');
                  } else {
                    document.getElementById("<xsl:value-of select="$modelnereId"/>").classList.add('showmodal');
                }
                }

              function windowOnClick(event) {
                 if (event.target === document.getElementById("<xsl:value-of select="$modelnereId"/>")) {
                 if (document.getElementById("<xsl:value-of select="$modelnereId"/>").classList.contains('showmodal')) {
                     document.getElementById("<xsl:value-of select="$modelnereId"/>").classList.remove('showmodal');
                   } else {
                     document.getElementById("<xsl:value-of select="$modelnereId"/>").classList.add('hidemodal');
                 }
                 }
              }

              function hidemodal() {
              if (document.getElementById("<xsl:value-of select="$modelnereId"/>").classList.contains('showmodal')) {
                  document.getElementById("<xsl:value-of select="$modelnereId"/>").classList.remove('showmodal');
                } else {
                  document.getElementById("<xsl:value-of select="$modelnereId"/>").classList.add('hidemodal');
              }
              }

              document.getElementById("<xsl:value-of select="$triggernereId"/>").addEventListener("click", showmodal);
              document.getElementById("<xsl:value-of select="$closenereId"/>").addEventListener("click", hidemodal);
              window.addEventListener("click", windowOnClick);
            </script>
          </div>



          <xsl:variable name="targetvarian" select="concat('#va#', translate(@xml:id, '-', ''), '#')"/>
          <xsl:variable name="triggernevaId" select="concat('trigger_',$targetvarian)"/>
          <xsl:variable name="modelnevaId" select="concat('model_',$targetvarian)"/>
          <xsl:variable name="closenevaId" select="concat('close_',$targetvarian)"/>

          <xsl:if test="//note[@type='variante'][contains($targetvarian, concat('#va#', translate(@target, '-', ''), '#'))]">
            <div class="trigger triggerva" id="{$triggernevaId}" title="Variante">V</div>
          </xsl:if>

          <div class="modal" id="{$modelnevaId}"><div class="modal-content">
            <span class="close-button" id="{$closenevaId}" title="Fechar">⨯</span>
            <xsl:apply-templates select="//note[@type='variante'][contains($targetvarian, concat('#va#', translate(@target, '-', ''), '#'))]"/>
          </div>
          <script>
            function showmodal() {
              if (document.getElementById("<xsl:value-of select="$modelnevaId"/>").classList.contains('hidemodal')) {
                  document.getElementById("<xsl:value-of select="$modelnevaId"/>").classList.remove('hidemodal');
                } else {
                  document.getElementById("<xsl:value-of select="$modelnevaId"/>").classList.add('showmodal');
              }
              }

            function windowOnClick(event) {
               if (event.target === document.getElementById("<xsl:value-of select="$modelnevaId"/>")) {
               if (document.getElementById("<xsl:value-of select="$modelnevaId"/>").classList.contains('showmodal')) {
                   document.getElementById("<xsl:value-of select="$modelnevaId"/>").classList.remove('showmodal');
                 } else {
                   document.getElementById("<xsl:value-of select="$modelnevaId"/>").classList.add('hidemodal');
               }
               }
            }

            function hidemodal() {
            if (document.getElementById("<xsl:value-of select="$modelnevaId"/>").classList.contains('showmodal')) {
                document.getElementById("<xsl:value-of select="$modelnevaId"/>").classList.remove('showmodal');
              } else {
                document.getElementById("<xsl:value-of select="$modelnevaId"/>").classList.add('hidemodal');
            }
            }

            document.getElementById("<xsl:value-of select="$triggernevaId"/>").addEventListener("click", showmodal);
            document.getElementById("<xsl:value-of select="$closenevaId"/>").addEventListener("click", hidemodal);
            window.addEventListener("click", windowOnClick);
            </script>
          </div>
        </td>
        <td class="lateral2">
          <xsl:if test="@n[substring(., string-length(.), 1) = 5] or @n[substring(., string-length(.), 1) = 0]"><span class="num05"><xsl:value-of select="number(@n)"/></span></xsl:if>
          <xsl:if test="@n[substring(., string-length(.), 1) = 1] or @n[substring(., string-length(.), 1) = 2] or @n[substring(., string-length(.), 1) = 3] or @n[substring(., string-length(.), 1) = 4] or @n[substring(., string-length(.), 1) = 6] or @n[substring(., string-length(.), 1) = 7] or @n[substring(., string-length(.), 1) = 8] or @n[substring(., string-length(.), 1) = 9]"><span class="num1234"><xsl:value-of select="number(@n)"/></span></xsl:if>
        </td>
        <td class="lateral3">
          <xsl:choose>
            <xsl:when test="ancestor::div[@type='refraninicial'] and //TEI/teiHeader/fileDesc/editionStmt/edition != 'Transcrición paleográfica'">
              <span class="lat3refran">
                <xsl:apply-templates/>
              </span>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates/>
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
    </xsl:if>
  </xsl:template>

    <xsl:template match="lg[@type='refran']/l">
      <xsl:if test="l = not(node())">
        <tr class="verso versorefran">
          <td class="lateral1">

            <xsl:variable name="targetnotaversre" select="concat('#nv#', @xml:id, '#')"/>
            <xsl:variable name="triggernevrId" select="concat('trigger_',$targetnotaversre)"/>
            <xsl:variable name="modelnevrId" select="concat('model_',$targetnotaversre)"/>
            <xsl:variable name="closenevrId" select="concat('close_',$targetnotaversre)"/>

            <xsl:if test="//note[@type='notavers'][contains($targetnotaversre, concat('#nv#', @target, '#'))]">
            <div class="trigger triggervr" id="{$triggernevrId}" title="Nota ao verso">N</div>
            </xsl:if>

            <div class="modal" id="{$modelnevrId}"><div class="modal-content">
                <span class="close-button" id="{$closenevrId}" title="Fechar">⨯</span>
                <xsl:apply-templates select="//note[@type='notavers'][contains($targetnotaversre, concat('#nv#', @target, '#'))]"/>
              </div>
              <script>
              function showmodal() {
                if (document.getElementById("<xsl:value-of select="$modelnevrId"/>").classList.contains('hidemodal')) {
                    document.getElementById("<xsl:value-of select="$modelnevrId"/>").classList.remove('hidemodal');
                  } else {
                    document.getElementById("<xsl:value-of select="$modelnevrId"/>").classList.add('showmodal');
                }
                }

              function windowOnClick(event) {
                 if (event.target === document.getElementById("<xsl:value-of select="$modelnevrId"/>")) {
                 if (document.getElementById("<xsl:value-of select="$modelnevrId"/>").classList.contains('showmodal')) {
                     document.getElementById("<xsl:value-of select="$modelnevrId"/>").classList.remove('showmodal');
                   } else {
                     document.getElementById("<xsl:value-of select="$modelnevrId"/>").classList.add('hidemodal');
                 }
                 }
              }

              function hidemodal() {
              if (document.getElementById("<xsl:value-of select="$modelnevrId"/>").classList.contains('showmodal')) {
                  document.getElementById("<xsl:value-of select="$modelnevrId"/>").classList.remove('showmodal');
                } else {
                  document.getElementById("<xsl:value-of select="$modelnevrId"/>").classList.add('hidemodal');
              }
              }

              document.getElementById("<xsl:value-of select="$triggernevrId"/>").addEventListener("click", showmodal);
              document.getElementById("<xsl:value-of select="$closenevrId"/>").addEventListener("click", hidemodal);
              window.addEventListener("click", windowOnClick);
              </script>
            </div>


            <xsl:variable name="targetpaleograre" select="concat('#pa#', @xml:id, '#')"/>
            <xsl:variable name="triggernereId" select="concat('trigger_',$targetpaleograre)"/>
            <xsl:variable name="modelnereId" select="concat('model_',$targetpaleograre)"/>
            <xsl:variable name="closenereId" select="concat('close_',$targetpaleograre)"/>

            <xsl:if test="//note[@type='paleogra'][contains($targetpaleograre, concat('#pa#', @target, '#'))]">
            <div class="trigger triggerne" id="{$triggernereId}" title="Nota paleográfica">P</div>
            </xsl:if>

            <div class="modal" id="{$modelnereId}"><div class="modal-content">
                <span class="close-button" id="{$closenereId}" title="Fechar">⨯</span>
                <xsl:for-each select="//note[@type='paleogra'][contains($targetpaleograre, concat('#pa#', @target, '#'))]"><p>
                  <xsl:apply-templates/>
                </p></xsl:for-each>
            </div>
              <script>
              function showmodal() {
                if (document.getElementById("<xsl:value-of select="$modelnereId"/>").classList.contains('hidemodal')) {
                    document.getElementById("<xsl:value-of select="$modelnereId"/>").classList.remove('hidemodal');
                  } else {
                    document.getElementById("<xsl:value-of select="$modelnereId"/>").classList.add('showmodal');
                }
                }

              function windowOnClick(event) {
                 if (event.target === document.getElementById("<xsl:value-of select="$modelnereId"/>")) {
                 if (document.getElementById("<xsl:value-of select="$modelnereId"/>").classList.contains('showmodal')) {
                     document.getElementById("<xsl:value-of select="$modelnereId"/>").classList.remove('showmodal');
                   } else {
                     document.getElementById("<xsl:value-of select="$modelnereId"/>").classList.add('hidemodal');
                 }
                 }
              }

              function hidemodal() {
              if (document.getElementById("<xsl:value-of select="$modelnereId"/>").classList.contains('showmodal')) {
                  document.getElementById("<xsl:value-of select="$modelnereId"/>").classList.remove('showmodal');
                } else {
                  document.getElementById("<xsl:value-of select="$modelnereId"/>").classList.add('hidemodal');
              }
              }

              document.getElementById("<xsl:value-of select="$triggernereId"/>").addEventListener("click", showmodal);
              document.getElementById("<xsl:value-of select="$closenereId"/>").addEventListener("click", hidemodal);
              window.addEventListener("click", windowOnClick);
              </script>
            </div>



            <xsl:variable name="targetvarian" select="concat('#va#', @xml:id, '#')"/>
            <xsl:variable name="triggernevaId" select="concat('trigger_',$targetvarian)"/>
            <xsl:variable name="modelnevaId" select="concat('model_',$targetvarian)"/>
            <xsl:variable name="closenevaId" select="concat('close_',$targetvarian)"/>

            <xsl:if test="//note[@type='variante'][contains($targetvarian, concat('#va#', @target, '#'))]">
            <div class="trigger triggerva" id="{$triggernevaId}" title="Variante">V</div>
            </xsl:if>

            <div class="modal" id="{$modelnevaId}"><div class="modal-content">
                <span class="close-button" id="{$closenevaId}" title="Fechar">⨯</span>
                <xsl:apply-templates select="//note[@type='variante'][contains($targetvarian, concat('#va#', @target, '#'))]"/>
              </div>
              <script>
              function showmodal() {
                if (document.getElementById("<xsl:value-of select="$modelnevaId"/>").classList.contains('hidemodal')) {
                    document.getElementById("<xsl:value-of select="$modelnevaId"/>").classList.remove('hidemodal');
                  } else {
                    document.getElementById("<xsl:value-of select="$modelnevaId"/>").classList.add('showmodal');
                }
                }

              function windowOnClick(event) {
                 if (event.target === document.getElementById("<xsl:value-of select="$modelnevaId"/>")) {
                 if (document.getElementById("<xsl:value-of select="$modelnevaId"/>").classList.contains('showmodal')) {
                     document.getElementById("<xsl:value-of select="$modelnevaId"/>").classList.remove('showmodal');
                   } else {
                     document.getElementById("<xsl:value-of select="$modelnevaId"/>").classList.add('hidemodal');
                 }
                 }
              }

              function hidemodal() {
              if (document.getElementById("<xsl:value-of select="$modelnevaId"/>").classList.contains('showmodal')) {
                  document.getElementById("<xsl:value-of select="$modelnevaId"/>").classList.remove('showmodal');
                } else {
                  document.getElementById("<xsl:value-of select="$modelnevaId"/>").classList.add('hidemodal');
              }
              }

              document.getElementById("<xsl:value-of select="$triggernevaId"/>").addEventListener("click", showmodal);
              document.getElementById("<xsl:value-of select="$closenevaId"/>").addEventListener("click", hidemodal);
              window.addEventListener("click", windowOnClick);
              </script>
            </div>
          </td>
          <td class="lateral2 lat2refran">
            <xsl:if test="@n[substring(., string-length(.), 1) = 5] or @n[substring(., string-length(.), 1) = 0]"><span class="num05"><xsl:value-of select="number(@n)"/></span></xsl:if>
            <xsl:if test="@n[substring(., string-length(.), 1) = 1] or @n[substring(., string-length(.), 1) = 2] or @n[substring(., string-length(.), 1) = 3] or @n[substring(., string-length(.), 1) = 4] or @n[substring(., string-length(.), 1) = 6] or @n[substring(., string-length(.), 1) = 7] or @n[substring(., string-length(.), 1) = 8] or @n[substring(., string-length(.), 1) = 9]"><span class="num1234"><xsl:value-of select="number(@n)"/></span></xsl:if>
          </td>
          <td class="lateral3">
            <xsl:choose>
              <xsl:when test="//edition = 'Transcrición paleográfica' and parent::lg[@type='refran']/@n[substring(., string-length(.), 1) = 0]">
                <span class="lat3refranpaleo">
                  <xsl:if test='not(@n)'>
                    <xsl:attribute name="style">margin-left:1em</xsl:attribute>
                  </xsl:if>
                  <xsl:apply-templates/>
                </span>
            </xsl:when>
            <xsl:otherwise>
              <span class="lat3refran"><xsl:apply-templates/></span>
            </xsl:otherwise>
          </xsl:choose>
          </td>
        </tr>
      </xsl:if>
    </xsl:template>

    <xsl:template match="div[@type='rubricaexplicativa']">
      <table class="taboa versos" style="font-size: 110%;">
        <tr>
          <td class="lateral1"></td>
          <td class="lateral2"></td>
          <td class="lateral3">
            <xsl:apply-templates/>
          </td>
        </tr>
      </table>
    </xsl:template>

    <!-- TEXTO - CHOICES -->

    <xsl:template match="choice">
      <xsl:choose>
        <xsl:when test="sic">
          <span class="tooltipabaixo">
            <span class="siccorr"><xsl:apply-templates select="corr"/></span><span class="tooltiptextabaixo">«<xsl:value-of select="sic"/>» foi corrixido na transcrición.<!--por «<xsl:value-of select="corr"/>»--></span>
          </span>
        </xsl:when>
        <xsl:when test="orig">
          <span class="origrel">
            <span class="orig"><xsl:apply-templates select="orig"/></span>
            <span class="reg"><xsl:value-of select="reg"/><!--por «<xsl:value-of select="corr"/>»--></span>
          </span>
        </xsl:when>
        <xsl:when test="abbr">
          <!-- Ensina ambas -->
          <span class="tooltip tooltipabbr">
                <xsl:apply-templates select="abbr"/><span class="tooltiptext"><xsl:value-of select="expan"/></span>
          </span>
          <span class="desenvolvimento"><xsl:value-of select="expan"/></span>
          <!-- Ensina apenas abbr
          <span class="tooltip">
              <span class="choice"><xsl:value-of select="abbr"/></span><span class="tooltiptext">Abreviatura de «<xsl:value-of select="expan"/>»&#160;(<xsl:value-of select="abbr/@type"/>)</span>
          </span> -->
        </xsl:when>
      </xsl:choose>
    </xsl:template>


    <!-- TEXTO - SUBSTITUCIÓNS (subst, add, del) -->

    <xsl:template match="subst[child::del[@type='raspadura']]" priority="15">
      <xsl:choose>
        <xsl:when test="del != ''">
          <span class="tooltipsubsti">
            <span class="subst"><xsl:apply-templates select="add"/></span><span class="tooltiptextsubsti">Escrito sobre un «<xsl:value-of select="del"/>» raspado</span>
          </span>
        </xsl:when>
        <xsl:otherwise>
          <span class="tooltipsubsti">
            <span class="subst"><xsl:apply-templates select="add"/></span><span class="tooltiptextsubsti">Raspadura</span>
          </span>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:template>

    <xsl:template match="subst[child::del[@type='debaixo']]">
      <span class="tooltipsubsti">
        <span class="subst"><xsl:apply-templates select="add[@type='refeito']"/></span>
        <span class="tooltiptextsubsti">
          «<xsl:choose>
            <xsl:when test="add[@type='refeito'][child::choice]">
              <xsl:value-of select="add[@type='refeito']/choice/abbr"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="add[@type='refeito']"/>
            </xsl:otherwise>
        </xsl:choose>» refeito<xsl:if test="string(del[@type='debaixo'])"> sobre «<xsl:value-of select="del[@type='debaixo']"/>»</xsl:if>
        </span>
      </span>
    </xsl:template>

    <xsl:template match="del[@type='raspadura'][@subtype= 'parcial']">
      <span class="tooltipsubsti">
        <span class="delrasppar"><xsl:apply-templates/></span><span class="tooltiptextsubsti">«<xsl:value-of select="."/>» visible eliminado por raspadura</span>
      </span>
    </xsl:template>

    <xsl:template match="del[@type='riscada']">
      <span class="tooltipsubsti">
        <span class="delrisc"><xsl:apply-templates/></span><span class="tooltiptextsubsti">Eliminación indicada por risca</span>
      </span>
    </xsl:template>

    <xsl:template match="del[@type='punto']">
      <span class="tooltipsubsti">
        <span class="delpunto"><xsl:apply-templates/></span><span class="tooltiptextsubsti">Eliminación indicada por puntos</span>
      </span>
    </xsl:template>

    <xsl:template match="del[@type='puntoarriba']">
      <span class="tooltipsubsti">
        <span class="delpuntoarriba"><xsl:apply-templates/></span><span class="tooltiptextsubsti">Eliminación indicada por puntos na parte superior</span>
      </span>
    </xsl:template>

    <xsl:template match="add[@type='arriba']">
      <span class="tooltipsubsti">
        <span class="addarr"><xsl:apply-templates/></span><span class="tooltiptextsubsti">Engadido por encima</span>
      </span>
    </xsl:template>

    <xsl:template match="add[@type='abaixo']">
      <span class="tooltipsubsti">
        <span class="addaba"><xsl:apply-templates/></span><span class="tooltiptextsubsti">Engadido por debaixo</span>
      </span>
    </xsl:template>

    <xsl:template match="add[@type='marxe']">
      <div class="tooltipsubsti">
        <span class="addmar"><xsl:apply-templates/></span><span class="tooltiptextsubsti">Engadido na marxe</span>
      </div>
    </xsl:template>

    <xsl:template match="unclear" priority="30">
      <div class="tooltipabaixo">
        <span class="unclear"><xsl:apply-templates/></span><span class="tooltiptextabaixo">Marcado incerto</span>
      </div>
    </xsl:template>


    <!-- TEXTO - TIPOS DE CARACTER (c) -->

    <!-- Inicial de apertura -->
    <xsl:template match="c[@type='inicial' and @subtype='apertura' and @rend='vermello']">
      <span class="inicial iniapertura vermello"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="c[@type='inicial' and @subtype='apertura' and @rend='azul']">
      <span class="inicial iniapertura azul"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="c[@type='inicial' and @subtype='apertura' and @rend='outro']">
      <span class="inicial iniapertura negro"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="c[@type='inicial' and @subtype='apertura' and @rend='decorado']">
      <span class="inicial iniapertura inidecorado"><xsl:apply-templates/></span>
    </xsl:template>

    <!-- Inicial de inicio de cobra -->
    <xsl:template match="c[@type='inicial' and @subtype='cobra' and @rend='vermello']">
      <span class="inicial inicobra vermello"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="c[@type='inicial' and @subtype='cobra' and @rend='azul']">
      <span class="inicial inicobra azul"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="c[@type='inicial' and @subtype='cobra' and @rend='outro']">
      <span class="inicial inicobra negro"><xsl:apply-templates/></span>
    </xsl:template>

    <!-- Inicial de refran -->
    <xsl:template match="c[@type='inicial' and @subtype='refran' and @rend='vermello']">
      <span class="inicial inirefran vermello"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="c[@type='inicial' and @subtype='refran' and @rend='azul']">
      <span  class="inicial inirefran azul"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="c[@type='inicial' and @subtype='refran' and @rend='outro']">
      <span class="inicial inirefran negro"><xsl:apply-templates/></span>
    </xsl:template>

    <!-- Inicial de rúbrica -->
    <xsl:template match="c[@type='inicial' and @subtype='rubrica' and @rend='vermello']">
      <span class="inicial inirubrica vermello"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="c[@type='inicial' and @subtype='rubrica' and @rend='azul']">
      <span class="inicial inirubrica azul"><xsl:apply-templates/></span>
    </xsl:template>

    <!-- Expansivas -->
    <xsl:template match="c[@type='expansiva']">
      <span class="expansiva"><xsl:value-of select="normalize-space(.)"/></span>
    </xsl:template>

    <!-- Superíndices -->
    <xsl:template match="c[@type= 'superindice']">
      <span class="superindice"><xsl:value-of select="translate(.,'','')"/></span>
    </xsl:template>


    <!-- SALTOS -->

    <xsl:template match="lb">
      <span class="tooltip"><span class="lb extratext">/</span><span class="tooltiptext">Salto de liña</span></span>
    </xsl:template>

    <xsl:template match="cb">
      <span class="tooltip"><span class="cb extratext">//</span><span class="tooltiptext">Salto de columna</span></span>
    </xsl:template>

    <xsl:template match="pb">
      <xsl:variable name="pbname"><xsl:value-of select="substring((@xml:id), 8, 3)"/></xsl:variable>
      <span class="tooltip"><span class="pb extratext">
        /[<xsl:value-of select="number($pbname)"/><xsl:value-of select="substring((@xml:id), 11, 1)"/>]
      </span><span class="tooltiptext">Inicio do folio <xsl:value-of select="number($pbname)"/><xsl:value-of select="substring((@xml:id), 11, 1)"/></span></span>
    </xsl:template>


    <!-- SUPPLIED -->

    <xsl:template match="supplied[@evidence='letraagarda']">
      <span class="tooltip"><span class="extratext">&#60;</span><xsl:apply-templates/><span class="extratext">&#62;</span><span class="tooltiptext">Espazo con letra de agarda. «<xsl:value-of select="."/>» reconstruído.</span></span>
    </xsl:template>

    <xsl:template match="supplied[@evidence='outro']">
      <span class="tooltip"><span class="extratext">[</span><xsl:apply-templates/><span class="extratext">]</span><span class="tooltiptext">«<xsl:value-of select="."/>» reconstruído</span></span>
    </xsl:template>


    <!-- ESPAZOS (space), DANOS (damage) E CARENCIAS (gap) -->

    <!--Space-->
    <xsl:template match="space[@extent= 'rubrica']">
      <div class="tooltip">
        <span class="space extratext">[rúbrica]</span><span class="tooltiptext">Rúbrica ausente. Queda espazo en branco para ser copiada</span>
      </div>
    </xsl:template>
    <xsl:template match="space[@extent= 'refran']">
      <div class="tooltip">
        <span class="space extratext">[refrán]</span><span class="tooltiptext">Queda espazo en branco para copiar o refrán</span>
      </div>
    </xsl:template>
    <xsl:template match="space[@extent= 'verso']">
      <div class="tooltip">
        <span class="space extratext">[verso]</span><span class="tooltiptext">Queda espazo en branco para copiar o verso</span>
      </div>
    </xsl:template>
    <xsl:template match="space[@extent= 'outro']">
      <div class="tooltip">
        <div class="space extratext">
          <xsl:apply-templates/>[&#160;&#160;]</div><span class="tooltiptext">Espazo en branco</span>
      </div>
    </xsl:template>

    <!--Damage-->
    <xsl:template match="damage[@agent= 'manchas']">
      <span class="tooltip">
        <span class="damagemanchas extratext">(🞱)</span><span class="tooltiptext">Manchas</span>
      </span>
    </xsl:template>
    <xsl:template match="damage[@agent= 'accidente']">
      <span class="tooltip">
        <span class="damagemanchas extratext">(⎯)</span><span class="tooltiptext">Carencia de texto por accidente material</span>
      </span>
    </xsl:template>
    <xsl:template match="damage[@agent= 'folioperdido']">
      <span class="tooltip">
        <span class="damagemanchas extratext">(⎔)</span><span class="tooltiptext">Carencia de texto por pérdida do folio</span>
      </span>
    </xsl:template>
    <xsl:template match="damage[@agent= 'tintadesgastada']">
      <span class="tooltip">
        <span class="damagemanchas extratext">(＃)</span><span class="tooltiptext">Tinta desgastada ou pouco lexíbel</span>
      </span>
    </xsl:template>

    <!--Gap-->
    <xsl:template match="gap[@reason='saltodecolumna' and @extent='refran']">
      <div class="tooltip">
        <div class="gap extratext"><xsl:value-of select="translate('{…}','','')"/></div>
        <span class="tooltiptext">Omisión do refrán por salto de columna</span>
        </div>
      </xsl:template>
      <xsl:template match="gap[@reason='salto' and @extent='refran']">
        <div class="tooltip">
          <div class="gap extratext"><xsl:value-of select="translate('{…}','','')"/></div>
          <span class="tooltiptext">Omisión do refrán</span>
        </div>
      </xsl:template>
      <xsl:template match="gap[@extent='rubrica']">
        <div class="tooltip">
          <div class="gap extratext"><xsl:value-of select="translate('{rúbrica}','','')"/></div>
          <span class="tooltiptext">Omisión da rúbrica. Non quedou espazo para ser copiada</span>
        </div>
      </xsl:template>
      <xsl:template match="gap[@reason='saltodecolumna' and @extent='verso']">
        <div class="tooltip">
          <div class="gap extratext"><xsl:value-of select="translate('{.}','','')"/></div>
          <span class="tooltiptext">Omisión do verso por salto de columna</span>
          </div>
        </xsl:template>
        <xsl:template match="gap[@reason='saltodefolio' and @extent='verso']">
          <div class="tooltip">
            <div class="gap extratext"><xsl:value-of select="translate('{.}','','')"/></div>
            <span class="tooltiptext">Omisión do verso por inicio de novo folio</span>
          </div>
        </xsl:template>
        <xsl:template match="gap[@reason='salto' and @extent='verso']">
          <div class="tooltip">
            <div class="gap extratext"><xsl:value-of select="translate('{.}','','')"/></div>
            <span class="tooltiptext">Omisión do verso</span>
          </div>
        </xsl:template>
      <xsl:template match="gap[@reason='saltodecolumna' and @extent='outro']">
        <div class="tooltip">
          <div class="gap extratext"><xsl:value-of select="translate('{.}','','')"/></div>
          <span class="tooltiptext">Omisión de texto por salto de columna</span>
          </div>
        </xsl:template>
        <xsl:template match="gap[@reason='saltodefolio' and @extent='outro']">
          <div class="tooltip">
            <div class="gap extratext"><xsl:value-of select="translate('{.}','','')"/></div>
            <span class="tooltiptext">Omisión de texto por inicio de novo folio</span>
          </div>
        </xsl:template>
        <xsl:template match="gap[@reason='salto' and @extent='outro']">
          <div class="tooltip">
            <div class="gap extratext"><xsl:value-of select="translate('{.}','','')"/></div>
            <span class="tooltiptext">Omisión de texto</span>
          </div>
        </xsl:template>


    <!-- NOTAS -->
    <xsl:template match="note">
      <span class="nota"><xsl:apply-templates/></span>
    </xsl:template>

    <!-- Nota explicativa -->
  <!--<xsl:template match="note[@type='explicat']/link" priority="1000">
      <span>&#160;</span><a target="_blank">
        <xsl:attribute name="href">
          <xsl:value-of select="@target"/>
        </xsl:attribute>Ver máis.</a>
    </xsl:template>-->

    <xsl:template match="term[starts-with(@xml:id,'n')]">
      <xsl:variable name="targetterm" select="concat('#', @xml:id, '#')"/>
      <xsl:variable name="triggerId" select="concat('trigger_',$targetterm)"/>
      <xsl:variable name="modelId" select="concat('model_',$targetterm)"/>
      <xsl:variable name="closeId" select="concat('close_',$targetterm)"/>

      <a class="trigger triggertexto" id="{$triggerId}" title="Máis información"><xsl:value-of select="translate(.,'','')"/></a>
      <div class="modal" id="{$modelId}"><div class="modal-content">
        <span class="close-button" id="{$closeId}" title="Fechar">⨯</span>
        <strong><xsl:value-of select='.'/>:</strong><xsl:apply-templates select="//note[@type='explicat'][contains($targetterm, concat('', @target, '#'))]"/>
        </div>
        <script>
        function showmodal() {
          if (document.getElementById("<xsl:value-of select="$modelId"/>").classList.contains('hidemodal')) {
              document.getElementById("<xsl:value-of select="$modelId"/>").classList.remove('hidemodal');
            } else {
              document.getElementById("<xsl:value-of select="$modelId"/>").classList.add('showmodal');
          }      }

        function windowOnClick(event) {
           if (event.target === document.getElementById("<xsl:value-of select="$modelId"/>")) {
           if (document.getElementById("<xsl:value-of select="$modelId"/>").classList.contains('showmodal')) {
               document.getElementById("<xsl:value-of select="$modelId"/>").classList.remove('showmodal');
             } else {
               document.getElementById("<xsl:value-of select="$modelId"/>").classList.add('hidemodal');       }       }    }

        function hidemodal() {
        if (document.getElementById("<xsl:value-of select="$modelId"/>").classList.contains('showmodal')) {
            document.getElementById("<xsl:value-of select="$modelId"/>").classList.remove('showmodal');
          } else {
            document.getElementById("<xsl:value-of select="$modelId"/>").classList.add('hidemodal');    }    }

        document.getElementById("<xsl:value-of select="$triggerId"/>").addEventListener("click", showmodal);
        document.getElementById("<xsl:value-of select="$closeId"/>").addEventListener("click", hidemodal);
        window.addEventListener("click", windowOnClick);
        </script>
      </div>
    </xsl:template>


    <!-- OUTROS -->

    <xsl:template match="hi">
      <xsl:choose>
        <xsl:when test="@rend='vermello'">
          <span style="color: #AB0300 !important;">
            <xsl:apply-templates/>
          </span>
        </xsl:when>
        <xsl:when test="@rend='negro'">
          <span style="color: #000000 !important;">
            <xsl:apply-templates/>
          </span>
        </xsl:when>
        <xsl:when test="@rend='n'">
          <span style="font-weight: bold;">
            <xsl:apply-templates/>
          </span>
        </xsl:when>
        <xsl:when test="@rend='i'">
          <span style="font-style: italic;">
            <xsl:apply-templates/>
          </span>
        </xsl:when>
        <xsl:when test="@rend='v'">
          <span style="font-variant: small-caps;">
            <xsl:apply-templates/>
          </span>
        </xsl:when>
          <!-- SÓ PARA USO INTERNO, BORRAR -->
        <xsl:when test="@rend='!'">
          <div class="tooltipabaixo">
            <span style="background-color: #c483ff; color: black; font-size: 100%; font-style: normal; line-height: 100%; font-weight: bold;">[!]</span><span class="tooltiptextabaixo"><u>Editora do texto</u>: <xsl:value-of select='.'/></span>
          </div>
        </xsl:when>
        <xsl:when test="@rend='!!'">
          <div class="tooltipabaixo">
            <span style="background-color: coral; color: darkblue; font-size: 100%; font-style: normal; line-height: 100%; font-weight: bold;">[!!]</span><span class="tooltiptextabaixo"><u>Editora do XML</u>: <xsl:value-of select='.'/></span>
          </div>
        </xsl:when>
        <xsl:when test="@rend='elvira' or @rend='verdeelvira' or @rend='amareloelvira' or @rend='laranxaelvira' or @rend='azulelvira' or @rend='rosaelvira'">
          <div class="tooltipabaixo">
            <span style="color: black; font-size: 100%; font-style: normal; line-height: 100%;" class="blinkElvira"><xsl:value-of select='.'/></span><span class="tooltiptextabaixo"><strong>🟡 Marca Elvira</strong></span>
          </div>
        </xsl:when>
      </xsl:choose>
    </xsl:template>

    <xsl:template match="idno">
      <span style="font-style: italic;">
        <xsl:apply-templates/>
      </span>
    </xsl:template>





    <!-- RESTOS -->

    <!-- Este fica aqui polas peculiariedades da sintaxe
    <xsl:otherwise>
      <div class="tooltip">
        <span class="damagemanchas"><xsl:if test="not(string(.))"><span class="extratext">[- -]</span></xsl:if><xsl:if test="(string(.))"><xsl:apply-templates/></xsl:if></span><span class="tooltiptext">Accidente material</span>
      </div>
    </xsl:otherwise> -->

    <!-- Déixoo como nota para o futuro sobre a utilidade dos tooltips e das súas posicións, xa que fan posíbel que estas condicións desaparezan, quedando as raspaduras simplemente como "eliminado por rasp" cun tooltip lateral e o resto cun superior.
    <xsl:template match="del[@type='raspadura']">
      <xsl:choose>
        <xsl:when test="supplied">
          <div class="tooltipsubsti">
            <span class="delrasp space supplied"><xsl:apply-templates/></span><span class="tooltiptextsubsti">Espazo provocado por raspadura e suplido con «<xsl:value-of select="supplied"/>» na trascrición.</span>
          </div>
        </xsl:when>
        <xsl:when test="space">
          <div class="tooltipsubsti">
            <span class="delrasp space supplied"><xsl:apply-templates/></span><span class="tooltiptextsubsti">Espazo provocado por raspadura.</span>
          </div>
        </xsl:when>
        <xsl:when test="count(*|text()[string-length(normalize-space(.))>0])">
          <div class="tooltipsubsti">
            <span class="delrasp"><xsl:apply-templates/></span><span class="tooltiptextsubsti">Eliminación por raspadura</span>
          </div>
        </xsl:when>
        <xsl:otherwise>
          <div class="tooltipsubsti">
            <span class="delrasp">&#160;&#160;</span><span class="tooltiptextsubsti">Eliminación por raspadura</span></div>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:template> -->

  </xsl:stylesheet>
