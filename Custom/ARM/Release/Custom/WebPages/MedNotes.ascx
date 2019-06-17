<%@ Control Language="C#" AutoEventWireup="true" CodeFile="MedNotes.ascx.cs" Inherits="ActivityPages_Harbor_Client_Detail_Documents_MedNote_MedNotes" %>




<%@ Register Src="~/CommonUserControls/CustomGrid.ascx" TagName="CustomGrid" TagPrefix="uc1" %>

<script type="text/javascript" language="javascript" src="<%=RelativePath%>Custom/Scripts/MedNote.js"></script>

<table border="0" cellpadding="0" cellspacing="0" width="100%">
    <tr>
        <td>
            <dxtc:ASPxPageControl ID="MedNotesTabPage" runat="server" ActiveTabIndex="0"
                EnableHierarchyRecreation="True" CssFilePath="~/App_Themes/Styles/DevExpressTabStyles.css"
                Width="100%" Paddings-Padding="0px" ContentStyle-BorderLeft-BorderWidth="0px"
                ContentStyle-BorderRight-BorderWidth="0px" ContentStyle-Paddings-PaddingLeft="0px"
                ContentStyle-Paddings-PaddingRight="0px">
                <ClientSideEvents TabClick="function(s, e) { onTabSelected(s,e); }" ActiveTabChanged="function(s, e) {
	                                    onActiveTabChanged(s,e);
                                   }" />
                <TabPages>
                    <dxtc:TabPage Text="General" Name="/Custom/WebPages/MedNoteGeneral.ascx">
                        <ContentCollection>
                            <dxw:ContentControl ID="ContentControlMedNoteGeneral" runat="server">
                            </dxw:ContentControl>
                        </ContentCollection>
                    </dxtc:TabPage>
                    <dxtc:TabPage Text="Mental Status" Name="/Custom/WebPages/MedNoteMentalStatus.ascx">
                        <ContentCollection>
                            <dxw:ContentControl ID="ContentControlMedNoteMentalStatus" runat="server">
                            </dxw:ContentControl>
                        </ContentCollection>
                    </dxtc:TabPage>
                    <dxtc:TabPage Text="Diagnosis" Name="/Custom/WebPages/MedNoteDiagnosis.ascx">
                        <ContentCollection>
                            <dxw:ContentControl ID="ContentControlMedNoteDiagnosis" runat="server">
                            </dxw:ContentControl>
                        </ContentCollection>
                    </dxtc:TabPage>
                    <dxtc:TabPage Text="Medications" Name="/Custom/WebPages/MedNoteMedications.ascx">
                        <ContentCollection>
                            <dxw:ContentControl ID="ContentControlMedNoteMedications" runat="server">
                            </dxw:ContentControl>
                        </ContentCollection>
                    </dxtc:TabPage>
                    <dxtc:TabPage Text="Instructions" Name="/Custom/WebPages/MedNotePatientInstructions.ascx">
                        <ContentCollection>
                            <dxw:ContentControl ID="ContentControlMedNotePatientInstructions" runat="server">
                            </dxw:ContentControl>
                        </ContentCollection>
                    </dxtc:TabPage>
                </TabPages>
            </dxtc:ASPxPageControl>
        </td>
    </tr>
</table>

<input id="HiddenFieldPageTables" name="HiddenFieldPageTables" type="hidden" value="CustomDocumentMedicationReviewNotes,DiagnosesIII,DiagnosesIV,DiagnosesV,DiagnosesIANDIIMaxOrder,CustomDocumentMentalStatuses" />
<input id="HiddenField_CustomDocumentMedicationReviewNotes_DocumentVersionId" name="HiddenField_CustomDocumentMedicationReviewNotes_DocumentVersionId"
    type="hidden" value="-1" />
<input type="hidden" id="HiddenField_DiagnosesIAndII_DiagnosisId" name="HiddenField_DiagnosesIAndII_DiagnosisId"
    value="-1" parentchildcontrols="True" />
<asp:Panel ID="PanelAjaxCall" runat="server"></asp:Panel>
