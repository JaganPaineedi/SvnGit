<%@ Control Language="C#" AutoEventWireup="true" CodeFile="MentalStatus.ascx.cs" Inherits="SHS.SmartCare.ActivityPages_Client_CMDocuments_MentalStatus" %>
<%@ Register src="~/CommonUserControls/DynamicForms.ascx" tagname="DynamicForms" tagprefix="uc1" %>

<div>
    <table width="97%" border="0" cellspacing="0" cellpadding="0">
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
    <%--Changes made by Vikas Kashyup- Ref Task 396- 9-Nov-2011- HiddenFieldPageTables commented to pass tables Names from Main Tab PrescreenEvent.ascx--%>
    <%--<input id="HiddenFieldPageTables" name="HiddenFieldPageTables" type="hidden" value="CustomAcuteServicesPrescreens" />--%>
</div>
