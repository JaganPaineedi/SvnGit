<%@ Control Language="C#" AutoEventWireup="true" CodeFile="DiagnosticInitialTxPlan.ascx.cs" Inherits="ActivityPages_Harbor_Client_Detail_Documents_DiagnosticAssessment_DiagnosticInitialTxPlan" %>
<%@ Register src="InitialTxPlan.ascx" tagname="TxPlan" tagprefix="uc1" %>
<% if (HttpContext.Current == null)
   { %>
<link href="<%=RelativePath%>App_Themes/Styles/smartcare_styles.css" rel="stylesheet"
    type="text/css" />
<%} %>
<div  style="overflow-x:hidden">
    <table border="0" cellpadding="0" cellspacing="0" width="100%" class="DocumentScreen">
   <tr><td style="height: 2px"></td></tr>
    <tr>
        <td style="width: 98%">
            <uc1:TxPlan ID="UserControl_UCTxPlan" runat="server"/>
        </td>
    </tr>
</table>
</div>
