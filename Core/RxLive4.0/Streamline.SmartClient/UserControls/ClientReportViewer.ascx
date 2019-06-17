<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ClientReportViewer.ascx.cs"
    Inherits="UserControls_ClientReportViewer" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=9.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
   
<div>
    <table width="100%" cellpadding="0" cellspacing="0" border="0">
        <tr>
            <td>
                <div id="divMessage" runat="server" align="center" class="errorMessageClass">
                </div>
            </td>
        </tr>
        <tr>
            <td>
                <div id="divReportViewer" runat="server">
                    <rsweb:ReportViewer ID="ReportViewer1" ShowFindControls="false" ShowRefreshButton="false"
                        ShowParameterPrompts="false" ShowPrintButton="false" ShowExportControls="false"
                        AsyncRendering="false" runat="server" Font-Names="Verdana" Font-Size="8pt" 
                        ProcessingMode="Remote" Width="750px">
                        <ServerReport ReportServerUrl="" />
                    </rsweb:ReportViewer>
                </div>
            </td>
        </tr>
    </table>
</div>
