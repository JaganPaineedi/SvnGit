<%@ Control Language="C#" AutoEventWireup="true" CodeFile="PsychiatricEvaluationNotes.ascx.cs"
    Inherits="ActivityPages_Harbor_Client_Detail_Documents_PsychiatricEvaluation_PsychiatricEvaluationNotes" %> 

<%@ Register Src="~/CommonUserControls/CustomGrid.ascx" TagName="CustomGrid" TagPrefix="uc1" %>

<script type="text/javascript" language="javascript" src="<%=RelativePath%>Custom/Scripts/PsychiatricEval.js"></script>
<script type="text/javascript" language="javascript" src="<%=RelativePath%>Custom/Scripts/PsychiatricRecommendations.js"></script>
<table border="0" cellpadding="0" cellspacing="0" width="100%">
    <tr>
        <td>
            <dxtc:ASPxPageControl ID="PsychiatricEvaluationsTabPage" ClientInstanceName="PsychiatricEvaluationsTabPage" runat="server" ActiveTabIndex="0"
                EnableHierarchyRecreation="True" CssFilePath="~/App_Themes/Styles/DevExpressTabStyles.css"
                Width="100%" Paddings-Padding="0px" ContentStyle-BorderLeft-BorderWidth="0px"
                ContentStyle-BorderRight-BorderWidth="0px" ContentStyle-Paddings-PaddingLeft="0px"
                ContentStyle-Paddings-PaddingRight="0px">
                <ClientSideEvents TabClick="function(s, e) { onTabSelected(s,e); }" ActiveTabChanged="function(s, e) {
	                                    onActiveTabChanged(s,e);
                                   }" />
                <TabPages>
                    <dxtc:TabPage Text="General" Name="/Custom/WebPages/CustomPsychiatricEvaluation.ascx">
                        <ContentCollection>
                            <dxw:ContentControl ID="ContentControlCustomPsychiatricEvaluation" runat="server">
                            </dxw:ContentControl>
                        </ContentCollection>
                    </dxtc:TabPage>
                    <dxtc:TabPage Text="Child Development" Name="/Custom/WebPages/PsychiatricChildDevelopmental.ascx">
                        <ContentCollection>
                            <dxw:ContentControl ID="ContentControlChildDevelopment" runat="server">
                            </dxw:ContentControl>
                        </ContentCollection>
                    </dxtc:TabPage>
                    <dxtc:TabPage Text="Child" Name="/Custom/WebPages/PsychiatricEvaluationChild.ascx">
                        <ContentCollection>
                            <dxw:ContentControl ID="ContentControlChildGeneral" runat="server">
                            </dxw:ContentControl>
                        </ContentCollection>
                    </dxtc:TabPage>
                    <dxtc:TabPage Text="Mental Status" Name="/Custom/WebPages/PsychiatricMentalStatus.ascx">
                        <ContentCollection>
                            <dxw:ContentControl ID="ContentControlMentalStatus" runat="server">
                            </dxw:ContentControl>
                        </ContentCollection>
                    </dxtc:TabPage>
                    <dxtc:TabPage Text="Risk" Name="/Custom/WebPages/PsychiatricRiskAssessment.ascx">
                        <ContentCollection>
                            <dxw:ContentControl ID="ContentControlRiskAssessment" runat="server">
                            </dxw:ContentControl>
                        </ContentCollection>
                    </dxtc:TabPage>
                    <dxtc:TabPage Text="Diagnosis" Name="/ICD10Diagnosis/Documents/ICDTenDiagnosis.ascx">
                        <ContentCollection>
                            <dxw:ContentControl ID="ContentControlDiagnosis" runat="server">
                            </dxw:ContentControl>
                        </ContentCollection>
                    </dxtc:TabPage>
                    <dxtc:TabPage Text="Medication / Labs" Name="/Custom/WebPages/PsychiatricMedicationsLabs.ascx">
                        <ContentCollection>
                            <dxw:ContentControl ID="ContentControlMedicationLabs" runat="server">
                            </dxw:ContentControl>
                        </ContentCollection>
                    </dxtc:TabPage>
                    <dxtc:TabPage Text="Recommendations" Name="/Custom/WebPages/PsychiatricRecommendations.ascx">
                        <ContentCollection>
                            <dxw:ContentControl ID="ContentControlRecommendations" runat="server">
                            </dxw:ContentControl>
                        </ContentCollection>
                    </dxtc:TabPage>
                    <dxtc:TabPage Text="Instructions" Name="/Custom/WebPages/PsychiatricPatientInstructions.ascx">
                        <ContentCollection>
                            <dxw:ContentControl ID="ContentControlPatientInstructions" runat="server">
                            </dxw:ContentControl>
                        </ContentCollection>
                    </dxtc:TabPage>
                </TabPages>
            </dxtc:ASPxPageControl>
        </td>
    </tr>
</table>
<input id="HiddenFieldPageTables" name="HiddenFieldPageTables" type="hidden" value="CustomDocumentPsychiatricEvaluations,CustomDocumentMentalStatuses,DocumentDiagnosis,DocumentDiagnosisFactors" />

<input id="HiddenField_CustomDocumentPsychologicalNotes_DocumentVersionId" name="HiddenField_CustomDocumentPsychologicalNotes_DocumentVersionId"
    type="hidden" value="-1" />
<input type="hidden" id="HiddenField_DiagnosesIAndII_DiagnosisId" name="HiddenField_DiagnosesIAndII_DiagnosisId"
    value="-1" parentchildcontrols="True" />
<input type="hidden" id="HiddenField_CustomDocumentPsychiatricEvaluationReferrals_ReferralId"
    name="HiddenField_CustomDocumentPsychiatricEvaluationReferrals_ReferralId" value="-1" parentchildcontrols="True" />
<asp:Panel ID="PanelAjaxCall" runat="server"></asp:Panel>
