<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Summary.ascx.cs" Inherits="SHS.SmartCare.ActivityPages_Client_CMDocuments_Summary" %>
<%@ Register src="~/CommonUserControls/DynamicForms.ascx" tagname="DynamicForms" tagprefix="uc1" %>

<div style="margin: 0px,0px,0px,0px; overflow-x: hidden" style="width:820px">

    <table   border="0" cellspacing="0" cellpadding="0" style="width:820px" >
    <tr>
            <td class="height2">
            </td>
        </tr>
    <tr>
        <td>
            <uc1:DynamicForms ID="DynamicForms1" width = "820px" runat="server" />
        </td>
    </tr>
    </table>
    <input id="HiddenField_CustomAcuteServicesPrescreens_DocumentVersionId" name="HiddenField_CustomAcuteServicesPrescreens_DocumentVersionId"
        type="hidden" value="-1" />
    
  <%--  <input id="HiddenFieldPageTables" name="HiddenFieldPageTables" type="hidden" value="CustomAcuteServicesPrescreens" />--%>
</div>
