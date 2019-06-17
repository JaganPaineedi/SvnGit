<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PreviewPharmacy.aspx.cs" Inherits="PreviewPharmacy" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
    
<body>
    <form id="form1" runat="server">
    <div>
   <table width="99%" border="0">
    <tr>
                    <!-- Inner Table Fifth Row Contains No Information-->
                    <td class="style2">&nbsp;
                        <asp:Label ID="LabelClientScript" runat="server" Text="Label" Visible="False"></asp:Label>
                    </td>
                </tr>
     <tr>
                    <td colspan="2">
                        <table cellpadding="0" cellspacing="0" style="border-right: #dee7ef 3px solid; border-top: #dee7ef 3px solid; border-left: #dee7ef 3px solid; border-bottom: #dee7ef 3px solid; height: 470px;"
                            width="100%">
                            <tr>
                                <td>
                                    <asp:Panel ID="Panel1" runat="server" Width="100%" Height="470px" ScrollBars="Vertical">
                                        <div id="divReportViewer" runat="server" style="width: 100%; scrollbar-3dlight-color: Azure;" >
                                            </div>
                                    </asp:Panel>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
    </table>
    </div>
    </form>
</body>
</html>
