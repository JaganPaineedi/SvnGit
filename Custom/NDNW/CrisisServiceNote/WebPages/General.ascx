<%@ Control Language="C#" AutoEventWireup="true" CodeFile="General.ascx.cs" Inherits="SHS.SmartCare.ActivityPages_Client_CMDocuments_General" %>
<% if (HttpContext.Current == null)
   { %>
<link href="../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet" type="text/css" />
<%} %>
<div style="overflow-x: hidden">
    <table cellpadding="0" cellspacing="0" style="width:100%">
        <tr>
            <td>
                <table border="0" cellpadding="0" cellspacing="0" width="99%">
                    <tr>
                        <td class="height2">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td style="width: 60%;">
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr>
                                                <td>
                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                            <td class="content_tab_left" align="left" width="22%">
                                                                General
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
                                                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                        <tr>
                                                            <td>
                                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                    <tr>
                                                                        <td align="left" style="width: 20%; padding-left: 7px;">
                                                                            <span id="Span$$CustomAcuteServicesPrescreens$$DateOfPrescreen" class="form_label">Date</span>
                                                                        </td>
                                                                        <td align="left" class="LPadd5">
                                                                            <table cellpadding="0" cellspacing="0" border="0">
                                                                                <tr>
                                                                                    <td>
                                                                                        <input type="text" class="date_text" id="TextBox_CustomAcuteServicesPrescreens_DateOfPrescreen"
                                                                                            name="TextBox_CustomAcuteServicesPrescreens_DateOfPrescreen" datatype="Date" />
                                                                                    </td>
                                                                                    <td>
                                                                                        &nbsp;
                                                                                    </td>
                                                                                    <td>
                                                                                        <img style="cursor: default" id="img_TextBox_CustomAcuteServicesPrescreens_DateOfPrescreen"
                                                                                            src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif" onclick="return showCalendar('TextBox_CustomAcuteServicesPrescreens_DateOfPrescreen', '%m/%d/%Y');"
                                                                                            alt="calendar" />
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
                                                            <td align="left" style="padding-left: 7px; width: 38%;">
                                                                <span class="form_label">Face to Face Time</span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td align="left" style="width: 38%; padding-left: 7px;">
                                                                <span id="Span$$CustomAcuteServicesPrescreens$$InitialCallTime" class="form_label">1.
                                                                    Initial Call Time</span>
                                                            </td>
                                                            <td class="LPadd2" style="width: 30%;">
                                                                <table cellpadding="0" cellspacing="0" border="0">
                                                                    <tr>
                                                                        <td>
                                                                            <input type="text" class="date_text" id="TextBox_CustomAcuteServicesPrescreens_InitialCallTime"
                                                                                name="TextBox_CustomAcuteServicesPrescreens_InitialCallTime" datatype="Date" />
                                                                        </td>
                                                                        <td>
                                                                            &nbsp;
                                                                        </td>
                                                                        <td>
                                                                            <img style="cursor: default" id="img_TextBox_CustomAcuteServicesPrescreens_InitialCallDate"
                                                                                src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif" onclick="return showCalendar('TextBox_CustomAcuteServicesPrescreens_InitialCallTime', '%m/%d/%Y');"
                                                                                alt="calendar" />
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td class="LPadd2" style="width: 10%;" colspan="2">
                                                                <input type="text" class="form_textbox" id="TextBoxTime_CustomAcuteServicesPrescreens_InitialCallTime"
                                                                    name="TextBoxTime_CustomAcuteServicesPrescreens_InitialCallTime" size="10" datatype="Time" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td align="left" colspan="5" style="padding-left: 7px;">
                                                                <span class="form_label">(Time of initial call from the referral source)</span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td align="left" style="padding-left: 7px;">
                                                                <span id="Span$$CustomAcuteServicesPrescreens$$ClientAvailableTimeForScreen" class="form_label">
                                                                    2. Consumer available for screen</span>
                                                            </td>
                                                            <td class="LPadd2">
                                                                <table cellpadding="0" cellspacing="0" border="0">
                                                                    <tr>
                                                                        <td>
                                                                            <input type="text" class="date_text" id="TextBox_CustomAcuteServicesPrescreens_ClientAvailableTimeForScreen"
                                                                                name="TextBox_CustomAcuteServicesPrescreens_ClientAvailableTimeForScreen" datatype="Date"
                                                                                onchange="dateDiff()" />
                                                                        </td>
                                                                        <td>
                                                                            &nbsp;
                                                                        </td>
                                                                        <td>
                                                                            <img style="cursor: default" id="img_TextBox_CustomAcuteServicesPrescreens_ClientAvailableTimeForScreen"
                                                                                src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif" onclick="return showCalendar('TextBox_CustomAcuteServicesPrescreens_ClientAvailableTimeForScreen', '%m/%d/%Y');"
                                                                                alt="calendar" />
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td class="LPadd2" colspan="2">
                                                                <input type="text" class="form_textbox" id="TextBoxTime_CustomAcuteServicesPrescreens_ClientAvailableTimeForScreen"
                                                                    name="TextBoxTime_CustomAcuteServicesPrescreens_ClientAvailableTimeForScreen"
                                                                    size="10" datatype="Time" onchange="dateDiff()"/>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td align="left" colspan="5" style="padding-left: 10px;">
                                                                <span class="form_label_dfa">(Time when customer presents or requests screening and
                                                                    is medically cleared – Consumer available time can be the same as Initial Call Time)</span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td align="left" style="padding-left: 7px;">
                                                                <span id="Span$$CustomAcuteServicesPrescreens$$DispositionTime" class="form_label">3.
                                                                    Disposition Time</span>
                                                            </td>
                                                            <td class="LPadd2">
                                                                <table cellpadding="0" cellspacing="0" border="0">
                                                                    <tr>
                                                                        <td>
                                                                            <input type="text" class="date_text" id="TextBox_CustomAcuteServicesPrescreens_DispositionTime"
                                                                                name="TextBox_CustomAcuteServicesPrescreens_DispositionTime" datatype="Date"
                                                                                onchange="dateDiff()" />
                                                                        </td>
                                                                        <td>
                                                                            &nbsp;
                                                                        </td>
                                                                        <td>
                                                                            <img style="cursor: default" id="img_TextBox_CustomAcuteServicesPrescreens_DispositionTime"
                                                                                src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif" onclick="return showCalendar('TextBox_CustomAcuteServicesPrescreens_DispositionTime', '%m/%d/%Y');"
                                                                                alt="calendar" />
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td class="LPadd2" colspan="2">
                                                                <input type="text" class="form_textbox" id="TextBoxTime_CustomAcuteServicesPrescreens_DispositionTime"
                                                                    name="TextBoxTime_CustomAcuteServicesPrescreens_DispositionTime" size="10" datatype="Time" onchange="dateDiff()" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2" colspan="5">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td align="left" colspan="5" style="padding-left: 7px;">
                                                                <span class="form_label">(Time when prescreener has made a decision about the level
                                                                    of care to be authorized)</span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2" colspan="5">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td align="left" style="padding-left: 7px;">
                                                                <span class="form_label">4. Elapsed Time</span>
                                                            </td>
                                                            <td class="LPadd2">
                                                                <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                                    <tr>
                                                                        <td style="width: 45%;">
                                                                            <input type="text" class="form_textbox" id="TextBox_CustomAcuteServicesPrescreens_ElapsedHours"
                                                                                name="TextBox_CustomAcuteServicesPrescreens_ElapsedHours" size="10" disabled="disabled"
                                                                                datatype="Numeric" style="width: 70px" />
                                                                        </td>
                                                                        <td style="padding-left: 1px;">
                                                                            <span id="Span$$CustomAcuteServicesPrescreens$$ElapsedHours" class="form_label">hours</span>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td class="LPadd2">
                                                                <input type="text" class="form_textbox" id="TextBox_CustomAcuteServicesPrescreens_ElapsedMinutes"
                                                                    name="TextBox_CustomAcuteServicesPrescreens_ElapsedMinutes" class="form_textbox"
                                                                    size="10" disabled="disabled" datatype="Numeric" />
                                                            </td>
                                                            <td style="padding-left: 1px;">
                                                                <span id="Span$$CustomAcuteServicesPrescreens$$ElapsedMinutes" class="form_label">minutes</span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td align="left" colspan="4" style="padding-left: 7px;">
                                                                <span class="form_label">(Length of time between items 2 and 3)</span>
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
                                    <td valign="top" class="LPadd5" style="width: 40%; padding-left: 10px;">
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr>
                                                <td>
                                                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                        <tr>
                                                            <td>
                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                        <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                                            Ethnicity
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
                                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                    <tr>
                                                                        <td align="left" style="padding-left: 8px;">
                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                <tr class="checkbox_container">
                                                                                    <td>
                                                                                        <input type="radio" id="RadioButton_CustomAcuteServicesPrescreens_ClientEthnicity_AF"
                                                                                            name="RadioButton_CustomAcuteServicesPrescreens_ClientEthnicity" value="AF" />
                                                                                    </td>
                                                                                    <td class="RadioText">
                                                                                        <label for="RadioButton_CustomAcuteServicesPrescreens_ClientEthnicity_AF">
                                                                                            African-American</label>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                        <td>
                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                <tr class="checkbox_container">
                                                                                    <td>
                                                                                        <input type="radio" id="RadioButton_CustomAcuteServicesPrescreens_ClientEthnicity_MR"
                                                                                            name="RadioButton_CustomAcuteServicesPrescreens_ClientEthnicity" value="MR" />
                                                                                    </td>
                                                                                    <td class="RadioText">
                                                                                        <label for="RadioButton_CustomAcuteServicesPrescreens_ClientEthnicity_MR">
                                                                                            Multiracial</label>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td align="left" style="padding-left: 8px;">
                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                <tr class="checkbox_container">
                                                                                    <td>
                                                                                        <input type="radio" id="RadioButton_CustomAcuteServicesPrescreens_ClientEthnicity_AR"
                                                                                            name="RadioButton_CustomAcuteServicesPrescreens_ClientEthnicity" value="AR" />
                                                                                    </td>
                                                                                    <td>
                                                                                        <label for="RadioButton_CustomAcuteServicesPrescreens_ClientEthnicity_AR">
                                                                                            Arab-American</label>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                        <td>
                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                <tr class="checkbox_container">
                                                                                    <td>
                                                                                        <input type="radio" id="RadioButton_CustomAcuteServicesPrescreens_ClientEthnicity_NA"
                                                                                            name="RadioButton_CustomAcuteServicesPrescreens_ClientEthnicity" value="NA" />
                                                                                    </td>
                                                                                    <td>
                                                                                        <label for="RadioButton_CustomAcuteServicesPrescreens_ClientEthnicity_NA">
                                                                                            Native American</label>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td align="left" style="padding-left: 8px;">
                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                <tr class="checkbox_container">
                                                                                    <td>
                                                                                        <input type="radio" id="RadioButton_CustomAcuteServicesPrescreens_ClientEthnicity_AS"
                                                                                            name="RadioButton_CustomAcuteServicesPrescreens_ClientEthnicity" value="AS" />
                                                                                    </td>
                                                                                    <td>
                                                                                        <label for="RadioButton_CustomAcuteServicesPrescreens_ClientEthnicity_AS">
                                                                                            Asian-American</label>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                        <td>
                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                <tr class="checkbox_container">
                                                                                    <td>
                                                                                        <input type="radio" id="RadioButton_CustomAcuteServicesPrescreens_ClientEthnicity_HI"
                                                                                            name="RadioButton_CustomAcuteServicesPrescreens_ClientEthnicity" value="HI" />
                                                                                    </td>
                                                                                    <td>
                                                                                        <label for="RadioButton_CustomAcuteServicesPrescreens_ClientEthnicity_HI">
                                                                                            Hispanic</label>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td align="left" style="padding-left: 8px;">
                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                <tr class="checkbox_container">
                                                                                    <td>
                                                                                        <input type="radio" id="RadioButton_CustomAcuteServicesPrescreens_ClientEthnicity_CA"
                                                                                            name="RadioButton_CustomAcuteServicesPrescreens_ClientEthnicity" value="CA" />
                                                                                    </td>
                                                                                    <td>
                                                                                        <label for="RadioButton_CustomAcuteServicesPrescreens_ClientEthnicity_CA">
                                                                                            Caucasian</label>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                        <td>
                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                <tr class="checkbox_container">
                                                                                    <td>
                                                                                        <input type="radio" id="RadioButton_CustomAcuteServicesPrescreens_ClientEthnicity_OR"
                                                                                            name="RadioButton_CustomAcuteServicesPrescreens_ClientEthnicity" value="OR" />
                                                                                    </td>
                                                                                    <td>
                                                                                        <label for="RadioButton_CustomAcuteServicesPrescreens_ClientEthnicity_OR">
                                                                                            Other/refused</label>
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
                                                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                        <tr>
                                                            <td>
                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                        <td class="content_tab_left" align="left" width="32%" nowrap="nowrap">
                                                                            CMH Status
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
                                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                    <tr>
                                                                        <td style="width: 47%; padding-left: 8px;" align="left">
                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                <tr class="checkbox_container">
                                                                                    <td>
                                                                                        <input type="radio" id="RadioButton_CustomAcuteServicesPrescreens_CMHStatus_O" name="RadioButton_CustomAcuteServicesPrescreens_CMHStatus"
                                                                                            value="O" onclick="EnableDisableDropDown();" />
                                                                                    </td>
                                                                                    <td>
                                                                                        <label for="RadioButton_CustomAcuteServicesPrescreens_CMHStatus_O">
                                                                                            Open</label>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td align="left" style="width: 47%; padding-left: 7px;">
                                                                            <span class="form_label">Optional: Primary Clinicians</span>
                                                                        </td>
                                                                        <td style="width: 52%; padding-right: 10px;">
                                                                            <asp:DropDownList EnableViewState="false" ID="DropDownList_CustomAcuteServicesPrescreens_CMHStatusPrimaryClinician"
                                                                                runat="server" CssClass="form_dropdown" Width="100%" disabled="disabled">
                                                                            </asp:DropDownList>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td align="left" style="padding-left: 8px;">
                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                <tr class="checkbox_container">
                                                                                    <td>
                                                                                        <input type="radio" id="RadioButton_CustomAcuteServicesPrescreens_CMHStatus_C" name="RadioButton_CustomAcuteServicesPrescreens_CMHStatus"
                                                                                            value="C" onclick="EnableDisableDropDown();" />
                                                                                    </td>
                                                                                    <td>
                                                                                        <label for="RadioButton_CustomAcuteServicesPrescreens_CMHStatus_C">
                                                                                            Closed</label>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td align="left" style="padding-left: 8px;">
                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                <tr class="checkbox_container">
                                                                                    <td>
                                                                                        <input type="radio" id="RadioButton_CustomAcuteServicesPrescreens_CMHStatus_N" name="RadioButton_CustomAcuteServicesPrescreens_CMHStatus"
                                                                                            value="N" onclick="EnableDisableDropDown();" />
                                                                                    </td>
                                                                                    <td>
                                                                                        <label for="RadioButton_CustomAcuteServicesPrescreens_CMHStatus_N">
                                                                                            New</label>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td align="left" style="padding-left: 8px;">
                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                <tr class="checkbox_container">
                                                                                    <td>
                                                                                        <input type="radio" id="RadioButton_CustomAcuteServicesPrescreens_CMHStatus_P" name="RadioButton_CustomAcuteServicesPrescreens_CMHStatus"
                                                                                            value="P" onclick="EnableDisableDropDown();" />
                                                                                    </td>
                                                                                    <td>
                                                                                        <label for="RadioButton_CustomAcuteServicesPrescreens_CMHStatus_P">
                                                                                            Pending</label>
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
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td>
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                    Demographics
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
                                        <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                            <tr>
                                                <td colspan="2">
                                                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                        <tr>
                                                            <td style="padding-left: 7px;">
                                                                <span id="Span$$CustomAcuteServicesPrescreens$$CMHCaseNumber" class="form_label">CMH
                                                                    Case #</span>
                                                            </td>
                                                            <td>
                                                                <input type="text" class="form_textbox" id="TextBox_CustomAcuteServicesPrescreens_CMHCaseNumber"
                                                                    name="TextBox_CustomAcuteServicesPrescreens_CMHCaseNumber" datatype="String"
                                                                    maxlength="20" />
                                                            </td>
                                                            <td style="width: 10px">
                                                            </td>
                                                            <td colspan="3">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="6" class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="padding-left: 3px">
                                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                    <tr>
                                                                        <td align="left">
                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                <tr class="checkbox_container">
                                                                                    <td>
                                                                                        <input type="radio" id="RadioButtonList_CustomAcuteServicesPrescreens_ClientSex_M"
                                                                                            name="RadioButtonList_CustomAcuteServicesPrescreens_ClientSex" value="M" style="padding-left: 5px;" />
                                                                                    </td>
                                                                                    <td>
                                                                                        <label for="RadioButtonList_CustomAcuteServicesPrescreens_ClientSex_M">
                                                                                            Male</label>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input type="radio" id="RadioButtonList_CustomAcuteServicesPrescreens_ClientSex_F"
                                                                                            name="RadioButtonList_CustomAcuteServicesPrescreens_ClientSex" value="F" style="padding-left: 5px;" />
                                                                                    </td>
                                                                                    <td>
                                                                                        <label for="RadioButtonList_CustomAcuteServicesPrescreens_ClientSex_F">
                                                                                            Female</label>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td>
                                                            </td>
                                                            <td style="width: 10px">
                                                            </td>
                                                            <td colspan="4">
                                                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                                    <tr>
                                                                        <td align="left">
                                                                            <table cellspacing="0" cellpadding="0" border="0">
                                                                                <tr class="checkbox_container">
                                                                                    <td>
                                                                                        <input type="radio" id="CustomAcuteServicesPrescreens_ClientMaritalStatus_SI" name="CustomAcuteServicesPrescreens_ClientMaritalStatus"
                                                                                            value="SI" style="padding-left: 4px" />
                                                                                    </td>
                                                                                    <td class="RadioText">
                                                                                        <label for="CustomAcuteServicesPrescreens_ClientMaritalStatus_SI" class="form_label">
                                                                                            Single</label>
                                                                                    </td>
                                                                                    <td>
                                                                                        &nbsp;
                                                                                    </td>
                                                                                    <td>
                                                                                        <input type="radio" id="CustomAcuteServicesPrescreens_ClientMaritalStatus_MA" name="CustomAcuteServicesPrescreens_ClientMaritalStatus"
                                                                                            value="MA" />
                                                                                    </td>
                                                                                    <td class="RadioText">
                                                                                        <label for="CustomAcuteServicesPrescreens_ClientMaritalStatus_MA" class="form_label">
                                                                                            Married</label>
                                                                                    </td>
                                                                                    <td>
                                                                                        &nbsp;
                                                                                    </td>
                                                                                    <td>
                                                                                        <input type="radio" id="CustomAcuteServicesPrescreens_ClientMaritalStatus_DI" name="CustomAcuteServicesPrescreens_ClientMaritalStatus"
                                                                                            value="DI" style="padding-left: 4px" />
                                                                                    </td>
                                                                                    <td class="RadioText">
                                                                                        <label for="CustomAcuteServicesPrescreens_ClientMaritalStatus_DI" class="form_label">
                                                                                            Divorced</label>
                                                                                    </td>
                                                                                    <td>
                                                                                        &nbsp;
                                                                                    </td>
                                                                                    <td>
                                                                                        <input type="radio" id="CustomAcuteServicesPrescreens_ClientMaritalStatus_SE" name="CustomAcuteServicesPrescreens_ClientMaritalStatus"
                                                                                            value="SE" style="padding-left: 4px" />
                                                                                    </td>
                                                                                    <td class="RadioText">
                                                                                        <label for="CustomAcuteServicesPrescreens_ClientMaritalStatus_SE" class="form_label">
                                                                                            Separated</label>
                                                                                    </td>
                                                                                    <td>
                                                                                        &nbsp;
                                                                                    </td>
                                                                                    <td>
                                                                                        <input type="radio" id="CustomAcuteServicesPrescreens_ClientMaritalStatus_WI" name="CustomAcuteServicesPrescreens_ClientMaritalStatus"
                                                                                            value="WI" style="padding-left: 4px" />
                                                                                    </td>
                                                                                    <td class="RadioText">
                                                                                        <label for="CustomAcuteServicesPrescreens_ClientMaritalStatus_WI" class="form_label">
                                                                                            Widowed</label>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="6" class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="padding-left: 7px;">
                                                                <span id="Span$$CustomAcuteServicesPrescreens$$ClientName" class="form_label">Name</span>
                                                            </td>
                                                            <td>
                                                                <input type="text" class="form_textbox" id="TextBox_CustomAcuteServicesPrescreens_ClientName"
                                                                    name="TextBox_CustomAcuteServicesPrescreens_ClientName" datatype="String" maxlength="100" />
                                                            </td>
                                                            <td style="width: 10px">
                                                            </td>
                                                            <td>
                                                                <span id="Span$$CustomAcuteServicesPrescreens$$ClientSSN" class="form_label">Social
                                                                    Security #</span>
                                                            </td>
                                                            <td>
                                                                <input type="text" class="form_textbox" id="TextBox_CustomAcuteServicesPrescreens_ClientSSN"
                                                                    name="TextBox_CustomAcuteServicesPrescreens_ClientSSN" datatype="SSN" />
                                                            </td>
                                                            <td>
                                                                <span id="Span$$CustomAcuteServicesPrescreens$$ClientDateOfBirth" class="form_label">
                                                                    DOB</span>
                                                            </td>
                                                            <td>
                                                                <table cellspacing="0" cellpadding="0" border="0">
                                                                    <tr>
                                                                        <td>
                                                                            <input type="text" class="date_text" id="TextBox_CustomAcuteServicesPrescreens_ClientDateOfBirth"
                                                                                name="TextBox_CustomAcuteServicesPrescreens_ClientDateOfBirth" datatype="Date" onblur="ValidateFutureDate('CustomAcuteServicesPrescreens','ClientDateOfBirth',this);" />
                                                                        </td>
                                                                        <td>
                                                                            &nbsp;
                                                                        </td>
                                                                        <td>
                                                                            <img style="cursor: default" id="img_ClientDateOfBirth" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                                onclick="return showCalendar('TextBox_CustomAcuteServicesPrescreens_ClientDateOfBirth', '%m/%d/%Y');"
                                                                                alt="calendar" />
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="6" class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="padding-left: 7px;">
                                                                <span id="Span$$CustomAcuteServicesPrescreens$$ClientAddress" class="form_label">Address</span>
                                                            </td>
                                                            <td>
                                                                <textarea style="width: 96%;" id="TextBox_CustomAcuteServicesPrescreens_ClientAddress"
                                                                    name="TextBox_CustomAcuteServicesPrescreens_ClientAddress" rows="2" cols="20"
                                                                    datatype="String" class="form_textarea" spellcheck="True">
                                                                 </textarea>
                                                            </td>
                                                            <td style="width: 10px">
                                                            </td>
                                                            <td>
                                                                <span id="Span$$CustomAcuteServicesPrescreens$$ClientCity" class="form_label">City</span>
                                                            </td>
                                                            <td>
                                                                <input type="text" class="form_textbox" id="TextBox_CustomAcuteServicesPrescreens_ClientCity"
                                                                    name="TextBox_CustomAcuteServicesPrescreens_ClientCity" datatype="String" maxlength="30" />
                                                            </td>
                                                            <td>
                                                                <span id="Span$$CustomAcuteServicesPrescreens$$ClientState" class="form_label">State</span>
                                                            </td>
                                                            <td style="padding-right: 3px">
                                                                <input type="text" class="form_textbox" id="TextBox_CustomAcuteServicesPrescreens_ClientState"
                                                                    name="TextBox_CustomAcuteServicesPrescreens_ClientState" datatype="String" maxlength="2" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="6" class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="padding-left: 7px;">
                                                                <span id="Span$$CustomAcuteServicesPrescreens$$ClientCounty" class="form_label">County
                                                                    of Residence</span>
                                                            </td>
                                                            <td>
                                                                <asp:DropDownList ID="DropDownList_CustomAcuteServicesPrescreens_ClientCounty" runat="server"
                                                                    EnableViewState="false" CssClass="form_dropdown">
                                                                </asp:DropDownList>
                                                            </td>
                                                            <td style="width: 10px">
                                                            </td>
                                                            <td>
                                                                <span id="Span$$CustomAcuteServicesPrescreens$$ClientHomePhone" class="form_label">Home
                                                                    Telephone</span>
                                                            </td>
                                                            <td>
                                                                <%--<input type="text" class="form_textbox" id="Text1"
                                                        name="TextBox_CustomAcuteServicesPrescreens_ClientHomePhone" datatype="PhoneNumber" maxlength="50" />--%>
                                                                <input type="text" class="form_textbox" id="TextBox_CustomAcuteServicesPrescreens_ClientHomePhone"
                                                                    name="TextBox_CustomAcuteServicesPrescreens_ClientHomePhone" datatype="PhoneNumber"
                                                                    maxlength="50" />
                                                            </td>
                                                            <td>
                                                                <span id="Span$$CustomAcuteServicesPrescreens$$ClientZip" class="form_label">Zip Code</span>
                                                            </td>
                                                            <td style="padding-right: 3px">
                                                                <input type="text" class="form_textbox" id="TextBox_CustomAcuteServicesPrescreens_ClientZip"
                                                                    name="TextBox_CustomAcuteServicesPrescreens_ClientZip" datatype="String" maxlength="12" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="6" class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="padding-left: 7px;">
                                                                <span id="Span$$CustomAcuteServicesPrescreens$$ClientEmergencyContact" class="form_label">
                                                                    Emergency Contact</span>
                                                            </td>
                                                            <td>
                                                                <input type="text" class="form_textbox" id="TextBox_CustomAcuteServicesPrescreens_ClientEmergencyContact"
                                                                    name="TextBox_CustomAcuteServicesPrescreens_ClientEmergencyContact" datatype="String"
                                                                    maxlength="100" />
                                                            </td>
                                                            <td style="width: 10px">
                                                            </td>
                                                            <td>
                                                                <span id="Span$$CustomAcuteServicesPrescreens$$ClientEmergencyPhone" class="form_label">
                                                                    Phone</span>
                                                            </td>
                                                            <td>
                                                                <input type="text" class="form_textbox" id="TextBox_CustomAcuteServicesPrescreens_ClientEmergencyPhone"
                                                                    name="TextBox_CustomAcuteServicesPrescreens_ClientEmergencyPhone" datatype="PhoneNumber"
                                                                    maxlength="50" />
                                                            </td>
                                                            <td>
                                                                <span id="Span$$CustomAcuteServicesPrescreens$$ClientRelationship" class="form_label">
                                                                    Relationship</span>
                                                            </td>
                                                            <td style="padding-right: 10px">
                                                                <asp:DropDownList ID="DropDownList_CustomAcuteServicesPrescreens_ClientRelationship"
                                                                    runat="server" EnableViewState="false" CssClass="form_dropdown" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="6" class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="padding-left: 7px; padding-right: 10px">
                                                                <span id="Span$$CustomAcuteServicesPrescreens$$ClientGuardianName" class="form_label">
                                                                    Guardian/ Responsible Adult</span>
                                                            </td>
                                                            <td>
                                                                <input type="text" class="form_textbox" id="TextBox_CustomAcuteServicesPrescreens_ClientGuardianName"
                                                                    name="TextBox_CustomAcuteServicesPrescreens_ClientGuardianName" datatype="String"
                                                                    maxlength="100" />
                                                            </td>
                                                            <td style="width: 10px">
                                                            </td>
                                                            <td>
                                                                <span id="Span$$CustomAcuteServicesPrescreens$$ClientGuardianPhone" class="form_label">
                                                                    Phone</span>
                                                            </td>
                                                            <td>
                                                                <input type="text" class="form_textbox" id="TextBox_CustomAcuteServicesPrescreens_ClientGuardianPhone"
                                                                    name="TextBox_CustomAcuteServicesPrescreens_ClientGuardianPhone" datatype="PhoneNumber"
                                                                    maxlength="50" />
                                                            </td>
                                                            <td>
                                                            </td>
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
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr>
                                                <td style="width: 50%" valign="top">
                                                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                        <tr>
                                                            <td>
                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                        <td class="content_tab_left" align="left" width="55%">
                                                                            Reported Payment Source
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
                                                                <table border="0" cellpadding="0" cellspacing="5" width="100%">
                                                                    <tr>
                                                                        <td class="LPadd5">
                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                <tr class="checkbox_container">
                                                                                    <td>
                                                                                        <input type="checkbox" id="CheckBox_CustomAcuteServicesPrescreens_PaymentSourceIndigent" />
                                                                                    </td>
                                                                                    <td>
                                                                                        <label for="CheckBox_CustomAcuteServicesPrescreens_PaymentSourceIndigent">
                                                                                            Indigent</label>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="width: 23%" class="LPadd5">
                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                <tr class="checkbox_container">
                                                                                    <td>
                                                                                        <input type="checkbox" id="CheckBox_CustomAcuteServicesPrescreens_PaymentSourcePrivate" />
                                                                                    </td>
                                                                                    <td>
                                                                                        <label for="CheckBox_CustomAcuteServicesPrescreens_PaymentSourcePrivate">
                                                                                            Private Emp</label>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                        <td style="width: 30%">
                                                                            <input type="text" class="form_textbox" id="TextBox_CustomAcuteServicesPrescreens_PaymentSourcePrivateEmployer"
                                                                                name="TextBox_CustomAcuteServicesPrescreens_PaymentSourcePrivateEmployer" style="width: 80%"
                                                                                datatype="String" maxlength="100" />
                                                                        </td>
                                                                        <td style="width: 9%">
                                                                            <span class="form_label">#</span>
                                                                        </td>
                                                                        <td>
                                                                            <input type="text" class="form_textbox" id="TextBox_CustomAcuteServicesPrescreens_PaymentSourcePrivateNumber"
                                                                                name="TextBox_CustomAcuteServicesPrescreens_PaymentSourcePrivateNumber" style="width: 80%"
                                                                                datatype="String" maxlength="25" />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="LPadd5">
                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                <tr class="checkbox_container">
                                                                                    <td>
                                                                                        <input type="checkbox" id="CheckBox_CustomAcuteServicesPrescreens_PaymentSourceMedicare" />
                                                                                    </td>
                                                                                    <td>
                                                                                        <label for="CheckBox_CustomAcuteServicesPrescreens_PaymentSourceMedicare">
                                                                                            Medicare #</label>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                        <td>
                                                                            <input type="text" class="form_textbox" id="TextBox_CustomAcuteServicesPrescreens_PaymentSourceMedicareNumber"
                                                                                name="TextBox_CustomAcuteServicesPrescreens_PaymentSourceMedicareNumber" style="width: 80%"
                                                                                datatype="String" maxlength="25" />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="LPadd5">
                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                <tr class="checkbox_container">
                                                                                    <td>
                                                                                        <input type="checkbox" id="CheckBox_CustomAcuteServicesPrescreens_PaymentSourceMedicaid" />
                                                                                    </td>
                                                                                    <td>
                                                                                        <label for="CheckBox_CustomAcuteServicesPrescreens_PaymentSourceMedicaid">
                                                                                            Medicaid #</label>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                        <td>
                                                                            <input type="text" class="form_textbox" id="TextBox_CustomAcuteServicesPrescreens_PaymentSourceMedicaidNumber"
                                                                                name="TextBox_CustomAcuteServicesPrescreens_PaymentSourceMedicaidNumber" style="width: 80%"
                                                                                datatype="String" maxlength="25" />
                                                                        </td>
                                                                        <td>
                                                                            <span class="form_label">Type</span>
                                                                        </td>
                                                                        <td>
                                                                            <input type="text" class="form_textbox" id="TextBox_CustomAcuteServicesPrescreens_PaymentSourceMedicaidType"
                                                                                name="TextBox_CustomAcuteServicesPrescreens_PaymentSourceMedicaidType" style="width: 80%"
                                                                                datatype="String" maxlength="25" />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="4" style="padding-left: 3px;">
                                                                            <span class="form_label">Please document if Medicaid is from another county</span>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="4" style="padding-right: 10px;" class="LPadd5">
                                                                            <textarea class="form_textareaWithoutWidth" id="TextArea_CustomAcuteServicesPrescreens_PaymentMedicaidOtherCounty"
                                                                                name="TextArea_CustomAcuteServicesPrescreens_PaymentMedicaidOtherCounty" rows="2"
                                                                                cols="65" datatype="String" spellcheck="True">
                                                                                </textarea>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="LPadd5">
                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                <tr class="checkbox_container">
                                                                                    <td>
                                                                                        <input type="checkbox" id="CheckBox_CustomAcuteServicesPrescreens_PaymentSourceVA" />
                                                                                    </td>
                                                                                    <td>
                                                                                        <label for="CheckBox_CustomAcuteServicesPrescreens_PaymentSourceVA">
                                                                                            VA</label>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="2" class="LPadd5">
                                                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                                <tr>
                                                                                    <td>
                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                            <tr class="checkbox_container">
                                                                                                <td>
                                                                                                    <input type="checkbox" id="CheckBox_CustomAcuteServicesPrescreens_PaymentSourceOther" />
                                                                                                </td>
                                                                                                <td>
                                                                                                    <label for="CheckBox_CustomAcuteServicesPrescreens_PaymentSourceOther">
                                                                                                        Other</label>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input type="text" class="form_textbox" id="TextBox_CustomAcuteServicesPrescreens_PaymentSourceOtherDescribe"
                                                                                            name="TextBox_CustomAcuteServicesPrescreens_PaymentSourceOtherDescribe" datatype="String"
                                                                                            maxlength="100" />
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="4" class="LPadd5">
                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                <tr class="checkbox_container">
                                                                                    <td>
                                                                                        <input type="checkbox" id="CheckBox_CustomAcuteServicesPrescreens_PaymentMedicaidVerified" />
                                                                                    </td>
                                                                                    <td>
                                                                                        <label for="CheckBox_CustomAcuteServicesPrescreens_PaymentMedicaidVerified">
                                                                                            Medicaid Verified (Call Mich. Access 888-696-3510)</label>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="4" class="LPadd2">
                                                                            <%--<span class="form_label">Venture Fax (269) 979-9728</span>--%>
                                                                            <span class="form_label">Make contact with PCP and MHP</span>
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
                                                <td style="width: 50%; padding-left: 10px;" valign="top">
                                                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                        <tr>
                                                            <td>
                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                        <td class="content_tab_left" align="left" width="60%">
                                                                            Service Requested by Consumer or Referral Source
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
                                                                <table style="height: 236px;" border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                    <tr>
                                                                        <td class="LPadd8 RPadd2">
                                                                            <textarea class="form_textareaWithoutWidth" id="TextArea_CustomAcuteServicesPrescreens_ServiceRequested"
                                                                                name="TextArea_CustomAcuteServicesPrescreens_ServiceRequested" rows="17" cols="72"
                                                                                datatype="String" spellcheck="True"></textarea>
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
                                                <td colspan="2" class="LPadd5">
                                                    <span class="form_label">Prov. ID SP 1700833555; RW 1033280763; BA 1952357410; VB 1003878554;
                                                        PI 1861430381 Prov. Type 21</span>
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
    <input type="hidden" bindautosaveevents="True" id="HiddenField_CustomAcuteServicesPrescreens_ElapsedHours"
        name="HiddenField_CustomAcuteServicesPrescreens_ElapsedHours" />
    <input type="hidden" bindautosaveevents="True" id="HiddenField_CustomAcuteServicesPrescreens_ElapsedMinutes"
        name="HiddenField_CustomAcuteServicesPrescreens_ElapsedMinutes" />
</div>
