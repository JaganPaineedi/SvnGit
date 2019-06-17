<%@ Control Language="C#" AutoEventWireup="true" CodeFile="IndividualServiceNoteGeneral.ascx.cs"
    Inherits="Custom_IndividualServiceNote_WebPages_IndividualServiceNoteGeneral" %>
<%--<%@ Register Src="~/Custom/Common/WebPages/CustomBillingDiagnosis.ascx" TagName="CustomBillingDiagnosis"
    TagPrefix="uc1" %>--%>
    <%@ Register Src="~/ActivityPages/Client/Detail/IndividualServiceNote/ServiceNoteInformation.ascx"
    TagName="Information" TagPrefix="uc3" %>
<style type="text/css">
    .style1
    {
        width: 20px;
    }
</style>
<div class="DocumentScreen">
    <input id="HiddenFieldGoalsAndObjectives" name="HiddenFieldGoalsAndObjectives" type="hidden"
        runat="server" />        
    <table border="0" cellspacing="0" cellpadding="0" style="width: 100%">
        <tr>
            <td>
                      <%--<uc1:CustomBillingDiagnosis ID="CustomBillingDiagnosis" runat="server" />  --%>    
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
                                        <span class="form_label" id="SpanInformation">Information</span>
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
                        <td class="content_tab_bg" align="left" valign="top" style="height: 15px;">
                            <uc3:Information ID="InformationUC" runat="server"></uc3:Information>
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
                                        <span class="form_label" id="SpanTracksEBPsUtilization">Tracks/EBPs Utilized During
                                            the Session</span>
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
                                        <table>
                                            <tr>
                                                <td style="padding-left: 2px;">
                                                    <table>
                                                        <tr class="checkbox_container">
                                                            <td align="center" valign="middle">
                                                                <input type="checkbox" id="CheckBox_CustomDocumentIndividualServiceNoteGenerals_DBT"
                                                                    name="CheckBox_CustomDocumentIndividualServiceNoteGenerals_DBT" onclick="EnableOrDisableDBTTab();"/>
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <label id="DBT" name="DBT" for="CheckBox_CustomDocumentIndividualServiceNoteGenerals_DBT"
                                                                    class="CrossBrowserAutoFix_margin-left_3px">
                                                                    DBT</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td style="padding-left: 2px;">
                                                    <table>
                                                        <tr class="checkbox_container">
                                                            <td align="center" valign="middle">
                                                                <input type="checkbox" id="CheckBox_CustomDocumentIndividualServiceNoteGenerals_OQYOQ"
                                                                    name="CheckBox_CustomDocumentIndividualServiceNoteGenerals_OQYOQ" />
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <label id="OQYOQ" name="OQYOQ" for="CheckBox_CustomDocumentIndividualServiceNoteGenerals_OQYOQ"
                                                                    class="CrossBrowserAutoFix_margin-left_3px">
                                                                    OQ/YOQ</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td style="padding-left: 2px;">
                                                    <table>
                                                        <tr class="checkbox_container">
                                                            <td align="center" valign="middle">
                                                                <input type="checkbox" id="CheckBox_CustomDocumentIndividualServiceNoteGenerals_MotivationalInterviewing"
                                                                    name="CheckBox_CustomDocumentIndividualServiceNoteGenerals_MotivationalInterviewing" />
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <label id="MotivationalInterviewing" name="MotivationalInterviewing" for="CheckBox_CustomDocumentIndividualServiceNoteGenerals_MotivationalInterviewing"
                                                                    class="CrossBrowserAutoFix_margin-left_3px">
                                                                    Motivational Interviewing (MI)</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td style="padding-left: 2px;">
                                                    <table>
                                                        <tr class="checkbox_container">
                                                            <td align="center" valign="middle">
                                                                <input type="checkbox" id="CheckBox_CustomDocumentIndividualServiceNoteGenerals_EMDR"
                                                                    name="CheckBox_CustomDocumentIndividualServiceNoteGenerals_EMDR" />
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <label id="EMDR" name="EMDR" for="CheckBox_CustomDocumentIndividualServiceNoteGenerals_EMDR"
                                                                    class="CrossBrowserAutoFix_margin-left_3px">
                                                                    EMDR</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td style="padding-left: 2px;">
                                                    <table>
                                                        <tr class="checkbox_container">
                                                            <td align="center" valign="middle">
                                                                <input type="checkbox" id="CheckBox_CustomDocumentIndividualServiceNoteGenerals_DV"
                                                                    name="CheckBox_CustomDocumentIndividualServiceNoteGenerals_DV" />
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <label id="DV" name="DV" for="CheckBox_CustomDocumentIndividualServiceNoteGenerals_DV"
                                                                    class="CrossBrowserAutoFix_margin-left_3px">
                                                                    DV</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td style="padding-left: 2px;">
                                                    <table>
                                                        <tr class="checkbox_container">
                                                            <td align="center" valign="middle">
                                                                <input type="checkbox" id="CheckBox_CustomDocumentIndividualServiceNoteGenerals_TFCBT"
                                                                    name="CheckBox_CustomDocumentIndividualServiceNoteGenerals_TFCBT" />
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <label id="TFCBT" name="TFCBT" for="CheckBox_CustomDocumentIndividualServiceNoteGenerals_TFCBT"
                                                                    class="CrossBrowserAutoFix_margin-left_3px">
                                                                    TF-CBT</label>
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
                            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                <tr>
                                    <td class="height2">
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td class="content_tab_left" align="left" nowrap="nowrap">
                                        <span id="Title" class="form_label">Care Plan Objectives Addressed by this Service</span>
                                    </td>
                                    <td width="17">
                                        <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif"
                                            width="17" height="26" alt="" />
                                    </td>
                                    <td class="content_tab_top" width="100%">
                                        <div style="vertical-align: middle;">
                                            <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentIndividualServiceNoteGenerals_ShowSelectedItem"
                                                name="CheckBox_CustomDocumentIndividualServiceNoteGenerals_ShowSelectedItem" onclick="javaScript:ShowCheckedGoalsObjectives(this)" />
                                            <span id="ShowItems" class="form_label">Show only selected items </span>
                                        </div>
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
                        <td style="padding-left: 15px" class="content_tab_bg">
                            <table width="100%" id="GoalObj">
                                <tr>
                                    <td>
                                        <div id="GoalsObj">
                                        </div>
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
                                        <span class="form_label" id="SpanClientCurrentCondition">Client's Current Condition</span>
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
                                        <table border="0" cellspacing="0" cellpadding="0" style="width: 100%">
                                            <tr>
                                                <td style="padding-left: 2px;">
                                                    <table>
                                                        <tr>
                                                            <td style="padding-left: 2px; width: 20%">
                                                                <span class="form_label" id="SpanMoodAffect">Mood/Affect</span>
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                    <tr class="checkbox_container">
                                                                        <td>
                                                                            <input type="radio" id="RadioButton_CustomDocumentIndividualServiceNoteGenerals_MoodAffect_N"
                                                                                name="RadioButton_CustomDocumentIndividualServiceNoteGenerals_MoodAffect" value="N" />
                                                                        </td>
                                                                        <td>
                                                                            <label id="MoodAffectUnremarkable" for="RadioButton_CustomDocumentIndividualServiceNoteGenerals_MoodAffect_N">
                                                                                Unremarkable</label>
                                                                        </td>
                                                                        <td style="width: 15px;">
                                                                            &nbsp;
                                                                        </td>
                                                                        <td>
                                                                            <input type="radio" id="RadioButton_CustomDocumentIndividualServiceNoteGenerals_MoodAffect_Y"
                                                                                name="RadioButton_CustomDocumentIndividualServiceNoteGenerals_MoodAffect" value="Y" />
                                                                        </td>
                                                                        <td>
                                                                            <label id="MoodAffectRemarkable" for="RadioButton_CustomDocumentIndividualServiceNoteGenerals_MoodAffect_Y">
                                                                                Remarkable</label>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td style="padding-left: 5px;">
                                                                <input class="form_textbox" type="text" id="TextBox_CustomDocumentIndividualServiceNoteGenerals_MoodAffectComments"
                                                                    name="TextBox_CustomDocumentIndividualServiceNoteGenerals_MoodAffectComments"
                                                                    style="width: 462px;" maxlength="150" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="padding-left: 2px;">
                                                    <table>
                                                        <tr>
                                                            <td style="padding-left: 2px; width: 20%">
                                                                <span class="form_label" id="SpanThoughtProcessOrientation">Thought Process/Orientation</span>
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                    <tr class="checkbox_container">
                                                                        <td>
                                                                            <input type="radio" id="RadioButton_CustomDocumentIndividualServiceNoteGenerals_ThoughtProcess_N"
                                                                                name="RadioButton_CustomDocumentIndividualServiceNoteGenerals_ThoughtProcess"
                                                                                value="N" />
                                                                        </td>
                                                                        <td>
                                                                            <label id="ThoughtProcessUnremarkable" for="RadioButton_CustomDocumentIndividualServiceNoteGenerals_ThoughtProcess_N">
                                                                                Unremarkable</label>
                                                                        </td>
                                                                        <td style="width: 15px;">
                                                                            &nbsp;
                                                                        </td>
                                                                        <td>
                                                                            <input type="radio" id="RadioButton_CustomDocumentIndividualServiceNoteGenerals_ThoughtProcess_Y"
                                                                                name="RadioButton_CustomDocumentIndividualServiceNoteGenerals_ThoughtProcess"
                                                                                value="Y" />
                                                                        </td>
                                                                        <td>
                                                                            <label id="ThoughtProcessremarkable" for="RadioButton_CustomDocumentIndividualServiceNoteGenerals_ThoughtProcess_Y">
                                                                                Remarkable</label>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td style="padding-left: 5px;">
                                                                <input class="form_textbox" type="text" id="TextBox_CustomDocumentIndividualServiceNoteGenerals_ThoughtProcessComments"
                                                                    name="TextBox_CustomDocumentIndividualServiceNoteGenerals_ThoughtProcessComments"
                                                                    style="width: 462px;" maxlength="150" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="padding-left: 2px;">
                                                    <table>
                                                        <tr>
                                                            <td style="padding-left: 2px; width: 20%">
                                                                <span class="form_label" id="SpanBehaviorFunctioning">Behavior/Functioning</span>
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                    <tr class="checkbox_container">
                                                                        <td>
                                                                            <input type="radio" id="RadioButton_CustomDocumentIndividualServiceNoteGenerals_Behavior_N"
                                                                                name="RadioButton_CustomDocumentIndividualServiceNoteGenerals_Behavior" value="N" />
                                                                        </td>
                                                                        <td>
                                                                            <label id="BehaviorUnremarkable" for="RadioButton_CustomDocumentIndividualServiceNoteGenerals_Behavior_N">
                                                                                Unremarkable</label>
                                                                        </td>
                                                                        <td style="width: 15px;">
                                                                            &nbsp;
                                                                        </td>
                                                                        <td>
                                                                            <input type="radio" id="RadioButton_CustomDocumentIndividualServiceNoteGenerals_Behavior_Y"
                                                                                name="RadioButton_CustomDocumentIndividualServiceNoteGenerals_Behavior" value="Y" />
                                                                        </td>
                                                                        <td>
                                                                            <label id="BehaviorRemarkable" for="RadioButton_CustomDocumentIndividualServiceNoteGenerals_Behavior_Y">
                                                                                Remarkable</label>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td style="padding-left: 5px;">
                                                                <input class="form_textbox" type="text" id="TextBox_CustomDocumentIndividualServiceNoteGenerals_BehaviorComments"
                                                                    name="TextBox_CustomDocumentIndividualServiceNoteGenerals_BehaviorComments" style="width: 462px;"
                                                                    maxlength="150" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="padding-left: 2px;">
                                                    <table>
                                                        <tr>
                                                            <td style="padding-left: 2px; width: 20%">
                                                                <span class="form_label" id="SpanMedicalCondition">Medical Condition</span>
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                    <tr class="checkbox_container">
                                                                        <td>
                                                                            <input type="radio" id="RadioButton_CustomDocumentIndividualServiceNoteGenerals_MedicalCondition_N"
                                                                                name="RadioButton_CustomDocumentIndividualServiceNoteGenerals_MedicalCondition"
                                                                                value="N" />
                                                                        </td>
                                                                        <td>
                                                                            <label id="MedicalConditionUnremarkable" for="RadioButton_CustomDocumentIndividualServiceNoteGenerals_MedicalCondition_N">
                                                                                Unremarkable</label>
                                                                        </td>
                                                                        <td style="width: 15px;">
                                                                            &nbsp;
                                                                        </td>
                                                                        <td>
                                                                            <input type="radio" id="RadioButton_CustomDocumentIndividualServiceNoteGenerals_MedicalCondition_Y"
                                                                                name="RadioButton_CustomDocumentIndividualServiceNoteGenerals_MedicalCondition"
                                                                                value="Y" />
                                                                        </td>
                                                                        <td>
                                                                            <label id="MedicalConditionRemarkable" for="RadioButton_CustomDocumentIndividualServiceNoteGenerals_MedicalCondition_Y">
                                                                                Remarkable</label>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td style="padding-left: 5px;">
                                                                <input class="form_textbox" type="text" id="TextBox_CustomDocumentIndividualServiceNoteGenerals_MedicalConditionComments"
                                                                    name="TextBox_CustomDocumentIndividualServiceNoteGenerals_MedicalConditionComments"
                                                                    style="width: 462px;" maxlength="150" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="padding-left: 2px;">
                                                    <table>
                                                        <tr>
                                                            <td style="padding-left: 2px; width: 20%">
                                                                <span class="form_label" id="SpanSubstanceAbuse">Substance Abuse</span>
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                    <tr class="checkbox_container">
                                                                        <td>
                                                                            <input type="radio" id="RadioButton_CustomDocumentIndividualServiceNoteGenerals_SubstanceAbuse_N"
                                                                                name="RadioButton_CustomDocumentIndividualServiceNoteGenerals_SubstanceAbuse"
                                                                                value="N" />
                                                                        </td>
                                                                        <td>
                                                                            <label id="SubstanceAbuseUnremarkable" for="RadioButton_CustomDocumentIndividualServiceNoteGenerals_SubstanceAbuse_N">
                                                                                Unremarkable</label>
                                                                        </td>
                                                                        <td style="width: 15px;">
                                                                            &nbsp;
                                                                        </td>
                                                                        <td>
                                                                            <input type="radio" id="RadioButton_CustomDocumentIndividualServiceNoteGenerals_SubstanceAbuse_Y"
                                                                                name="RadioButton_CustomDocumentIndividualServiceNoteGenerals_SubstanceAbuse"
                                                                                value="Y" />
                                                                        </td>
                                                                        <td>
                                                                            <label id="SubstanceAbuseRemarkable" for="RadioButton_CustomDocumentIndividualServiceNoteGenerals_SubstanceAbuse_Y">
                                                                                Remarkable</label>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td style="padding-left: 5px;">
                                                                <input class="form_textbox" type="text" id="TextBox_CustomDocumentIndividualServiceNoteGenerals_SubstanceAbuseComments"
                                                                    name="TextBox_CustomDocumentIndividualServiceNoteGenerals_SubstanceAbuseComments"
                                                                    style="width: 462px;" maxlength="150" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="padding-left: 3px;">
                                                    <table border="0" cellspacing="0" cellpadding="0" style="width: 98%">
                                                        <tr>
                                                            <td style="padding-left: 2px; width: 19%; padding-top:8px;">
                                                                <span class="form_label" id="SpanSelfHarm">Self Harm*</span>
                                                            </td>
                                                            <td style="padding-left: 2px; padding-top:8px;">
                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                    <tr class="checkbox_container">
                                                                        <td>
                                                                            <input type="radio" id="RadioButton_CustomDocumentIndividualServiceNoteGenerals_SelfHarm_N"
                                                                                name="RadioButton_CustomDocumentIndividualServiceNoteGenerals_SelfHarm" value="N" onclick="EnableOrDiableSelfHarmCheckBoxes()"/>
                                                                        </td>
                                                                        <td>
                                                                            <label id="SelfHarmNoneReported" for="RadioButton_CustomDocumentIndividualServiceNoteGenerals_SelfHarm_N">
                                                                                None Reported</label>
                                                                        </td>
                                                                        <td style="width: 15px;">
                                                                            &nbsp;
                                                                        </td>
                                                                        <td style="padding-left:20px;">
                                                                            <input type="radio" id="RadioButton_CustomDocumentIndividualServiceNoteGenerals_SelfHarm_Y"
                                                                                name="RadioButton_CustomDocumentIndividualServiceNoteGenerals_SelfHarm" value="Y" onclick="EnableOrDiableSelfHarmCheckBoxes()"/>
                                                                        </td>
                                                                        <td>
                                                                            <label id="SelfHarmPleaseSpecify" for="RadioButton_CustomDocumentIndividualServiceNoteGenerals_SelfHarm_Y">
                                                                                Please Specify</label>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td style="padding-left: 5px;">
                                                                &nbsp;
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="padding-left: 3px; padding-top:5px;">
                                                    <table>
                                                        <tr>
                                                            <td style="padding-left: 2px;">
                                                                <table>
                                                                    <tr class="checkbox_container">
                                                                        <td align="center" valign="middle">
                                                                            <input type="checkbox" id="CheckBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmIdeation"
                                                                                name="CheckBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmIdeation" />
                                                                        </td>
                                                                        <td style="padding-left: 2px;">
                                                                            <label id="SelfHarmIdeation" name="SelfHarmIdeation" for="CheckBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmIdeation"
                                                                                class="CrossBrowserAutoFix_margin-left_3px">
                                                                                Ideation</label>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <table>
                                                                    <tr class="checkbox_container">
                                                                        <td align="center" valign="middle">
                                                                            <input type="checkbox" id="CheckBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmIntent"
                                                                                name="CheckBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmIntent" />
                                                                        </td>
                                                                        <td style="padding-left: 2px;">
                                                                            <label id="SelfHarmIntent" name="SelfHarmIntent" for="CheckBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmIntent"
                                                                                class="CrossBrowserAutoFix_margin-left_3px">
                                                                                Intent</label>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <table>
                                                                    <tr class="checkbox_container">
                                                                        <td align="center" valign="middle">
                                                                            <input type="checkbox" id="CheckBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmAttempt"
                                                                                name="CheckBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmAttempt" />
                                                                        </td>
                                                                        <td style="padding-left: 2px;">
                                                                            <label id="SelfHarmAttempt" name="SelfHarmAttempt" for="CheckBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmAttempt"
                                                                                class="CrossBrowserAutoFix_margin-left_3px">
                                                                                Attempt</label>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <table>
                                                                    <tr class="checkbox_container">
                                                                        <td align="center" valign="middle">
                                                                            <input type="checkbox" id="CheckBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmMeans"
                                                                                name="CheckBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmMeans" />
                                                                        </td>
                                                                        <td style="padding-left: 2px;">
                                                                            <label id="SelfHarmMeans" name="SelfHarmMeans" for="CheckBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmMeans"
                                                                                class="CrossBrowserAutoFix_margin-left_3px">
                                                                                Means</label>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <table>
                                                                    <tr class="checkbox_container">
                                                                        <td align="center" valign="middle">
                                                                            <input type="checkbox" id="CheckBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmPlan"
                                                                                name="CheckBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmPlan" />
                                                                        </td>
                                                                        <td style="padding-left: 2px;">
                                                                            <label id="SelfHarmPlan" name="SelfHarmPlan" for="CheckBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmPlan"
                                                                                class="CrossBrowserAutoFix_margin-left_3px">
                                                                                Plan</label>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <table>
                                                                    <tr class="checkbox_container">
                                                                        <td align="center" valign="middle">
                                                                            <input type="checkbox" id="CheckBox_CustomDocumentIndividualServiceNoteGenerals_selfHarmOther"
                                                                                name="CheckBox_CustomDocumentIndividualServiceNoteGenerals_selfHarmOther" />
                                                                        </td>
                                                                        <td style="padding-left: 2px;">
                                                                            <label id="selfHarmOther" name="selfHarmOther" for="CheckBox_CustomDocumentIndividualServiceNoteGenerals_selfHarmOther"
                                                                                class="CrossBrowserAutoFix_margin-left_3px">
                                                                                Other</label>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <input class="form_textbox" type="text" id="TextBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmOtherComments"
                                                                    name="TextBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmOtherComments"
                                                                    style="width: 100px;" maxlength="150" />
                                                            </td>
                                                            <td style="padding-left: 50px;">
                                                                <table>
                                                                    <tr class="checkbox_container">
                                                                        <td align="center" valign="middle">
                                                                            <input type="checkbox" id="CheckBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmInformed"
                                                                                name="CheckBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmInformed" />
                                                                        </td>
                                                                        <td style="padding-left: 2px;">
                                                                            <label id="SelfHarmInformed" name="SelfHarmInformed" for="CheckBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmInformed"
                                                                                class="CrossBrowserAutoFix_margin-left_3px">
                                                                                I informed:</label>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <input class="form_textbox" type="text" id="TextBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmInformedComments"
                                                                    name="TextBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmInformedComments"
                                                                    style="width: 100px;" maxlength="150" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="padding-left: 3px;">
                                                    <span class="form_label" id="SpanSelfHarmComments">Comments</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="padding-left: 5px; padding-top:2px;">
                                                    <textarea class="form_textarea" id="TextArea_CustomDocumentIndividualServiceNoteGenerals_SelfharmComments"
                                                        name="TextArea_CustomDocumentIndividualServiceNoteGenerals_SelfharmComments"
                                                        rows="2" cols="1" style="width: 98%;" spellcheck="True" datatype="String"></textarea>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="padding-left: 3px;">
                                                    <table border="0" cellspacing="0" cellpadding="0" style="width: 100%">
                                                        <tr>
                                                            <td style="padding-left: 2px; width: 19%; padding-top:8px;">
                                                                <span class="form_label" id="SpanHarmtoOthers">Harm to Others*</span>
                                                            </td>
                                                            <td style="padding-left: 2px; padding-top:8px;">
                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                    <tr class="checkbox_container">
                                                                        <td>
                                                                            <input type="radio" id="RadioButton_CustomDocumentIndividualServiceNoteGenerals_HarmToOthers_N"
                                                                                name="RadioButton_CustomDocumentIndividualServiceNoteGenerals_HarmToOthers" value="N" onclick="EnableOrDiableHarmToOthersCheckBoxes()"/>
                                                                        </td>
                                                                        <td>
                                                                            <label id="HarmToOthersNoneReported" for="RadioButton_CustomDocumentIndividualServiceNoteGenerals_HarmToOthers_N">
                                                                                None Reported</label>
                                                                        </td>
                                                                        <td style="width: 15px;">
                                                                            &nbsp;
                                                                        </td>
                                                                        <td style="padding-left:20px;">
                                                                            <input type="radio" id="RadioButton_CustomDocumentIndividualServiceNoteGenerals_HarmToOthers_Y"
                                                                                name="RadioButton_CustomDocumentIndividualServiceNoteGenerals_HarmToOthers" value="Y" onclick="EnableOrDiableHarmToOthersCheckBoxes()"/>
                                                                        </td>
                                                                        <td>
                                                                            <label id="HarmToOthersPleaseSpecify" for="RadioButton_CustomDocumentIndividualServiceNoteGenerals_HarmToOthers_Y">
                                                                                Please Specify</label>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td style="padding-left: 5px; padding-top:5px;">
                                                                &nbsp;
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="padding-left: 3px; padding-top:5px;">
                                                    <table>
                                                        <tr>
                                                            <td style="padding-left: 2px;">
                                                                <table>
                                                                    <tr class="checkbox_container">
                                                                        <td align="center" valign="middle">
                                                                            <input type="checkbox" id="CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersIdeation"
                                                                                name="CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersIdeation" />
                                                                        </td>
                                                                        <td style="padding-left: 2px;">
                                                                            <label id="HarmToOthersIdeation" name="HarmToOthersIdeation" for="CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersIdeation"
                                                                                class="CrossBrowserAutoFix_margin-left_3px">
                                                                                Ideation</label>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <table>
                                                                    <tr class="checkbox_container">
                                                                        <td align="center" valign="middle">
                                                                            <input type="checkbox" id="CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersIntent"
                                                                                name="CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersIntent" />
                                                                        </td>
                                                                        <td style="padding-left: 2px;">
                                                                            <label id="HarmToOthersIntent" name="HarmToOthersIntent" for="CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersIntent"
                                                                                class="CrossBrowserAutoFix_margin-left_3px">
                                                                                Intent</label>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <table>
                                                                    <tr class="checkbox_container">
                                                                        <td align="center" valign="middle">
                                                                            <input type="checkbox" id="CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersAttempt"
                                                                                name="CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersAttempt" />
                                                                        </td>
                                                                        <td style="padding-left: 2px;">
                                                                            <label id="HarmToOthersAttempt" name="HarmToOthersAttempt" for="CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersAttempt"
                                                                                class="CrossBrowserAutoFix_margin-left_3px">
                                                                                Attempt</label>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <table>
                                                                    <tr class="checkbox_container">
                                                                        <td align="center" valign="middle">
                                                                            <input type="checkbox" id="CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersMeans"
                                                                                name="CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersMeans" />
                                                                        </td>
                                                                        <td style="padding-left: 2px;">
                                                                            <label id="HarmToOthersMeans" name="HarmToOthersMeans" for="CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersMeans"
                                                                                class="CrossBrowserAutoFix_margin-left_3px">
                                                                                Means</label>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <table>
                                                                    <tr class="checkbox_container">
                                                                        <td align="center" valign="middle">
                                                                            <input type="checkbox" id="CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersPlan"
                                                                                name="CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersPlan" />
                                                                        </td>
                                                                        <td style="padding-left: 2px;">
                                                                            <label id="HarmToOthersPlan" name="HarmToOthersPlan" for="CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersPlan"
                                                                                class="CrossBrowserAutoFix_margin-left_3px">
                                                                                Plan</label>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <table>
                                                                    <tr class="checkbox_container">
                                                                        <td align="center" valign="middle">
                                                                            <input type="checkbox" id="CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersOther"
                                                                                name="CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersOther" />
                                                                        </td>
                                                                        <td style="padding-left: 2px;">
                                                                            <label id="HarmToOthersOther" name="HarmToOthersOther" for="CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersOther"
                                                                                class="CrossBrowserAutoFix_margin-left_3px">
                                                                                Other</label>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <input class="form_textbox" type="text" id="TextBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersOtherComments"
                                                                    name="TextBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersOtherComments"
                                                                    style="width: 100px;" maxlength="150" />
                                                            </td>
                                                            <td style="padding-left: 50px;">
                                                                <table>
                                                                    <tr class="checkbox_container">
                                                                        <td align="center" valign="middle">
                                                                            <input type="checkbox" id="CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersInformed"
                                                                                name="CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersInformed" />
                                                                        </td>
                                                                        <td style="padding-left: 2px;">
                                                                            <label id="HarmToOthersInformed" name="HarmToOthersInformed" for="CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersInformed"
                                                                                class="CrossBrowserAutoFix_margin-left_3px">
                                                                                I informed:</label>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <input class="form_textbox" type="text" id="TextBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersInformedComments"
                                                                    name="TextBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersInformedComments"
                                                                    style="width: 100px;" maxlength="150" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="padding-left: 3px;">
                                                    <span class="form_label" id="SpanHarmToOthersComments">Comments</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="padding-left: 5px; padding-top:2px;">
                                                    <textarea class="form_textarea" id="TextArea_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersComments"
                                                        name="TextArea_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersComments"
                                                        rows="2" cols="1" style="width: 98%;" spellcheck="True" datatype="String"></textarea>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="padding-left: 3px;">
                                                    <table border="0" cellspacing="0" cellpadding="0" style="width: 100%">
                                                        <tr>
                                                            <td style="padding-left: 2px; width: 19%; padding-top:8px;">
                                                                <span class="form_label" id="SpanharmtoProperty">Harm to Property*</span>
                                                            </td>
                                                            <td style="padding-left: 2px; padding-top:8px;">
                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                    <tr class="checkbox_container">
                                                                        <td>
                                                                            <input type="radio" id="RadioButton_CustomDocumentIndividualServiceNoteGenerals_HarmToProperty_N"
                                                                                name="RadioButton_CustomDocumentIndividualServiceNoteGenerals_HarmToProperty"
                                                                                value="N" onclick="EnableOrDisableHarmToPropertyCheckBoxes()"/>
                                                                        </td>
                                                                        <td>
                                                                            <label id="HarmToPropertyNoneReported" for="RadioButton_CustomDocumentIndividualServiceNoteGenerals_HarmToProperty_N">
                                                                                None Reported</label>
                                                                        </td>
                                                                        <td style="width: 15px;">
                                                                            &nbsp;
                                                                        </td>
                                                                        <td style="padding-left:20px;">
                                                                            <input type="radio" id="RadioButton_CustomDocumentIndividualServiceNoteGenerals_HarmToProperty_Y"
                                                                                name="RadioButton_CustomDocumentIndividualServiceNoteGenerals_HarmToProperty"
                                                                                value="Y" onclick="EnableOrDisableHarmToPropertyCheckBoxes()" />
                                                                        </td>
                                                                        <td>
                                                                            <label id="HarmToPropertyPleaseSpecify" for="RadioButton_CustomDocumentIndividualServiceNoteGenerals_HarmToProperty_Y">
                                                                                Please Specify</label>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td style="padding-left: 5px; padding-top:5px;">
                                                                &nbsp;
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="padding-left: 3px; padding-top:5px;">
                                                    <table>
                                                        <tr>
                                                            <td style="padding-left: 2px;">
                                                                <table>
                                                                    <tr class="checkbox_container">
                                                                        <td align="center" valign="middle" class="style1">
                                                                            <input type="checkbox" id="CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyIdeation"
                                                                                name="CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyIdeation" />
                                                                        </td>
                                                                        <td style="padding-left: 2px;">
                                                                            <label id="HarmToPropertyIdeation" name="HarmToPropertyIdeation" for="CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyIdeation"
                                                                                class="CrossBrowserAutoFix_margin-left_3px">
                                                                                Ideation</label>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <table>
                                                                    <tr class="checkbox_container">
                                                                        <td align="center" valign="middle">
                                                                            <input type="checkbox" id="CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyIntent"
                                                                                name="CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyIntent" />
                                                                        </td>
                                                                        <td style="padding-left: 2px;">
                                                                            <label id="HarmToPropertyIntent" name="HarmToPropertyIntent" for="CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyIntent"
                                                                                class="CrossBrowserAutoFix_margin-left_3px">
                                                                                Intent</label>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <table>
                                                                    <tr class="checkbox_container">
                                                                        <td align="center" valign="middle">
                                                                            <input type="checkbox" id="CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyAttempt"
                                                                                name="CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyAttempt" />
                                                                        </td>
                                                                        <td style="padding-left: 2px;">
                                                                            <label id="HarmToPropertyAttempt" name="HarmToPropertyAttempt" for="CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyAttempt"
                                                                                class="CrossBrowserAutoFix_margin-left_3px">
                                                                                Attempt</label>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <table>
                                                                    <tr class="checkbox_container">
                                                                        <td align="center" valign="middle">
                                                                            <input type="checkbox" id="CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyMeans"
                                                                                name="CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyMeans" />
                                                                        </td>
                                                                        <td style="padding-left: 2px;">
                                                                            <label id="HarmToPropertyMeans" name="HarmToPropertyMeans" for="CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyMeans"
                                                                                class="CrossBrowserAutoFix_margin-left_3px">
                                                                                Means</label>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <table>
                                                                    <tr class="checkbox_container">
                                                                        <td align="center" valign="middle">
                                                                            <input type="checkbox" id="CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyPlan"
                                                                                name="CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyPlan" />
                                                                        </td>
                                                                        <td style="padding-left: 2px;">
                                                                            <label id="HarmToPropertyPlan" name="HarmToPropertyPlan" for="CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyPlan"
                                                                                class="CrossBrowserAutoFix_margin-left_3px">
                                                                                Plan</label>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <table>
                                                                    <tr class="checkbox_container">
                                                                        <td align="center" valign="middle">
                                                                            <input type="checkbox" id="CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyOther"
                                                                                name="CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyOther" />
                                                                        </td>
                                                                        <td style="padding-left: 2px;">
                                                                            <label id="HarmToPropertyOther" name="HarmToPropertyOther" for="CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyOther"
                                                                                class="CrossBrowserAutoFix_margin-left_3px">
                                                                                Other</label>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <input class="form_textbox" type="text" id="TextBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyOtherComments"
                                                                    name="TextBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyOtherComments"
                                                                    style="width: 100px;" maxlength="150" />
                                                            </td>
                                                            <td style="padding-left: 50px;">
                                                                <table>
                                                                    <tr class="checkbox_container">
                                                                        <td align="center" valign="middle">
                                                                            <input type="checkbox" id="CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyInformed"
                                                                                name="CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyInformed" />
                                                                        </td>
                                                                        <td style="padding-left: 2px;">
                                                                            <label id="Label9" name="HarmToOthersInformed" for="CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyInformed"
                                                                                class="CrossBrowserAutoFix_margin-left_3px">
                                                                                I informed:</label>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <input class="form_textbox" type="text" id="TextBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyInformedComments"
                                                                    name="TextBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyInformedComments"
                                                                    style="width: 100px;" maxlength="150" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="padding-left: 3px;">
                                                    <span class="form_label" id="SpanHarmToPropertyComments">Comments</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="padding-left: 5px; padding-top:2px;">
                                                    <textarea class="form_textarea" id="TextArea_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyComments"
                                                        name="TextArea_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyComments"
                                                        rows="2" cols="1" style="width: 98%;" spellcheck="True" datatype="String"></textarea>
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
                                        <span class="form_label" id="SpanSafetyPlan">Safety Plan</span>
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
                                    <td style="padding-left: 2px; width: 12%">
                                        <u><span id="SpansafetyCrisisPlan" class="form_label" style="color: Blue; cursor: hand;"
                onclick="OpenSafetyCrisisPlan()">Safety / Crisis Plan</span> </u>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding-left: 2px;">
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                                <td style="padding-left: 2px;">
                                                    <table>
                                                        <tr class="checkbox_container">
                                                            <td align="center" valign="middle">
                                                                <input type="checkbox" id="CheckBox_CustomDocumentIndividualServiceNoteGenerals_SafetyPlanwasReviewed"
                                                                    name="CheckBox_CustomDocumentIndividualServiceNoteGenerals_SafetyPlanwasReviewed" />
                                                            </td>
                                                            <td style="padding-left: 2px;">
                                                                <label id="SafetyPlanwasReviewed" name="SafetyPlanwasReviewed" for="CheckBox_CustomDocumentIndividualServiceNoteGenerals_SafetyPlanwasReviewed"
                                                                    class="CrossBrowserAutoFix_margin-left_3px">
                                                                    The Safety Plan was Reviewed</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td style="padding-left: 2px;">
                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                        <tr class="checkbox_container">
                                                            <td>
                                                                <input type="radio" id="RadioButton_CustomDocumentIndividualServiceNoteGenerals_WithOrWithOutClient_Y"
                                                                    name="RadioButton_CustomDocumentIndividualServiceNoteGenerals_WithOrWithOutClient"
                                                                    value="Y" />
                                                            </td>
                                                            <td>
                                                                <label id="WiththeClient" for="RadioButton_CustomDocumentIndividualServiceNoteGenerals_WithOrWithOutClient_Y">
                                                                    With the Client</label>
                                                            </td>
                                                            <td style="width: 15px;">
                                                                &nbsp;
                                                            </td>
                                                            <td>
                                                                <input type="radio" id="RadioButton_CustomDocumentIndividualServiceNoteGenerals_WithOrWithOutClient_N"
                                                                    name="RadioButton_CustomDocumentIndividualServiceNoteGenerals_WithOrWithOutClient"
                                                                    value="N" />
                                                            </td>
                                                            <td>
                                                                <label id="Withouttheclient" for="RadioButton_CustomDocumentIndividualServiceNoteGenerals_WithOrWithOutClient_N">
                                                                    Without the client, specify the reason client was not able to review below and discuss
                                                                    Next Steps</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding-left: 2px; width: 12%">
                                        <span id="SpanNextSteps" class="form_label">Next Steps</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding-left: 2px;">
                                        <textarea class="form_textarea" id="TextArea_CustomDocumentIndividualServiceNoteGenerals_NextSteps"
                                            name="TextArea_CustomDocumentIndividualServiceNoteGenerals_NextSteps" rows="2"
                                            cols="1" style="width: 98%;" spellcheck="True" datatype="String"></textarea>
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
                                        <span class="form_label" id="SpanInterventionProgress">Intervention/Progress</span>
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
                                        <span id="Spanfocusofthesession" class="form_label">What was the focus of the session
                                            (i.e. alleviation of emotional disturbances, reversal or change of maladaptive Patterns
                                            or behaviors, encouragement of personality growth or development)?</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding-left: 2px; padding-top:5px;" colspan="2">
                                        <textarea class="form_textarea" id="TextArea_CustomDocumentIndividualServiceNoteGenerals_FocusOfTheSession"
                                            name="TextArea_CustomDocumentIndividualServiceNoteGenerals_FocusOfTheSession"
                                            rows="4" cols="1" style="width: 98%;" spellcheck="True" datatype="String"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding-left: 2px;" colspan="2">
                                        <span id="SpanDescribeInterventionsProvided." class="form_label">Describe the interventions
                                            provided.</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding-left: 2px; padding-top:5px;" colspan="2">
                                        <textarea class="form_textarea" id="TextArea_CustomDocumentIndividualServiceNoteGenerals_InterventionsProvided"
                                            name="TextArea_CustomDocumentIndividualServiceNoteGenerals_InterventionsProvided"
                                            rows="4" cols="1" style="width: 98%;" spellcheck="True" datatype="String"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding-left: 2px;" colspan="2">
                                        <span id="SpanDescribeReasonsAndBarries" class="form_label">Describe the client's response
                                            to the intervention, progress made toward goals and clients strengths. If progress
                                            is not being made, describe reasons and barriers to progress.</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding-left: 2px; padding-top:5px;" colspan="2">
                                        <textarea class="form_textarea" id="TextArea_CustomDocumentIndividualServiceNoteGenerals_ProgressMade"
                                            name="TextArea_CustomDocumentIndividualServiceNoteGenerals_ProgressMade" rows="4"
                                            cols="1" style="width: 98%;" spellcheck="True" datatype="String"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding-left: 2px;" colspan="2">
                                        <span id="SpanDocumentPlan" class="form_label">Document the plan. If there were barriers
                                            describe the plan to overcome the barriers.</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding-left: 2px; padding-top:5px;" colspan="2">
                                        <textarea class="form_textarea" id="TextArea_CustomDocumentIndividualServiceNoteGenerals_Overcome"
                                            name="TextArea_CustomDocumentIndividualServiceNoteGenerals_Overcome" rows="4"
                                            cols="1" style="width: 98%;" spellcheck="True" datatype="String"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding-left: 2px;" colspan="2">
                                        <span id="SpanLastService" class="form_label">Plan from Last Service</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding-left: 2px; padding-top:5px;" colspan="2">
                                        <textarea class="form_textarea" id="TextArea_CustomDocumentIndividualServiceNoteGenerals_PlanLastService"
                                            name="TextArea_CustomDocumentIndividualServiceNoteGenerals_PlanLastService" rows="4"
                                            cols="1" style="width: 98%;" spellcheck="True" datatype="String" disabled="disabled"></textarea>
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



