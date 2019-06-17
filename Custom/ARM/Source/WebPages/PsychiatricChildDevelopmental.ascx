<%@ Control Language="C#" AutoEventWireup="true" CodeFile="PsychiatricChildDevelopmental.ascx.cs"
    Inherits="ActivityPages_Harbor_Client_Detail_Documents_PsychiatricEvaluation_PsychiatricChildDevelopmental" %>
<%@ Register Src="~/CommonUserControls/DynamicForms.ascx" TagName="DynamicForms" TagPrefix="uc2" %>
<div id="DivChildDevelopmentalDFA">
    <table border="0" cellpadding="0" cellspacing="0" class="DocumentScreen">
        <tr>
            <td class="height2">
            </td>
        </tr>
        <tr>
            <td>
                <uc2:DynamicForms ID="DynamicFormsPsychiatricEvaluationChildDevelopmental" runat="server" />
            </td>
        </tr>
    </table>
    <input id="HiddenField_CustomDocumentPsychiatricEvaluations_DocumentVersionId" name="HiddenField_CustomDocumentPsychiatricEvaluations_DocumentVersionId"
        type="hidden" value="-1" />
</div>
