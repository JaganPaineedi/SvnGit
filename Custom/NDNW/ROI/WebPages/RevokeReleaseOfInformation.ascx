<%@ Control Language="C#" AutoEventWireup="true" CodeFile="RevokeReleaseOfInformation.ascx.cs" Inherits="ActivityPages_Client_Detail_StJoe_RevokeReleaseOf_Information" %>
<%@ Register Src="~/CommonUserControls/DynamicForms.ascx" TagName="DynamicForms"
    TagPrefix="DFARevoke" %>
 <script src="<%= RelativePath%>Custom/ROI/Scripts/JSRevokeReleaseofInformation.js" type="text/javascript"></script>   
    
    <div id="DivRevokeROIDFA" runat="server">
    <table border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td>
            </td>
        </tr>
        <tr>
            <td>
                <DFARevoke:DynamicForms ID="DynamicFormsRevokeROI" width="820px" runat="server" />
            </td>
        </tr>
    </table>
    <input id="HiddenField_CustomDocumentRevokeReleaseOfInformations_DocumentVersionId" name="HiddenField_CustomDocumentRevokeReleaseOfInformations_DocumentVersionId"
        type="hidden" value="-1" />
    <input id="HiddenField_CustomDocumentRevokeReleaseOfInformations_DocumentId" name="HiddenField_CustomDocumentRevokeReleaseOfInformations_DocumentId"
        type="hidden" value="0" />
       
    <input id="HiddenFieldPageTables" name="HiddenFieldPageTables" type="hidden" value="CustomDocumentRevokeReleaseOfInformations" />

</div>
