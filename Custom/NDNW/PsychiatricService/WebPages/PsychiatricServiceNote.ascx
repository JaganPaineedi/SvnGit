<%@ Control Language="C#" AutoEventWireup="true" CodeFile="PsychiatricServiceNote.ascx.cs" Inherits="SHS.SmartCare.Custom_PsychiatricService_WebPages_PsychiatricServiceNote" %>
<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>

<script language="javascript" type="text/javascript" src="<%=RelativePath%>Custom/PsychiatricService/Scripts/PsychiatricService.js"></script>

<script src="<%=RelativePath%>JScripts/ApplicationScripts/jquery.tmpl.min.js" type="text/javascript"></script>

<style type="text/css">
    .RadTabStrip .rtsLink, .RadTabStrip .rtsOut, .RadTabStrip .rtsIn
    {
        padding-left: 0px;
        padding-right: 0px;
    }
</style>
<table id="TablePsychiatricServiceTabContainer" width="100%" border="0" cellpadding="0"
    cellspacing="0">
    <tr>
        <td valign="top" style="width: 100%; padding-top: 0px;">
            <telerik:radtabstrip id="RadTabStrip1" skin="Vista" width="832px" onclienttabselected="onTabSelectedClient"
                runat="server" multipageid="RadMultiPage1" onclientload="StoreTabstripClientObject"
                enableembeddedscripts="False" enableembeddedskins="False">
                <Tabs>
                    <telerik:RadTab Text="General" UcName="PsychiatricServiceGeneral" Path="/Custom/PsychiatricService/WebPages/PsychiatricServiceGeneral.ascx"
                        runat="server">
                    </telerik:RadTab>
                    <telerik:RadTab Text="History" UcName="PsychiatricServiceHistory" Path="/Custom/PsychiatricService/WebPages/PsychiatricServiceHistory.ascx"
                        runat="server">
                    </telerik:RadTab>
                    <telerik:RadTab Text="Exam" UcName="PsychiatricServiceExam" Path="/Custom/PsychiatricService/WebPages/PsychiatricServiceExam.ascx"
                        runat="server">
                    </telerik:RadTab>
                    <telerik:RadTab Text="Medical Decision Making" UcName="PsychiatricServiceMDM" Path="/Custom/PsychiatricService/WebPages/PsychiatricServiceMDM.ascx"
                        runat="server">
                    </telerik:RadTab>
                    <telerik:RadTab Text="Diagnosis" UcName="PsychiatricServiceDiagnosis" Path="/ICD10Diagnosis/Documents/ICDTenDiagnosis.ascx"
                        runat="server">
                    </telerik:RadTab>
                    </Tabs>
            </telerik:radtabstrip>
            <telerik:radmultipage id="RadMultiPage1" enableembeddedscripts="false" runat="server"
                cssclass="pageView">
                <telerik:RadPageView ID="PsychiatricServiceGeneral" runat="server">
                </telerik:RadPageView>
                <telerik:RadPageView ID="PsychiatricServiceHistory" runat="server">
                </telerik:RadPageView>
                <telerik:RadPageView ID="PsychiatricServiceExam" runat="server">
                </telerik:RadPageView>
                <telerik:RadPageView ID="PsychiatricServiceMDM" runat="server">
                </telerik:RadPageView>
                <telerik:RadPageView ID="PsychiatricServiceDiagnosis" runat="server">
                </telerik:RadPageView>
             </telerik:radmultipage>
        </td>
    </tr>
    <tr>
        <td>
            <input id="HiddenFieldPageTables" name="HiddenFieldPageTables" type="hidden" value="CustomDocumentPsychiatricServiceNoteGenerals,CustomDocumentPsychiatricServiceNoteHistory,CustomPsychiatricServiceNoteProblems,CustomDocumentPsychiatricServiceNoteExams,CustomDocumentPsychiatricServiceNoteMDMs,DocumentDiagnosisCodes,DocumentDiagnosis,DocumentDiagnosisFactors,NoteEMCodeOptions" />
        </td>
     </tr>
</table>