<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Incident.ascx.cs" Inherits="Custom_IncidentReport_WebPages_Incident" %>
<%@ Register Assembly="Streamline.DotNetDropDowns" Namespace="Streamline.DotNetDropDowns"
    TagPrefix="cc3" %>
<% if (HttpContext.Current == null)
   { %>
<link href="../../../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet"
    type="text/css" />
<%} %>
<table cellpadding="0" cellspacing="0" class="DocumentScreen" width="820px">
    <tr>
        <td>
            <table border="0" cellpadding="0" cellspacing="0" width="99%">
                <tr>
                    <td class="height2"></td>
                </tr>
                <tr>
                    <td>
                        <table border="0" cellpadding="0" cellspacing="0" width="100%" style="margin-bottom: 20px;" id="GeneralTable">
                            <tr>
                                <td style="width: 100%;">
                                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                        <tr>
                                            <td>
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr>
                                                        <td class="content_tab_left" align="left" width="10%">
                                                            <span id="Span4">General</span>
                                                        </td>
                                                        <td width="17">
                                                            <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif"
                                                                width="17" height="26" alt="" />
                                                        </td>
                                                        <td class="content_tab_top" width="100%"></td>
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
                                    <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td style="width: 15%">
                                                <span id="SpanIndividual" class="form_label" name="SpanIndividual">Individual</span>
                                            </td>
                                            <td style="width: 20%">
                                                <span id="Span_CustomIncidentReports_Individual" class="form_label_text" name="Span_CustomIncidentReports_Individual"><%=SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.Client.ClientName%></span>
                                            </td>
                                            <td style="width: 15%">
                                                <span id="SpanDOB" class="form_label" name="SpanDOB">DOB</span>
                                            </td>
                                            <td style="width: 20%">
                                                <span id="Span_CustomIncidentReports_DOB" class="form_label_text" name="Span_CustomIncidentReports_DOB"></span>
                                            </td>
                                            <td style="width: 15%">
                                                <span id="SpanID" class="form_label" name="SpanID">ID</span>
                                            </td>
                                            <td style="width: 15%">
                                                <span id="Span_CustomIncidentReports_ClientId" class="form_label_text" name="Span_CustomIncidentReports_ClientId"><%=SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.Client.ClientId%></span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height2"></td>
                                        </tr>
                                        <tr>
                                            <td style="width: 15%">
                                                <span id="SpanProgram" class="form_label" name="SpanProgram">Program</span>
                                            </td>
                                            <td style="width: 20%">
                                                <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentReportGenerals_GeneralProgram" Width="157px"
                                                    name="DropDownList_CustomIncidentReportGenerals_GeneralProgram" runat="server" AddBlankRow="True"
                                                    BlankRowText="" valuetype="" OnChange="HideDropDown();">
                                                </cc3:StreamlineDropDowns>
                                            </td>
                                            <td style="width: 15%">
                                                <span id="SpanDateOfIncident" class="form_label" name="SpanDateOfIncident">Date of incident</span>
                                            </td>
                                            <td style="width: 20%">
                                                <input datatype="Date" type="text" id="TextBox_CustomIncidentReportGenerals_GeneralDateOfIncident"
                                                    name="TextBox_CustomIncidentReportGenerals_GeneralDateOfIncident" style="width: 67px; height: 15px; padding-right: 2px"
                                                    class="form_textbox" />

                                                <img id="imgDateOfIncident" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                    onclick="return showCalendar('TextBox_CustomIncidentReportGenerals_GeneralDateOfIncident', '%m/%d/%Y');" style="cursor: default; vertical-align: text-bottom;"
                                                    alt="Calendar" />
                                            </td>
                                            <td style="width: 15%">
                                                <span id="SpanGeneralTimeOfIncident" class="form_label" name="SpanGeneralTimeOfIncident">Time of incident</span>
                                            </td>
                                            <td style="width: 15%">
                                                <input type="text" name="TextBox_CustomIncidentReportGenerals_GeneralTimeOfIncident" id="TextBox_CustomIncidentReportGenerals_GeneralTimeOfIncident"
                                                    onblur="TimeNotified(this)" bindautosaveevents="False" datatype="Time" style="width: 61%" class='form_textbox' datatype="Time" />
                                                <%--<input type="text" name="TextBoxTime_CustomIncidentReportGenerals_GeneralDateOfIncident" id="TextBoxTime_CustomIncidentReportGenerals_GeneralDateOfIncident"
                                                    datatype="Time" style="width: 61%" class='form_textbox' />--%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height2"></td>
                                        </tr>
                                        <tr>
                                            <td style="width: 15%">
                                                <span id="SpanResidence" class="form_label" name="SpanResidence">Residence</span>
                                            </td>
                                            <td style="width: 20%">
                                                <input type="text" class="form_textarea" style="width: 150px;"  id="TextBox_CustomIncidentReportGenerals_GeneralResidence"
                                                    name="TextBox_CustomIncidentReportGenerals_GeneralResidence" />
                                            </td>
                                            <td style="width: 15%">
                                                <span id="SpanGeneralDateStaffNotified" class="form_label" name="SpanGeneralDateStaffNotified">Date staff notified</span>
                                            </td>
                                            <td style="width: 20%" class="checkbox_container">
                                                <input datatype="Date" type="text" id="TextBox_CustomIncidentReportGenerals_GeneralDateStaffNotified"
                                                    name="TextBox_CustomIncidentReportGenerals_GeneralDateStaffNotified" style="width: 67px; height: 15px; padding-right: 2px"
                                                    class="form_textbox" />

                                                <img id="imgGeneralDateStaffNotified" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                    onclick="return showCalendar('TextBox_CustomIncidentReportGenerals_GeneralDateStaffNotified', '%m/%d/%Y');" style="cursor: default; vertical-align: text-bottom;"
                                                    alt="Calendar" />
                                                <input type="checkbox" id="CheckBox_CustomIncidentReportGenerals_GeneralSame"
                                                    name="CheckBox_CustomIncidentReportGenerals_GeneralSame" onchange="SameDT();" />
                                                <label for="CheckBox_CustomIncidentReportGenerals_GeneralSame" class="form_label">
                                                    Same
                                                </label>
                                            </td>
                                            <td style="width: 15%">
                                                <span id="SpanGeneralTimeStaffNotified" class="form_label" name="SpanGeneralTimeStaffNotified">Time staff notified</span>
                                            </td>
                                            <td style="width: 15%">
                                                <input type="text" name="TextBox_CustomIncidentReportGenerals_GeneralTimeStaffNotified"
                                                    id="TextBox_CustomIncidentReportGenerals_GeneralTimeStaffNotified" onblur="TimeNotified(this)" bindautosaveevents="False" datatype="Time" style="width: 61%" class='form_textbox' />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height2"></td>
                                        </tr>
                                        <tr>
                                            <td style="width: 15%">
                                                <span id="SpanGeneralLocationOfIncident" class="form_label" name="SpanGeneralLocationOfIncident">Location of incident</span>
                                            </td>
                                            <td style="width: 20%">
                                                <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentReportGenerals_GeneralLocationOfIncident" Width="157px"
                                                    name="DropDownList_CustomIncidentReportGenerals_GeneralLocationOfIncident" runat="server" AddBlankRow="True"
                                                    BlankRowText="" valuetype="">
                                                </cc3:StreamlineDropDowns>
                                            </td>
                                            <td style="width: 15%">
                                                <span id="SpanGeneralLocationDetails" class="form_label" name="SpanGeneralLocationDetails">Location details</span>
                                            </td>
                                            <td colspan="3">
                                                <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentReportGenerals_GeneralLocationDetails" Width="157px"
                                                    name="DropDownList_CustomIncidentReportGenerals_GeneralLocationDetails" runat="server" AddBlankRow="True"
                                                    BlankRowText="" valuetype="" onchange="ShowHideTextBox();" OnDataBound="LocationDetailCode">
                                                </cc3:StreamlineDropDowns>
                                                <input type="text" name="TextBox_CustomIncidentReportGenerals_GeneralLocationDetailsText" id="TextBox_CustomIncidentReportGenerals_GeneralLocationDetailsText"
                                                    style="width: 201px; display: none;" class='form_textbox' />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height2"></td>
                                        </tr>
                                        <tr>
                                            <td style="width: 15%">
                                                <span id="SpanIncidentCategory" class="form_label" name="SpanIncidentCategory">Incident Category</span>
                                            </td>
                                            <td style="width: 20%">
                                                <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentReportGenerals_GeneralIncidentCategory" Width="157px"
                                                    name="DropDownList_CustomIncidentReportGenerals_GeneralIncidentCategory" runat="server" AddBlankRow="True"
                                                    BlankRowText="" valuetype="" onchange="SetTabsIncidentCategory();" OnDataBound="GeneralIncidentCategoryCode">
                                                </cc3:StreamlineDropDowns>
                                            </td>
                                            <td style="width: 15%">
                                                <span id="SpanSecondaryCategory" class="form_label" name="SpanSecondaryCategory">Secondary Category</span>
                                            </td>
                                            <td style="width: 20%">
                                                <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentReportGenerals_GeneralSecondaryCategory" Width="157px"
                                                    name="DropDownList_CustomIncidentReportGenerals_GeneralSecondaryCategory" runat="server" AddBlankRow="True"
                                                    BlankRowText="" valuetype="" onchange="SetTabsSecondaryCategory();" OnDataBound="GeneralSecondCategoryCode">
                                                </cc3:StreamlineDropDowns>
                                            </td>
                                            <td colspan="2"></td>
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
                                            <td class="right_bottom_cont_bottom_bg" width="100%"></td>
                                            <td width="2" class="right_bottom_cont_bottom_bg" align="right">
                                                <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif"
                                                    height="7" alt="" />
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td class="content_tab_bg"></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="height2"></td>
                </tr>
                <tr>
                    <td>
                        <table border="0" cellpadding="0" cellspacing="0" width="100%" style="margin-bottom: 20px;" id="IncidentReportTable">
                            <tr>
                                <td>
                                    <table border="0" cellpadding="0" cellspacing="0" width="100%" style="margin-bottom: 20px;" id="DetailsTable">
                                        <tr>
                                            <td style="width: 100%;">
                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                    <tr>
                                                        <td>
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr>
                                                                    <td class="content_tab_left" align="left" width="10%">
                                                                        <span id="SpanDetails">Details</span>
                                                                    </td>
                                                                    <td width="17">
                                                                        <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif"
                                                                            width="17" height="26" alt="" />
                                                                    </td>
                                                                    <td class="content_tab_top" width="100%"></td>
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
                                            <td valign="top" class="content_tab_bg_padding" align="left">
                                                <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                    <tr>
                                                        <td>Description of incident (List all individuals and staff involved, what happened before if applicable, what occurred after the incident if applicable)
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <textarea id="TextBox_CustomIncidentReportDetails_DetailsDescriptionOfincident" class="form_textareaWithoutWidth"
                                                                name="TextBox_CustomIncidentReportDetails_DetailsDescriptionOfincident" rows="4" cols="158" spellcheck="True"></textarea>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td>Actions taken by staff
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <textarea id="TextBox_CustomIncidentReportDetails_DetailsActionsTakenByStaff" class="form_textareaWithoutWidth"
                                                                name="TextBox_CustomIncidentReportDetails_DetailsActionsTakenByStaff" rows="4" cols="158" spellcheck="True"></textarea>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td>Witnesses
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <textarea id="TextBox_CustomIncidentReportDetails_DetailsWitnesses" class="form_textareaWithoutWidth"
                                                                name="TextBox_CustomIncidentReportDetails_DetailsWitnesses" rows="4" cols="158" spellcheck="True"></textarea>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <span id="SpanDetailsStaffNotifiedForInjury" class="form_label" name="SpanDetailsStaffNotifiedForInjury" style="padding-right: 20px;">Staff notified for injury</span>
                                                            <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentReportDetails_DetailsStaffNotifiedForInjury" Width="157px"
                                                                name="DropDownList_CustomIncidentReportDetails_DetailsStaffNotifiedForInjury" runat="server" AddBlankRow="True"
                                                                BlankRowText="" valuetype="">
                                                            </cc3:StreamlineDropDowns>
                                                            <span id="SpanDetailsDateStaffNotified" class="form_label" name="SpanDetailsDateStaffNotified" style="padding-left: 70px;">Date Staff Notified</span>
                                                            <input datatype="Date" type="text" id="TextBox_CustomIncidentReportDetails_DetailsDateStaffNotified"
                                                                name="TextBox_CustomIncidentReportDetails_DetailsDateStaffNotified" style="width: 67px; height: 15px; padding-right: 2px"
                                                                class="form_textbox" />
                                                            <img id="imgDetailsDateStaffNotified" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                onclick="return showCalendar('TextBox_CustomIncidentReportDetails_DetailsDateStaffNotified', '%m/%d/%Y');" style="cursor: default; vertical-align: text-bottom;"
                                                                alt="Calendar" />
                                                            <span id="SpanDetailsTimestaffNotified" class="form_label" name="SpanDetailsTimestaffNotified" style="padding-left: 66px;">Time staff Notified</span>
                                                            <input type="text" name="TextBox_CustomIncidentReportDetails_DetailsTimestaffNotified" id="TextBox_CustomIncidentReportDetails_DetailsTimestaffNotified"
                                                                onblur="TimeNotified(this)" bindautosaveevents="False" datatype="Time" style="width: 67px" class='form_textbox' />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td class="checkbox_container">
                                                            <input type="checkbox" id="CheckBox_CustomIncidentReportDetails_DetailsNoMedicalStaffNotified"
                                                                name="CheckBox_CustomIncidentReportDetails_DetailsNoMedicalStaffNotified" />
                                                            <label for="CheckBox_CustomIncidentReportDetails_DetailsNoMedicalStaffNotified" style="cursor: default; padding-right: 80px;">No medical staff notified</label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <span id="Span1" class="form_label" name="SpanDetailsStaffNotifiedForInjury" style="padding-right: 8px;">Supervisor to be Flagged</span>
                                                            <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentReportDetails_DetailsSupervisorFlaggedId" Width="157px"
                                                                name="DropDownList_CustomIncidentReportDetails_DetailsSupervisorFlaggedId" runat="server" AddBlankRow="True"
                                                                BlankRowText="" valuetype="">
                                                            </cc3:StreamlineDropDowns>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td><span id="Span2" class="form_label" name="SpanDetailsStaffNotifiedForInjury" style="padding-right: 20px;">for Review</span>

                                                        </td>
                                                    </tr>
                                                     <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr>
                                                                    <td width="15%">
                                                                        <input type="button" id="ButtonDetailsSign" name="ButtonDetailsSign" value="Sign" onclick="DetailsSignDocument('Details');" class="less_detail_btn_new" />
                                                                    </td>
                                                                    <td width="8%">
                                                                        <span id="SpanSignedBy" class="form_label" name="SpanSignedBy">Signed By:</span>
                                                                    </td>
                                                                    <td width="50%">
                                                                        <span id="Span_SignedBy" class="form_label_text" name="Span_SignedBy"></span>
                                                                    </td>
                                                                    <td width="10%">
                                                                        <span id="SpanDateSigned" class="form_label" name="SpanDateSigned">Date Signed:</span>
                                                                    </td>
                                                                    <td width="22%">
                                                                        <span id="Span_DateSigned" class="form_label_text" name="Span_DateSigned"></span>
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
                                                        <td class="right_bottom_cont_bottom_bg" width="100%"></td>
                                                        <td width="2" class="right_bottom_cont_bottom_bg" align="right">
                                                            <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif"
                                                                height="7" alt="" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="content_tab_bg"></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2"></td>
                            </tr>
                            <tr>
                                <td>
                                    <table border="0" cellpadding="0" cellspacing="0" width="100%" style="margin-bottom: 20px;" id="IncidentFollowUPTable">
                                        <tr>
                                            <td style="width: 100%;">
                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                    <tr>
                                                        <td class="content_tab_left" align="left" nowrap='nowrap'>Follow Up of Individual Status
                                                        </td>
                                                        <td width="17">
                                                            <img style="vertical-align: top;" height="26" width="17" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                                                        </td>
                                                        <td class="content_tab_top" width="100%"></td>
                                                        <td width="7">
                                                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td valign="top" class="content_tab_bg_padding" align="left">
                                                <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                    <tr>
                                                        <td>
                                                            <span id="SpanNurseStaffEvaluating" name="SpanNurseStaffEvaluating" style="padding-right: 10px;">Nurse/staff evaluating</span>
                                                            <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentReportFollowUpOfIndividualStatuses_FollowUpIndividualStatusNurseStaffEvaluating" Width="157px"
                                                                name="DropDownList_CustomIncidentReportFollowUpOfIndividualStatuses_FollowUpIndividualStatusNurseStaffEvaluating" runat="server" AddBlankRow="True"
                                                                BlankRowText="" valuetype="" onchange="GetSuffix(this);">
                                                            </cc3:StreamlineDropDowns>
                                                            <span id="SpanCredentialTitle" name="SpanCredentialTitle" style="padding-left: 222px; padding-right: 10px;">Credential/title</span>
                                                            <input type="text" name="TextBoxTime_CustomIncidentReportFollowUpOfIndividualStatuses_FollowUpIndividualStatusCredentialTitle" id="TextBoxTime_CustomIncidentReportFollowUpOfIndividualStatuses_FollowUpIndividualStatusCredentialTitle"
                                                                style="width: 201px;" class='form_textbox' />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td>Details of injury/illness and treatment provided
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <textarea id="TextBox_CustomIncidentReportFollowUpOfIndividualStatuses_FollowUpIndividualStatusDetailsOfInjury" class="form_textareaWithoutWidth"
                                                                name="TextBox_CustomIncidentReportFollowUpOfIndividualStatuses_FollowUpIndividualStatusDetailsOfInjury" rows="4" cols="158" spellcheck="True"></textarea>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td>Comments
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <textarea id="TextBox_CustomIncidentReportFollowUpOfIndividualStatuses_FollowUpIndividualStatusComments" class="form_textareaWithoutWidth"
                                                                name="TextBox_CustomIncidentReportFollowUpOfIndividualStatuses_FollowUpIndividualStatusComments" rows="4" cols="158" spellcheck="True"></textarea>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td class="checkbox_container">
                                                            <span id="Span16" class="form_label" name="SpanIndividual" style="padding-right: 20px;">Family/Guardian/Custodian notified?</span>

                                                            <input type="radio" id="RadioButton_CustomIncidentReportFollowUpOfIndividualStatuses_FollowUpIndividualStatusFamilyGuardianCustodianNotified_Y" value="Y"
                                                                name="RadioButton_CustomIncidentReportFollowUpOfIndividualStatuses_FollowUpIndividualStatusFamilyGuardianCustodianNotified" style="cursor: default" />
                                                            <label for="RadioButton_CustomIncidentReportFollowUpOfIndividualStatuses_FollowUpIndividualStatusFamilyGuardianCustodianNotified_Y" style="cursor: default; padding-right: 5px;">
                                                                Yes</label>
                                                            <input type="radio" id="RadioButton_CustomIncidentReportFollowUpOfIndividualStatuses_FollowUpIndividualStatusFamilyGuardianCustodianNotified_N" value="N"
                                                                name="RadioButton_CustomIncidentReportFollowUpOfIndividualStatuses_FollowUpIndividualStatusFamilyGuardianCustodianNotified" style="cursor: default" />
                                                            <label for="RadioButton_CustomIncidentReportFollowUpOfIndividualStatuses_FollowUpIndividualStatusFamilyGuardianCustodianNotified_N" style="cursor: default">
                                                                No</label>

                                                            <span id="SpanFollowUpIndividualStatusDateOfNotification" class="form_label" name="SpanFollowUpIndividualStatusDateOfNotification" style="padding-left: 71px;">Date of notification</span>
                                                            <input datatype="Date" type="text" id="TextBox_CustomIncidentReportFollowUpOfIndividualStatuses_FollowUpIndividualStatusDateOfNotification"
                                                                name="TextBox_CustomIncidentReportFollowUpOfIndividualStatuses_FollowUpIndividualStatusDateOfNotification" style="width: 67px; height: 15px; padding-right: 2px"
                                                                class="form_textbox" />
                                                            <img id="img3" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                onclick="return showCalendar('TextBox_CustomIncidentReportFollowUpOfIndividualStatuses_FollowUpIndividualStatusDateOfNotification', '%m/%d/%Y');" style="cursor: default; vertical-align: text-bottom;"
                                                                alt="Calendar" />
                                                            <span id="SpanFollowUpIndividualStatusTimeOfNotification" class="form_label" name="SpanFollowUpIndividualStatusTimeOfNotification" style="padding-left: 70px;">Time of Notification</span>
                                                            <input type="text" name="TextBox_CustomIncidentReportFollowUpOfIndividualStatuses_FollowUpIndividualStatusTimeOfNotification" id="TextBox_CustomIncidentReportFollowUpOfIndividualStatuses_FollowUpIndividualStatusTimeOfNotification"
                                                                onblur="TimeNotified(this)" bindautosaveevents="False" datatype="Time" style="width: 67px" class='form_textbox' />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <span id="SpanFollowUpIndividualStatusStaffCompletedNotification" class="form_label" name="SpanFollowUpIndividualStatusStaffCompletedNotification" style="padding-right: 10px;">Staff who completed Notification</span>
                                                            <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentReportFollowUpOfIndividualStatuses_FollowUpIndividualStatusStaffCompletedNotification" Width="150px"
                                                                name="DropDownList_CustomIncidentReportFollowUpOfIndividualStatuses_FollowUpIndividualStatusStaffCompletedNotification" runat="server" AddBlankRow="True"
                                                                BlankRowText="" valuetype="">
                                                            </cc3:StreamlineDropDowns>
                                                            <%-- <input type="text" class="form_textarea" style="width: 150px;"  id="TextBox_CustomIncidentReportFollowUpOfIndividualStatuses_FollowUpIndividualStatusStaffCompletedNotification"
                                                                name="TextBox_CustomIncidentReportFollowUpOfIndividualStatuses_FollowUpIndividualStatusStaffCompletedNotification" />--%>
                                                            <span id="SpanFollowUpIndividualStatusNameOfFamilyGuardianCustodian" class="form_label" name="SpanFollowUpIndividualStatusNameOfFamilyGuardianCustodian" style="padding-left: 66px; padding-right: 11px;">Name of the family/guardian/custodian notified</span>
                                                            <input type="text" class="form_textarea" style="width: 150px;"  id="TextBox_CustomIncidentReportFollowUpOfIndividualStatuses_FollowUpIndividualStatusNameOfFamilyGuardianCustodian"
                                                                name="TextBox_CustomIncidentReportFollowUpOfIndividualStatuses_FollowUpIndividualStatusNameOfFamilyGuardianCustodian" />
                                                        </td>
                                                    </tr>
                                                     <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <div>
                                                                <table  width="99%" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                           <td width="40%"  style="padding-left: 117px;">
                                                                            <span id="Span_CustomIncidentReportFollowUpOfIndividualStatusesNoteType" class="form_label" name="SpanID" style="padding-right:2px">Note Type</span>
                                                                            
                                                                            <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentReportFollowUpOfIndividualStatuses_NoteType" Width="149px"
                                                                                name="DropDownList_CustomIncidentReportFollowUpOfIndividualStatuses_NoteType" runat="server" AddBlankRow="True"
                                                                                BlankRowText="" valuetype="">
                                                                            </cc3:StreamlineDropDowns>
                                                                            </td>
                                                                           <td width="30%">
                                                                               <span id="SpanFollowUpIndividualStatusNoteStart" class="form_label" name="SpanFollowUpIndividualStatusNoteStart" style="padding-left: 71px;">Note Start</span>
                                                                                <input datatype="Date" type="text" id="TextBox_CustomIncidentReportFollowUpOfIndividualStatuses_NoteStart"
                                                                                    name="TextBox_CustomIncidentReportFollowUpOfIndividualStatuses_NoteStart" style="width: 67px; height: 15px; padding-right: 2px"
                                                                                    class="form_textbox" />
                                                                                <img id="img_CustomIncidentReportFollowUpOfIndividualStatusesNoteStart" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                                    onclick="return showCalendar('TextBox_CustomIncidentReportFollowUpOfIndividualStatuses_NoteStart', '%m/%d/%Y');" style="cursor: default; vertical-align: text-bottom;"
                                                                                    alt="Calendar" />
                                                                         </td>
                                                                        <td width="30%">
                                                                               <span id="SpanFollowUpIndividualStatusNoteEnd" class="form_label" name="SpanFollowUpIndividualStatusNoteEnd" style="padding-left: 71px;">Note End</span>
                                                                                <input datatype="Date" type="text" id="TextBox_CustomIncidentReportFollowUpOfIndividualStatuses_NoteEnd"
                                                                                    name="TextBox_CustomIncidentReportFollowUpOfIndividualStatuses_NoteEnd" style="width: 67px; height: 15px; padding-right: 2px"
                                                                                    class="form_textbox" />
                                                                                <img id="img1" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                                    onclick="return showCalendar('TextBox_CustomIncidentReportFollowUpOfIndividualStatuses_NoteEnd', '%m/%d/%Y');" style="cursor: default; vertical-align: text-bottom;"
                                                                                    alt="Calendar" />
                                                                         </td>
                                                                    </tr>
                                                                    
                                                                     <tr>
                                                                        <td class="height2"  colspan="3"></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="3">
                                                                        <span id="Span_NoteComment" class="form_label" name="SpanFollowUpIndividualStatusNameOfFamilyGuardianCustodian" style="padding-left: 2px; padding-right: 11px;">Note Comment</span>
                                                                        <input type="text" class="form_textarea" style="width: 660px;" id="TextBox_CustomIncidentReportFollowUpOfIndividualStatuses_NoteComment"
                                                                name="TextBox_CustomIncidentReportFollowUpOfIndividualStatuses_NoteComment" />
                                                                       </td>
                                                                    </tr>
                                                                </table>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td>Details of Notification 
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <textarea id="TextBox_CustomIncidentReportFollowUpOfIndividualStatuses_FollowUpIndividualStatusDetailsOfNotification" class="form_textareaWithoutWidth"
                                                                name="TextBox_CustomIncidentReportFollowUpOfIndividualStatuses_FollowUpIndividualStatusDetailsOfNotification" rows="4" cols="158" spellcheck="True"></textarea>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr>
                                                                    <td width="15%">
                                                                        <input type="button" id="ButtonFollowUpIndividualStatusSign" name="ButtonFollowUpIndividualStatusSign" value="Sign" onclick="DetailsSignDocument('IndividualStatus');" class="less_detail_btn_new" />
                                                                    </td>
                                                                    <td width="8%">
                                                                        <span id="Span19" class="form_label" name="SpanSignedBy">Signed By:</span>
                                                                    </td>
                                                                    <td width="50%">
                                                                        <span id="Span_SignedByIndividualStatus" class="form_label_text" name="Span_SignedBy"></span>
                                                                    </td>
                                                                    <td width="10%">
                                                                        <span id="Span21" class="form_label" name="SpanDateSigned">Date Signed:</span>
                                                                    </td>
                                                                    <td width="22%">
                                                                        <span id="Span_DateSignedIndividualStatus" class="form_label_text" name="Span_DateSigned"></span>
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
                                                        <td class="right_bottom_cont_bottom_bg" width="100%"></td>
                                                        <td width="2" class="right_bottom_cont_bottom_bg" align="right">
                                                            <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif"
                                                                height="7" alt="" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="content_tab_bg"></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2"></td>
                            </tr>
                            <tr>
                                <td>
                                    <table border="0" cellpadding="0" cellspacing="0" width="100%" style="margin-bottom: 20px;" id="SupervisorFollowUpTable">
                                        <tr>
                                            <td style="width: 100%;">
                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                    <tr>
                                                        <td class="content_tab_left" align="left" nowrap='nowrap'>Supervisor Follow Up
                                                        </td>
                                                        <td width="17">
                                                            <img style="vertical-align: top;" height="26" width="17" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                                                        </td>
                                                        <td class="content_tab_top" width="100%"></td>
                                                        <td width="7">
                                                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td valign="top" class="content_tab_bg_padding" align="left">
                                                <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                    <tr>
                                                        <td>
                                                            <span id="SupervisorFollowUpSupervisorName" name="SupervisorFollowUpSupervisorName" style="padding-right: 20px;">Supervisor name</span>
                                                            <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpSupervisorName" Width="157px"
                                                                name="DropDownList_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpSupervisorName" runat="server" AddBlankRow="True"
                                                                BlankRowText="" valuetype="">
                                                            </cc3:StreamlineDropDowns>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td>Follow up
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <textarea id="TextBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpFollowUp" class="form_textareaWithoutWidth"
                                                                name="TextBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpFollowUp" rows="4" cols="158" spellcheck="True"></textarea>
                                                        </td>
                                                    </tr>
                                                      <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td class="checkbox_container">
                                                            <span id="Span3" class="form_label" name="SpanSupervisorFollowAdministratorNotified" style="padding-right: 22px;">Manager Notified</span>
                                                            <input type="radio" id="RadioButton_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpManagerNotified_Y" value="Y"
                                                                name="RadioButton_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpManagerNotified" onchange="SameManagerDT()" style="cursor: default"  />
                                                            <label for="RadioButton_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpManagerNotified_Y" style="cursor: default; padding-right: 5px;">
                                                                Yes</label>
                                                            <input type="radio" id="RadioButton_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpManagerNotified_N" value="N"
                                                                name="RadioButton_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpManagerNotified" onchange="SameManagerDT()" style="cursor: default" />
                                                            <label for="RadioButton_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpManagerNotified_N" style="cursor: default">
                                                                No</label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <span id="Span5" name="SpanSupervisorFollowAdministrator" style="padding-right: 63px; padding-left: 3px;">Manager</span>
                                                            <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpManager" Width="157px"
                                                                name="DropDownList_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpManager" runat="server" AddBlankRow="True"
                                                                BlankRowText="" valuetype="">
                                                            </cc3:StreamlineDropDowns>
                                                            <span id="Span6" class="form_label" name="SpanSupervisorFollowAdminDateOfNotification" style="padding-left: 80px;">Date of notification</span>
                                                            <input datatype="Date" type="text" id="TextBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpManagerDateOfNotification"
                                                                name="TextBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpManagerDateOfNotification" style="width: 67px; height: 15px; padding-right: 2px"
                                                                class="form_textbox" />
                                                            <img id="img2" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                onclick="return showCalendar('TextBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpManagerDateOfNotification', '%m/%d/%Y');" style="cursor: default; vertical-align: text-bottom;"
                                                                alt="Calendar" />
                                                            <span id="Span7" class="form_label" name="SpanSupervisorFollowAdminTimeOfNotification" style="padding-left: 70px;">Time of Notification</span>
                                                            <input type="text" name="TextBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpManagerTimeOfNotification"
                                                                id="TextBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpManagerTimeOfNotification"
                                                                onblur="TimeNotified(this)" bindautosaveevents="False" datatype="Time" style="width: 67px" class='form_textbox' />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td class="checkbox_container">
                                                            <span id="SpanSupervisorFollowAdministratorNotified" class="form_label" name="SpanSupervisorFollowAdministratorNotified" style="padding-right: 20px;">Administrator notified</span>
                                                            <input type="radio" id="RadioButton_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpAdministratorNotified_Y" value="Y"
                                                                name="RadioButton_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpAdministratorNotified" style="cursor: default" onchange="IncidentSectionsShowHide();" />
                                                            <label for="RadioButton_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpAdministratorNotified_Y" style="cursor: default; padding-right: 5px;">
                                                                Yes</label>
                                                            <input type="radio" id="RadioButton_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpAdministratorNotified_N" value="N"
                                                                name="RadioButton_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpAdministratorNotified" style="cursor: default" onchange="IncidentSectionsShowHide();" />
                                                            <label for="RadioButton_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpAdministratorNotified_N" style="cursor: default">
                                                                No</label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <span id="SpanSupervisorFollowAdministrator" name="SpanSupervisorFollowAdministrator" style="padding-right: 40px; padding-left: 3px;">Administrator</span>
                                                            <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpAdministrator" Width="157px"
                                                                name="DropDownList_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpAdministrator" runat="server" AddBlankRow="True"
                                                                BlankRowText="" valuetype="">
                                                            </cc3:StreamlineDropDowns>
                                                            <span id="SpanSupervisorFollowAdminDateOfNotification" class="form_label" name="SpanSupervisorFollowAdminDateOfNotification" style="padding-left: 80px;">Date of notification</span>
                                                            <input datatype="Date" type="text" id="TextBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpAdminDateOfNotification"
                                                                name="TextBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpAdminDateOfNotification" style="width: 67px; height: 15px; padding-right: 2px"
                                                                class="form_textbox" />
                                                            <img id="img4" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                onclick="return showCalendar('TextBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpAdminDateOfNotification', '%m/%d/%Y');" style="cursor: default; vertical-align: text-bottom;"
                                                                alt="Calendar" />
                                                            <span id="SpanSupervisorFollowAdminTimeOfNotification" class="form_label" name="SpanSupervisorFollowAdminTimeOfNotification" style="padding-left: 70px;">Time of Notification</span>
                                                            <input type="text" name="TextBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpAdminTimeOfNotification"
                                                                id="TextBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpAdminTimeOfNotification"
                                                                onblur="TimeNotified(this)" bindautosaveevents="False" datatype="Time" style="width: 67px" class='form_textbox' />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td class="checkbox_container">
                                                            <span id="SpanSupervisorFollowFamilyGuardianCustodianNotified" class="form_label" name="SpanSupervisorFollowFamilyGuardianCustodianNotified" style="padding-right: 20px;">Family/Guardian/Custodian notified?</span>

                                                            <input type="radio" id="RadioButton_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpFamilyGuardianCustodianNotified_Y" value="Y"
                                                                name="RadioButton_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpFamilyGuardianCustodianNotified" style="cursor: default" />
                                                            <label for="RadioButton_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpFamilyGuardianCustodianNotified" style="cursor: default; padding-right: 5px;">
                                                                Yes</label>
                                                            <input type="radio" id="RadioButton_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpFamilyGuardianCustodianNotified_N" value="N"
                                                                name="RadioButton_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpFamilyGuardianCustodianNotified" style="cursor: default" />
                                                            <label for="RadioButton_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpFamilyGuardianCustodianNotified" style="cursor: default">
                                                                No</label>

                                                            <span id="SpanSupervisorFollowFGCDateOfNotification" class="form_label" name="SpanSupervisorFollowFGCDateOfNotification" style="padding-left: 71px;">Date of notification</span>
                                                            <input datatype="Date" type="text" id="TextBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpFGCDateOfNotification"
                                                                name="TextBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpFGCDateOfNotification" style="width: 67px; height: 15px; padding-right: 2px"
                                                                class="form_textbox" />
                                                            <img id="img5" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                onclick="return showCalendar('TextBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpFGCDateOfNotification', '%m/%d/%Y');" style="cursor: default; vertical-align: text-bottom;"
                                                                alt="Calendar" />
                                                            <span id="SpanSupervisorFollowFGCTimeOfNotification" class="form_label" name="SpanSupervisorFollowFGCTimeOfNotification" style="padding-left: 70px;">Time of Notification</span>
                                                            <input type="text" name="TextBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpFGCTimeOfNotification" id="TextBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpFGCTimeOfNotification"
                                                                onblur="TimeNotified(this)" bindautosaveevents="False" style="width: 67px" class='form_textbox' datatype="Time" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <span id="SpanSupervisorFollowStaffCompletedNotification" class="form_label" name="SpanSupervisorFollowStaffCompletedNotification" style="padding-right: 10px;">Staff who completed Notification</span>
                                                            <%--<input type="text" class="form_textarea" style="width: 150px;"  id="TextBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpStaffCompletedNotification"
                                                                name="TextBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpStaffCompletedNotification" />--%>
                                                            <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpStaffCompletedNotification" Width="150px"
                                                                name="DropDownList_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpStaffCompletedNotification" runat="server" AddBlankRow="True"
                                                                BlankRowText="" valuetype="">
                                                            </cc3:StreamlineDropDowns>
                                                            <span id="SpanSupervisorFollowNameOfFamilyGuardianCustodian" class="form_label" name="SpanSupervisorFollowNameOfFamilyGuardianCustodian" style="padding-left: 66px; padding-right: 11px;">Name of the family/guardian/custodian notified</span>
                                                            <input type="text" class="form_textarea" style="width: 150px;"  id="TextBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpNameOfFamilyGuardianCustodian"
                                                                name="TextBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpNameOfFamilyGuardianCustodian" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                        <tr>
                                                            <td>Details of Notification </td>
                                                        </tr>
                                                    <tr>
                                                        <td>
                                                            <textarea id="TextBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpDetailsOfNotification" class="form_textareaWithoutWidth" cols="158" name="TextBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpDetailsOfNotification" rows="4" spellcheck="True"></textarea>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>Type of Incident </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td class="checkbox_container">
                                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                <tr>
                                                                    <td width="25%">
                                                                        <input type="checkbox" id="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpAggressionPhysical"
                                                                            name="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpAggressionPhysical" />
                                                                        <label class="form_label" for="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpAggressionPhysical">
                                                                            Aggression - Physical
                                                                        </label>
                                                                    </td>
                                                                    <td width="20%">
                                                                        <input type="checkbox" id="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpAggressionVerbal"
                                                                            name="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpAggressionVerbal" />
                                                                        <label class="form_label" for="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpAggressionVerbal">
                                                                            Aggression-Verbal
                                                                        </label>
                                                                    </td>
                                                                    <td colspan="3">
                                                                        <input type="checkbox" id="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpBehavioralRestraint"
                                                                            name="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpBehavioralRestraint" />
                                                                        <label class="form_label" for="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpBehavioralRestraint">
                                                                            Behavioral/restraint report needed
                                                                        </label>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="height2"></td>
                                                                </tr>
                                                                <tr>
                                                                    <td width="25%">
                                                                        <input type="checkbox" id="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpElopementOffCampus"
                                                                            name="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpElopementOffCampus" />
                                                                        <label class="form_label" for="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpElopementOffCampus">
                                                                            Elopement off campus
                                                                        </label>
                                                                    </td>
                                                                    <td width="20%">
                                                                        <input type="checkbox" id="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpElopementOnCampus"
                                                                            name="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpElopementOnCampus" />
                                                                        <label class="form_label" for="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpElopementOnCampus">
                                                                            Elopement on campus
                                                                        </label>
                                                                    </td>
                                                                    <td colspan="3"></td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="height2"></td>
                                                                </tr>
                                                                <tr>
                                                                    <td width="25%">
                                                                        <input type="checkbox" id="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpContraband"
                                                                            name="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpContraband" />
                                                                        <label class="form_label" for="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpContraband">
                                                                            Contraband
                                                                        </label>
                                                                    </td>
                                                                    <td width="20%">
                                                                        <input type="checkbox" id="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpPropertyDamage"
                                                                            name="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpPropertyDamage" />
                                                                        <label class="form_label" for="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpPropertyDamage">
                                                                            Property damage
                                                                        </label>
                                                                    </td>
                                                                    <td width="20%">
                                                                        <input type="checkbox" id="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpPropertyDestruction"
                                                                            name="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpPropertyDestruction" />
                                                                        <label class="form_label" for="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpPropertyDestruction">
                                                                            Property destruction
                                                                        </label>
                                                                    </td>
                                                                    <td width="18%">
                                                                        <input type="checkbox" id="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpSearchSeizure"
                                                                            name="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpSearchSeizure" />
                                                                        <label class="form_label" for="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpSearchSeizure">
                                                                            Search/seizure
                                                                        </label>
                                                                    </td>
                                                                    <td width="17%"></td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="height2"></td>
                                                                </tr>
                                                                <tr>
                                                                    <td width="25%">
                                                                        <input type="checkbox" id="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpSelfInjury"
                                                                            name="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpSelfInjury" />
                                                                        <label class="form_label" for="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpSelfInjury">
                                                                            Self-injury
                                                                        </label>
                                                                    </td>
                                                                    <td width="20%">
                                                                        <input type="checkbox" id="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpSuicideAttempt"
                                                                            name="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpSuicideAttempt" />
                                                                        <label class="form_label" for="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpSuicideAttempt">
                                                                            Suicide attempt
                                                                        </label>
                                                                    </td>
                                                                    <td width="20%">
                                                                        <input type="checkbox" id="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpSuicideThreatGesture"
                                                                            name="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpSuicideThreatGesture" />
                                                                        <label class="form_label" for="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpSuicideThreatGesture">
                                                                            Suicide threat/gesture
                                                                        </label>
                                                                    </td>
                                                                    <td colspan="2"></td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="height2"></td>
                                                                </tr>
                                                                <tr>
                                                                    <td width="25%">
                                                                        <input type="checkbox" id="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpOutbreakOfDisease"
                                                                            name="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpOutbreakOfDisease" />
                                                                        <label class="form_label" for="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpOutbreakOfDisease">
                                                                            Outbreak of disease
                                                                        </label>
                                                                    </td>
                                                                    <td width="20%">
                                                                        <input type="checkbox" id="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpIllness"
                                                                            name="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpIllness" />
                                                                        <label class="form_label" for="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpIllness">
                                                                            Illness
                                                                        </label>
                                                                    </td>
                                                                    <td colspan="3"></td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="height2"></td>
                                                                </tr>
                                                                <tr>
                                                                    <td width="25%">
                                                                        <input type="checkbox" id="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpHospitalizationMedical"
                                                                            name="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpHospitalizationMedical" />
                                                                        <label class="form_label" for="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpHospitalizationMedical">
                                                                            Hospitalization-Medical
                                                                        </label>
                                                                    </td>
                                                                    <td width="20%">
                                                                        <input type="checkbox" id="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpHospitalizationPsychiatric"
                                                                            name="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpHospitalizationPsychiatric" />
                                                                        <label class="form_label" for="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpHospitalizationPsychiatric">
                                                                            Hospitalization-Psychiatric
                                                                        </label>
                                                                    </td>
                                                                    <td width="20%">
                                                                        <input type="checkbox" id="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpTripToER"
                                                                            name="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpTripToER" />
                                                                        <label class="form_label" for="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpTripToER">
                                                                            Trip to ER
                                                                        </label>
                                                                    </td>
                                                                    <td colspan="2"></td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="height2"></td>
                                                                </tr>
                                                                <tr>
                                                                    <td width="25%">
                                                                        <input type="checkbox" id="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpAllegedAbuse"
                                                                            name="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpAllegedAbuse" />
                                                                        <label class="form_label" for="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpAllegedAbuse">
                                                                            Alleged abuse
                                                                        </label>
                                                                    </td>
                                                                    <td width="20%">
                                                                        <input type="checkbox" id="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpMisuseOfFundsProperty"
                                                                            name="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpMisuseOfFundsProperty" />
                                                                        <label class="form_label" for="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpMisuseOfFundsProperty">
                                                                            Misuse of funds/property
                                                                        </label>
                                                                    </td>
                                                                    <td width="20%">
                                                                        <input type="checkbox" id="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpViolationOfRights"
                                                                            name="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpViolationOfRights" />
                                                                        <label class="form_label" for="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpViolationOfRights">
                                                                            Violation of rights
                                                                        </label>
                                                                    </td>
                                                                    <td colspan="2"></td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="height2"></td>
                                                                </tr>
                                                                <tr>
                                                                    <td width="25%">
                                                                        <input type="checkbox" id="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpIndividualToIndividualInjury"
                                                                            name="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpIndividualToIndividualInjury" />
                                                                        <label class="form_label" for="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpIndividualToIndividualInjury">
                                                                            Individual to Individual Injury
                                                                        </label>
                                                                    </td>
                                                                    <td width="20%">
                                                                        <input type="checkbox" id="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpInjury"
                                                                            name="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpInjury" onchange="IncidentSectionsShowHide();" />
                                                                        <label class="form_label" for="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpInjury">
                                                                            Injury
                                                                        </label>
                                                                    </td>
                                                                    <td width="20%">
                                                                        <input type="checkbox" id="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpInjuryFromRestraint"
                                                                            name="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpInjuryFromRestraint" />
                                                                        <label class="form_label" for="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpInjuryFromRestraint">
                                                                            Injury from restraint
                                                                        </label>
                                                                    </td>
                                                                    <td colspan="2"></td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="height2"></td>
                                                                </tr>
                                                                <tr>
                                                                    <td width="25%">
                                                                        <input type="checkbox" id="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpFireDepartmentInvolvement"
                                                                            name="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpFireDepartmentInvolvement" />
                                                                        <label class="form_label" for="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpFireDepartmentInvolvement">
                                                                            Fire Department Involvement
                                                                        </label>
                                                                    </td>
                                                                    <td width="20%">
                                                                        <input type="checkbox" id="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpPoliceInvolvement"
                                                                            name="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpPoliceInvolvement" />
                                                                        <label class="form_label" for="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpPoliceInvolvement">
                                                                            Police involvement
                                                                        </label>
                                                                    </td>
                                                                    <td colspan="3"></td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="height2"></td>
                                                                </tr>
                                                                <tr>
                                                                    <td width="25%">
                                                                        <input type="checkbox" id="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpChokingSwallowingDifficulty"
                                                                            name="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpChokingSwallowingDifficulty" />
                                                                        <label class="form_label" for="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpChokingSwallowingDifficulty">
                                                                            Choking/Swallowing difficulty
                                                                        </label>
                                                                    </td>
                                                                    <td width="20%">
                                                                        <input type="checkbox" id="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpDeath"
                                                                            name="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpDeath" />
                                                                        <label class="form_label" for="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpDeath">
                                                                            Death
                                                                        </label>
                                                                    </td>
                                                                    <td width="20%">
                                                                        <input type="checkbox" id="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpDrugUsePossession"
                                                                            name="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpDrugUsePossession" />
                                                                        <label class="form_label" for="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpDrugUsePossession">
                                                                            Drug use/possession
                                                                        </label>
                                                                    </td>
                                                                    <td width="18%">
                                                                        <input type="checkbox" id="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpOutOfProgramArea"
                                                                            name="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpOutOfProgramArea" />
                                                                        <label class="form_label" for="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpOutOfProgramArea">
                                                                            Out of program area
                                                                        </label>
                                                                    </td>
                                                                    <td width="17%">
                                                                        <input type="checkbox" id="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpSexualIncident"
                                                                            name="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpSexualIncident" />
                                                                        <label class="form_label" for="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpSexualIncident">
                                                                            Sexual incident
                                                                        </label>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="height2"></td>
                                                                </tr>
                                                                <tr>
                                                                    <td colspan="5">
                                                                        <input type="checkbox" id="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpOther"
                                                                            name="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpOther" onchange="ShowHideTextBox();" />
                                                                        <label class="form_label" for="CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpOther" style="padding-right: 25px;">
                                                                            Other
                                                                        </label>
                                                                        <input style="width: 500px;" class="form_textbox element" type="text" id="TextBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpOtherComments"
                                                                            name="TextBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpOtherComments" />
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                <tr>
                                                                    <td width="15%">
                                                                        <input type="button" id="ButtonSupervisorFollowUpSign" name="ButtonSupervisorFollowUpSign" value="Sign" onclick="DetailsSignDocument('SupervisorFollowUp');" class="less_detail_btn_new" />
                                                                    </td>
                                                                    <td width="8%"><span id="Span31" class="form_label" name="SpanSignedBy">Signed By:</span> </td>
                                                                    <td width="50%"><span id="Span_SignedBySupervisorFollow" class="form_label_text" name="Span_SignedBySupervisorFollow"></span></td>
                                                                    <td width="10%"><span id="Span33" class="form_label" name="SpanDateSigned">Date Signed:</span> </td>
                                                                    <td width="22%"><span id="Span_DateSignedSupervisorFollow" class="form_label_text" name="Span_DateSignedSupervisorFollow"></span></td>
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
                                                        <td class="right_bottom_cont_bottom_bg" width="100%"></td>
                                                        <td width="2" class="right_bottom_cont_bottom_bg" align="right">
                                                            <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif"
                                                                height="7" alt="" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="content_tab_bg"></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2"></td>
                            </tr>
                            <tr>
                                <td>
                                    <table border="0" cellpadding="0" cellspacing="0" width="100%" style="margin-bottom: 20px;" id="IncidentManagerFollowUpTable">
                                        <tr>
                                            <td style="width: 100%;">
                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                    <tr>
                                                        <td class="content_tab_left" align="left" nowrap='nowrap'>Manager Review
                                                        </td>
                                                        <td width="17">
                                                            <img style="vertical-align: top;" height="26" width="17" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                                                        </td>
                                                        <td class="content_tab_top" width="100%"></td>
                                                        <td width="7">
                                                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td valign="top" class="content_tab_bg_padding" align="left">
                                                <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                    <tr>
                                                        <td>
                                                            <span id="SeizureSupervisorFollowUpManagerName" name="SeizureSupervisorFollowUpSupervisorName" style="padding-right: 20px;">Manager</span>
                                                            <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentReportManagerFollowUps_ManagerFollowUpManagerId" Width="157px"
                                                                name="DropDownList_CustomIncidentReportManagerFollowUps_ManagerFollowUpManagerId" runat="server" AddBlankRow="True"
                                                                BlankRowText="" valuetype="">
                                                            </cc3:StreamlineDropDowns>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td class="checkbox_container">
                                                            <span id="Span27" class="form_label" name="SpanSupervisorFollowAdministratorNotified" style="padding-right: 22px;">Administrator Notified</span>
                                                            <input type="radio" id="RadioButton_CustomIncidentReportManagerFollowUps_ManagerFollowUpAdministratorNotified_Y" value="Y"
                                                                name="RadioButton_CustomIncidentReportManagerFollowUps_ManagerFollowUpAdministratorNotified" style="cursor: default" onchange="IncidentSectionsShowHide();" />
                                                            <label for="RadioButton_CustomIncidentReportManagerFollowUps_ManagerFollowUpAdministratorNotified_Y" style="cursor: default; padding-right: 5px;">
                                                                Yes</label>
                                                            <input type="radio" id="RadioButton_CustomIncidentReportManagerFollowUps_ManagerFollowUpAdministratorNotified_N" value="N"
                                                                name="RadioButton_CustomIncidentReportManagerFollowUps_ManagerFollowUpAdministratorNotified" style="cursor: default" onchange="IncidentSectionsShowHide();";/>
                                                            <label for="RadioButton_CustomIncidentReportManagerFollowUps_ManagerFollowUpAdministratorNotified_N" style="cursor: default">
                                                                No</label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <span id="Span29" name="SpanSupervisorFollowAdministrator" style="padding-right: 63px; padding-left: 3px;">Administrator</span>
                                                            <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentReportManagerFollowUps_ManagerFollowUpAdministrator" Width="157px"
                                                                name="DropDownList_CustomIncidentReportManagerFollowUps_ManagerFollowUpAdministrator" runat="server" AddBlankRow="True"
                                                                BlankRowText="" valuetype="">
                                                            </cc3:StreamlineDropDowns>
                                                            <span id="Span30" class="form_label" name="SpanSupervisorFollowAdminDateOfNotification" style="padding-left: 80px;">Date of notification</span>
                                                            <input datatype="Date" type="text" id="TextBox_CustomIncidentReportManagerFollowUps_ManagerFollowUpAdminDateOfNotification"
                                                                name="TextBox_CustomIncidentReportManagerFollowUps_ManagerFollowUpAdminDateOfNotification" style="width: 67px; height: 15px; padding-right: 2px"
                                                                class="form_textbox" />
                                                            <img id="img6" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                onclick="return showCalendar('TextBox_CustomIncidentReportManagerFollowUps_ManagerFollowUpAdminDateOfNotification', '%m/%d/%Y');" style="cursor: default; vertical-align: text-bottom;"
                                                                alt="Calendar" />
                                                            <span id="Span8" class="form_label" name="SpanSupervisorFollowAdminTimeOfNotification" style="padding-left: 70px;">Time of Notification</span>
                                                            <input type="text" name="TextBox_CustomIncidentReportManagerFollowUps_ManagerFollowUpAdminTimeOfNotification"
                                                                id="TextBox_CustomIncidentReportManagerFollowUps_ManagerFollowUpAdminTimeOfNotification"
                                                                onblur="TimeNotified(this)" bindautosaveevents="False" datatype="Time" style="width: 67px" class='form_textbox' />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                   
                                                    <tr>
                                                        <td>Follow up
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <textarea id="TextBox_CustomIncidentReportManagerFollowUps_ManagerReviewFollowUp" class="form_textareaWithoutWidth"
                                                                name="TextBox_CustomIncidentReportManagerFollowUps_ManagerReviewFollowUp" rows="4" cols="158" spellcheck="True"></textarea>
                                                        </td>
                                                    </tr>
                                                       
                                                  
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr>
                                                                    <td width="15%">
                                                                        <input type="button" id="ButtonIncidentReportManagerFollowUpSign" name="ButtonIncidentReportManagerFollowUpSign" value="Sign" onclick="DetailsSignDocument('IncidentReportManagerFollowUp');" class="less_detail_btn_new" />
                                                                    </td>
                                                                    <td width="8%">
                                                                        <span id="SpanSignedByManagerFollowUp" class="form_label" name="SpanSignedBy">Signed By:</span>
                                                                    </td>
                                                                    <td width="50%">
                                                                        <span id="SpanSignedByIncidentReportManagerFollowUp" class="form_label_text" name="SpanSignedByIncidentReportManagerFollowUp"></span>
                                                                    </td>
                                                                    <td width="10%">
                                                                        <span id="Span28" class="form_label" name="SpanDateSigned">Date Signed:</span>
                                                                    </td>
                                                                    <td width="22%">
                                                                        <span id="Span_DateSignedIncidentReportManagerFollowUp" class="form_label_text" name="Span_DateSignedIncidentReportManagerFollowUp"></span>
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
                                                        <td class="right_bottom_cont_bottom_bg" width="100%"></td>
                                                        <td width="2" class="right_bottom_cont_bottom_bg" align="right">
                                                            <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif"
                                                                height="7" alt="" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="content_tab_bg"></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2"></td>
                            </tr>
                            <tr>
                                <td>
                                    <table border="0" cellpadding="0" cellspacing="0" width="100%" style="margin-bottom: 20px;" id="IncidentAdministratorTable">
                                        <tr>
                                            <td style="width: 100%;">
                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                    <tr>
                                                        <td class="content_tab_left" align="left" nowrap='nowrap'>Administrator Review
                                                        </td>
                                                        <td width="17">
                                                            <img style="vertical-align: top;" height="26" width="17" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                                                        </td>
                                                        <td class="content_tab_top" width="100%"></td>
                                                        <td width="7">
                                                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td valign="top" class="content_tab_bg_padding" align="left">
                                                <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                    <tr>
                                                        <td>
                                                            <span id="SpanAdministrator" name="SpanAdministrator" style="padding-right: 40px;">Administrator</span>
                                                            <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentReportAdministratorReviews_AdministratorReviewAdministrator" Width="157px"
                                                                name="DropDownList_CustomIncidentReportAdministratorReviews_AdministratorReviewAdministrator" runat="server" AddBlankRow="True"
                                                                BlankRowText="" valuetype="">
                                                            </cc3:StreamlineDropDowns>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td>Administrative review
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <textarea id="TextBox_CustomIncidentReportAdministratorReviews_AdministratorReviewAdministrativeReview" class="form_textareaWithoutWidth"
                                                                name="TextBox_CustomIncidentReportAdministratorReviews_AdministratorReviewAdministrativeReview" rows="4" cols="158" spellcheck="True"></textarea>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td class="checkbox_container">
                                                            <span id="Span39" class="form_label" name="SpanIndividual" style="padding-right: 20px;">Filed reportable Incident?</span>
                                                            <input type="radio" id="RadioButton_CustomIncidentReportAdministratorReviews_AdministratorReviewFiledReportableIncident_Y" value="Y"
                                                                name="RadioButton_CustomIncidentReportAdministratorReviews_AdministratorReviewFiledReportableIncident" style="cursor: default" />
                                                            <label for="RadioButton_CustomIncidentReportAdministratorReviews_AdministratorReviewFiledReportableIncident_Y" style="cursor: default; padding-right: 5px;">
                                                                Yes</label>
                                                            <input type="radio" id="RadioButton_CustomIncidentReportAdministratorReviews_AdministratorReviewFiledReportableIncident_N" value="N"
                                                                name="RadioButton_CustomIncidentReportAdministratorReviews_AdministratorReviewFiledReportableIncident" style="cursor: default" />
                                                            <label for="RadioButton_CustomIncidentReportAdministratorReviews_AdministratorReviewFiledReportableIncident_N" style="cursor: default; padding-right: 5px;">
                                                                No</label>
                                                            <input type="radio" id="RadioButton_CustomIncidentReportAdministratorReviews_AdministratorReviewFiledReportableIncident_O" value="O"
                                                                name="RadioButton_CustomIncidentReportAdministratorReviews_AdministratorReviewFiledReportableIncident" style="cursor: default" />
                                                            <label for="RadioButton_CustomIncidentReportAdministratorReviews_AdministratorReviewFiledReportableIncident_O" style="cursor: default">
                                                                Other</label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td>Comments
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <textarea id="TextBox_CustomIncidentReportAdministratorReviews_AdministratorReviewComments" class="form_textareaWithoutWidth"
                                                                name="TextBox_CustomIncidentReportAdministratorReviews_AdministratorReviewComments" rows="4" cols="158" spellcheck="True"></textarea>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr>
                                                                    <td width="15%">
                                                                        <input type="button" id="ButtonAdministratorReviewsSign" name="ButtonAdministratorReviews" value="Sign" onclick="DetailsSignDocument('AdministratorReview');" class="less_detail_btn_new" />
                                                                    </td>
                                                                    <td width="8%">
                                                                        <span id="Span48" class="form_label" name="SpanSignedBy">Signed By:</span>
                                                                    </td>
                                                                    <td width="50%">
                                                                        <span id="Span_SignedByAdministratorReview" class="form_label_text" name="Span_SignedByAdministratorReview"></span>
                                                                    </td>
                                                                    <td width="10%">
                                                                        <span id="Span50" class="form_label" name="SpanDateSigned">Date Signed:</span>
                                                                    </td>
                                                                    <td width="22%">
                                                                        <span id="Span_DateSignedAdministratorReview" class="form_label_text" name="Span_DateSignedAdministratorReview"></span>
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
                                                        <td class="right_bottom_cont_bottom_bg" width="100%"></td>
                                                        <td width="2" class="right_bottom_cont_bottom_bg" align="right">
                                                            <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif"
                                                                height="7" alt="" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="content_tab_bg"></td>
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

