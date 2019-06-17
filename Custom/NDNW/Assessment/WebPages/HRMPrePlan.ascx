<%@ Control Language="C#" AutoEventWireup="true" CodeFile="HRMPrePlan.ascx.cs" Inherits="SHS.SmartCare.ActivityPages_Client_Detail_Assessment_HRMPrePlan" %>
<% if (HttpContext.Current == null)
   { %>
<link href="../../../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet"
    type="text/css" />
<%} %>
<div style="overflow-x: hidden">
    <table border="0" cellpadding="0" cellspacing="0" class="DocumentScreen">
        <tr>
            <td class="height2">
            </td>
        </tr>
        <tr>
            <td class="height2">
            </td>
        </tr>
        <tr>
            <td class="checkbox_container" colspan="3">
                <input tabindex="1" type="checkbox" id="CheckBox_CustomHRMAssessments_PrePlanSeparateDocument" name="CheckBox_CustomHRMAssessments_PrePlanSeparateDocument"
                    onclick="hideTable();" style="padding-left: 4px" />
                <label for="CheckBox_CustomHRMAssessments_PrePlanSeparateDocument" class="form_label">
                    Separate preplanning document to be completed prior to treatment planning.</label>
            </td>
        </tr>
        <tr>
            <td colspan="3" class="height2">
            </td>
        </tr>
        <tr>
            <td>
                <table id="mainTable" border="0" cellpadding="0" cellspacing="0" width="99%">
                    <tr>
                        <td valign="top" width="49%">
                            <table border="0" cellpadding="0" cellspacing="0" width="98%">
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                    Participants
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
                                        <table style="height: 198px" border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <table  cellpadding="0" cellspacing="0" border="0" width="100%">
                                                        <tr>
                                                            <td style="padding-left: 7px;">
                                                                <span class="form_label">Who would you like to participate in your planning? How would
                                                                    you like to </span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="padding-left: 7px;">
                                                                <span class="form_label">invite them? How will they provide input? (By being present
                                                                    at the meeting, </span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="padding-left: 7px;">
                                                                <span class="form_label">providing input by phone,etc.) Who will be the recorder?
                                                                </span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="padding-left: 10px;">
                                                                <textarea tabindex="2" class="form_textareaWithoutWidth" id="TextArea_CustomHRMAssessments_Participants" name="TextArea_CustomHRMAssessments_Participants"
                                                                    spellcheck="True" cols="70" rows="11" ></textarea>
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
                                <tr>
                                    <td valign="top">
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr>
                                                <td>
                                                    <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                                        <tr>
                                                            <td colspan="1" class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                                Time/Location
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
                                                            <td class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="padding-left: 7px;">
                                                                <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                                    <tr>
                                                                        <td>
                                                                            <span class="form_label">What date and time would you like to have this meeting? Where
                                                                                would you </span>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <span class="form_label">like to have the meeting held?</span>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height2">
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-left: 3px;">
                                                                            <textarea tabindex="8" class="form_textareaWithoutWidth" id="TextArea_CustomHRMAssessments_TimeLocation" name="TextArea_CustomHRMAssessments_TimeLocation"
                                                                                spellcheck="True" datatype="String" cols="70" rows="6" ></textarea>
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
                                            <tr>
                                                <td valign="top">
                                                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                        <tr>
                                                            <td>
                                                                <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                                                    <tr>
                                                                        <td colspan="1" class="height2">
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                                            Issues to Avoid
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
                                                                        <td class="height2">
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-left: 7px;">
                                                                            <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                                                <tr>
                                                                                    <td>
                                                                                        <span class="form_label">Are there any issues you do not want to discuss at the meeting?</span>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td class="height2">
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td style="padding-left: 3px;">
                                                                                        <textarea tabindex="10"class="form_textareaWithoutWidth" id="TextArea_CustomHRMAssessments_IssuesToAvoid"
                                                                                            name="TextArea_CustomHRMAssessments_IssuesToAvoid" spellcheck="True" datatype="String"
                                                                                            cols="70" rows="7"></textarea>
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
                                            <tr>
                                                <td valign="top">
                                                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                        <tr>
                                                            <td>
                                                                <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                                                    <tr>
                                                                        <td colspan="1" class="height2">
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                                            What?
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
                                                                        <td class="height2">
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-left: 7px;">
                                                                            <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                                                <tr>
                                                                                    <td>
                                                                                        <span id = "PrePlanSpanText1" class="form_label">What does the customer do well, fear, preferences, supports
                                                                                            customer has </span>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <span id = "PrePlanSpanText2" class="form_label">or wish they had, what is stopping customer from living
                                                                                            the way he/she </span>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <span id = "PrePlanSpanText3" class="form_label">wants to live?</span>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td class="height2">
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td style="padding-left: 3px;">
                                                                                        <textarea tabindex="12" class="form_textareaWithoutWidth" id="TextArea_CustomHRMAssessments_IssuesToDiscuss"
                                                                                            name="TextArea_CustomHRMAssessments_IssuesToDiscuss" spellcheck="True" datatype="String"
                                                                                            cols="70" rows="5" ></textarea>
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
                                <tr>
                                    <td valign="top">
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr>
                                                <td valign="top">
                                                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                        <tr>
                                                            <td>
                                                                <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                                                    <tr>
                                                                        <td colspan="1" class="height2">
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                                            Self Determination/Fiscal Intermediary
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
                                                                        <td class="height2">
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-left: 7px;">
                                                                            <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                                                <tr>
                                                                                    <td>
                                                                                        <span class="form_label">Self Determination discussed and client desires this.</span>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td colspan="1" class="height2">
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td class="RadioText">
                                                                                        <input type="radio" tabindex="15" id="RadioButton_CustomHRMAssessments_SelfDeterminationDesired_N"
                                                                                            name="RadioButton_CustomHRMAssessments_SelfDeterminationDesired" value="N" /><label
                                                                                                for="RadioButton_CustomHRMAssessments_SelfDeterminationDesired_N" class="form_label">No,
                                                                                                does not desire</label>
                                                                                        <input type="radio" tabindex="16" id="RadioButton_CustomHRMAssessments_SelfDeterminationDesired_Y"
                                                                                            name="RadioButton_CustomHRMAssessments_SelfDeterminationDesired" value="Y" style="padding-right: 3px;" /><label
                                                                                                for="RadioButton_CustomHRMAssessments_SelfDeterminationDesired_Y">Yes, referral
                                                                                                made</label>
                                                                                        <input type="radio" tabindex="17" id="RadioButton_CustomHRMAssessments_SelfDeterminationDesired_A"
                                                                                            name="RadioButton_CustomHRMAssessments_SelfDeterminationDesired" value="A" style="padding-right: 3px;" /><label
                                                                                                for="RadioButton_CustomHRMAssessments_SelfDeterminationDesired_A">N/A</label>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td colspan="1" class="height2">
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <span class="form_label">Having a Fiscal Intermediary discussed and client desires this.</span>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td colspan="1" class="height2">
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td class="RadioText">
                                                                                        <input class="cursor_default" tabindex="18" type="radio" id="RadioButton_CustomHRMAssessments_FiscalIntermediaryDesired_N"
                                                                                            name="RadioButton_CustomHRMAssessments_FiscalIntermediaryDesired" value="N" style="padding-right: 3px;" /><label
                                                                                                for="RadioButton_CustomHRMAssessments_FiscalIntermediaryDesired_N">No, does not
                                                                                                desire
                                                                                            </label>
                                                                                        <input class="cursor_default" tabindex="19" type="radio" id="RadioButton_CustomHRMAssessments_FiscalIntermediaryDesired_Y"
                                                                                            name="RadioButton_CustomHRMAssessments_FiscalIntermediaryDesired" value="Y" style="padding-right: 3px;" /><label
                                                                                                for="RadioButton_CustomHRMAssessments_FiscalIntermediaryDesired_Y">Yes, referral
                                                                                                made</label>
                                                                                        <input class="cursor_default" tabindex="20"type="radio" id="RadioButton_CustomHRMAssessments_FiscalIntermediaryDesired_A"
                                                                                            name="RadioButton_CustomHRMAssessments_FiscalIntermediaryDesired" value="A" style="padding-right: 3px;" /><label
                                                                                                for="RadioButton_CustomHRMAssessments_FiscalIntermediaryDesired_A">N/A</label>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td colspan="1" class="height2">
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td style="padding-left: 3px;">
                                                                                        <textarea tabindex="21" class="form_textareaWithoutWidth" id="Textarea_CustomHRMAssessments_PrePlanFiscalIntermediaryComment"
                                                                                            name="Textarea_CustomHRMAssessments_PrePlanFiscalIntermediaryComment" cols="70"
                                                                                            rows="4"  spellcheck="True" datatype="String"></textarea>
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
                        </td>
                        <td style="width: 5px">
                            &nbsp;
                        </td>
                        <td valign="top" width="49%">
                            <table border="0" cellpadding="0" cellspacing="0" width="98%">
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                    Facilitator
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
                                        <table style="height: 198px"  border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="padding-left: 7px;">
                                                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                        <tr>
                                                            <td>
                                                                <span class="form_label">Did you offer the client information regarding independent
                                                                    facilitation?</span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="1" class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="RadioText">
                                                                <input tabindex="3" class="cursor_default" type="radio" id="RadioButton_CustomHRMAssessments_PrePlanIndependentFacilitatorDiscussed_Y"
                                                                    name="RadioButton_CustomHRMAssessments_PrePlanIndependentFacilitatorDiscussed"
                                                                    value="Y" /><label for="RadioButton_CustomHRMAssessments_PrePlanIndependentFacilitatorDiscussed_Y"
                                                                        class="form_label">Yes</label>
                                                            </td>
                                                            <tr>
                                                                <td class="height2">
                                                                </td>
                                                            </tr>
                                                        </tr>
                                                        <tr>
                                                            <td class="RadioText">
                                                                <input tabindex="4" class="cursor_default" type="radio" id="RadioButton_CustomHRMAssessments_PrePlanIndependentFacilitatorDiscussed_N"
                                                                    name="RadioButton_CustomHRMAssessments_PrePlanIndependentFacilitatorDiscussed"
                                                                    value="N" /><label for="RadioButton_CustomHRMAssessments_PrePlanIndependentFacilitatorDiscussed_N"
                                                                        class="form_label">N/A-Client is meds only, short term OP or incarcerated</label>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="1" class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <span class="form_label" groupname="GroupFacilitatorDiscussed" style="padding-left: 4px">
                                                                    Does the client request an independent facilitator? </span>
                                                                <input tabindex="5" class="RadioText" type="radio" id="RadioButton_CustomHRMAssessments_PrePlanIndependentFacilitatorDesired_Y"
                                                                    name="RadioButton_CustomHRMAssessments_PrePlanIndependentFacilitatorDesired"
                                                                    value="Y" groupname="GroupFacilitatorDiscussed" style="padding-left: 4px; padding-right: 3px;" /><label
                                                                        for="RadioButton_CustomHRMAssessments_PrePlanIndependentFacilitatorDesired_Y"
                                                                        class="RadioText">Yes</label><input tabindex="6" class="RadioText" type="radio" id="RadioButton_CustomHRMAssessments_PrePlanIndependentFacilitatorDesired_N"
                                                                            name="RadioButton_CustomHRMAssessments_PrePlanIndependentFacilitatorDesired"
                                                                            value="N" groupname="GroupFacilitatorDiscussed" style="padding-left: 6px; padding-right: 3px;" /><label
                                                                                for="RadioButton_CustomHRMAssessments_PrePlanIndependentFacilitatorDesired_N"
                                                                                class="RadioText">No</label>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height3">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <span class="form_label">Who would you like to facilitate you meeting? </span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height1">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="padding-left: 3px;">
                                                                <textarea tabindex="7" class="form_textareaWithoutWidth" id="TextArea_CustomHRMAssessments_Facilitator" name="TextArea_CustomHRMAssessments_Facilitator"
                                                                    spellcheck="True" datatype="String" cols="70" rows="7" ></textarea>
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
                                <tr>
                                    <td valign="top">
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr>
                                                <td>
                                                    <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                                        <tr>
                                                            <td colspan="1" class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                                Communication Accommodations
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
                                                            <td class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="padding-left: 7px;">
                                                                <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                                    <tr>
                                                                        <td nowrap="nowrap">
                                                                            <span class="form_label">Are there any communication accommodations that need to
                                                                            be arranged?
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height2">
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-left: 3px;">
                                                                            <textarea tabindex="9" class="form_textareaWithoutWidth" id="TextArea_CustomHRMAssessments_CommunicationAccomodations"
                                                                                name="TextArea_CustomHRMAssessments_CommunicationAccomodations" spellcheck="True"
                                                                                datatype="String" cols="70" rows="7" ></textarea>
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
                                <tr>
                                    <td valign="top">
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr>
                                                <td>
                                                    <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                                        <tr>
                                                            <td colspan="1" class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                                Source of Pre Planning Information
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
                                                            <td class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="padding-left: 7px;">
                                                                <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                                    <tr>
                                                                        <td>
                                                                            <span class="form_label">Who provided this pre-planning information? </span>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height2">
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-left: 3px;">
                                                                            <textarea tabindex="11" class="form_textareaWithoutWidth" id="TextArea_CustomHRMAssessments_SourceOfPrePlanningInfo"
                                                                                name="TextArea_CustomHRMAssessments_SourceOfPrePlanningInfo" spellcheck="True"
                                                                                datatype="String" cols="70" rows="7"></textarea>
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
                                <tr>
                                    <td valign="top">
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr>
                                                <td>
                                                    <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                                        <tr>
                                                            <td colspan="1" class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                                PCP Information
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
                                                            <td class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="padding-left: 7px;">
                                                                <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                                    <tr>
                                                                        <td>
                                                                            <span class="form_label">I have given the client information on person centered planning
                                                                                and we have </span>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <span class="form_label">discussed how the process occurs.</span>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="1" class="height2">
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="RadioText">
                                                                            <input tabindex="13" type="checkbox" id="CheckBox_CustomHRMAssessments_PamphletGiven" name="CheckBox_CustomHRMAssessments_PamphletGiven"
                                                                                style="padding-left: 4px" /><label for="CheckBox_CustomHRMAssessments_PamphletGiven"
                                                                                    style="padding-left: 4px">Pamphlet Given</label>
                                                                            <input type="checkBox" tabindex="14" id="Checkbox_CustomHRMAssessments_PamphletDiscussed" name="CheckBox_CustomHRMAssessments_PamphletDiscussed"
                                                                                style="padding-left: 4px" /><label for="Checkbox_CustomHRMAssessments_PamphletDiscussed"
                                                                                    style="padding-left: 4px">Discussed</label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="1" class="height2">
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
            </td>
        </tr>
    </table>
</div>
