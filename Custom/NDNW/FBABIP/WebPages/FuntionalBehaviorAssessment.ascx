<%@ Control Language="C#" AutoEventWireup="true" CodeFile="FuntionalBehaviorAssessment.ascx.cs" Inherits="ActivityPages_Client_Detail_Documents_Threshold_FBABIP_FuntionalBehaviorAssessment" %>
<%@ Register Src="~/CommonUserControls/DynamicForms.ascx" TagName="DynamicForms"
    TagPrefix="uc2" %>
<table border="0" cellpadding="0" cellspacing="0" width="100%">
    <tr>
        <td>
                <uc2:DynamicForms ID="DynamicFormsFBA" runat="server" Width="820px" />
                <asp:HiddenField ID="HiddenFieldGlobaCodes" runat="server" />
        </td>
    </tr>
</table>    
    
