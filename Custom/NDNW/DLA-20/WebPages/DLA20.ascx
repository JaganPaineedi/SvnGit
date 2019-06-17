<%@ Control Language="C#" AutoEventWireup="true" CodeFile="DLA20.ascx.cs" Inherits="Custom_DLA_20_WebPages_DLA20" %>
<input type="hidden" id="hiddenReletivePath" value='<%=RelativePath%>' />
<% if (HttpContext.Current == null)
   { %>
<link href="../../../../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet"
    type="text/css" />
<%} %>
<div style="overflow-x: hidden">
    <table border="0" cellpadding="0" cellspacing="0" class="DocumentScreen">
        <tr>
            <td>
                <table border="0" cellpadding="0" cellspacing="0" width="99%">
                    <tr>
                        <td class="padding_label1">
                            <table border="0" cellspacing="0" cellpadding="0" width="99%">
                                <tr>
                                    <td class="height2"></td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap='nowrap'>Instructions
                                                </td>
                                                <td width="17">
                                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/content_tab_sep.gif"
                                                        width="17" height="26" alt="" />
                                                </td>
                                                <td class="content_tab_top" width="100%">
                                                    <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                                        <tr>
                                                            <td class="checkbox_container" style="width: 20%;padding-bottom:4px">
                                                                <input type="checkbox" id="CheckBox_CustomDocumentDLA20s_NoDLA" name="CheckBox_CustomDocumentDLA20s_NoDLA" />
                                                                <label for="CheckBox_CustomDocumentDLA20s_NoDLA" style="cursor: default">No DLA Activities</label>
                                                            </td>
                                                            <td style="width: 80%"></td>
                                                        </tr>
                                                    </table>
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
                                                <td style="width: 100%; padding-left: 10px;">
                                                    <span class="form_label">DLA-20 (copyright protected)  Instructions: Using the scale below, rate how often or how well the consumer independently performed or managed each of the 20 activities of Daily Living during the last 30 days. If the consumer’s level of functioning varied,  rate the lowest possible score. Consider impairments in functioning due to physical limitations and mental impairments. Do not consider environmental limitations (e.g., “no jobs available”). A score of 5 to 7 in an activity indicates functioning “within normal limits” (WNL) for that activity – use criteria under strengths. N/A = only when “not assessed.” Do not exceed 5 N/A. </span>
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
                                                <td class="right_bottom_cont_bottom_bg" width="100%"></td>
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
                    <tr height="5px">
                        <td></td>
                    </tr>
                    <tr>
                        <td class="padding_label1">
                            <table border="0" cellspacing="0" cellpadding="0" width="99%">
                                <tr>
                                    <td class="height2"></td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap='nowrap'>Activities
                                                </td>
                                                <td width="17">
                                                    <img style="vertical-align: top" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/content_tab_sep.gif"
                                                        width="17" height="26" alt="" />
                                                </td>
                                                <td class="content_tab_top" width="100%"></td>
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
                                        <div id="DivHeader">
                                            <table>
                                                <tr>
                                                    <td class="height3"></td>
                                                </tr>
                                                <tr>
                                                    <td style="padding-left: 10px; font-size: small;" width="15%"><b>Activities</b>
                                                    </td>
                                                    <td style="font-size: small;" width="65%"><b>Criteria for scoring strengths as WNL behaviors (Scores 5-7)</b>
                                                    </td>
                                                    <td style="padding-left: 25px; font-size: small" width="20%"><b>Score - Description</b>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                        <div id="DivActivityContent">
                                        </div>
                                        <div>
                                            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                                <tr style="height: 4px;"></tr>
                                                <tr>
                                                    <td style="width: 60%; text-align: right; padding-right: 10px">
                                                        <label for="TextBoxSum20Ratings" class="form_label">
                                                            Sum 20 Ratings</label></td>
                                                    <td style="width: 20%">
                                                        <input class="form_textboxNew30" type="text" id="TextBoxSum20Ratings"
                                                            name="TextBoxSum20Ratings" disabled="disabled" datatype="Numeric" maxlength="20" style="width: 40%; height: 20px; padding: 2px; border: 1px solid #a8bac3; font-size: 11px; color: #333;" />
                                                    </td>
                                                    <td style="width: 20%"></td>
                                                    <%-- <td align ="left">                                         
                                              <label for="TextBoxSum20Ratings" class="form_label">
                                                        Sum 20 Ratings&nbsp;&nbsp;</label>
                                            <input class="form_textboxNew30" type="text" id="TextBoxSum20Ratings"
                                                name="TextBoxSum20Ratings" disabled="disabled"  datatype="Numeric" maxlength="20" style="width: 28%; height: 20px;padding: 2px; border: 1px solid #a8bac3; font-size: 11px; color: #333;" />
                                          </td>--%>
                                                </tr>
                                                <tr style="height: 3px;"></tr>
                                                <tr>
                                                    <td style="width: 60%; text-align: right; padding-right: 10px">
                                                        <label for="TextBoxAverageDLA" class="form_label">
                                                            Average DLA</label></td>
                                                    <td style="width: 20%">
                                                        <input class="form_textboxNew30" type="text" id="TextBoxAverageDLA"
                                                            name="TextBoxAverageDLA" disabled="disabled" datatype="Numeric" maxlength="20" style="width: 40%; height: 20px; padding: 2px; border: 1px solid #a8bac3; font-size: 11px; color: #333;" />
                                                    </td>
                                                    <td style="width: 20%"></td>
                                                    <%--<td align ="left"><label for="TextBoxAverageDLA" class="form_label">
                                                        Average DLA&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label><input class="form_textboxNew30" type="text" id="TextBoxAverageDLA"
                                                name="TextBoxAverageDLA"  disabled="disabled" datatype="Numeric" maxlength="20" style="width: 28%; height: 20px;padding: 2px; border: 1px solid #a8bac3; font-size: 11px; color: #333;" /></td>--%>
                                                </tr>
                                                <tr style="height: 3px;">
                                                </tr>
                                                <tr>
                                                    <td style="width: 60%; text-align: right; padding-right: 10px">
                                                        <label for="TextBoxAverageDLA" class="form_label">
                                                            Estimate GAF</label></td>
                                                    <td style="width: 20%">
                                                        <input class="form_textboxNew30" type="text" id="TextBoxEstimateGAF"
                                                            name="TextBoxEstimateGAF" disabled="disabled" datatype="Numeric" maxlength="20" style="width: 40%; height: 20px; padding: 2px; border: 1px solid #a8bac3; font-size: 11px; color: #333;" />
                                                    </td>
                                                    <td style="width: 20%"></td>
                                                    <%-- <td><label for="TextBoxAverageDLA" class="form_label">
                                                        Estimate GAF&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label><input class="form_textboxNew30" type="text" id="TextBoxEstimateGAF"
                                                name="TextBoxEstimateGAF"  disabled="disabled" datatype="Numeric" maxlength="20" style="width: 28%; height: 20px;padding: 2px; border: 1px solid #a8bac3; font-size: 11px; color: #333;" /></td>--%>
                                                </tr>
                                            </table>
                                        </div>
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
                                                <td class="right_bottom_cont_bottom_bg" width="100%"></td>
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
    <div id="DivScaleMessage" style="display: none; background-color: white; outline: 1px; top: 80px; border: 3px #1C5B94 solid; height: 150px; width: 730px; z-index: 1000; position: absolute;">
        <table border="0" width="100%" cellpadding="0" cellspacing="0">
            <tr>
                <td align="center">
                    <table class="PopUpTitleBar" border="0" cellpadding="0" cellspacing="0" width="99%">
                        <tr>
                            <td id="topborder" class="TitleBarText LPadd5">Streamline SmartCare
                            </td>
                            <td align="left" width="10px">
                                <a href="#">
                                    <img id="ImgCross" src=" <%=Page.ResolveUrl("~")%>App_Themes/Includes/Images/cross.jpg"
                                        title="Close" onclick="DivScaleMessageHide()" alt="Close" />
                                </a>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <span class="form_label">1 – None of the time; extremely severe impairment or problems
                        in functioning; pervasive level of continuous paid supports needed.<br />
                        2 – A little of the time; severe impairment or problems in functioning; extensive
                        level of continuous paid supports needed.
                        <br />
                        3 – Occasionally; moderately severe impairment or problems in functioning; moderate
                        level of continuous paid supports needed.<br />
                        4 – Some of the time; moderate impairment or problems in functioning; moderate level
                        of continuous paid supports needed.<br />
                        5 – A good bit of the time; mild impairment or problems in functioning; moderate
                        level of intermittent paid supports needed.<br />
                        6 – Most of the time; very mild impairment or problems in functioning; low level
                        of intermittent paid supports needed.<br />
                        7 – All of the time; no significant impairment or problems in functioning requiring
                        paid supports.<br />
                    </span>
                </td>
            </tr>
        </table>
    </div>
</div>
