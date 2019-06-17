<%@ Control Language="C#" AutoEventWireup="true" CodeFile="DiagnosticPsychosocialAdult.ascx.cs" Inherits="ActivityPages_Harbor_Client_Detail_Documents_DiagnosticAssessment_DiagnosticPsychosocialAdult" %>
<%@ Register Src="~/CommonUserControls/DynamicForms.ascx" TagName="DynamicForms" TagPrefix="uc2" %>

 <div id="DivDiagnosticPsychosocialAdultDFA">
 
  <table border="0" cellspacing="0" cellpadding="0" style="width: 100%">
        <tr>
            <td class="height2">
            </td>
        </tr>
        <tr>
            <td>
                <uc2:DynamicForms ID="DynamicFormsDiagnosticPsychosocialAdult" width="820px" runat="server" />
            </td>
        </tr>
    </table>
    <input id="HiddenField_CustomDocumentDiagnosticAssessments_DocumentVersionId" name="HiddenField_CustomDocumentDiagnosticAssessments_DocumentVersionId"
        type="hidden" value="-1" />
 </div>