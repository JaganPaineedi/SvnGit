<%@ Control Language="C#" AutoEventWireup="true" CodeFile="IndividualServiceNoteDBT.ascx.cs"
    Inherits="Custom_IndividualServiceNote_WebPages_IndividualServiceNoteDBT" %>
<div class="DocumentScreen">
    <table border="0" cellspacing="0" cellpadding="0" style="width: 100%">
        <tr>
            <td>
                <table border="0" cellpadding="0" cellspacing="0" width="98%">
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="content_tab_left" nowrap='nowrap'>
                                        <span class="form_label" id="SpanParticipants">Participants</span>
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
                                    <td style="padding-left: 2px;" colspan="2">
                                        <span id="SpanNameAndNature" class="form_label">Name and nature of significant other(s)
                                            involvement</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding-left: 2px;" colspan="2">
                                        <textarea class="form_textarea" id="TextArea_CustomDocumentDBTs_SignificantInvolvement"
                                            name="TextArea_CustomDocumentDBTs_SignificantInvolvement" rows="4" cols="1" style="width: 98%;"
                                            spellcheck="True" datatype="String"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding-left: 2px;" colspan="2">
                                        <span id="SpanOtherInvolvement" class="form_label">Other involvement details</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding-left: 2px;" colspan="2">
                                        <textarea class="form_textarea" id="TextArea_CustomDocumentDBTs_OtherInvolvementDetail"
                                            name="TextArea_CustomDocumentDBTs_OtherInvolvementDetail" rows="4" cols="1" style="width: 98%;"
                                            spellcheck="True" datatype="String"></textarea>
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
            <td class="height1">
                &nbsp;
            </td>
        </tr>
        <tr>
            <td>
                <table border="0" cellpadding="0" cellspacing="0" width="98%">
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="content_tab_left" nowrap='nowrap'>
                                        <span class="form_label" id="SpanTreatmentFocus">Treatment Focus</span>
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
                                    <td style="padding-left: 2px;">
                                        <span id="SpanMindfulnessSkills" class="form_label"><b>Mindfulness Skills</b></span>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding-left: 2px;">
                                        <table>
                                            <tr>
                                                <td style="padding-left: 2px;">
                                                    <table>
                                                        <tr class="checkbox_container">
                                                            <td align="center" valign="middle">
                                                                <input type="checkbox" id="CheckBox_CustomDocumentDBTs_WiseMind" name="CheckBox_CustomDocumentDBTs_WiseMind" />
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <label id="WiseMind" name="WiseMind" for="CheckBox_CustomDocumentDBTs_WiseMind" class="CrossBrowserAutoFix_margin-left_3px">
                                                                    Wise Mind</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td style="padding-left: 2px;">
                                                    <table>
                                                        <tr class="checkbox_container">
                                                            <td align="center" valign="middle">
                                                                <input type="checkbox" id="CheckBox_CustomDocumentDBTs_ObserveNotice" name="CheckBox_CustomDocumentDBTs_ObserveNotice" />
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <label id="ObserveNotice" name="ObserveNotice" for="CheckBox_CustomDocumentDBTs_ObserveNotice"
                                                                    class="CrossBrowserAutoFix_margin-left_3px">
                                                                    Observe Just Notice</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td style="padding-left: 2px;">
                                                    <table>
                                                        <tr class="checkbox_container">
                                                            <td align="center" valign="middle">
                                                                <input type="checkbox" id="CheckBox_CustomDocumentDBTs_DescribeWords" name="CheckBox_CustomDocumentDBTs_DescribeWords" />
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <label id="DescribeWords" name="DescribeWords" for="CheckBox_CustomDocumentDBTs_DescribeWords"
                                                                    class="CrossBrowserAutoFix_margin-left_3px">
                                                                    Describe Put Into Words</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td style="padding-left: 2px;">
                                                    <table>
                                                        <tr class="checkbox_container">
                                                            <td align="center" valign="middle">
                                                                <input type="checkbox" id="CheckBox_CustomDocumentDBTs_Participate" name="CheckBox_CustomDocumentDBTs_Participate" />
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <label id="Participate" name="Participate" for="CheckBox_CustomDocumentDBTs_Participate"
                                                                    class="CrossBrowserAutoFix_margin-left_3px">
                                                                    Participate</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td style="padding-left: 2px;">
                                                    <table>
                                                        <tr class="checkbox_container">
                                                            <td align="center" valign="middle">
                                                                <input type="checkbox" id="CheckBox_CustomDocumentDBTs_NonJudgmentalStance" name="CheckBox_CustomDocumentDBTs_NonJudgmentalStance" />
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <label id="NonJudgmentalStance" name="NonJudgmentalStance" for="CheckBox_CustomDocumentDBTs_NonJudgmentalStance"
                                                                    class="CrossBrowserAutoFix_margin-left_3px">
                                                                    Non-Judgmental Stance</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td style="padding-left: 2px;">
                                                    <table>
                                                        <tr class="checkbox_container">
                                                            <td align="center" valign="middle">
                                                                <input type="checkbox" id="CheckBox_CustomDocumentDBTs_MindfulSkill" name="CheckBox_CustomDocumentDBTs_MindfulSkill" />
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <label id="MindfulSkill" name="MindfulSkill" for="CheckBox_CustomDocumentDBTs_MindfulSkill"
                                                                    class="CrossBrowserAutoFix_margin-left_3px">
                                                                    One- Mindful</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td style="padding-left: 2px;">
                                                    <table>
                                                        <tr class="checkbox_container">
                                                            <td align="center" valign="middle">
                                                                <input type="checkbox" id="CheckBox_CustomDocumentDBTs_Effectiveness" name="CheckBox_CustomDocumentDBTs_Effectiveness" />
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <label id="Effectiveness" name="Effectiveness" for="CheckBox_CustomDocumentDBTs_Effectiveness"
                                                                    class="CrossBrowserAutoFix_margin-left_3px">
                                                                    Effectiveness</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding-left: 2px; padding-top:5px;">
                                        <span id="SpanInterpersonalSkills" class="form_label"><b>Interpersonal Skills</b></span>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding-left: 2px;">
                                        <table>
                                            <tr>
                                                <td style="padding-left: 2px;">
                                                    <table>
                                                        <tr class="checkbox_container">
                                                            <td align="center" valign="middle">
                                                                <input type="checkbox" id="CheckBox_CustomDocumentDBTs_DearMan" name="CheckBox_CustomDocumentDBTs_DearMan" />
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <label id="DearMan" name="DearMan" for="CheckBox_CustomDocumentDBTs_DearMan" class="CrossBrowserAutoFix_margin-left_3px">
                                                                    DEAR MAN</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td style="padding-left: 2px;">
                                                    <table>
                                                        <tr class="checkbox_container">
                                                            <td align="center" valign="middle">
                                                                <input type="checkbox" id="CheckBox_CustomDocumentDBTs_GiveInterpersonalSkill" name="CheckBox_CustomDocumentDBTs_GiveInterpersonalSkill" />
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <label id="GiveInterpersonalSkill" name="GiveInterpersonalSkill" for="CheckBox_CustomDocumentDBTs_GiveInterpersonalSkill"
                                                                    class="CrossBrowserAutoFix_margin-left_3px">
                                                                    GIVE</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td style="padding-left: 2px;">
                                                    <table>
                                                        <tr class="checkbox_container">
                                                            <td align="center" valign="middle">
                                                                <input type="checkbox" id="CheckBox_CustomDocumentDBTs_FastInterpersonalSkill" name="CheckBox_CustomDocumentDBTs_FastInterpersonalSkill" />
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <label id="FastInterpersonalSkill" name="FastInterpersonalSkill" for="CheckBox_CustomDocumentDBTs_FastInterpersonalSkill"
                                                                    class="CrossBrowserAutoFix_margin-left_3px">
                                                                    FAST</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding-left: 2px; padding-top:5px;">
                                        <span id="SpanEmotionalRegulationSkills" class="form_label"><b>Emotional Regulation
                                            Skills</b></span>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding-left: 2px;">
                                        <table>
                                            <tr>
                                                <td style="padding-left: 2px;">
                                                    <table>
                                                        <tr class="checkbox_container">
                                                            <td align="center" valign="middle">
                                                                <input type="checkbox" id="CheckBox_CustomDocumentDBTs_PleaseEmotionalRegulationSkill"
                                                                    name="CheckBox_CustomDocumentDBTs_PleaseEmotionalRegulationSkill" />
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <label id="PleaseEmotionalRegulationSkill" name="PleaseEmotionalRegulationSkill"
                                                                    for="CheckBox_CustomDocumentDBTs_PleaseEmotionalRegulationSkill" class="CrossBrowserAutoFix_margin-left_3px">
                                                                    PLEASE</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td style="padding-left: 2px;">
                                                    <table>
                                                        <tr class="checkbox_container">
                                                            <td align="center" valign="middle">
                                                                <input type="checkbox" id="CheckBox_CustomDocumentDBTs_Mastery" name="CheckBox_CustomDocumentDBTs_Mastery" />
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <label id="Mastery" name="Mastery" for="CheckBox_CustomDocumentDBTs_Mastery" class="CrossBrowserAutoFix_margin-left_3px">
                                                                    Mastery</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td style="padding-left: 2px;">
                                                    <table>
                                                        <tr class="checkbox_container">
                                                            <td align="center" valign="middle">
                                                                <input type="checkbox" id="CheckBox_CustomDocumentDBTs_PostiveExperience" name="CheckBox_CustomDocumentDBTs_PostiveExperience" />
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <label id="PostiveExperience" name="PostiveExperience" for="CheckBox_CustomDocumentDBTs_PostiveExperience"
                                                                    class="CrossBrowserAutoFix_margin-left_3px">
                                                                    Build Positive Experiences</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td style="padding-left: 2px;">
                                                    <table>
                                                        <tr class="checkbox_container">
                                                            <td align="center" valign="middle">
                                                                <input type="checkbox" id="CheckBox_CustomDocumentDBTs_ActOpposite" name="CheckBox_CustomDocumentDBTs_ActOpposite" />
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <label id="ActOpposite" name="ActOpposite" for="CheckBox_CustomDocumentDBTs_ActOpposite"
                                                                    class="CrossBrowserAutoFix_margin-left_3px">
                                                                    Act Opposite to Emotion</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding-left: 2px; padding-top:5px;">
                                        <span id="SpanDistressToleranceSkills" class="form_label"><b>Distress Tolerance Skills</b></span>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding-left: 2px;">
                                        <table>
                                            <tr>
                                                <td style="padding-left: 2px;">
                                                    <table>
                                                        <tr class="checkbox_container">
                                                            <td align="center" valign="middle">
                                                                <input type="checkbox" id="CheckBox_CustomDocumentDBTs_DistractSkill" name="CheckBox_CustomDocumentDBTs_DistractSkill" />
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <label id="DistractSkill" name="DistractSkill" for="CheckBox_CustomDocumentDBTs_DistractSkill"
                                                                    class="CrossBrowserAutoFix_margin-left_3px">
                                                                    Distract</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td style="padding-left: 2px;">
                                                    <table>
                                                        <tr class="checkbox_container">
                                                            <td align="center" valign="middle">
                                                                <input type="checkbox" id="CheckBox_CustomDocumentDBTs_SelfSootheSkill" name="CheckBox_CustomDocumentDBTs_SelfSootheSkill" />
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <label id="SelfSootheSkill" name="SelfSootheSkill" for="CheckBox_CustomDocumentDBTs_SelfSootheSkill"
                                                                    class="CrossBrowserAutoFix_margin-left_3px">
                                                                    Self Soothe</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td style="padding-left: 2px;">
                                                    <table>
                                                        <tr class="checkbox_container">
                                                            <td align="center" valign="middle">
                                                                <input type="checkbox" id="CheckBox_CustomDocumentDBTs_ImproveMoment" name="CheckBox_CustomDocumentDBTs_ImproveMoment" />
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <label id="ImproveMoment" name="ImproveMoment" for="CheckBox_CustomDocumentDBTs_ImproveMoment"
                                                                    class="CrossBrowserAutoFix_margin-left_3px">
                                                                    IMPROVE the Moment</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td style="padding-left: 2px;">
                                                    <table>
                                                        <tr class="checkbox_container">
                                                            <td align="center" valign="middle">
                                                                <input type="checkbox" id="CheckBox_CustomDocumentDBTs_ProsConsSkill" name="CheckBox_CustomDocumentDBTs_ProsConsSkill" />
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <label id="ProsConsSkill" name="ProsConsSkill" for="CheckBox_CustomDocumentDBTs_ProsConsSkill"
                                                                    class="CrossBrowserAutoFix_margin-left_3px">
                                                                    Pros and Cons</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td style="padding-left: 2px;">
                                                    <table>
                                                        <tr class="checkbox_container">
                                                            <td align="center" valign="middle">
                                                                <input type="checkbox" id="CheckBox_CustomDocumentDBTs_RadicalAcceptance" name="CheckBox_CustomDocumentDBTs_RadicalAcceptance" />
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <label id="RadicalAcceptance" name="RadicalAcceptance" for="CheckBox_CustomDocumentDBTs_RadicalAcceptance"
                                                                    class="CrossBrowserAutoFix_margin-left_3px">
                                                                    Radical Acceptance</label>
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
            <td class="height1">
                &nbsp;
            </td>
        </tr>
        <tr>
            <td>
                <table border="0" cellpadding="0" cellspacing="0" width="98%">
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="content_tab_left" nowrap='nowrap'>
                                        <span class="form_label" id="SpanTreatmentMethodsProvided">Treatment Methods Provided</span>
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
                                    <td style="padding-left: 2px;">
                                        <span id="SpanSkillAcquisition" class="form_label"><b>Skill Acquisition</b></span>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding-left: 2px;">
                                        <table>
                                            <tr>
                                                <td style="padding-left: 2px;">
                                                    <table>
                                                        <tr class="checkbox_container">
                                                            <td align="center" valign="middle">
                                                                <input type="checkbox" id="CheckBox_CustomDocumentDBTs_AssessingAbilities" name="CheckBox_CustomDocumentDBTs_AssessingAbilities" />
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <label id="AssessingAbilities" name="AssessingAbilities" for="CheckBox_CustomDocumentDBTs_AssessingAbilities"
                                                                    class="CrossBrowserAutoFix_margin-left_3px">
                                                                    Assessing Abilities</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td style="padding-left: 2px;">
                                                    <table>
                                                        <tr class="checkbox_container">
                                                            <td align="center" valign="middle">
                                                                <input type="checkbox" id="CheckBox_CustomDocumentDBTs_Instructions" name="CheckBox_CustomDocumentDBTs_Instructions" />
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <label id="Instructions" name="Instructions" for="CheckBox_CustomDocumentDBTs_Instructions"
                                                                    class="CrossBrowserAutoFix_margin-left_3px">
                                                                    Instructions</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td style="padding-left: 2px;">
                                                    <table>
                                                        <tr class="checkbox_container">
                                                            <td align="center" valign="middle">
                                                                <input type="checkbox" id="CheckBox_CustomDocumentDBTs_Modeling" name="CheckBox_CustomDocumentDBTs_Modeling" />
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <label id="Modeling" name="Modeling" for="CheckBox_CustomDocumentDBTs_Modeling" class="CrossBrowserAutoFix_margin-left_3px">
                                                                    Modeling</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding-left: 2px; padding-top:5px;">
                                        <span id="SpanSkillStrengthening" class="form_label"><b>Skill Strengthening</b></span>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding-left: 2px;">
                                        <table>
                                            <tr>
                                                <td style="padding-left: 2px;">
                                                    <table>
                                                        <tr class="checkbox_container">
                                                            <td align="center" valign="middle">
                                                                <input type="checkbox" id="CheckBox_CustomDocumentDBTs_BehavioralRehearsal" name="CheckBox_CustomDocumentDBTs_BehavioralRehearsal" />
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <label id="BehavioralRehearsal" name="BehavioralRehearsal" for="CheckBox_CustomDocumentDBTs_BehavioralRehearsal"
                                                                    class="CrossBrowserAutoFix_margin-left_3px">
                                                                    Behavioral Rehearsal</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td style="padding-left: 2px;">
                                                    <table>
                                                        <tr class="checkbox_container">
                                                            <td align="center" valign="middle">
                                                                <input type="checkbox" id="CheckBox_CustomDocumentDBTs_FeedbackCoaching" name="CheckBox_CustomDocumentDBTs_FeedbackCoaching" />
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <label id="FeedbackCoaching" name="FeedbackCoaching" for="CheckBox_CustomDocumentDBTs_FeedbackCoaching"
                                                                    class="CrossBrowserAutoFix_margin-left_3px">
                                                                    Feedback and Coaching</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td style="padding-left: 2px;">
                                                    <table>
                                                        <tr class="checkbox_container">
                                                            <td align="center" valign="middle">
                                                                <input type="checkbox" id="CheckBox_CustomDocumentDBTs_ResponseReinforcement" name="CheckBox_CustomDocumentDBTs_ResponseReinforcement" />
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <label id="ResponseReinforcement" name="ResponseReinforcement" for="CheckBox_CustomDocumentDBTs_ResponseReinforcement"
                                                                    class="CrossBrowserAutoFix_margin-left_3px">
                                                                    Response Reinforcement</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding-left: 2px; padding-top:5px;">
                                        <span id="SpanSkillGeneralization" class="form_label"><b>Skill Generalization</b></span>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding-left: 2px;">
                                        <table>
                                            <tr>
                                                <td style="padding-left: 2px;">
                                                    <table>
                                                        <tr class="checkbox_container">
                                                            <td align="center" valign="middle">
                                                                <input type="checkbox" id="CheckBox_CustomDocumentDBTs_HomeworkAssignment" name="CheckBox_CustomDocumentDBTs_HomeworkAssignment" />
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <label id="HomeworkAssignment" name="HomeworkAssignment" for="CheckBox_CustomDocumentDBTs_HomeworkAssignment"
                                                                    class="CrossBrowserAutoFix_margin-left_3px">
                                                                    Homework Assignment</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td style="padding-left: 2px;">
                                                    <table>
                                                        <tr class="checkbox_container">
                                                            <td align="center" valign="middle">
                                                                <input type="checkbox" id="CheckBox_CustomDocumentDBTs_DiscussionSimilarities" name="CheckBox_CustomDocumentDBTs_DiscussionSimilarities" />
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <label id="DiscussionSimilarities" name="DiscussionSimilarities" for="CheckBox_CustomDocumentDBTs_DiscussionSimilarities"
                                                                    class="CrossBrowserAutoFix_margin-left_3px">
                                                                    Discussion of similarities and differences in situations</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding-left: 2px; padding-top:5px;">
                                        <span id="SpanSkillReview" class="form_label"><b>Skill Review</b></span>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding-left: 2px;">
                                        <table>
                                            <tr>
                                                <td style="padding-left: 2px;">
                                                    <table>
                                                        <tr class="checkbox_container">
                                                            <td align="center" valign="middle">
                                                                <input type="checkbox" id="CheckBox_CustomDocumentDBTs_ReviewDiaryCard" name="CheckBox_CustomDocumentDBTs_ReviewDiaryCard" />
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <label id="ReviewDiaryCard" name="ReviewDiaryCard" for="CheckBox_CustomDocumentDBTs_ReviewDiaryCard"
                                                                    class="CrossBrowserAutoFix_margin-left_3px">
                                                                    Review of Diary Card</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td style="padding-left: 2px;">
                                                    <table>
                                                        <tr class="checkbox_container">
                                                            <td align="center" valign="middle">
                                                                <input type="checkbox" id="CheckBox_CustomDocumentDBTs_BehavioralChainAnalysis" name="CheckBox_CustomDocumentDBTs_BehavioralChainAnalysis" />
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <label id="BehavioralChainAnalysis" name="BehavioralChainAnalysis" for="CheckBox_CustomDocumentDBTs_BehavioralChainAnalysis"
                                                                    class="CrossBrowserAutoFix_margin-left_3px">
                                                                    Behavioral Chain Analysis</label>
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
