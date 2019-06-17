<%@ Control Language="C#" AutoEventWireup="true" CodeFile="DiagnosticEducationHistoryMinors.ascx.cs" Inherits="ActivityPages_Harbor_Client_Detail_Documents_DiagnosticAssessment_DiagnosticEducationHistoryMinors" %>
<%@ Register Src="~/CommonUserControls/DynamicForms.ascx" TagName="DynamicForms"
    TagPrefix="uc1" %>
<table border="0" cellpadding="0" cellspacing="0" class="DocumentScreen">
    <tr>
        <td class="height2">
        </td>
    </tr>
    <tr>
        <td>
            <div id="DivDiagnosticEHMinorsDFA">
                <uc1:DynamicForms ID="DynamicFormsDiagnosticEHMinors" runat="server" />
            </div>
        </td>
    </tr>
</table>