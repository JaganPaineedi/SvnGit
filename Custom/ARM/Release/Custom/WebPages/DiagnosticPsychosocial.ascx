<%@ Control Language="C#" AutoEventWireup="true" CodeFile="DiagnosticPsychosocial.ascx.cs" Inherits="ActivityPages_Harbor_Client_Detail_Documents_DiagnosticAssessment_DiagnosticPsychosocial" %>
<%@ Register Src="~/CommonUserControls/DynamicForms.ascx" TagName="DynamicForms" TagPrefix="uc2" %>

 <div id="DivDiagnosticPsychosocialDFA">
 
  <table border="0" cellspacing="0" cellpadding="0" style="width: 100%">
        <tr>
            <td class="height2">
            </td>
        </tr>
        <tr>
            <td>
                <uc2:DynamicForms ID="DynamicFormsDiagnosticPsychosocial" width="820px" runat="server" />
            </td>
        </tr>
    </table>
    <input id="HiddenField_CustomDocumentDiagnosticAssessments_DocumentVersionId" name="HiddenField_CustomDocumentDiagnosticAssessments_DocumentVersionId"
        type="hidden" value="-1" />
 </div>