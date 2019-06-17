-- =============================================  
-- Author:    Malathi Shiva 
-- Create date: July 20, 2014 
-- Description: New Templates for Diagnosis based on the SystemConfiguration Keys.  
/* 
Modified Date    Modidifed By    Purpose 
3 Mar 2016		Malathi Shiva	Camino - Customization: Task# 50 - Diagnosis label is modified, Race/Sex fields are removed, Client's Primary Coverage Plan/ Client Primary Pharmacy is added
*/ 
-- =============================================    
DECLARE @RXPatientSummaryTemplate VARCHAR(MAX) 

SET @RXPatientSummaryTemplate = 
'<div id="clientSummaryInfo" style="overflow-x: none; overflow-y: auto; height: 100%;      width: 100%;">      <table border="0" cellpadding="0" cellspacing="0" style="width: 96%;">          <tr style="height: 20px">              <td class="SumarryLabel" nowrap="nowrap" style="white-space: nowrap" valign="top"                  width="30%">                  Name:&nbsp;<a id="HyperLinkPatientName" runat="server" class="LinkLabel">HyperLinkPatientNameText</a>              </td>              <td class="SumarryLabel" nowrap="nowrap" style="white-space: nowrap" valign="top"                  width="20%">                  DOB/Age:&nbsp;<a id="HyperLinkPatientDOB" runat="server" class="LinkLabel">HyperLinkPatientDOBText                      </a>              </td>              <td class="SumarryLabel" nowrap="nowrap" style="white-space: nowrap" valign="top"                  width="20%">                  Primary Insurance Plan:&nbsp; <a id="HyperLinkClientPrimaryPlan" runat="server" class="LinkLabel">HyperLinkClientPrimaryPlanText                  </a>              </td>              <td class="SumarryLabel" nowrap="nowrap" style="white-space: nowrap; width: 25%;"                  valign="top">                  &nbsp; Pharmacy:&nbsp; <a id="HyperlinkClientPharmacy" runat="server" class="LinkLabel">HyperlinkClientPharmacyText</a>              </td>          </tr>          <tr>              <td colspan="4">                  <table style="height: 30px; width: 100%">                      <tr>                          <td class="SumarryLabel" valign="top" align="left" style="width: 7%">                              Diagnosis:</td>                       <td class="SumarryLabel" valign="top" align="left" style="width: 93%">                              <a id="HyperlinkAxisIText" runat="server" class="LinkLabel">HyperlinkAxisIText</a>                          </td>                      </tr>                  </table>              </td>          </tr>          <tr>              <td colspan="4">                  <table border="0" cellpadding="0" cellspacing="0" style="height: 20px; width: 100%">                      <tr>                          <td class="SumarryLabel" nowrap="nowrap" style="width: 50%;">                              Last Medication Visit:&nbsp;<a id="HyperLinkLastMedicationVisit" runat="server" class="LinkLabel">HyperLinkLastMedicationVisitText</a>                          </td>                          <td class="SumarryLabel" nowrap="nowrap">                              Next Medication Visit:&nbsp;<a id="HyperLinkNextMedicationVisit" runat="server" class="LinkLabel">HyperLinkNextMedicationVisitText</a>                          </td>                      </tr>                  </table>              </td>          </tr>              <tr>
            <td colspan="4">
                <table border="0" cellpadding="0" cellspacing="0" style="height: 20px; width: 100%">
                   <tr>
                    <td height="98"></td>
                    </tr>
                    <tr>
                          <td class="SumarryLabel" nowrap="nowrap" style="width: 50%;"><a id="HyperLinkCurrentDate" runat="server" class="LinkLabel">HyperLinkCurrentDate</a>         
                      <a id="HyperLinkScores" runat="server" class="LinkLabel">HyperLinkScores</a>         
                        <img src="App_Themes/Includes/Images/RedErrorFlag.jpg" id="PatientSummTemplatealertFlag" title="AlertFlag"> </td>
 </tr>
                </table>
            </td>
        </tr></table>  </div>'

DECLARE @RXPatientSummaryTemplateICD10 VARCHAR(MAX) 

SET @RXPatientSummaryTemplateICD10 = 
'<div id="clientSummaryInfo" style="overflow-x: none; overflow-y: auto; height: 100%;      width: 100%;">      <table border="0" cellpadding="0" cellspacing="0" style="width: 96%;">          <tr style="height: 20px">              <td class="SumarryLabel" nowrap="nowrap" style="white-space: nowrap" valign="top"                  width="30%">                  Name:&nbsp;<a id="HyperLinkPatientName" runat="server" class="LinkLabel">HyperLinkPatientNameText</a>              </td>              <td class="SumarryLabel" nowrap="nowrap" style="white-space: nowrap" valign="top"                  width="20%">                  DOB/Age:&nbsp;<a id="HyperLinkPatientDOB" runat="server" class="LinkLabel">HyperLinkPatientDOBText                      </a>              </td>              <td class="SumarryLabel" nowrap="nowrap" style="white-space: nowrap" valign="top"                  width="20%">                  Primary Insurance Plan:&nbsp; <a id="HyperLinkClientPrimaryPlan" runat="server" class="LinkLabel">HyperLinkClientPrimaryPlanText                  </a>              </td>              <td class="SumarryLabel" nowrap="nowrap" style="white-space: nowrap; width: 25%;"                  valign="top">                  &nbsp; Pharmacy:&nbsp; <a id="HyperlinkClientPharmacy" runat="server" class="LinkLabel">HyperlinkClientPharmacyText</a>              </td>          </tr>          <tr>              <td colspan="4">                  <table style="height: 30px; width: 100%">                      <tr>                          <td class="SumarryLabel" valign="top" align="left" style="width: 7%">                              Diagnosis:</td>                        <td class="SumarryLabel" valign="top" align="left" style="width: 93%">                              <a id="HyperLinkICD10Text" runat="server" class="LinkLabel">HyperLinkICD10Text</a>                          </td>                      </tr>                  </table>              </td>          </tr>          <tr>              <td colspan="4">                  <table border="0" cellpadding="0" cellspacing="0" style="height: 20px; width: 100%">                      <tr>                          <td class="SumarryLabel" nowrap="nowrap" style="width: 50%;">                              Last Medication Visit:&nbsp;<a id="HyperLinkLastMedicationVisit" runat="server" class="LinkLabel">HyperLinkLastMedicationVisitText</a>                          </td>                          <td class="SumarryLabel" nowrap="nowrap">                              Next Medication Visit:&nbsp;<a id="HyperLinkNextMedicationVisit" runat="server" class="LinkLabel">HyperLinkNextMedicationVisitText</a>                          </td>                      </tr>                  </table>              </td>          </tr>              <tr>
            <td colspan="4">
                <table border="0" cellpadding="0" cellspacing="0" style="height: 20px; width: 100%">
                   <tr>
                    <td height="98"></td>
                    </tr>
                    <tr>
                              <td class="SumarryLabel" nowrap="nowrap" style="width: 50%;"><a id="HyperLinkCurrentDate" runat="server" class="LinkLabel">HyperLinkCurrentDate</a>        
                    <a id="HyperLinkScores" runat="server" class="LinkLabel">HyperLinkScores</a>        
                         <img src="App_Themes/Includes/Images/RedErrorFlag.jpg" id="PatientSummTemplatealertFlag" title="AlertFlag"> </td>
</tr>
                </table>
            </td>
        </tr></table>  </div>'
        

IF NOT EXISTS(SELECT * 
              FROM   SystemConfigurationKeys 
              WHERE  [key] = 'RXPatientSummaryTemplate') 
  BEGIN 
      INSERT INTO SystemConfigurationKeys 
                  (CreatedBy 
                   ,CreateDate 
                   ,ModifiedBy 
                   ,ModifiedDate 
                   ,[Key] 
                   ,Value 
                   ,Description) 
      VALUES      ('mshiva' 
                   ,Getdate() 
                   ,'mshiva' 
                   ,Getdate() 
                   ,'RXPatientSummaryTemplate' 
                   ,@RXPatientSummaryTemplate
                   ,'Template which contains Axis I, II and III and not ICD 10') 
  END 
ELSE 
  BEGIN 
      UPDATE SystemConfigurationKeys 
      SET    Value = @RXPatientSummaryTemplate 
      WHERE  [Key] = 'RXPatientSummaryTemplate' 
  END 

IF NOT EXISTS(SELECT * 
              FROM   SystemConfigurationKeys 
              WHERE  [key] = 'RXPatientSummaryTemplateICD10') 
  BEGIN 
      INSERT INTO SystemConfigurationKeys 
                  (CreatedBy 
                   ,CreateDate 
                   ,ModifiedBy 
                   ,ModifiedDate 
                   ,[Key] 
                   ,Value 
                   ,Description) 
      VALUES      ('mshiva' 
                   ,Getdate() 
                   ,'mshiva' 
                   ,Getdate() 
                   ,'RXPatientSummaryTemplateICD10' 
                   ,@RXPatientSummaryTemplateICD10
                   ,'Template which contains ICD 10 and not Axis I, II and III') 
  END 
ELSE 
  BEGIN 
      UPDATE SystemConfigurationKeys 
      SET    Value = @RXPatientSummaryTemplateICD10 
      WHERE  [Key] = 'RXPatientSummaryTemplateICD10' 
  END 

GO 