<%@ Control Language="C#" AutoEventWireup="true" CodeFile="DiagnosticAssessment.ascx.cs" Inherits="ActivityPages_Harbor_Client_Detail_Documents_DiagnosticAssessment_DiagnosticAssessment" %>
<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>
<% if (HttpContext.Current == null)
   { %>

<link href="<%=RelativePath%>App_Themes/Styles/smartcare_styles.css" rel="stylesheet" type="text/css" />


<%} %>

<script language="javascript" type="text/javascript" src="<%=RelativePath%>Custom/Scripts/DiagnosticAssesment.js"></script>
<%--<script language="javascript" type="text/javascript" src="<%=RelativePath%>JScripts/Scripts/DiagnosticDLA.js"></script>--%>
<script language="javascript" type="text/javascript" src="<%=RelativePath%>Custom/Scripts/DiagnosticAssessmentNeeds.js"></script>
<script language="javascript" type="text/javascript" src="<%=RelativePath%>Custom/Scripts/DiagnosticSubstanceUse.js"></script>
<%--<script type="text/javascript" language="javascript" src="<%=RelativePath%>JScripts/Scripts/HarborTreatmetPlan.js"></script>
--%>
<script language="javascript" type="text/javascript" src="<%=RelativePath%>Custom/Scripts/Diagnosis.js"></script>
<script type="text/javascript" >
    var radtabScriptid = "<%= RadTabStrip1.ClientID %>"

</script>
<script language="javascript" type="text/javascript" src="<%=RelativePath%>Custom/Scripts/DiagnosticNarrativeSummary.js"></script>

<table id="TableDiagnosticTabContainer" width="100%" border="0" cellpadding="0" cellspacing="0" style="padding-left: 0px;display:none">
    <tr>
        <td valign="top" style="width: 100%; padding-top: 0px;">
            <telerik:RadTabStrip ID="RadTabStrip1" Skin="Vista"  Width="840px"
                OnClientTabSelected="onTabSelected" OnClientTabSelecting="ClientTabSelectingHandler" 
                runat="server" MultiPageID="RadMultiPage1" OnClientLoad="StoreTabstripClientObject" 
                SelectedIndex="18" EnableEmbeddedScripts="False" 
                EnableEmbeddedSkins="False"  >
                <Tabs>
                    <telerik:RadTab Text="Presenting Problem" UcName="DiagnosticPresentingProblem" Path="/Custom/WebPages/DiagnosticPresentingProblem.ascx"
                        runat="server" >
                    </telerik:RadTab>
                    <telerik:RadTab Text="DLA20" UcName="DiagnosticDLA" Path="/Custom/WebPages/DiagnosticDLA.ascx"
                        runat="server" >
                    </telerik:RadTab>
                     <telerik:RadTab Text="Sleep Hygiene" UcName="DiagnosticSleepHygiene" Path="/Custom/WebPages/DiagnosticSleepHygiene.ascx"
                        runat="server" >
                    </telerik:RadTab>
                    <telerik:RadTab Text="Family History" UcName="DiagnosticFamilyHistory" Path="/Custom/WebPages/DiagnosticFamilyHistory.ascx"
                        runat="server" >
                    </telerik:RadTab>
                    <telerik:RadTab Text="Child Psychosocial" UcName="DiagnosticChildPsychosocial" Path="/Custom/WebPages/DiagnosticChildPsychosocial.ascx"
                        runat="server">
                    </telerik:RadTab>
                    <telerik:RadTab Text="Psychosocial [M]" UcName="DiagnosticPsychosocialMinor" Path="/Custom/WebPages/DiagnosticPsychosocial.ascx"
                        runat="server" >
                    </telerik:RadTab>
                     <telerik:RadTab Text="Psychosocial [A]" UcName="DiagnosticPsychosocialAdult" Path="/Custom/WebPages/DiagnosticPsychosocialAdult.ascx"
                        runat="server" >
                    </telerik:RadTab>
                     <telerik:RadTab Text="Psychosocial [EAP]" UcName="DiagnosticPsychosocialEAP" Path="/Custom/WebPages/DiagnosticPsychosocialEAP.ascx"
                        runat="server" >
                    </telerik:RadTab>
                    <telerik:RadTab Text="Education History-Early Childhood" UcName="DiagnosticEducationHistory" Path="/Custom/WebPages/DiagnosticEducationHistory.ascx"
                        runat="server" >
                    </telerik:RadTab>
                     <telerik:RadTab Text="Education History-Minors" UcName="DiagnosticEducationMinors" Path="/Custom/WebPages/DiagnosticEducationHistoryMinors.ascx"
                        runat="server" >
                    </telerik:RadTab>
                     <telerik:RadTab Text="Dev Milestones" UcName="DiagnosticDevMilestones" Path="/Custom/WebPages/DiagnosticDevMilestones.ascx"
                        runat="server" >
                    </telerik:RadTab>
                    <telerik:RadTab Text="Substance Use" UcName="DiagnosticSubstanceUse" Path="/Custom/WebPages/DiagnosticSubstanceUse.ascx"
                        runat="server" >
                    </telerik:RadTab>
                    <telerik:RadTab Text="Risk Assessment" UcName="DiagnosticRiskAssessment" Path="/Custom/WebPages/DiagnosticRiskAssessment.ascx"
                        runat="server" >
                    </telerik:RadTab>
                     <telerik:RadTab Text="Risk Assessment [EAP]" UcName="RiskAssessmentEAP" Path="/Custom/WebPages/DiagnosticRiskAssessmentEAP.ascx"
                        runat="server" >
                    </telerik:RadTab>
                    <telerik:RadTab Text="Physical Health" UcName="DiagnosticPhysicalHealth" Path="/Custom/WebPages/DiagnosticPhysicalHealth.ascx"
                        runat="server" >
                    </telerik:RadTab>
                     <telerik:RadTab Text="Physical Health [EAP]" UcName="DiagnosticPhysicalEAP" Path="/Custom/WebPages/DiagnosticPhysicalHealthEAP.ascx"
                        runat="server" >
                    </telerik:RadTab>
                    <telerik:RadTab Text="Housing" UcName="DiagnosticHousing" Path="/Custom/WebPages/DiagnosticHousing.ascx"
                        runat="server">
                    </telerik:RadTab>
                     <telerik:RadTab Text="Vocational" UcName="DiagnosticVocational" Path="/Custom/WebPages/DiagnosticVocational.ascx"
                        runat="server" >
                    </telerik:RadTab>
                    <telerik:RadTab Text="Needs List" UcName="DiagnosticNeedsList" Path="/Custom/WebPages/DiagnosticNeedsList.ascx"
                        runat="server" >
                    </telerik:RadTab>
                      <telerik:RadTab Text="Mental Status [EAP]" UcName="MentalStatusEAP" Path="/Custom/WebPages/DiagnosticMentalStatusEAP.ascx"
                        runat="server" >
                    </telerik:RadTab>
                    <telerik:RadTab Text="Recommended Svcs" UcName="DiagnosticNarrativeSummary" Path="/Custom/WebPages/DiagnosticNarrativeSummary.ascx"
                        runat="server">
                    </telerik:RadTab>   
                    <telerik:RadTab Text="Initial Treatment Plan" UcName="DiagnosticInitialTxPlan" Path="/Custom/WebPages/DiagnosticInitialTxPlan.ascx"
                        runat="server" >
                    </telerik:RadTab>
                    <telerik:RadTab Text="Mental Status [C]" UcName="DiagnosticMStatusChildHood" Path="/Custom/WebPages/DiagnosticMentalStatus.ascx"
                        runat="server" > 
                        </telerik:RadTab>
                    <telerik:RadTab Text="Mental Status" UcName="DiagnosticMentalStatus" Path="/Custom/WebPages/DiagnosticMentalStatusAdultMinor.ascx"
                        runat="server" >
                    </telerik:RadTab>
                  <telerik:RadTab Text="Diagnosis" UcName="DiagnosticAssessmentDx" Path="/Custom/WebPages/DiagnosticAssessmentDx.ascx"
                        runat="server" >
                    </telerik:RadTab>
                </Tabs>
            </telerik:RadTabStrip>
            <telerik:RadMultiPage ID="RadMultiPage1" EnableEmbeddedScripts="false" runat="server"
                SelectedIndex="1" CssClass="pageView">
                <telerik:RadPageView ID="DiagnosticPresentingProblem" runat="server">
                </telerik:RadPageView>
                <telerik:RadPageView ID="DiagnosticDLA" runat="server">
                </telerik:RadPageView>
                <telerik:RadPageView ID="DiagnosticSleepHygiene" runat="server">
                </telerik:RadPageView>
                <telerik:RadPageView ID="DiagnosticFamilyHistory" runat="server">
                </telerik:RadPageView>
                <telerik:RadPageView ID="DiagnosticChildPsychosocial" runat="server">
                </telerik:RadPageView>
                <telerik:RadPageView ID="DiagnosticPsychosocialMinor" runat="server">
                </telerik:RadPageView>
                 <telerik:RadPageView ID="DiagnosticPsychosocialAdult" runat="server">
                </telerik:RadPageView>
                  <telerik:RadPageView ID="DiagnosticPsychosocialEAP" runat="server">
                </telerik:RadPageView>
                <telerik:RadPageView ID="DiagnosticEducationHistory" runat="server">
                </telerik:RadPageView>
                  <telerik:RadPageView ID="DiagnosticEducationMinors" runat="server">
                </telerik:RadPageView>
                <telerik:RadPageView ID="DiagnosticDevMilestones" runat="server">
                </telerik:RadPageView>
                <telerik:RadPageView ID="DiagnosticSubstanceUse" runat="server">
                </telerik:RadPageView>
                <telerik:RadPageView ID="DiagnosticRiskAssessment" runat="server">
                </telerik:RadPageView>
                <telerik:RadPageView ID="RiskAssessmentEAP" runat="server">
                </telerik:RadPageView>
                <telerik:RadPageView ID="DiagnosticPhysicalHealth" runat="server">
                </telerik:RadPageView>
                 <telerik:RadPageView ID="DiagnosticPhysicalEAP" runat="server">
                </telerik:RadPageView>
                <telerik:RadPageView ID="DiagnosticHousing" runat="server">
                </telerik:RadPageView>
                <telerik:RadPageView ID="DiagnosticVocational" runat="server">
                </telerik:RadPageView>
                <telerik:RadPageView ID="DiagnosticNeedsList" runat="server">
                </telerik:RadPageView>
                  <telerik:RadPageView ID="MentalStatusEAP" runat="server">
                </telerik:RadPageView>
                <telerik:RadPageView ID="DiagnosticNarrativeSummary" runat="server">
                </telerik:RadPageView>
                <telerik:RadPageView ID="DiagnosticInitialTxPlan" runat="server">
                </telerik:RadPageView>
                <telerik:RadPageView ID="DiagnosticMStatusChildHood" runat="server">
                </telerik:RadPageView>
                <telerik:RadPageView ID="DiagnosticMentalStatus" runat="server">
                </telerik:RadPageView>
               <telerik:RadPageView ID="DiagnosticAssessmentDx" runat="server">
                </telerik:RadPageView>
            </telerik:RadMultiPage>
        </td>
    </tr>
    <tr>
        <td>
            <input id="HiddenField_DiagnosticAssessments_DocumentVersionId" name="HiddenField_DiagnosticAssessments_DocumentVersionId"
                type="hidden" />
            <input type="hidden" id="HiddenField_DiagnosesIAndII_DiagnosisId" name="HiddenField_DiagnosesIAndII_DiagnosisId"
                value="-1" parentchildcontrols="True" />
                 <input type="hidden" id="HiddenField_CustomDocumentAssessmentReferrals_AssessmentReferralId" name="HiddenField_CustomDocumentAssessmentReferrals_AssessmentReferralId"
                value="-1" parentchildcontrols="True" />
                 <input type="hidden" id="HiddenField_CustomDocumentAssessmentTransferServices_AssessmentTransferServiceId" name="HiddenField_CustomDocumentAssessmentTransferServices_AssessmentTransferServiceId"
                value="-1" parentchildcontrols="True" />
               <input id="HiddenFieldPageTables" name="HiddenFieldPageTables" type="hidden" value="CustomDocumentDiagnosticAssessments,DiagnosesIII,DiagnosesIV,DiagnosesV,DiagnosesIIICodes,CustomDocumentAssessmentNeeds,CustomDocumentMentalStatuses,CustomTreatmentPlans,DocumentInitializationLog,CustomDocumentCrisisInterventionNotes" />
                <%--<input id="HiddenCustomDiagnosticActivitiesDataTable" runat="server" name="HiddenCustomDiagnosticActivitiesDataTable"
                type="hidden" />
                <input id="HiddenCustomDiagnosticNeedsDataTable" runat="server" name="HiddenCustomDiagnosticNeedsDataTable"
                type="hidden" />--%>
                
         </td>
    </tr>
</table>