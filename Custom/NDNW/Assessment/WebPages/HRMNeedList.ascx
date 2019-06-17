<%@ Control Language="C#" AutoEventWireup="true" CodeFile="HRMNeedList.ascx.cs" Inherits="SHS.SmartCare.ActivityPages_Client_Detail_Assessment_HRMNeedList" %>
<input type="hidden" id="hidden_RelativePath" value='<%=RelativePath%>' />
<% if (HttpContext.Current == null)
   { %>
<link href="../../../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet"
    type="text/css" />
<%} %>
<div style="overflow-x: hidden;">
    <table border="0" cellpadding="0" cellspacing="0" class="DocumentScreen">
        <tr>
            <td>
                <table border="0" cellpadding="0" cellspacing="0" width="99%">
                    <tr>
                        <td>
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr class="height2">
                                    <td>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td style="width:68%">
                                                </td>
                                                <td align="right" style="width:20%">
                                                    <span id="AddNeed" onclick="AddNeedList();" type="button" text="Add"></span>
                                                </td>
                                                <td align="right" style="width:12%">
                                                    <span id="CalculateNeeds" onclick="CalculateNeeds();" type="button" text="Calculate Needs"></span>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap="nowrap">
                                                    Needs List
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
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td class="padding_label1">
                                                    <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                                        <tr>
                                                            <td align="center" style="width: 33%">
                                                                <span class="form_label">Needs</span>
                                                            </td>
                                                            <td>
                                                            </td>
                                                            <td align="center" style="width: 40%">
                                                                <span class="form_label">Description Of Needs</span>
                                                            </td>
                                                            <td align="center" style="width: 27%">
                                                                <span class="form_label">Status</span>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr class="height2">
                                                <td>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <div id="DivNeedList">
                                                    </div>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
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
            </td>
        </tr>
    </table>
</div>
