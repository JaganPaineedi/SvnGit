<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
<xsl:template match="ChangeOrderResponse">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
        <link href="App_Themes/Includes/Style/Common.css?rel=3_5_x_4_1" rel="stylesheet" type="text/css" />
      </head>
      <body>
        <b>
          <u>Change Medication</u></b>
        <br />
        <b>Drug Name: </b>
        <xsl:value-of select="ChangeDrugInformation/DrugName" />
        <br />
        <b>Quantity: </b>
        <xsl:value-of select="ChangeDrugInformation/Quantity" />
        <br/>
        <b>Refills: </b>
        <xsl:value-of select="ChangeDrugInformation/Refills" />
        <br/>
        <b>DaysSupply: </b>
        <xsl:value-of select="ChangeDrugInformation/DaysSupply" />
        <br/>
        <b>Potency: </b>
        <xsl:value-of select="ChangeDrugInformation/Potency" />
        <br/>
        <b>Dispense as Written: </b>
        <xsl:value-of select="ChangeDrugInformation/DAW" />
        <br/>
        <b>Directions: </b>
        <xsl:value-of select="ChangeDrugInformation/Directions" />
        <br/>
        <b>Note: </b>
        <xsl:value-of select="ChangeDrugInformation/Note" />
        <br/>
        <b>
          <u>Prescribed Medication</u>
        </b>
        <br />
        <b>Drug Name: </b>
        <xsl:value-of select="PrescribedDrugInformation/DrugName" />
        <br />
        <b>Quantity: </b>
        <xsl:value-of select="PrescribedDrugInformation/Quantity" />
        <br/>
        <b>Refills: </b>
        <xsl:value-of select="PrescribedDrugInformation/Refills" />
        <br/>
        <b>DaysSupply: </b>
        <xsl:value-of select="PrescribedDrugInformation/DaysSupply" />
        <br/>
        <b>Potency: </b>
        <xsl:value-of select="PrescribedDrugInformation/Potency" />
        <br/>
         <b>Dispense as Written: </b>
        <xsl:value-of select="PrescribedDrugInformation/DAW" />
        <br/>
        <b>Directions: </b>
        <xsl:value-of select="PrescribedDrugInformation/Directions" />
        <br/>
        <b>Note: </b>
        <xsl:value-of select="PrescribedDrugInformation/Note" />
       <hr class="formulary" />

      </body>
    </html>
  </xsl:template>


</xsl:stylesheet>
