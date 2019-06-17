<%@ Control Language="C#" AutoEventWireup="true" CodeFile="MemberInquiriesList.ascx.cs"
    Inherits="Custom_InquiryDetails_MemberInquiriesList" %>
 
<%@ Register Namespace="SHS.CustomControl" TagPrefix="SHSC" %>
<%@ Register Assembly="Streamline.DotNetDropDowns" Namespace="Streamline.DotNetDropDowns"
    TagPrefix="cc1" %>
<%@ Register Assembly="Streamline.DotNetDropDownGlobalCodes" Namespace="Streamline.DotNetDropDownGlobalCodes"
    TagPrefix="cc2" %>
<%@ Register Assembly="Streamline.DotNetDropDownSubGlobalCodes" Namespace="Streamline.DotNetDropDownSubGlobalCodes"
    TagPrefix="cc3" %>
<% if (HttpContext.Current == null)
   { %>
<link href="../../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet" type="text/css" />
<%} %>

<script language="javascript" type="text/javascript" src="<%=RelativePath%>Custom/InquiryDetails/Scripts/MemberInquiriesList.js"></script>

<div class="bottom_contanier_white_bg">
    <table width="850px" border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td>
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr valign="top">
                        <td align="left">
                        </td>
                    </tr>
                    <tr runat="server" id="TableFiltersContainer">
                        <td>
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td>
                                        <table border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
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
                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                    <tr>
                                                                        <td>
                                                                            <table width="850px" border="0" cellpadding="0" cellspacing="0" id="TablePageFilters"
                                                                                name="TablePageFilters">
                                                                                <tr>
                                                                                    <td valign="top" class="ListPageMiddleTable">
                                                                                        <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                                                            <tr>
                                                                                                <td align="left" class="form_dropdownTD" style="width: 185px">
                                                                                                    <cc1:StreamlineDropDowns ID="DropDownList_RecordedBy" Width="185px" runat="server"
                                                                                                        TabIndex="1" AddBlankRow="true" BlankRowText="Recorded By All" CssClass="form_dropdown">
                                                                                                    </cc1:StreamlineDropDowns>
                                                                                                </td>
                                                                                                <td style="width: 10px">
                                                                                                    &nbsp;
                                                                                                </td>
                                                                                                <td align="left" class="form_dropdownTD" style="width: 185px">
                                                                                                    <cc1:StreamlineDropDowns ID="DropDownList_AssignedToStaffId" Width="185px" runat="server"
                                                                                                        TabIndex="2" AddBlankRow="true" BlankRowText="Assigned To All" CssClass="form_dropdown">
                                                                                                    </cc1:StreamlineDropDowns>
                                                                                                </td>
                                                                                                <td style="width: 10px">
                                                                                                    &nbsp;
                                                                                                </td>
                                                                                                <td align="left" class="form_dropdownTD" style="width: 185px">
                                                                                                    <cc2:DropDownGlobalCodes ID="DropDownList_Disposition" Width="185px" runat="server"
                                                                                                        TabIndex="3" AddBlankRow="true" BlankRowText="All Dispositions" CssClass="form_dropdown"
                                                                                                        Category="XINQDISPOSITION">
                                                                                                    </cc2:DropDownGlobalCodes>
                                                                                                </td>
                                                                                                <td style="width: 10px">
                                                                                                    &nbsp;
                                                                                                </td>
                                                                                                <td align="left" class="form_dropdownTD" style="width: 185px">
                                                                                                    <cc2:DropDownGlobalCodes ID="DropDownList_InquiryStatus" Width="185px" runat="server"
                                                                                                        TabIndex="4" AddBlankRow="true" BlankRowText="All Statuses" CssClass="form_dropdown"
                                                                                                        Category="XINQUIRYSTATUS">
                                                                                                    </cc2:DropDownGlobalCodes>
                                                                                                </td>
                                                                                                <td style="width: 10px">
                                                                                                    &nbsp;
                                                                                                </td>
                                                                                                <td align="right">
                                                                                                    <input id="Filter" onclick="return GetListPageWithFilters();" type="button" tabindex="7"
                                                                                                        value="Apply Filter" class="parentchildbutton" />
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td class="height2">
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td valign="top" class="ListPageMiddleTable">
                                                                                        <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                                                            <tr>
                                                                                                <td align="left" width="25%">
                                                                                                    <table cellpadding="0" cellspacing="0" border="0">
                                                                                                        <tr>
                                                                                                            <td>
                                                                                                                <span class="form_label" id="Span$$StartDate" name="Span$$StartDate">From</span>
                                                                                                            </td>
                                                                                                            <td style="width: 10px">
                                                                                                                &nbsp;
                                                                                                            </td>
                                                                                                            <td>
                                                                                                                <table cellpadding="0" cellspacing="0" border="0">
                                                                                                                    <tr class="date_Container">
                                                                                                                        <td>
                                                                                                                            <input type="text" datatype="Date" id="TextBox_InquiriesFrom" name="TextBox_FromDate"
                                                                                                                                value="<%=PeriodStartDate%>" class="date_text" tabindex="5" />
                                                                                                                        </td>
                                                                                                                        <td style="width: 10px">
                                                                                                                            &nbsp;
                                                                                                                        </td>
                                                                                                                        <td>
                                                                                                                            <img id="imgStartDate" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                                                                                onclick="return showCalendar('TextBox_InquiriesFrom', '%m/%d/%Y');" />
                                                                                                                        </td>
                                                                                                                    </tr>
                                                                                                                </table>
                                                                                                            </td>
                                                                                                        </tr>
                                                                                                    </table>
                                                                                                </td>
                                                                                                <td align="left" width="23%">
                                                                                                    <table cellpadding="0" cellspacing="0" border="0">
                                                                                                        <tr>
                                                                                                            <td>
                                                                                                                <span class="form_label" id="Span$$StartDate" name="Span$$StartDate">To</span>
                                                                                                            </td>
                                                                                                            <td style="width: 10px">
                                                                                                                &nbsp;
                                                                                                            </td>
                                                                                                            <td>
                                                                                                                <table cellpadding="0" cellspacing="0" border="0">
                                                                                                                    <tr class="date_Container">
                                                                                                                        <td>
                                                                                                                            <input type="text" datatype="Date" id="TextBox_InquiriesTo" name="TextBox_ToDate"
                                                                                                                                value="<%=PeriodEndDate%>" class="date_text" tabindex="6" />
                                                                                                                        </td>
                                                                                                                        <td style="width: 10px">
                                                                                                                            &nbsp;
                                                                                                                        </td>
                                                                                                                        <td>
                                                                                                                            <img id="img1" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                                                                                onclick="return showCalendar('TextBox_InquiriesTo', '%m/%d/%Y');" />
                                                                                                                        </td>
                                                                                                                    </tr>
                                                                                                                </table>
                                                                                                            </td>
                                                                                                        </tr>
                                                                                                    </table>
                                                                                                </td>
                                                                                                <td width="2%">
                                                                                                </td>
                                                                                                <td width="35%">
                                                                                                    <%--<span id="Span$$CustomFilter" class="form_label">Other</span>--%>
                                                                                                    <cc3:DropDownSubGlobalCodes Width="52%" ID="DropDownList_CustomFilter" runat="server"
                                                                                                        TabIndex="5" bindautosaveevents="False" CssClass="form_dropdown">
                                                                                                    </cc3:DropDownSubGlobalCodes>
                                                                                                </td>
                                                                                                <td width="1%">
                                                                                                </td>
                                                                                                <td width="5%">
                                                                                                </td>
                                                                                                <td width="9%">
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
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="height2">
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
                    <tr>
                        <td>
                            <div id="DivGridContainer">
                                <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                    <!--############## New Grid Starts ############### -->
                                    <tr>
                                        <td>
                                            <asp:ListView ID="ListViewMemberInquiries" runat="server" OnLayoutCreated="LayoutCreated">
                                                <LayoutTemplate>
                                                    <table cellpadding="0" cellspacing="0" border="0" class="ListPageContainer">
                                                        <tr>
                                                            <td>
                                                                <asp:Panel ID="divHeader" runat="server" Style="width: 832px; margin-right: 18px;"
                                                                    CssClass="ListPageHeader">
                                                                    <table cellspacing="0" cellpadding="0" border="0" style="width: 832px;">
                                                                        <tr>
                                                                            <td style="width: 140px">
                                                                                <asp:Panel ID="InquirerName" runat="server" SortId="InquirerName" CssClass="SortLabel">
                                                                                    Inquirer</asp:Panel>
                                                                            </td>
                                                                            <td style="width: 112px">
                                                                                <asp:Panel ID="InquiryDateTime" runat="server" SortId="InquiryDateTime" CssClass="SortLabel">
                                                                                    Date/Time</asp:Panel>
                                                                            </td>
                                                                            <td style="width: 130px">
                                                                                <asp:Panel ID="RecordedByName" runat="server" SortId="RecordedByName" CssClass="SortLabel">
                                                                                    Recorded By</asp:Panel>
                                                                            </td>
                                                                            <td style="width: 130px">
                                                                                <asp:Panel ID="AssignedStaffName" runat="server" SortId="AssignedStaffName" CssClass="SortLabel">
                                                                                    Assigned To</asp:Panel>
                                                                            </td>
                                                                            <td style="width: 130px">
                                                                                <asp:Panel ID="DispositionName" runat="server" SortId="DispositionName" CssClass="SortLabel">
                                                                                    Disposition</asp:Panel>
                                                                            </td>
                                                                            <td style="width: 130px">
                                                                                <asp:Panel ID="InquiryStatus" runat="server" SortId="InquiryStatus" CssClass="SortLabel">
                                                                                    Inquiry Status</asp:Panel>
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
                                                                    <table width="832px" cellspacing="0" cellpadding="0">
                                                                        <asp:PlaceHolder ID="itemPlaceholder" runat="server"></asp:PlaceHolder>
                                                                    </table>
                                                                </asp:Panel>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </LayoutTemplate>
                                                <ItemTemplate>
                                                    <tr class='<%# Container.DisplayIndex % 2 == 0 ? "" : "ListPageAltRow " %>ListPageHLRow'>
                                                        <td style="width: 140px">
                                                            <%# "<div class=\"ellipsis\" Title=\"" + Eval("InquirerName") + "\">" + Eval("InquirerName") + "</div>"%>
                                                        </td>
                                                        <td style="width: 112px">
                                                            <%# "<div style=\"cursor:hand\" class=\"ellipsis\" Title=\"" + string.Format("{0:MM/dd/yyyy}", Eval("InQuiryDateTime")) + " " + string.Format("{0:t}", Eval("InQuiryDateTime")) + "\" onclick=\"OpenPage(5761,10683,'InquiryId=" + Eval("InquiryId") + "',2,'" + Page.ResolveUrl("~/") + "');\"><u>" + string.Format("{0:MM/dd/yyyy}", Eval("InQuiryDateTime")) + " " + string.Format("{0:t}", Eval("InQuiryDateTime")) + "</u></div>"%>
                                                        </td>
                                                        <td style="width: 130px">
                                                            <%# "<div class=\"ellipsis\" Title=\"" + Eval("RecordedByName") + "\">" + Eval("RecordedByName") + "</div>"%>
                                                        </td>
                                                        <td style="width: 130px">
                                                            <%# "<div class=\"ellipsis\" Title=\"" + Eval("AssignedStaffName") + "\">" + Eval("AssignedStaffName") + "</div>"%>
                                                        </td>
                                                        <td style="width: 130px">
                                                            <%# "<div class=\"ellipsis\" Title=\"" + Eval("DispositionName") + "\">" + Eval("DispositionName") + "</div>"%>
                                                        </td>
                                                        <td style="width: 130px">
                                                            <%# "<div class=\"ellipsis\" Title=\"" + Eval("InquiryStatus") + "\">" + Eval("InquiryStatus") + "</div>"%>
                                                        </td>
                                                    </tr>
                                                </ItemTemplate>
                                                <EmptyDataTemplate>
                                                    <asp:Panel ID="divHeader" runat="server" Style="width: 850px; margin-right: 0px;">
                                                        <table cellspacing="0" cellpadding="0" border="0" width="850px" class="ListPageHeader ListPageContainer">
                                                            <tr>
                                                                <td style="width: 140px">
                                                                    <asp:Panel ID="InquirerName" runat="server" SortId="InquirerName" CssClass="SortLabel">
                                                                        Inquirer</asp:Panel>
                                                                </td>
                                                                <td style="width: 112px">
                                                                    <asp:Panel ID="InquiryDateTime" runat="server" SortId="InquiryDateTime" CssClass="SortLabel">
                                                                        Date/Time</asp:Panel>
                                                                </td>
                                                                <td style="width: 130px">
                                                                    <asp:Panel ID="RecordedByName" runat="server" SortId="RecordedByName" CssClass="SortLabel">
                                                                        Recorded By</asp:Panel>
                                                                </td>
                                                                <td style="width: 130px">
                                                                    <asp:Panel ID="AssignedStaffName" runat="server" SortId="AssignedStaffName" CssClass="SortLabel">
                                                                        Assigned To</asp:Panel>
                                                                </td>
                                                                <td style="width: 130px">
                                                                    <asp:Panel ID="DispositionName" runat="server" SortId="DispositionName" CssClass="SortLabel">
                                                                        Disposition</asp:Panel>
                                                                </td>
                                                                <td style="width: 130px">
                                                                    <asp:Panel ID="InquiryStatus" runat="server" SortId="InquiryStatus" CssClass="SortLabel">
                                                                        Inquiry Status</asp:Panel>
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
                                    <!--############## New Grid Ends   ############### -->
                                    <tr>
                                        <td align="left">
                                            <asp:Panel ID="PanelPager" runat="server">
                                            </asp:Panel>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                            <%--<div id="DivGridContainer">
                                <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                    <tr>
                                        <td>
                                            <dxwgv:ASPxGridView ID="GridViewMemberInquiries" runat="server" AutoGenerateColumns="False"
                                                KeyFieldName="InquiryId" Width="100%" ClientInstanceName="GridViewMemberInquiriesIntance"
                                                SettingsBehavior-AllowDragDrop="false">
                                                <Settings ShowHorizontalScrollBar="false" ShowVerticalScrollBar="true" VerticalScrollableHeight="300"
                                                    ShowColumnHeaders="true" GridLines="None" />
                                                <Styles AlternatingRow-BackColor="#f0f6f9" Header-CssClass="HeaderStyle" AlternatingRow-CssClass=""
                                                    Row-CssClass=" ">
                                                </Styles>
                                                <ClientSideEvents ColumnSorting="function(s, e) {                                                           
                                                             GridSortEventClick(s,e);
                                                              e.cancel=true;                                                             
                                                         }" />
                                                <Columns>
                                                    <dxwgv:GridViewDataColumn Width="15%" Caption="Inquirer" FieldName="InquirerName"
                                                        VisibleIndex="0" CellStyle-HorizontalAlign="Left">
                                                        <DataItemTemplate>
                                                            <%# "<div class=\"ellipsis\" Title=\"" + Eval("InquirerName") + "\">" + Convert.ToString(Eval("InquirerName") + "</div>"%>
                                                        </DataItemTemplate>
                                                    </dxwgv:GridViewDataColumn>
                                                    <dxwgv:GridViewDataColumn Width="15%" Caption="Date/Time" FieldName="InquiryDateTime"
                                                        VisibleIndex="0" CellStyle-HorizontalAlign="Left">
                                                        <DataItemTemplate>
                                                            <%# SHS.BaseLayer.BaseCommonFunctions.TrancateElementText(string.Format("{0:g}",Eval("InquiryDateTime")), 40, "OpenPage(5761,10683,'InquiryId=" + Eval("InquiryId") + "',2,'" + Page.ResolveUrl("~/") + "');")%>
                                                        </DataItemTemplate>
                                                    </dxwgv:GridViewDataColumn>
                                                    <dxwgv:GridViewDataColumn Width="15%" Caption="Recorded By" FieldName="RecordedByName"
                                                        VisibleIndex="1" CellStyle-HorizontalAlign="Left">
                                                        <DataItemTemplate>
                                                            <%# SHS.BaseLayer.BaseCommonFunctions.TrancateElementText(Eval("RecordedByName"), 40)%>
                                                        </DataItemTemplate>
                                                    </dxwgv:GridViewDataColumn>
                                                    <dxwgv:GridViewDataColumn Width="15%" Caption="Assigned To" FieldName="AssignedStaffName"
                                                        VisibleIndex="2" CellStyle-HorizontalAlign="Left">
                                                        <DataItemTemplate>
                                                            <%# SHS.BaseLayer.BaseCommonFunctions.TrancateElementText(Eval("AssignedStaffName"), 40)%>
                                                        </DataItemTemplate>
                                                    </dxwgv:GridViewDataColumn>
                                                    <dxwgv:GridViewDataColumn Width="15%" Caption="Disposition" FieldName="DispositionName"
                                                        VisibleIndex="3" CellStyle-HorizontalAlign="Left">
                                                        <DataItemTemplate>
                                                            <%# SHS.BaseLayer.BaseCommonFunctions.TrancateElementText(Eval("DispositionName"), 40)%>
                                                        </DataItemTemplate>
                                                    </dxwgv:GridViewDataColumn>
                                                    <dxwgv:GridViewDataColumn Width="15%" Caption="Inquiry Status" FieldName="InquiryStatus"
                                                        VisibleIndex="3" CellStyle-HorizontalAlign="Left">
                                                        <DataItemTemplate>
                                                            <%# SHS.BaseLayer.BaseCommonFunctions.TrancateElementText(Eval("InquiryStatus"), 40)%>
                                                        </DataItemTemplate>
                                                    </dxwgv:GridViewDataColumn>
                                                </Columns>
                                                <SettingsBehavior ColumnResizeMode="NextColumn" />
                                                <SettingsBehavior AllowSort="true" ColumnResizeMode="Disabled" />
                                                <Styles Cell-Wrap="False">
                                                </Styles>
                                                <SettingsPager Visible="false">
                                                </SettingsPager>
                                            </dxwgv:ASPxGridView>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left">
                                            <asp:Panel ID="PanelPager" runat="server">
                                            </asp:Panel>
                                        </td>
                                    </tr>
                                </table>
                            </div>--%>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</div>
