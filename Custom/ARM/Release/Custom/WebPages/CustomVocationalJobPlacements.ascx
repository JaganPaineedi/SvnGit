<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CustomVocationalJobPlacements.ascx.cs"
    Inherits="SHS.SmartCare.CustomVocationalJobPlacements" %>

<%@ Register Assembly="Streamline.DotNetDropDownSubGlobalCodes" Namespace="Streamline.DotNetDropDownSubGlobalCodes"
    TagPrefix="cc3" %>
<%@ Register Assembly="Streamline.DotNetDropDowns" Namespace="Streamline.DotNetDropDowns"
    TagPrefix="cc5" %>
<%@ Register Assembly="Streamline.DropDowns" Namespace="Streamline.DropDowns" TagPrefix="cc2" %>
<% if (HttpContext.Current == null)
   { %>
<link href="../../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet"
    type="text/css" />
<%} %>

<script src="../../../../JScripts/SystemScripts/CalCode.js" type="text/javascript"></script>

<script src="../../../../JScripts/ApplicationScripts/ApplicationCommonFunctions.js"
    type="text/javascript"></script>

<script src="<%= RelativePath%>Custom/Scripts/CustomVocationalJobPlacements.js"
    type="text/javascript"></script>

<div>
    <table border="0" cellpadding="0" cellspacing="0" width="100%">
        <tr>
            <td>
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                        <td>
                            <table border="0" cellpadding="0" cellspacing="0" class="DocumentScreen">
                                <tr>
                                    <td>
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr runat="server" id="TableFiltersContainer">
                                                <td>
                                                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                        <tr>
                                                            <td>
                                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                    <tr>
                                                                        <td class="toplt_curve" style="width: 6px">
                                                                        </td>
                                                                        <td class="top_brd" style="width: 99%">
                                                                        </td>
                                                                        <td class="toprt_curve" style="width: 6px">
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="mid_bg ltrt_brd">
                                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                    <tr>
                                                                        <td>
                                                                            <table id="TablePageFilters" name="TablePageFilters" border="0" cellpadding="0" cellspacing="0"
                                                                                width="100%">
                                                                                <tr>
                                                                                    <td class="ListPageMiddleTable">
                                                                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                                            <tr>
                                                                                                <td align="left">
                                                                                                    <span class="form_label" style="padding-right: 5px;" id="Span3">Job Placed Between</span>
                                                                                                    <input type="text" tabindex="3" name="TextBox_JobDevelopmentFrom" class="date_text"
                                                                                                        id="TextBox_JobDevelopmentFrom" datatype="Date" value="<%=jobDevelopmentFrom%>" />
                                                                                                    <img id="Img3" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                                                        onclick="return showCalendar('TextBox_JobDevelopmentFrom', '%m/%d/%Y');" style="cursor: hand;
                                                                                                        vertical-align: text-bottom;" />
                                                                                                    <span style="padding-right: 5px; padding-left: 5px;" class="form_label" id="Span6">and</span>
                                                                                                    <input type="text" tabindex="4" name="TextBox_JobDevelopmentTo" class="date_text"
                                                                                                        id="TextBox_JobDevelopmentTo" datatype="Date" value="<%=jobDevelopmentTo%>" />
                                                                                                    <img id="Img1" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                                                        onclick="return showCalendar('TextBox_JobDevelopmentTo', '%m/%d/%Y');" style="cursor: hand;
                                                                                                        vertical-align: text-bottom;" filter="false" />
                                                                                                </td>
                                                                                                <td>
                                                                                                    <span style="padding-right: 5px; padding-left: 5px;" class="form_label" id="Span4">Job
                                                                                                        Start Between</span>
                                                                                                    <input type="text" tabindex="5" name="TextBox_JobStartBetweenFrom" class="date_text"
                                                                                                        id="TextBox_JobStartBetweenFrom" datatype="Date" value="<%=jobStartBetweenFrom%>" />
                                                                                                    <img id="Img2" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                                                        onclick="return showCalendar('TextBox_JobStartBetweenFrom', '%m/%d/%Y');" style="cursor: hand;
                                                                                                        vertical-align: text-bottom;" filter="false" />
                                                                                                    <span style="padding-right: 5px; padding-left: 5px;" class="form_label" id="Span2">and</span>
                                                                                                    <input type="text" tabindex="6" name="TextBox_JobStartBetweenTo" class="date_text"
                                                                                                        id="TextBox_JobStartBetweenTo" datatype="Date" value="<%=jobStartBetweenTo %>" />
                                                                                                    <img id="Img4" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                                                        onclick="return showCalendar('TextBox_JobStartBetweenTo', '%m/%d/%Y');" style="cursor: hand;
                                                                                                        vertical-align: text-bottom;" filter="false" />
                                                                                                </td>
                                                                                                <td align="center" style="width: 100px">
                                                                                                    <span id="Span1" onclick="return GetListPageWithFilters();" type="button" text="Apply Filter">
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
                                                        <tr>
                                                            <td>
                                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                    <tr>
                                                                        <td class="botlt_curve" style="width: 6px">
                                                                        </td>
                                                                        <td class="bot_brd" style="width: 99%">
                                                                        </td>
                                                                        <td class="botrt_curve" style="width: 6px">
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2">
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
                                        <asp:HiddenField ID="HiddenFieldPageFilters" runat="server" />
                                        <asp:HiddenField ID="HiddenFieldCurrentPageIndex" runat="server" />
                                        <asp:HiddenField ID="HiddenFieldAscDescHistory" runat="server" />
                                        <asp:HiddenField ID="HiddenFieldSortColumn" runat="server" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td>
                                        <div id="DivGridContainer">
                                            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td>
                                                        <asp:ListView ID="lvJobPlacement" runat="server" OnLayoutCreated="LayoutCreated">
                                                            <LayoutTemplate>
                                                                <table cellpadding="0" cellspacing="0" border="0" class="ListPageContainer">
                                                                    <tr>
                                                                        <td>
                                                                            <asp:Panel ID="divHeader" runat="server" Style="width: 832px; margin-right: 18px;"
                                                                                CssClass="ListPageHeader">
                                                                                <table cellspacing="0" cellpadding="0" border="0" width="1000px"">
                                                                                    <tr>
                                                                                        <td width="47px">
                                                                                            <asp:Panel ID="JobStartDate" runat="server" SortId="JobStartDate" CssClass="SortLabel">
                                                                                                Job Start Date</asp:Panel>
                                                                                        </td>
                                                                                        <td width="47px">
                                                                                            <asp:Panel ID="JobDevelopmentStartDate" runat="server" SortId="JobDevelopmentStartDate"
                                                                                                CssClass="SortLabel">
                                                                                                Place Date</asp:Panel>
                                                                                        </td>
                                                                                        <td width="97px">
                                                                                            <asp:Panel ID="EmployerName" runat="server" SortId="EmployerName" CssClass="SortLabel">
                                                                                                Employer Name</asp:Panel>
                                                                                        </td>
                                                                                        <td width="50px">
                                                                                            <asp:Panel ID="ReferredBy" runat="server" SortId="ReferredBy" CssClass="SortLabel">
                                                                                                Referred By</asp:Panel>
                                                                                        </td>
                                                                                        <td width="50px">
                                                                                            <asp:Panel ID="JobHoursPerWeek" runat="server" SortId="JobHoursPerWeek" CssClass="SortLabel">
                                                                                                Hours</asp:Panel>
                                                                                        </td>
                                                                                        <td width="50px">
                                                                                            <asp:Panel ID="JobShift" runat="server" SortId="JobShift" CssClass="SortLabel">
                                                                                                Shift</asp:Panel>
                                                                                        </td>
                                                                                        <td width="50px">
                                                                                            <asp:Panel ID="JobStartingWage" runat="server" SortId="JobStartingWage" CssClass="SortLabel">
                                                                                                Starting Wage</asp:Panel>
                                                                                        </td>
                                                                                        <td width="50px">
                                                                                            <asp:Panel ID="JobLossEndDate" runat="server" SortId="JobLossEndDate" CssClass="SortLabel">
                                                                                                End Date</asp:Panel>
                                                                                        </td>
                                                                                        <td width="97px">
                                                                                            <asp:Panel ID="JobLossReason" runat="server" SortId="JobLossReason" CssClass="SortLabel">
                                                                                                Reason</asp:Panel>
                                                                                        </td>
                                                                                    </tr>
                                                                                </table>
                                                                            </asp:Panel>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td valign="top">
                                                                            <asp:Panel ID="divListPageContent" runat="server" Style="width: 850px; height: 350px;"
                                                                                CssClass="ListPageContent">
                                                                                <table width="1000px" cellspacing="0" cellpadding="0">
                                                                                    <asp:PlaceHolder ID="itemPlaceholder" runat="server"></asp:PlaceHolder>
                                                                                </table>
                                                                            </asp:Panel>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </LayoutTemplate>
                                                            <ItemTemplate>
                                                                <tr class='<%# Container.DisplayIndex % 2 == 0 ? "" : "ListPageAltRow " %>ListPageHLRow'>
                                                        <td width="50px">
                                                            <%# "<div style=\"cursor:hand\" class=\"ellipsis\" Title=\"" + String.Format("{0:MM/dd/yyyy}", Eval("JobStartDate")) + "\" onclick=\"OpenPage(5761,'20551','CustomVocationalJobPlacementId=" + Eval("CustomVocationalJobPlacementId") + "',2,'" + Page.ResolveUrl("~/") + "');\"><u>" + String.Format("{0:MM/dd/yyyy}", Eval("JobStartDate")) + "</u></div>"%>
                                                        </td>
                                                        <td width="50px">
                                                            <%# "<div class=\"ellipsis\" Title=\"" + string.Format("{0:MM/dd/yyyy}", Eval("JobDevelopmentStartDate")) + "\">" + String.Format("{0:MM/dd/yyyy}", Eval("JobDevelopmentStartDate")) + "</div>"%>
                                                        </td>
                                                        <td width="100px">
                                                            <%# "<div class=\"ellipsis\" Title=\"" + Eval("EmployerName") + "\">" + Eval("EmployerName") + "</div>"%>
                                                        </td>
                                                        <td width="53px">
                                                            <%# "<div class=\"ellipsis\" Title=\"" + Eval("ReferredBy") + "\">" + Eval("ReferredBy") + "</div>"%>
                                                        </td>
                                                        <td width="53px">
                                                            <%# "<div class=\"ellipsis\" Title=\"" + string.Format("{0:n0}", Eval("JobHoursPerWeek")) + "\">" + string.Format("{0:n0}", Eval("JobHoursPerWeek")) + "</div>"%>
                                                        </td>
                                                        <td width="53px">
                                                            <%# "<div class=\"ellipsis\" Title=\"" + Eval("JobShift") + "\">" + Eval("JobShift") + "</div>"%>
                                                        </td>
                                                        <td width="53px">
                                                            <%# "<div class=\"ellipsis\" Title=\"" + string.Format("{0:c}", Eval("JobStartingWage")) + "\">" + string.Format("{0:c}", Eval("JobStartingWage")) + "</div>"%>
                                                        </td>
                                                        <td width="53px">
                                                            <%# "<div class=\"ellipsis\" Title=\"" + string.Format("{0:MM/dd/yyyy}", Eval("JobLossEndDate")) + "\">" + String.Format("{0:MM/dd/yyyy}", Eval("JobLossEndDate")) + "</div>"%>
                                                        </td>
                                                        <td width="100px">
                                                            <%# "<div class=\"ellipsis\" Title=\"" + Eval("JobLossReason") + "\">" + Eval("JobLossReason") + "</div>"%>
                                                        </td>
                                                    </tr>
                                                            </ItemTemplate>
                                                            <EmptyDataTemplate>
                                                                 <asp:Panel ID="divHeader" runat="server" Style="width: 850px;">
                                                        <table cellspacing="0" cellpadding="0" border="0" width="850px" class="ListPageHeader ListPageContainer">
                                                            <tr>
                                                                <td width="67px">
                                                                    <asp:Panel ID="JobStartDate" runat="server" SortId="JobStartDate" CssClass="SortLabel">
                                                                        Job Start Date</asp:Panel>
                                                                </td>
                                                                <td width="67px">
                                                                    <asp:Panel ID="JobDevelopmentStartDate" runat="server" SortId="JobDevelopmentStartDate"
                                                                        CssClass="SortLabel">
                                                                        Place Date</asp:Panel>
                                                                </td>
                                                                <td width="97px">
                                                                    <asp:Panel ID="EmployerName" runat="server" SortId="EmployerName" CssClass="SortLabel">
                                                                        Employer Name</asp:Panel>
                                                                </td>
                                                                <td width="70px">
                                                                    <asp:Panel ID="ReferredBy" runat="server" SortId="ReferredBy" CssClass="SortLabel">
                                                                        Referred By</asp:Panel>
                                                                </td>
                                                                <td width="50px">
                                                                    <asp:Panel ID="JobHoursPerWeek" runat="server" SortId="JobHoursPerWeek" CssClass="SortLabel">
                                                                        Hours</asp:Panel>
                                                                </td>
                                                                <td width="50px">
                                                                    <asp:Panel ID="JobShift" runat="server" SortId="JobShift" CssClass="SortLabel">
                                                                        Shift</asp:Panel>
                                                                </td>
                                                                <td width="70px">
                                                                    <asp:Panel ID="JobStartingWage" runat="server" SortId="JobStartingWage" CssClass="SortLabel">
                                                                        Starting Wage</asp:Panel>
                                                                </td>
                                                                <td width="60px">
                                                                    <asp:Panel ID="JobLossEndDate" runat="server" SortId="JobLossEndDate" CssClass="SortLabel">
                                                                        End Date</asp:Panel>
                                                                </td>
                                                                <td width="97px">
                                                                    <asp:Panel ID="JobLossReason" runat="server" SortId="JobLossReason" CssClass="SortLabel">
                                                                        Reason</asp:Panel>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                        <table cellspacing="0" border="1" style="height: 50px" cellpadding="0" width="850px">
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
                                        </div>
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
