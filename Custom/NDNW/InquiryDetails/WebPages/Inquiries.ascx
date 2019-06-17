<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Inquiries.ascx.cs" Inherits="Custom_InquiryDetails_Inquiries" %>

<script src="<%= RelativePath%>JScripts/ApplicationScripts/CustomDate.js" type="text/javascript"></script>

<%@ Register Assembly="Streamline.DotNetDropDowns" Namespace="Streamline.DotNetDropDowns"
    TagPrefix="cc2" %>
<%@ Register Assembly="Streamline.DotNetDropDownGlobalCodes" Namespace="Streamline.DotNetDropDownGlobalCodes"
    TagPrefix="cc4" %>
<%@ Register Assembly="Streamline.DotNetDropDownSubGlobalCodes" Namespace="Streamline.DotNetDropDownSubGlobalCodes"
    TagPrefix="cc5" %>

<script src="<%= RelativePath%>Custom/InquiryDetails/Scripts/Inquries.js" type="text/javascript"></script>

<div class="bottom_contanier_white_bg">
    <table width="850px" border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td>
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr id="TableFiltersContainer" runat="server">
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
                                                    <table width="100%" border="0" cellpadding="0" cellspacing="0" id="TablePageFilters"
                                                        name="TablePageFilters">
                                                        <tr>
                                                            <td class="ListPageMiddleTable" width="99%">
                                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                    <tr>
                                                                        <td style="width: 15%" align="left" class="form_dropdownTD">
                                                                            <cc2:StreamlineDropDowns ID="DropDownList_RecordedByStaffId" Width="150px" runat="server"
                                                                                TabIndex="1" CssClass="form_dropdown">
                                                                            </cc2:StreamlineDropDowns>
                                                                        </td>
                                                                        <td style="width: 3px">
                                                                            &nbsp;
                                                                        </td>
                                                                        <td style="width: 15%" align="left" class="form_dropdownTD">
                                                                            <cc2:StreamlineDropDowns ID="DropDownList_AssignedToStaffId" Width="150px" runat="server"
                                                                                TabIndex="2" CssClass="form_dropdown">
                                                                            </cc2:StreamlineDropDowns>
                                                                        </td>
                                                                        <td style="width: 3px">
                                                                            &nbsp;
                                                                        </td>
                                                                        <td align="left" class="form_dropdownTD" style="width: 15%">
                                                                            <cc4:DropDownGlobalCodes ID="DropDownList_Dispositions" CssClass="form_dropdown"
                                                                                Width="150px" runat="server" Category="XINQDISPOSITION" AddBlankRow="true" BlankRowText="All Dispositions"
                                                                                BlankRowValue="0" TabIndex="3">
                                                                            </cc4:DropDownGlobalCodes>
                                                                        </td>
                                                                        <td style="width: 3px">
                                                                            &nbsp;
                                                                        </td>
                                                                        <td align="left" class="form_dropdownTD" style="width: 15%">
                                                                            <cc4:DropDownGlobalCodes ID="DropDownList_InquiryStatus" CssClass="form_dropdown"
                                                                                Width="150px" runat="server" Category="XINQUIRYSTATUS" AddBlankRow="true" BlankRowText="All Statuses"
                                                                                BlankRowValue="0" TabIndex="4">
                                                                            </cc4:DropDownGlobalCodes>
                                                                        </td>
                                                                        <td style="width: 3px">
                                                                            &nbsp;
                                                                        </td>
                                                                        <td align="left" class="form_dropdownTD" style="width: 15%">
                                                                            <cc5:DropDownSubGlobalCodes ID="DropDownList_CustomFilter" Width="87px" runat="server"
                                                                                TabIndex="9" CssClass="form_dropdown">
                                                                            </cc5:DropDownSubGlobalCodes>
                                                                        </td>
                                                                        <td style="width: 3px">
                                                                            &nbsp;
                                                                        </td>
                                                                        <td align="right">
                                                                            <span id="Filter" onclick="GetListPageWithFilters();" type="button" text="Apply Filter">
                                                                            </span>
                                                                        </td>
                                                                        <td style="width: 3px">
                                                                            &nbsp;
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="9" class="height2">
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="9">
                                                                            <table cellpadding="0" cellspacing="0" width="100%" border="0">
                                                                                <tr>
                                                                                    <td align="left" style="width: 155px">
                                                                                        <table cellpadding="0" cellspacing="0" border="0">
                                                                                            <tr class="date_Container">
                                                                                                <td>
                                                                                                    <span name="Span$$InquiriesFrom" id="Span$$InquiriesFrom" filter="false">From</span>
                                                                                                </td>
                                                                                                <td>
                                                                                                    &nbsp;
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input type="text" name="TextBox_InquiriesFrom" TabIndex="5" id="TextBox_InquiriesFrom"
                                                                                                        value="<%=PeriodStartDate%>" datatype="Date" />
                                                                                                </td>
                                                                                                <td>
                                                                                                    &nbsp;
                                                                                                </td>
                                                                                                <td>
                                                                                                    <img id="img1" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                                                        onclick="return showCalendar('TextBox_InquiriesFrom', '%m/%d/%Y');" filter="false" />
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </td>
                                                                                    <td style="width: 3px">
                                                                                        &nbsp;
                                                                                    </td>
                                                                                    <td align="left" style="width: 107px">
                                                                                        <table cellpadding="0" cellspacing="0" border="0">
                                                                                            <tr class="date_Container">
                                                                                                <td align="left">
                                                                                                    <span name="Span$$InquiriesTo" id="Span$$InquiriesTo" filter="false">To</span>
                                                                                                </td>
                                                                                                <td>
                                                                                                    &nbsp;
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input type="text" name="TextBox_InquiriesTo" id="TextBox_InquiriesTo" TabIndex="6"
                                                                                                        value="<%=PeriodEndDate%>" datatype="Date" />
                                                                                                </td>
                                                                                                <td>
                                                                                                    &nbsp;
                                                                                                </td>
                                                                                                <td>
                                                                                                    <img id="img2" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                                                        onclick="return showCalendar('TextBox_InquiriesTo', '%m/%d/%Y');" style="cursor: hand;"
                                                                                                        filter="false" />
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </td>
                                                                                    <td style="width: 10px">
                                                                                        &nbsp;
                                                                                    </td>
                                                                                    <td style="width: 70px; text-align: left">
                                                                                        <span class="form_label">Last Name</span>
                                                                                    </td>
                                                                                    <td style="width: 3px">
                                                                                        &nbsp;
                                                                                    </td>
                                                                                    <td align="left" style="width: 90px">
                                                                                        <input id="TextBox_MemberLatName" name="TextBox_MemberLatName" style="width: 90px"
                                                                                            class="form_textbox" type="text" TabIndex="7" />
                                                                                    </td>
                                                                                    <td style="width: 10px">
                                                                                        &nbsp;
                                                                                    </td>
                                                                                    <td style="width: 70px; text-align: left">
                                                                                        <span class="form_label">First Name</span>
                                                                                    </td>
                                                                                    <td style="width: 3px">
                                                                                        &nbsp;
                                                                                    </td>
                                                                                    <td style="width: 90px">
                                                                                        <input id="TextBox_MemberFirstName" name="TextBox_MemberFirstName" style="width: 90px"
                                                                                            class="form_textbox" type="text" TabIndex="8" />
                                                                                    </td>
                                                                                    <td>
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
                   <%-- <tr>
                        <td class="height2"  colspan="3">
                        </td>
                    </tr>--%>
                   
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
        <%--PPPPP--%>
        <tr>
            <td>
                <div id="DivGridContainer"  style="overflow: auto">
                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                        <!--############## New Grid Starts ############### -->
                        <tr>
                        <td class="height2">
                      
                        </td>
                    </tr>
                        <tr>
                            <td  align="left">
                                <asp:ListView ID="ListViewInquriesListRadGrid" runat="server" OnLayoutCreated="LayoutCreated">
                                    <LayoutTemplate>
                                        <table cellpadding="0" cellspacing="0" border="0" class="ListPageContainer">
                                            <tr>
                                                <td>
                                                    <asp:Panel ID="divHeader" runat="server" Style="width: 832px; margin-right: 18px;"
                                                        CssClass="ListPageHeader">
                                                        <table cellspacing="0" cellpadding="0" border="0" width="832px"">
                                                            <tr>
                                                                <td width="110px">
                                                                    <asp:Panel ID="MemberName" runat="server" SortId="MemberName" CssClass="SortLabel">
                                                                        Client (Potential)</asp:Panel>
                                                                </td>
                                                                <td width="55px">
                                                                    <asp:Panel ID="MemberId" runat="server" SortId="MemberId" CssClass="SortLabel">
                                                                        Client Id</asp:Panel>
                                                                </td>
                                                                <td width="90px">
                                                                    <asp:Panel ID="InquirerName" runat="server" SortId="InquirerName" CssClass="SortLabel">
                                                                        Inquirer</asp:Panel>
                                                                </td>
                                                                <td width="110px">
                                                                    <asp:Panel ID="InQuiryDateTime" runat="server" SortId="InQuiryDateTime" CssClass="SortLabel">
                                                                        Date/Time</asp:Panel>
                                                                </td>
                                                                <td width="90px">
                                                                    <asp:Panel ID="RecordedByName" runat="server" SortId="RecordedByName" CssClass="SortLabel">
                                                                        Recorded By</asp:Panel>
                                                                </td>
                                                                <td width="90px">
                                                                    <asp:Panel ID="AssignedToName" runat="server" SortId="AssignedToName" CssClass="SortLabel">
                                                                        Assigned To</asp:Panel>
                                                                </td>
                                                                <td width="80px">
                                                                    <asp:Panel ID="Disposition" runat="server" SortId="Disposition" CssClass="SortLabel">
                                                                        Disposition</asp:Panel>
                                                                </td>
                                                                <td width="80px">
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
                                            <td width="110px">
                                                <%# "<div class=\"ellipsis\" Title=\"" + Eval("MemberName") + "\">" + Eval("MemberName") + "</div>"%>
                                            </td>
                                            <td width="55px">
                                                <%# "<div style=\"cursor:hand\" class=\"ellipsis\" Title=\"" + Eval("MemberId") + "\"  onclick=\"OpenPage(5764,'19','ClientId=" + Eval("MemberId") + "',2,'" + Page.ResolveUrl("~/") + "');\"><u>" + Eval("MemberId") + "</u></div>"%>
                                            </td>
                                            <td width="90px">
                                                <%# "<div class=\"ellipsis\" Title=\"" + Eval("InquirerName") + "\">" + Eval("InquirerName") + "</div>"%>
                                            </td>
                                            <td width="110px">
                                                <%# "<div style=\"cursor:hand\" class=\"ellipsis\" Title=\"" + string.Format("{0:MM/dd/yyyy}", Eval("InQuiryDateTime")) +" "+ string.Format("{0:t}", Eval("InQuiryDateTime")) + "\" onclick=\"OpenPage(5761,10683,'InquiryId=" + Eval("InquiryId") + "',1,'" + Page.ResolveUrl("~/") + "');\"><u>" + string.Format("{0:MM/dd/yyyy}", Eval("InQuiryDateTime")) +" "+ string.Format("{0:t}", Eval("InQuiryDateTime")) + "</u></div>"%>
                                            </td>
                                            <td width="90px">
                                                <%# "<div class=\"ellipsis\" Title=\"" + Eval("RecordedByName") + "\">" + Eval("RecordedByName") + "</div>"%>
                                            </td>
                                            <td width="90px">
                                                <%# "<div class=\"ellipsis\" Title=\"" + Eval("AssignedToName") + "\">" + Eval("AssignedToName") + "</div>"%>
                                            </td>
                                            <td width="80px">
                                                <%# "<div class=\"ellipsis\" Title=\"" + Eval("Disposition") + "\">" + Eval("Disposition") + "</div>"%>
                                            </td>
                                            <td width="80px">
                                                <%# "<div class=\"ellipsis\" Title=\"" + Eval("InquiryStatus") + "\">" + Eval("InquiryStatus") + "</div>"%>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                    <EmptyDataTemplate>
                                        <asp:Panel ID="divHeader" runat="server" Style="width: 850px; margin-right: 0px;">
                                            <table cellspacing="0" cellpadding="0" border="0" width="850px" class="ListPageHeader ListPageContainer">
                                                <tr>
                                                    <td width="110px">
                                                        <asp:Panel ID="MemberName" runat="server" SortId="MemberName" CssClass="SortLabel">
                                                            Client (Potential)</asp:Panel>
                                                    </td>
                                                    <td width="55px">
                                                        <asp:Panel ID="MemberId" runat="server" SortId="MemberId" CssClass="SortLabel">
                                                            Client Id</asp:Panel>
                                                    </td>
                                                    <td width="90px">
                                                        <asp:Panel ID="InquirerName" runat="server" SortId="InquirerName" CssClass="SortLabel">
                                                            Inquirer</asp:Panel>
                                                    </td>
                                                    <td width="110px">
                                                        <asp:Panel ID="InQuiryDateTime" runat="server" SortId="InQuiryDateTime" CssClass="SortLabel">
                                                            Date/Time</asp:Panel>
                                                    </td>
                                                    <td width="90px">
                                                        <asp:Panel ID="RecordedByName" runat="server" SortId="RecordedByName" CssClass="SortLabel">
                                                            Recorded By</asp:Panel>
                                                    </td>
                                                    <td width="90px">
                                                        <asp:Panel ID="AssignedToName" runat="server" SortId="AssignedToName" CssClass="SortLabel">
                                                            Assigned To</asp:Panel>
                                                    </td>
                                                    <td width="80px">
                                                        <asp:Panel ID="Disposition" runat="server" SortId="Disposition" CssClass="SortLabel">
                                                            Disposition</asp:Panel>
                                                    </td>
                                                    <td width="80px">
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
                                <dxwgv:ASPxGridView ID="GridViewInquriesListRadGrid" runat="server" AutoGenerateColumns="False"
                                    KeyFieldName="InquiryId" Width="100%" ClientInstanceName="grid" Settings-ShowHorizontalScrollBar="false"
                                    SettingsBehavior-AllowDragDrop="false">
                                    <Settings ShowHorizontalScrollBar="false" ShowVerticalScrollBar="true" VerticalScrollableHeight="300"
                                        GridLines="None" />
                                    <Styles AlternatingRow-BackColor="#f0f6f9" AlternatingRow-CssClass="" Row-CssClass=" "
                                        Header-CssClass="HeaderStyle">
                                    </Styles>
                                    <ClientSideEvents ColumnSorting="function(s, e) { 
                                                          
                                                             GridSortEventClick(s,e);
                                                              e.cancel=true;
                                                             
                                                         }" />
                                    <Columns>
                                        <dxwgv:GridViewDataColumn FieldName="MemberName" Width="120px" ReadOnly="True" VisibleIndex="0"
                                            Caption="Client (Potential)" CellStyle-HorizontalAlign="Left" CellStyle-Wrap="False">
                                           <DataItemTemplate>
                                                <%# SHS.BaseLayer.BaseCommonFunctions.TrancateElementText(Eval("MemberName"), 20)%>
                                            </DataItemTemplate>
                                        </dxwgv:GridViewDataColumn>
                                        <dxwgv:GridViewDataColumn FieldName="MemberId" Width="60px" ReadOnly="True"
                                            VisibleIndex="0" Caption="Client Id" CellStyle-HorizontalAlign="Left" CellStyle-Wrap="False">
                                            <DataItemTemplate>                                               
                                                <%# SHS.BaseLayer.BaseCommonFunctions.TrancateElementText(Eval("MemberId"), 10, "OpenPage(5764,'19','ClientId=" + Eval("MemberId") + "',2,'" + Page.ResolveUrl("~/") + "');")%>
                                            </DataItemTemplate>
                                        </dxwgv:GridViewDataColumn>
                                        <dxwgv:GridViewDataColumn Width="120px" FieldName="InquirerName" ReadOnly="True" VisibleIndex="0"
                                            Caption="Inquirer" CellStyle-HorizontalAlign="Left" CellStyle-Wrap="False">
                                           <DataItemTemplate>
                                                <%# SHS.BaseLayer.BaseCommonFunctions.TrancateElementText(Eval("InquirerName"), 20)%>
                                            </DataItemTemplate>
                                        </dxwgv:GridViewDataColumn>
                                        <dxwgv:GridViewDataColumn Width="110px" Caption="Date/Time" FieldName="InQuiryDateTime" VisibleIndex="1"
                                            CellStyle-HorizontalAlign="Left" CellStyle-Wrap="False">
                                            <DataItemTemplate>
                                                <%# SHS.BaseLayer.BaseCommonFunctions.TrancateElementText(string.Format("{0:g}", Eval("InQuiryDateTime")), 25, "OpenPage(5761,10683,'InquiryId=" + Eval("InquiryId") + "',1,'" + Page.ResolveUrl("~/") + "');")%>
                                            </DataItemTemplate>
                                        </dxwgv:GridViewDataColumn>
                                        <dxwgv:GridViewDataColumn Width="105px" Caption="Recorded By" FieldName="RecordedByName"
                                            VisibleIndex="1" CellStyle-HorizontalAlign="Left" CellStyle-Wrap="False">
                                            <DataItemTemplate>
                                                <%# SHS.BaseLayer.BaseCommonFunctions.TrancateElementText(Eval("RecordedByName"), 20)%>
                                            </DataItemTemplate>
                                        </dxwgv:GridViewDataColumn>
                                        <dxwgv:GridViewDataColumn Caption="Assigned To" Width="105px" FieldName="AssignedToName"
                                            VisibleIndex="1" CellStyle-HorizontalAlign="Left" CellStyle-Wrap="False">
                                            <DataItemTemplate>
                                                <%# SHS.BaseLayer.BaseCommonFunctions.TrancateElementText(Eval("AssignedToName"), 20)%>
                                            </DataItemTemplate>
                                        </dxwgv:GridViewDataColumn>
                                        <dxwgv:GridViewDataColumn Width="100px"  Caption="Disposition" FieldName="Disposition" VisibleIndex="1"
                                            CellStyle-HorizontalAlign="Left" CellStyle-Wrap="False"  >
                                           <DataItemTemplate>
                                                <%# SHS.BaseLayer.BaseCommonFunctions.TrancateElementText(Eval("Disposition"), 20)%>
                                            </DataItemTemplate> 
                                        </dxwgv:GridViewDataColumn>
                                         <dxwgv:GridViewDataColumn Width="100px"  Caption="Inquiry Status" FieldName="InquiryStatus" VisibleIndex="1"
                                            CellStyle-HorizontalAlign="Left" CellStyle-Wrap="False"  >
                                           <DataItemTemplate>
                                                <%# SHS.BaseLayer.BaseCommonFunctions.TrancateElementText(Eval("InquiryStatus"), 20)%>
                                            </DataItemTemplate> 
                                        </dxwgv:GridViewDataColumn>
                                        
                                    </Columns>
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
        <%--PPPP--%>
    </table>
</div>
