<%@ Control Language="C#" AutoEventWireup="true" CodeFile="PsychiatricEvaluation.ascx.cs" Inherits="SHS.SmartCare.Custom_PsychiatricEvaluation_WebPages_PsychiatricEvaluation" %>
<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>
<script type="text/javascript" src="<%=RelativePath%>Custom/PsychiatricEvaluation/Scripts/PsychiatricEvaluation.js"></script>
<table id="TablePsychiatricEvaluationTabContainer" border="0" cellpadding="0" cellspacing="0" width="100%">
    <tr>
        <td>
            <telerik:RadTabStrip ID="RadTabStrip1PsychEvalTabPage" Skin="Vista" Width="832px"
                OnClientTabSelected="onTabSelectedClient" OnClientLoad="StoreTabstripClientObject"
                runat="server" MultiPageID="RadMultiPagePsychEvalTabPage" EnableEmbeddedScripts="False" EnableEmbeddedSkins="False">
                <Tabs>
                    <telerik:RadTab Text="General" UcName="General" Path="/Custom/PsychiatricEvaluation/WebPages/General.ascx"
                        runat="server">
                    </telerik:RadTab>
                    <telerik:RadTab Text="History" UcName="History" Path="/Custom/PsychiatricEvaluation/WebPages/History.ascx"
                        runat="server">
                    </telerik:RadTab>
                    <telerik:RadTab Text="Exam" UcName="Exam" Path="/Custom/PsychiatricEvaluation/WebPages/Exam.ascx"
                        runat="server">
                    </telerik:RadTab>
                    <telerik:RadTab Text="Medical Decision Making" UcName="MedicalDecisionMaking" Path="/Custom/PsychiatricEvaluation/WebPages/MedicalDecisionMaking.ascx"
                        runat="server">
                    </telerik:RadTab>
                    <telerik:RadTab Text="Diagnosis" UcName="PsychiatricEvaluationDiagnosis" Path="/ICD10Diagnosis/Documents/ICDTenDiagnosis.ascx"
                        runat="server">
                    </telerik:RadTab>
                </Tabs>
            </telerik:RadTabStrip>
            <telerik:RadMultiPage ID="RadMultiPagePsychEvalTabPage" EnableEmbeddedScripts="false"
                runat="server" SelectedIndex="0" CssClass="pageView">
                <telerik:RadPageView ID="General" runat="server">
                </telerik:RadPageView>
                <telerik:RadPageView ID="History" runat="server">
                </telerik:RadPageView>
                <telerik:RadPageView ID="Exam" runat="server">
                </telerik:RadPageView>
                <telerik:RadPageView ID="MedicalDecisionMaking" runat="server">
                </telerik:RadPageView>
                <telerik:RadPageView ID="PsychiatricEvaluationDiagnosis" runat="server">
                </telerik:RadPageView>
            </telerik:RadMultiPage>
        </td>
    </tr>
    <tr>
        <td>
            <input id="HiddenFieldPageTables" name="HiddenFieldPageTables" type="hidden" value="CustomDocumentPsychiatricEvaluations,CustomPsychiatricEvaluationProblems,DocumentDiagnosisCodes,DocumentDiagnosis,DocumentDiagnosisFactors,NoteEMCodeOptions" />
        </td>
    </tr>
</table>

