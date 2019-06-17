<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CustomVocationalJobPlacementDetail.ascx.cs"
    Inherits="SHS.SmartCare.CustomVocationalJobPlacementDetail" %>
 
<%@ Register Assembly="Streamline.DotNetDropDownSubGlobalCodes" Namespace="Streamline.DotNetDropDownSubGlobalCodes"
    TagPrefix="cc5" %>
<%@ Register Assembly="Streamline.DotNetDropDowns" Namespace="Streamline.DotNetDropDowns"
    TagPrefix="cc2" %>

<script language="javascript" type="text/javascript" src="<%=RelativePath%>Custom/Scripts/CustomVocationalJobPlacementDetail.js" ></script>

<div style="width: 97%">
    <input id="HiddenField_CustomVocationalJobPlacements_CustomVocationalJobPlacementId"
        runat="server" type="hidden" />
    <input id="HiddenFieldPageTables" name="HiddenFieldPageTables" type="hidden" value="CustomVocationalJobPlacements" />
    <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td>
                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                    <tr>
                        <td class="content_tab_left" align="left" nowrap='nowrap'>
                            <span id="Span14">Placement</span>
                        </td>
                        <td width="17">
                            <img style="vertical-align: top;" height="26" width="17" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                        </td>
                        <td class="content_tab_top" width="100%">
                        </td>
                        <td width="7">
                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td class="content_tab_bg" style="padding-left: 7px">
                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td>
                            <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                <tr>
                                    <td>
                                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td width="12%">
                                                    <span class="form_label" id="Span2">Placed by:</span>
                                                </td>
                                                <td width="88%">
                                                    <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                        <tr>
                                                            <td width="17%">
                                                                <cc2:StreamlineDropDowns ID="DropDownList_CustomVocationalJobPlacements_PlacedBy"
                                                                    Name="DropDownList_CustomVocationalJobPlacements_PlacedBy" TabIndex="1" runat="server"
                                                                    BlankRowValue="-1" ValueType="System.Int32" Style="width: 99%">
                                                                </cc2:StreamlineDropDowns>
                                                            </td>
                                                            <td width="10%" align="right" style="padding-right: 2px">
                                                                <span class="form_label" id="Span1">Referred by:</span>
                                                            </td>
                                                            <td width="10%">
                                                                <%--<cc2:StreamlineDropDowns ID="DropDownList_GlobalCodes_CodeName" name="DropDownList_GlobalCodes_CodeName" 
                                                             runat="server" TabIndex="2" Width="100%">
                                                        </cc2:StreamlineDropDowns>--%>
                                                                <cc2:StreamlineDropDowns ID="DropDownList_CustomVocationalJobPlacements_ReferredBy"
                                                                    name="DropDownList_CustomVocationalJobPlacements_ReferredBy" runat="server" TabIndex="2"
                                                                    Width="99%" AddBlankRow="true" BlankRowText="" BlankRowValue="-1">
                                                                </cc2:StreamlineDropDowns>
                                                            </td>
                                                            <td width="21%" style="text-align: right">
                                                                <span class="form_label" id="Span3">Job Development Start Date:</span>
                                                            </td>
                                                            <td align="right" width="10%">
                                                                <input type="text" tabindex="3" name="TextBox_CustomVocationalJobPlacements_JobDevelopmentStartDate"
                                                                    class="date_text" id="TextBox_CustomVocationalJobPlacements_JobDevelopmentStartDate"
                                                                    tabindex="3" datatype="Date" />
                                                            </td>
                                                            <td align="left" width="5%" style="padding-left: 2px">
                                                                <img id="Img3" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                    onclick="return showCalendar('TextBox_CustomVocationalJobPlacements_JobDevelopmentStartDate', '%m/%d/%Y');"
                                                                    style="cursor: hand;" filter="false" />
                                                            </td>
                                                            <td width="12%" style="text-align: right">
                                                                <span class="form_label" id="Span4">Placement Date:</span>
                                                            </td>
                                                            <td align="right" width="10%">
                                                                <input type="text" tabindex="3" name="TextBox_CustomVocationalJobPlacements_JobPlacementDate"
                                                                    class="date_text" tabindex="4" id="TextBox_CustomVocationalJobPlacements_JobPlacementDate"
                                                                    datatype="Date" />
                                                            </td>
                                                            <td align="left" width="5%" style="padding-left: 2px">
                                                                <img id="Img1" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                    onclick="return showCalendar('TextBox_CustomVocationalJobPlacements_JobPlacementDate', '%m/%d/%Y');"
                                                                    style="cursor: hand;" filter="false" />
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
                                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td width="12%" align="left">
                                                    <span class="form_label" id="Span5">Job Title:</span>
                                                </td>
                                                <td width="88%">
                                                <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                        <tr>
                                                 <td width="37%">
                                                    <input id="TextBox_CustomVocationalJobPlacements_JobTitle" enabled="enabled" tabindex="5"
                                                        type="text" style="width: 91%" class="form_textbox" maxlength="250" />
                                                </td>
                                                
                                                <td width="14%" style="text-align: right">
                                                    <span class="form_label" id="Span13">Authorization Number:</span>
                                                </td>
                                                <td width="42%" align="left" style="padding-left: 2%">
                                                    <input id="TextBox_CustomVocationalJobPlacements_AuthorizationNumber" enabled="enabled" tabindex="6"
                                                        type="text" style="width: 91%" class="form_textbox" maxlength="250" />
                                                </td>
                                                </tr> </table> 
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
                                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td width="12%">
                                                    <span class="form_label" id="Span6">Start Date</span>
                                                </td>
                                                <td width="88%">
                                                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td align="left" width="6%">
                                                                <input type="text" tabindex="7" name="TextBox_CustomVocationalJobPlacements_JobStartDate"
                                                                    class="date_text" id="TextBox_CustomVocationalJobPlacements_JobStartDate" datatype="Date" />
                                                            </td>
                                                            <td align="left" width="7%" style="padding-left: 2px">
                                                                <img id="Img2" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                    onclick="return showCalendar('TextBox_CustomVocationalJobPlacements_JobStartDate', '%m/%d/%Y');"
                                                                    style="cursor: hand;" filter="false" />
                                                            </td>
                                                            <td style="width: 10%; padding-right: 2px" align="right">
                                                                <span class="form_label" id="Span7"># Of Hour</span>
                                                            </td>
                                                            <td width="18%">
                                                                <input id="TextBox_CustomVocationalJobPlacements_JobHoursPerWeek" name="TextBox_CustomVocationalJobPlacements_JobHoursPerWeek" enabled="enabled" <%--onblur="validateHours();"--%>
                                                                    type="text" style="width: 60%" maxlength="7" class="form_textbox" tabindex="8"
                                                                    datatype="Decimal" />
                                                            </td>
                                                            <td width="6%" align="right" style="padding-right: 2px">
                                                                <span class="form_label" id="Span8">Shift:</span>
                                                            </td>
                                                            <td width="53%">
                                                                <%-- <cc5:DropDownSubGlobalCodes ID="DropDownList_CustomVocationalJobPlacements_JobShift" 
                                              runat="server" TabIndex="8" Width ="100%"  AddBlankRow="true" BlankRowText="" BlankRowValue="-1">
                                            </cc5:DropDownSubGlobalCodes>  --%>
                                                                <cc2:StreamlineDropDowns ID="DropDownList_CustomVocationalJobPlacements_JobShift"
                                                                    name="DropDownList_CustomVocationalJobPlacements_JobShift" runat="server" TabIndex="9"
                                                                    Width="30%" AddBlankRow="true" BlankRowText="" BlankRowValue="-1">
                                                                </cc2:StreamlineDropDowns>
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
                                        <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                            <tr>
                                                <td width="12%">
                                                    <span class="form_label" id="Span9">Starting Wage($):</span>
                                                </td>
                                                <td width="88%">
                                                    <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                        <tr>
                                                            <td width="12%">
                                                                <input id="TextBox_CustomVocationalJobPlacements_JobStartingWage" enabled="enabled" maxlength="14"
                                                                    type="text" style="width: 80%" class="form_textbox" tabindex="10" datatype="Decimal"  />
                                                            </td>
                                                            <td width="7%">
                                                                <span class="form_label" id="Span10"></span>
                                                            </td>
                                                            <td width="15%">
                                                                <input type="radio" id="RadioButton_CustomVocationalJobPlacements_JobPayFrequency_Y"
                                                                    name="RadioButton_CustomVocationalJobPlacements_JobPayFrequency" value="W" tabindex="10" />
                                                                <label id="Label_Staff_AccessCareManagement_Y" for="RadioButton_Staff_AccessCareManagement_Y"
                                                                    style="vertical-align: top;">
                                                                    Paid Weekly</label>
                                                            </td>
                                                            <td width="15%" align="left">
                                                                <input type="radio" id="RadioButton_CustomVocationalJobPlacements_JobPayFrequency_N"
                                                                    name="RadioButton_CustomVocationalJobPlacements_JobPayFrequency" value="B" tabindex="11" />
                                                                <label id="Label1" for="RadioButton_CustomVocationalJobPlacements_JobPayFrequency_N"
                                                                    style="vertical-align: top;">
                                                                    Paid bi-Weekly</label>
                                                            </td>
                                                            <td width="18%" align="right" style="padding-right: 2px">
                                                                <span class="form_label" id="Span11">Date of First Paycheck:</span>
                                                            </td>
                                                            <td align="left" width="6%">
                                                                <input type="text" tabindex="12" name="TextBox_CustomVocationalJobPlacements_JobFirstPaycheckDate"
                                                                    class="date_text" id="TextBox_CustomVocationalJobPlacements_JobFirstPaycheckDate"
                                                                    datatype="Date" />
                                                            </td>
                                                            <td align="left" width="25%" style="padding-left: 2px">
                                                                <img id="Img4" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                    onclick="return showCalendar('TextBox_CustomVocationalJobPlacements_JobFirstPaycheckDate', '%m/%d/%Y');"
                                                                    style="cursor: hand;" filter="false" />
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
                                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td width="33%">
                                                    <span class="form_label" id="Span12">Safety Policy/ Instructions reviewed prior to start?</span>
                                                </td>
                                                <td width="7%">
                                                    <input type="radio" id="RadioButton_CustomVocationalJobPlacements_SafetyInstructionsReviewed _Y"
                                                        name="RadioButton_CustomVocationalJobPlacements_SafetyInstructionsReviewed" value="Y"
                                                        tabindex="13" />
                                                    <label id="Label_CustomVocationalJobPlacements_SafetyInstructionsReviewed _Y" for="RadioButton_Staff_SafetyInstructionsReviewed_Y"
                                                        style="vertical-align: top;">
                                                        Yes</label>
                                                </td>
                                                <td width="60%">
                                                    <input type="radio" id="RadioButton_CustomVocationalJobPlacements_SafetyInstructionsReviewed_N"
                                                        name="RadioButton_CustomVocationalJobPlacements_SafetyInstructionsReviewed" value="N"
                                                        tabindex="14" />
                                                    <label id="Label_CustomVocationalJobPlacements_SafetyInstructionsReviewed_N" for="RadioButton_CustomVocationalJobPlacements_SafetyInstructionsReviewed_N"
                                                        style="vertical-align: top;">
                                                        No</label>
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
                                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td width="12%">
                                                    <span class="form_label" id="Span15">Comments:</span>
                                                </td>
                                                <td style="width: 88%;">
                                                    <input id="TextBox_CustomVocationalJobPlacements_PlacementComments" enabled="enabled"
                                                        type="text" style="width: 98%" class="form_textbox" tabindex="15" maxlength="250" />
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
                                    <td style="padding-left: 2px">
                                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td>
                                                    <b>Benefits Receiving (Check all that apply):</b>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td>
                                                            </td>
                                                            <td>
                                                                <input type="checkbox" id="CheckBox_CustomVocationalJobPlacements_BenefitsHealthInsurance"
                                                                    name="CheckBox_CustomVocationalJobPlacements_BenefitsHealthInsurance" tabindex="16" />
                                                                <label id="Label_CustomVocationalJobPlacements_BenefitsHealthInsurance" style="vertical-align: top;"
                                                                    for="CheckBox_CustomVocationalJobPlacements_BenefitsHealthInsurance">
                                                                    Health Insurance</label>
                                                            </td>
                                                            <td>
                                                                <input type="checkbox" id="CheckBox_CustomVocationalJobPlacements_BenefitsLifeInsurance"
                                                                    name="CheckBox_CustomVocationalJobPlacements_BenefitsLifeInsurance" tabindex="17" />
                                                                <label id="Label_CustomVocationalJobPlacements_BenefitsLifeInsurance" for="CheckBox_CustomVocationalJobPlacements_BenefitsLifeInsurance"
                                                                    style="vertical-align: top;">
                                                                    Life Insurance</label>
                                                            </td>
                                                            <td>
                                                                <input type="checkbox" id="CheckBox_CustomVocationalJobPlacements_BenefitsDentalInsurance"
                                                                    tabindex="18" />
                                                                <label id="Label_CustomVocationalJobPlacements_BenefitsDentalInsurance" for="CheckBox_CustomVocationalJobPlacements_BenefitsDentalInsurance"
                                                                    style="vertical-align: top;">
                                                                    Dental Insurance</label>
                                                            </td>
                                                            <td>
                                                                <input type="checkbox" id="CheckBox_CustomVocationalJobPlacements_BenefitsPaidHolidays"
                                                                    tabindex="19" />
                                                                <label id="Label_CustomVocationalJobPlacements_BenefitsPaidHolidays" for="CheckBox_CustomVocationalJobPlacements_BenefitsPaidHolidays"
                                                                    style="vertical-align: top;">
                                                                    Paid Sick Time</label>
                                                            </td>
                                                            <td>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                            </td>
                                                            <td>
                                                                <input type="checkbox" id="CheckBox_CustomVocationalJobPlacements_BenefitsVisionInsurance"
                                                                    tabindex="20" />
                                                                <label id="Label_CustomVocationalJobPlacements_BenefitsVisionInsurance" for="CheckBox_CustomVocationalJobPlacements_BenefitsVisionInsurance"
                                                                    style="vertical-align: top;">
                                                                    Vision Insurance</label>
                                                            </td>
                                                            <td>
                                                                <input type="checkbox" id="CheckBox_CustomVocationalJobPlacements_BenefitsPaidHolidays"
                                                                    tabindex="21" />
                                                                <label id="Label_CustomVocationalJobPlacements_BenefitsPaidHolidays" for="CheckBox_CustomVocationalJobPlacements_BenefitsPaidHolidays"
                                                                    style="vertical-align: top;">
                                                                    Paid Holidays</label>
                                                            </td>
                                                            <td>
                                                                <input type="checkbox" id="CheckBox_CustomVocationalJobPlacements_BenefitsPaidVacation"
                                                                    tabindex="22" />
                                                                <label id="Label_CustomVocationalJobPlacements_BenefitsPaidVacation" for="CheckBox_CustomVocationalJobPlacements_BenefitsPaidVacation"
                                                                    style="vertical-align: top;">
                                                                    Paid Vacation</label>
                                                            </td>
                                                            <td>
                                                            </td>
                                                            <td>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                            </td>
                                                            <td colspan="5">
                                                                <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                                    <tr>
                                                                        <td style="width: 9%;">
                                                                            <input type="checkbox" id="CheckBox_CustomVocationalJobPlacements_BenefitsOther"
                                                                                tabindex="23" />
                                                                            <label id="Label_CustomVocationalJobPlacements_BenefitsOther" for="CheckBox_CustomVocationalJobPlacements_BenefitsOther"
                                                                                style="vertical-align: top;">
                                                                                Other</label>
                                                                        </td>
                                                                        <td>
                                                                            <input id="TextBox_CustomVocationalJobPlacements_BenefitsOtherComment" enabled="enabled" maxlength="250"
                                                                                type="text" style="width: 98%" tabindex="24" class="form_textbox" />
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
                                                            </td>
                                                            <td colspan="4">
                                                                <span class="form_label" id="Span15">Comments (include additional assistance need such
                                                                    as coaching, adaptive equipment, etc.)</span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                            </td>
                                                            <td colspan="4">
                                                                <textarea id="TextArea_CustomVocationalJobPlacements_JobComments" spellcheck="True"  onKeyPress='return maxLength(this,"250");' onpaste='return maxLengthPaste(this,"250");'
                                                                    name="TextArea_Comment" tabindex="25" style="width: 98%; height: 50px;" class="form_textarea element"></textarea>
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
        <tr>
            <td>
                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                    <tr>
                        <td class="content_tab_left" align="left" nowrap='nowrap'>
                            <span id="Span16">Employer</span>
                        </td>
                        <td width="17">
                            <img style="vertical-align: top;" height="26" width="17" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                        </td>
                        <td class="content_tab_top" width="100%">
                        </td>
                        <td width="7">
                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td class="content_tab_bg" style="padding-left: 7px">
                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td>
                            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td style="width: 12%;">
                                        <span class="form_label" id="Span17">Employer Name:</span>
                                    </td>
                                    <td style="width: 88%;">
                                        <input id="TextBox_CustomVocationalJobPlacements_EmployerName" enabled="enabled"
                                            type="text" style="width: 98%" class="form_textbox" tabindex="26" maxlength="250" />
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
                            <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                <tr>
                                    <td style="width: 12%">
                                        <span class="form_label" id="Span18">Address:</span>
                                    </td>
                                    <td style="width: 88%">
                                        <textarea id="TextBox_CustomVocationalJobPlacements_EmployerAddress" tabindex="27"  onKeyPress='return maxLength(this,"1000");' onpaste='return maxLengthPaste(this,"1000");'
                                            spellcheck="True" name="TextBox_CustomVocationalJobPlacements_EmployerAddress"
                                            style="width: 98%; height: 50px;" class="form_textarea" rows="2"></textarea>
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
                            <table cellpadding="0" cellspacing="0" width="100%" border="0">
                                <tr>
                                    <td style="width: 12%">
                                        <span class="form_label" id="Span19">Phone:</span>
                                    </td>
                                    <td style="width: 88%">
                                        <table cellpadding="0" cellspacing="0" width="100%" border="0">
                                            <tr>
                                                <td style="width: 30%;">
                                                    <input id="TextBox_CustomVocationalJobPlacements_EmployerPhone" class="form_textbox"
                                                        enabled="enabled" type="text" style="width: 90%" datatype="PhoneNumber" tabindex="28"
                                                        maxlength="50" />
                                                </td>
                                                <td style="width: 20%; padding-right: 2px" align="right">
                                                    <span class="form_label" id="Span20">Fax:</span>
                                                </td>
                                                <td style="width: 50%">
                                                    <input id="TextBox_CustomVocationalJobPlacements_EmployerFax" enabled="enabled" type="text" datatype="PhoneNumber"
                                                        style="width: 96%" class="form_textbox" tabindex="29" maxlength="50" />
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
                            <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                <tr>
                                    <td>
                                        <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                            <tr>
                                                <td style="width: 12%">
                                                    <span class="form_label" id="Span21">Supervisor:</span>
                                                </td>
                                                <td style="width: 88%">
                                                    <input id="TextBox_CustomVocationalJobPlacements_EmployerSupervisorName" enabled="enabled"
                                                        type="text" style="width: 98%" class="form_textbox" tabindex="30" maxlength="250" />
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
        <tr>
            <td>
                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                    <tr>
                        <td class="content_tab_left" align="left" nowrap='nowrap'>
                            <span id="Span22">Reviews</span>
                        </td>
                        <td width="17">
                            <img style="vertical-align: top;" height="26" width="17" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                        </td>
                        <td class="content_tab_top" width="100%">
                        </td>
                        <td width="7">
                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td class="content_tab_bg" style="padding-left: 7px">
                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td>
                            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td style="width: 30%">
                                        <span class="form_label" id="Span23">Initial: Employee received orientation work site:</span>
                                    </td>
                                    <td style="width: 6%">
                                        <input type="radio" id="RadioButton_CustomVocationalJobPlacements_EmployeeReceivedOrientation_Y"
                                            name="RadioButton_CustomVocationalJobPlacements_EmployeeReceivedOrientation"
                                            value="Y" tabindex="31" />
                                        <label id="Label_CustomVocationalJobPlacements_EmployeeReceivedOrientation_Y" for="RadioButton_CustomVocationalJobPlacements_EmployeeReceivedOrientation_Y"
                                            style="vertical-align: top;">
                                            Yes</label>
                                    </td>
                                    <td style="width: 6%">
                                        <input type="radio" id="RadioButton_CustomVocationalJobPlacements_EmployeeReceivedOrientation_N"
                                            name="RadioButton_CustomVocationalJobPlacements_EmployeeReceivedOrientation"
                                            value="N" tabindex="32" />
                                        <label id="Label_CustomVocationalJobPlacements_EmployeeReceivedOrientation_N" for="RadioButton_CustomVocationalJobPlacements_EmployeeReceivedOrientation_N"
                                            style="vertical-align: top;">
                                            No</label>
                                    </td>
                                    <td style="width: 3%">
                                        <span class="form_label" id="Span24">Date:</span>
                                    </td>
                                    <td align="left" style="width: 6%">
                                        <input type="text" tabindex="33" name="TextBox_CustomVocationalJobPlacements_ReceivedOrientationDate"
                                            class="date_text" id="TextBox_CustomVocationalJobPlacements_ReceivedOrientationDate"
                                            datatype="Date" />
                                    </td>
                                    <td align="left" style="width: 48%; padding-left: 2px">
                                        <img id="Img5" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                            onclick="return showCalendar('TextBox_CustomVocationalJobPlacements_ReceivedOrientationDate','%m/%d/%Y');"
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
                        <td>
                            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td style="width: 9%">
                                        <span class="form_label" id="Span25">30 Days:</span>
                                    </td>
                                    <td align="left" style="width: 3%">
                                        <input type="text" tabindex="33" name="TextBox_CustomVocationalJobPlacements_ReviewDate30Day"
                                            class="date_text" id="TextBox_CustomVocationalJobPlacements_ReviewDate30Day"
                                            datatype="Date" />
                                    </td>
                                    <td align="left" style="width: 92%; padding-left: 2px">
                                        <img id="Img6" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                            onclick="return showCalendar('TextBox_CustomVocationalJobPlacements_ReviewDate30Day', '%m/%d/%Y');"
                                            style="cursor: hand;" filter="false" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 9%">
                                        <span class="form_label" id="Span26">60 Days:</span>
                                    </td>
                                    <td align="left" style="width: 3%">
                                        <input type="text" tabindex="34" name="TextBox_CustomVocationalJobPlacements_ReviewDate60Day"
                                            class="date_text" id="TextBox_CustomVocationalJobPlacements_ReviewDate60Day"
                                            datatype="Date" />
                                    </td>
                                    <td align="left" style="width: 92%; padding-left: 2px">
                                        <img id="Img7" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                            onclick="return showCalendar('TextBox_CustomVocationalJobPlacements_ReviewDate60Day', '%m/%d/%Y');"
                                            style="cursor: hand;" filter="false" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 9%">
                                        <span class="form_label" id="Span27">90 Days:</span>
                                    </td>
                                    <td align="left" style="width: 3%">
                                        <input type="text" tabindex="35" name="TextBox_CustomVocationalJobPlacements_ReviewDate90Day"
                                            class="date_text" id="TextBox_CustomVocationalJobPlacements_ReviewDate90Day"
                                            datatype="Date" />
                                    </td>
                                    <td align="left" style="width: 92%; padding-left: 2px">
                                        <img id="Img8" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                            onclick="return showCalendar('TextBox_CustomVocationalJobPlacements_ReviewDate90Day', '%m/%d/%Y');"
                                            style="cursor: hand;" filter="false" />
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
        <tr>
            <td>
                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                    <tr>
                        <td class="content_tab_left" align="left" nowrap='nowrap'>
                            <span id="Span28">Job Loss</span>
                        </td>
                        <td width="17">
                            <img style="vertical-align: top;" height="26" width="17" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                        </td>
                        <td class="content_tab_top" width="100%">
                        </td>
                        <td width="7">
                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td class="content_tab_bg" style="padding-left: 7px">
                <table width="100%" cellpadding="0" cellspacing="0" border="0">
                    <tr>
                        <td>
                            <table width="100%" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td style="width: 13%;">
                                        <span class="form_label" id="Span29">End Date</span>
                                    </td>
                                    <td style="width: 87%;">
                                        <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                            <tr>
                                                <td align="left" style="width: 7%;">
                                                    <input type="text" tabindex="36" name="TextBox_CustomVocationalJobPlacements_JobLossEndDate"
                                                        class="date_text" id="TextBox_CustomVocationalJobPlacements_JobLossEndDate" datatype="Date" />
                                                </td>
                                                <td align="left" style="width: 5%; padding-left: 2px">
                                                    <img id="Img9" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                        onclick="return showCalendar('TextBox_CustomVocationalJobPlacements_JobLossEndDate', '%m/%d/%Y');"
                                                        style="cursor: hand;" filter="false" />
                                                </td>
                                                <td style="width: 88%;">
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
                            <table width="100%" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td>
                                        <table width="100%" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td style="width: 13%;">
                                                    <span class="form_label" id="Span30">Reason for job loss:</span>
                                                </td>
                                                <td style="width: 87%;">
                                                    <cc2:StreamlineDropDowns ID="DropDownList_CustomVocationalJobPlacements_JobLossReason"
                                                        name="DropDownList_CustomVocationalJobPlacements_JobLossReason" Width="117px"
                                                        runat="server" TabIndex="37" AddBlankRow="true" BlankRowText="" BlankRowValue="-1">
                                                    </cc2:StreamlineDropDowns>
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
                        <td class="height2">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td style="width: 13%;">
                                    </td>
                                    <td style="width: 6%;">
                                        <input type="checkbox" id="CheckBox_CustomVocationalJobPlacements_JobLossReasonOther"
                                            tabindex="38" />
                                        <label id="Label_CustomVocationalJobPlacements_JobLossReasonOther" for="CheckBox_CustomVocationalJobPlacements_JobLossReasonOther"
                                            style="vertical-align: top;">
                                            Other</label>
                                    </td>
                                    <td style="width: 81%;">
                                        <input id="TextBox_CustomVocationalJobPlacements_JobLossReasonOtherComment" enabled="enabled"
                                            type="text" style="width: 90%" tabindex="39" class="form_textbox" />
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
    </table>
</div>
