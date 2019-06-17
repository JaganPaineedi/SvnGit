<%@ Control Language="C#" AutoEventWireup="true" CodeFile="HRMCAFAS.ascx.cs" Inherits="SHS.SmartCare.ActivityPages_Client_Detail_Assessment_HRMCAFAS" %>
<% if (HttpContext.Current == null)
   { %>
<link href="../../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet"
    type="text/css" />
<%} %>
<script src="<%=RelativePath%>Custom/Assessment/Scripts/Cafas2.js" type="text/javascript" language="javascript" >
</script>
<div style="margin: 0px,0px,0px,0px; overflow-x: hidden">
    <table border="0" cellspacing="0" cellpadding="0" class="DocumentScreen">
        <tr>
            <td>
                <table border="0" cellspacing="0" cellpadding="0" width="99%">
                    <tr>
                        <td class="padding_label1">
                            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                <tr>
                                    <td colspan="4" class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" class="height1">
                                    </td>
                                </tr>
                                <tr>
                                    <td valign="middle" width="20%">
                                        <%--<input type="button" style="width:150px" id="GoToOnlineCafas" name="GoToOnlineCafas" value="Go to Online Cafas"
                                                                                class="less_detail_btn" onclick="GotoOnlineCafas();" />--%>
                                        <span id="GoToOnlineCafas" onclick="GotoOnlineCafas();" type="button" text="Go to Online Cafas">
                                        </span>
                                    </td>
                                    <td valign="middle" width="20%">
                                        <%--<input type="button" id="ImportCAFASScores" name="ImportCAFASScores" class="glow_mid" value="Import CAFAS Scores"
                                                                                />
                                       <span id="ImportCAFASScores"   type="button" text="Import CAFAS Scores">PPP
                                        </span>--%>
                                        <%-- <table cellpadding="0" cellspacing="0" border="0">
                                            <tr>
                                                <td>
                                                    <div class="glow_lt">
                                                        &nbsp;</div>
                                                </td>
                                                <td>
                                                    <div class="glow_mid">
                                                        <input type="button" style="width: 120px;" id="ImportCAFASScores" value="Import CAFAS Scores"
                                                            tabindex="15" />
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="glow_rt">
                                                        &nbsp;</div>
                                                </td>
                                            </tr>
                                        </table>--%>
                                        <input type="button" class="more_detail_btn_120" id="ImportCAFASScores" value="Import CAFAS Scores" onclick="JavaScript:ImportCafasScores()"
                                             />
                                    </td>
                                    <td width="30%">
                                    </td>
                                    <td width="30%">
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="padding_label1">
                            <table border="0" cellspacing="0" cellpadding="0" width="98%">
                                <tr>
                                    <td colspan="4" class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td width="25%">
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td>
                                                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                        <tr>
                                                            <td class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                                                    <tr>
                                                                        <td class="content_tab_left" align="left" width="70%">
                                                                            <span>CAFAS Date</span>
                                                                        </td>
                                                                        <td width="17">
                                                                            <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/content_tab_sep.gif"
                                                                                width="17" height="26" alt="" />
                                                                        </td>
                                                                        <td class="content_tab_top" width="100%">
                                                                        </td>
                                                                        <td width="7">
                                                                            <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/content_tab_right.gif"
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
                                                                        <td colspan="2" class="height2">
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="2" class="height2">
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td width="30%" align="right" class="padding_label1">
                                                                            <input type="text" id="TextBox_CustomCAFAS2_CAFASDate" name="TextBox_CustomCAFAS2_CAFASDate"
                                                                                datatype="Date"  class="date_text" />
                                                                        </td>
                                                                        <td width="20%" align="left">
                                                                            <img style="cursor: default; padding-left: 5px;" id="imgCurrentAssessmentDate" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                                onclick="return showCalendar('TextBox_CustomCAFAS2_CAFASDate', '%m/%d/%Y');"
                                                                                alt="" class="cursor_default" />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="2" class="height1">
                                                                            &nbsp;
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
                                                                            <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                                                                                height="7" alt="" />
                                                                        </td>
                                                                        <td class="right_bottom_cont_bottom_bg" width="100%">
                                                                        </td>
                                                                        <td width="2" class="right_bottom_cont_bottom_bg" align="right">
                                                                            <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif"
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
                                    <td width="5%">
                                    </td>
                                    <td width="25%">
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td>
                                                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                        <tr>
                                                            <td class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                                                    <tr>
                                                                        <td class="content_tab_left" align="left" width="70%">
                                                                            <span>Interval</span>
                                                                        </td>
                                                                        <td width="17">
                                                                            <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/content_tab_sep.gif"
                                                                                width="17" height="26" alt="" />
                                                                        </td>
                                                                        <td class="content_tab_top" width="100%">
                                                                        </td>
                                                                        <td width="7">
                                                                            <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/content_tab_right.gif"
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
                                                                        <td colspan="7" class="height2">
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="7" class="height2">
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="7" align="center">
                                                                            <asp:DropDownList ID="DropDownList_CustomCAFAS2_CAFASInterval" runat="server" EnableViewState="false"
                                                                                CssClass="form_dropdown" Width="150px">
                                                                            </asp:DropDownList>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="7" class="height1">
                                                                            &nbsp;
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
                                                                            <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                                                                                height="7" alt="" />
                                                                        </td>
                                                                        <td class="right_bottom_cont_bottom_bg" width="100%">
                                                                        </td>
                                                                        <td width="2" class="right_bottom_cont_bottom_bg" align="right">
                                                                            <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif"
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
                                    <td width="5%">
                                    </td>
                                    <td width="25%">
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td>
                                                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                        <tr>
                                                            <td class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                                                    <tr>
                                                                        <td class="content_tab_left" align="left" width="70%">
                                                                            <span>Rater</span>
                                                                        </td>
                                                                        <td width="17">
                                                                            <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/content_tab_sep.gif"
                                                                                width="17" height="26" alt="" />
                                                                        </td>
                                                                        <td class="content_tab_top" width="100%">
                                                                        </td>
                                                                        <td width="7">
                                                                            <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/content_tab_right.gif"
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
                                                                        <td colspan="7" class="height2">
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="7" class="height2">
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="4" align="center">
                                                                            <asp:DropDownList ID="DropDownList_CustomCAFAS2_RaterClinician" runat="server" EnableViewState="false"
                                                                                CssClass="form_dropdown" Width="150px">
                                                                            </asp:DropDownList>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="7" class="height1">
                                                                            &nbsp;
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
                                                                            <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                                                                                height="7" alt="" />
                                                                        </td>
                                                                        <td class="right_bottom_cont_bottom_bg" width="100%">
                                                                        </td>
                                                                        <td width="2" class="right_bottom_cont_bottom_bg" align="right">
                                                                            <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif"
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
                                    <td width="5%">
                                    </td>
                                    <td width="8%">
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="padding_label1">
                            <table border="0" cellpadding="0" cellspacing="0" width="98%">
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap="nowrap">
                                                    <span>School/Work Role Performance </span>
                                                </td>
                                                <td width="17">
                                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/content_tab_sep.gif"
                                                        width="17" height="26" alt="" />
                                                </td>
                                                <td class="content_tab_top" width="100%">
                                                </td>
                                                <td width="7">
                                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/content_tab_right.gif"
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
                                                <td colspan="7" class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="padding_label1" width="9%">
                                                    <span id="ns_2" class="ui-stepper">
                                                        <input type="text" id="TextBox_CustomCAFAS2_SchoolPerformance" name="TextBox_CustomCAFAS2_SchoolPerformance"
                                                            value="0" datatype="Number" size="2" autocomplete="off" class="ui-stepper-textbox"
                                                            onchange="CalCulateCafasScore(this,'2','TextArea_CustomCAFAS2_SchoolPerformanceComment');" />
                                                        <img name="ns_button_1_1" class="ui-stepper-plus" style="vertical-align: top; cursor: default"
                                                            src="<%= WebsiteSettings.BaseUrl  %>App_Themes/Includes/Images/toparrow.png"
                                                            alt="" />
                                                        <img name="ns_button_2_1" class="ui-stepper-minus" style="vertical-align: bottom;
                                                            cursor: default" src="<%= WebsiteSettings.BaseUrl  %>App_Themes/Includes/Images/bottomarrow.png" />
                                                    </span>
                                                </td>
                                                <td class="padding_label1">
                                                    <textarea class="form_textareaWithoutWidth" id="TextArea_CustomCAFAS2_SchoolPerformanceComment"
                                                        name="TextArea_CustomCAFAS2_SchoolPerformanceComment" rows="5" spellcheck="True"
                                                        cols="140"  onchange="CafasNeedList('TextBox_CustomCAFAS2_SchoolPerformance','2','TextArea_CustomCAFAS2_SchoolPerformanceComment');"></textarea>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="7" class="height1">
                                                    &nbsp;
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
                                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                                                        height="7" alt="" />
                                                </td>
                                                <td class="right_bottom_cont_bottom_bg" width="100%">
                                                </td>
                                                <td width="2" class="right_bottom_cont_bottom_bg" align="right">
                                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif"
                                                        height="7" alt="" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="padding_label1">
                            <table border="0" cellpadding="0" cellspacing="0" width="98%">
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap="nowrap">
                                                    <span>Home Role Performance </span>
                                                </td>
                                                <td width="17">
                                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/content_tab_sep.gif"
                                                        width="17" height="26" alt="" />
                                                </td>
                                                <td class="content_tab_top" width="100%">
                                                </td>
                                                <td width="7">
                                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/content_tab_right.gif"
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
                                                <td colspan="7" class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="padding_label1" width="9%">
                                                    <span id="Span1" class="ui-stepper">
                                                        <input type="text" id="TextBox_CustomCAFAS2_HomePerformance" name="TextBox_CustomCAFAS2_HomePerformance"
                                                            value="0" datatype="Number" size="2" autocomplete="off" class="ui-stepper-textbox"
                                                            onchange="CalCulateCafasScore(this,'3','TextArea_CustomCAFAS2_HomePerfomanceComment');"  />
                                                        <img name="ns_button_1_1" class="ui-stepper-plus" style="vertical-align: top; cursor: default"
                                                            src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/toparrow.png" alt="" />
                                                        <img name="ns_button_2_1" class="ui-stepper-minus" style="vertical-align: bottom;
                                                            cursor: default" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/bottomarrow.png"
                                                            alt="" />
                                                    </span>
                                                </td>
                                                <td class="padding_label1">
                                                    <textarea class="form_textareaWithoutWidth" id="TextArea_CustomCAFAS2_HomePerfomanceComment"
                                                        name="TextArea_CustomCAFAS2_HomePerfomanceComment" rows="5" spellcheck="True"
                                                        cols="140"  onchange="CafasNeedList('TextBox_CustomCAFAS2_HomePerformance','3','TextArea_CustomCAFAS2_HomePerfomanceComment');"></textarea>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="7" class="height1">
                                                    &nbsp;
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
                                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                                                        height="7" alt="" />
                                                </td>
                                                <td class="right_bottom_cont_bottom_bg" width="100%">
                                                </td>
                                                <td width="2" class="right_bottom_cont_bottom_bg" align="right">
                                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif"
                                                        height="7" alt="" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="padding_label1">
                            <table border="0" cellpadding="0" cellspacing="0" width="98%">
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap="nowrap">
                                                    <span>Community Role Performance </span>
                                                </td>
                                                <td width="17">
                                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/content_tab_sep.gif"
                                                        width="17" height="26" alt="" />
                                                </td>
                                                <td class="content_tab_top" width="100%">
                                                </td>
                                                <td width="7">
                                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/content_tab_right.gif"
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
                                                <td colspan="7" class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="padding_label1" width="9%">
                                                    <span id="Span2" class="ui-stepper">
                                                        <input type="text" id="TextBox_CustomCAFAS2_CommunityPerformance" name="TextBox_CustomCAFAS2_CommunityPerformance"
                                                            value="0" datatype="Number" size="2" autocomplete="off" class="ui-stepper-textbox"
                                                            onchange="CalCulateCafasScore(this,'4','TextArea_CustomCAFAS2_CommunityPerformanceComment');" />
                                                        <img name="ns_button_1_1" class="ui-stepper-plus" style="vertical-align: top; cursor: default"
                                                            src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/toparrow.png" alt="" />
                                                        <img name="ns_button_2_1" class="ui-stepper-minus" style="vertical-align: bottom;
                                                            cursor: default" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/bottomarrow.png" />
                                                    </span>
                                                </td>
                                                <td class="padding_label1">
                                                    <textarea class="form_textareaWithoutWidth" id="TextArea_CustomCAFAS2_CommunityPerformanceComment"
                                                        name="TextArea_CustomCAFAS2_CommunityPerformanceComment" rows="5" spellcheck="True"
                                                        cols="140"   onchange="CafasNeedList('TextBox_CustomCAFAS2_CommunityPerformance','4','TextArea_CustomCAFAS2_CommunityPerformanceComment');"></textarea>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="7" class="height1">
                                                    &nbsp;
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
                                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                                                        height="7" alt="" />
                                                </td>
                                                <td class="right_bottom_cont_bottom_bg" width="100%">
                                                </td>
                                                <td width="2" class="right_bottom_cont_bottom_bg" align="right">
                                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif"
                                                        height="7" alt="" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="padding_label1">
                            <table border="0" cellpadding="0" cellspacing="0" width="98%">
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap="nowrap">
                                                    <span>Behavior Toward Others </span>
                                                </td>
                                                <td width="17">
                                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/content_tab_sep.gif"
                                                        width="17" height="26" alt="" />
                                                </td>
                                                <td class="content_tab_top" width="100%">
                                                </td>
                                                <td width="7">
                                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/content_tab_right.gif"
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
                                                <td colspan="7" class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="padding_label1" width="9%">
                                                    <span id="Span3" class="ui-stepper">
                                                        <input type="text" id="TextBox_CustomCAFAS2_BehaviorTowardsOther" name="TextBox_CustomCAFAS2_BehaviorTowardsOther"
                                                            value="0" datatype="Number" size="2" autocomplete="off" class="ui-stepper-textbox"
                                                            onchange="CalCulateCafasScore(this,'5','TextArea_CustomCAFAS2_BehaviorTowardsOtherComment');"  />
                                                        <img name="ns_button_1_1" class="ui-stepper-plus" style="vertical-align: top; cursor: default"
                                                            src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/toparrow.png" alt="" />
                                                        <img name="ns_button_2_1" class="ui-stepper-minus" style="vertical-align: bottom;
                                                            cursor: default" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/bottomarrow.png" />
                                                    </span>
                                                </td>
                                                <td class="padding_label1">
                                                    <textarea class="form_textareaWithoutWidth" id="TextArea_CustomCAFAS2_BehaviorTowardsOtherComment"
                                                        name="TextArea_CustomCAFAS2_BehaviorTowardsOtherComment" rows="5" spellcheck="True"
                                                        cols="140"   onchange="CafasNeedList('TextBox_CustomCAFAS2_BehaviorTowardsOther','5','TextArea_CustomCAFAS2_BehaviorTowardsOtherComment');"></textarea>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="7" class="height1">
                                                    &nbsp;
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
                                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                                                        height="7" alt="" />
                                                </td>
                                                <td class="right_bottom_cont_bottom_bg" width="100%">
                                                </td>
                                                <td width="2" class="right_bottom_cont_bottom_bg" align="right">
                                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif"
                                                        height="7" alt="" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="padding_label1">
                            <table border="0" cellpadding="0" cellspacing="0" width="98%">
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap="nowrap">
                                                    <span>Moods/Emotions</span>
                                                </td>
                                                <td width="17">
                                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/content_tab_sep.gif"
                                                        width="17" height="26" alt="" />
                                                </td>
                                                <td class="content_tab_top" width="100%">
                                                </td>
                                                <td width="7">
                                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/content_tab_right.gif"
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
                                                <td colspan="7" class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="padding_label1" width="9%">
                                                    <span id="Span4" class="ui-stepper">
                                                        <input type="text" id="TextBox_CustomCAFAS2_MoodsEmotion" name="TextBox_CustomCAFAS2_MoodsEmotion"
                                                            value="0" datatype="Number" size="2" autocomplete="off" class="ui-stepper-textbox"
                                                            onchange="CalCulateCafasScore(this,'6','TextArea_CustomCAFAS2_MoodsEmotionComment');"  />
                                                        <img name="ns_button_1_1" class="ui-stepper-plus" style="vertical-align: top; cursor: default"
                                                            src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/toparrow.png" alt="" />
                                                        <img name="ns_button_2_1" class="ui-stepper-minus" style="vertical-align: bottom;
                                                            cursor: default" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/bottomarrow.png" />
                                                    </span>
                                                </td>
                                                <td class="padding_label1">
                                                    <textarea class="form_textareaWithoutWidth" id="TextArea_CustomCAFAS2_MoodsEmotionComment" name="TextArea_CustomCAFAS2_MoodsEmotionComment"
                                                        rows="5" spellcheck="True" cols="140"   onchange="CafasNeedList('TextBox_CustomCAFAS2_MoodsEmotion','6','TextArea_CustomCAFAS2_MoodsEmotionComment');"></textarea>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="7" class="height1">
                                                    &nbsp;
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
                                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                                                        height="7" alt="" />
                                                </td>
                                                <td class="right_bottom_cont_bottom_bg" width="100%">
                                                </td>
                                                <td width="2" class="right_bottom_cont_bottom_bg" align="right">
                                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif"
                                                        height="7" alt="" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="padding_label1">
                            <table border="0" cellpadding="0" cellspacing="0" width="98%">
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap="nowrap">
                                                    <span>Self-Harmful Behavior</span>
                                                </td>
                                                <td width="17">
                                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/content_tab_sep.gif"
                                                        width="17" height="26" alt="" />
                                                </td>
                                                <td class="content_tab_top" width="100%">
                                                </td>
                                                <td width="7">
                                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/content_tab_right.gif"
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
                                                <td colspan="7" class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="padding_label1" width="9%">
                                                    <span id="Span5" class="ui-stepper">
                                                        <input type="text" id="TextBox_CustomCAFAS2_SelfHarmfulBehavior" name="TextBox_CustomCAFAS2_SelfHarmfulBehavior"
                                                            value="0" datatype="Number" size="2" autocomplete="off" class="ui-stepper-textbox"
                                                            onchange="CalCulateCafasScore(this,'7','TextArea_CustomCAFAS2_SelfHarmfulBehaviorComment');"  />
                                                        <img name="ns_button_1_1" class="ui-stepper-plus" style="vertical-align: top; cursor: default"
                                                            src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/toparrow.png" alt="" />
                                                        <img name="ns_button_2_1" class="ui-stepper-minus" style="vertical-align: bottom;
                                                            cursor: default" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/bottomarrow.png" />
                                                    </span>
                                                </td>
                                                <td class="padding_label1">
                                                    <textarea class="form_textareaWithoutWidth" id="TextArea_CustomCAFAS2_SelfHarmfulBehaviorComment"
                                                        name="TextArea_CustomCAFAS2_SelfHarmfulBehaviorComment" rows="5" spellcheck="True"
                                                        cols="140"  onchange="CafasNeedList('TextBox_CustomCAFAS2_SelfHarmfulBehavior','7','TextArea_CustomCAFAS2_SelfHarmfulBehaviorComment');"></textarea>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="7" class="height1">
                                                    &nbsp;
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
                                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                                                        height="7" alt="" />
                                                </td>
                                                <td class="right_bottom_cont_bottom_bg" width="100%">
                                                </td>
                                                <td width="2" class="right_bottom_cont_bottom_bg" align="right">
                                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif"
                                                        height="7" alt="" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="padding_label1">
                            <table border="0" cellpadding="0" cellspacing="0" width="98%">
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap="nowrap">
                                                    <span>Substance Use</span>
                                                </td>
                                                <td width="17">
                                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/content_tab_sep.gif"
                                                        width="17" height="26" alt="" />
                                                </td>
                                                <td class="content_tab_top" width="100%">
                                                </td>
                                                <td width="7">
                                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/content_tab_right.gif"
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
                                                <td colspan="7" class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="padding_label1" width="9%">
                                                    <span id="Span6" class="ui-stepper">
                                                        <input type="text" id="TextBox_CustomCAFAS2_SubstanceUse" name="TextBox_CustomCAFAS2_SubstanceUse"
                                                            value="0" datatype="Number" size="2" autocomplete="off" class="ui-stepper-textbox"
                                                            onchange="CalCulateCafasScore(this,'8','TextArea_CustomCAFAS2_SubstanceUseComment');"  />
                                                        <img name="ns_button_1_1" class="ui-stepper-plus" style="vertical-align: top; cursor: default"
                                                            src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/toparrow.png" alt="" />
                                                        <img name="ns_button_2_1" class="ui-stepper-minus" style="vertical-align: bottom;
                                                            cursor: default" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/bottomarrow.png" />
                                                    </span>
                                                </td>
                                                <td class="padding_label1">
                                                    <textarea class="form_textareaWithoutWidth" id="TextArea_CustomCAFAS2_SubstanceUseComment" name="TextArea_CustomCAFAS2_SubstanceUseComment"
                                                        rows="5" spellcheck="True" cols="140"  onchange="CafasNeedList('TextBox_CustomCAFAS2_SubstanceUse','8','TextArea_CustomCAFAS2_SubstanceUseComment');"></textarea>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="7" class="height1">
                                                    &nbsp;
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
                                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                                                        height="7" alt="" />
                                                </td>
                                                <td class="right_bottom_cont_bottom_bg" width="100%">
                                                </td>
                                                <td width="2" class="right_bottom_cont_bottom_bg" align="right">
                                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif"
                                                        height="7" alt="" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="padding_label1">
                            <table border="0" cellpadding="0" cellspacing="0" width="98%">
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap="nowrap">
                                                    <span>Thinking</span>
                                                </td>
                                                <td width="17">
                                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/content_tab_sep.gif"
                                                        width="17" height="26" alt="" />
                                                </td>
                                                <td class="content_tab_top" width="100%">
                                                </td>
                                                <td width="7">
                                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/content_tab_right.gif"
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
                                                <td colspan="7" class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="padding_label1" width="9%">
                                                    <span id="Span7" class="ui-stepper">
                                                        <input type="text" id="TextBox_CustomCAFAS2_Thinkng" name="TextBox_CustomCAFAS2_Thinkng"
                                                            value="0" datatype="Number" size="2" autocomplete="off" class="ui-stepper-textbox"
                                                            onchange="CalCulateCafasScore(this,'9','TextArea_CustomCAFAS2_ThinkngComment');"/>
                                                        <img name="ns_button_1_1" class="ui-stepper-plus" style="vertical-align: top; cursor: default"
                                                            src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/toparrow.png" alt="" />
                                                        <img name="ns_button_2_1" class="ui-stepper-minus" style="vertical-align: bottom;
                                                            cursor: default" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/bottomarrow.png" />
                                                    </span>
                                                </td>
                                                <td class="padding_label1">
                                                    <textarea class="form_textareaWithoutWidth" id="TextArea_CustomCAFAS2_ThinkngComment" name="TextArea_CustomCAFAS2_ThinkngComment"
                                                        rows="5" spellcheck="True" cols="140" onchange="CafasNeedList('TextBox_CustomCAFAS2_Thinkng','9','TextArea_CustomCAFAS2_ThinkngComment');"></textarea>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="7" class="height1">
                                                    &nbsp;
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
                                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                                                        height="7" alt="" />
                                                </td>
                                                <td class="right_bottom_cont_bottom_bg" width="100%">
                                                </td>
                                                <td width="2" class="right_bottom_cont_bottom_bg" align="right">
                                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif"
                                                        height="7" alt="" />
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
                        <td class="height2">
                        </td>
                    </tr>
                    <tr>
                        <td class="padding_label1">
                            <table border="0" cellspacing="0" cellpadding="0" width="98%">
                                <tr>
                                    <td align="left" width="15%">
                                        <span class="form_label">Youth Total Score</span>
                                    </td>
                                    <td>
                                        <input readonly="readonly" type="text" id="TextBox_CustomCAFAS2_YouthTotalScore" name="TextBox_CustomCAFAS2_YouthTotalScore"
                                            datatype="Number" size="3" />
                                    </td>
                                    <td width="100%">
                                    </td>
                                    <td width="7">
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
                        <td class="height2">
                        </td>
                    </tr>
                    <tr>
                        <td class="padding_label1">
                            <table border="0" cellpadding="0" cellspacing="0" width="98%">
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap="nowrap">
                                                    <span>Primary Material</span>
                                                </td>
                                                <td width="17">
                                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/content_tab_sep.gif"
                                                        width="17" height="26" alt="" />
                                                </td>
                                                <td class="content_tab_top" width="100%">
                                                </td>
                                                <td width="7">
                                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/content_tab_right.gif"
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
                                                <td colspan="7" class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="padding_label1" width="9%">
                                                    <span id="Span8" class="ui-stepper">
                                                        <input type="text" id="TextBox_CustomCAFAS2_PrimaryFamilyMaterialNeeds" name="TextBox_CustomCAFAS2_PrimaryFamilyMaterialNeeds"
                                                            value="0" datatype="Number" size="2" onchange="CalCulateCafasScore(this,'10','TextArea_CustomCAFAS2_PrimaryFamilyMaterialNeedsComment');" autocomplete="off" class="ui-stepper-textbox" />
                                                        <img name="ns_button_1_1" class="ui-stepper-plus" style="vertical-align: top; cursor: default"
                                                            src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/toparrow.png" alt="" />
                                                        <img name="ns_button_2_1" class="ui-stepper-minus" style="vertical-align: bottom;
                                                            cursor: default" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/bottomarrow.png" />
                                                    </span>
                                                </td>
                                                <td class="padding_label1">
                                                    <textarea class="form_textareaWithoutWidth" id="TextArea_CustomCAFAS2_PrimaryFamilyMaterialNeedsComment"
                                                        name="TextArea_CustomCAFAS2_PrimaryFamilyMaterialNeedsComment" rows="5" spellcheck="True"
                                                        cols="140"   onchange="CafasNeedList('TextBox_CustomCAFAS2_PrimaryFamilyMaterialNeeds','10','TextArea_CustomCAFAS2_PrimaryFamilyMaterialNeedsComment');"></textarea>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="7" class="height1">
                                                    &nbsp;
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
                                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                                                        height="7" alt="" />
                                                </td>
                                                <td class="right_bottom_cont_bottom_bg" width="100%">
                                                </td>
                                                <td width="2" class="right_bottom_cont_bottom_bg" align="right">
                                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif"
                                                        height="7" alt="" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="padding_label1">
                            <table border="0" cellpadding="0" cellspacing="0" width="98%">
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap="nowrap">
                                                    <span>Primary Support</span>
                                                </td>
                                                <td width="17">
                                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/content_tab_sep.gif"
                                                        width="17" height="26" alt="" />
                                                </td>
                                                <td class="content_tab_top" width="100%">
                                                </td>
                                                <td width="7">
                                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/content_tab_right.gif"
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
                                                <td colspan="7" class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="padding_label1" width="9%">
                                                    <span id="Span9" class="ui-stepper">
                                                        <input type="text" id="TextBox_CustomCAFAS2_PrimaryFamilySocialSupport" name="TextBox_CustomCAFAS2_PrimaryFamilySocialSupport"
                                                            value="0" datatype="Number" size="2" onchange="CalCulateCafasScore(this,'11','TextArea_CustomCAFAS2_PrimaryFamilySocialSupportComment');" autocomplete="off" class="ui-stepper-textbox" />
                                                        <img name="ns_button_1_1" class="ui-stepper-plus" style="vertical-align: top; cursor: default"
                                                            src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/toparrow.png" alt="" />
                                                        <img name="ns_button_2_1" class="ui-stepper-minus" style="vertical-align: bottom;
                                                            cursor: default" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/bottomarrow.png" />
                                                    </span>
                                                </td>
                                                <td class="padding_label1">
                                                    <textarea class="form_textareaWithoutWidth" id="TextArea_CustomCAFAS2_PrimaryFamilySocialSupportComment"
                                                        name="TextArea_CustomCAFAS2_PrimaryFamilySocialSupportComment" rows="5" spellcheck="True"
                                                        cols="140"   onchange="CafasNeedList('TextBox_CustomCAFAS2_PrimaryFamilySocialSupport','11','TextArea_CustomCAFAS2_PrimaryFamilySocialSupportComment');"></textarea>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="7" class="height1">
                                                    &nbsp;
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
                                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                                                        height="7" alt="" />
                                                </td>
                                                <td class="right_bottom_cont_bottom_bg" width="100%">
                                                </td>
                                                <td width="2" class="right_bottom_cont_bottom_bg" align="right">
                                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif"
                                                        height="7" alt="" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="padding_label1">
                            <table border="0" cellpadding="0" cellspacing="0" width="98%">
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap="nowrap">
                                                    <span>Non-Custodial Material</span>
                                                </td>
                                                <td width="17">
                                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/content_tab_sep.gif"
                                                        width="17" height="26" alt="" />
                                                </td>
                                                <td class="content_tab_top" width="100%">
                                                </td>
                                                <td width="7">
                                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/content_tab_right.gif"
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
                                                <td colspan="7" class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="padding_label1" width="9%">
                                                    <span id="Span10" class="ui-stepper">
                                                        <input type="text" id="TextBox_CustomCAFAS2_NonCustodialMaterialNeeds" name="TextBox_CustomCAFAS2_NonCustodialMaterialNeeds"
                                                            value="0" datatype="Number" size="2" onchange="CalCulateCafasScore(this,'14','TextArea_CustomCAFAS2_NonCustodialMaterialNeedsComment');" autocomplete="off" class="ui-stepper-textbox" />
                                                        <img name="ns_button_1_1" class="ui-stepper-plus" style="vertical-align: top; cursor: default"
                                                            src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/toparrow.png" alt="" />
                                                        <img name="ns_button_2_1" class="ui-stepper-minus" style="vertical-align: bottom;
                                                            cursor: default" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/bottomarrow.png" />
                                                    </span>
                                                </td>
                                                <td class="padding_label1">
                                                    <textarea class="form_textareaWithoutWidth" id="TextArea_CustomCAFAS2_NonCustodialMaterialNeedsComment"
                                                        name="TextArea_CustomCAFAS2_NonCustodialMaterialNeedsComment" rows="5" spellcheck="True"
                                                        cols="140"   onchange="CafasNeedList('TextBox_CustomCAFAS2_NonCustodialMaterialNeeds','14','TextArea_CustomCAFAS2_NonCustodialMaterialNeedsComment');"></textarea>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="7" class="height1">
                                                    &nbsp;
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
                                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                                                        height="7" alt="" />
                                                </td>
                                                <td class="right_bottom_cont_bottom_bg" width="100%">
                                                </td>
                                                <td width="2" class="right_bottom_cont_bottom_bg" align="right">
                                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif"
                                                        height="7" alt="" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="padding_label1">
                            <table border="0" cellpadding="0" cellspacing="0" width="98%">
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap="nowrap">
                                                    <span>Non-Custodial Support</span>
                                                </td>
                                                <td width="17">
                                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/content_tab_sep.gif"
                                                        width="17" height="26" alt="" />
                                                </td>
                                                <td class="content_tab_top" width="100%">
                                                </td>
                                                <td width="7">
                                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/content_tab_right.gif"
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
                                                <td colspan="7" class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="padding_label1" width="9%">
                                                    <span id="Span11" class="ui-stepper">
                                                        <input type="text" id="TextBox_CustomCAFAS2_NonCustodialSocialSupport" name="TextBox_CustomCAFAS2_NonCustodialSocialSupport"
                                                            value="0" datatype="Number" size="2" onchange="CalCulateCafasScore(this,'15','TextArea_CustomCAFAS2_NonCustodialSocialSupportComment');" autocomplete="off" class="ui-stepper-textbox" />
                                                        <img name="ns_button_1_1" class="ui-stepper-plus" style="vertical-align: top; cursor: default"
                                                            src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/toparrow.png" alt="" />
                                                        <img name="ns_button_2_1" class="ui-stepper-minus" style="vertical-align: bottom;
                                                            cursor: default" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/bottomarrow.png" />
                                                    </span>
                                                </td>
                                                <td class="padding_label1">
                                                    <textarea class="form_textareaWithoutWidth" id="TextArea_CustomCAFAS2_NonCustodialSocialSupportComment"
                                                        name="TextArea_CustomCAFAS2_NonCustodialSocialSupportComment" rows="5" spellcheck="True"
                                                        cols="140"   onchange="CafasNeedList('TextBox_CustomCAFAS2_NonCustodialSocialSupport','15','TextArea_CustomCAFAS2_NonCustodialSocialSupportComment');"></textarea>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="7" class="height1">
                                                    &nbsp;
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
                                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                                                        height="7" alt="" />
                                                </td>
                                                <td class="right_bottom_cont_bottom_bg" width="100%">
                                                </td>
                                                <td width="2" class="right_bottom_cont_bottom_bg" align="right">
                                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif"
                                                        height="7" alt="" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="padding_label1">
                            <table border="0" cellpadding="0" cellspacing="0" width="98%">
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap="nowrap">
                                                    <span>Surrogate Material</span>
                                                </td>
                                                <td width="17">
                                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/content_tab_sep.gif"
                                                        width="17" height="26" alt="" />
                                                </td>
                                                <td class="content_tab_top" width="100%">
                                                </td>
                                                <td width="7">
                                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/content_tab_right.gif"
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
                                                <td colspan="7" class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="padding_label1" width="9%">
                                                    <span id="Span12" class="ui-stepper">
                                                        <input type="text" id="TextBox_CustomCAFAS2_SurrogateMaterialNeeds" name="TextBox_CustomCAFAS2_SurrogateMaterialNeeds"
                                                            value="0" datatype="Number" size="2" onchange="CalCulateCafasScore(this,'12','TextArea_CustomCAFAS2_SurrogateMaterialNeedsComment');"  autocomplete="off" class="ui-stepper-textbox" />
                                                        <img name="ns_button_1_1" class="ui-stepper-plus" style="vertical-align: top; cursor: default"
                                                            src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/toparrow.png" alt="" />
                                                        <img name="ns_button_2_1" class="ui-stepper-minus" style="vertical-align: bottom;
                                                            cursor: default" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/bottomarrow.png" />
                                                    </span>
                                                </td>
                                                <td class="padding_label1">
                                                    <textarea class="form_textareaWithoutWidth" id="TextArea_CustomCAFAS2_SurrogateMaterialNeedsComment"
                                                        name="TextArea_CustomCAFAS2_SurrogateMaterialNeedsComment" rows="5" spellcheck="True"
                                                        cols="140"  onchange="CafasNeedList('TextBox_CustomCAFAS2_SurrogateMaterialNeeds','12','TextArea_CustomCAFAS2_SurrogateMaterialNeedsComment');"></textarea>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="7" class="height1">
                                                    &nbsp;
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
                                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                                                        height="7" alt="" />
                                                </td>
                                                <td class="right_bottom_cont_bottom_bg" width="100%">
                                                </td>
                                                <td width="2" class="right_bottom_cont_bottom_bg" align="right">
                                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif"
                                                        height="7" alt="" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="padding_label1">
                            <table border="0" cellpadding="0" cellspacing="0" width="98%">
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap="nowrap">
                                                    <span>Surrogate Support</span>
                                                </td>
                                                <td width="17">
                                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/content_tab_sep.gif"
                                                        width="17" height="26" alt="" />
                                                </td>
                                                <td class="content_tab_top" width="100%">
                                                </td>
                                                <td width="7">
                                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/content_tab_right.gif"
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
                                                <td colspan="7" class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="padding_label1" width="9%">
                                                    <span id="Span13" class="ui-stepper">
                                                        <input type="text" id="TextBox_CustomCAFAS2_SurrogateSocialSupport" name="TextBox_CustomCAFAS2_SurrogateSocialSupport"
                                                            value="0" datatype="Number" size="2" onchange="CalCulateCafasScore(this,'16','TextArea_CustomCAFAS2_SurrogateSocialSupportComment');" autocomplete="off" class="ui-stepper-textbox" />
                                                        <img name="ns_button_1_1" class="ui-stepper-plus" style="vertical-align: top; cursor: default"
                                                            src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/toparrow.png" alt="" />
                                                        <img name="ns_button_2_1" class="ui-stepper-minus" style="vertical-align: bottom;
                                                            cursor: default" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/bottomarrow.png" />
                                                    </span>
                                                </td>
                                                <td class="padding_label1">
                                                    <textarea class="form_textareaWithoutWidth" id="TextArea_CustomCAFAS2_SurrogateSocialSupportComment"
                                                        name="TextArea_CustomCAFAS2_SurrogateSocialSupportComment" rows="5" spellcheck="True"
                                                        cols="140"   onchange="CafasNeedList('TextBox_CustomCAFAS2_SurrogateSocialSupport','16','TextArea_CustomCAFAS2_SurrogateSocialSupportComment');"></textarea>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="7" class="height1">
                                                    &nbsp;
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
                                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                                                        height="7" alt="" />
                                                </td>
                                                <td class="right_bottom_cont_bottom_bg" width="100%">
                                                </td>
                                                <td width="2" class="right_bottom_cont_bottom_bg" align="right">
                                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif"
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
