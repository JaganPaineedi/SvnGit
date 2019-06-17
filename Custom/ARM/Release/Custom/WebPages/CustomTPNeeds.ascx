<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CustomTPNeeds.ascx.cs"
    Inherits="ActivityPages_Harbor_Client_Detail_CustomTPNeeds" %>



<script type="text/javascript" language="javascript" src="<%=RelativePath%>Custom/Scripts/CustomTPNeed.js"></script>

<% if (HttpContext.Current == null)
   { %>
<link href="../../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet"
    type="text/css" />
<%} %>
<table id="tableMain" style="width: 450px;" cellpadding="0" cellspacing="0" border="0"
    align="center">
    <tr style="width: 100%;">
        <td>
            <table cellpadding="0" cellspacing="0" border="0" style="width: 100%">
                <tr>
                    <td>
                        <table cellspacing="0" cellpadding="0" border="0" style="width: 100%">
                            <tr>
                                <td>
                                    <table cellspacing="0" cellpadding="0" border="0">
                                        <tr>
                                            <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                New Need
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
                            <tr class="content_tab_bg">
                                <td>
                                    <table border="0" cellpadding="0" cellspacing="0" width="100%" height="100px">
                                        <tr>
                                            <td style="border-right: #a8a8a8 1px solid; border-left: #a8a8a8 1px solid; height: 5px;">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="padding_Label" align="center" width="90%" style="border-right: #a8a8a8 1px solid;
                                                border-left: #a8a8a8 1px solid">
                                                <textarea id="TextArea_CustomTPNeed_NeedText" class="form_textarea" runat="server"
                                                    spellcheck="True" name="TextArea_CustomTPNeed_NeedText" style="width: 97%; height: 100%;"
                                                    cols="110" rows="6"></textarea>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="height: 5px; border-right: #a8a8a8 1px solid; border-left: #a8a8a8 1px solid;">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="border-right: #a8a8a8 1px solid; border-left: #a8a8a8 1px solid; text-align: right;
                                                padding-right: 5px;">
                                                <input class="less_detail_btn" id="button_CustomTPNeed_Insert" type="button" value="Add To Need"
                                                    style="width: 20%;" />
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
                <tr style="width: 100%;">
                    <td style="height: 5px;">
                    </td>
                </tr>
                <tr>
                    <td>
                        <table cellspacing="0" cellpadding="0" border="0" style="width: 100%">
                            <tr>
                                <td style="height: 5px;">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <table cellspacing="0" cellpadding="0" border="0">
                                        <tr>
                                            <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                Current Needs
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
                                            <%--Added by Amit Kumar Srivastava,#1541, Initial Treatment Plan: Need pop up showing the scroll bar, PM Web Bugs,22 May 2012 </tr></table>--%>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr class="content_tab_bg">
                    <td style="border-right: #a8a8a8 1px solid; border-left: #a8a8a8 1px solid">
                        <table border="0" cellpadding="0" cellspacing="0" width="97%" height="100px" style="align: center;">
                            <tr>
                                <td id="divAssoiateNeed" class="padding_Label" align="center" width="97%" style="border-right: #a8a8a8 1px solid;
                                    border-left: #a8a8a8 1px solid">
                                    <dxwgv:ASPxGridView ID="GridViewCustomTPNeed" runat="server" AutoGenerateColumns="False"
                                        Width="100%" ClientInstanceName="grid" SettingsBehavior-AllowDragDrop="false"
                                        Paddings-PaddingLeft="5px" Paddings-PaddingRight="5px" OnHtmlRowPrepared="GridViewCustomTPNeed_HtmlRowPrepared"
                                        OnHtmlDataCellPrepared="GridViewCustomTPNeed_HtmlDataCellPrepared">
                                        <Settings ShowHorizontalScrollBar="false" ShowVerticalScrollBar="true" VerticalScrollableHeight="200"
                                            GridLines="None" />
                                        <Styles AlternatingRow-BackColor="#f0f6f9" Header-CssClass="HeaderStyle" AlternatingRow-CssClass=""
                                            Row-CssClass=" ">
                                        </Styles>
                                        <Columns>
                                            <dxwgv:GridViewDataColumn Caption="" Width="10%" VisibleIndex="0" HeaderStyle-Font-Underline="false"
                                                CellStyle-HorizontalAlign="Left">
                                                <DataItemTemplate>
                                                </DataItemTemplate>
                                            </dxwgv:GridViewDataColumn>
                                            <dxwgv:GridViewDataColumn Caption="Need Description" Width="40%" VisibleIndex="1"
                                                HeaderStyle-Font-Underline="false" FieldName="NeedText" CellStyle-HorizontalAlign="Left"
                                                Settings-AllowSort="false">
                                                <HeaderTemplate>
                                                    <span id="NeedDescription" style="color: black; font-size: 11px; cursor: hand; text-decoration: underline;"
                                                        onclick="sortRows(event,'td:eq(3) label',false);">Need Description</span>
                                                </HeaderTemplate>
                                                <DataItemTemplate>
                                                </DataItemTemplate>
                                            </dxwgv:GridViewDataColumn>
                                            <dxwgv:GridViewDataColumn Caption="Date Identified Need Added To Plan" Width="40%"
                                                VisibleIndex="2" HeaderStyle-Font-Underline="false" FieldName="DateNeedAddedToPlan"
                                                CellStyle-HorizontalAlign="Center">
                                                <HeaderTemplate>
                                                    <span id="DateNeedAddedToPlan" style="color: black; font-size: 11px; cursor: hand;
                                                        text-decoration: underline;" onclick="sortRows(event,'td:eq(4)',true);">Date Identified
                                                        Need Added To Plan</span>
                                                </HeaderTemplate>
                                                <DataItemTemplate>
                                                    <span id="SpanDate"></span>
                                                </DataItemTemplate>
                                            </dxwgv:GridViewDataColumn>
                                        </Columns>
                                        <SettingsBehavior ColumnResizeMode="NextColumn" AllowSort="false" />
                                        <SettingsBehavior AllowSort="false" ColumnResizeMode="Disabled" />
                                        <SettingsPager Visible="false" Mode="ShowAllRecords">
                                        </SettingsPager>
                                        <Styles Cell-Wrap="False">
                                        </Styles>
                                    </dxwgv:ASPxGridView>
                                    <%--<textarea id="TextArea1" name="TextArea_CustomTreatmentPlans_ReasonForUpdate1" rows="5"
                                        cols="48" class="form_textarea"  ></textarea>--%>
                                </td>
                            </tr>
                            <tr>
                                <td style="height: 5px;">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input id="button_Ok" type="button" value="OK" style="width: 20%" class="less_detail_btn" />
                                    <input id="button_Cancel" type="button" value="Cancel" class="less_detail_btn" style="width: 20%"
                                        onclick="CheckBeforeClose(); return false;" />
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
                        <input type="hidden" runat="server" id="HiddenField_TPGoalId" />
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
<%--</td> </tr> </table>--%><%--<div style="padding-left: 10px">
    <dxtc:ASPxPageControl ID="CustomTPNeeds" runat="server" Width="95%" ActiveTabIndex="0"
        EnableHierarchyRecreation="True" CssFilePath="~/App_Themes/Styles/DevExpressTabStyles.css"
        ContentStyle-BorderLeft-BorderWidth="1px" ContentStyle-BorderRight-BorderWidth="1px"
        Paddings-Padding="0px" Height="50%">
        <TabPages>
            <dxtc:TabPage Text="New Need">
                <ContentCollection>
                    <dxw:ContentControl ID="ContentControGeneral" runat="server">
                        <table style="width: 100%">
                            <tr>
                                <td>
                                </td>
                            </tr>
                            <tr>
                                <td style="height: 5px;">
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align: right;">
                                </td>
                            </tr>
                        </table>
                    </dxw:ContentControl>
                </ContentCollection>
            </dxtc:TabPage>
        </TabPages>
    </dxtc:ASPxPageControl>
    <div style="width: 95%; padding-bottom: 10px; padding-top: 10px" align="right">
    </div>
    <div id="divAssoiateNeed" style="width: 450px">
    </div>
    <div style="width: 95%; padding-bottom: 10px; padding-top: 10px" align="right">
        
    </div>
    
</div>--%>