<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Exam.ascx.cs" Inherits="SHS.SmartCare.Custom_PsychiatricEvaluation_WebPages_Exam" %>
<%@ Register Assembly="Streamline.DotNetDropDowns" Namespace="Streamline.DotNetDropDowns"
    TagPrefix="cc2" %>
<div>
    <table border="0" cellpadding="0" cellspacing="0" class="DocumentScreen">
        <tr>
            <td class="height2"></td>
        </tr>
        <tr>
            <td>
                <table width="98%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td class="height1"></td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="content_tab_left" nowrap='nowrap'>Vitals
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
                    <tr>
                        <td class="content_tab_bg" style="padding-left: 10px">
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="height1" colspan="2"></td>
                                </tr>
                                <tr>
                                    <td style="width: 50%">
                                        <span id="Span_FlowSheetVitals">Vitals</span>
                                    </td>
                                    <td align="right" style="width: 50%; padding-right: 15px;">
                                        <table cellspacing="0" cellpadding="0" border="0" style="padding-left: 0px; text-align: right;">
                                            <tr>
                                                <td class="glow_lt">&nbsp;
                                                </td>
                                                <td class="glow_mid">
                                                    <input type="button" id="Button_OpenFlowSheet" name="Button_OpenFlowSheet"
                                                        value="Open Flowsheets to Update Vitals" />
                                                </td>
                                                <td class="glow_rt">&nbsp;
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height1" colspan="2"></td>
                                </tr>
                            </table>
                            <div id="divVitalsHead" style="border: solid 1px #b1b1b1; border-bottom: 0px; background-color: #ffffff; width: 98.3%">
                            </div>
                            <div id="divVitals" style="border: solid 1px #b1b1b1; border-top: 0px; background-color: #ffffff; overflow-y: scroll; height: 100px; width: 98.3%">
                            </div>
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
                        <td class="height2"></td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="content_tab_left" nowrap='nowrap'>General Appearance and Manner
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
                    <tr>
                        <td class="content_tab_bg" style="padding-left: 10px">
                            <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                <tr>
                                    <td align="center" style="width: 2%">
                                        <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricEvaluations_AppropriatelyDressed"
                                            name="CheckBox_CustomDocumentPsychiatricEvaluations_AppropriatelyDressed" style="cursor: default" />
                                    </td>
                                    <td align="left" style="width: 24%; padding-left: 2px">
                                        <label for="CheckBox_CustomDocumentPsychiatricEvaluations_AppropriatelyDressed" style="cursor: default">
                                            Appropriately dressed & groomed</label>
                                    </td>
                                    <td align="center" style="width: 2%">
                                        <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricEvaluations_GeneralAppearanceUnkept"
                                            name="CheckBox_CustomDocumentPsychiatricEvaluations_GeneralAppearanceUnkept" style="cursor: default" />
                                    </td>
                                    <td align="left" style="width: 20%; padding-left: 2px">
                                        <label for="CheckBox_CustomDocumentPsychiatricEvaluations_GeneralAppearanceUnkept" style="cursor: default">
                                            Unkept</label>
                                    </td>
                                    <td align="center" style="width: 2%">
                                        <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricEvaluations_GeneralAppearanceOther"
                                            name="CheckBox_CustomDocumentPsychiatricEvaluations_GeneralAppearanceOther" style="cursor: default" />
                                    </td>
                                    <td align="left" style="width: 6%; padding-left: 2px">
                                        <label for="CheckBox_CustomDocumentPsychiatricEvaluations_GeneralAppearanceOther" style="cursor: default">
                                            Other</label>
                                    </td>
                                    <td align="left" style="width: 44%">
                                        <input type="text" id="TextBox_CustomDocumentPsychiatricEvaluations_GeneralAppearanceOtherText" name="TextBox_CustomDocumentPsychiatricEvaluations_GeneralAppearanceOtherText" class="form_textbox" style="height: 13px; width: 95%;" />
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
                        <td class="height2"></td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="content_tab_left" nowrap='nowrap'>Musculoskeletal
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
                    <tr>
                        <td class="content_tab_bg" style="padding-left: 10px">
                            <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                <tr>
                                    <td align="center" style="width: 2%">
                                        <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricEvaluations_MuscleStrengthNormal"
                                            name="CheckBox_CustomDocumentPsychiatricEvaluations_MuscleStrengthNormal" style="cursor: default" />
                                    </td>
                                    <td align="left" style="width: 24%; padding-left: 2px">
                                        <label for="CheckBox_CustomDocumentPsychiatricEvaluations_MuscleStrengthNormal" style="cursor: default">
                                            Muscle strength normal</label>
                                    </td>
                                    <td align="center" style="width: 2%">
                                        <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricEvaluations_MuscleStrengthAbnormal"
                                            name="CheckBox_CustomDocumentPsychiatricEvaluations_MuscleStrengthAbnormal" style="cursor: default" />
                                    </td>
                                    <td align="left" style="width: 20%; padding-left: 2px">
                                        <label for="CheckBox_CustomDocumentPsychiatricEvaluations_MuscleStrengthAbnormal" style="cursor: default">
                                            Muscle strength abnormal</label>
                                    </td>
                                    <td align="center" style="width: 2%">
                                        <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricEvaluations_MusculoskeletalTone"
                                            name="CheckBox_CustomDocumentPsychiatricEvaluations_MusculoskeletalTone" style="cursor: default" />
                                    </td>
                                    <td align="left" style="width: 50%; padding-left: 2px">
                                        <label for="CheckBox_CustomDocumentPsychiatricEvaluations_MusculoskeletalTone" style="cursor: default">
                                            Tone</label>
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
                        <td class="height2"></td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="content_tab_left" nowrap='nowrap'>Gait and Station
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
                    <tr>
                        <td class="content_tab_bg" style="padding-left: 10px">
                            <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                <tr>
                                    <td align="center" style="width: 2%">
                                        <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricEvaluations_GaitNormal"
                                            name="CheckBox_CustomDocumentPsychiatricEvaluations_GaitNormal" style="cursor: default" />
                                    </td>
                                    <td align="left" style="width: 24%; padding-left: 2px">
                                        <label for="CheckBox_CustomDocumentPsychiatricEvaluations_GaitNormal" style="cursor: default">
                                            Gait normal</label>
                                    </td>
                                    <td align="center" style="width: 2%">
                                        <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricEvaluations_GaitAbnormal"
                                            name="CheckBox_CustomDocumentPsychiatricEvaluations_GaitAbnormal" style="cursor: default" />
                                    </td>
                                    <td align="left" style="width: 20%; padding-left: 2px">
                                        <label for="CheckBox_CustomDocumentPsychiatricEvaluations_GaitAbnormal" style="cursor: default">
                                            Gait abnormal</label>
                                    </td>
                                    <td align="center" style="width: 2%">
                                        <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricEvaluations_TicsTremorsAbnormalMovements"
                                            name="CheckBox_CustomDocumentPsychiatricEvaluations_TicsTremorsAbnormalMovements" style="cursor: default" />
                                    </td>
                                    <td align="left" style="width: 28%; padding-left: 2px">
                                        <label for="CheckBox_CustomDocumentPsychiatricEvaluations_TicsTremorsAbnormalMovements" style="cursor: default">
                                            Tics, tremors or abnormal movements</label>
                                    </td>
                                    <td align="center" style="width: 2%">
                                        <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricEvaluations_EPS"
                                            name="CheckBox_CustomDocumentPsychiatricEvaluations_EPS" style="cursor: default" />
                                    </td>
                                    <td align="left" style="width: 20%; padding-left: 2px">
                                        <label for="CheckBox_CustomDocumentPsychiatricEvaluations_EPS" style="cursor: default">
                                            EPS</label>
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
                        <td class="height2"></td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="content_tab_left" nowrap='nowrap'>Suicidal/Homicidal
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
                    <tr>
                        <td class="content_tab_bg" style="padding-left: 10px">
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td style="width: 8%">
                                        <span id="Span_Suicidal">Suicidal</span>
                                    </td>
                                    <td align="left" valign="top" style="width: 2%">
                                        <input type="radio" id="RadioButton_CustomDocumentPsychiatricEvaluations_Suicidal_Y" value="Y"
                                            name="RadioButton_CustomDocumentPsychiatricEvaluations_Suicidal" style="cursor: default" />
                                    </td>
                                    <td style="width: 4%">
                                        <label for="RadioButton_CustomDocumentPsychiatricEvaluations_Suicidal_Y" style="cursor: default">Yes</label>
                                    </td>
                                    <td align="left" valign="top" style="width: 2%">
                                        <input type="radio" id="RadioButton_CustomDocumentPsychiatricEvaluations_Suicidal_N" value="N"
                                            name="RadioButton_CustomDocumentPsychiatricEvaluations_Suicidal" style="cursor: default" />
                                    </td>
                                    <td align="left" style="width: 84%">
                                        <label for="RadioButton_CustomDocumentPsychiatricEvaluations_Suicidal_N" style="cursor: default">No</label>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="5" class="height2"></td>
                                </tr>
                                <tr>
                                    <td style="width: 8%">
                                        <span id="Span_Homicidal">Homicidal</span>
                                    </td>
                                    <td align="left" valign="top" style="width: 2%">
                                        <input type="radio" id="RadioButton_CustomDocumentPsychiatricEvaluations_Homicidal_Y" value="Y"
                                            name="RadioButton_CustomDocumentPsychiatricEvaluations_Homicidal" style="cursor: default" />
                                    </td>
                                    <td style="width: 4%">
                                        <label for="RadioButton_CustomDocumentPsychiatricEvaluations_Homicidal_Y" style="cursor: default">Yes</label>
                                    </td>
                                    <td align="left" valign="top" style="width: 2%">
                                        <input type="radio" id="RadioButton_CustomDocumentPsychiatricEvaluations_Homicidal_N" value="N"
                                            name="RadioButton_CustomDocumentPsychiatricEvaluations_Homicidal" style="cursor: default" />
                                    </td>
                                    <td align="left" style="width: 84%">
                                        <label for="RadioButton_CustomDocumentPsychiatricEvaluations_Homicidal_N" style="cursor: default">No</label>
                                    </td>
                                </tr>
                            </table>
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td class="height2"></td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 100%;">
                                        <span id="Span_IndicateIdeation">Indicate ideation, active, passive, intent and plan</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height1" style="width: 100%;"></td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 100%;">
                                        <textarea class="form_textarea" id="TextArea_CustomDocumentPsychiatricEvaluations_IndicateIdeation"
                                            name="TextArea_CustomDocumentPsychiatricEvaluations_IndicateIdeation" rows="4" cols="1" style="width: 98%;"
                                            spellcheck="True" datatype="String"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2"></td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr>
                                                <td style="width: 8%">
                                                    <span id="Span_NotifyStaff1">Notify Staff</span>
                                                </td>
                                                <td style="width: 25%">
                                                    <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentPsychiatricEvaluations_NotifyStaff1" name="DropDownList_CustomDocumentPsychiatricEvaluations_NotifyStaff1"
                                                        Style="width: 95%" runat="server">
                                                    </cc2:StreamlineDropDowns>
                                                </td>
                                                <td style="width: 8%">
                                                    <span id="Span_NotifyStaff2">Notify Staff</span>
                                                </td>
                                                <td style="width: 25%">
                                                    <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentPsychiatricEvaluations_NotifyStaff2" name="DropDownList_CustomDocumentPsychiatricEvaluations_NotifyStaff2"
                                                        Style="width: 98%" runat="server">
                                                    </cc2:StreamlineDropDowns>
                                                </td>
                                                <td style="width: 1%"></td>
                                                <td style="width: 8%">
                                                    <span id="Span_NotifyStaff3">Notify Staff</span>
                                                </td>
                                                <td style="width: 25%">
                                                    <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentPsychiatricEvaluations_NotifyStaff3" name="DropDownList_CustomDocumentPsychiatricEvaluations_NotifyStaff3"
                                                        Style="width: 95%" runat="server">
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
                        <td class="height2"></td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="content_tab_left" nowrap='nowrap'>Psychiatric
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
                    <tr>
                        <td class="content_tab_bg" style="padding-left: 10px">
                            <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                <tr>
                                    <td align="center" style="width: 2%">
                                        <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricEvaluations_AppearanceBehavior"
                                            name="CheckBox_CustomDocumentPsychiatricEvaluations_AppearanceBehavior" style="cursor: default" />
                                    </td>
                                    <td align="left" style="width: 20%; padding-left: 5px">
                                        <label for="CheckBox_CustomDocumentPsychiatricEvaluations_AppearanceBehavior" style="cursor: default">
                                            Appearance and Behavior</label>
                                    </td>
                                    <td align="left" style="width: 78%">
                                        <input type="text" id="TextBox_CustomDocumentPsychiatricEvaluations_AppearanceBehaviorComments" name="TextBox_CustomDocumentPsychiatricEvaluations_AppearanceBehaviorComments" class="form_textbox" style="height: 13px; width: 97.2%;" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2" colspan="3"></td>
                                </tr>
                                <tr>
                                    <td align="center" style="width: 2%">
                                        <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricEvaluations_Speech"
                                            name="CheckBox_CustomDocumentPsychiatricEvaluations_Speech" style="cursor: default" />
                                    </td>
                                    <td align="left" style="width: 20%; padding-left: 5px">
                                        <label for="CheckBox_CustomDocumentPsychiatricEvaluations_Speech" style="cursor: default">
                                            Speech</label>
                                    </td>
                                    <td align="left" style="width: 78%">
                                        <input type="text" id="TextBox_CustomDocumentPsychiatricEvaluations_SpeechComments" name="TextBox_CustomDocumentPsychiatricEvaluations_SpeechComments" class="form_textbox" style="height: 13px; width: 97.2%;" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2" colspan="3"></td>
                                </tr>
                                <tr>
                                    <td align="center" style="width: 2%">
                                        <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricEvaluations_ThoughtProcess"
                                            name="CheckBox_CustomDocumentPsychiatricEvaluations_ThoughtProcess" style="cursor: default" />
                                    </td>
                                    <td align="left" style="width: 20%; padding-left: 5px">
                                        <label for="CheckBox_CustomDocumentPsychiatricEvaluations_ThoughtProcess" style="cursor: default">
                                            Thought Process</label>
                                    </td>
                                    <td align="left" style="width: 78%">
                                        <input type="text" id="TextBox_CustomDocumentPsychiatricEvaluations_ThoughtProcessComments" name="TextBox_CustomDocumentPsychiatricEvaluations_ThoughtProcessComments" class="form_textbox" style="height: 13px; width: 97.2%;" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2" colspan="3"></td>
                                </tr>
                                <tr>
                                    <td align="center" style="width: 2%">
                                        <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricEvaluations_Associations"
                                            name="CheckBox_CustomDocumentPsychiatricEvaluations_Associations" style="cursor: default" />
                                    </td>
                                    <td align="left" style="width: 20%; padding-left: 5px">
                                        <label for="CheckBox_CustomDocumentPsychiatricEvaluations_Associations" style="cursor: default">
                                            Associations</label>
                                    </td>
                                    <td align="left" style="width: 78%">
                                        <input type="text" id="TextBox_CustomDocumentPsychiatricEvaluations_AssociationsComments" name="TextBox_CustomDocumentPsychiatricEvaluations_AssociationsComments" class="form_textbox" style="height: 13px; width: 97.2%;" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2" colspan="3"></td>
                                </tr>
                                <tr>
                                    <td align="center" style="width: 2%">
                                        <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricEvaluations_AbnormalPsychoticThoughts"
                                            name="CheckBox_CustomDocumentPsychiatricEvaluations_AbnormalPsychoticThoughts" style="cursor: default" />
                                    </td>
                                    <td align="left" style="width: 20%; padding-left: 5px">
                                        <label for="CheckBox_CustomDocumentPsychiatricEvaluations_AbnormalPsychoticThoughts" style="cursor: default">
                                            Abnormal/Psychotic Thoughts</label>
                                    </td>
                                    <td align="left" style="width: 78%">
                                        <input type="text" id="TextBox_CustomDocumentPsychiatricEvaluations_AbnormalPsychoticThoughtsComments" name="TextBox_CustomDocumentPsychiatricEvaluations_AbnormalPsychoticThoughtsComments" class="form_textbox" style="height: 13px; width: 97.2%;" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2" colspan="3"></td>
                                </tr>
                                <tr>
                                    <td align="center" style="width: 2%">
                                        <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricEvaluations_JudgmentAndInsight"
                                            name="CheckBox_CustomDocumentPsychiatricEvaluations_JudgmentAndInsight" style="cursor: default" />
                                    </td>
                                    <td align="left" style="width: 20%; padding-left: 5px">
                                        <label for="CheckBox_CustomDocumentPsychiatricEvaluations_JudgmentAndInsight" style="cursor: default">
                                            Judgment and Insight</label>
                                    </td>
                                    <td align="left" style="width: 78%">
                                        <input type="text" id="TextBox_CustomDocumentPsychiatricEvaluations_JudgmentAndInsightComments" name="TextBox_CustomDocumentPsychiatricEvaluations_JudgmentAndInsightComments" class="form_textbox" style="height: 13px; width: 97.2%;" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2" colspan="3"></td>
                                </tr>
                                <tr>
                                    <td align="center" style="width: 2%">
                                        <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricEvaluations_Orientation"
                                            name="CheckBox_CustomDocumentPsychiatricEvaluations_Orientation" style="cursor: default" />
                                    </td>
                                    <td align="left" style="width: 20%; padding-left: 5px">
                                        <label for="CheckBox_CustomDocumentPsychiatricEvaluations_Orientation" style="cursor: default">
                                            Orientation</label>
                                    </td>
                                    <td align="left" style="width: 78%">
                                        <input type="text" id="TextBox_CustomDocumentPsychiatricEvaluations_OrientationComments" name="TextBox_CustomDocumentPsychiatricEvaluations_OrientationComments" class="form_textbox" style="height: 13px; width: 97.2%;" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2" colspan="3"></td>
                                </tr>
                                <tr>
                                    <td align="center" style="width: 2%">
                                        <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricEvaluations_RecentRemoteMemory"
                                            name="CheckBox_CustomDocumentPsychiatricEvaluations_RecentRemoteMemory" style="cursor: default" />
                                    </td>
                                    <td align="left" style="width: 20%; padding-left: 5px">
                                        <label for="CheckBox_CustomDocumentPsychiatricEvaluations_RecentRemoteMemory" style="cursor: default">
                                            Recent and Remote Memory</label>
                                    </td>
                                    <td align="left" style="width: 78%">
                                        <input type="text" id="TextBox_CustomDocumentPsychiatricEvaluations_RecentRemoteMemoryComments" name="TextBox_CustomDocumentPsychiatricEvaluations_RecentRemoteMemoryComments" class="form_textbox" style="height: 13px; width: 97.2%;" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2" colspan="3"></td>
                                </tr>
                                <tr>
                                    <td align="center" style="width: 2%">
                                        <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricEvaluations_AttentionConcentration"
                                            name="CheckBox_CustomDocumentPsychiatricEvaluations_AttentionConcentration" style="cursor: default" />
                                    </td>
                                    <td align="left" style="width: 20%; padding-left: 5px">
                                        <label for="CheckBox_CustomDocumentPsychiatricEvaluations_AttentionConcentration" style="cursor: default">
                                            Attention and Concentration</label>
                                    </td>
                                    <td align="left" style="width: 78%">
                                        <input type="text" id="TextBox_CustomDocumentPsychiatricEvaluations_AttentionConcentrationComments" name="TextBox_CustomDocumentPsychiatricEvaluations_AttentionConcentrationComments" class="form_textbox" style="height: 13px; width: 97.2%;" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2" colspan="3"></td>
                                </tr>
                                <tr>
                                    <td align="center" style="width: 2%">
                                        <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricEvaluations_Language"
                                            name="CheckBox_CustomDocumentPsychiatricEvaluations_Language" style="cursor: default" />
                                    </td>
                                    <td align="left" style="width: 20%; padding-left: 5px">
                                        <label for="CheckBox_CustomDocumentPsychiatricEvaluations_Language" style="cursor: default">
                                            Language</label>
                                    </td>
                                    <td align="left" style="width: 78%">
                                        <input type="text" id="TextBox_CustomDocumentPsychiatricEvaluations_LanguageCommments" name="TextBox_CustomDocumentPsychiatricEvaluations_LanguageCommments" class="form_textbox" style="height: 13px; width: 97.2%;" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2" colspan="3"></td>
                                </tr>
                                <tr>
                                    <td align="center" style="width: 2%">
                                        <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricEvaluations_FundOfKnowledge"
                                            name="CheckBox_CustomDocumentPsychiatricEvaluations_FundOfKnowledge" style="cursor: default" />
                                    </td>
                                    <td align="left" style="width: 20%; padding-left: 5px">
                                        <label for="CheckBox_CustomDocumentPsychiatricEvaluations_FundOfKnowledge" style="cursor: default">
                                            Fund of Knowledge</label>
                                    </td>
                                    <td align="left" style="width: 78%">
                                        <input type="text" id="TextBox_CustomDocumentPsychiatricEvaluations_FundOfKnowledgeComments" name="TextBox_CustomDocumentPsychiatricEvaluations_FundOfKnowledgeComments" class="form_textbox" style="height: 13px; width: 97.2%;" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2" colspan="3"></td>
                                </tr>
                                <tr>
                                    <td align="center" style="width: 2%">
                                        <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricEvaluations_MoodAndAffect"
                                            name="CheckBox_CustomDocumentPsychiatricEvaluations_MoodAndAffect" style="cursor: default" />
                                    </td>
                                    <td align="left" style="width: 20%; padding-left: 5px">
                                        <label for="CheckBox_CustomDocumentPsychiatricEvaluations_MoodAndAffect" style="cursor: default">
                                            Mood and Affect</label>
                                    </td>
                                    <td align="left" style="width: 78%">
                                        <input type="text" id="TextBox_CustomDocumentPsychiatricEvaluations_MoodAndAffectComments" name="TextBox_CustomDocumentPsychiatricEvaluations_MoodAndAffectComments" class="form_textbox" style="height: 13px; width: 97.2%;" />
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
                </table>
            </td>
        </tr>
    </table>
</div>
