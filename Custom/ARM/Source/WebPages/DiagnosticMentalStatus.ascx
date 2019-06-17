<%@ Control Language="C#" AutoEventWireup="true" CodeFile="DiagnosticMentalStatus.ascx.cs" Inherits="ActivityPages_Harbor_Client_Detail_Documents_DiagnosticAssessment_DiagnosticMentalStatus" %>
<%@ Register Src="~/CommonUserControls/DynamicForms.ascx" TagName="DynamicForms"
    TagPrefix="uc2" %>

<table border="0" cellpadding="0" cellspacing="0" class="DocumentScreen">
    <tr>
        <td class="height2">
        </td>
    </tr>
    <tr>
        <td>
            <div id="DivDiagnosticMentalStatusDFA">
                <uc2:DynamicForms ID="DynamicFormsDiagnosticMentalStatus" runat="server" />
                  <uc2:DynamicForms ID="DynamicFormsMentalStatus" runat="server" />
            </div>
        </td>
    </tr>
</table>