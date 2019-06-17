<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CustomInformedConsents.ascx.cs" Inherits="ActivityPages_Client_Detail_Documents_Threshold_CustomInformedConsents" %>
<%@ Register Src="~/CommonUserControls/DynamicForms.ascx" TagName="DynamicForms"
    TagPrefix="uc2" %>

<div id="DivCustomDocumentInformedConsentsDFA">
    <table border="0" cellspacing="0" cellpadding="0" style="width: 100%">
        <tr>
            <td class="height2">
            </td>
        </tr>
        <tr>
            <td>
                <uc2:DynamicForms ID="DynamicFormsCustomDocumentInformedConsents" width="820px" runat="server" />
            </td>
        </tr>
    </table>
    <input id="HiddenField_CustomDocumentInformedConsents_DocumentVersionId" name="HiddenField_CustomDocumentInformedConsents_DocumentVersionId"
        type="hidden" value="-1" />
    <input id="HiddenFieldPageTables" name="HiddenFieldPageTables" type="hidden" value="CustomDocumentInformedConsents" />
</div>