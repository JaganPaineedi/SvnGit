<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Gambling.ascx.cs" Inherits="Gambling" %>
<%@ Register Assembly="Streamline.DotNetDropDowns" Namespace="Streamline.DotNetDropDowns"
    TagPrefix="cc2" %>
<%@ Register Src="~/ActivityPages/Client/Detail/IndividualServiceNote/ServiceNoteInformation.ascx"
    TagName="Information" TagPrefix="uc3" %>
<div class="DocumentScreen">
    <table border="0" cellpadding="0" cellspacing="0" width="100%">
        <tr>
            <td>
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                        <td class="height2">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                <tr>
                                    <td class="content_tab_left" align="left" nowrap='nowrap'>
                                        Gambling
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
                                    <td class="padding_label1">
                                        <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                            <tr>
                                                <td>
                                                    <table cellpadding="0" cellspacing="0" border="0" style="width: 100%">
                                                        <tr>
                                                            <td style="width: 72%" align="left">
                                                                <span class="form_label" id="Span8">In the past 6 months, how frequently were you satisfied
                                                                    with each of the following. Use the scale to score your responses </span>
                                                            </td>
                                                            <td>
                                                            <td class="form_label">
                                                                <img width="12" height="12" style="cursor: pointer; padding-left: 1px" src="<%=RelativePath%>App_Themes/Includes/Images/info.png"
                                                                    height="7" title="Tool Tip: 1. Never; 2. Rarely; 3. Sometimes; 4. Often; 5. Always; 6. Don’t know/doesn’t apply" />
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td>
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <table cellpadding="0" cellspacing="0" border="0" style="width: 100%">
                                                        <tr>
                                                            <td width="80%" align="left">
                                                                <span class="form_label" id="Span12">Often find yourself thinking about gambling, for
                                                                    example, reliving past gambling experiences, planning the next time you would play
                                                                    or thinking of ways to get money for gambling.</span>
                                                            </td>
                                                            <td width="18%" align="left">
                                                                <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentGambling_ThinkingAboutGambling"
                                                                    Width="150px" runat="server" CssClass="form_dropdown" valuetype="System.Int32">
                                                                </cc2:StreamlineDropDowns>
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="80%" align="left">
                                                                <span class="form_label" id="Span9">Need to gamble with more and more money to get the
                                                                    amount of excitement you were looking for.</span>
                                                            </td>
                                                            <td width="18%" align="left">
                                                                <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentGambling_GamblingWithMoreMoney"
                                                                    Width="150px" runat="server" CssClass="form_dropdown" valuetype="System.Int32">
                                                                </cc2:StreamlineDropDowns>
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="80%" align="left">
                                                                <span class="form_label" id="Span13">Make repeated unsuccessful attempts to control,
                                                                    cut back or stop gambling.</span>
                                                            </td>
                                                            <td width="18%" align="left">
                                                                <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentGambling_UnsuccessfulAttemptsToControlGambling"
                                                                    Width="150px" runat="server" CssClass="form_dropdown" valuetype="System.Int32">
                                                                </cc2:StreamlineDropDowns>
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="80%" align="left">
                                                                <span class="form_label" id="Span14">Become restless or irritable when trying to cut
                                                                    down or stop gambling.</span>
                                                            </td>
                                                            <td width="18%" align="left">
                                                                <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentGambling_RestlessOrIrritable"
                                                                    Width="150px" runat="server" CssClass="form_dropdown" valuetype="System.Int32">
                                                                </cc2:StreamlineDropDowns>
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="80%" align="left">
                                                                <span class="form_label" id="Span15">Gamble to escape from problems or when you were
                                                                    feeling depressed, anxious, or bad about yourself.</span>
                                                            </td>
                                                            <td width="18%" align="left">
                                                                <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentGambling_GambleToEscapeFromProblems"
                                                                    Width="150px" runat="server" CssClass="form_dropdown" valuetype="System.Int32">
                                                                </cc2:StreamlineDropDowns>
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="80%" align="left">
                                                                <span class="form_label" id="Span16">After losing money gambling, return another day
                                                                    in order to get even.</span>
                                                            </td>
                                                            <td width="18%" align="left">
                                                                <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentGambling_ReturningAfterLosingGamblingMoney"
                                                                    Width="150px" runat="server" CssClass="form_dropdown" valuetype="System.Int32">
                                                                </cc2:StreamlineDropDowns>
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="80%" align="left">
                                                                <span class="form_label" id="Span17">Lie to your family or others to hide the extent
                                                                    of your gambling.</span>
                                                            </td>
                                                            <td width="18%" align="left">
                                                                <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentGambling_LieToFamily" Width="150px"
                                                                    runat="server" CssClass="form_dropdown" valuetype="System.Int32">
                                                                </cc2:StreamlineDropDowns>
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="80%" align="left">
                                                                <span class="form_label" id="Span18">Go beyond what is strictly legal in order to finance
                                                                    gambling or to pay gambling debts.</span>
                                                            </td>
                                                            <td width="18%" align="left">
                                                                <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentGambling_GoBeyondLegalGambling"
                                                                    Width="150px" runat="server" CssClass="form_dropdown" valuetype="System.Int32">
                                                                </cc2:StreamlineDropDowns>
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="80%" align="left">
                                                                <span class="form_label" id="Span19">Risk or lose a significant relationship, job, educational
                                                                    or career opportunity because of gambling.</span>
                                                            </td>
                                                            <td width="18%" align="left">
                                                                <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentGambling_LoseSignificantRelationship"
                                                                    Width="150px" runat="server" CssClass="form_dropdown" valuetype="System.Int32">
                                                                </cc2:StreamlineDropDowns>
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="80%" align="left">
                                                                <span class="form_label" id="Span20">Seek help from others to provide money to relieve
                                                                    a desperate financial situation caused by gambling.</span>
                                                            </td>
                                                            <td width="18%" align="left">
                                                                <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentGambling_SeekHelpFromOthers"
                                                                    Width="150px" runat="server" CssClass="form_dropdown" valuetype="System.Int32">
                                                                </cc2:StreamlineDropDowns>
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
            <td>
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                        <td class="height2">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                <tr>
                                    <td class="content_tab_left" align="left" nowrap='nowrap'>
                                        Activities
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
                                    <td class="padding_label1">
                                        <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                            <tr>
                                                <td>
                                                    <table cellpadding="0" cellspacing="0" border="0" style="width: 100%">
                                                        <tr>
                                                            <td style="width: 72%" align="left">
                                                                <span class="form_label" id="Span30">In the past 6 months, how frequently were you satisfied
                                                                    with each of the following. Use the scale to score your responses </span>
                                                            </td>
                                                            <td>
                                                            <td class="form_label">
                                                                <img width="12" height="12" style="cursor: pointer; padding-left: 1px" src="<%=RelativePath%>App_Themes/Includes/Images/info.png"
                                                                    height="7" title="Tool Tip: 1. Never; 2. Rarely; 3. Sometimes; 4. Often; 5. Always; 6. Don’t know/doesn’t apply" />
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td>
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="width: 100%" class="style2" valign="top">
                                                    <table cellpadding="0" cellspacing="0" border="0" style="width: 100%">
                                                        <tr>
                                                            <td width="80%" align="left">
                                                                <span class="form_label" id="Span1">Number of days gambled during the last 30 days</span>
                                                            </td>
                                                            <td width="18%" align="left">
                                                                <input name="TextBox_CustomDocumentGambling_NumberOfDaysGambled" class="form_textbox element"
                                                                    id="TextBox_CustomDocumentGambling_NumberOfDaysGambled" style="width: 30%;"
                                                                    type="text" maxlength="4" datatype="Numeric" />
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="80%" align="left">
                                                                <span class="form_label" id="Span2">Average amount gambled for each day that you gambled
                                                                    during the last 30 days (actual amount of money that came out of your pocket each
                                                                    day gambled)</span>
                                                            </td>
                                                            <td width="18%" align="left">
                                                                <input name="TextBox_CustomDocumentGambling_AverageAmountGambled" class="form_textbox element"
                                                                    id="TextBox_CustomDocumentGambling_AverageAmountGambled" style="width: 30%;"
                                                                    type="text" maxlength="8" datatype="Currency" />
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td>
                                                            </td>
                                                        </tr>
                                                       
                                                    </table>
                                                    <table cellpadding="0" cellspacing="0" border="0" style="width: 100%">
                                                     <tr>
                                                            <td width="98%" align="left">
                                                                <span class="form_label" id="Span3">What was the primary gambling activity (game) played
                                                                    during the past 30 days</span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="98%" align="left">
                                                                <input name="TextBox_CustomDocumentGambling_PrimaryGamblingActivity" class="form_textbox element"
                                                                    id="TextBox_CustomDocumentGambling_PrimaryGamblingActivity" style="width: 90%;"
                                                                    type="text" maxlength="50" />
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="98%" align="left">
                                                                <span class="form_label" id="Span4">Where did you primarily gamble in the past 30 days
                                                                    (bingo hall, card room, bar, casino, home, internet, convenience store, track, restaurant,
                                                                    etc.)</span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="98%" align="left">
                                                                <input name="TextBox_CustomDocumentGambling_PrimarilyGamblingPlace" class="form_textbox element"
                                                                    id="TextBox_CustomDocumentGambling_PrimarilyGamblingPlace" style="width: 90%;"
                                                                    type="text" maxlength="50" />
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td>
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
            <td>
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                        <td class="height2">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                <tr>
                                    <td class="content_tab_left" align="left" nowrap='nowrap'>
                                        Other Services
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
                                    <td class="padding_label1">
                                        <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                            <tr>
                                                <td style="width: 100%" valign="top">
                                                    <table cellpadding="0" cellspacing="0" border="0" style="width: 100%">
                                                        <tr>
                                                            <td width="60%" align="left">
                                                                <span class="form_label" id="Span6">Number of times in the past 6 months that you went
                                                                    to an emergency room or urgent care center</span>
                                                            </td>
                                                            <td width="40%" align="left">
                                                                <input name="TextBox_CustomDocumentGambling_NumberOfTimesEnteredEmergencyRoom" class="form_textbox element"
                                                                    id="TextBox_CustomDocumentGambling_NumberOfTimesEnteredEmergencyRoom" style="width: 19%;"
                                                                    type="text" maxlength="4" datatype="Numeric" />
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="60%" align="left">
                                                                <span class="form_label" id="Span7">Did you enroll in a treatment program for the treatment
                                                                    of alcohol and/or drug abuse problems?</span>
                                                            </td>
                                                            <td width="40%" align="left">
                                                                <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentGambling_EnrolledInTreatmentProgramForAlcohol"
                                                                    Width="20%" runat="server" CssClass="form_dropdown" valuetype="System.Int32"
                                                                    onchange="javascript:ValidateGamblingTabControls();">
                                                                </cc2:StreamlineDropDowns>
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <table>
                                                                    <tr class="RadioText">
                                                                        <td width="80%" align="left">
                                                                            <span class="form_label" id="Span5">Inpatient A&D</span>
                                                                        </td>
                                                                        <td>
                                                                            <input type="radio" id="RadioButton_CustomDocumentGambling_AlcoholInpatientAAndD_Y"
                                                                                name="RadioButton_CustomDocumentGambling_AlcoholInpatientAAndD" value="Y" />
                                                                            <label for="RadioButton_CustomDocumentGambling_AlcoholInpatientAAndD_Y">
                                                                                Yes</label>
                                                                        </td>
                                                                        <td width="8px">
                                                                            &nbsp;
                                                                        </td>
                                                                        <td>
                                                                            <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentGambling_AlcoholInpatientAAndD_N"
                                                                                name="RadioButton_CustomDocumentGambling_AlcoholInpatientAAndD" value="N" />
                                                                            <label for="RadioButton_CustomDocumentGambling_AlcoholInpatientAAndD_N">
                                                                                No</label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr class="height2">
                                                                        <td>
                                                                        </td>
                                                                    </tr>
                                                                    <tr class="RadioText">
                                                                        <td width="80%" align="left">
                                                                            <span class="form_label" id="Span21">Outpatient A&D</span>
                                                                        </td>
                                                                        <td>
                                                                            <input type="radio" id="RadioButton_CustomDocumentGambling_AlcoholOutpatientAAndD_Y"
                                                                                name="RadioButton_CustomDocumentGambling_AlcoholOutpatientAAndD" value="Y" />
                                                                            <label for="RadioButton_CustomDocumentGambling_AlcoholOutpatientAAndD_Y">
                                                                                Yes</label>
                                                                        </td>
                                                                        <td width="8px">
                                                                            &nbsp;
                                                                        </td>
                                                                        <td>
                                                                            <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentGambling_AlcoholOutpatientAAndD_N"
                                                                                name="RadioButton_CustomDocumentGambling_AlcoholOutpatientAAndD" value="N" />
                                                                            <label for="RadioButton_CustomDocumentGambling_AlcoholOutpatientAAndD_N">
                                                                                No</label>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="60%" align="left">
                                                                <span class="form_label" id="Span10">Did you enroll in a treatment program for mental
                                                                    health problems (other than the gambling program you attended)</span>
                                                            </td>
                                                            <td width="40%" align="left">
                                                                <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentGambling_EnrolledInTreatmentProgramForMentalHealth"
                                                                    Width="20%" runat="server" CssClass="form_dropdown" valuetype="System.Int32"
                                                                    onchange="javascript:ValidateGamblingTabControls();">
                                                                </cc2:StreamlineDropDowns>
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <table>
                                                                    <tr class="RadioText">
                                                                        <td width="80%" align="left">
                                                                            <span class="form_label" id="Span22">Inpatient A&D</span>
                                                                        </td>
                                                                        <td>
                                                                            <input type="radio" id="RadioButton_CustomDocumentGambling_MentalHealthInpatientAAndD_Y"
                                                                                name="RadioButton_CustomDocumentGambling_MentalHealthInpatientAAndD" value="Y" />
                                                                            <label for="RadioButton_CustomDocumentGambling_MentalHealthInpatientAAndD_Y">
                                                                                Yes</label>
                                                                        </td>
                                                                        <td width="8px">
                                                                            &nbsp;
                                                                        </td>
                                                                        <td>
                                                                            <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentGambling_MentalHealthInpatientAAndD_N"
                                                                                name="RadioButton_CustomDocumentGambling_MentalHealthInpatientAAndD" value="N" />
                                                                            <label for="RadioButton_CustomDocumentGambling_MentalHealthInpatientAAndD_N">
                                                                                No</label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr class="height2">
                                                                        <td>
                                                                        </td>
                                                                    </tr>
                                                                    <tr class="RadioText">
                                                                        <td width="80%" align="left">
                                                                            <span class="form_label" id="Span23">Outpatient A&D</span>
                                                                        </td>
                                                                        <td>
                                                                            <input type="radio" id="RadioButton_CustomDocumentGambling_MentalHealthOutpatientAAndD_Y"
                                                                                name="RadioButton_CustomDocumentGambling_MentalHealthOutpatientAAndD" value="Y" />
                                                                            <label for="RadioButton_CustomDocumentGambling_MentalHealthOutpatientAAndD_Y">
                                                                                Yes</label>
                                                                        </td>
                                                                        <td width="8px">
                                                                            &nbsp;
                                                                        </td>
                                                                        <td>
                                                                            <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentGambling_MentalHealthOutpatientAAndD_N"
                                                                                name="RadioButton_CustomDocumentGambling_MentalHealthOutpatientAAndD" value="N" />
                                                                            <label for="RadioButton_CustomDocumentGambling_MentalHealthOutpatientAAndD_N">
                                                                                No</label>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="60%" align="left">
                                                                <span class="form_label" id="Span11">Did you enroll in another gambling treatment program,
                                                                    or see another therapist or doctor outside the staff of the gambling program you
                                                                    attended.</span>
                                                            </td>
                                                            <td width="40%" align="left">
                                                                <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentGambling_EnrolledInAnotherGamblingProgram"
                                                                    Width="20%" runat="server" CssClass="form_dropdown" valuetype="System.Int32"
                                                                    onchange="javascript:ValidateGamblingTabControls();">
                                                                </cc2:StreamlineDropDowns>
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    <table>
                                                        <tr class="RadioText">
                                                            <td width="80%" align="left">
                                                                <span class="form_label" id="Span24">Inpatient A&D</span>
                                                            </td>
                                                            <td>
                                                                <input type="radio" id="RadioButton_CustomDocumentGambling_GamblingInpatientAAndD_Y"
                                                                    name="RadioButton_CustomDocumentGambling_GamblingInpatientAAndD" value="Y" />
                                                                <label for="RadioButton_CustomDocumentGambling_GamblingInpatientAAndD_Y">
                                                                    Yes</label>
                                                            </td>
                                                            <td width="8px">
                                                                &nbsp;
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentGambling_GamblingInpatientAAndD_N"
                                                                    name="RadioButton_CustomDocumentGambling_GamblingInpatientAAndD" value="N" />
                                                                <label for="RadioButton_CustomDocumentGambling_GamblingInpatientAAndD_N">
                                                                    No</label>
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td>
                                                            </td>
                                                        </tr>
                                                        <tr class="RadioText">
                                                            <td width="80%" align="left">
                                                                <span class="form_label" id="Span25">Outpatient A&D</span>
                                                            </td>
                                                            <td>
                                                                <input type="radio" id="RadioButton_CustomDocumentGambling_GamblingOutpatientAAndD_Y"
                                                                    name="RadioButton_CustomDocumentGambling_GamblingOutpatientAAndD" value="Y" />
                                                                <label for="RadioButton_CustomDocumentGambling_GamblingOutpatientAAndD_Y">
                                                                    Yes</label>
                                                            </td>
                                                            <td width="8px">
                                                                &nbsp;
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentGambling_GamblingOutpatientAAndD_N"
                                                                    name="RadioButton_CustomDocumentGambling_GamblingOutpatientAAndD" value="N" />
                                                                <label for="RadioButton_CustomDocumentGambling_GamblingOutpatientAAndD_N">
                                                                    No</label>
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    <table>
                                                        <tr class="RadioText">
                                                            <td width="80%" align="left">
                                                                <span class="form_label" id="Span26">In the past 6 months, have you filed for bankruptcy.<span>
                                                            </td>
                                                            <td>
                                                                <input type="radio" id="RadioButton_CustomDocumentGambling_FiledForBankruptcy_Y"
                                                                    name="RadioButton_CustomDocumentGambling_FiledForBankruptcy" value="Y" />
                                                                <label for="RadioButton_CustomDocumentGambling_FiledForBankruptcy_Y">
                                                                    Yes</label>
                                                            </td>
                                                            <td width="8px">
                                                                &nbsp;
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentGambling_FiledForBankruptcy_N"
                                                                    name="RadioButton_CustomDocumentGambling_FiledForBankruptcy" value="N" />
                                                                <label for="RadioButton_CustomDocumentGambling_FiledForBankruptcy_N">
                                                                    No</label>
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td>
                                                            </td>
                                                        </tr>
                                                        <tr class="RadioText">
                                                            <td width="80%" align="left">
                                                                <span class="form_label" id="Span27">In the past 6 months, have you been convicted of
                                                                    any gambling related crime.</span>
                                                            </td>
                                                            <td>
                                                                <input type="radio" id="RadioButton_CustomDocumentGambling_ConvictedOfGambling_Y"
                                                                    name="RadioButton_CustomDocumentGambling_ConvictedOfGambling" value="Y" />
                                                                <label for="RadioButton_CustomDocumentGambling_ConvictedOfGambling_Y">
                                                                    Yes</label>
                                                            </td>
                                                            <td width="8px">
                                                                &nbsp;
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentGambling_ConvictedOfGambling_N"
                                                                    name="RadioButton_CustomDocumentGambling_ConvictedOfGambling" value="N" />
                                                                <label for="RadioButton_CustomDocumentGambling_ConvictedOfGambling_N">
                                                                    No</label>
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td>
                                                            </td>
                                                        </tr>
                                                        <tr class="RadioText">
                                                            <td width="80%" align="left">
                                                                <span class="form_label" id="Span28">In the past 6 months, have you experienced physical
                                                                    violence in a relationship.</span>
                                                            </td>
                                                            <td>
                                                                <input type="radio" id="RadioButton_CustomDocumentGambling_ExperiencedPhysicalViolence_Y"
                                                                    name="RadioButton_CustomDocumentGambling_ExperiencedPhysicalViolence" value="Y" />
                                                                <label for="RadioButton_CustomDocumentGambling_ExperiencedPhysicalViolence_Y">
                                                                    Yes</label>
                                                            </td>
                                                            <td width="8px">
                                                                &nbsp;
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentGambling_ExperiencedPhysicalViolence_N"
                                                                    name="RadioButton_CustomDocumentGambling_ExperiencedPhysicalViolence" value="N" />
                                                                <label for="RadioButton_CustomDocumentGambling_ExperiencedPhysicalViolence_N">
                                                                    No</label>
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td>
                                                            </td>
                                                        </tr>
                                                        <tr class="RadioText">
                                                            <td width="80%" align="left">
                                                                <span class="form_label" id="Span29">In the past 6 months, have you experienced verbal,
                                                                    emotional, or psychological abuse in a relationship.</span>
                                                            </td>
                                                            <td>
                                                                <input type="radio" id="RadioButton_CustomDocumentGambling_AbuseInRelationship_Y"
                                                                    name="RadioButton_CustomDocumentGambling_AbuseInRelationship" value="Y" />
                                                                <label for="RadioButton_CustomDocumentGambling_AbuseInRelationship_Y">
                                                                    Yes</label>
                                                            </td>
                                                            <td width="8px">
                                                                &nbsp;
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentGambling_AbuseInRelationship_N"
                                                                    name="RadioButton_CustomDocumentGambling_AbuseInRelationship" value="N" />
                                                                <label for="RadioButton_CustomDocumentGambling_AbuseInRelationship_N">
                                                                    No</label>
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td>
                                                            </td>
                                                        </tr>
                                                        <tr class="RadioText">
                                                            <td width="80%" align="left">
                                                                <span class="form_label" id="Span31">In the past 6 months, have you felt controlled,
                                                                    trapped or manipulated by a significant other.</span>
                                                            </td>
                                                            <td>
                                                                <input type="radio" id="RadioButton_CustomDocumentGambling_ControlloedManipulatedByOther_Y"
                                                                    name="RadioButton_CustomDocumentGambling_ControlloedManipulatedByOther" value="Y" />
                                                                <label for="RadioButton_CustomDocumentGambling_ControlloedManipulatedByOther_Y">
                                                                    Yes</label>
                                                            </td>
                                                            <td width="8px">
                                                                &nbsp;
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentGambling_ControlloedManipulatedByOther_N"
                                                                    name="RadioButton_CustomDocumentGambling_ControlloedManipulatedByOther" value="N" />
                                                                <label for="RadioButton_CustomDocumentGambling_ControlloedManipulatedByOther_N">
                                                                    No</label>
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td>
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
</div>
