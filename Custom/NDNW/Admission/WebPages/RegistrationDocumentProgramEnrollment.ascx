<%@ Control Language="C#" AutoEventWireup="true" CodeFile="RegistrationDocumentProgramEnrollment.ascx.cs"
    Inherits="Custom_Registration_WebPages_RegistrationDocumentProgramEnrollment" %>
<%@ Register Src="~/CommonUserControls/DynamicForms.ascx" TagName="DynamicForms"
    TagPrefix="uc2" %>
<div id="DivProgramEnrollmentDFA">
    <table border="0" cellspacing="0" cellpadding="0" style="width: 100%">
        <tr>
            <td class="height2">
            </td>
        </tr>
        <tr>
            <td>
                <uc2:DynamicForms ID="DynamicFormsProgramEnrollment" width="820px" runat="server" />
            </td>
        </tr>
    </table>
    <%--<input id="HiddenField_CustomRegistrations_DocumentVersionId" name="HiddenField_CustomRegistrations_DocumentVersionId"
        type="hidden" value="-1" />--%>
</div>
