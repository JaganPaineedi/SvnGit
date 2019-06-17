<%@ Control Language="C#" AutoEventWireup="true" CodeFile="TransitionPlan.ascx.cs" Inherits="SHS.SmartCare.TransitionPlan" %>
<%@ Register Src="~/CommonUserControls/CustomGrid.ascx" TagName="CustomGrid" TagPrefix="uc1" %>
<%@ Register Assembly="Streamline.DotNetDropDowns" Namespace="Streamline.DotNetDropDowns" TagPrefix="cc2" %>
<% if (HttpContext.Current == null)
   { %>
<link href="../../../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet"
    type="text/css" />
<%} %>

    <script language="javascript" type="text/javascript" src="<%=RelativePath%>Custom/Scripts/TransitionPlan.js" ></script>

<%@ Register Assembly="Streamline.DotNetDropDowns" Namespace="Streamline.DotNetDropDowns"
    TagPrefix="cc2" %>
<input id="HiddenFieldPageTables" runat="server" name="HiddenFieldPageTables" type="hidden" value="CustomDocumentHealthHomeTransitionPlans" />
<input id="HiddenFieldCustomAjaxCallType" runat="server" name="HiddenFieldCustomAjaxCallType" type="hidden" />
<table class="DocumentScreen" border="0" cellspacing="0" cellpadding="0" style="padding-right:18px" >
    <tr>
        <td>
            <span class="form_label_text" id="Span1">Clinician coordinating discharge</span>
            &nbsp;&nbsp;&nbsp;
            <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentHealthHomeTransitionPlans_ClinicianCoordinatingDischarge"
                name="DropDownList_CustomDocumentHealthHomeTransitionPlans_ClinicianCoordinatingDischarge"
                Width="210px" runat="server" TabIndex="5">
            </cc2:StreamlineDropDowns>
        </td>
    </tr>
    <tr>
        <td class="height2">
        </td>
    </tr>
    <tr>
        <td>
            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                <tr>
                    <td align="left">
                        <table cellspacing="0" cellpadding="0" border="0" width="100%">
                            <tr>
                                <td width="5%">
                                    <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                        <tr>
                                            <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                <span id="Span14">Transition From</span>
                                            </td>
                                            <td width="17">
                                                <img style="vertical-align: top;" height="26" width="17" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                                            </td>
                                            <td class="content_tab_top" width="100%">
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                                <td width="93%" align="left" class="content_tab_top" valign="top">
                                    &nbsp
                                    <input type="checkbox" id="CheckBox_CustomDocumentHealthHomeTransitionPlans_TransitionFromNA"
                                        tabindex="22" class="RadioText" name="CheckBox_CustomDocumentHealthHomeTransitionPlans_TransitionFromNA"
                                        onclick="HideTable(this,'TransitionFrom','TextArea_CustomDocumentHealthHomeTransitionPlans_TransitionFromEntityTypeComment');" />
                                    <span class="RadioText">N/A</span>
                                </td>
                                <td class="content_tab_top">
                                    <img style="vertical-align: top;" height="26" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="content_tab_bg">
                        <table id ="TransitionFrom" width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td style="padding-left: 10px; padding-right: 5px">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td style="width: 10%">
                                                <span class="form_label_text" id="Span2">Entity</span>
                                            </td>
                                            <td style="width: 90%">
                                                <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentHealthHomeTransitionPlans_TransitionFromEntityType"
                                                    name="DropDownList_CustomDocumentHealthHomeTransitionPlans_TransitionFromEntityType"
                                                    Width="210px" runat="server" TabIndex="5">
                                                </cc2:StreamlineDropDowns>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height2">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 10%">
                                                <span class="form_label_text" id="Span3">Other/Comment</span>
                                            </td>
                                            <td style="width: 90%">
                                                <textarea id="TextArea_CustomDocumentHealthHomeTransitionPlans_TransitionFromEntityTypeComment"
                                                    name="TextArea_CustomDocumentHealthHomeTransitionPlans_TransitionFromEntityTypeComment" onkeypress="return maxLength(this, 250);" onpaste="return maxLengthPaste(this,250);"
                                                    rows="4" cols="158" class="form_textarea" spellcheck="True"></textarea>
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
            </table>
        </td>
    </tr>
    <tr>
        <td class="height2">
        </td>
    </tr>
    <tr>
        <td>
            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                <tr>
                    <td align="left">
                        <table cellspacing="0" cellpadding="0" border="0" width="100%">
                            <tr>
                                <td width="5%">
                                    <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                        <tr>
                                            <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                <span id="Span4">Transition To</span>
                                            </td>
                                            <td width="17">
                                                <img style="vertical-align: top;" height="26" width="17" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                                            </td>
                                            <td class="content_tab_top" width="100%">
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                                <td width="93%" align="left" class="content_tab_top" valign="top">
                                    &nbsp;
                                    <input type="checkbox" id="CheckBox_CustomDocumentHealthHomeTransitionPlans_TransitionToNA"
                                        tabindex="22" class="RadioText" name="CheckBox_CustomDocumentHealthHomeTransitionPlans_TransitionToNA"
                                        onclick="HideTable(this,'TransitionTo','TextArea_CustomDocumentHealthHomeTransitionPlans_TransitionToEntityTypeComment');" />
                                    <span class="RadioText">N/A</span>
                                </td>
                                <td class="content_tab_top">
                                    <img style="vertical-align: top;" height="26" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="content_tab_bg">
                        <table id = "TransitionTo" width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td style="padding-left: 10px; padding-right: 5px">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td style="width: 10%">
                                                <span class="form_label_text" id="Span5">Entity</span>
                                            </td>
                                            <td style="width: 90%">
                                                <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentHealthHomeTransitionPlans_TransitionToEntityType"
                                                    name="DropDownList_CustomDocumentHealthHomeTransitionPlans_TransitionToEntityType"
                                                    Width="210px" runat="server" TabIndex="5">
                                                </cc2:StreamlineDropDowns>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height2">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 10%">
                                                <span class="form_label_text" id="Span6">Other/Comment</span>
                                            </td>
                                            <td style="width: 90%">
                                                <textarea id="TextArea_CustomDocumentHealthHomeTransitionPlans_TransitionToEntityTypeComment"
                                                    name="TextArea_CustomDocumentHealthHomeTransitionPlans_TransitionToEntityTypeComment" onkeypress="return maxLength(this, 250);" onpaste="return maxLengthPaste(this,250);"
                                                    rows="4" cols="158" class="form_textarea" spellcheck="True"></textarea>
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
            </table>
        </td>
    </tr>
    <tr>
        <td class="height2">
        </td>
    </tr>
    <tr>
        <td>
            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                <tr>
                    <td align="left">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                    Residence Information
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
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td style="padding-left: 10px; padding-right: 5px">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td colspan="2">
                                                <span class="form_label_text" id="Span7">If this is a transition "from", client's residence immediately
                                                    following discharge</span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height2">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2">
                                                <textarea id="TextArea_CustomDocumentHealthHomeTransitionPlans_ResidenceFollowingDischarge"
                                                    name="TextArea_CustomDocumentHealthHomeTransitionPlans_ResidenceFollowingDischarge"
                                                    rows="4" cols="158" class="form_textarea" spellcheck="True"></textarea>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height2">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2">
                                                <input type="checkbox" id="CheckBox_CustomDocumentHealthHomeTransitionPlans_ResidenceFollowingDischargeNA"
                                                    tabindex="22" class="RadioText" name="CheckBox_CustomDocumentHealthHomeTransitionPlans_ResidenceFollowingDischargeNA"
                                                    onclick="HideTable(this,'divresidence','TextArea_CustomDocumentHealthHomeTransitionPlans_ResidencePlanForLongTerm');" />
                                                <span class="RadioText">N/A</span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height2">
                                            </td>
                                        </tr>
                                        <tr>
                                        <td>
                                        <div id="divresidence">
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                          <tr>
                                            <td style="width:27%">
                                                <span class="form_label_text" id="Span8">Is this a long term/permanent residence?
                                                 
                                                                </span>
                                                            </td>
                                                            <td style="width: 73%">
                                                                <input class="cursor_default" type="radio" style="vertical-align: bottom" id="RadioButton_CustomDocumentHealthHomeTransitionPlans_ResidencePermanent_Y"
                                                                    name="RadioButton_CustomDocumentHealthHomeTransitionPlans_ResidencePermanent"
                                                                    value="Y" />
                                                                <label for="RadioButton_CustomDocumentHealthHomeTransitionPlans_ResidencePermanent_Y">
                                                                    Yes</label>
                                                                &nbsp&nbsp&nbsp
                                                                <input class="cursor_default" type="radio" style="vertical-align: bottom" id="RadioButton_CustomDocumentHealthHomeTransitionPlans_ResidencePermanent_N"
                                                                    name="RadioButton_CustomDocumentHealthHomeTransitionPlans_ResidencePermanent"
                                                                    value="N" />
                                                                <label for="RadioButton_CustomDocumentHealthHomeTransitionPlans_ResidencePermanent">
                                                                    No</label>
                                                                &nbsp&nbsp&nbsp
                                                                <input class="cursor_default" type="radio" style="vertical-align: bottom" id="RadioButton_CustomDocumentHealthHomeTransitionPlans_ResidencePermanent_A"
                                                                    name="RadioButton_CustomDocumentHealthHomeTransitionPlans_ResidencePermanent"
                                                                    value="A" />
                                                                <label for="RadioButton_CustomDocumentHealthHomeTransitionPlans_ResidencePermanent">
                                                                    N/A</label>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <span class="form_label_text" id="Span9">If no, what is the plan for long term/permanent
                                                                    residency? </span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <textarea id="TextArea_CustomDocumentHealthHomeTransitionPlans_ResidencePlanForLongTerm"
                                                                    name="TextArea_CustomDocumentHealthHomeTransitionPlans_ResidencePlanForLongTerm"
                                                                    rows="4" cols="158" class="form_textarea" spellcheck="True"></textarea>
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
            </table>
        </td>
    </tr>
    <tr>
        <td class="height2">
        </td>
    </tr>
    <tr>
        <td>
            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                <tr>
                    <td align="left">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                    Scheduled Service Dates
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
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td style="padding-left: 10px; padding-right: 5px">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td style="width: 28%">
                                                <span class="form_label_text" id="Span10">Date of next scheduled Health Home Service
                                            </td>
                                            <td style="width: 72%">
                                                <input type="text" id="TextBox_CustomDocumentHealthHomeTransitionPlans_NextScheduledHHServiceDate"
                                                    name="TextBox_CustomDocumentHealthHomeTransitionPlans_NextScheduledHHServiceDate"
                                                    datatype="Date" class="form_textbox element" style="width: 75px;" />
                                                <img id="Img3" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                    onclick="return showCalendar('TextBox_CustomDocumentHealthHomeTransitionPlans_NextScheduledHHServiceDate', '%m/%d/%Y');"
                                                    style="cursor: hand;" filter="false" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height2">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr>
                                                        <td style="width: 43%">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr>
                                                                    <td style="width: 65%">
                                                                        <span class="form_label_text" id="Span13">Date of next A Renewed Mind Visit</span>
                                                                    </td>
                                                                    <td style="width: 35%; padding-left: 1px">
                                                                        <input type="text" datatype="Date" id="TextBox_CustomDocumentHealthHomeTransitionPlans_NextScheduledMHServiceDate"
                                                                            name="TextBox_CustomDocumentHealthHomeTransitionPlans_NextScheduledMHServiceDate"
                                                                            class="form_textbox element" style="width: 75px" />
                                                                        <img id="Img1" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                            onclick="return showCalendar('TextBox_CustomDocumentHealthHomeTransitionPlans_NextScheduledMHServiceDate', '%m/%d/%Y');"
                                                                            style="cursor: hand;" filter="false" />
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                        <td style="width: 52%">
                                                            <span class="form_label_text" id="Span11">Type </span>&nbsp&nbsp&nbsp
                                                            <input type="text" id="TextBox_CustomDocumentHealthHomeTransitionPlans_NextScheduledMHServiceType"
                                                                name="TextBox_CustomDocumentHealthHomeTransitionPlans_NextScheduledMHServiceType"
                                                                maxlength="250" class="form_textbox element" style="width: 87%" maxlength="250" />
                                                        </td>
                                                        <td style="width: 5%">
                                                            <input type="checkbox" id="CheckBox_CustomDocumentHealthHomeTransitionPlans_NextScheduledMHServiceTypeNA"
                                                                tabindex="22" class="RadioText" name="CheckBox_CustomDocumentHealthHomeTransitionPlans_NextScheduledMHServiceTypeNA"
                                                                onclick="" />
                                                            <span class="RadioText">N/A</span>
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
                                                <span class="form_label_text" id="Span12">Date of next scheduled PCP visit </span>
                                            </td>
                                            <td>
                                                <input type="text" id="TextBox_CustomDocumentHealthHomeTransitionPlans_NextScheduledPCPVisitDate"
                                                    name="TextBox_CustomDocumentHealthHomeTransitionPlans_NextScheduledPCPVisitDate"
                                                    datatype="Date" class="form_textbox element" style="width: 75px;" />
                                                <img id="Img2" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                    onclick="return showCalendar('TextBox_CustomDocumentHealthHomeTransitionPlans_NextScheduledPCPVisitDate', '%m/%d/%Y');"
                                                    style="cursor: hand;" filter="false" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height2">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2">
                                                <span class="form_label_text" id="Span15">Reminder: ensure PCP receives a copy of discharge
                                                    paperwork if this is a transition "from" </span>
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
            </table>
        </td>
    </tr>
    <tr>
        <td class="height2">
        </td>
    </tr>
    <tr>
        <td>
            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                <tr>
                    <td align="left">
                        <table cellspacing="0" cellpadding="0" border="0" width="100%">
                            <tr>
                                <td>
                                    <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                        <tr>
                                            <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                Referrals
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
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="content_tab_bg">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td style="padding-left: 10px; padding-right: 5px">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td colspan="2">
                                                <span class="form_label_text" id="Span17">Is the client referred to any additionalspecialists, supports, 
                                                    or other treatments (ex.physical therapy, behavioral health counseling, AA, cardiologist,
                                                    etc.)?</span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height2">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2">
                                                <input class="cursor_default" type="radio" style="vertical-align: bottom" id="RadioButton_CustomDocumentHealthHomeTransitionPlans_HasRerralsToAdditionalProvider_Y"
                                                    name="RadioButton_CustomDocumentHealthHomeTransitionPlans_HasRerralsToAdditionalProvider"
                                                    value="Y" onclick="ShowHideReferrals();" />
                                                <label for="RadioButton_CustomDocumentHealthHomeTransitionPlans_HasRerralsToAdditionalProvider_Y">
                                                    Yes</label>
                                                &nbsp&nbsp&nbsp
                                                <input class="cursor_default" type="radio" style="vertical-align: bottom" id="RadioButton_CustomDocumentHealthHomeTransitionPlans_HasRerralsToAdditionalProvider_N"
                                                    name="RadioButton_CustomDocumentHealthHomeTransitionPlans_HasRerralsToAdditionalProvider"
                                                    value="N" onclick="ShowHideReferrals();" />
                                                <label for="RadioButton_CustomDocumentHealthHomeTransitionPlans_HasRerralsToAdditionalProvider_N">
                                                    No</label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height2">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2">
                                                <div id="Referrals" style="width: 100%">
                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0" id="TableChildControl_CustomDocumentHealthHomeReferrals">
                                                        <tr>
                                                            <td style="width: 22%">
                                                                <span class="form_label_text" id="Span16">Referral</span>
                                                            </td>
                                                            <td style="width: 78%">
                                                                <input type="text" id="TextBox_CustomDocumentHealthHomeReferrals_Referral" parentchildcontrols="True"
                                                                    name="TextBox_CustomDocumentHealthHomeReferrals_Referral" class="form_textbox"
                                                                    style="width: 90%" maxlength="250" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2" colspan="2">
                                                                <input type="hidden" id="HiddenField_CustomDocumentHealthHomeReferrals_HealthHomeReferralId"
                                                                    name="HiddenField_CustomDocumentHealthHomeReferrals_HealthHomeReferralId" parentchildcontrols="True"
                                                                    value="-1" />
                                                                <input type="hidden" id="HiddenFieldPrimaryKeyHealthHomeReferralId" name="HiddenFieldPrimaryKeyHealthHomeReferralId"
                                                                    value="HealthHomeReferralId" parentchildcontrols="True" />
                                                                <input type="hidden" id="HiddenField_CustomDocumentHealthHomeReferrals_DocumentVersionId"
                                                                    name="HiddenField_CustomDocumentHealthHomeReferrals_DocumentVersionId" value="-1"
                                                                    parentchildcontrols="True" />
                                                                <input type="hidden" id="HiddenField_CustomDocumentHealthHomeReferrals_Phone" name="HiddenField_CustomDocumentHealthHomeReferrals_Phone"  parentchildcontrols="True" includeinparentchildxml="true" />
                                                                <input type="hidden" id="HiddenField_CustomDocumentHealthHomeReferrals_SequenceNumber" name = "HiddenField_CustomDocumentHealthHomeReferrals_SequenceNumber" parentchildcontrols="True" includeinparentchildxml="true" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <span class="form_label_text" id="Span18">Scheduled for</span>
                                                            </td>
                                                            <td>
                                                                <input type="text" id="TextBox_CustomDocumentHealthHomeReferrals_ScheduledFor" parentchildcontrols="True"
                                                                    name="TextBox_CustomDocumentHealthHomeReferrals_ScheduledFor" class="form_textbox element"
                                                                    style="width: 90%" maxlength="250" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2" colspan="2">
                                                            </td>
                                                        </tr>
                                                        <%--<tr>
                                                            <td>
                                                                <span class="form_label_text" id="Span19">Phone </span>
                                                            </td>
                                                            <td>
                                                               <input type="text" id="TextBox_CustomDocumentHealthHomeReferrals_Phone" parentchildcontrols="True"
                                                                    name="TextBox_CustomDocumentHealthHomeReferrals_Phone" class="form_textbox element"
                                                                    style="width: 90%" maxlength="250" />
                                                                    
                                                            </td>
                                                        </tr>--%>
                                                        <tr>
                                                                            <td width="15%" align="left" >
                                                                                <span class="form_label" id="Span38">Phone</span>
                                                                                </td>
                                                                                <td align="left" width="85%" valign="top">
                                                                                    <span class="form_label" id="Span39">(</span>
                                                                                    <input id="TextBox_CustomDocumentHealthHomeReferrals_Phone1" enabled="enabled" type="text" class="form_textbox"
                                                                                        style="width: 6%" datatype="Numeric" maxlength="3" bindautosaveevents="False"
                                                                                        onkeyup="return autoTab(this, 3, event);" onkeydown="AllowNumericOnly('TextBox_CustomDocumentHealthHomeReferrals_Phone1');"
                                                                                        onblur="javascript:UpdatePhone('1');" />
                                                                                    <span class="form_label" id="Span40">)</span>
                                                                                    <input id="TextBox_CustomDocumentHealthHomeReferrals_Phone2" enabled="enabled" type="text" class="form_textbox"
                                                                                        onkeyup="return autoTab(this, 3, event);" style="width: 6%" datatype="Numeric"
                                                                                        maxlength="3" bindautosaveevents="False" onblur="javascript:UpdatePhone('2');"
                                                                                        onkeydown="AllowNumericOnly('TextBox_CustomDocumentHealthHomeReferrals_Phone2');" />
                                                                                    <span class="form_label" id="Span41">-</span>
                                                                                    <input id="TextBox_CustomDocumentHealthHomeReferrals_Phone3" enabled="enabled" type="text" class="form_textbox"
                                                                                        onkeyup="return autoTab(this, 4, event);" style="width: 8%" datatype="Numeric"
                                                                                        maxlength="4" onkeydown="AllowNumericOnly('TextBox_CustomDocumentHealthHomeReferrals_Phone3');"
                                                                                        bindautosaveevents="False" onblur="javascript:UpdatePhone('3');" />
                                                                                    <span class="form_label" id="Span42">Ext</span>
                                                                                    <input id="TextBox_CustomDocumentHealthHomeReferrals_Phone4" enabled="enabled" type="text" class="form_textbox"
                                                                                        onkeyup="return autoTab(this, 6, event);" style="width: 10%" datatype="Numeric"
                                                                                        maxlength="6" bindautosaveevents="False" onblur="javascript:UpdatePhone('4');"
                                                                                        onkeydown="AllowNumericOnly('TextBox_CustomDocumentHealthHomeReferrals_Phone4');" />
                                                                                </td>                                                                            
                                                                        </tr>
                                                        <tr>
                                                            <td class="height2" colspan="2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <span class="form_label_text" id="Span20">Transportation will be provided by</span>
                                                            </td>
                                                            <td>
                                                                <input type="text" id="TextBox_CustomDocumentHealthHomeReferrals_TransportationProvidedBy"
                                                                    name="TextBox_CustomDocumentHealthHomeReferrals_TransportationProvidedBy" parentchildcontrols="True"
                                                                    class="form_textbox element" style="width: 90%" maxlength="250" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2" colspan="2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2" style="text-align: right; padding-right: 20px;" class="height2">
                                                                <input type="button" id="TableChildControl_CustomDocumentHealthHomeReferrals_ButtonInsert"
                                                                    name="TableChildControl_CustomDocumentHealthHomeReferrals_ButtonInsert" baseurl="<%=ResolveUrl("~") %>"
                                                                    onclick="insertCustomDocumentHealthHomeReferrals('TableChildControl_CustomDocumentHealthHomeReferrals','InsertGrid_CustomDocumentHealthHomeReferrals','CustomGrid_CustomDocumentHealthHomeReferrals', this);"
                                                                    value="Insert" class="parentchildbutton" />&nbsp;<input type="button" id="Button3"
                                                                        onclick="Clear_CustomDocumentHealthHomeReferrals_Data();" name="ButtonClear"
                                                                        value="Clear" class="parentchildbutton" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2" class="height2">
                                                            </td>
                                                        </tr>
                                                        <!-- Custom Grid -->
                                                        <tr>
                                                            <td colspan="2">
                                                                <div id="InsertGrid_CustomDocumentHealthHomeReferrals" style="overflow-x: hidden;
                                                                    overflow-y: auto; height: 100px; width: 100%">
                                                                    <uc1:CustomGrid ID="CustomGrid_CustomDocumentHealthHomeReferrals" runat="server"
                                                                        TableName="CustomDocumentHealthHomeReferrals" PrimaryKey="HealthHomeReferralId"
                                                                        CustomGridTableName="TableChildControl_CustomDocumentHealthHomeReferrals" GridPageName="CustomDocumentHealthHomeReferrals_Grid"
                                                                        ColumnName="Referral:ScheduledFor:Phone:TransportationProvidedBy" ColumnHeader="Referral:Scheduled for:Phone:Transportation will be provided by"
                                                                        ColumnWidth="25%:25%:15%:35%" DivGridName="InsertGrid_CustomDocumentHealthHomeReferrals"
                                                                        InsertButtonId="TableChildControl_CustomDocumentHealthHomeReferrals_ButtonInsert"
                                                                        OrderByQuery="HealthHomeReferralId" />
                                                                </div>
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
            </table>
        </td>
    </tr>
    <tr>
        <td class="height2">
        </td>
    </tr>
    <tr>
        <td>
            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                <tr>
                    <td align="left">
                        <table cellspacing="0" cellpadding="0" border="0" width="100%">
                            <tr>
                                <td>
                                    <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                        <tr>
                                            <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                Prior Authorization
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
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="content_tab_bg">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0" id="TableChildControl_CustomDocumentHealthHomePriorAuthorizations">
                            <tr>
                                <td style="padding-left: 10px; padding-right: 5px">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td colspan="2">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr>
                                                        <td style="width: 75%">
                                                            <span id="Span21" class="form_label_text">Is Prior Autherization or a PCP Referral required
                                                                for any specialists, supports, or treatements referenced on this plan?</span>
                                                        </td>
                                                        <td style="width: 25%">
                                                            <input class="cursor_default" type="radio" style="vertical-align: bottom" id="RadioButton_CustomDocumentHealthHomeTransitionPlans_RequiresAuthsForAdditionalProvider_N"
                                                                name="RadioButton_CustomDocumentHealthHomeTransitionPlans_RequiresAuthsForAdditionalProvider"
                                                                value="N" onclick="ShowHidePriorAuthorization();" />
                                                            <label for="RadioButton_CustomDocumentHealthHomeTransitionPlans_RequiresAuthsForAdditionalProvider_N">
                                                                No</label>
                                                            &nbsp&nbsp&nbsp
                                                            <input class="cursor_default" type="radio" style="vertical-align: bottom" id="RadioButton_CustomDocumentHealthHomeTransitionPlans_RequiresAuthsForAdditionalProvider_Y"
                                                                name="RadioButton_CustomDocumentHealthHomeTransitionPlans_RequiresAuthsForAdditionalProvider"
                                                                value="Y" onclick="ShowHidePriorAuthorization();" />
                                                            <label for="RadioButton_CustomDocumentHealthHomeTransitionPlans_RequiresAuthsForAdditionalProvider_Y">
                                                                Yes</label>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height2">
                                                <input type="hidden" id="HiddenField_CustomDocumentHealthHomePriorAuthorizations_HealthHomePriorAuthorizationId"
                                                    name="HiddenField_CustomDocumentHealthHomePriorAuthorizations_HealthHomePriorAuthorizationId"
                                                    parentchildcontrols="True" value="-1" />
                                                <input type="hidden" id="HiddenFieldPrimaryKeyHealthHomePriorAuthorizationId" name="HiddenFieldPrimaryKeyHealthHomePriorAuthorizationId"
                                                    value="HealthHomePriorAuthorizationId" parentchildcontrols="True" />
                                                <input type="hidden" id="HiddenField_CustomDocumentHealthHomePriorAuthorizations_DocumentVersionId"
                                                    name="HiddenField_CustomDocumentHealthHomePriorAuthorizations_DocumentVersionId"
                                                    value="-1" parentchildcontrols="True" />
                                                <input type="hidden" id="HiddenField_CustomDocumentHealthHomePriorAuthorizations_SequenceNumber" name = "HiddenField_CustomDocumentHealthHomePriorAuthorizations_SequenceNumber" parentchildcontrols="True" includeinparentchildxml="true" />    
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2">
                                                <div id="PriorAuthorization">
                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                            <td>
                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                        <td style="width: 55%">
                                                                            <span class="form_label_text" id="Span22">Service </span>&nbsp&nbsp
                                                                            <input type="text" id="TextBox_CustomDocumentHealthHomePriorAuthorizations_ServiceDescription"
                                                                                parentchildcontrols="True" name="TextBox_CustomDocumentHealthHomePriorAuthorizations_ServiceDescription"
                                                                                class="form_textbox element" style="width: 85%" maxlength="250" />
                                                                        </td>
                                                                        <td style="width: 45%">
                                                                            <span class="form_label_text" id="Span23">Date authorization/ referral obtained or verified</span>&nbsp&nbsp
                                                                            <input type="text" id="TextBox_CustomDocumentHealthHomePriorAuthorizations_DateAuthorizationObtained"
                                                                                name="TextBox_CustomDocumentHealthHomePriorAuthorizations_DateAuthorizationObtained"
                                                                                parentchildcontrols="True" datatype="Date" class="form_textbox element" style="width: 75px;" />
                                                                            <img id="Img5" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                                onclick="return showCalendar('TextBox_CustomDocumentHealthHomePriorAuthorizations_DateAuthorizationObtained', '%m/%d/%Y');"
                                                                                style="cursor: hand;" filter="false" />
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
                                                            <td colspan="2" style="text-align: right; padding-right: 20px;">
                                                                <input type="button" id="TableChildControl_CustomDocumentHealthHomePriorAuthorizations_ButtonInsert"
                                                                    name="TableChildControl_CustomDocumentHealthHomePriorAuthorizations_ButtonInsert"
                                                                    baseurl="<%=ResolveUrl("~") %>" onclick="insertCustomDocumentHealthHomePriorAuthorizations('TableChildControl_CustomDocumentHealthHomePriorAuthorizations','InsertGrid_CustomDocumentHealthHomePriorAuthorizations','CustomGrid_CustomDocumentHealthHomePriorAuthorizations', this);"
                                                                    value="Insert" class="parentchildbutton" />&nbsp;<input type="button" id="ButtonClear"
                                                                        onclick="Clear_CustomDocumentHealthHomePriorAuthorizations_Data();" name="ButtonClear"
                                                                        value="Clear" class="parentchildbutton" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2" class="height2">
                                                            </td>
                                                        </tr>
                                                        <!-- Custom Grid -->
                                                        <tr>
                                                            <td colspan="2">
                                                                <div id="InsertGrid_CustomDocumentHealthHomePriorAuthorizations" style="overflow-x: hidden;
                                                                    overflow-y: auto; height: 100px; width: 100%;">
                                                                    <uc1:CustomGrid ID="CustomGrid_CustomDocumentHealthHomePriorAuthorizations" runat="server"
                                                                        TableName="CustomDocumentHealthHomePriorAuthorizations" PrimaryKey="HealthHomePriorAuthorizationId"
                                                                        CustomGridTableName="TableChildControl_CustomDocumentHealthHomePriorAuthorizations"
                                                                        GridPageName="CustomDocumentHealthHomePriorAuthorizations_Grid" ColumnName="ServiceDescription:DateAuthorizationObtained"
                                                                        ColumnHeader="Service:Date autherization/ referral obtained or verified" ColumnWidth="50%:50%" ColumnFormat=":Date"
                                                                        DivGridName="InsertGrid_CustomDocumentHealthHomePriorAuthorizations" InsertButtonId="TableChildControl_CustomDocumentHealthHomePriorAuthorizations_ButtonInsert"
                                                                        OrderByQuery="HealthHomePriorAuthorizationId" />
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2">
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
            </table>
        </td>
    </tr>
    <tr>
        <td class="height2">
        </td>
    </tr>
    <tr>
        <td>
            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                <tr>
                    <td align="left">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                    Plan
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
                        <table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 10px;
                            padding-right: 5px">
                            <tr>
                                <td>
                                    <span class="form_label_text" id="Span24">Plan to prevent need for more intensive treatment
                                        (inpatient, residential, emergency, department, etc.)</span>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <textarea id="TextArea_CustomDocumentHealthHomeTransitionPlans_PreventionPlan" name="TextArea_CustomDocumentHealthHomeTransitionPlans_PreventionPlan"
                                        rows="4" cols="158" class="form_textarea" spellcheck="True"></textarea>
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
            </table>
        </td>
    </tr>
    <tr>
        <td class="height2">
        </td>
    </tr>
    <tr>
        <td>
            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                <tr>
                    <td align="left">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                    Post Discharge
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
                        <table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 10px;
                            padding-right: 5px">
                            <tr>
                                <td>
                                    <span class="form_label_text" id="Span25">Complete this section Post Discharge</span>
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
                                            <td style="width: 25%">
                                                <span class="form_label_text" id="Span26">Medication Reconciliation Completion Date</span>
                                            </td>
                                            <td style="width: 15%">
                                                <input type="text" id="TextBox_CustomDocumentHealthHomeTransitionPlans_MedReconciliationCompletionDate"
                                                    name="TextBox_CustomDocumentHealthHomeTransitionPlans_MedReconciliationCompletionDate"
                                                    datatype="Date" class="form_textbox element" style="width: 75px;" />
                                                <img id="Img4" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                    onclick="return showCalendar('TextBox_CustomDocumentHealthHomeTransitionPlans_MedReconciliationCompletionDate', '%m/%d/%Y');"
                                                    style="cursor: hand;" filter="false" />
                                            </td>
                                            <td style="width: 60%">
                                                <input type="checkbox" id="CheckBox_CustomDocumentHealthHomeTransitionPlans_MedReconciliationCompletionNA"
                                                    tabindex="22" class="RadioText" name="CheckBox_CustomDocumentHealthHomeTransitionPlans_MedReconciliationCompletionNA"
                                                    onclick="" />
                                                <span class="RadioText">N/A</span>
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
                                    <span class="form_label_text" id="Span27">(record all medications the client is currently
                                        on in SmartCare RX, may use discharge instructions (ex. from hospital) for reference)</span>
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
                                            <td style="width: 83%">
                                                <span class="form_label_text" id="Span28">Client/guardian has demonstrated understanding
                                                    of all discharge instructions including medication administration instructions,
                                                    if applicable </span>
                                            </td>
                                            <td style="width: 17%">
                                                <input class="cursor_default" type="radio" style="vertical-align: bottom" id="RadioButton_CustomDocumentHealthHomeTransitionPlans_ClientHasDemonstratedUnderstanding_Y"
                                                    name="RadioButton_CustomDocumentHealthHomeTransitionPlans_ClientHasDemonstratedUnderstanding"
                                                    value="Y" />
                                                <label for="RadioButton_CustomDocumentHealthHomeTransitionPlans_RadioButton_CustomDocumentHealthHomeTransitionPlans_ClientHasDemonstratedUnderstanding_Y">
                                                    Yes</label>
                                                &nbsp&nbsp&nbsp
                                                <input class="cursor_default" type="radio" style="vertical-align: bottom" id="RadioButton_CustomDocumentHealthHomeTransitionPlans_ClientHasDemonstratedUnderstanding_N"
                                                    name="RadioButton_CustomDocumentHealthHomeTransitionPlans_ClientHasDemonstratedUnderstanding"
                                                    value="N" />
                                                <label for="RadioButton_CustomDocumentHealthHomeTransitionPlans_ClientHasDemonstratedUnderstanding">
                                                    No</label>
                                                &nbsp&nbsp&nbsp
                                                <input class="cursor_default" type="radio" style="vertical-align: bottom" id="RadioButton_CustomDocumentHealthHomeTransitionPlans_ClientHasDemonstratedUnderstanding_A"
                                                    name="RadioButton_CustomDocumentHealthHomeTransitionPlans_ClientHasDemonstratedUnderstanding"
                                                    value="A" />
                                                <label for="RadioButton_CustomDocumentHealthHomeTransitionPlans_ClientHasDemonstratedUnderstanding">
                                                    N/A</label>
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
                                            <td style="width: 58%">
                                                <span class="form_label_text" id="Span29">Coordination of records/instructions from
                                                    discharging to accepting provider to next complete</span>
                                            </td>
                                            <td style="width: 42%">
                                                <input class="cursor_default" type="radio" style="vertical-align: bottom" id="RadioButton_CustomDocumentHealthHomeTransitionPlans_CoordinationOfRecordsComplete_Y"
                                                    name="RadioButton_CustomDocumentHealthHomeTransitionPlans_CoordinationOfRecordsComplete"
                                                    value="Y" />
                                                <label for="RadioButton_CustomDocumentHealthHomeTransitionPlans_CoordinationOfRecordsComplete_Y">
                                                    Yes</label>
                                                &nbsp&nbsp&nbsp
                                                <input class="cursor_default" type="radio" style="vertical-align: bottom" id="RadioButton_CustomDocumentHealthHomeTransitionPlans_CoordinationOfRecordsComplete_N"
                                                    name="RadioButton_CustomDocumentHealthHomeTransitionPlans_CoordinationOfRecordsComplete"
                                                    value="N" />
                                                <label for="RadioButton_CustomDocumentHealthHomeTransitionPlans_CoordinationOfRecordsComplete_N">
                                                    No</label>
                                                &nbsp&nbsp&nbsp
                                                <input class="cursor_default" type="radio" style="vertical-align: bottom" id="RadioButton_CustomDocumentHealthHomeTransitionPlans_CoordinationOfRecordsComplete_A"
                                                    name="RadioButton_CustomDocumentHealthHomeTransitionPlans_CoordinationOfRecordsComplete"
                                                    value="A" />
                                                <label for="RadioButton_CustomDocumentHealthHomeTransitionPlans_CoordinationOfRecordsComplete_A">
                                                    N/A</label>
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
                                            <td style="width: 16%">
                                                <span class="form_label_text" id="Span30">Additional Comments</span>
                                            </td>
                                            <td style="width: 84%">
                                                <textarea id="TextArea_CustomDocumentHealthHomeTransitionPlans_AdditionalComments"
                                                    name="TextArea_CustomDocumentHealthHomeTransitionPlans_AdditionalComments" rows="4"
                                                    cols="158" class="form_textarea" spellcheck="True"></textarea>
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
                                    <span class="form_label_text" id="Span31">Provider: Please provide the client/ guardian
                                        with a copy of this plan for reference. </span>
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
            </table>
        </td>
    </tr>
</table>
<asp:Panel ID="PanelLoadUC" runat="server">
</asp:Panel>