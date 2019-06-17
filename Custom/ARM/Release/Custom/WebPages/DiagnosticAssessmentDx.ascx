<%@ Control Language="C#" AutoEventWireup="true" CodeFile="DiagnosticAssessmentDx.ascx.cs" Inherits="ActivityPages_Harbor_Client_Detail_Documents_DiagnosticAssessment_DiagnosticAssessmentDx" %>
<%@ Register src="~/Custom/WebPages/Diagnosis.ascx" tagname="Diagnosis" tagprefix="uc1" %>
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
            <uc1:Diagnosis ID="UserControl_UCDiagnosis" runat="server" />
        </td>
    </tr>
</table>
</div>
