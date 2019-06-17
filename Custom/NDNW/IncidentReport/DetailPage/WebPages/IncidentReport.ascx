<%@ Control Language="C#" AutoEventWireup="true" CodeFile="IncidentReport.ascx.cs" Inherits="SHS.SmartCare.Custom_IncidentReport_WebPages_IncidentReport" %>
<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>
<% if (HttpContext.Current == null)
   { %>
<link href="../../../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet"
    type="text/css" />
<%} %>
<script language="javascript" type="text/javascript" src="<%=RelativePath%>Custom/IncidentReport/DetailPage/Scripts/IncidentReport.js"></script>
<script language="javascript" type="text/javascript" src="<%=RelativePath%>JScripts/ApplicationScripts/Documents.js"></script>
<script src="<%=RelativePath%>JScripts/ApplicationScripts/jquery.tmpl.min.js" type="text/javascript"></script>


<table id="TableMedReviewNoteTabContainer" width="100%" border="0" cellpadding="0" cellspacing="0">
    <tr>
        <td valign="top" style="width: 100%; padding-top: 0px;">
            <telerik:RadTabStrip ID="RadTabStrip1" Skin="Vista" Width="840px" OnClientTabSelected="onTabSelected"
                OnClientTabSelecting="onTabSelectedClient" runat="server" MultiPageID="RadMultiPage1" CssClass="DocuementScreen"
                OnClientLoad="StoreTabstripClientObject" SelectedIndex="0" EnableEmbeddedScripts="False"
                EnableEmbeddedSkins="False">
                <Tabs>
                    <telerik:RadTab Text="Incident" UcName="Incident" Path="Custom/IncidentReport/DetailPage/WebPages/Incident.ascx"
                        runat="server">
                    </telerik:RadTab>
                     <telerik:RadTab Text="Fall" UcName="Fall" Path="Custom/IncidentReport/DetailPage/WebPages/Fall.ascx"
                        runat="server">
                    </telerik:RadTab>
                    <telerik:RadTab Text="Seizure" UcName="Seizure" Path="Custom/IncidentReport/DetailPage/WebPages/Seizure.ascx"
                        runat="server">
                    </telerik:RadTab>
                </Tabs>
            </telerik:RadTabStrip>
            <telerik:RadMultiPage ID="RadMultiPage1" EnableEmbeddedScripts="false" runat="server"
                SelectedIndex="0" CssClass="pageView">
                <telerik:RadPageView ID="Incident" runat="server">
                </telerik:RadPageView>
                <telerik:RadPageView ID="Fall" runat="server">
                </telerik:RadPageView>
                <telerik:RadPageView ID="Seizure" runat="server">
                </telerik:RadPageView>
            </telerik:RadMultiPage>
        </td>
    </tr>
    <tr>
        <td>
            <input id="HiddenFieldPageTables" name="HiddenFieldPageTables" type="hidden" value="CustomIncidentReports,CustomIncidentReportGenerals,CustomIncidentReportDetails,CustomIncidentReportFollowUpOfIndividualStatuses,CustomIncidentReportSupervisorFollowUps,CustomIncidentReportAdministratorReviews,CustomIncidentReportFallDetails,CustomIncidentReportFallFollowUpOfIndividualStatuses,CustomIncidentReportFallSupervisorFollowUps,CustomIncidentReportFallAdministratorReviews,CustomIncidentReportSeizureDetails,CustomIncidentSeizureDetails,CustomIncidentReportSeizureFollowUpOfIndividualStatuses,CustomIncidentReportSeizureSupervisorFollowUps,CustomIncidentReportSeizureAdministratorReviews,CustomIncidentReportManagerFollowUps,CustomIncidentReportSeizureManagerFollowUps,CustomIncidentReportFallManagerFollowUps" />
            <input id="HiddenField_CustomIncidentReports_IncidentReportId" name="HiddenField_CustomIncidentReports_IncidentReportId" type="hidden" />
            <input id="HiddenField_CustomIncidentReportGenerals_IncidentReportGeneralId" name="HiddenField_CustomIncidentReportGenerals_IncidentReportGeneralId" type="hidden" />
            <input id="HiddenField_CustomIncidentReportDetails_IncidentReportDetailId" name="HiddenField_CustomIncidentReportDetails_IncidentReportDetailId" type="hidden" />
            <input id="HiddenField_CustomIncidentReportFollowUpOfIndividualStatuses_IncidentReportFollowUpOfIndividualStatusId" name="HiddenField_CustomIncidentReportFollowUpOfIndividualStatuses_IncidentReportFollowUpOfIndividualStatusId" type="hidden" />
            <input id="HiddenField_CustomIncidentReportSupervisorFollowUps_IncidentReportSupervisorFollowUpId" name="HiddenField_CustomIncidentReportSupervisorFollowUps_IncidentReportSupervisorFollowUpId" type="hidden" />
            <input id="HiddenField_CustomIncidentReportManagerFollowUps_IncidentReportManagerFollowUpId" name="HiddenField_CustomIncidentReportManagerFollowUps_IncidentReportManagerFollowUpId" type="hidden" />
            <input id="HiddenField_CustomIncidentReportAdministratorReviews_IncidentReportAdministratorReviewId" name="HiddenField_CustomIncidentReportAdministratorReviews_IncidentReportAdministratorReviewId" type="hidden" />
            <input id="HiddenField_CustomIncidentReportFallDetails_IncidentReportFallDetailId" name="HiddenField_CustomIncidentReportFallDetails_IncidentReportFallDetailId" type="hidden" />
            <input id="HiddenField_CustomIncidentReportFallFollowUpOfIndividualStatuses_IncidentReportFallFollowUpOfIndividualStatusId" name="HiddenField_CustomIncidentReportFallFollowUpOfIndividualStatuses_IncidentReportFallFollowUpOfIndividualStatusId" type="hidden" />
            <input id="HiddenField_CustomIncidentReportFallSupervisorFollowUps_IncidentReportFallSupervisorFollowUpId" name="HiddenField_CustomIncidentReportFallSupervisorFollowUps_IncidentReportFallSupervisorFollowUpId" type="hidden" />
            <input id="HiddenField_CustomIncidentReportFallAdministratorReviews_IncidentReportFallAdministratorReviewId" name="HiddenField_CustomIncidentReportFallAdministratorReviews_IncidentReportFallAdministratorReviewId" type="hidden" />
            <input id="HiddenField_CustomIncidentReportSeizureDetails_IncidentReportSeizureDetailId" name="HiddenField_CustomIncidentReportSeizureDetails_IncidentReportSeizureDetailId" type="hidden" />
            <input id="HiddenField_CustomIncidentSeizureDetails_IncidentSeizureDetailId" name="HiddenField_CustomIncidentSeizureDetails_IncidentSeizureDetailId" type="hidden" />
            <input id="HiddenField_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_IncidentReportSeizureFollowUpOfIndividualStatusId" name="HiddenField_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_IncidentReportSeizureFollowUpOfIndividualStatusId" type="hidden" />
            <input id="HiddenField_CustomIncidentReportSeizureSupervisorFollowUps_IncidentReportSeizureSupervisorFollowUpId" name="HiddenField_CustomIncidentReportSeizureSupervisorFollowUps_IncidentReportSeizureSupervisorFollowUpId" type="hidden" />
            <input id="HiddenField_CustomIncidentReportSeizureAdministratorReviews_IncidentReportSeizureAdministratorReviewId" name="HiddenField_CustomIncidentReportSeizureAdministratorReviews_IncidentReportSeizureAdministratorReviewId" type="hidden" />
            <input id="HiddenField_LoggedInUserName" name="HiddenField_LoggedInUserName" type="hidden" runat="server"/>
        </td>
    </tr>
</table>
