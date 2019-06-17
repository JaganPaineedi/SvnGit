<%@ Control Language="C#" AutoEventWireup="true" CodeFile="PsychiatricRiskAssessment.ascx.cs" Inherits="ActivityPages_Harbor_Client_Detail_Documents_PsychiatricEvaluation_PsychiatricRiskAssessment" %>
<%@ Register Src="~/CommonUserControls/DynamicForms.ascx" TagName="DynamicForms"
    TagPrefix="uc2" %>

<table border="0" cellpadding="0" cellspacing="0" class="DocumentScreen">
    <tr>
        <td class="height2">
        </td>
    </tr>
    <tr>
        <td>
            <div id="DivPsychiatricRiskAssessmentDFA">
                <uc2:DynamicForms ID="DynamicFormsPsychiatricRiskAssessment" runat="server" />
           </div>
        </td>
    </tr>
</table>