<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Disposition.ascx.cs" Inherits="SHS.SmartCare.Disposition" %>
<table border="0" cellpadding="0" cellspacing="0" width="100%">
    <tr>
        <td>
            <table width="99%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class="height2">
                    </td>
                </tr>
                <tr>
                    <td>
                        <table cellspacing="0" cellpadding="0" border="0">
                            <tr>
                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                    Facilities
                                </td>
                                <td width="17" style="overflow: hidden">
                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif"
                                        width="17" height="26" alt="" />
                                </td>
                                <td class="content_tab_top" width="100%">
                                </td>
                                <td width="7">
                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_right.gif"
                                        width="7" height="26" alt="" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="content_tab_bg" style="padding-left: 5px">
                        <table border="0" cellpadding="0" cellspacing="5" width="100%">
                            <tr>
                                <td>
                                    <asp:Panel ID="MainPanelUC" runat="server">
                                    </asp:Panel>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td width="2" class="right_bottom_cont_bottom_bg">
                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                                        height="7" alt="" />
                                </td>
                                <td class="right_bottom_cont_bottom_bg" width="100%">
                                </td>
                                <td width="2" class="right_bottom_cont_bottom_bg" align="right">
                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif"
                                        height="7" alt="" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
