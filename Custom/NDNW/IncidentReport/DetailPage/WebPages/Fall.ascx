<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Fall.ascx.cs" Inherits="Custom_IncidentReport_WebPages_Fall" %>
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
                        <table border="0" cellpadding="0" cellspacing="0" width="100%" style="margin-bottom: 20px;" id="FallDetailsTable">
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
                                    <table width="99%" cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td>
                                                <span id="SpanFallDetailsDescribeIncident" name="SpanFallDetailsDescribeIncident" style="padding-right: 20px;">Describe Incident</span>
                                                <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentReportFallDetails_FallDetailsDescribeIncident" Width="157px"
                                                    name="DropDownList_CustomIncidentReportFallDetails_FallDetailsDescribeIncident" runat="server" AddBlankRow="True"
                                                    BlankRowText="" valuetype="">
                                                </cc3:StreamlineDropDowns>
                                                <span id="SpanFallDetailsCauseOfIncident" name="SpanFallDetailsCauseOfIncident" style="padding-right: 20px; padding-left: 60px;">Cause of Incident</span>
                                                <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentReportFallDetails_FallDetailsCauseOfIncident" Width="157px"
                                                    name="DropDownList_CustomIncidentReportFallDetails_FallDetailsCauseOfIncident" runat="server" AddBlankRow="True"
                                                    BlankRowText="" valuetype="" OnDataBound="CauseOfIncidentCode"  onchange="ShowHideTextBox();">
                                                </cc3:StreamlineDropDowns>
                                                <input type="text" class="form_textarea" style="width: 150px; display: none" id="TextBox_CustomIncidentReportFallDetails_FallDetailsCauseOfIncidentText"
                                                    name="TextBox_CustomIncidentReportFallDetails_FallDetailsCauseOfIncidentText" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height2"></td>
                                        </tr>
                                        <tr>
                                            <td>Personal/Safety Protective Device(s) Used at Time of Incident
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height2"></td>
                                        </tr>
                                        <tr>
                                            <td class="checkbox_container">
                                                <input type="checkbox" id="CheckBox_CustomIncidentReportFallDetails_FallDetailsNone"
                                                    name="CheckBox_CustomIncidentReportFallDetails_FallDetailsNone" />
                                                <label for="CheckBox_CustomIncidentReportFallDetails_FallDetailsNone" class="form_label" style="padding-right: 31px;">
                                                    None
                                                </label>
                                                <input type="checkbox" id="CheckBox_CustomIncidentReportFallDetails_FallDetailsCane"
                                                    name="CheckBox_CustomIncidentReportFallDetails_FallDetailsCane" />
                                                <label for="CheckBox_CustomIncidentReportFallDetails_FallDetailsCane" class="form_label" style="padding-right: 67px;">
                                                    Cane
                                                </label>
                                                <input type="checkbox" id="CheckBox_CustomIncidentReportFallDetails_FallDetailsSeatLapBelt"
                                                    name="CheckBox_CustomIncidentReportFallDetails_FallDetailsSeatLapBelt" />
                                                <label for="CheckBox_CustomIncidentReportFallDetails_FallDetailsSeatLapBelt" class="form_label" style="padding-right: 22px;">
                                                    Seat/Lap belt
                                                </label>
                                                <input type="checkbox" id="CheckBox_CustomIncidentReportFallDetails_FallDetailsWheelchair"
                                                    name="CheckBox_CustomIncidentReportFallDetails_FallDetailsWheelchair" />
                                                <label for="CheckBox_CustomIncidentReportFallDetails_FallDetailsWheelchair" class="form_label" style="padding-right: 15px;">
                                                    Wheelchair
                                                </label>
                                                <input type="checkbox" id="CheckBox_CustomIncidentReportFallDetails_FallDetailsGaitBelt"
                                                    name="CheckBox_CustomIncidentReportFallDetails_FallDetailsGaitBelt" />
                                                <label for="CheckBox_CustomIncidentReportFallDetails_FallDetailsGaitBelt" class="form_label" style="padding-right: 20px;">
                                                    Gait Belt
                                                </label>
                                                <input type="checkbox" id="CheckBox_CustomIncidentReportFallDetails_FallDetailsWheellchairTray"
                                                    name="CheckBox_CustomIncidentReportFallDetails_FallDetailsWheellchairTray" />
                                                <label for="CheckBox_CustomIncidentReportFallDetails_FallDetailsWheellchairTray" class="form_label" style="padding-right: 20px;">
                              Wheelchair Tray
                                                </label>
                                                <input type="checkbox" id="CheckBox_CustomIncidentReportFallDetails_FallDetailsWalker"
                                                    name="CheckBox_CustomIncidentReportFallDetails_FallDetailsWalker" />
                                                <label for="CheckBox_CustomIncidentReportFallDetails_FallDetailsWalker" class="form_label" style="padding-right: 28px;">
                                                    Walker
                                                </label>
                                                <input type="checkbox" id="CheckBox_CustomIncidentReportFallDetails_FallDetailsMafosBraces"
                                                    name="CheckBox_CustomIncidentReportFallDetails_FallDetailsMafosBraces" />
                                                <label for="CheckBox_CustomIncidentReportFallDetails_FallDetailsMafosBraces" class="form_label">
                                                    MAFOs/Braces
                                                </label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height2"></td>
                                        </tr>
                                        <tr>
                                            <td class="checkbox_container">
                                                <input type="checkbox" id="CheckBox_CustomIncidentReportFallDetails_FallDetailsHelmet"
                                                    name="CheckBox_CustomIncidentReportFallDetails_FallDetailsHelmet" />
                                                <label for="CheckBox_CustomIncidentReportFallDetails_FallDetailsHelmet" class="form_label" style="padding-right: 22px;">
                                                    Helmet
                                                </label>
                                                <input type="checkbox" id="CheckBox_CustomIncidentReportFallDetails_FallDetailsChestHarness"
                                                    name="CheckBox_CustomIncidentReportFallDetails_FallDetailsChestHarness" />
                                                <label for="CheckBox_CustomIncidentReportFallDetails_FallDetailsChestHarness" class="form_label" style="padding-right: 22px;">
                                                    Chest Harness
                                                </label>
                                                <input type="checkbox" id="CheckBox_CustomIncidentReportFallDetails_FallDetailsOther"
                                                    name="CheckBox_CustomIncidentReportFallDetails_FallDetailsOther" onchange="ShowHideTextBox();" />
                                                <label for="CheckBox_CustomIncidentReportFallDetails_FallDetailsOther" class="form_label" style="padding-right: 37px;">
                                                    Other
                                                </label>
                                                <input style="width: 500px; display: none;" class="form_textbox element" type="text" id="TextBox_CustomIncidentReportFallDetails_FallDetailsOtherText"
                                                    name="TextBox_CustomIncidentReportFallDetails_FallDetailsOtherText" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height2"></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <span id="SpanFallDetailsIncidentOccurredWhile" name="SpanFallDetailsIncidentOccurredWhile" style="padding-right: 10px;">Incident Occurred While</span>
                                                <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentReportFallDetails_FallDetailsIncidentOccurredWhile" Width="157px"
                                                    name="DropDownList_CustomIncidentReportFallDetails_FallDetailsIncidentOccurredWhile" runat="server" AddBlankRow="True"
                                                    BlankRowText="" valuetype="" onchange="IncidentSectionsShowHide();" OnDataBound="IncidentOccurredWhileCode">
                                                </cc3:StreamlineDropDowns>
                                                <span id="SpanFootwearAtTimeOfIncident" name="SpanFootwearAtTimeOfIncident" style="padding-right: 12px; padding-left: 70px;">Footwear at Time of Incident</span>
                                                <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentReportFallDetails_FallDetailsFootwearAtTimeOfIncident" Width="157px"
                                                    name="DropDownList_CustomIncidentReportFallDetails_FallDetailsFootwearAtTimeOfIncident" runat="server" AddBlankRow="True"
                                                    BlankRowText="" valuetype="">
                                                </cc3:StreamlineDropDowns>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height2"></td>
                                        </tr>
                                        <tr class="WheelsSections">
                                            <td class="checkbox_container">
                                                <span id="SpanFallDetailsWheelsLocked" class="form_label" name="SpanFallDetailsWheelsLocked" style="padding-right: 84px;">Wheels Locked?</span>
                                                <input type="radio" id="RadioButton_CustomIncidentReportFallDetails_FallDetailsWheelsLocked_Y" value="Y"
                                                    name="RadioButton_CustomIncidentReportFallDetails_FallDetailsWheelsLocked" style="cursor: default" />
                                                <label for="RadioButton_CustomIncidentReportFallDetails_FallDetailsWheelsLocked_Y" style="cursor: default; padding-right: 5px;">
                                                    Yes</label>
                                                <input type="radio" id="RadioButton_CustomIncidentReportFallDetails_FallDetailsWheelsLocked_N" value="N"
                                                    name="RadioButton_CustomIncidentReportFallDetails_FallDetailsWheelsLocked" style="cursor: default" />
                                                <label for="RadioButton_CustomIncidentReportFallDetails_FallDetailsWheelsLocked_N" style="cursor: default; padding-right: 5px;">
                                                    No</label>
                                                <input type="radio" id="RadioButton_CustomIncidentReportFallDetails_FallDetailsWheelsLocked_U" value="U"
                                                    name="RadioButton_CustomIncidentReportFallDetails_FallDetailsWheelsLocked" style="cursor: default" />
                                                <label for="RadioButton_CustomIncidentReportFallDetails_FallDetailsWheelsLocked_U" style="cursor: default">
                                                    Unknown</label>
                                            </td>
                                        </tr>
                                        <tr class="WheelsSections">
                                            <td class="height2"></td>
                                        </tr>
                                        <tr class="WheelsSections">
                                            <td class="checkbox_container">
                                                <span id="Span7" class="form_label" name="SpanIndividual" style="padding-right: 20px;">Where bed wheels unlocked?</span>
                                                <input type="radio" id="CustomIncidentReportFallDetails_FallDetailsWhereBedWheelsUnlocked_Y" value="Y"
                                                    name="CustomIncidentReportFallDetails_FallDetailsWhereBedWheelsUnlocked" style="cursor: default" />
                                                <label for="CustomIncidentReportFallDetails_FallDetailsWhereBedWheelsUnlocked_Y" style="cursor: default; padding-right: 5px;">
                                                    Yes</label>
                                                <input type="radio" id="CustomIncidentReportFallDetails_FallDetailsWhereBedWheelsUnlocked_N" value="N"
                                                    name="CustomIncidentReportFallDetails_FallDetailsWhereBedWheelsUnlocked" style="cursor: default" />
                                                <label for="CustomIncidentReportFallDetails_FallDetailsWhereBedWheelsUnlocked_N" style="cursor: default; padding-right: 5px;">
                                                    No</label>
                                                <input type="radio" id="CustomIncidentReportFallDetails_FallDetailsWhereBedWheelsUnlocked_NA" value="A"
                                                    name="CustomIncidentReportFallDetails_FallDetailsWhereBedWheelsUnlocked" style="cursor: default" />
                                                <label for="CustomIncidentReportFallDetails_FallDetailsWhereBedWheelsUnlocked_NA" style="cursor: default">
                                                    N/A</label>
                                            </td>
                                        </tr>
                                        <tr class="RailsPresent">
                                            <td class="height2"></td>
                                        </tr>
                                        <tr class="RailsPresent">
                                            <td>What type of side rails were present?
                                            </td>
                                        </tr>
                                        <tr class="RailsPresent">
                                            <td class="height2"></td>
                                        </tr>
                                        <tr class="RailsPresent">
                                            <td class="checkbox_container">
                                                <input type="checkbox" id="CheckBox_CustomIncidentReportFallDetails_FallDetailsNA"
                                                    name="CheckBox_CustomIncidentReportFallDetails_FallDetailsNA" />
                                                <label for="CheckBox_CustomIncidentReportFallDetails_FallDetailsNA" class="form_label" style="padding-right: 10px;">
                                                    N/A
                                                </label>
                                                <input type="checkbox" id="CheckBox_CustomIncidentReportFallDetails_FallDetailsFullLength"
                                                    name="CheckBox_CustomIncidentReportFallDetails_FallDetailsFullLength" />
                                                <label for="CheckBox_CustomIncidentReportFallDetails_FallDetailsFullLength" class="form_label" style="padding-right: 5px;">
                                                    Full Length
                                                </label>
                                                <input type="checkbox" id="CheckBox_CustomIncidentReportFallDetails_FallDetails2Half"
                                                    name="CheckBox_CustomIncidentReportFallDetails_FallDetails2Half" />
                                                <label for="CheckBox_CustomIncidentReportFallDetails_FallDetails2Half" class="form_label" style="padding-right: 10px;">
                                                    2 Half
                                                </label>
                                                <input type="checkbox" id="CheckBox_CustomIncidentReportFallDetails_FallDetails4Half"
                                                    name="CheckBox_CustomIncidentReportFallDetails_FallDetails4Half" />
                                                <label for="CheckBox_CustomIncidentReportFallDetails_FallDetails4Half" class="form_label" style="padding-right: 10px;">
                                                    4 Half
                                                </label>
                                                <input type="checkbox" id="CheckBox_CustomIncidentReportFallDetails_FallDetailsBothSidesUp"
                                                    name="CheckBox_CustomIncidentReportFallDetails_FallDetailsBothSidesUp" />
                                                <label for="CheckBox_CustomIncidentReportFallDetails_FallDetailsBothSidesUp" class="form_label" style="padding-right: 5px;">
                                                    Both Sides Up
                                                </label>
                                                <input type="checkbox" id="CheckBox_CustomIncidentReportFallDetails_FallDetailsOneSidesUp"
                                                    name="CheckBox_CustomIncidentReportFallDetails_FallDetailsOneSidesUp" />
                                                <label for="CheckBox_CustomIncidentReportFallDetails_FallDetailsOneSidesUp" class="form_label" style="padding-right: 5px;">
                                                    One Side Up
                                                </label>
                                                <input type="checkbox" id="CheckBox_CustomIncidentReportFallDetails_FallDetailsBumperPads"
                                                    name="CheckBox_CustomIncidentReportFallDetails_FallDetailsBumperPads" />
                                                <label for="CheckBox_CustomIncidentReportFallDetails_FallDetailsBumperPads" class="form_label" style="padding-right: 5px;">
                                                    Bumper Pads
                                                </label>
                                                <input type="checkbox" id="CheckBox_CustomIncidentReportFallDetails_FallDetailsFurtherDescription"
                                                    name="CheckBox_CustomIncidentReportFallDetails_FallDetailsFurtherDescription" onchange="ShowHideTextBox();" />
                                                <label for="CheckBox_CustomIncidentReportFallDetails_FallDetailsFurtherDescription" class="form_label" style="padding-right: 5px;">
                                                    Further Description
                                                </label>
                                                <input style="width: 120px; display: none;" class="form_textbox element" type="text" id="TextBox_CustomIncidentReportFallDetails_FallDetailsFurtherDescriptiontext"
                                                    name="TextBox_CustomIncidentReportFallDetails_FallDetailsFurtherDescriptiontext" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height2"></td>
                                        </tr>
                                        <tr>
                                            <td class="checkbox_container">
                                                <span id="SpanWasAnAlarmPresent" class="form_label" name="SpanWasAnAlarmPresent" style="padding-right: 50px;">Was an alarm present?</span>
                                                <input type="radio" id="RadioButton_CustomIncidentReportFallDetails_FallDetailsWasAnAlarmPresent_Y" value="Y"
                                                    name="RadioButton_CustomIncidentReportFallDetails_FallDetailsWasAnAlarmPresent" style="cursor: default" onchange="IncidentSectionsShowHide();" />
                                                <label for="RadioButton_CustomIncidentReportFallDetails_FallDetailsWasAnAlarmPresent_Y" style="cursor: default; padding-right: 5px;">
                                                    Yes</label>
                                                <input type="radio" id="RadioButton_CustomIncidentReportFallDetails_FallDetailsWasAnAlarmPresent_N" value="N"
                                                    name="RadioButton_CustomIncidentReportFallDetails_FallDetailsWasAnAlarmPresent" style="cursor: default" onchange="IncidentSectionsShowHide();" />
                                                <label for="RadioButton_CustomIncidentReportFallDetails_FallDetailsWasAnAlarmPresent_N" style="cursor: default; padding-right: 5px;">
                                                    No</label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height2"></td>
                                        </tr>
                                        <tr class="TypeofAlarm">
                                            <td>Type of Alarm
                                            </td>
                                        </tr>
                                        <tr class="TypeofAlarm">
                                            <td class="height2"></td>
                                        </tr>
                                        <tr class="TypeofAlarm">
                                            <td class="checkbox_container">
                                                <input type="checkbox" id="CheckBox_CustomIncidentReportFallDetails_FallDetailsAlarmSoundedDuringIncident"
                                                    name="CheckBox_CustomIncidentReportFallDetails_FallDetailsAlarmSoundedDuringIncident" />
                                                <label for="CheckBox_CustomIncidentReportFallDetails_FallDetailsAlarmSoundedDuringIncident" class="form_label" style="padding-right: 25px;">
                                                    Alarm sounded during incident
                                                </label>
                                                <input type="checkbox" id="CheckBox_CustomIncidentReportFallDetails_FallDetailsAlarmDidNotSoundDuringIncident"
                                                    name="CheckBox_CustomIncidentReportFallDetails_FallDetailsAlarmDidNotSoundDuringIncident" />
                                                <label for="CheckBox_CustomIncidentReportFallDetails_FallDetailsAlarmDidNotSoundDuringIncident" class="form_label" style="padding-right: 25px;">
                                                    Alarm did not sound during incident
                                                </label>
                                                <input type="checkbox" id="CheckBox_CustomIncidentReportFallDetails_FallDetailsBedMat"
                                                    name="CheckBox_CustomIncidentReportFallDetails_FallDetailsBedMat" />
                                                <label for="CheckBox_CustomIncidentReportFallDetails_FallDetailsBedMat" class="form_label" style="padding-right: 30px;">
                                                    Bed Mat
                                                </label>
                                                <input type="checkbox" id="CheckBox_CustomIncidentReportFallDetails_FallDetailsBeam"
                                                    name="CheckBox_CustomIncidentReportFallDetails_FallDetailsBeam" />
                                                <label for="CheckBox_CustomIncidentReportFallDetails_FallDetailsBeam" class="form_label" style="padding-right: 30px;">
                                                    Beam
                                                </label>
                                                <input type="checkbox" id="CheckBox_CustomIncidentReportFallDetails_FallDetailsBabyMonitor"
                                                    name="CheckBox_CustomIncidentReportFallDetails_FallDetailsBabyMonitor" />
                                                <label for="CheckBox_CustomIncidentReportFallDetails_FallDetailsBabyMonitor" class="form_label" style="padding-right: 35px;">
                                                    Baby Monitor
                                                </label>
                                                <input type="checkbox" id="CheckBox_CustomIncidentReportFallDetails_FallDetailsFloorMat"
                                                    name="CheckBox_CustomIncidentReportFallDetails_FallDetailsFloorMat" />
                                                <label for="CheckBox_CustomIncidentReportFallDetails_FallDetailsFloorMat" class="form_label">
                                                    Floor Mat
                                                </label>
                                            </td>
                                        </tr>
                                        <tr class="TypeofAlarm">
                                            <td class="height2"></td>
                                        </tr>
                                        <tr class="TypeofAlarm">
                                            <td class="checkbox_container">
                                                <input type="checkbox" id="CheckBox_CustomIncidentReportFallDetails_FallDetailsMagneticClip"
                                                    name="CheckBox_CustomIncidentReportFallDetails_FallDetailsMagneticClip" />
                                                <label for="CheckBox_CustomIncidentReportFallDetails_FallDetailsMagneticClip" class="form_label" style="padding-right: 109px;">
                                                    Magnetic Clip
                                                </label>
                                                <input type="checkbox" id="CheckBox_CustomIncidentReportFallDetails_FallDetailsTypeOfAlarmOtherText"
                                                    name="CheckBox_CustomIncidentReportFallDetails_FallDetailsTypeOfAlarmOtherText" onchange="ShowHideTextBox();" />
                                                <label for="CheckBox_CustomIncidentReportFallDetails_FallDetailsTypeOfAlarmOtherText" class="form_label" style="padding-right: 25px;">
                                                    Other
                                                </label>
                                                <input style="width: 500px; display: none;" class="form_textbox element" type="text" id="TextBox_CheckBox_CustomIncidentReportFallDetails_FallDetailsTypeOfAlarmOther"
                                                    name="TextBox_CheckBox_CustomIncidentReportFallDetails_FallDetailsTypeOfAlarmOther" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height2"></td>
                                        </tr>
                                        <tr>
                                            <td>Description of incident (List all individuals and staff involved, what happened before if applicable, what occurred after the incident if applicable)
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <textarea id="TextBox_CustomIncidentReportFallDetails_FallDetailsDescriptionOfincident" class="form_textareaWithoutWidth"
                                                    name="TextBox_CustomIncidentReportFallDetails_FallDetailsDescriptionOfincident" rows="4" cols="158" spellcheck="True"></textarea>
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
                                                <textarea id="TextBox_CustomIncidentReportFallDetails_FallDetailsActionsTakenByStaff" class="form_textareaWithoutWidth"
                                                    name="TextBox_CustomIncidentReportFallDetails_FallDetailsActionsTakenByStaff" rows="4" cols="158" spellcheck="True"></textarea>
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
                                                <textarea id="TextBox_CustomIncidentReportFallDetails_FallDetailsWitnesses" class="form_textareaWithoutWidth"
                                                    name="TextBox_CustomIncidentReportFallDetails_FallDetailsWitnesses" rows="4" cols="158" spellcheck="True"></textarea>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height2"></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <span id="SpanFallDetailsStaffNotifiedForInjury" class="form_label" name="SpanFallDetailsStaffNotifiedForInjury" style="padding-right: 20px;">Staff notified for injury</span>
                                                <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentReportFallDetails_FallDetailsStaffNotifiedForInjury" Width="157px"
                                                    name="DropDownList_CustomIncidentReportFallDetails_FallDetailsStaffNotifiedForInjury" runat="server" AddBlankRow="True"
                                                    BlankRowText="" valuetype="">
                                                </cc3:StreamlineDropDowns>
                                                <span id="SpanFallDetailsDateStaffNotified" class="form_label" name="SpanFallDetailsDateStaffNotified" style="padding-left: 70px;">Date Staff Notified</span>
                                                <input datatype="Date" type="text" id="TextBox_CustomIncidentReportFallDetails_FallDetailsDateStaffNotified"
                                                    name="TextBox_CustomIncidentReportFallDetails_FallDetailsDateStaffNotified" style="width: 67px; height: 15px; padding-right: 2px"
                                                    class="form_textbox" />
                                                <img id="imgFallDetailsDateStaffNotified" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                    onclick="return showCalendar('TextBox_CustomIncidentReportFallDetails_FallDetailsDateStaffNotified', '%m/%d/%Y');" style="cursor: default; vertical-align: text-bottom;"
                                                    alt="Calendar" />
                                                <span id="SpanFallDetailsTimestaffNotified" class="form_label" name="SpanFallDetailsTimestaffNotified" style="padding-left: 66px;">Time staff Notified</span>
                                                <input type="text" name="TextBox_CustomIncidentReportFallDetails_FallDetailsTimestaffNotified" id="TextBox_CustomIncidentReportFallDetails_FallDetailsTimestaffNotified"
                                                    onblur="TimeNotified(this)" bindautosaveevents="False" datatype="Time" style="width: 67px" class='form_textbox' />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height2"></td>
                                        </tr>
                                        <tr>
                                            <td class="checkbox_container">
                                                <input type="checkbox" id="CheckBox_CustomIncidentReportFallDetails_FallDetailsNoMedicalStaffNotified"
                                                    name="CheckBox_CustomIncidentReportFallDetails_FallDetailsNoMedicalStaffNotified" />
                                                <label for="CheckBox_CustomIncidentReportFallDetails_FallDetailsNoMedicalStaffNotified" style="cursor: default; padding-right: 80px;">No medical staff notified</label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height2"></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <span id="Span3" class="form_label" name="SpanDetailsStaffNotifiedForInjury" style="padding-right: 8px;">Supervisor to be Flagged</span>
                                                <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentReportFallDetails_FallDetailsSupervisorFlaggedId" Width="157px"
                                                    name="DropDownList_CustomIncidentReportFallDetails_FallDetailsSupervisorFlaggedId" runat="server" AddBlankRow="True"
                                                    BlankRowText="" valuetype="">
                                                </cc3:StreamlineDropDowns>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><span id="Span4" class="form_label" name="SpanDetailsStaffNotifiedForInjury" style="padding-right: 20px;">for Review</span>

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
                                                            <input type="button" id="ButtonFallDetailsSign" name="ButtonFallDetailsSign" value="Sign" onclick="DetailsSignDocument('FallDetails');" class="less_detail_btn_new" />
                                                        </td>
                                                        <td width="8%">
                                                            <span id="SpanSignedBy1F" class="form_label" name="Span_SignedBy">Signed By:</span>
                                                        </td>
                                                        <td width="50%">
                                                            <span id="SpanSignedByFallDetails" class="form_label_text" name="SpanSignedByFallDetails"></span>
                                                        </td>
                                                        <td width="10%">
                                                            <span id="SpanDateSigned" class="form_label" name="SpanDateSigned">Date Signed:</span>
                                                        </td>
                                                        <td width="22%">
                                                            <span id="Span_DateSignedFallDetails" class="form_label_text" name="Span_DateSignedFallDetails"></span>
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
                        <table border="0" cellpadding="0" cellspacing="0" width="100%" style="margin-bottom: 20px;" id="FallIndividualStatusTable">
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
                                                <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusNurseStaffEvaluating" Width="157px"
                                                    name="DropDownList_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusNurseStaffEvaluating" runat="server" AddBlankRow="True"
                                                    BlankRowText="" valuetype="" onchange="GetSuffix(this);">
                                                </cc3:StreamlineDropDowns>
                                                <span id="SpanCredentialTitle" name="SpanCredentialTitle" style="padding-left: 222px; padding-right: 10px;">Credential/title</span>
                                                <input type="text" name="TextBox_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusCredentialTitle"
                                                    id="TextBox_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusCredentialTitle" style="width: 201px;" class='form_textbox' />
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
                                                <textarea id="TextBox_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusDetailsOfInjury" class="form_textareaWithoutWidth"
                                                    name="TextBox_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusDetailsOfInjury" rows="4" cols="158" spellcheck="True"></textarea>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height2"></td>
                                        </tr>
                                        <tr>
                                            <td>Treatment
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height2"></td>
                                        </tr>
                                        <tr>
                                            <td class="checkbox_container">
                                                <input type="checkbox" id="CheckBox_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusNoTreatmentNoInjury"
                                                    name="CheckBox_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusNoTreatmentNoInjury" />
                                                <label for="CheckBox_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusNoTreatmentNoInjury" class="form_label" style="padding-right:15px">
                                                    No Treatment/No Injury
                                                </label>
                                                <input type="checkbox" id="CheckBox_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusFirstAidOnly"
                                                    name="CheckBox_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusFirstAidOnly" />
                                                <label for="CheckBox_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusFirstAidOnly" class="form_label" style="padding-right:15px">
                                                    First Aid Only
                                                </label>
                                                <input type="checkbox" id="CheckBox_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusMonitor"
                                                    name="CheckBox_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusMonitor" />
                                                <label for="CheckBox_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusMonitor" class="form_label" style="padding-right:15px">
                                                    Monitor
                                                </label>
                                                <input type="checkbox" id="CheckBox_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusToPrimaryCareProviderClinicEvaluation"
                                                    name="CheckBox_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusToPrimaryCareProviderClinicEvaluation" />
                                                <label for="CheckBox_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusToPrimaryCareProviderClinicEvaluation" class="form_label" style="padding-right:5px">
                                                    To Primary Care Provider/Clinic Evaluation
                                                </label>
                                                <input type="checkbox" id="CheckBox_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusToEmergencyRoom"
                                                    name="CheckBox_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusToEmergencyRoom" />
                                                <label for="CheckBox_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusToEmergencyRoom" class="form_label" style="padding-right:15px">
                                                    To Emergency Room
                                                </label>                                                                                    
                                            </td>
                                        </tr>
                                          <tr>
                                            <td class="height2"></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                 <input type="checkbox" id="CheckBox_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusOther"
                                                    name="CheckBox_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusOther" onchange="ShowHideTextBox();" />
                                                <label for="CheckBox_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusOther" class="form_label" style="padding-right:15px">
                                                    Other
                                                </label>          
                                                 <input style="width:500px; display: none;" class="form_textbox element" type="text" id="TextBox_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusOtherText"
                                                    name="TextBox_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusOtherText" />
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
                                                <textarea id="TextBox_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusComments" class="form_textareaWithoutWidth"
                                                    name="TextBox_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusComments" rows="4" cols="158" spellcheck="True"></textarea>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height2"></td>
                                        </tr>
                                        <tr>
                                            <td class="checkbox_container">
                                                <span id="SpanFGCNotified" class="form_label" name="SpanFGCNotified" style="padding-right: 20px;">Family/Guardian/Custodian notified?</span>

                                                <input type="radio" id="RadioButton_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusFamilyGuardianCustodianNotified_Y" value="Y"
                                                    name="RadioButton_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusFamilyGuardianCustodianNotified" style="cursor: default" />
                                                <label for="RadioButton_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusFamilyGuardianCustodianNotified_Y" style="cursor: default; padding-right: 5px;">
                                                    Yes</label>
                                                <input type="radio" id="RadioButton_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusFamilyGuardianCustodianNotified_N" value="N"
                                                    name="RadioButton_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusFamilyGuardianCustodianNotified" style="cursor: default" />
                                                <label for="RadioButton_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusFamilyGuardianCustodianNotified_N" style="cursor: default">
                                                    No</label>

                                                <span id="SpanDON" class="form_label" name="SpanDON" style="padding-left: 71px;">Date of notification</span>
                                                <input datatype="Date" type="text" id="TextBox_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusDateOfNotification"
                                                    name="TextBox_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusDateOfNotification" style="width: 67px; height: 15px; padding-right: 2px"
                                                    class="form_textbox" />
                                                <img id="img3" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                    onclick="return showCalendar('TextBox_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusDateOfNotification', '%m/%d/%Y');" style="cursor: default; vertical-align: text-bottom;"
                                                    alt="Calendar" />
                                                <span id="SpanTON" class="form_label" name="SpanTON" style="padding-left: 70px;">Time of Notification</span>
                                                <input type="text" name="TextBox_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusTimeOfNotification" id="TextBox_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusTimeOfNotification"
                                                    onblur="TimeNotified(this)" bindautosaveevents="False" datatype="Time" style="width: 67px" class='form_textbox' />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height2"></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <span id="SpanStaffcompletednotification" class="form_label" name="SpanStaffcompletednotification" style="padding-right: 10px;">Staff who completed Notification</span>
                                                <%--                                         <input type="text" class="form_textarea" style="width: 150px;"  id="TextBox_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusStaffCompletedNotification"
                                                    name="TextBox_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusStaffCompletedNotification" />--%>
                                                <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusStaffCompletedNotification" Width="150px"
                                                    name="DropDownList_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusStaffCompletedNotification" runat="server" AddBlankRow="True"
                                                    BlankRowText="" valuetype="">
                                                </cc3:StreamlineDropDowns>
                                                <span id="SpanNameOfTheFamily" class="form_label" name="SpanNameOfTheFamily" style="padding-left: 66px; padding-right: 11px;">Name of the family/guardian/custodian notified</span>
                                                <input type="text" class="form_textarea" style="width: 150px;"  id="TextBox_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusNameOfFamilyGuardianCustodian"
                                                    name="TextBox_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusNameOfFamilyGuardianCustodian" />
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
                                                                <span id="Span_CustomIncidentReportFallFollowUpOfIndividualStatusesNoteType" class="form_label" name="SpanID" style="padding-right:2px">Note Type</span>
                                                                            
                                                                <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentReportFallFollowUpOfIndividualStatuses_NoteType" Width="149px"
                                                                    name="DropDownList_CustomIncidentReportFallFollowUpOfIndividualStatuses_NoteType" runat="server" AddBlankRow="True"
                                                                    BlankRowText="" valuetype="">
                                                                </cc3:StreamlineDropDowns>
                                                                </td>
                                                                <td width="30%">
                                                                    <span id="SpanFollowUpIndividualStatusNoteStart" class="form_label" name="SpanFollowUpIndividualStatusNoteStart" style="padding-left: 71px;">Note Start</span>
                                                                    <input datatype="Date" type="text" id="TextBox_CustomIncidentReportFallFollowUpOfIndividualStatuses_NoteStart"
                                                                        name="TextBox_CustomIncidentReportFallFollowUpOfIndividualStatuses_NoteStart" style="width: 67px; height: 15px; padding-right: 2px"
                                                                        class="form_textbox" />
                                                                    <img id="img_CustomIncidentReportFallFollowUpOfIndividualStatusesNoteStart" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                        onclick="return showCalendar('TextBox_CustomIncidentReportFallFollowUpOfIndividualStatuses_NoteStart', '%m/%d/%Y');" style="cursor: default; vertical-align: text-bottom;"
                                                                        alt="Calendar" />
                                                                </td>
                                                            <td width="30%">
                                                                    <span id="SpanFollowUpIndividualStatusNoteEnd" class="form_label" name="SpanFollowUpIndividualStatusNoteEnd" style="padding-left: 71px;">Note End</span>
                                                                    <input datatype="Date" type="text" id="TextBox_CustomIncidentReportFallFollowUpOfIndividualStatuses_NoteEnd"
                                                                        name="TextBox_CustomIncidentReportFallFollowUpOfIndividualStatuses_NoteEnd" style="width: 67px; height: 15px; padding-right: 2px"
                                                                        class="form_textbox" />
                                                                    <img id="img1" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                        onclick="return showCalendar('TextBox_CustomIncidentReportFallFollowUpOfIndividualStatuses_NoteEnd', '%m/%d/%Y');" style="cursor: default; vertical-align: text-bottom;"
                                                                        alt="Calendar" />
                                                                </td>
                                                        </tr>
                                                                    
                                                            <tr>
                                                            <td class="height2"  colspan="3"></td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="3">
                                                            <span id="Span_NoteComment" class="form_label" name="SpanFollowUpIndividualStatusNameOfFamilyGuardianCustodian" style="padding-left: 2px; padding-right: 11px;">Note Comment</span>
                                                            <input type="text" class="form_textarea" style="width: 660px;" id="TextBox_CustomIncidentReportFallFollowUpOfIndividualStatuses_NoteComment"
                                                    name="TextBox_CustomIncidentReportFallFollowUpOfIndividualStatuses_NoteComment" />
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
                                                <textarea id="TextBox_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusDetailsOfNotification" class="form_textareaWithoutWidth"
                                                    name="TextBox_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusDetailsOfNotification" rows="4" cols="158" spellcheck="True"></textarea>
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
                                                            <input type="button" id="ButtonFallFollowUpIndividualStatusSign" name="ButtonFallFollowUpIndividualStatusSign" value="Sign" onclick="DetailsSignDocument('FallIndividualStatus');" class="less_detail_btn_new" />
                                                        </td>
                                                        <td width="8%">
                                                            <span id="Span19" class="form_label" name="SpanSignedBy">Signed By:</span>
                                                        </td>
                                                        <td width="50%">
                                                            <span id="SpanSignedByFallIndividual" class="form_label_text" name="SpanSignedByFallIndividual"></span>
                                                        </td>
                                                        <td width="10%">
                                                            <span id="Span21" class="form_label" name="SpanDateSigned">Date Signed:</span>
                                                        </td>
                                                        <td width="22%">
                                                            <span id="Span_DateSignedFallIndividual" class="form_label_text" name="Span_DateSignedFallIndividual"></span>
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
                        <table border="0" cellpadding="0" cellspacing="0" width="100%" style="margin-bottom: 20px;" id="FallSupervisorFollowUpTable">
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
                                                <span id="Span15" name="SpanNurseStaffEvaluating" style="padding-right: 20px;">Supervisor name</span>
                                                <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentReportFallSupervisorFollowUps_FallSupervisorFollowUpSupervisorName" Width="157px"
                                                    name="DropDownList_CustomIncidentReportFallSupervisorFollowUps_FallSupervisorFollowUpSupervisorName" runat="server" AddBlankRow="True"
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
                                                <textarea id="TextBox_CustomIncidentReportFallSupervisorFollowUps_FallSupervisorFollowUpFollowUp" class="form_textareaWithoutWidth"
                                                    name="TextBox_CustomIncidentReportFallSupervisorFollowUps_FallSupervisorFollowUpFollowUp" rows="4" cols="158" spellcheck="True"></textarea>
                                            </td>
                                        </tr>
                                         <tr>
                                            <td class="height2"></td>
                                        </tr>
                                        <tr>
                                            <td class="checkbox_container">
                                                <span id="Span5" class="form_label" name="SpanSupervisorFollowAdministratorNotified" style="padding-right: 22px;">Manager Notified</span>
                                                <input type="radio" id="RadioButton_CustomIncidentReportFallSupervisorFollowUps_SupervisorFollowUpManagerNotified_Y" value="Y"
                                                    name="RadioButton_CustomIncidentReportFallSupervisorFollowUps_SupervisorFollowUpManagerNotified"  onchange="SameManagerDTFall()" style="cursor: default"  />
                                                <label for="RadioButton_CustomIncidentReportFallSupervisorFollowUps_SupervisorFollowUpManagerNotified_Y" style="cursor: default; padding-right: 5px;">
                                                    Yes</label>
                                                <input type="radio" id="RadioButton_CustomIncidentReportFallSupervisorFollowUps_SupervisorFollowUpManagerNotified_N" value="N"
                                                    name="RadioButton_CustomIncidentReportFallSupervisorFollowUps_SupervisorFollowUpManagerNotified"  onchange="SameManagerDTFall()" style="cursor: default" />
                                                <label for="RadioButton_CustomIncidentReportFallSupervisorFollowUps_SupervisorFollowUpManagerNotified_N" style="cursor: default">
                                                    No</label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height2"></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <span id="Span6" name="SpanSupervisorFollowAdministrator" style="padding-right: 63px; padding-left: 3px;">Manager</span>
                                                <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentReportFallSupervisorFollowUps_SupervisorFollowUpManager" Width="157px"
                                                    name="DropDownList_CustomIncidentReportFallSupervisorFollowUps_SupervisorFollowUpManager" runat="server" AddBlankRow="True"
                                                    BlankRowText="" valuetype="">
                                                </cc3:StreamlineDropDowns>
                                                <span id="Span8" class="form_label" name="SpanSupervisorFollowAdminDateOfNotification" style="padding-left: 80px;">Date of notification</span>
                                                <input datatype="Date" type="text" id="TextBox_CustomIncidentReportFallSupervisorFollowUps_SupervisorFollowUpManagerDateOfNotification"
                                                    name="TextBox_CustomIncidentReportFallSupervisorFollowUps_SupervisorFollowUpManagerDateOfNotification" style="width: 67px; height: 15px; padding-right: 2px"
                                                    class="form_textbox" />
                                                <img id="img2" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                    onclick="return showCalendar('TextBox_CustomIncidentReportFallSupervisorFollowUps_SupervisorFollowUpManagerDateOfNotification', '%m/%d/%Y');" style="cursor: default; vertical-align: text-bottom;"
                                                    alt="Calendar" />
                                                <span id="Span9" class="form_label" name="SpanSupervisorFollowAdminTimeOfNotification" style="padding-left: 70px;">Time of Notification</span>
                                                <input type="text" name="TextBox_CustomIncidentReportFallSupervisorFollowUps_SupervisorFollowUpManagerTimeOfNotification"
                                                    id="TextBox_CustomIncidentReportFallSupervisorFollowUps_SupervisorFollowUpManagerTimeOfNotification"
                                                    onblur="TimeNotified(this)" bindautosaveevents="False" datatype="Time" style="width: 67px" class='form_textbox' />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height2"></td>
                                        </tr>
                                        <tr>
                                            <td class="checkbox_container">
                                                <span id="SpanAdministratorNotified" class="form_label" name="SpanAdministratorNotified" style="padding-right: 92px;">Administrator notified</span>
                                                <input type="radio" id="RadioButton_CustomIncidentReportFallSupervisorFollowUps_FallSupervisorFollowUpAdministratorNotified_Y" value="Y"
                                                    name="RadioButton_CustomIncidentReportFallSupervisorFollowUps_FallSupervisorFollowUpAdministratorNotified" style="cursor: default" onchange="IncidentSectionsShowHide();" />
                                                <label for="RadioButton_CustomIncidentReportFallSupervisorFollowUps_FallSupervisorFollowUpAdministratorNotified_Y" style="cursor: default; padding-right: 5px;">
                                                    Yes</label>
                                                <input type="radio" id="RadioButton_CustomIncidentReportFallSupervisorFollowUps_FallSupervisorFollowUpAdministratorNotified_N" value="N"
                                                    name="RadioButton_CustomIncidentReportFallSupervisorFollowUps_FallSupervisorFollowUpAdministratorNotified" style="cursor: default" onchange="IncidentSectionsShowHide();" />
                                                <label for="RadioButton_CustomIncidentReportFallSupervisorFollowUps_FallSupervisorFollowUpAdministratorNotified_N" style="cursor: default">
                                                    No</label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height2"></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <span id="Span25" name="SpanNurseStaffEvaluating" style="padding-right: 40px; padding-left: 3px;">Administrator</span>
                                                <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentReportFallSupervisorFollowUps_FallSupervisorFollowUpAdministrator" Width="157px"
                                                    name="DropDownList_CustomIncidentReportFallSupervisorFollowUps_FallSupervisorFollowUpAdministrator" runat="server" AddBlankRow="True"
                                                    BlankRowText="" valuetype="">
                                                </cc3:StreamlineDropDowns>
                                                <span id="Span1" class="form_label" name="SpanDON" style="padding-left: 80px;">Date of notification</span>
                                                <input datatype="Date" type="text" id="TextBox_CustomIncidentReportFallSupervisorFollowUps_FallSupervisorFollowUpAdminDateOfNotification"
                                                    name="TextBox_CustomIncidentReportFallSupervisorFollowUps_FallSupervisorFollowUpAdminDateOfNotification" style="width: 67px; height: 15px; padding-right: 2px"
                                                    class="form_textbox" />
                                                <img id="img4" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                    onclick="return showCalendar('TextBox_CustomIncidentReportFallSupervisorFollowUps_FallSupervisorFollowUpAdminDateOfNotification', '%m/%d/%Y');" style="cursor: default; vertical-align: text-bottom;"
                                                    alt="Calendar" />
                                                <span id="Span2" class="form_label" name="SpanTON" style="padding-left: 70px;">Time of Notification</span>
                                                <input type="text" name="TextBox_CustomIncidentReportFallSupervisorFollowUps_FallSupervisorFollowUpAdminTimeOfNotification" id="TextBox_CustomIncidentReportFallSupervisorFollowUps_FallSupervisorFollowUpAdminTimeOfNotification"
                                                    onblur="TimeNotified(this)" bindautosaveevents="False" datatype="Time" style="width: 67px" class='form_textbox' />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height2"></td>
                                        </tr>
                                        <tr>
                                            <td class="checkbox_container">
                                                <span id="Span29" class="form_label" name="SpanIndividual" style="padding-right: 20px;">Family/Guardian/Custodian notified?</span>

                                                <input type="radio" id="RadioButton_CustomIncidentReportFallSupervisorFollowUps_FallSupervisorFollowUpFamilyGuardianCustodianNotified_Y" value="Y"
                                                    name="RadioButton_CustomIncidentReportFallSupervisorFollowUps_FallSupervisorFollowUpFamilyGuardianCustodianNotified" style="cursor: default" />
                                                <label for="RadioButton_CustomIncidentReportFallSupervisorFollowUps_FallSupervisorFollowUpFamilyGuardianCustodianNotified_Y" style="cursor: default; padding-right: 5px;">
                                                    Yes</label>
                                                <input type="radio" id="RadioButton_CustomIncidentReportFallSupervisorFollowUps_FallSupervisorFollowUpFamilyGuardianCustodianNotified_N" value="N"
                                                    name="RadioButton_CustomIncidentReportFallSupervisorFollowUps_FallSupervisorFollowUpFamilyGuardianCustodianNotified" style="cursor: default" />
                                                <label for="RadioButton_CustomIncidentReportFallSupervisorFollowUps_FallSupervisorFollowUpFamilyGuardianCustodianNotified_N" style="cursor: default">
                                                    No</label>

                                                <span id="SpanFGCDON" class="form_label" name="SpanFGCDON" style="padding-left: 71px;">Date of notification</span>
                                                <input datatype="Date" type="text" id="TextBox_CustomIncidentReportFallSupervisorFollowUps_FallSupervisorFollowUpFGCDateOfNotification"
                                                    name="TextBox_CustomIncidentReportFallSupervisorFollowUps_FallSupervisorFollowUpFGCDateOfNotification" style="width: 67px; height: 15px; padding-right: 2px"
                                                    class="form_textbox" />
                                                <img id="img5" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                    onclick="return showCalendar('TextBox_CustomIncidentReportFallSupervisorFollowUps_FallSupervisorFollowUpFGCDateOfNotification', '%m/%d/%Y');" style="cursor: default; vertical-align: text-bottom;"
                                                    alt="Calendar" />
                                                <span id="SpanFGCTON" class="form_label" name="SpanFGCTON" style="padding-left: 70px;">Time of Notification</span>
                                                <input type="text" name="TextBox_CustomIncidentReportFallSupervisorFollowUps_FallSupervisorFollowUpFGCTimeOfNotification" id="TextBox_CustomIncidentReportFallSupervisorFollowUps_FallSupervisorFollowUpFGCTimeOfNotification"
                                                    onblur="TimeNotified(this)" bindautosaveevents="False" datatype="Time" style="width: 67px" class='form_textbox' />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height2"></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <span id="Span36" class="form_label" name="SpanIndividual" style="padding-right: 10px;">Staff who completed Notification</span>
                                                <%--<input type="text" class="form_textarea" style="width: 150px;"  id="TextBox_CustomIncidentReportFallSupervisorFollowUps_FallSupervisorFollowUpStaffCompletedNotification"
                                                    name="TextBox_CustomIncidentReportFallSupervisorFollowUps_FallSupervisorFollowUpStaffCompletedNotification" />--%>
                                                 <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentReportFallSupervisorFollowUps_FallSupervisorFollowUpStaffCompletedNotification" Width="150px"
                                                    name="DropDownList_CustomIncidentReportFallSupervisorFollowUps_FallSupervisorFollowUpStaffCompletedNotification" runat="server" AddBlankRow="True"
                                                    BlankRowText="" valuetype="">
                                                </cc3:StreamlineDropDowns>
                                                <span id="Span37" class="form_label" name="SpanIndividual" style="padding-left: 66px; padding-right: 11px;">Name of the family/guardian/custodian notified</span>
                                                <input type="text" class="form_textarea" style="width: 150px;"  id="TextBox_CustomIncidentReportFallSupervisorFollowUps_FallSupervisorFollowUpNameOfFamilyGuardianCustodian"
                                                    name="TextBox_CustomIncidentReportFallSupervisorFollowUps_FallSupervisorFollowUpNameOfFamilyGuardianCustodian" />
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
                                                <textarea id="TextBox_CustomIncidentReportFallSupervisorFollowUps_FallSupervisorFollowUpDetailsOfNotification" class="form_textareaWithoutWidth"
                                                    name="TextBox_CustomIncidentReportFallSupervisorFollowUps_FallSupervisorFollowUpDetailsOfNotification" rows="4" cols="158" spellcheck="True"></textarea>
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
                                                            <input type="button" id="ButtonFallSupervisorFollowUpSign" name="ButtonFallSupervisorFollowUpSign" value="Sign" onclick="DetailsSignDocument('FallSupervisorFollowUp');" class="less_detail_btn_new" />
                                                        </td>
                                                        <td width="8%">
                                                            <span id="Span31" class="form_label" name="SpanSignedBy">Signed By:</span>
                                                        </td>
                                                        <td width="50%">
                                                            <span id="SpanSignedByFallSupervisor" class="form_label_text" name="SpanSignedByFallSupervisor"></span>
                                                        </td>
                                                        <td width="10%">
                                                            <span id="Span33" class="form_label" name="SpanDateSigned">Date Signed:</span>
                                                        </td>
                                                        <td width="22%">
                                                            <span id="Span_DateSignedFallSupervisor" class="form_label_text" name="Span_DateSignedFallSupervisor"></span>
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
                                    <table border="0" cellpadding="0" cellspacing="0" width="100%" style="margin-bottom: 20px;" id="FallManagerFollowUpTable">
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
                                                            <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentReportFallManagerFollowUps_ManagerFollowUpManagerId" Width="157px"
                                                                name="DropDownList_CustomIncidentReportFallManagerFollowUps_ManagerFollowUpManagerId" runat="server" AddBlankRow="True"
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
                                                            <input type="radio" id="RadioButton_CustomIncidentReportFallManagerFollowUps_ManagerFollowUpAdministratorNotified_Y" value="Y"
                                                                name="RadioButton_CustomIncidentReportFallManagerFollowUps_ManagerFollowUpAdministratorNotified" style="cursor: default"  onchange="IncidentSectionsShowHide();"/>
                                                            <label for="RadioButton_CustomIncidentReportFallManagerFollowUps_ManagerFollowUpAdministratorNotified_Y" style="cursor: default; padding-right: 5px;">
                                                                Yes</label>
                                                            <input type="radio" id="RadioButton_CustomIncidentReportFallManagerFollowUps_ManagerFollowUpAdministratorNotified_N" value="N"
                                                                name="RadioButton_CustomIncidentReportFallManagerFollowUps_ManagerFollowUpAdministratorNotified" style="cursor: default" onchange="IncidentSectionsShowHide();"/>
                                                            <label for="RadioButton_CustomIncidentReportFallManagerFollowUps_ManagerFollowUpAdministratorNotified_N" style="cursor: default">
                                                                No</label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <span id="Span10" name="SpanSupervisorFollowAdministrator" style="padding-right: 63px; padding-left: 3px;">Administrator</span>
                                                            <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentReportFallManagerFollowUps_ManagerFollowUpAdministrator" Width="157px"
                                                                name="DropDownList_CustomIncidentReportFallManagerFollowUps_ManagerFollowUpAdministrator" runat="server" AddBlankRow="True"
                                                                BlankRowText="" valuetype="">
                                                            </cc3:StreamlineDropDowns>
                                                            <span id="Span30" class="form_label" name="SpanSupervisorFollowAdminDateOfNotification" style="padding-left: 80px;">Date of notification</span>
                                                            <input datatype="Date" type="text" id="TextBox_CustomIncidentReportFallManagerFollowUps_ManagerFollowUpAdminDateOfNotification"
                                                                name="TextBox_CustomIncidentReportFallManagerFollowUps_ManagerFollowUpAdminDateOfNotification" style="width: 67px; height: 15px; padding-right: 2px"
                                                                class="form_textbox" />
                                                            <img id="img6" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                onclick="return showCalendar('TextBox_CustomIncidentReportFallManagerFollowUps_ManagerFollowUpAdminDateOfNotification', '%m/%d/%Y');" style="cursor: default; vertical-align: text-bottom;"
                                                                alt="Calendar" />
                                                            <span id="Span11" class="form_label" name="SpanSupervisorFollowAdminTimeOfNotification" style="padding-left: 70px;">Time of Notification</span>
                                                            <input type="text" name="TextBox_CustomIncidentReportFallManagerFollowUps_ManagerFollowUpAdminTimeOfNotification"
                                                                id="TextBox_CustomIncidentReportFallManagerFollowUps_ManagerFollowUpAdminTimeOfNotification"
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
                                                            <textarea id="TextBox_CustomIncidentReportFallManagerFollowUps_ManagerReviewFollowUp" class="form_textareaWithoutWidth"
                                                                name="TextBox_CustomIncidentReportFallManagerFollowUps_ManagerReviewFollowUp" rows="4" cols="158" spellcheck="True"></textarea>
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
                                                                        <input type="button" id="ButtonCustomIncidentReportFallManagerFollowUpSign" name="ButtonCustomIncidentReportFallManagerFollowUpSign" value="Sign" onclick="DetailsSignDocument('FallManagerFollowUp');" class="less_detail_btn_new" />
                                                                    </td>
                                                                    <td width="8%">
                                                                        <span id="Span26" class="form_label" name="SpanSignedBy">Signed By:</span>
                                                                    </td>
                                                                    <td width="50%">
                                                                        <span id="SpanSignedByIncidentReportFallManagerFollowUp" class="form_label_text" name="SpanSignedByIncidentReportManagerFollowUp"></span>
                                                                    </td>
                                                                    <td width="10%">
                                                                        <span id="Span28" class="form_label" name="SpanDateSigned">Date Signed:</span>
                                                                    </td>
                                                                    <td width="22%">
                                                                        <span id="Span_DateSignedIncidentReportFallManagerFollowUp" class="form_label_text" name="Span_DateSignedIncidentReportManagerFollowUp"></span>
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
                        <table border="0" cellpadding="0" cellspacing="0" width="100%" style="margin-bottom: 20px;" id="FallAdministrator">
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
                                                <span id="SpanAdmin" name="SpanAdmin" style="padding-right: 40px;">Administrator</span>
                                                <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentReportFallAdministratorReviews_FallAdministratorReviewAdministrator" Width="157px"
                                                    name="DropDownList_CustomIncidentReportFallAdministratorReviews_FallAdministratorReviewAdministrator" runat="server" AddBlankRow="True"
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
                                                <textarea id="TextBox_CustomIncidentReportFallAdministratorReviews_FallAdministratorReviewAdministrativeReview" class="form_textareaWithoutWidth"
                                                    name="TextBox_CustomIncidentReportFallAdministratorReviews_FallAdministratorReviewAdministrativeReview" rows="4" cols="158" spellcheck="True"></textarea>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height2"></td>
                                        </tr>
                                        <tr>
                                            <td class="checkbox_container">
                                                <span id="Spanfilled" class="form_label" name="Spanfilled" style="padding-right: 20px;">Filed reportable Incident?</span>
                                                <input type="radio" id="RadioButton_CustomIncidentReportFallAdministratorReviews_FallAdministratorReviewFiledReportableIncident_Y" value="Y"
                                                    name="RadioButton_CustomIncidentReportFallAdministratorReviews_FallAdministratorReviewFiledReportableIncident" style="cursor: default" />
                                                <label for="RadioButton_CustomIncidentReportFallAdministratorReviews_FallAdministratorReviewFiledReportableIncident_Y" style="cursor: default; padding-right: 5px;">
                                                    Yes</label>
                                                <input type="radio" id="RadioButton_CustomIncidentReportFallAdministratorReviews_FallAdministratorReviewFiledReportableIncident_N" value="N"
                                                    name="RadioButton_CustomIncidentReportFallAdministratorReviews_FallAdministratorReviewFiledReportableIncident" style="cursor: default" />
                                                <label for="RadioButton_CustomIncidentReportFallAdministratorReviews_FallAdministratorReviewFiledReportableIncident_N" style="cursor: default; padding-right: 5px;">
                                                    No</label>
                                                <input type="radio" id="RadioButton_CustomIncidentReportFallAdministratorReviews_FallAdministratorReviewFiledReportableIncident_O" value="O"
                                                    name="RadioButton_CustomIncidentReportFallAdministratorReviews_FallAdministratorReviewFiledReportableIncident" style="cursor: default" />
                                                <label for="RadioButton_CustomIncidentReportFallAdministratorReviews_FallAdministratorReviewFiledReportableIncident_O" style="cursor: default">
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
                                                <textarea id="TextBox_CustomIncidentReportFallAdministratorReviews_FallAdministratorReviewComments" class="form_textareaWithoutWidth"
                                                    name="TextBox_CustomIncidentReportFallAdministratorReviews_FallAdministratorReviewComments" rows="4" cols="158" spellcheck="True"></textarea>
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
                                                            <input type="button" id="ButtonFallAdministratorReviewSign" name="ButtonFallAdministratorReviewSign" value="Sign" onclick="DetailsSignDocument('FallAdministrators');" class="less_detail_btn_new" />
                                                        </td>
                                                        <td width="8%">
                                                            <span id="Span48" class="form_label" name="SpanSignedBy">Signed By:</span>
                                                        </td>
                                                        <td width="50%">
                                                            <span id="SpanSignedByFallAdministrator" class="form_label_text" name="SpanSignedByFallAdministrator"></span>
                                                        </td>
                                                        <td width="10%">
                                                            <span id="Span50" class="form_label" name="SpanDateSigned">Date Signed:</span>
                                                        </td>
                                                        <td width="22%">
                                                            <span id="Span_DateSignedFallAdministrator" class="form_label_text" name="Span_DateSignedFallAdministrator"></span>
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

