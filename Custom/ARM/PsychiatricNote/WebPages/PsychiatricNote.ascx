<%@ Control Language="C#" AutoEventWireup="true" CodeFile="PsychiatricNote.ascx.cs" Inherits="SHS.SmartCare.Custom_PsychiatricNote_WebPages_PsychiatricNote" %>

<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>
<script type="text/javascript" language="javascript" src="<%=RelativePath%>JScripts/ApplicationScripts/GeneralFormFunctions.js"></script>
<script type="text/javascript" language="javascript" src="<%=RelativePath%>JScripts/ApplicationScripts/GeneralArrayHelpers.js"></script>
<script language="javascript" type="text/javascript" src="<%=RelativePath%>Custom/PsychiatricNote/Scripts/PsychiatricNote.js"></script>
<script src="<%=RelativePath%>JScripts/ApplicationScripts/jquery.tmpl.min.js" type="text/javascript"></script>
<style type="text/css">
    .RadTabStrip .rtsLink, .RadTabStrip .rtsOut, .RadTabStrip .rtsIn {
        padding-left: 0px;
        padding-right: 0px;
    }
</style>
<table id="TableMedicalNoteTabContainer" width="100%" border="0" cellpadding="0"
    cellspacing="0">
    <tr>
        <td valign="top" style="width: 100%; padding-top: 0px;">
            <telerik:RadTabStrip ID="RadTabStrip1" Skin="Vista" Width="832px" OnClientTabSelected="onTabSelectedClient"
                runat="server" MultiPageID="RadMultiPage1" OnClientLoad="StoreTabstripClientObject"
                EnableEmbeddedScripts="False" EnableEmbeddedSkins="False"  >
                <Tabs>
                    <telerik:RadTab Text="General" UcName="MyPsychiatricNoteGeneral" Path="/Custom/PsychiatricNote/WebPages/PsychiatricNoteGeneral.ascx"
                        runat="server">
                    </telerik:RadTab>
                    <telerik:RadTab Text="Exam" UcName="MyPsychiatricNoteExam" Path="/Custom/PsychiatricNote/WebPages/PsychiatricNoteExam.ascx"
                        runat="server">
                    </telerik:RadTab>
                    <telerik:RadTab Text="Medical Decision Making" UcName="MyPsychiatricNoteMDM" Path="/Custom/PsychiatricNote/WebPages/PsychiatricNoteMDM.ascx"
                        runat="server">
                    </telerik:RadTab>

                    <telerik:RadTab Text="Child/Adolescent" UcName="MyChildAdolescent" Path="/Custom/PsychiatricNote/WebPages/ChildAdolescent.ascx"
                        runat="server">
                    </telerik:RadTab>

                    <telerik:RadTab Text="AIMS" UcName="MyPsychiatricNoteAIMS" Path="/Custom/PsychiatricNote/WebPages/AIMS.ascx"
                        runat="server">
                    </telerik:RadTab>
                    <telerik:RadTab Text="Diagnosis" UcName="MyPsychiatricNoteDiagnosis" Path="/ICD10Diagnosis/Documents/ICDTenDiagnosis.ascx"
                        runat="server">
                    </telerik:RadTab>
                     
                </Tabs>
            </telerik:RadTabStrip>
            <telerik:RadMultiPage ID="RadMultiPage1" EnableEmbeddedScripts="false" runat="server"
                CssClass="pageView">
                <telerik:RadPageView ID="MyPsychiatricNoteGeneral" runat="server">
                </telerik:RadPageView>
                <telerik:RadPageView ID="MyPsychiatricNoteExam" runat="server">
                </telerik:RadPageView>
                <telerik:RadPageView ID="MyPsychiatricNoteMDM" runat="server">
                </telerik:RadPageView>
                    <telerik:RadPageView ID="MyChildAdolescent" runat="server">
                </telerik:RadPageView>
                <telerik:RadPageView ID="MyPsychiatricNoteAIMS" runat="server">
                </telerik:RadPageView>
                <telerik:RadPageView ID="MyPsychiatricNoteDiagnosis" runat="server">
                </telerik:RadPageView>
             
            </telerik:RadMultiPage>
        </td>
    </tr>
    <tr>
        <td>
            <input id="HiddenFieldPageTables" name="HiddenFieldPageTables" type="hidden" value="CustomDocumentPsychiatricNoteGenerals,CustomPsychiatricNoteProblems,CustomDocumentPsychiatricPCPProviders,CustomDocumentPsychiatricNoteExams,CustomDocumentPsychiatricNoteMDMs,CustomDocumentPsychiatricAIMSs,CustomDocumentPsychiatricNoteChildAdolescents,DocumentDiagnosis,DocumentDiagnosisFactors,NoteEMCodeOptions,CustomPsychiatricNoteSubstanceUses,CustomPsychiatricNoteMedicationHistory" />
            <input id="hiddenICDCodes" name="hiddenProgramCodes" type="hidden" runat="server" />
			<input id="hiddenProcedureCodes" name="hiddenProcedureCodes" type="hidden" runat="server" />
        </td>
    </tr>
</table>

<asp:Panel ID="PanelAjax" runat="server">
</asp:Panel>
