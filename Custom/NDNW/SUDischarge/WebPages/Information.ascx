<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Information.ascx.cs" Inherits="SHS.SmartCare.Custom_SUDischarge_WebPages_Information" %>
<%@ Register Assembly="Streamline.DotNetDropDownGlobalCodes" Namespace="Streamline.DotNetDropDownGlobalCodes"
    TagPrefix="cc1" %>
<div>
    <table border="0" cellpadding="0" cellspacing="0" class="DocumentScreen">
        <tr>
            <td>
                <table cellpadding="0" width="98%" cellspacing="0" border="0">
                    <tr>
                        <td class="height2">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="content_tab_left" align="left" nowrap='nowrap'>
                                        <span id="Span_SectionDemographicsInformation">Demographics Information</span>
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
                        <td class="content_tab_bg" style="padding-left: 10px">
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td colspan="2" class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 19%">
                                        <span id="SpanCurrentLivingArrangement">Current Living Arrangement*</span>
                                    </td>
                                    <td align="left" style="width: 81%">
                                        <cc1:DropDownGlobalCodes ID="DropDownList_CustomDocumentSUDischarges_LivingArrangement"
                                            EnableViewState="false" AddBlankRow="true" BlankRowText="" runat="server" Category="xSUHouseholdComp"
                                            Style="width: 40%;" CssClass="form_dropdown">
                                        </cc1:DropDownGlobalCodes>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 19%">
                                        <span id="SpanEmploymentStatus">Employment Status*</span>
                                    </td>
                                    <td align="left" style="width: 81%">
                                        <cc1:DropDownGlobalCodes ID="DropDownList_CustomDocumentSUDischarges_EmploymentStatus"
                                            EnableViewState="false" AddBlankRow="true" BlankRowText="" runat="server" Category="EMPLOYMENTSTATUS"
                                            Style="width: 40%;" CssClass="form_dropdown">
                                        </cc1:DropDownGlobalCodes>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 19%">
                                        <span id="SpanEducation">Education*</span>
                                    </td>
                                    <td align="left" style="width: 81%">
                                        <cc1:DropDownGlobalCodes ID="DropDownList_CustomDocumentSUDischarges_Education" EnableViewState="false"
                                            AddBlankRow="true" BlankRowText="" runat="server" Category="xTEDSEnrolledEd"
                                            Style="width: 40%;" CssClass="form_dropdown">
                                        </cc1:DropDownGlobalCodes>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr class="tmplrow">
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
                    <tr>
                        <td class="height2">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="content_tab_left" align="left" nowrap='nowrap'>
                                        <span id="Span_SectionLegalInformation">Legal Information</span>
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
                        <td class="content_tab_bg" style="padding-left: 10px">
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td colspan="2" class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 19%">
                                        <span id="SpanNumberOfArrests"># of Arrests in past 30 days</span>
                                    </td>
                                    <td align="left" style="width: 81%">
                                        <input class="form_textbox" style="width: 35px; height: 13px;" type="text" datatype="Numeric"
                                            id="TextBox_CustomDocumentSUDischarges_NumberOfArrests" runat="server" name="TextBox_CustomDocumentSUDischarges_NumberOfArrests"
                                            maxlength="5" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr class="tmplrow">
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
                    <tr>
                        <td class="height2">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="content_tab_left" align="left" nowrap='nowrap'>
                                        <span id="Span_ParticipationinSocialSupport">Social Support</span>
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
                        <td class="content_tab_bg" style="padding-left: 10px">
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td colspan="2" class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 19%">
                                        <span id="SpanSocialSupport">Participation in Social Support</span>
                                    </td>
                                    <td align="left" style="width: 81%">
                                        <cc1:DropDownGlobalCodes ID="DropDownList_CustomDocumentSUDischarges_SocialSupport"
                                            EnableViewState="false" AddBlankRow="true" BlankRowText="" runat="server" Category="XSOCIALSUPPORT"
                                            Style="width: 40%;" CssClass="form_dropdown">
                                        </cc1:DropDownGlobalCodes>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 19%">
                                        <span id="SpanSelfHelpAttended">Number of self-help groups attended in the last 30 days</span>
                                    </td>
                                    <td align="left" style="width: 81%">
                                        <input class="form_textbox" style="width: 35px; height: 13px;" type="text" datatype="Numeric"
                                            id="TextBox_CustomDocumentSUDischarges_NumberOfSelfHelpGroupsAttendedLast30Days"
                                            runat="server" name="TextBox_CustomDocumentSUDischarges_NumberOfSelfHelpGroupsAttendedLast30Days"
                                            maxlength="5" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr class="tmplrow">
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
                    <tr>
                        <td class="height2">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="content_tab_left" align="left" nowrap='nowrap'>
                                        <span id="Span1">Other Information</span>
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
                        <td class="content_tab_bg" style="padding-left: 10px">
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td colspan="2" class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 19%">
                                        <span id="SpanFacetoFaceContact">Last face to face contact</span>
                                    </td>
                                    <td style="width: 88%">
                                        <table border="0" cellpadding="0" cellspacing="0">
                                            <tr class="date_Container">
                                                <td>
                                                    <input type="text" id="TextBox_CustomDocumentSUDischarges_LastFaceToFaceDate" name="TextBox_CustomDocumentSUDischarges_LastFaceToFaceDate"
                                                        datatype="Date" class="form_textbox" />
                                                </td>
                                                <td>
                                                    &nbsp;
                                                </td>
                                                <td>
                                                    <img id="imgDateOfDischarge" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                        onclick="return showCalendar('TextBox_CustomDocumentSUDischarges_LastFaceToFaceDate', '%m/%d/%Y');" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr class="tmplrow">
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
</div>
