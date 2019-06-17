<%@ Control Language="C#" AutoEventWireup="true" CodeFile="TreatmentPlanHarbor.ascx.cs"
    Inherits="SHS.SmartCare.ActivityPages_Client_Detail_HarborTreatmentPlan_TreatmentPlanHarbor" %>
 
<%@ Register src="~/Custom/WebPages/HarborTxPlan.ascx" TagName="TxPlan" TagPrefix="uc1" %>
<% if (HttpContext.Current == null)
   { %>
<link href="<%=RelativePath%>App_Themes/Styles/smartcare_styles.css" rel="stylesheet"
    type="text/css" />
<%} %>
<script type="text/javascript" language="javascript" src="~/Custom/Scripts/HarborTreatmentPlanInitial.js"></script>
<div  style="overflow-x:hidden">
    <table border="0" cellpadding="0" cellspacing="0" width="100%" >
   <tr><td style="height: 2px"></td></tr>
    <tr>
        <td style="width: 98%">
        <uc1:TxPlan ID="UserControl_UCTxPlan" runat="server"></uc1:TxPlan>
        </td>
    </tr>
</table>
<input id="HiddenFieldPageTables" name="HiddenFieldPageTables" type="hidden" value="CustomTreatmentPlans" />

</div>
