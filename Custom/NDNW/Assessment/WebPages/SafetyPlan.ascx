<%@ Control Language="C#" AutoEventWireup="true" CodeFile="SafetyPlan.ascx.cs" Inherits="SHS.SmartCare.Custom_Assessment_WebPages_SafetyPlan" %>
<%@ Register Assembly="Streamline.DotNetDropDowns" Namespace="Streamline.DotNetDropDowns"
    TagPrefix="cc2" %>
<%@ Register Src="~/CommonUserControls/CustomGrid.ascx" TagName="CustomGrid" TagPrefix="uc1" %>
<div>
    <table border="0" cellpadding="0" cellspacing="0" class="DocumentScreen">
        <tr>
            <td class="height2">
            </td>
        </tr>
        <tr>
            <td>
                <table width="98%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td class="height1">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="content_tab_left" nowrap='nowrap'>
                                        General
                                    </td>
                                    <td width="17">
                                        <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif"
                                            width="17" height="26" alt="" />
                                    </td>
                                    <td class="content_tab_top" width="100%">
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%" style="margin-top: -15px">
                                            <tr>
                                                <td valign="bottom" style="width: 25%; padding-left: 15px">
                                                </td>
                                            </tr>
                                        </table>
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
                            <table cellpadding="0" cellspacing="0" border="0" width="90%">
                                <tr>
                                    <td align="left" style="width: 2%">
                                        <input type="radio" id="RadioButton_CustomDocumentSafetyCrisisPlans_InitialSafetyPlan_Y"
                                            value="Y" name="RadioButton_CustomDocumentSafetyCrisisPlans_InitialSafetyPlan"
                                            style="cursor: default" checked="checked" onclick="ReInitializeSafetyPlan('Y')" />
                                    </td>
                                    <td align="left" nowrap='nowrap' style="width: 20%">
                                        <label for="RadioButton_CustomDocumentSafetyCrisisPlans_InitialSafetyPlan_Y" style="cursor: default">
                                            Initial Safety Plan</label>
                                    </td>
                                    <td align="left" style="width: 2%">
                                        <input type="radio" id="RadioButton_CustomDocumentSafetyCrisisPlans_InitialSafetyPlan_N"
                                            value="N" name="RadioButton_CustomDocumentSafetyCrisisPlans_InitialSafetyPlan"
                                            style="cursor: default" onclick="ReInitializeSafetyPlan('N')" />
                                    </td>
                                    <td align="left" style="width: 20%">
                                        <label for="RadioButton_CustomDocumentSafetyCrisisPlans_InitialSafetyPlan_N" style="cursor: default">
                                            Review</label>
                                    </td>
                                    <td align="left" style="width: 2%">
                                        <input type="checkbox" id="CheckBox_CustomDocumentSafetyCrisisPlans_ClientHasCurrentCrisis"
                                            name="CheckBox_CustomDocumentSafetyCrisisPlans_ClientHasCurrentCrisis" style="cursor: default"
                                            value="C" onclick="showCurrentCrisis(this)" />
                                    </td>
                                    <td align="left" valign="middle" style="padding-left: 3px">
                                        <label for="CheckBox_CustomDocumentSafetyCrisisPlans_ClientHasCurrentCrisis" style="cursor: default">
                                            Client has current crisis</label>
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
                    <tr>
                        <td class="height2">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="content_tab_left" nowrap='nowrap'>
                                        Warning Signs of a Crisis
                                    </td>
                                    <td width="17">
                                        <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif"
                                            width="17" height="26" alt="" />
                                    </td>
                                    <td class="content_tab_top" width="100%">
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%" style="margin-top: -15px">
                                            <tr>
                                                <td valign="bottom" style="width: 25%; padding-left: 15px">
                                                </td>
                                            </tr>
                                        </table>
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
                                    <td align="left" style="width: 100%;">
                                        <span id="Span_WarningSignsCrisis">What are my thoughts, feelings, behaviors, or moods
                                            that indicate that a crisis may be developing?*</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2" style="width: 100%;">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 100%;">
                                        <textarea class="form_textarea" id="TextArea_CustomDocumentSafetyCrisisPlans_WarningSignsCrisis"
                                            name="TextArea_CustomDocumentSafetyCrisisPlans_WarningSignsCrisis" rows="4" cols="1"
                                            style="width: 98%;" spellcheck="True" datatype="String"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2">
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
                    <tr>
                        <td class="height2">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="content_tab_left" nowrap='nowrap'>
                                        Coping Strategies
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
                                    <td align="left" style="width: 100%;">
                                        <span id="Span_CopingStrategies">What can I do to make sure that I am personally safe?*</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2" style="width: 100%;">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 100%;">
                                        <textarea class="form_textarea" id="TextArea_CustomDocumentSafetyCrisisPlans_CopingStrategies"
                                            name="TextArea_CustomDocumentSafetyCrisisPlans_CopingStrategies" rows="4" cols="1"
                                            style="width: 98%;" spellcheck="True" datatype="String"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2">
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
                    <tr>
                        <td class="height2">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="content_tab_left" nowrap='nowrap'>
                                        Support Systems
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
                            <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                <tr>
                                    <td>
                                        <table id="TableChildControl_CustomSupportContacts" parentchildcontrols="True" cellpadding="0"
                                            cellspacing="0" border="0" width="100%">
                                            <tr>
                                                <td style="width: 100%">
                                                    <span id="Span_WhomdoIcontactwhenIneedhelp">Whom do I contact when I need help?*</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="width: 100%" class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="width: 100%">
                                                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                        <tr>
                                                            <td style="width: 8%">
                                                                <span id="Span_CustomSupportContactsContact">Contact:</span>
                                                            </td>
                                                            <td style="width: 30%">
                                                                <cc2:StreamlineDropDowns ID="DropDownList_ClientContactInformation_Name" name="DropDownList_ClientContactInformation_Name"
                                                                    Width="93%" runat="server" CssClass="form_dropdown" bindautosaveevents="False"
                                                                    parentchildcontrols="True" bindsetformdata="False">
                                                                </cc2:StreamlineDropDowns>
                                                            </td>
                                                            <td style="width: 17%;">
                                                                <input class="more_detail_btn_120" type="button" id="TableChildControl_CustomSupportContacts_ButtonInsert"
                                                                    name="TableChildControl_CustomSupportContacts_ButtonInsert" value="Add" runat="server"
                                                                    onclick="InsertCustomSupportContactsGridData();" />
                                                            </td>
                                                            <td style="width: 45%;">
                                                                <input class="more_detail_btn_120" type="button" id="Button_CustomSupportContacts_OpenContacts"
                                                                    name="Button_CustomSupportContacts_OpenContacts" value="Open Contacts" onclick="OpenContacts()" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="width: 100%" class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="width: 100%">
                                                    <div id="InsertGridSupportContacts" style="width: 98.5%;">
                                                        <uc1:CustomGrid ID="CustomGridSupportContacts" runat="server" TableName="CustomSupportContacts"
                                                            PrimaryKey="SupportContactId" ForeignKey="DocumentVersionId" CustomGridTableName="TableChildControl_CustomSupportContacts"
                                                            GridPageName="CustomSupportContacts" width="100%" ColumnName="Name:Relationship:Address:Phone"
                                                            ColumnHeader="Name:Relationship:Address:Phone" ColumnWidth="25%:25%:25%:25%"
                                                            ColumnFormat=":::" DivGridName="InsertGridSupportContacts" InsertButtonId="TableChildControl_CustomSupportContacts_ButtonInsert"
                                                            DoNotDisplayRadio="true" DoNotDisplayDeleteImage="False" />
                                                    </div>
                                                    <input type="hidden" id="HiddenField_CustomSupportContacts_SupportContactId" name="HiddenField_CustomSupportContacts_SupportContactId"
                                                        parentchildcontrols="True" />
                                                    <input type="hidden" id="HiddenFieldPrimaryKey" name="HiddenFieldPrimaryKey" value="SupportContactId"
                                                        parentchildcontrols="True" />
                                                    <input type="hidden" id="HiddenFieldForigenKey" name="HiddenFieldForigenKey" value="DocumentVersionId"
                                                        parentchildcontrols="True" />
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
                    <tr>
                        <td class="height2">
                        </td>
                    </tr>
                    <tr section="trSafetyReviewed" style="display: none">
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="content_tab_left" nowrap='nowrap'>
                                        Safety/Crisis Plan Reviewed On
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
                    <tr section="trSafetyReviewed" style="display: none">
                        <td class="content_tab_bg" style="padding-left: 10px">
                            <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                <tr>
                                    <td>
                                        <table id="TableChildControl_CustomSafetyCrisisPlanReviews" parentchildcontrols="True"
                                            cellpadding="0" cellspacing="0" border="0" width="100%">
                                            <tr>
                                                <td style="width: 100%">
                                                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                        <tr>
                                                            <td align="left" style="width: 2%">
                                                                <input type="radio" id="RadioButton_CustomSafetyCrisisPlanReviews_SafetyCrisisPlanReviewed_Y"
                                                                    value="Y" checked="checked" onclick="showCrisisDisposition(this);" name="RadioButton_CustomSafetyCrisisPlanReviews_SafetyCrisisPlanReviewed"
                                                                    style="cursor: default" bindautosaveevents="False" parentchildcontrols="True"
                                                                    bindsetformdata="False" />
                                                            </td>
                                                            <td align="left" style="width: 14%">
                                                                <label for="RadioButton_CustomSafetyCrisisPlanReviews_SafetyCrisisPlanReviewed_Y"
                                                                    style="cursor: default">
                                                                    Safety Plan Reviewed</label>
                                                            </td>
                                                            <td align="left" style="width: 2%;">
                                                                <input type="radio" id="RadioButton_CustomSafetyCrisisPlanReviews_SafetyCrisisPlanReviewed_N"
                                                                    value="N" onclick="showCrisisDisposition(this);" name="RadioButton_CustomSafetyCrisisPlanReviews_SafetyCrisisPlanReviewed"
                                                                    style="cursor: default" bindautosaveevents="False" parentchildcontrols="True"
                                                                    bindsetformdata="False" />
                                                            </td>
                                                            <td align="left" style="width: 82%;">
                                                                <label for="RadioButton_CustomSafetyCrisisPlanReviews_SafetyCrisisPlanReviewed_N"
                                                                    style="cursor: default">
                                                                    Crisis Plan Reviewed</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="width: 100%" class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="width: 100%">
                                                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                        <tr>
                                                            <td align="left" style="width: 10%">
                                                                <span id="SpanDateReviewed">Date Reviewed</span>
                                                            </td>
                                                            <td align="left" style="width: 17%">
                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                    <tr class="date_Container">
                                                                        <td>
                                                                            <input type="text" class="form_textbox" id="TextBox_CustomSafetyCrisisPlanReviews_DateReviewed"
                                                                                name="TextBox_CustomSafetyCrisisPlanReviews_DateReviewed" datatype="Date" bindautosaveevents="False"
                                                                                parentchildcontrols="True" bindsetformdata="False" />
                                                                        </td>
                                                                        <td>
                                                                            &nbsp;
                                                                        </td>
                                                                        <td>
                                                                            <img id="imgDynamicDate" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                                onclick="return showCalendar('TextBox_CustomSafetyCrisisPlanReviews_DateReviewed', '%m/%d/%Y');" />
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td align="left" style="width: 9%;">
                                                                <span id="SpanReviewEveryXDays">Review Every</span>
                                                            </td>
                                                            <td align="left" style="width: 5%;">
                                                                <input type="text" class="form_textbox" id="TextBox_CustomSafetyCrisisPlanReviews_ReviewEveryXDays"
                                                                    name="TextBox_CustomSafetyCrisisPlanReviews_ReviewEveryXDays" datatype="Numeric"
                                                                    maxlength="3" style="width: 70%" bindautosaveevents="False" parentchildcontrols="True"
                                                                    bindsetformdata="False" />
                                                                <input type="hidden" id="HiddenField_CustomSafetyCrisisPlanReviews_ReviewEveryDaysText"
                                                                    name="HiddenField_CustomSafetyCrisisPlanReviews_ReviewEveryDaysText" bindautosaveevents="False"
                                                                    parentchildcontrols="True" bindsetformdata="False" />
                                                            </td>
                                                            <td align="left" style="width: 5%;">
                                                                <span id="Span_Days">Days</span>
                                                            </td>
                                                            <td align="left">
                                                                <%=NextSafetyPlanReviewDate%>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="width: 100%" class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="left" style="width: 100%;">
                                                    <span id="SpanDescribePlanReview">Describe Plan Review</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="width: 100%" class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="left" style="width: 100%;">
                                                    <textarea class="form_textarea" id="TextArea_CustomSafetyCrisisPlanReviews_DescribePlanReview"
                                                        name="TextArea_CustomSafetyCrisisPlanReviews_DescribePlanReview" rows="3" cols="1"
                                                        style="width: 98%;" spellcheck="True" datatype="String" bindautosaveevents="False"
                                                        parentchildcontrols="True" bindsetformdata="False"></textarea>
                                                </td>
                                            </tr>
                                            <tr section="CrisisDisposition" style="display: none">
                                                <td style="width: 100%" class="height2">
                                                </td>
                                            </tr>
                                            <tr section="CrisisDisposition" style="display: none">
                                                <td>
                                                    <table cellpadding="0" cellspacing="0" border="0" width="50%">
                                                        <tr>
                                                            <td align="left">
                                                                <span id="SpanCrisisDisposition">Crisis Disposition</span>
                                                            </td>
                                                            <td align="left" style="width: 2%;">
                                                                <input type="checkbox" id="CheckBox_CustomSafetyCrisisPlanReviews_CrisisResolved"
                                                                    name="CheckBox_CustomSafetyCrisisPlanReviews_CrisisResolved" style="cursor: default"
                                                                    bindautosaveevents="False" parentchildcontrols="True" bindsetformdata="False" />
                                                            </td>
                                                            <td align="left" valign="middle" style="padding-left: 3px">
                                                                <label for="CheckBox_CustomSafetyCrisisPlanReviews_CrisisResolved" style="cursor: default">
                                                                    Crisis is Resolved</label>
                                                                <input type="hidden" id="HiddenField_CustomSafetyCrisisPlanReviews_CrisisResolvedText"
                                                                    parentchildcontrols="True" runat="server" name="HiddenField_CustomSafetyCrisisPlanReviews_CrisisResolvedText" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr section="CrisisDisposition" style="display: none">
                                                <td style="width: 100%" class="height2">
                                                </td>
                                            </tr>
                                            <tr section="CrisisDisposition" style="display: none">
                                                <td align="left" style="width: 100%;">
                                                    <textarea class="form_textarea" id="TextArea_CustomSafetyCrisisPlanReviews_CrisisDisposition"
                                                        name="TextArea_CustomSafetyCrisisPlanReviews_CrisisDisposition" rows="3" cols="1"
                                                        style="width: 98%;" spellcheck="True" datatype="String" bindautosaveevents="False"
                                                        parentchildcontrols="True" bindsetformdata="False"></textarea>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="width: 100%" class="height5">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="width: 100%">
                                                    <table cellpadding="0" cellspacing="0" border="0" width="98.5%">
                                                        <tr>
                                                            <td>
                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                        <td class="content_tab_left" nowrap='nowrap'>
                                                                            Safety/Crisis Plan Review
                                                                        </td>
                                                                        <td width="17">
                                                                            <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif"
                                                                                width="17" height="26" alt="" />
                                                                        </td>
                                                                        <td class="content_tab_top" width="100%">
                                                                            <table border="0" cellpadding="0" cellspacing="0" width="100%" style="margin-top: -15px">
                                                                                <tr>
                                                                                    <td valign="bottom" style="width: 25%; padding-left: 15px">
                                                                                        <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                                                            <tr>
                                                                                                <td align="left" style="width: 2%;">
                                                                                                    <input type="checkbox" id="CheckBox_CustomDocumentSafetyCrisisPlans_ThreeMonths"
                                                                                                        name="CheckBox_CustomDocumentSafetyCrisisPlans_ThreeMonths" style="cursor: default"
                                                                                                        onclick="safetyCrisisPlanReviewFilter(this, '3months');" />
                                                                                                </td>
                                                                                                <td align="left" valign="middle" style="width: 98%; padding-left: 3px">
                                                                                                    <label for="CheckBox_CustomDocumentSafetyCrisisPlans_ThreeMonths" style="cursor: default">
                                                                                                        Show Last 3 Months</label>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </td>
                                                                                    <td valign="bottom" style="width: 45%">
                                                                                        <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                                                            <tr>
                                                                                                <td align="left" style="width: 2%;">
                                                                                                    <input type="checkbox" id="CheckBox_CustomDocumentSafetyCrisisPlans_TwelveMonths"
                                                                                                        name="CheckBox_CustomDocumentSafetyCrisisPlans_TwelveMonths" style="cursor: default"
                                                                                                        onclick="safetyCrisisPlanReviewFilter(this, '12months');" />
                                                                                                </td>
                                                                                                <td align="left" valign="middle" style="width: 98%; padding-left: 3px">
                                                                                                    <label for="CheckBox_CustomDocumentSafetyCrisisPlans_TwelveMonths" style="cursor: default">
                                                                                                        Show Last 12 Months</label>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </td>
                                                                                    <td style="width: 15%; padding-left: 15px">
                                                                                        <input class="parentchildbutton" type="button" id="TableChildControl_CustomSafetyCrisisPlanReviews_ButtonInsert"
                                                                                            name="TableChildControl_CustomSafetyCrisisPlanReviews_ButtonInsert" baseurl="<%=ResolveUrl("~") %>"
                                                                                            value="Insert" onclick="CustomCustomSafetyCrisisPlanReviewsInsertGridData()" />&nbsp;
                                                                                    </td>
                                                                                    <td style="width: 15%">
                                                                                        <input class="parentchildbutton" type="button" id="ButtonClear" name="ButtonClear"
                                                                                            value="Clear" onclick="ClearTable('TableChildControl_CustomSafetyCrisisPlanReviews', 'TableChildControl_CustomSafetyCrisisPlanReviews_ButtonInsert', false);" />
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
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
                                                                <div id="DivCustomGridCustomSafetyCrisisPlanReviews" style="width: 98.5%;">
                                                                    <uc1:CustomGrid ID="CustomGridCustomSafetyCrisisPlanReviews" runat="server" TableName="CustomSafetyCrisisPlanReviews"
                                                                        PrimaryKey="SafetyCrisisPlanReviewId" ForeignKey="DocumentVersionId" CustomGridTableName="TableChildControl_CustomSafetyCrisisPlanReviews"
                                                                        GridPageName="CustomSafetyCrisisPlanReviews" width="100%" ColumnName="DateReviewed:ReviewEveryDaysText:DescribePlanReview:CrisisDisposition:CrisisResolvedText"
                                                                        ColumnHeader="Date Reviewed:Review Every X Days:Description of Plan Review:Crisis Disposition:Crisis Resolved"
                                                                        ColumnWidth="20%:20%:20%:25%:15%" ColumnFormat="Date::::" DivGridName="DivCustomGridCustomSafetyCrisisPlanReviews"
                                                                        InsertButtonId="TableChildControl_CustomSafetyCrisisPlanReviews_ButtonInsert" />
                                                                </div>
                                                                <input type="hidden" parentchildcontrols="True" id="HiddenField_CustomSafetyCrisisPlanReviews_SafetyCrisisPlanReviewId"
                                                                    name="HiddenField_CustomSafetyCrisisPlanReviews_SafetyCrisisPlanReviewId" includeinparentchildxml="True" />
                                                                <input type="hidden" parentchildcontrols="True" id="HiddenField_CustomSafetyCrisisPlanReviews_DocumentVersionId"
                                                                    name="HiddenField_CustomSafetyCrisisPlanReviews_DocumentVersionId" includeinparentchildxml="True" />
                                                                <input type="hidden" id="HiddenFieldPrimaryKeySafetyCrisisPlanReviewId" name="HiddenFieldPrimaryKeySafetyCrisisPlanReviewId"
                                                                    value="SafetyCrisisPlanReviewId" parentchildcontrols="True" />
                                                                <%--<input type="hidden" id="Hidden1" name="HiddenFieldForigenKey" value="DocumentVersionId"
                                                                    parentchildcontrols="True" />--%>
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
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr section="trSafetyReviewed" style="display: none">
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
    <asp:HiddenField runat="server" ID="HiddenFieldClientContactInformation" />
</div>
