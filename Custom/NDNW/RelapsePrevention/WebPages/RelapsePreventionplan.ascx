<%@ Control Language="C#" AutoEventWireup="true" CodeFile="RelapsePreventionplan.ascx.cs"
    Inherits="Custom_RelapsePrevention_WebPages_RelapsePreventionplan" %>
<%@ Register Assembly="Streamline.DotNetDropDownGlobalCodes" Namespace="Streamline.DotNetDropDownGlobalCodes"
    TagPrefix="cc2" %>

<script type="text/javascript" language="javascript" src="<%=RelativePath%>JScripts/ApplicationScripts/jquery.tmpl.min.js"></script>

<div class="DocumentScreen">
    <table cellpadding="0" cellspacing="0" border="0" style="width: 98.5%">
        <tr>
            <td>
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                        <td class="height2">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                <tr>
                                    <td class="content_tab_left" align="left" nowrap='nowrap'>
                                        <span id="SpanRelapsePreventionplan">Plan Information</span>
                                    </td>
                                    <td width="17">
                                        <img style="vertical-align: top;" height="26" width="17" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                                    </td>
                                    <td class="content_tab_top" width="100%" />
                                    <td width="7">
                                        <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="content_tab_bg" style="padding-left: 10px">
                            <table>
                                <tr>
                                    <td style="width: 50%">
                                        <table border="0">
                                            <tr>
                                                <td>
                                                    Plan Name
                                                </td>
                                                <td style="padding-left: 10px">
                                                    <input type="text" class="form_textbox" id="TextBox_CustomDocumentRelapsePreventionPlans_PlanName"
                                                        name="TextBox_CustomDocumentRelapsePreventionPlans_PlanName" class="form_textbox" style="width: 223px" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Plan Period
                                                </td>
                                                <td style="padding-left: 10px">
                                                    <input type="text" class="form_textbox" id="TextBox_CustomDocumentRelapsePreventionPlans_PlanPeriod"
                                                        name="TextBox_CustomDocumentRelapsePreventionPlans_PlanPeriod" class="form_textbox" style="width: 223px" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Plan Status
                                                </td>
                                                <td style="padding-left: 10px">
                                                    <cc2:DropDownGlobalCodes ID="DropDownList_CustomDocumentRelapsePreventionPlans_PlanStatus"
                                                        name="DropDownList_CustomDocumentRelapsePreventionPlans_PlanStatus" runat="server"
                                                        CssClass="form_dropdown" Width="230px" Category="xRelapseplanstatus" AddBlankRow="true"
                                                        BlankRowText="">
                                                    </cc2:DropDownGlobalCodes>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    High Risk Situations
                                                </td>
                                                <td style="padding-left: 10px">
                                                    <cc2:DropDownGlobalCodes ID="DropDownList_CustomDocumentRelapsePreventionPlans_HighRiskSituations"
                                                        name="DropDownList_CustomDocumentRelapsePreventionPlans_HighRiskSituations" runat="server"
                                                        CssClass="form_dropdown" Width="230px" Category="xRelapsehighrisk" AddBlankRow="true"
                                                        BlankRowText="">
                                                    </cc2:DropDownGlobalCodes>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Recovery Activities
                                                </td>
                                                <td style="padding-left: 10px">
                                                    <cc2:DropDownGlobalCodes ID="DropDownList_CustomDocumentRelapsePreventionPlans_RecoveryActivities"
                                                        name="DropDownList_CustomDocumentRelapsePreventionPlans_RecoveryActivities" runat="server"
                                                        CssClass="form_dropdown" Width="230px" Category="xrelapserecoveract" AddBlankRow="true"
                                                        BlankRowText="">
                                                    </cc2:DropDownGlobalCodes>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="padding-left: 45px" valign="top">
                                        <table border="0">
                                            <tr>
                                                <td style="width: 35%">
                                                    Plan Start Date
                                                </td>
                                                <td style="width: 27%;" align="left">
                                                    <input type="text" id="TextBox_CustomDocumentRelapsePreventionPlans_PlanStartDate"
                                                        style="width: 80%" name="TextBox_CustomDocumentRelapsePreventionPlans_PlanStartDate"
                                                        class="date_text" datatype="Date" />
                                                </td>
                                                <td style="width: 38%" align="left">
                                                    <img id="img4" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                        onclick="return showCalendar('TextBox_CustomDocumentRelapsePreventionPlans_PlanStartDate', '%m/%d/%Y');"
                                                        alt="" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Plan End Date
                                                </td>
                                                <td style="width: 27%;" align="left">
                                                    <input type="text" id="TextBox_CustomDocumentRelapsePreventionPlans_PlanEndDate"
                                                        style="width: 80%" name="TextBox_CustomDocumentRelapsePreventionPlans_PlanEndDate"
                                                        class="date_text" datatype="Date" />
                                                </td>
                                                <td style="width: 38%" align="left">
                                                    <img id="img2" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                        onclick="return showCalendar('TextBox_CustomDocumentRelapsePreventionPlans_PlanEndDate', '%m/%d/%Y');"
                                                        alt="" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Next Review Date
                                                </td>
                                                <td style="width: 27%;" align="left">
                                                    <input type="text" id="TextBox_CustomDocumentRelapsePreventionPlans_NextReviewDate"
                                                        style="width: 80%" name="TextBox_CustomDocumentRelapsePreventionPlans_NextReviewDate"
                                                        class="date_text" datatype="Date" />
                                                </td>
                                                <td style="width: 38%" align="left">
                                                    <img id="img3" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                        onclick="return showCalendar('TextBox_CustomDocumentRelapsePreventionPlans_NextReviewDate', '%m/%d/%Y');"
                                                        alt="" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="3">
                                                    <table>
                                                        <tr>
                                                            <td>
                                                                Client participated in recovery plan development?
                                                            </td>
                                                            <td>
                                                                <input type="radio" id="RadioButton_CustomDocumentRelapsePreventionPlans_ClientParticipated_Y"
                                                                    name="RadioButton_CustomDocumentRelapsePreventionPlans_ClientParticipated" value="Y" />
                                                                <label for="RadioButton_EducationResources_ClientParticipated_Y">
                                                                    Yes</label>
                                                                <input type="radio" id="RadioButton_CustomDocumentRelapsePreventionPlans_ClientParticipated_N"
                                                                    value="N" name="RadioButton_CustomDocumentRelapsePreventionPlans_ClientParticipated" />
                                                                <label for="RadioButton_CustomDocumentRelapsePreventionPlans_ClientParticipated_N">
                                                                    No</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
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
                                    <td style="vertical-align: top;" class="right_bottom_cont_bottom_bg" align="right"
                                        width="2">
                                        <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_right.gif" />
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
</div>
