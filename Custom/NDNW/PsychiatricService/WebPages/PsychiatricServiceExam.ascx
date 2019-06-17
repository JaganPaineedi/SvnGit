<%@ Control Language="C#" AutoEventWireup="true" CodeFile="PsychiatricServiceExam.ascx.cs" Inherits="Custom_PsychiatricService_WebPages_PsychiatricServiceExam" %>
<div class="bottom_contanier_white_bg">
    <table border="0" cellspacing="0" cellpadding="0" class="DocumentScreen" style="width: 98%">
        <tr>
            <td colspan="3">
                <table width="98%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="height2"></td>
                                </tr>
                                <tr>
                                    <td>
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">

                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap='nowrap'>Vitals
                                                </td>
                                                <td width="17">
                                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif"
                                                        width="17" height="26" alt="" />
                                                </td>
                                                <td class="content_tab_top" width="100%"></td>
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
                                        <table border="0" cellspacing="0" cellpadding="0" style="text-align: left; padding-left: 10px;"
                                            width="100%">
                                            <tr>
                                                <td align="left">
                                                    <table cellpadding="0" cellspacing="0" border="0" width="98%">
                                                        <tr>
                                                            <td class="height2"></td>
                                                        </tr> 
                                                        <tr>
                                                          <td style="padding-left: 5px;" align="right">
                                                                <table cellpadding="0" cellspacing="0">
                                                                    <tr>
                                                                        <td class="glow_lt" width="3px" align="right">
                                                                        </td>
                                                                        <td class="glow_mid">
                                                                            <input type="button" id="Button_OpenFlowSheet" name="Button_OpenFlowSheet"
                                                                    value="Open vitals flow sheet" />
                                                                        </td>
                                                                        <td class="glow_rt" width="3px" align="left">
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
                                                                <div id="divVitals" style="border: solid 1px #b1b1b1; background-color: #ffffff; overflow-y: scroll; height: 100px; width: 770px">                                                                    
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
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="height2"></td>
                                </tr>
                                <tr>
                                    <td>
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap='nowrap'>General Appearance and Manner
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
                                    <td class="content_tab_bg" style="text-align: left; padding-left: 10px;">
                                        <table border="0" cellspacing="0" cellpadding="0" width="98%">
                                            <tr>
                                                <td align="left">
                                                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                        <tr>
                                                            <td class="height2"></td>
                                                        </tr>
                                                        <tr>
                                                            <tr>
                                                                <td>
                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="text-align: left;">
                                                                        <tr>
                                                                            <td class="checkbox_container">
                                                                                <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricServiceNoteExams_AppropriatelyDressed"
                                                                                    name="CheckBox_CustomDocumentPsychiatricServiceNoteExams_AppropriatelyDressed" />
                                                                                <span class="form_label" id="Span3" style="padding-right: 50px">Appropriately dressed & groomed</span>
                                                                                <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricServiceNoteExams_GeneralAppearanceUnkept"
                                                                                    name="CheckBox_CustomDocumentPsychiatricServiceNoteExams_GeneralAppearanceUnkept" />
                                                                                <span class="form_label" id="Span1" style="padding-right: 150px">Unkept</span>
                                                                                <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricServiceNoteExams_GeneralAppearanceOther"
                                                                                    name="CheckBox_CustomDocumentPsychiatricServiceNoteExams_GeneralAppearanceOther" />
                                                                                <span class="form_label" id="Span2" style="padding-right: 50px">Other</span>
                                                                                <input style="width: 200px;" class="form_textbox element" type="text" id="TextBox_CustomDocumentPsychiatricServiceNoteExams_GeneralAppearanceOtherText"
                                                                                    name="TextBox_CustomDocumentPsychiatricServiceNoteExams_GeneralAppearanceOtherText" />
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
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
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="height2"></td>
                                </tr>
                                <tr>
                                    <td>
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap='nowrap'>Musculoskeletal 
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
                                    <td class="content_tab_bg" style="text-align: left; padding-left: 10px;">
                                        <table border="0" cellspacing="0" cellpadding="0" width="98%">
                                            <tr>
                                                <td align="left">
                                                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                        <tr>
                                                            <td class="height2"></td>
                                                        </tr>
                                                        <tr>
                                                            <tr>
                                                                <td>
                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="text-align: left;">
                                                                        <tr>
                                                                            <td class="checkbox_container">
                                                                                <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricServiceNoteExams_MuscleStrengthNormal"
                                                                                    name="CheckBox_CustomDocumentPsychiatricServiceNoteExams_MuscleStrengthNormal" />
                                                                                <span class="form_label" id="Span4" style="padding-right: 100px">Muscle strength normal</span>
                                                                                <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricServiceNoteExams_MuscleStrengthAbnormal"
                                                                                    name="CheckBox_CustomDocumentPsychiatricServiceNoteExams_MuscleStrengthAbnormal" />
                                                                                <span class="form_label" id="Span5" style="padding-right: 59px">Muscle strength abnormal </span>
                                                                                <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricServiceNoteExams_MusculoskeletalTone"
                                                                                    name="CheckBox_CustomDocumentPsychiatricServiceNoteExams_MusculoskeletalTone" />
                                                                                <span class="form_label" id="Span6" style="padding-right: 50px">Tone </span>

                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
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
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="height2"></td>
                                </tr>
                                <tr>
                                    <td>
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap='nowrap'>Gait and Station 
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
                                    <td class="content_tab_bg" style="text-align: left; padding-left: 10px;">
                                        <table border="0" cellspacing="0" cellpadding="0" width="98%">
                                            <tr>
                                                <td align="left">
                                                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                        <tr>
                                                            <td class="height2"></td>
                                                        </tr>
                                                        <tr>
                                                            <tr>
                                                                <td>
                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="text-align: left;">
                                                                        <tr>
                                                                            <td class="checkbox_container">
                                                                                <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricServiceNoteExams_GaitNormal"
                                                                                    name="CheckBox_CustomDocumentPsychiatricServiceNoteExams_GaitNormal" />
                                                                                <span class="form_label" id="Span7" style="padding-right: 157px">Gait normal</span>
                                                                                <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricServiceNoteExams_GaitAbnormal"
                                                                                    name="CheckBox_CustomDocumentPsychiatricServiceNoteExams_GaitAbnormal" />
                                                                                <span class="form_label" id="Span8" style="padding-right: 120px">Gait abnormal</span>
                                                                                <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricServiceNoteExams_TicsTremorsAbnormalMovements"
                                                                                    name="CheckBox_CustomDocumentPsychiatricServiceNoteExams_TicsTremorsAbnormalMovements" />
                                                                                <span class="form_label" id="Span9" style="padding-right: 20px">Tics, tremors or abnormal movements</span>
                                                                                <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricServiceNoteExams_EPS"
                                                                                    name="CheckBox_CustomDocumentPsychiatricServiceNoteExams_EPS" />
                                                                                <span class="form_label" id="Span10">EPS</span>

                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
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
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="height2"></td>
                                </tr>
                                <tr>
                                    <td>
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap='nowrap'>Psychiatric 
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
                                    <td class="content_tab_bg" style="text-align: left; padding-left: 10px;">
                                        <table border="0" cellspacing="0" cellpadding="0" width="98%">
                                            <tr>
                                                <td align="left">
                                                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                        <tr>
                                                            <td class="height2"></td>
                                                        </tr>
                                                        <tr>
                                                            <td class="checkbox_container">
                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0" style="text-align: left;">
                                                                    <tr>
                                                                        <td>
                                                                            <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricServiceNoteExams_AppearanceBehavior"
                                                                                name="CheckBox_CustomDocumentPsychiatricServiceNoteExams_AppearanceBehavior" />
                                                                            <span class="form_label" id="Span12" style="padding-right: 67px">Appearance and behavior</span>
                                                                            <input style="width: 300px;" class="form_textbox element" type="text" id="TextBox_CustomDocumentPsychiatricServiceNoteExams_AppearanceBehaviorComments"
                                                                                name="TextBox_CustomDocumentPsychiatricServiceNoteExams_AppearanceBehaviorComments" /><br />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height2"></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricServiceNoteExams_Speech"
                                                                                name="CheckBox_CustomDocumentPsychiatricServiceNoteExams_Speech" />
                                                                            <span class="form_label" id="Span11" style="padding-right: 155px">Speech</span>
                                                                            <input style="width: 300px;" class="form_textbox element" type="text" id="TextBox_CustomDocumentPsychiatricServiceNoteExams_SpeechComments"
                                                                                name="TextBox_CheckBox_CustomDocumentPsychiatricServiceNoteExams_SpeechComments" /><br />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height2"></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricServiceNoteExams_ThoughtProcess"
                                                                                name="CheckBox_CustomDocumentPsychiatricServiceNoteExams_ThoughtProcess" />
                                                                            <span class="form_label" id="Span13" style="padding-right: 110px">Thought process</span>
                                                                            <input style="width: 300px;" class="form_textbox element" type="text" id="TextBox_CustomDocumentPsychiatricServiceNoteExams_ThoughtProcessComments"
                                                                                name="TextBox_CustomDocumentPsychiatricServiceNoteExams_ThoughtProcessComments" /><br />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height2"></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricServiceNoteExams_Associations"
                                                                                name="CheckBox_CustomDocumentPsychiatricServiceNoteExams_Associations" />
                                                                            <span class="form_label" id="Span14" style="padding-right: 131px">Associations</span>
                                                                            <input style="width: 300px;" class="form_textbox element" type="text" id="TextBox_CustomDocumentPsychiatricServiceNoteExams_AssociationsComments"
                                                                                name="TextBox_CustomDocumentPsychiatricServiceNoteExams_AssociationsComments" /><br />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height2"></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricServiceNoteExams_AbnormalPsychoticThoughts"
                                                                                name="CheckBox_CustomDocumentPsychiatricServiceNoteExams_AbnormalPsychoticThoughts" />
                                                                            <span class="form_label" id="Span18" style="padding-right: 49px">Abnormal/psychotic thoughts</span>
                                                                            <input style="width: 300px;" class="form_textbox element" type="text" id="TextBox_CustomDocumentPsychiatricServiceNoteExams_AbnormalPsychoticThoughtsComments"
                                                                                name="TextBox_CustomDocumentPsychiatricServiceNoteExams_AbnormalPsychoticThoughtsComments" /><br />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height2"></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricServiceNoteExams_JudgmentAndInsight"
                                                                                name="CheckBox_CustomDocumentPsychiatricServiceNoteExams_JudgmentAndInsight" />
                                                                            <span class="form_label" id="Span15" style="padding-right: 86px">Judgment and insight </span>
                                                                            <input style="width: 300px;" class="form_textbox element" type="text" id="TextBox_CustomDocumentPsychiatricServiceNoteExams_JudgmentAndInsightComments"
                                                                                name="TextBox_CustomDocumentPsychiatricServiceNoteExams_JudgmentAndInsightComments" /><br />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height2"></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricServiceNoteExams_Orientation"
                                                                                name="CheckBox_CustomDocumentPsychiatricServiceNoteExams_Orientation" />
                                                                            <span class="form_label" id="Span16" style="padding-right: 136px">Orientation</span>
                                                                            <input style="width: 300px;" class="form_textbox element" type="text" id="TextBox_CustomDocumentPsychiatricServiceNoteExams_OrientationComments"
                                                                                name="TextBox_CustomDocumentPsychiatricServiceNoteExams_OrientationComments" /><br />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height2"></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricServiceNoteExams_RecentRemoteMemory"
                                                                                name="CheckBox_CustomDocumentPsychiatricServiceNoteExams_RecentRemoteMemory" />
                                                                            <span class="form_label" id="Span17" style="padding-right: 55px">Recent and remote memory </span>
                                                                            <input style="width: 300px;" class="form_textbox element" type="text" id="TextBox_CustomDocumentPsychiatricServiceNoteExams_RecentRemoteMemoryComments"
                                                                                name="TextBox_CustomDocumentPsychiatricServiceNoteExams_RecentRemoteMemoryComments" /><br />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height2"></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricServiceNoteExams_AttentionConcentration"
                                                                                name="CheckBox_CustomDocumentPsychiatricServiceNoteExams_AttentionConcentration" />
                                                                            <span class="form_label" id="Span19" style="padding-right: 55px">Attention and concentration </span>
                                                                            <input style="width: 300px;" class="form_textbox element" type="text" id="TextBox_CustomDocumentPsychiatricServiceNoteExams_AttentionConcentrationComments"
                                                                                name="TextBox_CustomDocumentPsychiatricServiceNoteExams_AttentionConcentrationComments" /><br />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height2"></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricServiceNoteExams_Language"
                                                                                name="CheckBox_CustomDocumentPsychiatricServiceNoteExams_Language" />
                                                                            <span class="form_label" id="Span20" style="padding-right: 143px">Language</span>
                                                                            <input style="width: 300px;" class="form_textbox element" type="text" id="TextBox_CustomDocumentPsychiatricServiceNoteExams_LanguageCommments"
                                                                                name="TextBox_CustomDocumentPsychiatricServiceNoteExams_LanguageCommments" /><br />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height2"></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricServiceNoteExams_FundOfKnowledge"
                                                                                name="CheckBox_CustomDocumentPsychiatricServiceNoteExams_FundOfKnowledge" />
                                                                            <span class="form_label" id="Span21" style="padding-right: 95px">Fund Of Knowledge </span>
                                                                            <input style="width: 300px;" class="form_textbox element" type="text" id="TextBox_CustomDocumentPsychiatricServiceNoteExams_FundOfKnowledgeComments"
                                                                                name="TextBox_CustomDocumentPsychiatricServiceNoteExams_FundOfKnowledgeComments" /><br />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height2"></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricServiceNoteExams_MoodAndAffect"
                                                                                name="CheckBox_CustomDocumentPsychiatricServiceNoteExams_MoodAndAffect" />
                                                                            <span class="form_label" id="Span22" style="padding-right: 111px">Mood and Affect </span>
                                                                            <input style="width: 300px;" class="form_textbox element" type="text" id="TextBox_CustomDocumentPsychiatricServiceNoteExams_MoodAndAffectComments"
                                                                                name="TextBox_CustomDocumentPsychiatricServiceNoteExams_MoodAndAffectComments" /><br />
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
            </td>
        </tr>
        <tr>
            <td class="height2"></td>
        </tr>
    </table>
</div>
