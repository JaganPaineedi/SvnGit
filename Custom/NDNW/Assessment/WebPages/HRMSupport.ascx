<%@ Control Language="C#" AutoEventWireup="true" CodeFile="HRMSupport.ascx.cs" Inherits="SHS.SmartCare.ActivityPages_Client_Detail_Assessment_HRMSupport" %>
<input type="hidden" id="hiddenReletivePath" value='<%=RelativePath%>' />
<% if (HttpContext.Current == null)
   { %>
<link href="../../../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet"
    type="text/css" />
<%} %>
<%--<asp:Panel ID="PanelTxPlanMain" runat="server" Width="97%" ParentChildControls='True'>
            </asp:Panel>--%>
<div style="overflow-x:hidden" >
<table border="0" cellpadding="0" cellspacing="0" class="DocumentScreen">
 <tr>
   <td>
   
    <table border="0" cellpadding="0" cellspacing="0" width="99%">
        <tr>
            <td valign="top" class="LPadd8">
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                        <td class="height2">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="content_tab_left" align="left"  nowrap="nowrap">
                                        Supports
                                    </td>
                                    <td width="17">
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
                        <td class="content_tab_bg">
                            <table cellpadding="0" cellspacing="0" border="0">
                                <tr>
                                    <td>
                                        <div id="DivSupport">
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height4">
                                    </td>
                                </tr>
                                <tr>
                                    <td class="LPadd8" align="left">
                                        <asp:PlaceHolder ID="PlaceHolderControlSupport" runat="server"><a href="javascript:void(0);"
                                            border="0" onclick="javascript:AddSupportSection();" id="AnchorAddSupport" style="text-decoration: underline;">
                                            <span id="SpanAddSupport" class="form_label">Add Support</span></a></asp:PlaceHolder>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height4">
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                <tbody>
                                    <tr>
                                        <td width="2" class="right_bottom_cont_bottom_bg">
                                            <img height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                                                style="vertical-align: top;" />
                                        </td>
                                        <td width="100%" class="right_bottom_cont_bottom_bg">
                                        </td>
                                        <td align="right" width="2" class="right_bottom_cont_bottom_bg">
                                            <img height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif"
                                                style="vertical-align: top;" />
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    </td>
 </tr>
</table>
</div>
<table cellpadding="0" cellspacing="0" border="0">
</table>
<%--<asp:PlaceHolder ID="PlaceHolderControlSupport" runat="server" class="LPadd8"></asp:PlaceHolder>--%>
<%--<asp:HiddenField ID="HiddenFiedNeedCount" runat="server" />--%>