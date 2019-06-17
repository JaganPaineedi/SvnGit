<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <xsl:output omit-xml-declaration="yes" />
  <xsl:key name="glKey" match="GenderLimits" use="concat(ExternalMedicationId,'|',FormularyStatus,'|',Gender)" />
  <xsl:key name="adikey" match="AlternateDrugsInformation/AlternateDrugs" use="concat(Ordering,'|',AlternateExternalMedicationId,'|',AlternatePreferenceLevel,'|',MaxFormularyStatus,'|',PharmacyType,'|',FlatCopayAmount,'|',PercentCopayRate,'|',FirstCopayTerm,'|',MinimumCopay,'|',MaxCopay,'|',DaysSupplyPerCopay,'|',CopayTier,'|',MaxCopayTier)" />
  <xsl:key name="adglkey" match="AlternateDrugsInformation/AlternateDrugGenderLimits" use="concat(OriginalExternalMedicationId,'|',AlternateExternalMedicationId,'|',AlternatePreferenceLevel,'|',Gender)" />
  <xsl:key name="adqlkey" match="AlternateDrugsInformation/AlternateDrugQuantityLimits" use="concat(OriginalExternalMedicationId,'|',AlternateExternalMedicationId,'|',AlternatePreferenceLevel,'|',MaxAmount,'|', MaxAmountQualifier,'|', MaxAmountTime,'|', MaxStartDate,'|', MaxEndDate,'|', MaxTimeUnit)" />
  <xsl:key name="cdkey" match="CopayDetail" use="concat(ExternalMedicationId,'|',PharmacyType,'|',FlatCopayAmount,'|',PercentCopayRate,'|',FirstCopayTerm,'|',MinCopay,'|',MaxCopay,'|',DaysSupplyPerCopay,'|',CopayTier,'|',MaxCopayTier)" />
  <xsl:key name="acdkey" match="AlternateDrugCopayDetail" use="concat(AlternateExternalMedicationId,'|',PharmacyType,'|',FlatCopayAmount,'|',PercentCopayRate,'|',FirstCopayTerm,'|',MinimumCopay,'|',MaxCopay,'|',DaysSupplyPerCopay,'|',CopayTier,'|',MaxCopayTier)" />
  <xsl:key name="cskey" match="CopaySummary" use="concat(PharmacyType,'|',FlatCopayAmount,'|',PercentCopayRate,'|',FirstCopayTerm,'|',MinCopay,'|',MaxCopay,'|',DaysSupplyPerCopay,'|',CopayTier,'|',MaxCopayTier,'|',OutPocketRangeStart,'|',OutPocketRangeEnd,'|',FormularyStatus,'|',ProductType)" />
  <xsl:key name="acskey" match="AlternateDrugCopaySummary" use="concat(PharmacyType,'|',FlatCopayAmount,'|',PercentCopayRate,'|',FirstCopayTerm,'|',MinCopay,'|',MaxCopay,'|',DaysSupplyPerCopay,'|',CopayTier,'|',MaxCopayTier,'|',OutPocketRangeStart,'|',OutPocketRangeEnd,'|',FormularyStatus,'|',ProductType)" />
  <xsl:key name="qlkey" match="QuantityLimits" use="concat(ExternalMedicationId,'|',MaxAmount,'|', MaxAmountQualifier,'|', MaxAmountTime,'|', MaxStartDate,'|', MaxEndDate,'|', MaxTimeUnit)" />
  <xsl:key name="agekey" match="AgeLimits" use="concat(ExternalMedicationId,'|',FormularyStatus,'|',MinAge,'|',MinAgeQualifier,'|',MaxAge,'|',MaxAgeQualifier)" />
  <xsl:key name="smkey" match="StepMedications" use="concat(ExternalMedicationId,'|',StepDrugLabel,'|',NumDrugToTry,'|',StepOrder)" />
  <xsl:key name="mxkey" match="MaxFormularyStatus" use="concat(ExternalMedicationId,'|',MaxFormularyStatus)" />
 
  <xsl:template match="FormularyResponse">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
        <link href="App_Themes/Includes/Style/Common.css?rel=3_5_x_4_1" rel="stylesheet" type="text/css" />
      </head>
      <body>
        <b>Drug Name: </b>
        <xsl:value-of select="DrugInformation/LabelName" />
        <br />
        <b>Drug Type: </b>
        <xsl:choose>
          <xsl:when test="DrugInformation/DrugType=1">Branded</xsl:when>
          <xsl:when test="DrugInformation/DrugType=2">Generic</xsl:when>
          <xsl:otherwise>Non-Drug</xsl:otherwise>
        </xsl:choose>
        <br />
        <b>Drug Class: </b>
        <xsl:choose>
          <xsl:when test="DrugInformation/DrugClass='F'">RX</xsl:when>
          <xsl:otherwise>OTC</xsl:otherwise>
        </xsl:choose>

        <br />
        <b>Formulary Status: </b>
        <xsl:variable name="FormularyStatusValueMx" select="DrugInformation/MaxFormularyStatus"></xsl:variable>
        <xsl:choose>
          <xsl:when test="DrugInformation/MaxFormularyStatus = 0">Not Reimbursable</xsl:when>
          <xsl:when test="DrugInformation/MaxFormularyStatus = 1">Non Formulary</xsl:when>
          <xsl:when test="DrugInformation/MaxFormularyStatus = 2">On-Formulary (Not Preferred)</xsl:when>
          <xsl:when test="DrugInformation/MaxFormularyStatus > 2">
            On-Formulary Preferred Level (<xsl:value-of select="number($FormularyStatusValueMx) - 2"/>)
          </xsl:when>
          <xsl:otherwise>Unknown</xsl:otherwise>
        </xsl:choose>
        
        <hr class="formulary" />
        <div style="height:400px; width:100%; overflow:auto;" id="FormularyInformationTabData">
          <xsl:apply-templates select="FormularyRequestInfo" />
        </div>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="FormularyRequestInfo">
    <xsl:variable name="FormularyStatusValue" select="MaxFormularyStatus"></xsl:variable>
    <table cellpadding="0" cellspacing="0" border="0">
      <tr class="formularybgcolor2">
        <td>
          <b>Source Name: </b>
          <xsl:value-of select="PMBName" />
        </td>
      </tr>
      <xsl:if test="MaxFormularyStatus">
        <tr>
          <td>
            <table cellpadding="0" cellspacing="0" border="0">
              <tr class="formularybgcolor1">
                <td>
                  <b>Alternatives List</b>
                </td>
              </tr>
              <tr>
                <td>
                  <table cellpadding="0" cellspacing="0" border="0">
                    <xsl:apply-templates select="MaxFormularyStatus[generate-id(.)=generate-id(key('mxkey',concat(ExternalMedicationId,'|',MaxFormularyStatus))[1])]" mode="maxdetails">
                      <xsl:sort select="number(MaxFormularyStatus)" order="descending"/>
                      <xsl:sort select="StrengthDescription"/>
                      <xsl:sort select="ExternalMedicationId"/>
                    </xsl:apply-templates>
                  </table>
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="CopayDetail">
        <tr>
          <td>
            <table cellpadding="0" cellspacing="0" border="0">
              <tr class="formularybgcolor1">
                <td>
                  <b>Copay Detail</b>
                </td>
              </tr>
              <tr>
                <td>
                  <table cellpadding="0" cellspacing="0" border="0">
                    <xsl:apply-templates select="CopayDetail[generate-id(.)=generate-id(key('cdkey',concat(ExternalMedicationId,'|',PharmacyType,'|',FlatCopayAmount,'|',PercentCopayRate,'|',FirstCopayTerm,'|',MinCopay,'|',MaxCopay,'|',DaysSupplyPerCopay,'|',CopayTier,'|',MaxCopayTier))[1])]" mode="copaydetails">
                      <xsl:sort select="PharmacyType" order="descending"/>
                      <xsl:sort select="number(FormularyStatus)" order="descending"/>
                      <xsl:sort select="StrengthDescription"/>
                    </xsl:apply-templates>
                  </table>
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="CopaySummary">
        <tr class="formularybgcolor1">
          <td>
            <b>Summary Level Copay</b>
          </td>
        </tr>
        <tr>
          <td>
            <table cellpadding="0" cellspacing="0" border="0">
              <xsl:apply-templates select="CopaySummary[generate-id(.)=generate-id(key('cskey',concat(PharmacyType,'|',FlatCopayAmount,'|',PercentCopayRate,'|',FirstCopayTerm,'|',MinCopay,'|',MaxCopay,'|',DaysSupplyPerCopay,'|',CopayTier,'|',MaxCopayTier,'|',OutPocketRangeStart,'|',OutPocketRangeEnd,'|',FormularyStatus,'|',ProductType))[1])]" mode="copaysummarylist">
                <xsl:sort select="PharmacyType" order="descending"/>
                <xsl:sort select="number(FormularyStatus)" order="descending"/>
                <xsl:sort select="ProductType"/>
              </xsl:apply-templates>
            </table>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="PriorAuthorization">
        <tr class="formularywarning">
          <td>
            <b>Prior Authorization Required</b>
          </td>
        </tr>
        <tr>
          <td>
            <table cellpadding="0" cellspacing="0" border="0">
              <xsl:apply-templates select="PriorAuthorization"></xsl:apply-templates>
            </table>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="DrugExclusion">
        <tr class="formularywarning">
          <td>
            <b>Drug Exclusion</b>
          </td>
        </tr>
        <tr>
          <td>
            <table cellpadding="0" cellspacing="0" border="0">
              <xsl:apply-templates select="DrugExclusion"></xsl:apply-templates>
            </table>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="StepTherapy">
        <tr class="formularybgcolor1">
          <td>
            <b>Step Therapy</b>
          </td>
        </tr>
        <tr>
          <td>
            <table cellpadding="0" cellspacing="0" border="0">
              <xsl:apply-templates select="StepTherapy">
                <xsl:sort select="DrugLabel"/>
                <xsl:sort select="StengthDescription"/>
              </xsl:apply-templates>
            </table>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="StepMedications">
        <tr class="formularybgcolor1">
          <td>
            <b>Step Medications</b>
          </td>
        </tr>
        <tr>
          <td>
            <table cellpadding="0" cellspacing="0" border="0">
              <xsl:apply-templates select="StepMedications[generate-id(.)=generate-id(key('smkey', concat(ExternalMedicationId,'|',StepDrugLabel,'|',NumDrugToTry,'|',StepOrder))[1])]">
                <xsl:sort select="DrugLabel"/>
                <xsl:sort select="StengthDescription"/>
                <xsl:sort select="StepOrder"/>
              </xsl:apply-templates>
            </table>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="AgeLimits">
        <tr class="formularybgcolor1">
          <td>
            <b>Age Limits</b>
          </td>
        </tr>
        <tr>
          <td>
            <table cellpadding="0" cellspacing="0" border="0">
              <xsl:apply-templates select="AgeLimits[generate-id(.)=generate-id(key('agekey',concat(ExternalMedicationId,'|',FormularyStatus,'|',MinAge,'|',MinAgeQualifier,'|',MaxAge,'|',MaxAgeQualifier))[1])]" mode="agelimitslist">
                <xsl:sort select="number(FormularyStatus)=FormularyStatus" order="descending"/>
                <xsl:sort select="StrengthDescription"/>
              </xsl:apply-templates>
            </table>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="GenderLimits[number(FormularyStatus)=FormularyStatus]">
        <tr class="formularybgcolor1">
          <td>
            <b>Gender Limits</b>
          </td>
        </tr>
        <tr>
          <td>
            <table cellpadding="0" cellspacing="0" border="0">
              <xsl:apply-templates select="GenderLimits[generate-id(.)=generate-id(key('glKey',concat(ExternalMedicationId,'|',FormularyStatus,'|',Gender))[1])]" mode="genderlistitems">
                <xsl:sort select="Gender"/>
                <xsl:sort select="number(FormularyStatus)=FormularyStatus" order="descending"/>
                <xsl:sort select="StrengthDescription"/>
              </xsl:apply-templates>
            </table>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="QuantityLimits">
        <tr class="formularybgcolor1">
          <td>
            <b>Quantity Limits</b>
          </td>
        </tr>
        <tr>
          <td>
            <table cellpadding="0" cellspacing="0" border="0">
              <xsl:apply-templates select="QuantityLimits[generate-id(.)=generate-id(key('qlkey',concat(ExternalMedicationId,'|',MaxAmount,'|', MaxAmountQualifier,'|', MaxAmountTime,'|', MaxStartDate,'|', MaxEndDate,'|', MaxTimeUnit))[1])]" mode="quantitylimitslist">
                <xsl:sort select="number(FormularyStatus)=FormularyStatus" order="descending"/>
                <xsl:sort select="StrengthDescription"/>
              </xsl:apply-templates>
            </table>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="TextMessages">
        <tr class="formularybgcolor1">
          <td>
            <b>Text Messages</b>
          </td>
        </tr>
        <tr>
          <td>
            <table cellpadding="0" cellspacing="0" border="0">
              <xsl:apply-templates select="TextMessages"></xsl:apply-templates>
            </table>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="ResourceInfoDrugSpecific">
        <tr class="formularybgcolor1">
          <td>
            <b>Resource Info Drug Specific</b>
          </td>
        </tr>
        <tr>
          <td>
            <table cellpadding="0" cellspacing="0" border="0">
              <xsl:apply-templates select="ResourceInfoDrugSpecific"></xsl:apply-templates>
            </table>
          </td>
        </tr>
      </xsl:if>      
      <xsl:if test="AlternateDrugsInformation/AlternateDrugs">
        <tr class="formularybgcolor1">
          <td class="formularyleftpadding">
            <b>Alternate Drugs</b>
          </td>
        </tr>
        <tr>
          <td>
            <table cellpadding="0" cellspacing="0" border="0">
              <xsl:apply-templates select="AlternateDrugsInformation/AlternateDrugs[generate-id(.)=generate-id(key('adikey',concat(Ordering,'|',AlternateExternalMedicationId,'|',AlternatePreferenceLevel,'|',MaxFormularyStatus,'|',PharmacyType,'|',FlatCopayAmount,'|',PercentCopayRate,'|',FirstCopayTerm,'|',MinimumCopay,'|',MaxCopay,'|',DaysSupplyPerCopay,'|',CopayTier,'|',MaxCopayTier))[1])]" mode="altdetails">
                <xsl:sort select="number(Ordering)=Ordering" order="ascending"/>
              </xsl:apply-templates>
            </table>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="AlternateDrugsInformation/AlternateDrugCopayDetail">
        <tr class="formularybgcolor1">
          <td>
            <b>Alternate Drugs Copay Detail</b>
          </td>
        </tr>
        <tr>
          <td>
            <table cellpadding="0" cellspacing="0" border="0">
              <tr>
                <xsl:apply-templates select="AlternateDrugsInformation/AlternateDrugCopayDetail[generate-id(.)=generate-id(key('acdkey',concat(AlternateExternalMedicationId,'|',PharmacyType,'|',FlatCopayAmount,'|',PercentCopayRate,'|',FirstCopayTerm,'|',MinimumCopay,'|',MaxCopay,'|',DaysSupplyPerCopay,'|',CopayTier,'|',MaxCopayTier))[1])]" mode="alternatecopaydetails">
                  <xsl:sort select="Ordering"/>
                </xsl:apply-templates>
              </tr>
            </table>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="AlternateDrugsInformation/*">
        <!--<tr class="formularybgcolor1">
          <td>
            <b>Alternative Drug Information</b>
          </td>
        </tr>-->
        <xsl:if test="AlternateDrugsInformation/AlternateDrugCopaySummary">
          <tr>
            <td class="formularyleftpadding">
              <table cellpadding="0" cellspacing="0" border="0">
                <tr class="formularybgcolor1">
                  <td>
                    <b>Alternative Drugs Copay Summary</b>
                  </td>
                </tr>
                <tr>
                  <td>
                    <table cellpadding="0" cellspacing="0" border="0">
                      <tr>
                        <xsl:apply-templates select="AlternateDrugsInformation/AlternateDrugCopaySummary[generate-id(.)=generate-id(key('acskey',concat(PharmacyType,'|',FlatCopayAmount,'|',PercentCopayRate,'|',FirstCopayTerm,'|',MinCopay,'|',MaxCopay,'|',DaysSupplyPerCopay,'|',CopayTier,'|',MaxCopayTier,'|',OutPocketRangeStart,'|',OutPocketRangeEnd,'|',FormularyStatus,'|',ProductType))[1])]" mode="altCopaysummarylist">
                          <xsl:sort select="PharmacyType"/>
                          <xsl:sort select="FormularyStatus"/>
                          <xsl:sort select="ProductType"/>
                        </xsl:apply-templates>
                      </tr>
                    </table>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
        </xsl:if>
      </xsl:if>
      <xsl:if test="AlternateDrugsInformation/AlternateDrugGenderLimits">
        <tr class="formularybgcolor1">
          <td class="formularyleftpadding">
            <b>Alternate Drugs Gender Limits</b>
          </td>
        </tr>
        <tr>
          <td>
            <table cellpadding="0" cellspacing="0" border="0">
              <xsl:apply-templates select="AlternateDrugsInformation/AlternateDrugGenderLimits[generate-id(.)=generate-id(key('adglkey',concat(OriginalExternalMedicationId,'|',AlternateExternalMedicationId,'|',AlternatePreferenceLevel,'|',Gender))[1])]" mode="altgenderdetails">
                <xsl:sort select="Gender"/>
                <xsl:sort select="AlternatePreferenceLevel"/>
                <xsl:sort select="number(FormularyStatus)=FormularyStatus" order="descending"/>
                <xsl:sort select="OriginalStrengthDescription"/>
                <xsl:sort select="MedicationName"/>
                <xsl:sort select="StrengthDescription"/>
              </xsl:apply-templates>
            </table>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="AlternateDrugsInformation/AlternateDrugQuantityLimits">
        <tr class="formularybgcolor1">
          <td class="formularyleftpadding">
            <b>Alternate Drugs Quantity Limits</b>
          </td>
        </tr>
        <tr>
          <td>
            <table cellpadding="0" cellspacing="0" border="0">
              <xsl:apply-templates select="AlternateDrugsInformation/AlternateDrugQuantityLimits[generate-id(.)=generate-id(key('adqlkey',concat(OriginalExternalMedicationId,'|',AlternateExternalMedicationId,'|',AlternatePreferenceLevel,'|',MaxAmount,'|', MaxAmountQualifier,'|', MaxAmountTime,'|', MaxStartDate,'|', MaxEndDate,'|', MaxTimeUnit))[1])]" mode="altquantitydetails">
                <xsl:sort select="AlternatePreferenceLevel"/>
                <xsl:sort select="number(FormularyStatus)=FormularyStatus" order="descending"/>
                <xsl:sort select="OriginalStrengthDescription"/>
                <xsl:sort select="MedicationName"/>
                <xsl:sort select="StrengthDescription"/>
              </xsl:apply-templates>
            </table>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="AlternateDrugsInformation/AlternateDrugTextMessages">
        <tr class="formularybgcolor1">
          <td class="formularyleftpadding">
            <b>Alternate Drugs Text Messages</b>
          </td>
        </tr>
        <tr>
          <td>
            <table cellpadding="0" cellspacing="0" border="0">
              <xsl:apply-templates select="AlternateDrugsInformation/AlternateDrugTextMessages" mode="alttextdetails">
                <xsl:sort select="AlternatePreferenceLevel"/>
                <xsl:sort select="number(FormularyStatus)=FormularyStatus" order="descending"/>
                <xsl:sort select="OriginalStrengthDescription"/>
                <xsl:sort select="MedicationName"/>
                <xsl:sort select="StrengthDescription"/>
              </xsl:apply-templates>
            </table>
          </td>
        </tr>
      </xsl:if>


    </table>
    <hr />
  </xsl:template>
  <xsl:template match="PriorAuthorization">
    <tr>
      <td width="10px"></td>
    </tr>
  </xsl:template>
  <xsl:template match="DrugExclusion">
    <tr>
      <td width="10px"></td>
    </tr>
  </xsl:template>
  <xsl:template match="ResourceInfoDrugSpecific">
    <xsl:variable name="ResourceLink" select="URL"></xsl:variable>
    <tr>
      <td width="10px"></td>
      <td class="formularybgcolor1">
        <b>
          <xsl:choose>
            <xsl:when test="ResourceLinkType = 'AL'">Age Limit: </xsl:when>
            <xsl:when test="ResourceLinkType = 'GL'">Gender Limit: </xsl:when>
            <xsl:when test="ResourceLinkType = 'QL'">Quantity Limit: </xsl:when>
            <xsl:when test="ResourceLinkType = 'PA'">Prior Authorization: </xsl:when>
            <xsl:when test="ResourceLinkType = 'ST'">Step Medication: </xsl:when>
          </xsl:choose>
        </b>
      </td>
      <td width="5px"></td>
      <td class="formularyfontreduce">
        <a href="{$ResourceLink}" target="_blank">
          <xsl:value-of select="URL" />
        </a>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="TextMessages">
    <tr>
      <td style="width:400px;vertical-align:top;">
        <xsl:value-of select="TextMessageLong"/>
      </td>
      <td style="width:200px;vertical-align:top;">
        <xsl:value-of select="TextMessage"/>        
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="AgeLimits" mode="agelimitslist">
    <xsl:for-each select=".">
      <xsl:if test="number(FormularyStatus)=FormularyStatus and (MinAgeQualifier!='' or MaxAgeQualifier!='')">
        <xsl:variable name="FormularyStatusValueAL" select="FormularyStatus"></xsl:variable>
        <xsl:variable name="MinAgeText">
          <xsl:choose>
            <xsl:when test="MinAgeQualifier != MaxAgeQualifier">
              <xsl:choose>
                <xsl:when test="MinAgeQualifier='D'">&#160;Day(s)</xsl:when>
                <xsl:when test="MinAgeQualifier='Y'">&#160;Year(s)</xsl:when>
                <xsl:otherwise></xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise></xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="MaxAgeText">
          <xsl:choose>
            <xsl:when test="MinAgeQualifier != MaxAgeQualifier">
              <xsl:choose>
                <xsl:when test="MaxAgeQualifier='D'">&#160;Day(s)</xsl:when>
                <xsl:when test="MaxAgeQualifier='Y'">&#160;Year(s)</xsl:when>
                <xsl:otherwise></xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise></xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="AgeText">
          <xsl:choose>
            <xsl:when test="MinAgeQualifier = MaxAgeQualifier">
              <xsl:choose>
                <xsl:when test="MinAgeQualifier='D'">&#160;Day(s)</xsl:when>
                <xsl:when test="MinAgeQualifier='Y'">&#160;Year(s)</xsl:when>
                <xsl:otherwise></xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise></xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <tr>
          <td width="10px">
          </td>
          <td>
            <xsl:choose>
              <xsl:when test="number(MinAge) > 0 and number(MaxAge)">
                <b>Age range&#160;&#160;</b>
                <xsl:value-of select="MinAge"/>
                <xsl:value-of select="$MinAgeText" />
                <b> - </b>
                <xsl:value-of select="MaxAge"/>
                <xsl:value-of select="$MaxAgeText" />
                <xsl:value-of select="$AgeText"/>
              </xsl:when>
              <xsl:when test="number(MinAge) > 0">
                <b>Age </b>
                <xsl:value-of select="MinAge"/>
                <xsl:value-of select="$MinAgeText" />
              </xsl:when>
            </xsl:choose>
          </td>
        </tr>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="GenderLimits" mode="genderlistitems">
    <xsl:for-each select=".">
      <xsl:variable name="FormularyStatusValueGL" select="FormularyStatus"></xsl:variable>
      <xsl:if test="number(FormularyStatus)=FormularyStatus">
        <tr>
          <td width="10px"></td>
          <td>
            <xsl:choose>
              <xsl:when test="Gender=1">Male</xsl:when>
              <xsl:when test="Gender=2">Female</xsl:when>
              <xsl:otherwise>Unknown-Gender</xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="AlternateDrugsInformation/AlternateDrugs" mode="altdetails">
    <xsl:for-each select=".">
      <xsl:variable name="FormularyStatusValueADI" select="FormularyStatus"></xsl:variable>
      <tr>
        <td width="10px">
        </td>
        <td>
          <!--<b>Orig Strength: </b>
          <span class="formularybgcolor2">
            <xsl:value-of select="OriginalStrengthDescription"/>
          </span>
          <br />-->
          <b>Alt: </b>
          <span class="formularybgcolor3">
            <xsl:value-of select="MedicationName"/>
          </span>&#160;[&#160;<span class="formularybgcolor2">
            <xsl:value-of select="StrengthDescription"/>
          </span>&#160;]
          <br />
          <b>Type: </b>
          <xsl:choose>
            <xsl:when test="DrugType=1">Generic</xsl:when>
            <xsl:when test="DrugType=2">Branded</xsl:when>
            <xsl:otherwise>Non-Drug</xsl:otherwise>
          </xsl:choose>&#160;&#160;
          <b>Class: </b>
          <xsl:choose>
            <xsl:when test="DrugClass='F'">RX</xsl:when>
            <xsl:otherwise>OTC</xsl:otherwise>
          </xsl:choose>
        </td>
        <td width="5px"></td>
        <td style="vertical-align:top;">
          <b> Pref Level: </b>
          <xsl:value-of select="AlternatePreferenceLevel"/>
          <br />
          <b>
            <xsl:choose>
              <xsl:when test="FormularyStatus = 0">Not Reimbursable</xsl:when>
              <xsl:when test="FormularyStatus = 1">Non Formulary</xsl:when>
              <xsl:when test="FormularyStatus = 2">On-Formulary (Not Preferred)</xsl:when>
              <xsl:when test="FormularyStatus > 2">
                On-Formulary Preferred Level (<xsl:value-of select="number($FormularyStatusValueADI) - 2"/>)
              </xsl:when>
              <xsl:otherwise>Unknown Status</xsl:otherwise>
            </xsl:choose>
          </b>
        </td>
      </tr>
      <xsl:if test="FlatCopayAmount!='' or  PercentCopayRate!='' or MinCopay!='' or MaxCopay!='' or MaxCopayTier!='' or OutPocketRangeStart!='' or OutPocketRangeEnd!=''">
        <tr>
          <td width="10px">
          </td>
          <td>
            <xsl:choose>
              <xsl:when test="FirstCopayTerm='F' or FirstCopayTerm=''">
                <b>Flat Copay Amount: </b>
                <!--<xsl:value-of select="format-number(FlatCopayAmount, '$0.##')" />-->
                <xsl:choose>
                  <xsl:when test="number(FlatCopayAmount) or number(FlatCopayAmount) >= 0">
                    <xsl:value-of select="format-number(FlatCopayAmount,'$0.##')" />
                  </xsl:when>
                </xsl:choose>
                <br />
                <b>Percent Copay Rate: </b>
                <xsl:choose>
                  <xsl:when test="number(PercentCopayRate) or number(PercentCopayRate) >=0">
                    <xsl:value-of select="format-number(PercentCopayRate,'0%')" />
                  </xsl:when>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="FirstCopayTerm='P'">
                <b>Percent Copay Rate: </b>
                <!--<xsl:value-of select="format-number(PercentCopayRate, '0%')" />-->
                <xsl:choose>
                  <xsl:when test="number(PercentCopayRate) or number(PercentCopayRate) >= 0">
                    <xsl:value-of select="format-number(PercentCopayRate,'0%')" />
                  </xsl:when>
                </xsl:choose>
                <br />
                <b>Flat Copay Amount: </b>
                <xsl:choose>
                  <xsl:when test="number(FlatCopayAmount) or number(FlatCopayAmount) >= 0">
                    <xsl:value-of select="format-number(FlatCopayAmount,'$0.##')" />
                  </xsl:when>
                </xsl:choose>
              </xsl:when>
            </xsl:choose>
            <br />
            <b>Copay min: </b>
            <xsl:choose>
              <xsl:when test="number(MinimumCopay) or number(MinimumCopay)=0 or number(MinimumCopay) > 0">
                <xsl:value-of select="format-number(MinimumCopay,'$0.##')" />
              </xsl:when>
            </xsl:choose>
            <br />
            <b>Copay max: </b>
            <xsl:choose>
              <xsl:when test="number(MaxCopay) or number(MaxCopay)=0 or number(MaxCopay) >0">
                <xsl:value-of select="format-number(MaxCopay,'$0.##')" />
              </xsl:when>
            </xsl:choose>
            <br/>
            <xsl:if test="PharmacyType != ''">
              <div class="formularybgcolor1">
                <b>Pharmacy Type: </b>
                <xsl:choose>
                  <xsl:when test="PharmacyType='M'">Mail Order</xsl:when>
                  <xsl:when test="PharmacyType='R'">Retail</xsl:when>
                  <xsl:when test="PharmacyType='S'">Specialty</xsl:when>
                  <xsl:when test="PharmacyType='L'">Long-term Care</xsl:when>
                  <xsl:when test="PharmacyType='A'">Any</xsl:when>
                  <xsl:otherwise>Unknown</xsl:otherwise>
                </xsl:choose>
              </div>
            </xsl:if>
            <!--</xsl:if>-->
          </td>
          <td width="5px"></td>
          <td style="vertical-align:top;">
            <b> Days Supply Per Copay: </b>
            <xsl:value-of select="DaysSupplyPerCopay" />
            <br />
            <xsl:if test="number(CopayTier) > 0 or number(MaxCopayTier) > 0">
              <b>Copay Tier: </b>
              <xsl:value-of select="CopayTier" />
              <b>/</b>
              <xsl:value-of select="MaxCopayTier" />
              <br />
            </xsl:if>
            <xsl:if test="number(OutPocketRangeStart) > 0 or number(OutPocketRangeEnd) > 0">
              <b>Out of Pocket Range: </b>
              <xsl:value-of select="format-number(OutPocketRangeStart,'$0.##')" />
              <b> to </b>
              <xsl:value-of select="format-number(OutPocketRangeEnd,'$0.##')" />
              <br />
            </xsl:if>
          </td>
        </tr>
      </xsl:if>
      <tr>
        <td colspan="4" style="border: 1px solid black; height:1px;"></td>
      </tr>
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="AlternateDrugsInformation/AlternateDrugGenderLimits" mode="altgenderdetails">
    <xsl:for-each select=".">
      <xsl:variable name="FormularyStatusValueADGL" select="FormularyStatus"></xsl:variable>
      <tr>
        <td width="10px">
        </td>
        <td>
          <b>Orig Strength: </b>
          <span class="formularybgcolor2">
            <xsl:value-of select="OriginalStrengthDescription"/>
          </span>
          <br />
          <b>Alt: </b>
          <span class="formularybgcolor3">
            <xsl:value-of select="MedicationName"/>
          </span>&#160;[&#160;<span class="formularybgcolor2">
            <xsl:value-of select="StrengthDescription"/>
          </span>&#160;]
          <br />
          <b>Type: </b>
          <xsl:choose>
            <xsl:when test="DrugType=1">Generic</xsl:when>
            <xsl:when test="DrugType=2">Branded</xsl:when>
            <xsl:otherwise>Non-Drug</xsl:otherwise>
          </xsl:choose>&#160;&#160;
          <b>Class: </b>
          <xsl:choose>
            <xsl:when test="DrugClass='F'">RX</xsl:when>
            <xsl:otherwise>OTC</xsl:otherwise>
          </xsl:choose>
        </td>
        <td width="5px"></td>
        <td style="vertical-align:top;">
          <b> Pref Level: </b>
          <xsl:value-of select="AlternatePreferenceLevel"/>
          <br />
          <xsl:choose>
            <xsl:when test="Gender=1">Male</xsl:when>
            <xsl:when test="Gender=2">Female</xsl:when>
            <xsl:otherwise>Unknown-Gender</xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
      <tr>
        <td colspan="4" style="border: 1px solid black; height:1px;"></td>
      </tr>
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="AlternateDrugsInformation/AlternateDrugQuantityLimits" mode="altquantitydetails">
    <xsl:for-each select=".">
      <xsl:variable name="FormularyStatusValueADQL" select="FormularyStatus"></xsl:variable>
      <xsl:variable name="MaxAmountTimeValue">
        <xsl:choose>
          <xsl:when test="MaxAmountTime='CM'">
            per Calendar Month - Max <xsl:value-of select="MaxAmount" /> Units
          </xsl:when>
          <xsl:when test="MaxAmountTime='CQ'">
            per Calendar Quarter - Max <xsl:value-of select="MaxAmount" /> Units
          </xsl:when>
          <xsl:when test="MaxAmountTime='CY'">
            per Calendar Year - Max <xsl:value-of select="MaxAmount" /> Units
          </xsl:when>
          <xsl:when test="MaxAmountTime='DY'">
            Days - Max <xsl:value-of select="MaxAmount" /> Units
          </xsl:when>
          <xsl:when test="MaxAmountTime='LT'"> per Life Time</xsl:when>
          <xsl:when test="MaxAmountTime='PD'"> per Dispensing</xsl:when>
          <xsl:when test="MaxAmountTime='SP'"> per Specific Date Range</xsl:when>
          <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <tr>
        <td width="10px">
        </td>
        <td>
          <b>Orig Strength: </b>
          <span class="formularybgcolor2">
            <xsl:value-of select="OriginalStrengthDescription"/>
          </span>
          <br />
          <b>Alt: </b>
          <span class="formularybgcolor3">
            <xsl:value-of select="MedicationName"/>
          </span>&#160;[&#160;<span class="formularybgcolor2">
            <xsl:value-of select="StrengthDescription"/>
          </span>&#160;]
          <br />
          <b>Type: </b>
          <xsl:choose>
            <xsl:when test="DrugType=1">Generic</xsl:when>
            <xsl:when test="DrugType=2">Branded</xsl:when>
            <xsl:otherwise>Non-Drug</xsl:otherwise>
          </xsl:choose>&#160;&#160;
          <b>Class: </b>
          <xsl:choose>
            <xsl:when test="DrugClass='F'">RX</xsl:when>
            <xsl:otherwise>OTC</xsl:otherwise>
          </xsl:choose>
          <xsl:choose>
            <xsl:when test="MaxAmountTime='SP'">
              <br />
              Date Range: <xsl:value-of select="MaxStartDate"/> - <xsl:value-of select="MaxEndDate"/>
            </xsl:when>
          </xsl:choose>
        </td>
        <td width="5px"></td>
        <td style="vertical-align:top;">
          <b> Pref Level: </b>
          <xsl:value-of select="AlternatePreferenceLevel"/>
          <br />
          <b>
            <xsl:choose>
              <xsl:when test="FormularyStatus = 0">Not Reimbursable</xsl:when>
              <xsl:when test="FormularyStatus = 1">Non Formulary</xsl:when>
              <xsl:when test="FormularyStatus = 2">On-Formulary (Not Preferred)</xsl:when>
              <xsl:when test="FormularyStatus > 2">
                On-Formulary Preferred Level (<xsl:value-of select="number($FormularyStatusValueADQL) - 2"/>)
              </xsl:when>
              <xsl:otherwise>Unknown Status</xsl:otherwise>
            </xsl:choose>
          </b>
          <br />
          <xsl:choose>
            <xsl:when test="MaxAmountQualifier='DL'">
              <xsl:value-of select="format-number(MaxTimeUnit, '$0.##')"/>
              <xsl:value-of select="$MaxAmountTimeValue"/>
            </xsl:when>
            <xsl:when test="MaxAmountQualifier='DS'">
              <b>Days Supply: </b>
              <xsl:value-of select="MaxTimeUnit"/>
              <xsl:value-of select="$MaxAmountTimeValue"/>
            </xsl:when>
            <xsl:when test="MaxAmountQualifier='FL'">
              <b>Fills: </b>
              <xsl:value-of select="MaxTimeUnit"/>
              <xsl:value-of select="$MaxAmountTimeValue"/>
            </xsl:when>
            <xsl:when test="MaxAmountQualifier='QY'">
              <xsl:value-of select="format-number(MaxTimeUnit, '#,###')"/>
              <xsl:value-of select="$MaxAmountTimeValue"/>
            </xsl:when>
          </xsl:choose>
        </td>
      </tr>
      <tr>
        <td colspan="4" style="border: 1px solid black; height:1px;"></td>
      </tr>
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="AlternateDrugsInformation/AlternateDrugTextMessages" mode="alttextdetails">
    <xsl:for-each select=".">
      <xsl:variable name="FormularyStatusValueADTM" select="FormularyStatus"></xsl:variable>
      <tr>
        <td width="10px">
        </td>
        <td>
          <b>Orig Strength: </b>
          <span class="formularybgcolor2">
            <xsl:value-of select="OriginalStrengthDescription"/>
          </span>
          <br />
          <b>Alt: </b>
          <span class="formularybgcolor3">
            <xsl:value-of select="MedicationName"/>
          </span>&#160;[&#160;<span class="formularybgcolor2">
            <xsl:value-of select="StrengthDescription"/>
          </span>&#160;]
          <br />
          <b>Type: </b>
          <xsl:choose>
            <xsl:when test="DrugType=1">Generic</xsl:when>
            <xsl:when test="DrugType=2">Branded</xsl:when>
            <xsl:otherwise>Non-Drug</xsl:otherwise>
          </xsl:choose>&#160;&#160;
          <b>Class: </b>
          <xsl:choose>
            <xsl:when test="DrugClass='F'">RX</xsl:when>
            <xsl:otherwise>OTC</xsl:otherwise>
          </xsl:choose>
        </td>
        <td width="5px"></td>
        <td style="vertical-align:top;">
          <b> Pref Level: </b>
          <xsl:value-of select="AlternatePreferenceLevel"/>
          <br />
          <b>
            <xsl:choose>
              <xsl:when test="FormularyStatus = 0">Not Reimbursable</xsl:when>
              <xsl:when test="FormularyStatus = 1">Non Formulary</xsl:when>
              <xsl:when test="FormularyStatus = 2">On-Formulary (Not Preferred)</xsl:when>
              <xsl:when test="FormularyStatus > 2">
                On-Formulary Preferred Level (<xsl:value-of select="number($FormularyStatusValueADTM) - 2"/>)
              </xsl:when>
              <xsl:otherwise>Unknown Status</xsl:otherwise>
            </xsl:choose>
          </b>
        </td>
      </tr>
      <tr>
        <td width="10px">
        </td>
        <td colspan="3">
          <span class="formularybgcolor4">
            <xsl:value-of select="TextMessageLong"/>
          </span>
        </td>
      </tr>
      <tr>
        <td colspan="4" style="border: 1px solid black; height:1px;"></td>
      </tr>
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="StepMedications">
    <xsl:if test ="StepOrder=1">
      <tr>
        <td width="10px">
        </td>
        <td colspan="4">
          <xsl:value-of select="DrugLabel"/>&#160;(&#160;<xsl:value-of select="StrengthDescription"/>&#160;)
        </td>
      </tr>
    </xsl:if>
    <tr>
      <td width="10px"></td>
      <td width="30px"></td>
      <td>
        <b>
          Step&#160;<xsl:value-of select="StepOrder"/>
        </b>
      </td>
      <td width="5px"></td>
      <td>
        <xsl:value-of select="StepDrugLabel"/>&#160;(&#160;<xsl:value-of select="StrengthDescription"/>&#160;)
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="StepTherapy">
    <tr>
      <td width="10px"></td>
      <td>
        <xsl:value-of select="DrugLabel"/>&#160;(&#160;<xsl:value-of select="StrengthDescription"/>&#160;)
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="QuantityLimits" mode="quantitylimitslist">
    <xsl:for-each select=".">
      <xsl:if test="number(FormularyStatus)=FormularyStatus">
        <xsl:variable name="FormularyStatusValueQL" select="FormularyStatus"></xsl:variable>
        <xsl:variable name="MaxAmountTimeValue">
          <xsl:choose>
            <xsl:when test="MaxAmountTime='CM'">
              per Calendar Month - Max <xsl:value-of select="MaxAmount" /> Units
            </xsl:when>
            <xsl:when test="MaxAmountTime='CQ'">
              per Calendar Quarter - Max <xsl:value-of select="MaxAmount" /> Units
            </xsl:when>
            <xsl:when test="MaxAmountTime='CY'">
              per Calendar Year - Max <xsl:value-of select="MaxAmount" /> Units
            </xsl:when>
            <xsl:when test="MaxAmountTime='DY'">
              Days - Max <xsl:value-of select="MaxAmount" /> Units
            </xsl:when>
            <xsl:when test="MaxAmountTime='LT'"> per Life Time</xsl:when>
            <xsl:when test="MaxAmountTime='PD'"> per Dispensing</xsl:when>
            <xsl:when test="MaxAmountTime='SP'"> per Specific Date Range</xsl:when>
            <xsl:otherwise></xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <td style="vertical-align:top;">
          <table cellpadding="0" cellspacing="0" border="0" width="100%">
            <tr>
              <td width="10px">
              </td>
              <td>
                <xsl:choose>
                  <xsl:when test="MaxAmountQualifier='DL'">
                    <xsl:value-of select="format-number(MaxTimeUnit, '$0.##')"/>
                    <xsl:value-of select="$MaxAmountTimeValue"/>
                  </xsl:when>
                  <xsl:when test="MaxAmountQualifier='DS'">
                    <b>Days Supply: </b>
                    <xsl:value-of select="MaxAmount"/>
                    <xsl:value-of select="$MaxAmountTimeValue"/>
                  </xsl:when>
                  <xsl:when test="MaxAmountQualifier='FL'">
                    <b>Fills: </b>
                    <xsl:value-of select="MaxTimeUnit"/>
                    <xsl:value-of select="$MaxAmountTimeValue"/>
                  </xsl:when>
                  <xsl:when test="MaxAmountQualifier='QY'">
                    <xsl:value-of select="format-number(MaxTimeUnit, '#,###')"/>
                    <xsl:value-of select="$MaxAmountTimeValue"/>
                  </xsl:when>
                </xsl:choose>
                <xsl:choose>
                  <xsl:when test="MaxAmountTime='SP'">
                    <br />
                    Date Range: <xsl:value-of select="MaxStartDate"/> - <xsl:value-of select="MaxEndDate"/>
                  </xsl:when>
                </xsl:choose>
              </td>
            </tr>
          </table>
        </td>
        <td width="30px;"></td>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="MaxFormularyStatus" mode="maxdetails">
    <xsl:variable name="FormularyStatusValueMx" select="MaxFormularyStatus"></xsl:variable>
    <xsl:for-each select=".">
      <!--<xsl:if test="IsAlternative='Y'">-->
      <tr>
        <td width="10px">
        </td>
        <td>
          <xsl:value-of select="DrugLabel"/>, 
          <xsl:value-of select="StrengthDescription"/>
      
        </td>
        <td style="width:30px;"></td>
        <td>
          <xsl:choose>
            <xsl:when test="MaxFormularyStatus = 0">Not Reimbursable</xsl:when>
            <xsl:when test="MaxFormularyStatus = 1">Non Formulary</xsl:when>
            <xsl:when test="MaxFormularyStatus = 2">On-Formulary (Not Preferred)</xsl:when>
            <xsl:when test="MaxFormularyStatus > 2">
              On-Formulary Preferred Level (<xsl:value-of select="number($FormularyStatusValueMx) - 2"/>)
            </xsl:when>
            <xsl:otherwise>Unknown</xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
      <!--</xsl:if>-->
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="CopayDetail" mode="copaydetails">
    <xsl:variable name="FormularyStatusValueCD" select="FormularyStatus"></xsl:variable>
    <xsl:variable name="copaydetailposition" select="position()" />
    <xsl:variable name="lastdetailposition" select="last()" />
    <xsl:for-each select=".">
      <xsl:if test="$copaydetailposition = 1">
        <xsl:text disable-output-escaping="yes">&lt;tr&gt;</xsl:text>
      </xsl:if>
      <xsl:if test="$copaydetailposition mod 4 = 0">
        <xsl:text disable-output-escaping="yes">&lt;&#47;tr&gt; &lt;tr&gt;</xsl:text>
      </xsl:if>
      <td>
        <table cellpadding="0" cellspacing="0" border="0" width="100%">
          <tr>
            <td width="10px">
            </td>
            <td>
              <xsl:if test="PharmacyType != ''">
                <div class="formularybgcolor5">
                  <b>Pharmacy Type: </b>
                  <xsl:choose>
                    <xsl:when test="PharmacyType='M'">Mail Order</xsl:when>
                    <xsl:when test="PharmacyType='R'">Retail</xsl:when>
                    <xsl:when test="PharmacyType='S'">Specialty</xsl:when>
                    <xsl:when test="PharmacyType='L'">Long-term Care</xsl:when>
                    <xsl:when test="PharmacyType='A'">Any</xsl:when>
                    <xsl:otherwise>Unknown</xsl:otherwise>
                  </xsl:choose>
                </div>
              </xsl:if>
              <!--<xsl:if test="StrengthDescription != ''">
                <div class="formularybgcolor5">
                  <xsl:if test="DrugLabel != ''">
				  <b>Drug: </b>
                  <xsl:value-of select="DrugLabel"/>
                <br />
				  
				</xsl:if>
                <b>Strength: </b>
                  <xsl:value-of select="StrengthDescription"/>
                </div>
              </xsl:if>
              <xsl:choose>
                <xsl:when test="FormularyStatus = 0">Not Reimbursable</xsl:when>
                <xsl:when test="FormularyStatus = 1">Non Formulary</xsl:when>
                <xsl:when test="FormularyStatus = 2">On-Formulary (Not Preferred)</xsl:when>
                <xsl:when test="FormularyStatus > 2">
                  On-Formulary Preferred Level (<xsl:value-of select="number($FormularyStatusValueCD) - 2"/>)
                </xsl:when>
                <xsl:otherwise>Unknown</xsl:otherwise>
              </xsl:choose>
              <br />-->
              <xsl:choose>
                <xsl:when test="FirstCopayTerm='F'">
                  <b>Flat Copay Amount: </b>
                  <!--<xsl:value-of select="format-number(FlatCopayAmount, '$0.##')" />-->
                  <xsl:choose>
                    <xsl:when test="number(FlatCopayAmount) and number(FlatCopayAmount) > 0">
                      <xsl:value-of select="format-number(FlatCopayAmount,'$0.##')" />
                    </xsl:when>
                  </xsl:choose>

                  <xsl:choose>
                    <xsl:when test="not(PercentCopayRate='')">
                      <br />
                      <b>Percent Copay Rate: </b>
                      <xsl:value-of select="format-number(PercentCopayRate, '0%')" />
                    </xsl:when>
                  </xsl:choose>
                </xsl:when>
                <xsl:when test="FirstCopayTerm='P'">
                  <b>Percent Copay Rate: </b>
                  <xsl:value-of select="format-number(PercentCopayRate, '0%')" />
                  <xsl:choose>
                    <xsl:when test="not(FlatCopayAmount='')">
                      <br />
                      <b>Flat Copay Amount: </b>
                      <!--<xsl:value-of select="format-number(FlatCopayAmount, '$0.##')" />-->
                      <xsl:choose>
                        <xsl:when test="number(FlatCopayAmount) and number(FlatCopayAmount) > 0">
                          <xsl:value-of select="format-number(FlatCopayAmount,'$0.##')" />
                        </xsl:when>
                      </xsl:choose>
                    </xsl:when>
                  </xsl:choose>
                </xsl:when>
                <xsl:when test="FirstCopayTerm=''">
                  <b>Flat Copay Amount: </b>
                  <!--<xsl:value-of select="format-number(FlatCopayAmount, '$0.##')" />-->
                  <xsl:choose>
                    <xsl:when test="number(FlatCopayAmount) and number(FlatCopayAmount) > 0">
                      <xsl:value-of select="format-number(FlatCopayAmount,'$0.##')" />
                    </xsl:when>
                  </xsl:choose>

                  <xsl:choose>
                    <xsl:when test="not(PercentCopayRate='')">
                      <br />
                      <b>Percent Copay Rate: </b>
                      <xsl:value-of select="format-number(PercentCopayRate, '0%')" />
                    </xsl:when>
                  </xsl:choose>
                </xsl:when>
              </xsl:choose>
              <br />
              <xsl:if test="number(MinCopay) > 0 or number(MaxCopay) > 0">
                <b>Copay min: </b>
                <xsl:choose>
                  <xsl:when test="number(MinCopay) > 0">
                    <xsl:value-of select="format-number(MinCopay,'$0.##')" />
                  </xsl:when>
                </xsl:choose>
                <br />
                <b>Copay max: </b>
                <xsl:choose>
                  <xsl:when test="number(MaxCopay) >= 0">
                    <xsl:value-of select="format-number(MaxCopay,'$0.##')" />
                  </xsl:when>
                </xsl:choose>
                <br/>
              </xsl:if>
              <b> Days Supply Per Copay: </b>
              <xsl:value-of select="DaysSupplyPerCopay" />
              <br />
              <xsl:if test="number(CopayTier) > 0 or number(MaxCopayTier) > 0">
                <b>Copay Tier: </b>
                <xsl:value-of select="CopayTier" />
                <b>/</b>
                <xsl:value-of select="MaxCopayTier" />
                <br />
              </xsl:if>
              <xsl:if test="number(OutPocketrangeStart) > 0 or number(OutPocketRangeEnd) > 0">
                <b>Out of Pocket Range: </b>
                <xsl:value-of select="format-number(OutPocketRangeStart,'$0.##')" />
                <b> to </b>
                <xsl:value-of select="format-number(OutPocketRangeEnd, '$0.##')" />
                <br />
              </xsl:if>
            </td>
          </tr>
        </table>
      </td>
      <xsl:if test="$copaydetailposition = $lastdetailposition">
        <xsl:text disable-output-escaping="yes">&lt;&#47;tr&gt;</xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="AlternateDrugsInformation/AlternateDrugCopayDetail" mode="alternatecopaydetails">
    <xsl:for-each select=".">
      <td>
        <table cellpadding="0" cellspacing="0" border="0" width="100%">
          <tr>
            <td width="10px">
            </td>
            <td>
              <xsl:if test="PharmacyType != ''">
                <div class="formularybgcolor1">
                  <b>Pharmacy Type: </b>
                  <xsl:choose>
                    <xsl:when test="PharmacyType='M'">Mail Order</xsl:when>
                    <xsl:when test="PharmacyType='R'">Retail</xsl:when>
                    <xsl:when test="PharmacyType='S'">Specialty</xsl:when>
                    <xsl:when test="PharmacyType='L'">Long-term Care</xsl:when>
                    <xsl:when test="PharmacyType='A'">Any</xsl:when>
                    <xsl:otherwise>Unknown</xsl:otherwise>
                  </xsl:choose>
                </div>
              </xsl:if>
              <xsl:if test="StrengthDescription != ''">
                <div class="formularybgcolor1">
                  <xsl:if test="MedicationName != ''">
                    <b>Drug: </b>
                    <xsl:value-of select="MedicationName"/>
                    <br />

                  </xsl:if>
                  <b>Strength: </b>
                  <xsl:value-of select="StrengthDescription"/>
                </div>
              </xsl:if>

              <xsl:choose>
                <xsl:when test="FirstCopayTerm='F'">
                  <b>Flat Copay Amount: </b>
                  <!--<xsl:value-of select="format-number(FlatCopayAmount, '$0.##')" />-->
                  <xsl:choose>
                    <xsl:when test="number(FlatCopayAmount) and number(FlatCopayAmount) > 0">
                      <xsl:value-of select="format-number(FlatCopayAmount,'$0.##')" />
                    </xsl:when>
                  </xsl:choose>
                  <br />
                </xsl:when>
                <xsl:when test="FirstCopayTerm='P'">
                  <b>Percent Copay Rate: </b>
                  <xsl:value-of select="format-number(PercentCopayRate, '0%')" />
                  <br />
                </xsl:when>
              </xsl:choose>
              <b>Copay min: </b>
              <xsl:choose>
                <xsl:when test="number(MinCopay) > 0">
                  <xsl:value-of select="format-number(MinCopay,'$0.##')" />
                </xsl:when>
              </xsl:choose>
              <br />
              <b>Copay max: </b>
              <xsl:choose>
                <xsl:when test="number(MaxCopay) >= 0">
                  <xsl:value-of select="format-number(MaxCopay,'$0.##')" />
                </xsl:when>
              </xsl:choose>
              <br/>
              <!--</xsl:if>-->
              <b> Days Supply Per Copay: </b>
              <xsl:value-of select="DaysSupplyPerCopay" />
              <br />
              <xsl:if test="number(CopayTier) > 0 or number(MaxCopayTier) > 0">
                <b>Copay Tier min: </b>
                <xsl:value-of select="CopayTier" />
                <b> max: </b>
                <xsl:value-of select="MaxCopayTier" />
                <br />
              </xsl:if>
              <xsl:if test="number(OutPocketRangeStart) > 0 or number(OutPocketRangeEnd) > 0">
                <b>Out of Pocket Range: </b>
                <xsl:value-of select="format-number(OutPocketRangeStart,'$0.##')" />
                <b> to </b>
                <xsl:value-of select="format-number(OutPocketRangeEnd,'$0.##')" />
                <br />
              </xsl:if>
            </td>
          </tr>
        </table>
      </td>
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="CopaySummary" mode="copaysummarylist">
    <xsl:variable name="copaysummaryposition" select="position()" />
    <xsl:variable name="lastsummaryposition" select="last()" />
    <xsl:variable name="FormularyStatusValueCS" select="FormularyStatus"></xsl:variable>
    <xsl:for-each select=".">
      <xsl:if test="$copaysummaryposition = 1">
        <xsl:text disable-output-escaping="yes">&lt;tr&gt;</xsl:text>
      </xsl:if>
      <xsl:if test="$copaysummaryposition mod 4 = 0">
        <xsl:text disable-output-escaping="yes">&lt;&#47;tr&gt; &lt;tr&gt;</xsl:text>
      </xsl:if>
      <td valign="top">
        <table cellpadding="0" cellspacing="0" border="0" width="100%">
          <tr>
            <td width="10px">
            </td>
            <td>
              <div class="formularybgcolor5">
                <b>Pharmacy Type: </b>
                <xsl:choose>
                  <xsl:when test="PharmacyType='M'">Mail Order</xsl:when>
                  <xsl:when test="PharmacyType='R'">Retail</xsl:when>
                  <xsl:when test="PharmacyType='S'">Specialty</xsl:when>
                  <xsl:when test="PharmacyType='L'">Long-term Care</xsl:when>
                  <xsl:when test="PharmacyType='A'">Any</xsl:when>
                  <xsl:otherwise>Unknown</xsl:otherwise>
                </xsl:choose>
              </div>
              <xsl:choose>
                <xsl:when test="FormularyStatus = 0">Not Reimbursable</xsl:when>
                <xsl:when test="FormularyStatus = 1">Non Formulary</xsl:when>
                <xsl:when test="FormularyStatus = 2">On-Formulary (Not Preferred)</xsl:when>
                <xsl:when test="FormularyStatus > 2">
                  On-Formulary Preferred Level (<xsl:value-of select="number($FormularyStatusValueCS) - 2"/>)
                </xsl:when>
                <xsl:otherwise>Unknown</xsl:otherwise>
              </xsl:choose>
              <br />
              <xsl:choose>
                <xsl:when test="FirstCopayTerm='F'">
                  <b>Flat Copay Amount: </b>
                  <!--<xsl:value-of select="format-number(FlatCopayAmount, '$0.##')" />-->
                  <xsl:choose>
                    <xsl:when test="number(FlatCopayAmount) and number(FlatCopayAmount) > 0">
                      <xsl:value-of select="format-number(FlatCopayAmount,'$0.##')" />
                    </xsl:when>
                  </xsl:choose>
                  <xsl:choose>
                <xsl:when test="not(PercentCopayRate='')">
              <br />
                  <b>Percent Copay Rate: </b>
                  <xsl:value-of select="format-number(PercentCopayRate, '0%')" />
                </xsl:when>
              </xsl:choose>
                </xsl:when>
                <xsl:when test="FirstCopayTerm='P'">
                  <b>Percent Copay Rate: </b>
                  <xsl:value-of select="format-number(PercentCopayRate, '0%')" />
              <xsl:choose>
                <xsl:when test="not(FlatCopayAmount='')">
              <br />
                  <b>Flat Copay Amount: </b>
                  <xsl:value-of select="format-number(FlatCopayAmount, '$0.##')" />
                </xsl:when>
              </xsl:choose>
                </xsl:when>
				<xsl:when test="FirstCopayTerm=''">
                  <b>Flat Copay Amount: </b>
                  <!--<xsl:value-of select="format-number(FlatCopayAmount, '$0.##')" />-->
          <xsl:choose>
            <xsl:when test="number(FlatCopayAmount) and number(FlatCopayAmount) > 0">
              <xsl:value-of select="format-number(FlatCopayAmount,'$0.##')" />
            </xsl:when>
          </xsl:choose>

          <xsl:choose>
                <xsl:when test="not(PercentCopayRate='')">
              <br />
                  <b>Percent Copay Rate: </b>
                  <xsl:value-of select="format-number(PercentCopayRate, '0%')" />
                </xsl:when>
              </xsl:choose>
                </xsl:when>
                
              </xsl:choose>
              <br />
              <b>Copay min: </b>
              <xsl:choose>
                <xsl:when test="number(MinCopay) > 0">
                  <xsl:value-of select="format-number(MinCopay,'$0.##')" />
                </xsl:when>
              </xsl:choose>
              <br />
              <b>Copay max: </b>
              <xsl:choose>
                <xsl:when test="number(MaxCopay) >= 0">
                  <xsl:value-of select="format-number(MaxCopay,'$0.##')" />
                </xsl:when>
              </xsl:choose>
              <br/>
              <b> Days Supply Per Copay: </b>
              <xsl:value-of select="DaysSupplyPerCopay" />
              <br />
              <xsl:if test="number(CopayTier) > 0 or number(MaxCopayTier) > 0">
                <b>Copay Tier min: </b>
                <xsl:value-of select="CopayTier" />
                <b> max: </b>
                <xsl:value-of select="MaxCopayTier" />
                <br />
              </xsl:if>
              <xsl:if test="number(OutPocketRangeStart) > 0 or number(OutPocketRangeEnd) > 0">
                <b>Out of Pocket Range: </b>
                <!--<xsl:value-of select="format-number(OutPocketRangeStart,'$0.##')" />-->
                <xsl:choose>
                  <xsl:when test="number(OutPocketRangeStart) and number(OutPocketRangeStart) > 0">
                    <xsl:value-of select="format-number(OutPocketRangeStart,'$0.##')" />
                  </xsl:when>
                </xsl:choose>
                <b> to </b>
                <!--<xsl:value-of select="format-number(OutPocketRangeEnd,'$0.##')" />-->
                <xsl:choose>
                  <xsl:when test="number(OutPocketRangeEnd) and number(OutPocketRangeEnd) > 0">
                    <xsl:value-of select="format-number(OutPocketRangeEnd,'$0.##')" />
                  </xsl:when>
                </xsl:choose>
                <br />
              </xsl:if>
              <b>ProductType: </b>
              <xsl:choose>
                <xsl:when test="ProductType='0'">Not Specified</xsl:when>
                <xsl:when test="ProductType='1'">Single Source Brand</xsl:when>
                <xsl:when test="ProductType='2'">Branded Generic</xsl:when>
                <xsl:when test="ProductType='3'">Generic</xsl:when>
                <xsl:when test="ProductType='4'">OTC</xsl:when>
                <xsl:when test="ProductType='5'">Compound</xsl:when>
                <xsl:when test="ProductType='6'">Supply</xsl:when>
                <xsl:when test="ProductType='A'">Any</xsl:when>
              </xsl:choose>
            </td>
          </tr>
        </table>
      </td>
      <xsl:if test="$copaysummaryposition = $lastsummaryposition">
        <xsl:text disable-output-escaping="yes">&lt;&#47;tr&gt;</xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="AlternateDrugsInformation/AlternateDrugCopaySummary" mode="altCopaysummarylist">
    <xsl:for-each select=".">
      <xsl:variable name="FormularyStatusValueCS" select="FormularyStatus"></xsl:variable>
      <td>
        <table cellpadding="0" cellspacing="0" border="0" width="100%">
          <tr>
            <td width="10px">
            </td>
            <td>
              <div class="formularybgcolor1">
                <b>Pharmacy Type: </b>
                <xsl:choose>
                  <xsl:when test="PharmacyType='M'">Mail Order</xsl:when>
                  <xsl:when test="PharmacyType='R'">Retail</xsl:when>
                  <xsl:when test="PharmacyType='S'">Specialty</xsl:when>
                  <xsl:when test="PharmacyType='L'">Long-term Care</xsl:when>
                  <xsl:when test="PharmacyType='A'">Any</xsl:when>
                  <xsl:otherwise>Unknown</xsl:otherwise>
                </xsl:choose>
              </div>
              <xsl:choose>
                <xsl:when test="FirstCopayTerm='F'">
                  <b>Flat Copay Amount: </b>
                  <!--<xsl:value-of select="format-number(FlatCopayAmount, '$0.##')" />-->
                  <xsl:choose>
                    <xsl:when test="number(FlatCopayAmount) and number(FlatCopayAmount) > 0">
                      <xsl:value-of select="format-number(FlatCopayAmount,'$0.##')" />
                    </xsl:when>
                  </xsl:choose>
                  <br />
                  <b>Percent Copay Rate: </b>
                  <xsl:value-of select="format-number(PercentCopayRate, '0%')" />
                </xsl:when>
                <xsl:when test="FirstCopayTerm='P'">
                  <b>Percent Copay Rate: </b>
                  <xsl:value-of select="format-number(PercentCopayRate, '0%')" />
                  <br />
                  <b>Flat Copay Amount: </b>
                  <!--<xsl:value-of select="format-number(FlatCopayAmount, '$0.##')" />-->
                  <xsl:choose>
                    <xsl:when test="number(FlatCopayAmount) and number(FlatCopayAmount) > 0">
                      <xsl:value-of select="format-number(FlatCopayAmount,'$0.##')" />
                    </xsl:when>
                  </xsl:choose>
                </xsl:when>
                <xsl:when test="not(FlatCopayAmount='') or not(PercentCopayRate='')">
                  <b>Flat Copay Amount: </b>
                  <!--<xsl:value-of select="format-number(FlatCopayAmount, '$0.##')" />-->
                  <xsl:choose>
                    <xsl:when test="number(FlatCopayAmount) and number(FlatCopayAmount) > 0">
                      <xsl:value-of select="format-number(FlatCopayAmount,'$0.##')" />
                    </xsl:when>
                  </xsl:choose>
                  <br />
                  <b>Percent Copay Rate: </b>
                  <xsl:value-of select="format-number(PercentCopayRate, '0%')" />
                </xsl:when>
                <xsl:when test="not(PercentCopayRate='')">
                  <b>Percent Copay Rate: </b>
                  <xsl:value-of select="format-number(PercentCopayRate, '0%')" />
                </xsl:when>
              </xsl:choose>
              <br />
              <b>Copay min: </b>
              <xsl:choose>
                <xsl:when test="number(MinimumCopay) > 0">
                  <xsl:value-of select="format-number(MinimumCopay,'$0.##')" />
                </xsl:when>
              </xsl:choose>
              <br />
              <b>Copay max: </b>
              <xsl:choose>
                <xsl:when test="number(MaxCopay) >= 0">
                  <xsl:value-of select="format-number(MaxCopay,'$0.##')" />
                </xsl:when>
              </xsl:choose>
              <br/>
              <b> Days Supply Per Copay: </b>
              <xsl:value-of select="DaysSupplyPerCopay" />
              <br />
              <xsl:if test="number(CopayTier) > 0 or number(MaxCopayTier) > 0">
                <b>Copay Tier min: </b>
                <xsl:value-of select="CopayTier" />
                <b> max: </b>
                <xsl:value-of select="MaxCopayTier" />
                <br />
              </xsl:if>
              <xsl:if test="number(OutPocketRangeStart) > 0 or number(OutPocketRangeEnd) > 0">
                <b>Out of Pocket Range: </b>
                <xsl:value-of select="format-number(OutPocketRangeStart,'$0.##')" />
                <b> to </b>
                <xsl:value-of select="format-number(OutPocketRangeEnd,'$0.##')" />
                <br />
              </xsl:if>
              <b>ProductType: </b>
              <xsl:choose>
                <xsl:when test="ProductType='0'">Not Specified</xsl:when>
                <xsl:when test="ProductType='1'">Single Source Brand</xsl:when>
                <xsl:when test="ProductType='2'">Branded Generic</xsl:when>
                <xsl:when test="ProductType='3'">Generic</xsl:when>
                <xsl:when test="ProductType='4'">OTC</xsl:when>
                <xsl:when test="ProductType='5'">Compound</xsl:when>
                <xsl:when test="ProductType='6'">Supply</xsl:when>
                <xsl:when test="ProductType='A'">Any</xsl:when>
              </xsl:choose>
              <br />
              <xsl:choose>
                <xsl:when test="FormularyStatus = 0">Not Reimbursable</xsl:when>
                <xsl:when test="FormularyStatus = 1">Non Formulary</xsl:when>
                <xsl:when test="FormularyStatus = 2">On-Formulary (Not Preferred)</xsl:when>
                <xsl:when test="FormularyStatus > 2">
                  On-Formulary Preferred Level (<xsl:value-of select="number($FormularyStatusValueCS) - 2"/>)
                </xsl:when>
                <xsl:otherwise>Unknown</xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
        </table>
      </td>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
