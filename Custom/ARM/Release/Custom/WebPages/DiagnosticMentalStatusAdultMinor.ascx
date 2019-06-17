<%@ Control Language="C#" AutoEventWireup="true" CodeFile="DiagnosticMentalStatusAdultMinor.ascx.cs" Inherits="ActivityPages_Harbor_Client_Detail_Documents_DiagnosticAssessment_DiagnosticMentalStatusAdultMinor" %>
<%@ Register Src="~/CommonUserControls/DynamicForms.ascx" TagName="DynamicForms"
    TagPrefix="uc2" %>
<table border="0" cellpadding="0" cellspacing="0" class="DocumentScreen">
    <tr>
        <td class="height2">
        </td>
    </tr>
    <tr>
        <td>
            <div id="DivDiagnosticMentalStatusAdultMinorDFA">
                <uc2:DynamicForms ID="DynamicFormsDiagnosticMentalStatusAdultMinor" runat="server" />
                <uc2:DynamicForms ID="DynamicFormsDiagnosticSummary" runat="server" />
            </div>
        </td>
    </tr>
</table>