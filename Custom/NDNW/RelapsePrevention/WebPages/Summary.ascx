<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Summary.ascx.cs" Inherits="Custom_RelapsePrevention_WebPages_Summary" %>
<div>
    <table border="0" cellpadding="0" cellspacing="0" class="DocumentScreen">
        <tr>
            <td class="height2">
            </td>
        </tr>
        <tr>
            <td>
                <table width="850px" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td>
                            <div id="DivGridContainer">
                                <table cellspacing="0" cellpadding="0" width="100%">
                                    <tr>
                                        <td>
                                            <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                <tr>
                                                    <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                        Summary
                                                    </td>
                                                    <td width="17">
                                                        <img style="vertical-align: top;" height="26" width="17" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                                                    </td>
                                                    <td class="content_tab_top" width="100%">
                                                    </td>
                                                    <td width="7">
                                                        <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="content_tab_bg">
                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                <tr>
                                                    <td style="padding-left: 7px;">
                                                        <table width="90%" border="0" cellpadding="0" cellspacing="0">
                                                            <tr>
                                                                <td>
                                                                    <asp:ListView ID="GridViewSummaryGrid" runat="server" DataKeyNames="DocumentVersionId">
                                                                        <LayoutTemplate>
                                                                            <table cellpadding="0" cellspacing="0" border="0" class="ListPageContainer">
                                                                                <tr>
                                                                                    <td>
                                                                                        <asp:Panel ID="divHeader" runat="server" Style="width: 832px; margin-right: 18px;"
                                                                                            CssClass="ListPageHeader">
                                                                                            <table cellspacing="0" cellpadding="0" border="0" width="832px">
                                                                                                <tr>
                                                                                                    <td style="width: 14%">
                                                                                                        <asp:Panel ID="HyperLink_LifeDomains" runat="server" SortId="LifeDomains" CssClass="SortLabel">
                                                                                                            Life Domains</asp:Panel>
                                                                                                    </td>
                                                                                                    <td style="width: 14%">
                                                                                                        <asp:Panel ID="HyperLink_Goals" runat="server" SortId="Goals" CssClass="SortLabel">
                                                                                                            Goals</asp:Panel>
                                                                                                    </td>
                                                                                                    <td style="width: 17%">
                                                                                                        <asp:Panel ID="HyperLink_Objectives" runat="server" SortId="Objectives" CssClass="SortLabel">
                                                                                                            Objectives</asp:Panel>
                                                                                                    </td>
                                                                                                    <td style="width: 15%">
                                                                                                        <asp:Panel ID="HyperLink_ActionSteps" runat="server" SortId="ActionSteps" CssClass="SortLabel">
                                                                                                            Action Steps</asp:Panel>
                                                                                                    </td>
                                                                                                </tr>
                                                                                            </table>
                                                                                        </asp:Panel>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td valign="top">
                                                                                        <asp:Panel ID="divListPageContent" runat="server" CssClass="ListPageContent" Style="width: 850px;
                                                                                            height: 215px;">
                                                                                            <table width="100%" cellspacing="0" cellpadding="0">
                                                                                                <asp:PlaceHolder ID="itemPlaceholder" runat="server"></asp:PlaceHolder>
                                                                                            </table>
                                                                                        </asp:Panel>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </LayoutTemplate>
                                                                        <ItemTemplate>
                                                                            <tr class='<%# Container.DisplayIndex % 2 == 0 ? "" : "ListPageAltRow " %>ListPageHLRow'>
                                                                                <td style="width: 14%;">
                                                                                    <%#  Eval("LifeDomain")%>
                                                                                </td>
                                                                                <td style="width: 14%;">
                                                                                    <span id="Span_BedAssignments_EndDae" name="Span_BedAssignments_EndDae">
                                                                                        <%# "<div class=\"ellipsis\" Title=\"" + Eval("Goals").ToString() + "\">" + Eval("Goals").ToString() + "</div>"%>
                                                                                </td>
                                                                                <td style="width: 17%;">
                                                                                    <%# "<div class=\"ellipsis\" Title=\"" + Eval("Objectives").ToString() + "\">" + Eval("Objectives").ToString() + "</div>"%>
                                                                                    <%--  <%#  Eval("Objectives")%>--%>
                                                                                </td>
                                                                                <td align="left" style="width: 15%;">
                                                                                    <%# "<div class=\"ellipsis\" Title=\"" + Eval("ActionSteps").ToString() + "\">" + Eval("ActionSteps").ToString() + "</div>"%>
                                                                                    <%--<%#  Eval("ActionSteps")%>--%>
                                                                                </td>
                                                                            </tr>
                                                                        </ItemTemplate>
                                                                        <EmptyDataTemplate>
                                                                            <asp:Panel ID="divHeader" runat="server" Style="width: 830px; margin-right: 0px;">
                                                                                <table cellspacing="0" cellpadding="0" border="0" width="830px" class="ListPageHeader ListPageContainer">
                                                                                    <tr>
                                                                                        <td style="width: 14%">
                                                                                            <asp:Panel ID="HyperLink_StartDate" runat="server" SortId="LifeDomains" CssClass="SortLabel">
                                                                                                Life Domains</asp:Panel>
                                                                                        </td>
                                                                                        <td style="width: 14%">
                                                                                            <asp:Panel ID="HyperLink_EndDate" runat="server" SortId="Goals" CssClass="SortLabel">
                                                                                                Goals</asp:Panel>
                                                                                        </td>
                                                                                        <td style="width: 17%">
                                                                                            <asp:Panel ID="HyperLink_Activity" runat="server" SortId="Objectives" CssClass="SortLabel">
                                                                                                Objectives</asp:Panel>
                                                                                        </td>
                                                                                        <td style="width: 15%">
                                                                                            <asp:Panel ID="HyperLink_Disposition" runat="server" SortId="ActionSteps" CssClass="SortLabel">
                                                                                                ActionSteps</asp:Panel>
                                                                                        </td>
                                                                                    </tr>
                                                                                </table>
                                                                                <table cellspacing="0" border="0" style="height: 50px; border: 1px solid Gray" cellpadding="0"
                                                                                    width="830px">
                                                                                    <tr>
                                                                                        <td height="20px" align="center" valign="middle">
                                                                                            <asp:Label ID="Label2" runat="server" Style="color: Gray">No data to display</asp:Label>
                                                                                        </td>
                                                                                    </tr>
                                                                                </table>
                                                                            </asp:Panel>
                                                                        </EmptyDataTemplate>
                                                                    </asp:ListView>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td align="left">
                                                                    <asp:Panel ID="PanelPager" runat="server">
                                                                    </asp:Panel>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                <tr>
                                                    <td class="right_bottom_cont_bottom_bg" width="2">
                                                        <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_left.gif" />
                                                    </td>
                                                    <td class="right_bottom_cont_bottom_bg" width="100%">
                                                    </td>
                                                    <td class="right_bottom_cont_bottom_bg" align="right" width="2">
                                                        <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_right.gif" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</div>
