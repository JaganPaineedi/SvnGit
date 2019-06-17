<%@ Control Language="C#" AutoEventWireup="true" CodeFile="HRMAssessment.ascx.cs"
    Inherits="SHS.SmartCare.ActivityPages_Client_Detail_Assessment_HRMAssessment" %>
<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>
<% if (HttpContext.Current == null)
   { %>
<link href="../../../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet"
    type="text/css" />
<%} %>

<script src="<%=RelativePath%>JScripts/ApplicationScripts/GeneralFormFunctions.js"
    type="text/javascript"></script>

<script src="<%=RelativePath%>JScripts/ApplicationScripts/GeneralArrayHelpers.js"
    type="text/javascript"></script>

<script type="text/javascript" language="javascript" src="<%=RelativePath%>Custom/DLA-20/Scripts/DLA20Youth.js"></script>
<script type="text/javascript" language="javascript" src="<%=RelativePath%>Custom/DLA-20/Scripts/DLA.js"></script>

<script type="text/javascript" language="javascript" src="<%=RelativePath%>Custom/DLA-20/Scripts/tooltipsy.min.js"></script>

<script language="javascript" type="text/javascript" src="<%=RelativePath%>Custom/Assessment/Scripts/Assesment.js"></script>

<script language="javascript" type="text/javascript" src="<%=RelativePath%>Custom/Assessment/Scripts/LookupPopUp.js"></script>

<script language="javascript" type="text/javascript" src="<%=RelativePath%>Custom/Assessment/Scripts/SustanceUseHistory.js"></script>

<script language="javascript" type="text/javascript" src="<%=RelativePath%>Custom/Assessment/Scripts/CalculateNeeds.js"></script>

<script src="<%=RelativePath%>Modules/CarePlan/Scripts/CarePlanNeeds.js" type="text/javascript"></script>

<script src="<%=RelativePath%>JScripts/ApplicationScripts/jquery.tmpl.min.js" type="text/javascript"></script>

<%--<script type="text/javascript" language="javascript" src="<%=RelativePath%>Custom/Assessment/Scripts/DLA.js"></script>
--%>

<script type="text/javascript" language="javascript" src="<%=RelativePath%>ICD10Diagnosis/Scripts/ICDTenDiagnosis.js"></script>

<%--<script type="text/javascript" language="javascript" src="<%=RelativePath%>Custom/Assessment/Scripts/CSSRSAdultScreeners.js"></script>
--%>

<%--<script type="text/javascript" src="<%=RelativePath %>JScripts/ApplicationScripts/GeneralArrayHelpers.js"></script>

<script type="text/javascript" src="<%=RelativePath %>JScripts/ApplicationScripts/GeneralFormFunctions.js"></script>--%>

<%--<script type="text/javascript" language="javascript" src="<%=RelativePath%>Custom/DLA-20/Scripts/DLAMain.js"></script>--%>


<%--<script type="text/javascript" language="javascript" src="<%=RelativePath%>Custom/Assessment/Scripts/CSSRSChildAdolescentSinceLT.js"></script>

<script type="text/javascript" language="javascript" src="<%=RelativePath%>Custom/Assessment/Scripts/CSSRSAdultSinceLT.js"></script>
--%>
<style type="text/css">
    .RadTabStrip .rtsLink, .RadTabStrip .rtsOut, .RadTabStrip .rtsIn
    {
        padding-left: 0px;
        padding-right: 0px;
    }
    .tooltipsy
    {
        padding: 10px;
        max-width: 600px;
        color: #303030;
        background-color: #E0E0E0;
        border: 1px solid #deca7e;
    }
</style>
<script type="text/javascript">
    $('.hastip').tooltipsy();
</script>

<table width="100%" border="0" cellpadding="0" cellspacing="0" style="padding-left: 0px;">
    <tr>
        <td valign="top" style="width: 100%; padding-top: 0px;">
            <telerik:RadTabStrip ID="RadTabStrip1" Skin="Vista" Width="840px" OnClientTabSelected="onTabSelected" ClientIDMode="Static"
                OnClientTabSelecting="ClientTabSelectingHandler" runat="server" MultiPageID="RadMultiPage1"
                OnClientLoad="StoreTabstripClientObject" SelectedIndex="0" EnableEmbeddedScripts="False"
                EnableEmbeddedSkins="False">
                <Tabs>
                    <telerik:RadTab Text="Initial" UcName="AssessmentHRMInitial" Path="/Custom/Assessment/WebPages/HRMInitial.ascx"
                        runat="server">
                    </telerik:RadTab>
                    <telerik:RadTab Text="Gambling" UcName="Gambling" Path="/Custom/Assessment/WebPages/GamblingTab.ascx"
                        runat="server">
                    </telerik:RadTab>
                    <%--  <telerik:RadTab Text="DLA-20" UcName="HRMDla" Path="/Custom/Assessment/WebPages/HRMDla.ascx"
                        runat="server">
                    </telerik:RadTab>--%>
                    <%-- <telerik:RadTab Text="CAFAS" UcName="HRMCAFAS" Path="/Custom/Assessment/WebPages/HRMCAFAS.ascx"
                        runat="server">
                    </telerik:RadTab>--%>
                    <%--  <telerik:RadTab Text="RAP Community" UcName="HRMRAPCommunity" Path="/Custom/Assessment/WebPages/HRMRAPCommunity.ascx"
                        runat="server" HrmNeeds="37^38^39^40^41^42^43^44^45^46^47^48^49^50^131">
                    </telerik:RadTab>
                    <telerik:RadTab Text="RAP Behaviors" UcName="HRMRAPBehaviors" Path="/Custom/Assessment/WebPages/HRMRAPBehaviors.ascx"
                        runat="server" HrmNeeds="51^52^53^120^132">
                    </telerik:RadTab>
                    <telerik:RadTab Text="RAP Abilities" UcName="HRMRAPAbilites" Path="/Custom/Assessment/WebPages/HRMRAPAbilites.ascx"
                        runat="server" HrmNeeds="54^55^56^57^58^59^60^61^62^63^133">
                    </telerik:RadTab>
                    <telerik:RadTab Text="RAP Health" UcName="HRMRAPHealth" Path="/Custom/Assessment/WebPages/HRMRAPHealth.ascx"
                        runat="server" HrmNeeds="64^65^66^67^68^69^70^71^72^73^134^136^139">
                    </telerik:RadTab>--%>
                    <telerik:RadTab Text="UNCOPE" UcName="HRMUncope" Path="/Custom/Assessment/WebPages/HRMUncope.ascx"
                        runat="server">
                    </telerik:RadTab>
                    <telerik:RadTab Text="CRAFFT" UcName="CrafftAssessment" Path="/Custom/Assessment/WebPages/CraftAssessment.ascx"
                        runat="server">
                    </telerik:RadTab>
                    <telerik:RadTab Text="Substance Abuse" UcName="HRMSuAssessment" Path="/Custom/Assessment/WebPages/SuAssessment.ascx"
                        runat="server">
                    </telerik:RadTab>
                    <%--<telerik:RadTab Text="PES" UcName="HRMPES" Path="/Custom/Assessment/WebPages/PES.ascx"
                        runat="server">
                    </telerik:RadTab>--%>
                    <telerik:RadTab Text="Psychosocial Adult" UcName="HRMPsychosocialAdult" Path="/Custom/Assessment/WebPages/HRMPsychosocialAdult.ascx"
                        runat="server">
                    </telerik:RadTab>
                    <telerik:RadTab Text="Psychosocial Child" UcName="HRMPsychosocialChild" Path="/Custom/Assessment/WebPages/HRMPsychosocialChild.ascx"
                        runat="server">
                    </telerik:RadTab>
                    <telerik:RadTab Text="Psychosocial DD" UcName="HRMDDPsychosocial" Path="/Custom/Assessment/WebPages/HRMDDPsychosocial.ascx"
                        runat="server">
                    </telerik:RadTab>
                    <telerik:RadTab Text="Supports" UcName="HRMSupport" Path="/Custom/Assessment/WebPages/HRMSupport.ascx"
                        runat="server">
                    </telerik:RadTab>
                    <telerik:RadTab Text="Mental Status" UcName="HRMMentalStatus" Path="/Custom/Assessment/WebPages/HRMMentalStatus.ascx"
                        runat="server">
                    </telerik:RadTab>
                    <telerik:RadTab Text="Risk Assessment" UcName="HRMRiskAssessment" Path="/Custom/Assessment/WebPages/HRMRiskAssessment.ascx"
                        runat="server">
                    </telerik:RadTab>
                    <%-- <telerik:RadTab Text="CSSRS - Adult LT" UcName="CSSRSAdultLT" Path="/Custom/Assessment/WebPages/CSSRSAdultLT.ascx"
                        runat="server">
                    </telerik:RadTab>--%>
                    <%-- <telerik:RadTab Text="CSSRS - Lifetime / Recent Child" UcName="CSSRSLifeTimeRecentChild" Path="/Custom/Assessment/WebPages/CSSRSAdultLifetimeChild.ascx"
                        runat="server">
                    </telerik:RadTab>
                     <telerik:RadTab Text="CSSRS Adult Since LT" UcName="CSSRSAdultSinceLT" Path="/Custom/Assessment/WebPages/CSSRSAdultSinceLT.ascx"
                        runat="server">
                    </telerik:RadTab>
                       <telerik:RadTab Text="CSSRS Adult Screeners" UcName="CSSRSAdultScreeners" Path="/Custom/Assessment/WebPages/CSSRSAdultScreeners.ascx"
                        runat="server">
                    </telerik:RadTab>
                   <telerik:RadTab Text="CSSRS - Child LT" UcName="CSSRSChildLT" Path="/Custom/Assessment/WebPages/CSSRSChildLT.ascx"
                        runat="server">
                    </telerik:RadTab>
                     <telerik:RadTab Text="CSSRS Child Adolescent Since LT" UcName="CSSRSChildAdolescentSinceLT" Path="/Custom/Assessment/WebPages/CSSRSChildAdolescentSinceLT.ascx"
                        runat="server">
                    </telerik:RadTab>--%>
                    <telerik:RadTab Text="Family Medical History" UcName="FamilyHistory" Path="/FamilyHistory/Client/Detail/Documents/FamilyHistory.ascx"
                        runat="server" Selected="True">
                    </telerik:RadTab>
                    <telerik:RadTab Text="Dx" UcName="HRMDXDD" Path="/ICD10Diagnosis/Documents/ICDTenDiagnosis.ascx"
                        runat="server">
                    </telerik:RadTab>
                    <telerik:RadTab Text="Needs List" UcName="HRMNeedList" Path="/Modules/CarePlan/ActivityPages/Client/Detail/Documents/CarePlanNeeds.ascx"
                        runat="server">
                    </telerik:RadTab>
                    <telerik:RadTab Text="Summary/Level of Care" UcName="HRMSummary" Path="/Custom/Assessment/WebPages/HRMSummary.ascx"
                        runat="server">
                    </telerik:RadTab>
                    <%--    <telerik:RadTab Text="Pre Plan" UcName="HRMPrePlan" Path="/Custom/Assessment/WebPages/HRMPrePlan.ascx"
                        runat="server" >
                    </telerik:RadTab>--%>
                    <telerik:RadTab Text="Safety/Crisis Plan" UcName="PlanCrisisSafety" Path="/Custom/Assessment/WebPages/SafetyCrisisPlan.ascx"
                        runat="server">
                    </telerik:RadTab>
                    <telerik:RadTab Text="Facility" UcName="Disposition" Path="/Custom/Assessment/WebPages/Disposition.ascx"
                        runat="server">
                    </telerik:RadTab>

                   <telerik:RadTab Text="DLA-20" UcName="DLA20" Path="/Custom/DLA-20/WebPages/DLA20.ascx"
                        runat="server">
                    </telerik:RadTab>
                   <telerik:RadTab Text="DLA-20 Y" UcName="YDLA20Y" Path="/Custom/DLA-20/WebPages/DLA20Y.ascx"
                        runat="server">
                    </telerik:RadTab>


                </Tabs>
            </telerik:RadTabStrip>
            <telerik:RadMultiPage ID="RadMultiPage1" EnableEmbeddedScripts="false" runat="server"
                SelectedIndex="0" CssClass="pageView">
                <telerik:RadPageView ID="AssessmentHRMInitial" runat="server" ClientIDMode="Static">
                </telerik:RadPageView>
                <telerik:RadPageView ID="Gambling" runat="server" ClientIDMode="Static">
                </telerik:RadPageView>
                <%--<telerik:RadPageView ID="HRMDla" runat="server">
                </telerik:RadPageView>
                <telerik:RadPageView ID="HRMCAFAS" runat="server">
                </telerik:RadPageView>--%>
                <%--<telerik:RadPageView ID="HRMRAPCommunity" runat="server">
                </telerik:RadPageView>--%>
                <%--<telerik:RadPageView ID="HRMRAPBehaviors" runat="server">
                </telerik:RadPageView>--%>
                <%--<telerik:RadPageView ID="HRMRAPAbilites" runat="server">
                </telerik:RadPageView>--%>
                <%--<telerik:RadPageView ID="HRMRAPHealth" runat="server">
                </telerik:RadPageView>--%>
                <telerik:RadPageView ID="HRMUncope" runat="server" ClientIDMode="Static">
                </telerik:RadPageView>
                <telerik:RadPageView ID="CrafftAssessment" runat="server" ClientIDMode="Static">
                </telerik:RadPageView>
                <telerik:RadPageView ID="HRMSuAssessment" runat="server" ClientIDMode="Static">
                </telerik:RadPageView>
                <%-- <telerik:RadPageView ID="HRMPES" runat="server">
                </telerik:RadPageView>--%>
                <telerik:RadPageView ID="HRMPsychosocialAdult" runat="server" ClientIDMode="Static">
                </telerik:RadPageView>
                <telerik:RadPageView ID="HRMPsychosocialChild" runat="server" ClientIDMode="Static">
                </telerik:RadPageView>
                <telerik:RadPageView ID="HRMDDPsychosocial" runat="server" ClientIDMode="Static">
                </telerik:RadPageView>
                <telerik:RadPageView ID="HRMSupport" runat="server" ClientIDMode="Static">
                </telerik:RadPageView>
                <telerik:RadPageView ID="HRMMentalStatus" runat="server" ClientIDMode="Static">
                </telerik:RadPageView>
                <telerik:RadPageView ID="HRMRiskAssessment" runat="server" ClientIDMode="Static">
                </telerik:RadPageView>
                <%-- <telerik:RadPageView ID="CSSRSAdultLT" runat="server">
                </telerik:RadPageView>--%>
                <%--  <telerik:RadPageView ID="CSSRSLifeTimeRecentChild" runat="server">
                </telerik:RadPageView>
                  <telerik:RadPageView ID="CSSRSAdultSinceLT" runat="server">
                </telerik:RadPageView>
                 <telerik:RadPageView ID="CSSRSAdultScreeners" runat="server">
                </telerik:RadPageView>
              <telerik:RadPageView ID="CSSRSChildLT" runat="server">
                </telerik:RadPageView>
                <telerik:RadPageView ID="CSSRSChildAdolescentSinceLT" runat="server">
                </telerik:RadPageView>--%>
                <telerik:RadPageView ID="FamilyHistory" runat="server" ClientIDMode="Static">
                </telerik:RadPageView>
                <telerik:RadPageView ID="HRMDXDD" runat="server" ClientIDMode="Static">
                </telerik:RadPageView>
                <telerik:RadPageView ID="HRMNeedList" runat="server" ClientIDMode="Static">
                </telerik:RadPageView>
                <telerik:RadPageView ID="HRMSummary" runat="server" ClientIDMode="Static">
                </telerik:RadPageView>
                <%--   <telerik:RadPageView ID="HRMPrePlan" runat="server">
                </telerik:RadPageView>--%>
                <telerik:RadPageView ID="PlanCrisisSafety" runat="server" ClientIDMode="Static">
                </telerik:RadPageView>
                <telerik:RadPageView ID="Disposition" runat="server" ClientIDMode="Static">
                </telerik:RadPageView>
                <telerik:RadPageView ID="DLA20" runat="server" ClientIDMode="Static">
                </telerik:RadPageView>
                <telerik:RadPageView ID="YDLA20Y" runat="server" ClientIDMode="Static">
                </telerik:RadPageView>
            </telerik:RadMultiPage>
        </td>
    </tr>
    <tr>
        <td>
            <input id="HiddenField_CustomHRMAssessments_DocumentVersionId" name="HiddenField_CustomHRMAssessments_DocumentVersionId"
                type="hidden" />
            <input type="hidden" id="HiddenField_DiagnosesIAndII_DiagnosisId" name="HiddenField_DiagnosesIAndII_DiagnosisId"
                value="-1" parentchildcontrols="True" />
            <input id="HiddenFieldPageTables" name="HiddenFieldPageTables" type="hidden" value="CustomHRMAssessments,CustomSubstanceUseAssessments,CustomSubstanceUseHistory2,CustomHRMAssessmentLevelOfCareOptions,CustomOtherRiskFactors,CustomHRMAssessmentSupports2,CustomMentalStatuses2,CustomDocumentCRAFFTs,CustomDispositions,CustomServiceDispositions,CustomProviderServices,CustomASAMPlacements,CustomDocumentAssessmentSubstanceUses,CustomHRMAssessmentMedications,DocumentFamilyHistory,CustomDocumentSafetyCrisisPlans,CustomSupportContacts,CustomSafetyCrisisPlanReviews,CustomCrisisPlanMedicalProviders,CustomCrisisPlanNetworkProviders,CustomDocumentDLA20s,CustomDailyLivingActivityScores,CustomYouthDLAScores,DocumentDiagnosisCodes,DocumentDiagnosis,DocumentDiagnosisFactors,CarePlanNeeds,CarePlanDomains,CarePlanDomainNeeds,CustomDocumentGambling" />
            <asp:HiddenField ID="HiddenCustomHRMNeedsDataTable" runat="server" />
            <asp:HiddenField ID="Hidden1" runat="server" />
            <asp:HiddenField ID="Hidden2" runat="server" />
            <asp:HiddenField ID="Hidden3" runat="server" />
            <input type="hidden" id="HiddenClientAge"  runat="server"/>
            <input id="HiddenField_CustomPsychosocialAdult2_DocumentVersionId" name="HiddenField_CustomPsychosocialAdult2_DocumentVersionId"
                type="hidden" value="" />
            <input id="HiddenCustomHRMActivitiesDataTable" runat="server" name="HiddenCustomHRMActivitiesDataTable"
                style="display: none" />
            <input id="HiddenCustomHRMActivitiesDataTableYouth" runat="server" name="HiddenCustomHRMActivitiesDataTableYouth"
                style="display: none" />
            <input id="HiddenUpdateAssessmentText" name="HiddenUpdateAssessmentText" style="display: none" />
            <input id="HiddenAgencyName" name="HiddenAgencyName" runat="server" type="hidden" />
            <input id="ActualLethalityMedicalDamage" name="HiddenFieldPageTables" type="hidden"
                value="0.  No physical damage or very minor physical damage (e.g., surface scratches).<br/>1.  Minor physical damage (e.g., lethargic speech; first-degree burns; mild bleeding; sprains).<br/>2.  Moderate physical damage; medical attention needed<br/>&nbsp&nbsp (e.g., conscious but sleepy, somewhat responsive; second-degree burns; bleeding of major vessel).<br/>3.  Moderately severe physical damage; medical hospitalization and likely intensive care required<br/>&nbsp&nbsp (e.g., comatose with reflexes intact; third-degree burns less than 20% of body; extensive blood loss but can recover; major fractures).<br/>4.  Severe physical damage; medical hospitalization with intensive care required<br/>&nbsp&nbsp (e.g., comatose without reflexes; third-degree burns over 20% of body; extensive blood loss with unstable vital signs; major damage to a vital area).<br/>5.  Death" />
            <input id="PotentialLethality" name="HiddenFieldPageTables" type="hidden" value="&nbsp Likely lethality of actual attempt if no medical damage <br/>&nbsp (the following examples, while having no actual medical damage, had potential for very serious lethality: <br/>&nbsp put gun in mouth and pulled the trigger but gun fails to fire so no medical damage;<br/>&nbsp laying on train tracks with oncoming train but pulled away before run over)." />
        </td>
    </tr>
</table>
<asp:Panel ID="MainPanelUC" runat="server">
</asp:Panel>
