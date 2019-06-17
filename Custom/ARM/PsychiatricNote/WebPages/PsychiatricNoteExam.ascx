<%@ Control Language="C#" AutoEventWireup="true" CodeFile="PsychiatricNoteExam.ascx.cs" Inherits="Custom_PsychiatricNote_WebPages_PsychiatricNoteExam" %>


<div class="DocumentScreen">
    <table border="0" cellspacing="0" cellpadding="0" style="width: 820px;">
        <tr>
            <td colspan="3">
                <table width="820px" border="0" cellspacing="0" cellpadding="0">
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
                                                                        <td class="glow_lt" width="3px" align="right"></td>
                                                                        <td class="glow_mid">
                                                                            <input type="button" id="Button_OpenFlowSheet" name="Button_OpenFlowSheet"
                                                                                value="Open vitals flow sheet" />
                                                                        </td>
                                                                        <td class="glow_rt" width="3px" align="left"></td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2"></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                             <%--   <div id="divVitals" style="border: solid 1px #b1b1b1; background-color: #ffffff; overflow-y: scroll; height: 100px; width: 800px">
                                                                </div>--%>
                                                            <%--       <div id="div_FlowSheetVitals" style="border: solid 1px #b1b1b1; background-color: #ffffff; overflow-y: scroll; height: 300px; width: 800px">
                                </div>--%>
                                                                    <div id="div_FlowSheetVitals">
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






                                <tr>
                                    <td class="height2"></td>
                                </tr>
                                <tr>
                                    <td class="height2"></td>
                                </tr>




                                <tr style="display: none;">
                                    <td>
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
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
                                                <td class="content_tab_bg">
                                                    <table border="0" cellspacing="0" cellpadding="0" width="98%">
                                                        <tr>
                                                            <td style="text-align: left; padding-left: 10px;">
                                                                <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                                    <tr>
                                                                        <td>
                                                                            <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                                                <tr>
                                                                                    <td class="checkbox_container" width="25%">
                                                                                        <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_MusculoskeletalMuscleNormal" name="CheckBox_CustomDocumentPsychiatricNoteExams_MusculoskeletalMuscleNormal" />
                                                                                        <%--<span class="form_label" id="Span3">Muscle strength normal</span>--%>
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_MusculoskeletalMuscleNormal" style="cursor: default">Muscle strength normal</label>
                                                                                    </td>
                                                                                    <td class="checkbox_container" width="25%">
                                                                                        <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_MusculoskeletalMuscleAbnormal" name="CheckBox_CustomDocumentPsychiatricNoteExams_MusculoskeletalMuscleAbnormal" />
                                                                                        <%--<span class="form_label" id="Span4">Muscle strength abnormal</span>--%>
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_MusculoskeletalMuscleAbnormal" style="cursor: default">Muscle strength abnormal</label>
                                                                                    </td>
                                                                                    <td class="checkbox_container" width="10%">
                                                                                        <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_MusculoskeletalMuscleTone" name="CheckBox_CustomDocumentPsychiatricNoteExams_MusculoskeletalMuscleTone" />
                                                                                        <%--<span class="form_label" id="Span5">Tone</span>--%>
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_MusculoskeletalMuscleTone" style="cursor: default">Tone</label>
                                                                                    </td>
                                                                                    <td class="checkbox_container" width="40%">
                                                                                        <input id="TextBox_CustomDocumentPsychiatricNoteExams_MusculoskeletalMuscleComment" name="TextBox_CustomDocumentPsychiatricNoteExams_MusculoskeletalMuscleComment"
                                                                                            type="text" class="form_textbox" style="width: 350px" />
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td class="height2"></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td class="checkbox_container" width="30%">
                                                                                        <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_MusculoskeletalMuscleTicsTremors" name="CheckBox_CustomDocumentPsychiatricNoteExams_MusculoskeletalMuscleTicsTremors" />
                                                                                        <%--<span class="form_label" id="Span3">Muscle strength normal</span>--%>
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_MusculoskeletalMuscleTicsTremors" style="cursor: default">Tics,tremors or abnormal movements</label>
                                                                                    </td>
                                                                                    <td class="checkbox_container" width="25%">
                                                                                        <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_MusculoskeletalMuscleEPS" name="CheckBox_CustomDocumentPsychiatricNoteExams_MusculoskeletalMuscleEPS" />
                                                                                        <%--<span class="form_label" id="Span4">Muscle strength abnormal</span>--%>
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_MusculoskeletalMuscleEPS" style="cursor: default">EPS</label>
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
                                <tr>
                                    <td class="height2"></td>
                                </tr>
                                <tr>
                                    <td class="height2"></td>
                                </tr>

                                <tr style="display: none;">
                                    <td>
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
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
                                                <td class="content_tab_bg">
                                                    <table width="98%" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                            <td align="left">
                                                                <table cellpadding="0" cellspacing="0" border="0" width="98%">
                                                                    <tr>
                                                                        <td class="height2"></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="text-align: left; padding-left: 10px;">
                                                                            <table cellpadding="3" cellspacing="0" border="0" width="100%">
                                                                                <tr>
                                                                                    <td class="checkbox_container" width="30%">
                                                                                        <table>
                                                                                            <tr>
                                                                                                <td style="width: 50%">
                                                                                                    <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_GaitStationNormal" name="CheckBox_CustomDocumentPsychiatricNoteExams_GaitStationNormal" />
                                                                                                    <%--<span class="form_label" id="Span6">Gait normal</span>--%>
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_GaitStationNormal" style="cursor: default">Gait normal</label>
                                                                                                </td>
                                                                                                <td style="width: 50%">
                                                                                                    <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_GaitStationAbnormal" name="CheckBox_CustomDocumentPsychiatricNoteExams_GaitStationAbnormal" />
                                                                                                    <%--<span class="form_label" id="Span7">Gait abnormal</span>--%>
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_GaitStationAbnormal" style="cursor: default">Gait abnormal</label>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>

                                                                                    </td>

                                                                                    <%--<td class="checkbox_container" width="30%" style="padding-left: 30px;">
                                                                                        <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_GaitStationNormalTicsTremors" name="CheckBox_CustomDocumentPsychiatricNoteExams_GaitStationNormalTicsTremors" />
                                                                                        <span class="form_label" id="Span8">Tics, tremors or abnormal movements</span>
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_GaitStationNormalTicsTremors" style="cursor: default">Tics, tremors or abnormal movements</label>
                                                                                    </td>
                                                                                    <td class="checkbox_container" width="20%">
                                                                                        <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_GaitStationEPS" name="CheckBox_CustomDocumentPsychiatricNoteExams_GaitStationEPS" />
                                                                                        <span class="form_label" id="Span9">EPS</span>
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_GaitStationEPS" style="cursor: default">EPS</label>
                                                                                    </td>--%>
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
                                <tr>
                                    <td class="height2"></td>
                                </tr>
                                <tr>
                                    <td class="height2"></td>
                                </tr>
                                <tr>
                                    <td>
                                        <table cellspacing="0" class="CalculateLOCR" cellpadding="0" border="0" width="100%">
                                            <tr>
                                                <td>
                                                    <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                        <tr>
                                                            <td class="content_tab_left" align="left" nowrap='nowrap'>Mental Status Exam
                                                            </td>
                                                            <td width="17">
                                                                <img style="vertical-align: top;" height="26" width="17" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                                                            </td>
                                                            <td class="content_tab_top" width="100%" />
                                                            <td width="7">
                                                                <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td valign="top" class="content_tab_bg" align="left" style="padding-left: 5px;">
                                                    <table border="0" cellspacing="0" cellpadding="0" style="width: 100%; height: 6%; vertical-align: bottom;">
                                                        <tr>
                                                            <td class="Tdwidth"><span></span></td>
                                                            <td style="width: 15%;"></td>
                                                            <td style="width: 18%;"><span></span></td>
                                                            <td><span></span></td>
                                                            <td><span>&nbsp;</span></td>
                                                        </tr>
                                                    </table>
                                                    <table cellspacing="0" cellpadding="0" border="0" width="99%" style="margin-left: 2px;">
                                                        <tr>
                                                            <td>
                                                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                                    <tr>
                                                                        <td width="7">
                                                                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_left1.gif" />
                                                                        </td>
                                                                        <td class="content_tab_top" width="100%" />
                                                                        <td width="7">
                                                                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td valign="top" class="content_tab_bg" align="left" style="padding-left: 8px;">
                                                                <table border="0" cellspacing="0" cellpadding="0" border="0" style="width: 95%">
                                                                    <tr>
                                                                        <td>
                                                                            <table style="width: 100%">
                                                                                <tr>
                                                                                    <td width="20%">
                                                                                        <span><b>General Appearance</b></span>
                                                                                    </td>
                                                                                    <td class="RadioText" width="15%">
                                                                                        <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_GeneralAppearance_A"
                                                                                            name="RadioButton_CustomDocumentPsychiatricNoteExams_GeneralAppearance" value="A" />
                                                                                        <label for="RadioButton_CustomDocumentPsychiatricNoteExams_GeneralAppearance_A">Assessed</label>
                                                                                    </td>
                                                                                    <td class="RadioText" width="17%">
                                                                                        <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_GeneralAppearance_N"
                                                                                            name="RadioButton_CustomDocumentPsychiatricNoteExams_GeneralAppearance" value="N" />
                                                                                        <label for="RadioButton_CustomDocumentPsychiatricNoteExams_GeneralAppearance_N">Not Assessed</label>
                                                                                    </td>
                                                                                    <td class="RadioText" width="58%">
                                                                                        <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_GeneralAppearance_G"
                                                                                            name="RadioButton_CustomDocumentPsychiatricNoteExams_GeneralAppearance" value="G" />
                                                                                        <label for="RadioButton_CustomDocumentPsychiatricNoteExams_GeneralAppearance_G">WNL – Appropriately dressed and groomed for the occasion</label>
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
                                                                            <table cellpadding="0" cellspacing="0" width="100%" style="padding-left: 20px;">
                                                                                <tr class="checkbox_container">
                                                                                    <td>
                                                                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_GeneralPoorlyAddresses" name="CheckBox_CustomDocumentPsychiatricNoteExams_GeneralPoorlyAddresses" GeneralAppearance="GeneralAppearance" />
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_GeneralPoorlyAddresses">Poorly dressed</label>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_GeneralPoorlyGroomed" name="CheckBox_CustomDocumentPsychiatricNoteExams_GeneralPoorlyGroomed" GeneralAppearance="GeneralAppearance" />
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_GeneralPoorlyGroomed">Poorly groomed</label>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_GeneralDisheveled" name="CheckBox_CustomDocumentPsychiatricNoteExams_GeneralDisheveled" GeneralAppearance="GeneralAppearance" />
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_GeneralDisheveled">Disheveled</label>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_GeneralOdferous" name="CheckBox_CustomDocumentPsychiatricNoteExams_GeneralOdferous" GeneralAppearance="GeneralAppearance" />
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_GeneralOdferous">Odiferous</label>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_GeneralDeformities" name="CheckBox_CustomDocumentPsychiatricNoteExams_GeneralDeformities" GeneralAppearance="GeneralAppearance" />
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_GeneralDeformities">Deformities</label>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td class="height2"></td>
                                                                                </tr>
                                                                                <tr class="checkbox_container">
                                                                                    <td>
                                                                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_GeneralPoorNutrion" name="CheckBox_CustomDocumentPsychiatricNoteExams_GeneralPoorNutrion" GeneralAppearance="GeneralAppearance" />
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_GeneralPoorNutrion">Poor nutrition</label>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_GeneralRestless" name="CheckBox_CustomDocumentPsychiatricNoteExams_GeneralRestless" GeneralAppearance="GeneralAppearance" />
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_GeneralRestless">Restless</label>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_GeneralPsychometer" name="CheckBox_CustomDocumentPsychiatricNoteExams_GeneralPsychometer" GeneralAppearance="GeneralAppearance" />
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_GeneralPsychometer">Psychomotor retardation</label>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_GeneralHyperActive" name="CheckBox_CustomDocumentPsychiatricNoteExams_GeneralHyperActive" GeneralAppearance="GeneralAppearance" />
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_GeneralHyperActive">Hyperactive/intrusive</label>
                                                                                    </td>
                                                                                    <td></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td class="height2"></td>
                                                                                </tr>
                                                                                <tr class="checkbox_container">
                                                                                    <td>
                                                                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_GeneralEvasive" name="CheckBox_CustomDocumentPsychiatricNoteExams_GeneralEvasive" GeneralAppearance="GeneralAppearance" />
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_GeneralEvasive">Evasive/distant</label>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_GeneralInAttentive" name="CheckBox_CustomDocumentPsychiatricNoteExams_GeneralInAttentive" GeneralAppearance="GeneralAppearance" />
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_GeneralInAttentive">Inattentive</label>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_GeneralPoorEyeContact" name="CheckBox_CustomDocumentPsychiatricNoteExams_GeneralPoorEyeContact" GeneralAppearance="GeneralAppearance" />
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_GeneralPoorEyeContact">Poor eye contact</label>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_GeneralHostile" name="CheckBox_CustomDocumentPsychiatricNoteExams_GeneralHostile" GeneralAppearance="GeneralAppearance" />
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_GeneralHostile">Hostile</label>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_GeneralAppearanceOthers" name="CheckBox_CustomDocumentPsychiatricNoteExams_GeneralAppearanceOthers" GeneralAppearance="GeneralAppearance" onclick="ShowCommentBox('CheckBox_CustomDocumentPsychiatricNoteExams_GeneralAppearanceOthers', 'Textbox_CustomDocumentPsychiatricNoteExams_GeneralAppearanceOtherComments', 'CustomDocumentPsychiatricNoteExams', 'GeneralAppearanceOtherComments')" />
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_GeneralAppearanceOthers">Other</label>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                                <table border="0" cellspacing="0" cellpadding="0" border="0" width="90%">
                                                                    <tr>
                                                                        <td class="height2"></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height2" style="padding-left: 20px;">
                                                                            <input style="width: 100%;" class="form_textbox element" type="text" id="Textbox_CustomDocumentPsychiatricNoteExams_GeneralAppearanceOtherComments"
                                                                                name="Textbox_CustomDocumentPsychiatricNoteExams_GeneralAppearanceOtherComments" />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height2"></td>
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
                                                                        <td class="right_bottom_cont_bottom_bg" width="100%"></td>
                                                                        <td class="right_bottom_cont_bottom_bg" align="right" width="2">
                                                                            <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_right.gif" />
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    <table cellspacing="0" cellpadding="0" border="0" width="99%" style="margin-left: 2px;">
                                                        <tr>
                                                            <td>
                                                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                                    <tr>
                                                                        <td width="7">
                                                                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_left1.gif" />
                                                                        </td>
                                                                        <td class="content_tab_top" width="100%" />
                                                                        <td width="7">
                                                                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td valign="top" class="content_tab_bg" align="left" style="padding-left: 8px;">
                                                                <table border="0" cellspacing="0" cellpadding="0" border="0" style="width: 90%">
                                                                    <tr>
                                                                        <td>
                                                                            <table style="width: 100%">
                                                                                <tr>
                                                                                    <td>
                                                                                        <span><b>Speech</b></span>
                                                                                    </td>
                                                                                    <td class="RadioText">
                                                                                        <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_Speech_A"
                                                                                            name="RadioButton_CustomDocumentPsychiatricNoteExams_Speech" value="A" />
                                                                                        <label for="RadioButton_CustomDocumentPsychiatricNoteExams_Speech_A">Assessed</label>
                                                                                    </td>
                                                                                    <td class="RadioText">
                                                                                        <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_Speech_N"
                                                                                            name="RadioButton_CustomDocumentPsychiatricNoteExams_Speech" value="N" />
                                                                                        <label for="RadioButton_CustomDocumentPsychiatricNoteExams_Speech_N">Not Assessed</label>
                                                                                    </td>
                                                                                    <td class="RadioText">
                                                                                        <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_Speech_W"
                                                                                            name="RadioButton_CustomDocumentPsychiatricNoteExams_Speech" value="W" />
                                                                                        <label for="RadioButton_CustomDocumentPsychiatricNoteExams_Speech_W">WNL – non-pressured, with normal rate, tone, latency</label>
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
                                                                            <table cellpadding="0" cellspacing="0" width="100%" style="padding-left: 20px;">
                                                                                <tr class="checkbox_container">
                                                                                    <td>
                                                                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_SpeechIncreased" name="CheckBox_CustomDocumentPsychiatricNoteExams_SpeechIncreased" Speech="Speech" />
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_SpeechIncreased">Increased latency</label>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_SpeechDecreased" name="CheckBox_CustomDocumentPsychiatricNoteExams_SpeechDecreased" Speech="Speech" />
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_SpeechDecreased">Decreased rate</label>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_SpeechPaucity" name="CheckBox_CustomDocumentPsychiatricNoteExams_SpeechPaucity" Speech="Speech" />
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_SpeechPaucity">Paucity</label>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_SpeechHyperverbal" name="CheckBox_CustomDocumentPsychiatricNoteExams_SpeechHyperverbal" Speech="Speech" />
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_SpeechHyperverbal">Hyperverbal</label>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td class="height2"></td>
                                                                                </tr>
                                                                                <tr class="checkbox_container">
                                                                                    <td>
                                                                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_SpeechPoorArticulations" name="CheckBox_CustomDocumentPsychiatricNoteExams_SpeechPoorArticulations" Speech="Speech" />
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_SpeechPoorArticulations">Poor articulation</label>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_SpeechLoud" name="CheckBox_CustomDocumentPsychiatricNoteExams_SpeechLoud" Speech="Speech" />
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_SpeechLoud">Loud</label>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_SpeechSoft" name="CheckBox_CustomDocumentPsychiatricNoteExams_SpeechSoft" Speech="Speech" />
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_SpeechSoft">Soft</label>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_SpeechMute" name="CheckBox_CustomDocumentPsychiatricNoteExams_SpeechMute" Speech="Speech" />
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_SpeechMute">Mute</label>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td class="height2"></td>
                                                                                </tr>
                                                                                <tr class="checkbox_container">
                                                                                    <td>
                                                                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_SpeechStuttering" name="CheckBox_CustomDocumentPsychiatricNoteExams_SpeechStuttering" Speech="Speech" />
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_SpeechStuttering">Stuttering</label>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_SpeechImpaired" name="CheckBox_CustomDocumentPsychiatricNoteExams_SpeechImpaired" Speech="Speech" />
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_SpeechImpaired">Impaired prosody</label>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_SpeechPressured" name="CheckBox_CustomDocumentPsychiatricNoteExams_SpeechPressured" Speech="Speech" />
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_SpeechPressured">Pressured</label>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_SpeechFlight" name="CheckBox_CustomDocumentPsychiatricNoteExams_SpeechFlight" Speech="Speech" />
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_SpeechFlight">Flight of Ideas</label>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                                <table border="0" cellspacing="0" cellpadding="0" border="0" width="90%">
                                                                    <tr>
                                                                        <td class="height2"></td>
                                                                    </tr>
                                                                    <tr class="checkbox_container">
                                                                        <td style="padding-left: 20px;">
                                                                            <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_SpeechOthers" name="CheckBox_CustomDocumentPsychiatricNoteExams_SpeechOthers" Speech="Speech" onclick="ShowCommentBox('CheckBox_CustomDocumentPsychiatricNoteExams_SpeechOthers', 'Textbox_CustomDocumentPsychiatricNoteExams_SpeechOtherComments', 'CustomDocumentPsychiatricNoteExams', 'SpeechOtherComments')" />
                                                                            <label for="CheckBox_CustomDocumentPsychiatricNoteExams_SpeechOthers">Other</label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height2"></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height2" style="padding-left: 20px;">
                                                                            <input style="width: 100%;" class="form_textbox element" type="text" id="Textbox_CustomDocumentPsychiatricNoteExams_SpeechOtherComments"
                                                                                name="Textbox_CustomDocumentPsychiatricNoteExams_SpeechOtherComments" />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height2"></td>
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
                                                                        <td class="right_bottom_cont_bottom_bg" width="100%"></td>
                                                                        <td class="right_bottom_cont_bottom_bg" align="right" width="2">
                                                                            <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_right.gif" />
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    <table cellspacing="0" cellpadding="0" border="0" width="99%" style="margin-left: 2px;">
                                                        <tr>
                                                            <td>
                                                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                                    <tr>
                                                                        <td width="7">
                                                                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_left1.gif" />
                                                                        </td>
                                                                        <td class="content_tab_top" width="100%" />
                                                                        <td width="7">
                                                                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td valign="top" class="content_tab_bg" align="left" style="padding-left: 8px;">
                                                                <table border="0" cellspacing="0" cellpadding="0" border="0" width="90%">
                                                                    <tr>
                                                                        <td>
                                                                            <table width="100%">
                                                                                <tr>
                                                                                    <td>
                                                                                        <span><b>Language</b></span>
                                                                                    </td>
                                                                                    <td class="RadioText">
                                                                                        <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_PsychiatricNoteExamLanguage_A"
                                                                                            name="RadioButton_CustomDocumentPsychiatricNoteExams_PsychiatricNoteExamLanguage" value="A" />
                                                                                        <label for="RadioButton_CustomDocumentPsychiatricNoteExams_PsychiatricNoteExamLanguage_A">Assessed</label>
                                                                                    </td>
                                                                                    <td class="RadioText">
                                                                                        <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_PsychiatricNoteExamLanguage_N"
                                                                                            name="RadioButton_CustomDocumentPsychiatricNoteExams_PsychiatricNoteExamLanguage" value="N" />
                                                                                        <label for="RadioButton_CustomDocumentPsychiatricNoteExams_PsychiatricNoteExamLanguage_N">Not Assessed</label>
                                                                                    </td>
                                                                                    <td class="RadioText">
                                                                                        <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_PsychiatricNoteExamLanguage_W"
                                                                                            name="RadioButton_CustomDocumentPsychiatricNoteExams_PsychiatricNoteExamLanguage" value="W" />
                                                                                        <label for="RadioButton_CustomDocumentPsychiatricNoteExams_PsychiatricNoteExamLanguage_W">WNL – non-pressured, with normal rate, tone, latency</label>
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
                                                                            <table cellpadding="0" cellspacing="0" width="70%" style="padding-left: 20px;">
                                                                                <tr class="checkbox_container">
                                                                                    <td>
                                                                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_LanguageDifficultyNaming" name="CheckBox_CustomDocumentPsychiatricNoteExams_LanguageDifficultyNaming" PsychiatricNoteExamLanguage="PsychiatricNoteExamLanguage" />
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_LanguageDifficultyNaming">Difficulty naming objects</label>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_LanguageDifficultyRepeating" name="CheckBox_CustomDocumentPsychiatricNoteExams_LanguageDifficultyRepeating" PsychiatricNoteExamLanguage="PsychiatricNoteExamLanguage" />
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_LanguageDifficultyRepeating">Difficulty repeating phrases</label>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_LanguageOthers" name="CheckBox_CustomDocumentPsychiatricNoteExams_LanguageOthers" PsychiatricNoteExamLanguage="PsychiatricNoteExamLanguage" onclick="ShowCommentBox('CheckBox_CustomDocumentPsychiatricNoteExams_LanguageOthers', 'Textbox_CustomDocumentPsychiatricNoteExams_LanguageOtherComments', 'CustomDocumentPsychiatricNoteExams', 'LanguageOtherComments')" />
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_LanguageOthers">Other</label>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                                <table border="0" cellspacing="0" cellpadding="0" border="0" width="90%">
                                                                    <tr>
                                                                        <td class="height2"></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height2" style="padding-left: 20px;">
                                                                            <input style="width: 100%;" class="form_textbox element" type="text" id="Textbox_CustomDocumentPsychiatricNoteExams_LanguageOtherComments"
                                                                                name="Textbox_CustomDocumentPsychiatricNoteExams_LanguageOtherComments" />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height2"></td>
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
                                                                        <td class="right_bottom_cont_bottom_bg" width="100%"></td>
                                                                        <td class="right_bottom_cont_bottom_bg" align="right" width="2">
                                                                            <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_right.gif" />
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    <table cellspacing="0" cellpadding="0" border="0" width="99%" style="margin-left: 2px;">
                                                        <tr>
                                                            <td>
                                                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                                    <tr>
                                                                        <td width="7">
                                                                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_left1.gif" />
                                                                        </td>
                                                                        <td class="content_tab_top" width="100%" />
                                                                        <td width="7">
                                                                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td valign="top" class="content_tab_bg" align="left" style="padding-left: 8px;">
                                                                <table border="0" cellspacing="0" cellpadding="0" border="0" width="100%">
                                                                    <tr>
                                                                        <td>
                                                                            <table width="90%">
                                                                                <tr>
                                                                                    <td>
                                                                                        <span><b>Mood and Affect</b></span>
                                                                                    </td>
                                                                                    <td class="RadioText">
                                                                                        <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_MoodAndAffect_A"
                                                                                            name="RadioButton_CustomDocumentPsychiatricNoteExams_MoodAndAffect" value="A" />
                                                                                        <label for="RadioButton_CustomDocumentPsychiatricNoteExams_MoodAndAffect_A">Assessed</label>
                                                                                    </td>
                                                                                    <td class="RadioText">
                                                                                        <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_MoodAndAffect_N"
                                                                                            name="RadioButton_CustomDocumentPsychiatricNoteExams_MoodAndAffect" value="N" />
                                                                                        <label for="RadioButton_CustomDocumentPsychiatricNoteExams_MoodAndAffect_N">Not Assessed</label>
                                                                                    </td>
                                                                                    <td class="RadioText">
                                                                                        <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_MoodAndAffect_W"
                                                                                            name="RadioButton_CustomDocumentPsychiatricNoteExams_MoodAndAffect" value="W" />
                                                                                        <label for="RadioButton_CustomDocumentPsychiatricNoteExams_MoodAndAffect_W">WNL – mood and affect euthymic and congruent</label>
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
                                                                            <table cellpadding="0" cellspacing="0" width="100%" style="padding-left: 20px;">
                                                                                <tr class="checkbox_container">
                                                                                    <%--  <td>
                                                                                        <table style="width:95%">
                                                                                            <tr>--%>
                                                                                    <td>
                                                                                        <span>Mood</span>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_MoodHappy" name="CheckBox_CustomDocumentPsychiatricNoteExams_MoodHappy" MoodAndAffect="MoodAndAffect" />
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_MoodHappy">Happy</label>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_MoodSad" name="CheckBox_CustomDocumentPsychiatricNoteExams_MoodSad" MoodAndAffect="MoodAndAffect" />
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_MoodSad">Sad</label>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_MoodAnxious" name="CheckBox_CustomDocumentPsychiatricNoteExams_MoodAnxious" MoodAndAffect="MoodAndAffect" />
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_MoodAnxious">Anxious</label>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_MoodAngry" name="CheckBox_CustomDocumentPsychiatricNoteExams_MoodAngry" MoodAndAffect="MoodAndAffect" />
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_MoodAngry">Angry</label>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_MoodIrritable" name="CheckBox_CustomDocumentPsychiatricNoteExams_MoodIrritable" MoodAndAffect="MoodAndAffect" />
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_MoodIrritable">Irritable</label>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_MoodElation" name="CheckBox_CustomDocumentPsychiatricNoteExams_MoodElation" MoodAndAffect="MoodAndAffect" />
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_MoodElation">Elation</label>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_MoodNormal" name="CheckBox_CustomDocumentPsychiatricNoteExams_MoodNormal" MoodAndAffect="MoodAndAffect" />
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_MoodNormal">Normal</label>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_MoodOthers" name="CheckBox_CustomDocumentPsychiatricNoteExams_MoodOthers" MoodAndAffect="MoodAndAffect" onclick="ShowCommentBox('CheckBox_CustomDocumentPsychiatricNoteExams_MoodOthers', 'Textbox_CustomDocumentPsychiatricNoteExams_MoodOtherComments', 'CustomDocumentPsychiatricNoteExams', 'MoodOtherComments')" />
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_MoodOthers">Other</label>
                                                                                    </td>

                                                                                    <%--  </tr>
                                                                                        </table>
                                                                                    </td>--%>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td class="height2"></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td class="height2" colspan="9">
                                                                                        <input style="width: 90%;" class="form_textbox element" type="text" id="Textbox_CustomDocumentPsychiatricNoteExams_MoodOtherComments"
                                                                                            name="Textbox_CustomDocumentPsychiatricNoteExams_MoodOtherComments" />
                                                                                    </td>
                                                                                </tr>
                                                                                
                                                                                <tr>
                                                                                    <td class="height2" colspan="9">___________________________________________________________________________________________________________________________</td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td class="height2"></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td class="height2"></td>
                                                                                </tr>
                                                                                <tr class="checkbox_container">
                                                                                    <%--  <td>
                                                                                        <table>
                                                                                            <tr>--%>
                                                                                    <td>
                                                                                        <span style="padding-right: 5px;">Affect</span>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_AffectEuthymic" name="CheckBox_CustomDocumentPsychiatricNoteExams_AffectEuthymic" MoodAndAffect="MoodAndAffect" />
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_AffectEuthymic">Euthymic</label>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_AffectDysphoric" name="CheckBox_CustomDocumentPsychiatricNoteExams_AffectDysphoric" MoodAndAffect="MoodAndAffect" />
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_AffectDysphoric">Dysphoric</label>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_AffectAnxious" name="CheckBox_CustomDocumentPsychiatricNoteExams_AffectAnxious" MoodAndAffect="MoodAndAffect" />
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_AffectAnxious">Anxious</label>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_AffectIrritable" name="CheckBox_CustomDocumentPsychiatricNoteExams_AffectIrritable" MoodAndAffect="MoodAndAffect" />
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_AffectIrritable">Irritable/angry</label>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_AffectBlunted" name="CheckBox_CustomDocumentPsychiatricNoteExams_AffectBlunted" MoodAndAffect="MoodAndAffect" />
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_AffectBlunted">Blunted/flag</label>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_AffectLabile" name="CheckBox_CustomDocumentPsychiatricNoteExams_AffectLabile" MoodAndAffect="MoodAndAffect" />
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_AffectLabile">Labile</label>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_AffectEuphoric" name="CheckBox_CustomDocumentPsychiatricNoteExams_AffectEuphoric" MoodAndAffect="MoodAndAffect" />
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_AffectEuphoric">Euphoric</label>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_AffectCongruent" name="CheckBox_CustomDocumentPsychiatricNoteExams_AffectCongruent" MoodAndAffect="MoodAndAffect" />
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_AffectCongruent">Congruent w/mood</label>
                                                                                    </td>
                                                                                    <%--  </tr>
                                                                                        </table>
                                                                                    </td>--%>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                                <table border="0" cellspacing="0" cellpadding="0" border="0" width="90%">
                                                                    <tr>
                                                                        <td class="height2"></td>
                                                                    </tr>
                                                                    <tr class="checkbox_container">
                                                                        <td style="padding-left: 77px;">
                                                                            <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_AffectOthers" name="CheckBox_CustomDocumentPsychiatricNoteExams_AffectOthers" MoodAndAffect="MoodAndAffect" onclick="ShowCommentBox('CheckBox_CustomDocumentPsychiatricNoteExams_AffectOthers', 'Textbox_CustomDocumentPsychiatricNoteExams_AffectOtherComments', 'CustomDocumentPsychiatricNoteExams', 'AffectOtherComments')" />
                                                                            <label for="CheckBox_CustomDocumentPsychiatricNoteExams_AffectOthers">Other</label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height2"></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height2" style="padding-left: 20px;">
                                                                            <input style="width: 100%;" class="form_textbox element" type="text" id="Textbox_CustomDocumentPsychiatricNoteExams_AffectOtherComments"
                                                                                name="Textbox_CustomDocumentPsychiatricNoteExams_AffectOtherComments" />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height2"></td>
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
                                                                        <td class="right_bottom_cont_bottom_bg" width="100%"></td>
                                                                        <td class="right_bottom_cont_bottom_bg" align="right" width="2">
                                                                            <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_right.gif" />
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    <table cellspacing="0" cellpadding="0" border="0" width="99%" style="margin-left: 2px;">
                                                        <tr>
                                                            <td>
                                                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                                    <tr>
                                                                        <td width="7">
                                                                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_left1.gif" />
                                                                        </td>
                                                                        <td class="content_tab_top" width="100%" />
                                                                        <td width="7">
                                                                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td valign="top" class="content_tab_bg" align="left" style="padding-left: 8px;">
                                                                <table border="0" cellspacing="0" cellpadding="0" border="0" width="100%">
                                                                    <tr>
                                                                        <td>
                                                                            <table width="90%">
                                                                                <tr>
                                                                                    <td>
                                                                                        <span><b>Attention Span and Concentration</b></span>
                                                                                    </td>
                                                                                    <td class="RadioText">
                                                                                        <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_AttensionSpanAndConcentration_A"
                                                                                            name="RadioButton_CustomDocumentPsychiatricNoteExams_AttensionSpanAndConcentration" value="A" />
                                                                                        <label for="RadioButton_CustomDocumentPsychiatricNoteExams_AttensionSpanAndConcentration_A">Assessed</label>
                                                                                    </td>
                                                                                    <td class="RadioText">
                                                                                        <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_AttensionSpanAndConcentration_N"
                                                                                            name="RadioButton_CustomDocumentPsychiatricNoteExams_AttensionSpanAndConcentration" value="N" />
                                                                                        <label for="RadioButton_CustomDocumentPsychiatricNoteExams_AttensionSpanAndConcentration_N">Not Assessed</label>
                                                                                    </td>
                                                                                    <td class="RadioText">
                                                                                        <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_AttensionSpanAndConcentration_W"
                                                                                            name="RadioButton_CustomDocumentPsychiatricNoteExams_AttensionSpanAndConcentration" value="W" />
                                                                                        <label for="RadioButton_CustomDocumentPsychiatricNoteExams_AttensionSpanAndConcentration_W">WNL-with good concentration and attention span</label>
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
                                                                            <table cellpadding="0" cellspacing="0" width="65%" style="padding-left: 20px;">
                                                                                <tr class="checkbox_container">
                                                                                    <td>
                                                                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_AttensionPoorConcentration" name="CheckBox_CustomDocumentPsychiatricNoteExams_AttensionPoorConcentration" AttensionSpanAndConcentration="AttensionSpanAndConcentration" />
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_AttensionPoorConcentration">Poor concentration</label>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_AttensionPoorAttension" name="CheckBox_CustomDocumentPsychiatricNoteExams_AttensionPoorAttension" AttensionSpanAndConcentration="AttensionSpanAndConcentration" />
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_AttensionPoorAttension">Poor attention span</label>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_AttensionDistractible" name="CheckBox_CustomDocumentPsychiatricNoteExams_AttensionDistractible" AttensionSpanAndConcentration="AttensionSpanAndConcentration" />
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_AttensionDistractible">Distractible</label>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_AttentionSpanOthers" name="CheckBox_CustomDocumentPsychiatricNoteExams_AttentionSpanOthers" AttensionSpanAndConcentration="AttensionSpanAndConcentration" onclick="ShowCommentBox('CheckBox_CustomDocumentPsychiatricNoteExams_AttentionSpanOthers', 'Textbox_CustomDocumentPsychiatricNoteExams_AttentionSpanOtherComments', 'CustomDocumentPsychiatricNoteExams', 'AttentionSpanOtherComments')" />
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_AttentionSpanOthers">Other</label>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                            <table border="0" cellspacing="0" cellpadding="0" border="0" width="90%">
                                                                                <tr>
                                                                                    <td class="height2"></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td class="height2" style="padding-left: 20px;">
                                                                                        <input style="width: 100%;" class="form_textbox element" type="text" id="Textbox_CustomDocumentPsychiatricNoteExams_AttentionSpanOtherComments"
                                                                                            name="Textbox_CustomDocumentPsychiatricNoteExams_AttentionSpanOtherComments" />
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td class="height2"></td>
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
                                                                        <td class="right_bottom_cont_bottom_bg" width="100%"></td>
                                                                        <td class="right_bottom_cont_bottom_bg" align="right" width="2">
                                                                            <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_right.gif" />
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    <table cellspacing="0" cellpadding="0" border="0" width="99%" style="margin-left: 2px;">
                                                        <tr>
                                                            <td>
                                                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                                    <tr>
                                                                        <td width="7">
                                                                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_left1.gif" />
                                                                        </td>
                                                                        <td class="content_tab_top" width="100%" />
                                                                        <td width="7">
                                                                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td valign="top" class="content_tab_bg" align="left" style="padding-left: 8px;">
                                                                <table border="0" cellspacing="0" cellpadding="0" border="0" class="TableWidth">
                                                                    <tr>
                                                                        <td>
                                                                            <table width="100%">
                                                                                <tr>
                                                                                    <td colspan="3">
                                                                                        <span><b>Thought Content and Process; Cognition</b></span>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td class="RadioText" width="20%" style="padding-left: 25px">
                                                                                        <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_ThoughtContentCognision_A"
                                                                                            name="RadioButton_CustomDocumentPsychiatricNoteExams_ThoughtContentCognision" value="A" />
                                                                                        <label for="RadioButton_CustomDocumentPsychiatricNoteExams_ThoughtContentCognision_A">Assessed all sections below</label>
                                                                                    </td>
                                                                                    <td class="RadioText" width="15%">
                                                                                        <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_ThoughtContentCognision_N"
                                                                                            name="RadioButton_CustomDocumentPsychiatricNoteExams_ThoughtContentCognision" value="N" />
                                                                                        <label for="RadioButton_CustomDocumentPsychiatricNoteExams_ThoughtContentCognision_N">Not Assessed</label>
                                                                                    </td>
                                                                                    <td class="RadioText" width="65%">
                                                                                        <table style="width: 100%">
                                                                                            <tr>
                                                                                                <td style="width: 5%">
                                                                                                    <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_ThoughtContentCognision_W"
                                                                                                        name="RadioButton_CustomDocumentPsychiatricNoteExams_ThoughtContentCognision" value="W" />
                                                                                                </td>
                                                                                                <td style="width: 95%">
                                                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteExams_ThoughtContentCognision_W">
                                                                                                        WNL for age – coherent and goal directed with no evidence of abnormal or delusional thought
                                                                                content or cognitive disturbance; good fund of knowledge</label>
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
                                                                            <table cellpadding="0" cellspacing="0" width="100%" style="padding-left: 20px;">
                                                                                <tr>
                                                                                    <td>
                                                                                        <span>Thought Process Abnormalities (leave unchecked if not present)</span>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td class="height2"></td>
                                                                                </tr>
                                                                                <tr class="checkbox_container">
                                                                                    <td>
                                                                                        <table style="width: 80%; padding-left: 5px;">
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_TPDisOrganised" name="CheckBox_CustomDocumentPsychiatricNoteExams_TPDisOrganised" ThoughtContentCognision="ThoughtContentCognision" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_TPDisOrganised">Disorganized</label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_TPBlocking" name="CheckBox_CustomDocumentPsychiatricNoteExams_TPBlocking" ThoughtContentCognision="ThoughtContentCognision" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_TPBlocking">Blocking</label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_TPPersecution" name="CheckBox_CustomDocumentPsychiatricNoteExams_TPPersecution" ThoughtContentCognision="ThoughtContentCognision" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_TPPersecution">Persecution</label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_TPBroadCasting" name="CheckBox_CustomDocumentPsychiatricNoteExams_TPBroadCasting" ThoughtContentCognision="ThoughtContentCognision" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_TPBroadCasting">Broadcasting</label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_TPDetrailed" name="CheckBox_CustomDocumentPsychiatricNoteExams_TPDetrailed" ThoughtContentCognision="ThoughtContentCognision" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_TPDetrailed">Derailed</label>
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td class="height2"></td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_TPThoughtinsertion" name="CheckBox_CustomDocumentPsychiatricNoteExams_TPThoughtinsertion" ThoughtContentCognision="ThoughtContentCognision" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_TPThoughtinsertion">Thought insertion</label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_TPIncoherent" name="CheckBox_CustomDocumentPsychiatricNoteExams_TPIncoherent" ThoughtContentCognision="ThoughtContentCognision" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_TPIncoherent">Incoherent</label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_TPRacing" name="CheckBox_CustomDocumentPsychiatricNoteExams_TPRacing" ThoughtContentCognision="ThoughtContentCognision" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_TPRacing">Racing</label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_TPIllogical" name="CheckBox_CustomDocumentPsychiatricNoteExams_TPIllogical" ThoughtContentCognision="ThoughtContentCognision" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_TPIllogical">Illogical</label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_ThoughtProcessOthers" name="CheckBox_CustomDocumentPsychiatricNoteExams_ThoughtProcessOthers" ThoughtContentCognision="ThoughtContentCognision" onclick="ShowCommentBox('CheckBox_CustomDocumentPsychiatricNoteExams_ThoughtProcessOthers', 'Textbox_CustomDocumentPsychiatricNoteExams_ThoughtProcessOtherComments', 'CustomDocumentPsychiatricNoteExams', 'ThoughtProcessOtherComments')" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_ThoughtProcessOthers">Other</label>
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td class="height2"></td>
                                                                                            </tr>
                                                                                        </table>
                                                                                        <table border="0" cellspacing="0" cellpadding="0" border="0" width="90%">
                                                                                            <tr>
                                                                                                <td class="height2"></td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td class="height2" style="padding-left: 5px;">
                                                                                                    <input style="width: 100%;" class="form_textbox element" type="text" id="Textbox_CustomDocumentPsychiatricNoteExams_ThoughtProcessOtherComments"
                                                                                                        name="Textbox_CustomDocumentPsychiatricNoteExams_ThoughtProcessOtherComments" />
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td class="height2"></td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td class="height2"></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <span>Thought Content Abnormalities (leave unchecked if not present)</span>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td class="height2"></td>
                                                                                </tr>
                                                                                <tr class="checkbox_container">
                                                                                    <td>
                                                                                        <table style="width: 100%; padding-left: 5px;">
                                                                                            <tr>
                                                                                                <%--   <td>
                                                                            <table style="width:100%;">
                                                                                <tr>--%>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_TCDelusional" name="CheckBox_CustomDocumentPsychiatricNoteExams_TCDelusional" ThoughtContentCognision="ThoughtContentCognision" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_TCDelusional">Delusional</label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_TCParanoid" name="CheckBox_CustomDocumentPsychiatricNoteExams_TCParanoid" ThoughtContentCognision="ThoughtContentCognision" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_TCParanoid">Paranoid</label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_TCIdeas" name="CheckBox_CustomDocumentPsychiatricNoteExams_TCIdeas" ThoughtContentCognision="ThoughtContentCognision" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_TCIdeas">Ideas of Reference</label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_TCThoughtInsertion" name="CheckBox_CustomDocumentPsychiatricNoteExams_TCThoughtInsertion" ThoughtContentCognision="ThoughtContentCognision" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_TCThoughtInsertion">Thought insertion</label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_TCThoughtWithdrawal" name="CheckBox_CustomDocumentPsychiatricNoteExams_TCThoughtWithdrawal" ThoughtContentCognision="ThoughtContentCognision" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_TCThoughtWithdrawal">Thought withdrawal</label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_TCThoughtBroadcasting" name="CheckBox_CustomDocumentPsychiatricNoteExams_TCThoughtBroadcasting" ThoughtContentCognision="ThoughtContentCognision" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_TCThoughtBroadcasting">Thought Broadcasting</label>
                                                                                                </td>
                                                                                                <%-- </tr>
                                                                            </table>
                                                                        </td>--%>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td class="height2"></td>
                                                                                            </tr>
                                                                                            <%--  <tr>
                                                                        <td>
                                                                            <table style="width:90%;">--%>
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_TCReligiosity" name="CheckBox_CustomDocumentPsychiatricNoteExams_TCReligiosity" ThoughtContentCognision="ThoughtContentCognision" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_TCReligiosity">Religiosity</label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_TCGrandiosity" name="CheckBox_CustomDocumentPsychiatricNoteExams_TCGrandiosity" ThoughtContentCognision="ThoughtContentCognision" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_TCGrandiosity">Grandiosity</label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_TCPerserveration" name="CheckBox_CustomDocumentPsychiatricNoteExams_TCPerserveration" ThoughtContentCognision="ThoughtContentCognision" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_TCPerserveration">Perserveration</label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_TCObsessions" name="CheckBox_CustomDocumentPsychiatricNoteExams_TCObsessions" ThoughtContentCognision="ThoughtContentCognision" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_TCObsessions">Obsessions</label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_TCWorthlessness" name="CheckBox_CustomDocumentPsychiatricNoteExams_TCWorthlessness" ThoughtContentCognision="ThoughtContentCognision" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_TCWorthlessness">Worthlessness</label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_TCLoneliness" name="CheckBox_CustomDocumentPsychiatricNoteExams_TCLoneliness" ThoughtContentCognision="ThoughtContentCognision" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_TCLoneliness">Loneliness</label>
                                                                                                </td>
                                                                                            </tr>
                                                                                            <%--  </table>
                                                                        </td>
                                                                       
                                                                    </tr>--%>
                                                                                            <tr>
                                                                                                <td class="height2"></td>
                                                                                            </tr>
                                                                                            <%-- <tr>
                                                                        <td>
                                                                            <table style="width:45%">--%>
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_TCGuilt" name="CheckBox_CustomDocumentPsychiatricNoteExams_TCGuilt" ThoughtContentCognision="ThoughtContentCognision" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_TCGuilt">Guilt</label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_TCHopelessness" name="CheckBox_CustomDocumentPsychiatricNoteExams_TCHopelessness" ThoughtContentCognision="ThoughtContentCognision" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_TCHopelessness">Hopelessness</label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_TCHelplessness" name="CheckBox_CustomDocumentPsychiatricNoteExams_TCHelplessness" ThoughtContentCognision="ThoughtContentCognision" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_TCHelplessness">Helplessness</label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_ThoughtContentOthers" name="CheckBox_CustomDocumentPsychiatricNoteExams_ThoughtContentOthers" ThoughtContentCognision="ThoughtContentCognision" onclick="ShowCommentBox('CheckBox_CustomDocumentPsychiatricNoteExams_ThoughtContentOthers', 'Textbox_CustomDocumentPsychiatricNoteExams_ThoughtContentOtherComments', 'CustomDocumentPsychiatricNoteExams', 'ThoughtContentOtherComments')" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_ThoughtContentOthers">Other</label>
                                                                                                </td>
                                                                                                <%--  </tr>
                                                                            </table>
                                                                        </td>--%>
                                                                                            </tr>
                                                                                        </table>
                                                                                        <table border="0" cellspacing="0" cellpadding="0" border="0" width="90%">
                                                                                            <tr>
                                                                                                <td class="height2"></td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td class="height2" style="padding-left: 5px;">
                                                                                                    <input style="width: 100%;" class="form_textbox element" type="text" id="Textbox_CustomDocumentPsychiatricNoteExams_ThoughtContentOtherComments"
                                                                                                        name="Textbox_CustomDocumentPsychiatricNoteExams_ThoughtContentOtherComments" />
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td class="height2"></td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td class="height2"></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <span>Cognitive Abnormalities (leave unchecked if not present)</span>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td class="height2"></td>
                                                                                </tr>
                                                                                <tr class="checkbox_container">
                                                                                    <td>
                                                                                        <table style="width: 70%; padding-left: 5px;">
                                                                                            <tr>
                                                                                                <%-- <td>
                                                                             <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_CAPoorKnowledget" name="CheckBox_CustomDocumentPsychiatricNoteExams_CAPoorKnowledget" ThoughtContentCognision="ThoughtContentCognision" />
                                                                             <label for="CheckBox_CustomDocumentPsychiatricNoteExams_CAPoorKnowledget">Poor fund of knowledge</label>
                                                                        </td>--%>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_CAConcrete" name="CheckBox_CustomDocumentPsychiatricNoteExams_CAConcrete" ThoughtContentCognision="ThoughtContentCognision" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_CAConcrete">Concrete</label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_CAUnable" name="CheckBox_CustomDocumentPsychiatricNoteExams_CAUnable" ThoughtContentCognision="ThoughtContentCognision" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_CAUnable">Unable to follow instructions</label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_CAPoorComputation" name="CheckBox_CustomDocumentPsychiatricNoteExams_CAPoorComputation" ThoughtContentCognision="ThoughtContentCognision" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_CAPoorComputation">Poor Computation</label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_CognitiveAbnormalitiesOthers" name="CheckBox_CustomDocumentPsychiatricNoteExams_CognitiveAbnormalitiesOthers" ThoughtContentCognision="ThoughtContentCognision" onclick="ShowCommentBox('CheckBox_CustomDocumentPsychiatricNoteExams_CognitiveAbnormalitiesOthers', 'Textbox_CustomDocumentPsychiatricNoteExams_CognitiveAbnormalitiesOtherComments', 'CustomDocumentPsychiatricNoteExams', 'CognitiveAbnormalitiesOtherComments')" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_CognitiveAbnormalitiesOthers">Other</label>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                        <table border="0" cellspacing="0" cellpadding="0" border="0" width="90%">
                                                                                            <tr>
                                                                                                <td class="height2"></td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td class="height2" style="padding-left: 5px;">
                                                                                                    <input style="width: 100%;" class="form_textbox element" type="text" id="Textbox_CustomDocumentPsychiatricNoteExams_CognitiveAbnormalitiesOtherComments"
                                                                                                        name="Textbox_CustomDocumentPsychiatricNoteExams_CognitiveAbnormalitiesOtherComments" />
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td class="height2"></td>
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
                                                                        <td class="right_bottom_cont_bottom_bg" width="100%"></td>
                                                                        <td class="right_bottom_cont_bottom_bg" align="right" width="2">
                                                                            <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_right.gif" />
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </table>

                                                    <table cellspacing="0" cellpadding="0" border="0" width="99%" style="margin-left: 2px;">
                                                        <tr>
                                                            <td>
                                                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                                    <tr>
                                                                        <td width="7">
                                                                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_left1.gif" />
                                                                        </td>
                                                                        <td class="content_tab_top" width="100%" />
                                                                        <td width="7">
                                                                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td valign="top" class="content_tab_bg" align="left" style="padding-left: 8px;">
                                                                <table border="0" cellspacing="0" cellpadding="0" border="0" width="80%">
                                                                    <tr>
                                                                        <td>
                                                                            <table width="90%">
                                                                                <tr>
                                                                                    <td>
                                                                                        <span><b>Associations</b></span>
                                                                                    </td>
                                                                                    <td class="RadioText">
                                                                                        <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_Associations_A"
                                                                                            name="RadioButton_CustomDocumentPsychiatricNoteExams_Associations" value="A" />
                                                                                        <label for="RadioButton_CustomDocumentPsychiatricNoteExams_AttensionSpanAndConcentration_A">Assessed all sections below</label>
                                                                                    </td>
                                                                                    <td class="RadioText">
                                                                                        <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_Associations_N"
                                                                                            name="RadioButton_CustomDocumentPsychiatricNoteExams_Associations" value="N" />
                                                                                        <label for="RadioButton_CustomDocumentPsychiatricNoteExams_Associations_N">Not Assessed</label>
                                                                                    </td>
                                                                                    <td class="RadioText">
                                                                                        <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_Associations_W"
                                                                                            name="RadioButton_CustomDocumentPsychiatricNoteExams_Associations" value="W" />
                                                                                        <label for="RadioButton_CustomDocumentPsychiatricNoteExams_Associations_W">WNL - Intact</label>
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
                                                                            <table cellpadding="0" cellspacing="0" width="95%" style="padding-left: 20px;">
                                                                                <tr class="checkbox_container">
                                                                                    <td>
                                                                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_AssociationsLoose" name="CheckBox_CustomDocumentPsychiatricNoteExams_AssociationsLoose" Associations="Associations" />
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_AssociationsLoose">Loose</label>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_AssociationsClanging" name="CheckBox_CustomDocumentPsychiatricNoteExams_AssociationsClanging" Associations="Associations" />
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_AssociationsClanging">Clanging</label>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_AssociationsWordsalad" name="CheckBox_CustomDocumentPsychiatricNoteExams_AssociationsWordsalad" Associations="Associations" />
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_AssociationsWordsalad">Word salad</label>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_AssociationsCircumstantial" name="CheckBox_CustomDocumentPsychiatricNoteExams_AssociationsCircumstantial" Associations="Associations" />
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_AssociationsCircumstantial">Circumstantial</label>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_AssociationsTangential" name="CheckBox_CustomDocumentPsychiatricNoteExams_AssociationsTangential" Associations="Associations" />
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_AssociationsTangential">Tangential</label>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_AssociationsOthers" name="CheckBox_CustomDocumentPsychiatricNoteExams_AssociationsOthers" Associations="Associations" onclick="ShowCommentBox('CheckBox_CustomDocumentPsychiatricNoteExams_AssociationsOthers', 'Textbox_CustomDocumentPsychiatricNoteExams_AssociationsOtherComments', 'CustomDocumentPsychiatricNoteExams', 'AssociationsOtherComments')" />
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_AssociationsOthers">Other</label>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                                <table border="0" cellspacing="0" cellpadding="0" border="0" width="90%">
                                                                    <tr>
                                                                        <td class="height2"></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height2" style="padding-left: 20px;">
                                                                            <input style="width: 100%;" class="form_textbox element" type="text" id="Textbox_CustomDocumentPsychiatricNoteExams_AssociationsOtherComments"
                                                                                name="Textbox_CustomDocumentPsychiatricNoteExams_AssociationsOtherComments" />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height2"></td>
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
                                                                        <td class="right_bottom_cont_bottom_bg" width="100%"></td>
                                                                        <td class="right_bottom_cont_bottom_bg" align="right" width="2">
                                                                            <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_right.gif" />
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    <%--          <table cellspacing="0" cellpadding="0" border="0" width="99%" style="margin-left: 2px;">
                                                        <tr>
                                                            <td>
                                                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                                    <tr>
                                                                        <td width="7">
                                                                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_left1.gif" />
                                                                        </td>
                                                                        <td class="content_tab_top" width="100%" />
                                                                        <td width="7">
                                                                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td valign="top" class="content_tab_bg" align="left" style="padding-left: 8px;">
                                                                <table border="0" cellspacing="0" cellpadding="0" border="0" class="TableWidth">
                                                           
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
                                                                        <td class="right_bottom_cont_bottom_bg" width="100%"></td>
                                                                        <td class="right_bottom_cont_bottom_bg" align="right" width="2">
                                                                            <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_right.gif" />
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </table>--%>


                                                    <table cellspacing="0" cellpadding="0" border="0" width="99%" style="margin-left: 2px;">
                                                        <tr>
                                                            <td>
                                                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                                    <tr>
                                                                        <td width="7">
                                                                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_left1.gif" />
                                                                        </td>
                                                                        <td class="content_tab_top" width="100%" />
                                                                        <td width="7">
                                                                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td valign="top" class="content_tab_bg" align="left" style="padding-left: 8px;">
                                                                <table border="0" cellspacing="0" cellpadding="0" border="0" width="85%">
                                                                    <tr>
                                                                        <td>
                                                                            <table width="100%">
                                                                                <tr>
                                                                                    <td>
                                                                                        <table width="65%">
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <span><b>Abnormal/Psychotic Thoughts</b></span>
                                                                                                </td>
                                                                                                <td class="RadioText">
                                                                                                    <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_AbnormalorPsychoticThoughts_A"
                                                                                                        name="RadioButton_CustomDocumentPsychiatricNoteExams_AbnormalorPsychoticThoughts" value="A" />
                                                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteExams_AbnormalorPsychoticThoughts_A">Assessed</label>
                                                                                                </td>
                                                                                                <td class="RadioText">
                                                                                                    <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_AbnormalorPsychoticThoughts_N"
                                                                                                        name="RadioButton_CustomDocumentPsychiatricNoteExams_AbnormalorPsychoticThoughts" value="N" />
                                                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteExams_AbnormalorPsychoticThoughts_N">Not Assessed</label>
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
                                                                                        <table width="100%">
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <span>Psychosis/Disturbance of Perception</span>
                                                                                                </td>
                                                                                                <td class="RadioText">
                                                                                                    <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_PsychosisOrDisturbanceOfPerception_N"
                                                                                                        name="RadioButton_CustomDocumentPsychiatricNoteExams_PsychosisOrDisturbanceOfPerception" value="N" AbnormalorPsychoticThoughts="AbnormalorPsychoticThoughts" />
                                                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteExams_PsychosisOrDisturbanceOfPerception_N">None</label>
                                                                                                </td>
                                                                                                <td class="RadioText">
                                                                                                    <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_PsychosisOrDisturbanceOfPerception_P"
                                                                                                        name="RadioButton_CustomDocumentPsychiatricNoteExams_PsychosisOrDisturbanceOfPerception" value="P" AbnormalorPsychoticThoughts="AbnormalorPsychoticThoughts" />
                                                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteExams_PsychosisOrDisturbanceOfPerception_P">Present(leave items below unchecked if not present)</label>
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
                                                                                        <table cellpadding="0" cellspacing="0" width="100%" style="padding-left: 20px;">
                                                                                            <tr class="checkbox_container">
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_PDAuditoryHallucinations" name="CheckBox_CustomDocumentPsychiatricNoteExams_PDAuditoryHallucinations" AbnormalorPsychoticThoughts="AbnormalorPsychoticThoughts" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_PDAuditoryHallucinations">Auditory hallucinations</label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_PDVisualHallucinations" name="CheckBox_CustomDocumentPsychiatricNoteExams_PDVisualHallucinations" AbnormalorPsychoticThoughts="AbnormalorPsychoticThoughts" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_PDVisualHallucinations">Visual hallucinations</label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_PDCommandHallucinations" name="CheckBox_CustomDocumentPsychiatricNoteExams_PDCommandHallucinations" AbnormalorPsychoticThoughts="AbnormalorPsychoticThoughts" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_PDCommandHallucinations">Command hallucinations</label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_PDDelusions" name="CheckBox_CustomDocumentPsychiatricNoteExams_PDDelusions" AbnormalorPsychoticThoughts="AbnormalorPsychoticThoughts" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_PDDelusions">Delusions</label>
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td class="height2"></td>
                                                                                            </tr>
                                                                                            <tr class="checkbox_container">
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_PDPreoccupation" name="CheckBox_CustomDocumentPsychiatricNoteExams_PDPreoccupation" AbnormalorPsychoticThoughts="AbnormalorPsychoticThoughts" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_PDPreoccupation">Preoccupation w/violence</label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_PDOlfactoryHallucinations" name="CheckBox_CustomDocumentPsychiatricNoteExams_PDOlfactoryHallucinations" AbnormalorPsychoticThoughts="AbnormalorPsychoticThoughts" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_PDOlfactoryHallucinations">Olfactory hallucinations</label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_PDGustatoryHallucinations" name="CheckBox_CustomDocumentPsychiatricNoteExams_PDGustatoryHallucinations" AbnormalorPsychoticThoughts="AbnormalorPsychoticThoughts" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_PDGustatoryHallucinations">Gustatory hallucinations</label>
                                                                                                </td>
                                                                                                <td>&nbsp;
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td class="height2"></td>
                                                                                            </tr>
                                                                                            <tr class="checkbox_container">
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_PDTactileHallucinations" name="CheckBox_CustomDocumentPsychiatricNoteExams_PDTactileHallucinations" AbnormalorPsychoticThoughts="AbnormalorPsychoticThoughts" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_PDTactileHallucinations">Tactile hallucinations</label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_PDSomaticHallucinations" name="CheckBox_CustomDocumentPsychiatricNoteExams_PDSomaticHallucinations" AbnormalorPsychoticThoughts="AbnormalorPsychoticThoughts" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_PDSomaticHallucinations">Somatic hallucinations</label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_PDIllusions" name="CheckBox_CustomDocumentPsychiatricNoteExams_PDIllusions" AbnormalorPsychoticThoughts="AbnormalorPsychoticThoughts" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_PDIllusions">Illusions</label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_AbnormalPsychoticOthers" name="CheckBox_CustomDocumentPsychiatricNoteExams_AbnormalPsychoticOthers" AbnormalorPsychoticThoughts="AbnormalorPsychoticThoughts" onclick="ShowCommentBox('CheckBox_CustomDocumentPsychiatricNoteExams_AbnormalPsychoticOthers', 'Textbox_CustomDocumentPsychiatricNoteExams_AbnormalPsychoticOthersComments', 'CustomDocumentPsychiatricNoteExams', 'AbnormalPsychoticOthersComments')" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_AbnormalPsychoticOthers">Other</label>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td class="height2">
                                                                                        <table border="0" cellspacing="0" cellpadding="0" border="0" width="100%">
                                                                                            <tr>
                                                                                                <td class="height2"></td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td class="height2" style="padding-left: 20px;">
                                                                                                    <input style="width: 100%;" class="form_textbox element" type="text" id="Textbox_CustomDocumentPsychiatricNoteExams_AbnormalPsychoticOthersComments"
                                                                                                        name="Textbox_CustomDocumentPsychiatricNoteExams_AbnormalPsychoticOthersComments" />
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td class="height2"></td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <table cellpadding="0" cellspacing="0" width="70%" style="padding-left: 10px;">
                                                                                            <tr class="checkbox_container">
                                                                                                <td>
                                                                                                    <span>Current suicide ideation</span>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_PDCurrentSuicideIdeation_Y"
                                                                                                        name="RadioButton_CustomDocumentPsychiatricNoteExams_PDCurrentSuicideIdeation" value="Y" AbnormalorPsychoticThoughts="AbnormalorPsychoticThoughts" />
                                                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteExams_PDCurrentSuicideIdeation_Y">
                                                                                                        Yes</label>
                                                                                                    <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_PDCurrentSuicideIdeation_N"
                                                                                                        name="RadioButton_CustomDocumentPsychiatricNoteExams_PDCurrentSuicideIdeation" value="N" AbnormalorPsychoticThoughts="AbnormalorPsychoticThoughts" />
                                                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteExams_PDCurrentSuicideIdeation_N">
                                                                                                        No</label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <span>Current suicidal plan</span>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_PDCurrentSuicidalPlan_Y"
                                                                                                        name="RadioButton_CustomDocumentPsychiatricNoteExams_PDCurrentSuicidalPlan" value="Y" AbnormalorPsychoticThoughts="AbnormalorPsychoticThoughts" />
                                                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteExams_PDCurrentSuicidalPlan_Y">
                                                                                                        Yes</label>
                                                                                                    <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_PDCurrentSuicidalPlan_N"
                                                                                                        name="RadioButton_CustomDocumentPsychiatricNoteExams_PDCurrentSuicidalPlan" value="N" AbnormalorPsychoticThoughts="AbnormalorPsychoticThoughts" />
                                                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteExams_PDCurrentSuicidalPlan_N">
                                                                                                        No</label>
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td class="height2"></td>
                                                                                            </tr>
                                                                                            <tr class="checkbox_container">
                                                                                                <td>
                                                                                                    <span>Current suicidal intent</span>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_PDCurrentSuicidalIntent_Y"
                                                                                                        name="RadioButton_CustomDocumentPsychiatricNoteExams_PDCurrentSuicidalIntent" value="Y" AbnormalorPsychoticThoughts="AbnormalorPsychoticThoughts" />
                                                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteExams_PDCurrentSuicidalIntent_Y">
                                                                                                        Yes</label>
                                                                                                    <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_PDCurrentSuicidalIntent_N"
                                                                                                        name="RadioButton_CustomDocumentPsychiatricNoteExams_PDCurrentSuicidalIntent" value="N" AbnormalorPsychoticThoughts="AbnormalorPsychoticThoughts" />
                                                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteExams_PDCurrentSuicidalIntent_N">
                                                                                                        No</label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <span>Means to carry out attempt</span>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_PDMeanstocarry_Y"
                                                                                                        name="RadioButton_CustomDocumentPsychiatricNoteExams_PDMeanstocarry" value="Y" AbnormalorPsychoticThoughts="AbnormalorPsychoticThoughts" />
                                                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteExams_PDMeanstocarry_Y">
                                                                                                        Yes</label>
                                                                                                    <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_PDMeanstocarry_N"
                                                                                                        name="RadioButton_CustomDocumentPsychiatricNoteExams_PDMeanstocarry" value="N" AbnormalorPsychoticThoughts="AbnormalorPsychoticThoughts" />
                                                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteExams_PDMeanstocarry_N">
                                                                                                        No</label>
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td class="height2"></td>
                                                                                            </tr>
                                                                                            <tr class="checkbox_container">
                                                                                                <td>
                                                                                                    <span>Current homicidal ideation</span>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_PDCurrentHomicidalIdeation_Y"
                                                                                                        name="RadioButton_CustomDocumentPsychiatricNoteExams_PDCurrentHomicidalIdeation" value="Y" AbnormalorPsychoticThoughts="AbnormalorPsychoticThoughts" />
                                                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteExams_PDCurrentHomicidalIdeation_Y">
                                                                                                        Yes</label>
                                                                                                    <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_PDCurrentHomicidalIdeation_N"
                                                                                                        name="RadioButton_CustomDocumentPsychiatricNoteExams_PDCurrentHomicidalIdeation" value="N" AbnormalorPsychoticThoughts="AbnormalorPsychoticThoughts" />
                                                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteExams_PDCurrentHomicidalIdeation_N">
                                                                                                        No</label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <span>Current homicidal plans</span>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_PDCurrentHomicidalPlans_Y"
                                                                                                        name="RadioButton_CustomDocumentPsychiatricNoteExams_PDCurrentHomicidalPlans" value="Y" AbnormalorPsychoticThoughts="AbnormalorPsychoticThoughts" />
                                                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteExams_PDCurrentHomicidalPlans_Y">
                                                                                                        Yes</label>
                                                                                                    <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_PDCurrentHomicidalPlans_N"
                                                                                                        name="RadioButton_CustomDocumentPsychiatricNoteExams_PDCurrentHomicidalPlans" value="N" AbnormalorPsychoticThoughts="AbnormalorPsychoticThoughts" />
                                                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteExams_PDCurrentHomicidalPlans_N">
                                                                                                        No</label>
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td class="height2"></td>
                                                                                            </tr>
                                                                                            <tr class="checkbox_container">
                                                                                                <td>
                                                                                                    <span>Current homicidal intent</span>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_PDCurrentHomicidalIntent_Y"
                                                                                                        name="RadioButton_CustomDocumentPsychiatricNoteExams_PDCurrentHomicidalIntent" value="Y" AbnormalorPsychoticThoughts="AbnormalorPsychoticThoughts" />
                                                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteExams_PDCurrentHomicidalIntent_Y">
                                                                                                        Yes</label>
                                                                                                    <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_PDCurrentHomicidalIntent_N"
                                                                                                        name="RadioButton_CustomDocumentPsychiatricNoteExams_PDCurrentHomicidalIntent" value="N" AbnormalorPsychoticThoughts="AbnormalorPsychoticThoughts" />
                                                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteExams_PDCurrentHomicidalIntent_N">
                                                                                                        No</label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <span>Means to carry out attempt</span>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_PDMeansToCarryNew_Y"
                                                                                                        name="RadioButton_CustomDocumentPsychiatricNoteExams_PDMeansToCarryNew" value="Y" AbnormalorPsychoticThoughts="AbnormalorPsychoticThoughts" />
                                                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteExams_PDMeansToCarryNew_Y">
                                                                                                        Yes</label>
                                                                                                    <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_PDMeansToCarryNew_N"
                                                                                                        name="RadioButton_CustomDocumentPsychiatricNoteExams_PDMeansToCarryNew" value="N" AbnormalorPsychoticThoughts="AbnormalorPsychoticThoughts" />
                                                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteExams_PDMeansToCarryNew_N">
                                                                                                        No</label>
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
                                                                        <td class="right_bottom_cont_bottom_bg" width="100%"></td>
                                                                        <td class="right_bottom_cont_bottom_bg" align="right" width="2">
                                                                            <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_right.gif" />
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    <table cellspacing="0" cellpadding="0" border="0" width="99%" style="margin-left: 2px;">
                                                        <tr>
                                                            <td>
                                                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                                    <tr>
                                                                        <td width="7">
                                                                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_left1.gif" />
                                                                        </td>
                                                                        <td class="content_tab_top" width="100%" />
                                                                        <td width="7">
                                                                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td valign="top" class="content_tab_bg" align="left" style="padding-left: 8px;">
                                                                <table border="0" cellspacing="0" cellpadding="0" border="0" width="90%">
                                                                    <tr>
                                                                        <td>
                                                                            <table width="100%">
                                                                                <tr>
                                                                                    <td>
                                                                                        <table width="100%">
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <span><b>Orientation</b></span>
                                                                                                </td>
                                                                                                <td class="RadioText">
                                                                                                    <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_Orientation_A"
                                                                                                        name="RadioButton_CustomDocumentPsychiatricNoteExams_Orientation" value="A" />
                                                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteExams_Orientation_A">Assessed</label>
                                                                                                </td>
                                                                                                <td class="RadioText">
                                                                                                    <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_Orientation_N"
                                                                                                        name="RadioButton_CustomDocumentPsychiatricNoteExams_Orientation" value="N" />
                                                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteExams_Orientation_N">Not Assessed</label>
                                                                                                </td>
                                                                                                <td class="RadioText">
                                                                                                    <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_Orientation_W"
                                                                                                        name="RadioButton_CustomDocumentPsychiatricNoteExams_Orientation" value="W" />
                                                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteExams_Orientation_W">WNL – Oriented to person, place, time, situation</label>
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
                                                                                        <table cellpadding="0" cellspacing="0" width="75%" style="padding-left: 20px;">
                                                                                            <tr class="checkbox_container">
                                                                                                <td>
                                                                                                    <span>Disoriented to</span>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_OrientationPerson" name="CheckBox_CustomDocumentPsychiatricNoteExams_OrientationPerson" Orientation="Orientation" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_OrientationPerson">Person</label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_OrientationPlace" name="CheckBox_CustomDocumentPsychiatricNoteExams_OrientationPlace" Orientation="Orientation" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_OrientationPlace">Place</label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_OrientationTime" name="CheckBox_CustomDocumentPsychiatricNoteExams_OrientationTime" Orientation="Orientation" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_OrientationTime">Time</label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_OrientationSituation" name="CheckBox_CustomDocumentPsychiatricNoteExams_OrientationSituation" Orientation="Orientation" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_OrientationSituation">Situation</label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_OrientationOthers" name="CheckBox_CustomDocumentPsychiatricNoteExams_OrientationOthers" Orientation="Orientation" onclick="ShowCommentBox('CheckBox_CustomDocumentPsychiatricNoteExams_OrientationOthers', 'Textbox_CustomDocumentPsychiatricNoteExams_OrientationOtherComments', 'CustomDocumentPsychiatricNoteExams', 'OrientationOtherComments')" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_OrientationOthers">Other</label>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                        <table border="0" cellspacing="0" cellpadding="0" border="0" width="100%">
                                                                                            <tr>
                                                                                                <td class="height2"></td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td class="height2" style="padding-left: 20px;">
                                                                                                    <input style="width: 100%;" class="form_textbox element" type="text" id="Textbox_CustomDocumentPsychiatricNoteExams_OrientationOtherComments"
                                                                                                        name="Textbox_CustomDocumentPsychiatricNoteExams_OrientationOtherComments" />
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td class="height2"></td>
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
                                                                        <td class="right_bottom_cont_bottom_bg" width="100%"></td>
                                                                        <td class="right_bottom_cont_bottom_bg" align="right" width="2">
                                                                            <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_right.gif" />
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    <table cellspacing="0" cellpadding="0" border="0" width="99%" style="margin-left: 2px;">
                                                        <tr>
                                                            <td>
                                                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                                    <tr>
                                                                        <td width="7">
                                                                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_left1.gif" />
                                                                        </td>
                                                                        <td class="content_tab_top" width="100%" />
                                                                        <td width="7">
                                                                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td valign="top" class="content_tab_bg" align="left" style="padding-left: 8px;">
                                                                <table border="0" cellspacing="0" cellpadding="0" border="0" width="95%">
                                                                    <tr>
                                                                        <td>
                                                                            <table width="100%">
                                                                                <tr>
                                                                                    <td>
                                                                                        <table width="90%">
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <span><b>Fund of Knowledge</b></span>
                                                                                                </td>
                                                                                                <td class="RadioText">
                                                                                                    <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_FundOfKnowledge_A"
                                                                                                        name="RadioButton_CustomDocumentPsychiatricNoteExams_FundOfKnowledge" value="A" />
                                                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteExams_FundOfKnowledge_A">Assessed</label>
                                                                                                </td>
                                                                                                <td class="RadioText">
                                                                                                    <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_FundOfKnowledge_N"
                                                                                                        name="RadioButton_CustomDocumentPsychiatricNoteExams_FundOfKnowledge" value="N" />
                                                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteExams_FundOfKnowledge_N">Not Assessed</label>
                                                                                                </td>
                                                                                                <td class="RadioText">
                                                                                                    <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_FundOfKnowledge_W"
                                                                                                        name="RadioButton_CustomDocumentPsychiatricNoteExams_FundOfKnowledge" value="W" />
                                                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteExams_FundOfKnowledge_W">Fund of knowledge WNL for developmental level</label>
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
                                                                                        <table cellpadding="0" cellspacing="0" width="95%" style="padding-left: 20px;">
                                                                                            <tr class="checkbox_container">
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_FundOfKnowledgeCurrentEvents" name="CheckBox_CustomDocumentPsychiatricNoteExams_FundOfKnowledgeCurrentEvents" FundOfKnowledge="FundOfKnowledge" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_FundOfKnowledgeCurrentEvents">Unaware of current events</label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_FundOfKnowledgePastHistory" name="CheckBox_CustomDocumentPsychiatricNoteExams_FundOfKnowledgePastHistory" FundOfKnowledge="FundOfKnowledge" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_FundOfKnowledgePastHistory">Unaware of past history</label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_FundOfKnowledgeVocabulary" name="CheckBox_CustomDocumentPsychiatricNoteExams_FundOfKnowledgeVocabulary" FundOfKnowledge="FundOfKnowledge" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_FundOfKnowledgeVocabulary">Vocabulary inappropriate for age</label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_FundOfKnowledgeOthers" name="CheckBox_CustomDocumentPsychiatricNoteExams_FundOfKnowledgeOthers" FundOfKnowledge="FundOfKnowledge" onclick="ShowCommentBox('CheckBox_CustomDocumentPsychiatricNoteExams_FundOfKnowledgeOthers', 'Textbox_CustomDocumentPsychiatricNoteExams_FundOfKnowledgeOtherComments', 'CustomDocumentPsychiatricNoteExams', 'FundOfKnowledgeOtherComments')" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_FundOfKnowledgeOthers">Other</label>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                                <table border="0" cellspacing="0" cellpadding="0" border="0" width="90%">
                                                                    <tr>
                                                                        <td class="height2"></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height2" style="padding-left: 20px;">
                                                                            <input style="width: 100%;" class="form_textbox element" type="text" id="Textbox_CustomDocumentPsychiatricNoteExams_FundOfKnowledgeOtherComments"
                                                                                name="Textbox_CustomDocumentPsychiatricNoteExams_FundOfKnowledgeOtherComments" />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height2"></td>
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
                                                                        <td class="right_bottom_cont_bottom_bg" width="100%"></td>
                                                                        <td class="right_bottom_cont_bottom_bg" align="right" width="2">
                                                                            <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_right.gif" />
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    <table cellspacing="0" cellpadding="0" border="0" width="99%" style="margin-left: 2px;">
                                                        <tr>
                                                            <td>
                                                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                                    <tr>
                                                                        <td width="7">
                                                                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_left1.gif" />
                                                                        </td>
                                                                        <td class="content_tab_top" width="100%" />
                                                                        <td width="7">
                                                                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td valign="top" class="content_tab_bg" align="left" style="padding-left: 8px;">
                                                                <table border="0" cellspacing="0" cellpadding="0" border="0" width="70%">
                                                                    <tr>
                                                                        <td>
                                                                            <table width="100%">
                                                                                <tr>
                                                                                    <td>
                                                                                        <table width="65%">
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <span><b>Insight and Judgement</b></span>
                                                                                                </td>
                                                                                                <td class="RadioText">
                                                                                                    <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_InsightAndJudgement_A"
                                                                                                        name="RadioButton_CustomDocumentPsychiatricNoteExams_InsightAndJudgement" value="A" />
                                                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteExams_InsightAndJudgement_A">Assessed</label>
                                                                                                </td>
                                                                                                <td class="RadioText">
                                                                                                    <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_InsightAndJudgement_N"
                                                                                                        name="RadioButton_CustomDocumentPsychiatricNoteExams_InsightAndJudgement" value="N" />
                                                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteExams_InsightAndJudgement_N">Not Assessed</label>
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
                                                                                        <table cellpadding="0" cellspacing="0" width="95%" style="padding-left: 20px;">
                                                                                            <tr class="checkbox_container">
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_InsightAndJudgementStatus_E"
                                                                                                        name="RadioButton_CustomDocumentPsychiatricNoteExams_InsightAndJudgementStatus" value="E" InsightAndJudgement="InsightAndJudgement" />
                                                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteExams_InsightAndJudgementStatus_E">Excellent</label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_InsightAndJudgementStatus_G"
                                                                                                        name="RadioButton_CustomDocumentPsychiatricNoteExams_InsightAndJudgementStatus" value="G" InsightAndJudgement="InsightAndJudgement" />
                                                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteExams_InsightAndJudgementStatus_G">Good</label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_InsightAndJudgementStatus_F"
                                                                                                        name="RadioButton_CustomDocumentPsychiatricNoteExams_InsightAndJudgementStatus" value="F" InsightAndJudgement="InsightAndJudgement" />
                                                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteExams_InsightAndJudgementStatus_F">Fair</label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_InsightAndJudgementStatus_P"
                                                                                                        name="RadioButton_CustomDocumentPsychiatricNoteExams_InsightAndJudgementStatus" value="P" InsightAndJudgement="InsightAndJudgement" />
                                                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteExams_InsightAndJudgementStatus_P">Poor</label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_InsightAndJudgementStatus_R"
                                                                                                        name="RadioButton_CustomDocumentPsychiatricNoteExams_InsightAndJudgementStatus" value="R" InsightAndJudgement="InsightAndJudgement" />
                                                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteExams_InsightAndJudgementStatus_R">Grossly Impaired</label>
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td class="height2"></td>
                                                                                            </tr>

                                                                                        </table>
                                                                                        <table>
                                                                                            <tr class="checkbox_container">
                                                                                                <td style="padding-left: 20px;">
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_InsightAndJudgementSubstance" name="CheckBox_CustomDocumentPsychiatricNoteExams_InsightAndJudgementSubstance" InsightAndJudgement="InsightAndJudgement" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_InsightAndJudgementSubstance">Substance related</label>
                                                                                                </td>
                                                                                                <td style="padding-left: 20px;">
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_InsightAndJudgementOthers" name="CheckBox_CustomDocumentPsychiatricNoteExams_InsightAndJudgementOthers" InsightAndJudgement="InsightAndJudgement" onclick="ShowCommentBox('CheckBox_CustomDocumentPsychiatricNoteExams_InsightAndJudgementOthers', 'Textbox_CustomDocumentPsychiatricNoteExams_InsightAndJudgementOtherComments', 'CustomDocumentPsychiatricNoteExams', 'InsightAndJudgementOtherComments')" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_InsightAndJudgementOthers">Other</label>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>

                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                                <table border="0" cellspacing="0" cellpadding="0" border="0" width="90%">
                                                                    <tr>
                                                                        <td class="height2"></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height2" style="padding-left: 20px;">
                                                                            <input style="width: 100%;" class="form_textbox element" type="text" id="Textbox_CustomDocumentPsychiatricNoteExams_InsightAndJudgementOtherComments"
                                                                                name="Textbox_CustomDocumentPsychiatricNoteExams_InsightAndJudgementOtherComments" />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height2"></td>
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
                                                                        <td class="right_bottom_cont_bottom_bg" width="100%"></td>
                                                                        <td class="right_bottom_cont_bottom_bg" align="right" width="2">
                                                                            <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_right.gif" />
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    <table cellspacing="0" cellpadding="0" border="0" width="99%" style="margin-left: 2px;">
                                                        <tr>
                                                            <td>
                                                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                                    <tr>
                                                                        <td width="7">
                                                                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_left1.gif" />
                                                                        </td>
                                                                        <td class="content_tab_top" width="100%" />
                                                                        <td width="7">
                                                                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td valign="top" class="content_tab_bg" align="left" style="padding-left: 8px;">
                                                                <table border="0" cellspacing="0" cellpadding="0" border="0" width="90%">
                                                                    <tr>
                                                                        <td>
                                                                            <table width="100%">
                                                                                <tr>
                                                                                    <td>
                                                                                        <table width="100%">
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <span><b>Memory</b></span>
                                                                                                </td>
                                                                                                <td class="RadioText">
                                                                                                    <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_Memory_A"
                                                                                                        name="RadioButton_CustomDocumentPsychiatricNoteExams_Memory" value="A" />
                                                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteExams_Memory_A">Assessed</label>
                                                                                                </td>
                                                                                                <td class="RadioText">
                                                                                                    <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_Memory_N"
                                                                                                        name="RadioButton_CustomDocumentPsychiatricNoteExams_Memory" value="N" />
                                                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteExams_Memory_N">Not Assessed</label>
                                                                                                </td>
                                                                                                <td class="RadioText">
                                                                                                    <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_Memory_W"
                                                                                                        name="RadioButton_CustomDocumentPsychiatricNoteExams_Memory" value="W" />
                                                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteExams_Memory_W">WNL – Immediate, recent, and remote memory intact</label>
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
                                                                                        <table cellpadding="0" cellspacing="0" width="30%" style="padding-left: 20px;">
                                                                                            <tr class="checkbox_container">
                                                                                                <td>
                                                                                                    <span>Immediate</span>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_MemoryImmediate_F"
                                                                                                        name="RadioButton_CustomDocumentPsychiatricNoteExams_MemoryImmediate" value="F" Memory="Memory" />
                                                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteExams_MemoryImmediate_F">Fair</label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_MemoryImmediate_I"
                                                                                                        name="RadioButton_CustomDocumentPsychiatricNoteExams_MemoryImmediate" value="I" Memory="Memory" />
                                                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteExams_MemoryImmediate_I">Impaired</label>
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td class="height2"></td>
                                                                                            </tr>
                                                                                            <tr class="checkbox_container">
                                                                                                <td>
                                                                                                    <span>Recent</span>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_MemoryRecent_F"
                                                                                                        name="RadioButton_CustomDocumentPsychiatricNoteExams_MemoryRecent" value="F" Memory="Memory" />
                                                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteExams_MemoryRecent_F">Fair</label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_MemoryRecent_I"
                                                                                                        name="RadioButton_CustomDocumentPsychiatricNoteExams_MemoryRecent" value="I" Memory="Memory" />
                                                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteExams_MemoryRecent_I">Impaired</label>
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td class="height2"></td>
                                                                                            </tr>
                                                                                            <tr class="checkbox_container">
                                                                                                <td>
                                                                                                    <span>Remote</span>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_MemoryRemote_F"
                                                                                                        name="RadioButton_CustomDocumentPsychiatricNoteExams_MemoryRemote" value="F" Memory="Memory" />
                                                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteExams_MemoryRemote_F">Fair</label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_MemoryRemote_I"
                                                                                                        name="RadioButton_CustomDocumentPsychiatricNoteExams_MemoryRemote" value="I" Memory="Memory" />
                                                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteExams_MemoryRemote_I">Impaired</label>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                                <table border="0" cellspacing="0" cellpadding="0" border="0" width="90%">
                                                                    <tr>
                                                                        <td class="height2"></td>
                                                                    </tr>
                                                                    <tr class="checkbox_container">
                                                                        <td style="padding-left: 20px;">
                                                                            <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_MemoryOthers" name="CheckBox_CustomDocumentPsychiatricNoteExams_MemoryOthers"  Memory="Memory" onclick="ShowCommentBox('CheckBox_CustomDocumentPsychiatricNoteExams_MemoryOthers', 'Textbox_CustomDocumentPsychiatricNoteExams_MemoryOtherComments', 'CustomDocumentPsychiatricNoteExams', 'MemoryOtherComments')" />
                                                                            <label for="CheckBox_CustomDocumentPsychiatricNoteExams_MemoryOthers">Other</label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height2"></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height2" style="padding-left: 20px;">
                                                                            <input style="width: 100%;" class="form_textbox element" type="text" id="Textbox_CustomDocumentPsychiatricNoteExams_MemoryOtherComments"
                                                                                name="Textbox_CustomDocumentPsychiatricNoteExams_MemoryOtherComments" />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height2"></td>
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
                                                                        <td class="right_bottom_cont_bottom_bg" width="100%"></td>
                                                                        <td class="right_bottom_cont_bottom_bg" align="right" width="2">
                                                                            <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_right.gif" />
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    <table cellspacing="0" cellpadding="0" border="0" width="99%" style="margin-left: 2px;">
                                                        <tr>
                                                            <td>
                                                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                                    <tr>
                                                                        <td width="7">
                                                                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_left1.gif" />
                                                                        </td>
                                                                        <td class="content_tab_top" width="100%" />
                                                                        <td width="7">
                                                                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td valign="top" class="content_tab_bg" align="left" style="padding-left: 8px;">
                                                                <table border="0" cellspacing="0" cellpadding="0" border="0" width="60%">
                                                                    <tr>
                                                                        <td>
                                                                            <table width="100%">

                                                                                <tr>
                                                                                    <td>
                                                                                        <table width="90%">
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <span><b>Muscle Strength/Tone</b></span>
                                                                                                </td>
                                                                                                <td class="RadioText">
                                                                                                    <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_MuscleStrengthorTone_A"
                                                                                                        name="RadioButton_CustomDocumentPsychiatricNoteExams_MuscleStrengthorTone" value="A" />
                                                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteExams_MuscleStrengthorTone_A">Assessed</label>
                                                                                                </td>
                                                                                                <td class="RadioText">
                                                                                                    <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_MuscleStrengthorTone_N"
                                                                                                        name="RadioButton_CustomDocumentPsychiatricNoteExams_MuscleStrengthorTone" value="N" />
                                                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteExams_MuscleStrengthorTone_N">Not Assessed</label>
                                                                                                </td>
                                                                                                <td class="RadioText">
                                                                                                    <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_MuscleStrengthorTone_W"
                                                                                                        name="RadioButton_CustomDocumentPsychiatricNoteExams_MuscleStrengthorTone" value="W" />
                                                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteExams_MuscleStrengthorTone_W">WNL</label>
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
                                                                                        <table cellpadding="0" cellspacing="0" width="75%" style="padding-left: 20px;">
                                                                                            <tr class="checkbox_container">
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_MuscleStrengthorToneAtrophy" name="CheckBox_CustomDocumentPsychiatricNoteExams_MuscleStrengthorToneAtrophy" MuscleStrengthorTone="MuscleStrengthorTone" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_MuscleStrengthorToneAtrophy">Atrophy</label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_MuscleStrengthorToneAbnormal" name="CheckBox_CustomDocumentPsychiatricNoteExams_MuscleStrengthorToneAbnormal" MuscleStrengthorTone="MuscleStrengthorTone" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_MuscleStrengthorToneAbnormal">Abnormal Movements</label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_MuscleStrengthOthers" name="CheckBox_CustomDocumentPsychiatricNoteExams_MuscleStrengthOthers" MuscleStrengthorTone="MuscleStrengthorTone" onclick="ShowCommentBox('CheckBox_CustomDocumentPsychiatricNoteExams_MuscleStrengthOthers', 'Textbox_CustomDocumentPsychiatricNoteExams_MuscleStrengthOtherComments', 'CustomDocumentPsychiatricNoteExams', 'MuscleStrengthOtherComments')" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_MuscleStrengthOthers">Other</label>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                                <table border="0" cellspacing="0" cellpadding="0" border="0" width="90%">
                                                                    <tr>
                                                                        <td class="height2"></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height2" style="padding-left: 20px;">
                                                                            <input style="width: 100%;" class="form_textbox element" type="text" id="Textbox_CustomDocumentPsychiatricNoteExams_MuscleStrengthOtherComments"
                                                                                name="Textbox_CustomDocumentPsychiatricNoteExams_MuscleStrengthOtherComments" />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height2"></td>
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
                                                                        <td class="right_bottom_cont_bottom_bg" width="100%"></td>
                                                                        <td class="right_bottom_cont_bottom_bg" align="right" width="2">
                                                                            <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_right.gif" />
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    <table cellspacing="0" cellpadding="0" border="0" width="99%" style="margin-left: 2px;">
                                                        <tr>
                                                            <td>
                                                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                                    <tr>
                                                                        <td width="7">
                                                                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_left1.gif" />
                                                                        </td>
                                                                        <td class="content_tab_top" width="100%" />
                                                                        <td width="7">
                                                                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td valign="top" class="content_tab_bg" align="left" style="padding-left: 8px;">
                                                                <table border="0" cellspacing="0" cellpadding="0" border="0" width="65%">
                                                                    <tr>
                                                                        <td>
                                                                            <table width="100%">

                                                                                <tr>
                                                                                    <td>
                                                                                        <table width="90%">
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <span><b>Gait and Station</b></span>
                                                                                                </td>
                                                                                                <td class="RadioText">
                                                                                                    <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_GaitandStation_A"
                                                                                                        name="RadioButton_CustomDocumentPsychiatricNoteExams_GaitandStation" value="A" />
                                                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteExams_GaitandStation_A">Assessed</label>
                                                                                                </td>
                                                                                                <td class="RadioText">
                                                                                                    <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_GaitandStation_N"
                                                                                                        name="RadioButton_CustomDocumentPsychiatricNoteExams_GaitandStation" value="N" />
                                                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteExams_GaitandStation_N">Not Assessed</label>
                                                                                                </td>
                                                                                                <td class="RadioText">
                                                                                                    <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_GaitandStation_G"
                                                                                                        name="RadioButton_CustomDocumentPsychiatricNoteExams_GaitandStation" value="W" />
                                                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteExams_GaitandStation_W">WNL</label>
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
                                                                                        <table cellpadding="0" cellspacing="0" width="100%" style="padding-left: 20px;">
                                                                                            <tr class="checkbox_container">
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_GaitandStationRestlessness" name="CheckBox_CustomDocumentPsychiatricNoteExams_GaitandStationRestlessness" GaitandStation="GaitandStation" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_GaitandStationRestlessness">Restlessness</label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_GaitandStationStaggered" name="CheckBox_CustomDocumentPsychiatricNoteExams_GaitandStationStaggered" GaitandStation="GaitandStation" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_GaitandStationStaggered">Staggered</label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_GaitandStationShuffling" name="CheckBox_CustomDocumentPsychiatricNoteExams_GaitandStationShuffling" GaitandStation="GaitandStation" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_GaitandStationShuffling">Shuffling</label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_GaitandStationUnstable" name="CheckBox_CustomDocumentPsychiatricNoteExams_GaitandStationUnstable" GaitandStation="GaitandStation" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_GaitandStationUnstable">Unstable</label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_GaitAndStationOthers" name="CheckBox_CustomDocumentPsychiatricNoteExams_GaitAndStationOthers" GaitandStation="GaitandStation" onclick="ShowCommentBox('CheckBox_CustomDocumentPsychiatricNoteExams_GaitAndStationOthers', 'Textbox_CustomDocumentPsychiatricNoteExams_GaitAndStationOtherComments', 'CustomDocumentPsychiatricNoteExams', 'GaitAndStationOtherComments')" />
                                                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteExams_GaitAndStationOthers">Other</label>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                                <table border="0" cellspacing="0" cellpadding="0" border="0" width="90%">
                                                                    <tr>
                                                                        <td class="height2"></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height2" style="padding-left: 20px;">
                                                                            <input style="width: 100%;" class="form_textbox element" type="text" id="Textbox_CustomDocumentPsychiatricNoteExams_GaitAndStationOtherComments"
                                                                                name="Textbox_CustomDocumentPsychiatricNoteExams_GaitAndStationOtherComments" />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height2"></td>
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
                                                                        <td class="right_bottom_cont_bottom_bg" width="100%"></td>
                                                                        <td class="right_bottom_cont_bottom_bg" align="right" width="2">
                                                                            <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_right.gif" />
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                        <tr>
                                                            <td class="height4"></td>
                                                        </tr>
                                                        <tr>
                                                            <td><span style="padding-left: 10px;"><b>Comments</b></span></td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height4"></td>
                                                        </tr>

                                                        <tr>
                                                            <td style="padding-left: 10px; padding-right: 10px">

                                                                <textarea class="form_textarea" id="TextArea_CustomDocumentPsychiatricNoteExams_MentalStatusComments"
                                                                    name="TextArea_CustomDocumentPsychiatricNoteExams_MentalStatusComments" rows="4"
                                                                    spellcheck="True" datatype="String" cols="80"></textarea>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2"></td>
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
                                                            <td class="right_bottom_cont_bottom_bg" width="100%"></td>
                                                            <td class="right_bottom_cont_bottom_bg" align="right" width="2">
                                                                <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_right.gif" />
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

                                <tr>
                                    <td>
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                                <td>
                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                            <td class="content_tab_left" align="left" nowrap='nowrap'><span>Review</span>
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
                                                <td class="content_tab_bg">
                                                    <table width="98%" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                            <td align="left">
                                                                <table cellpadding="0" cellspacing="0" border="0" width="98%">
                                                                    <tr>
                                                                        <td class="height2"></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="text-align: left; padding-left: 10px;">
                                                                            <table cellpadding="3" cellspacing="0" border="0" width="100%">
                                                                                <tr>
                                                                                    <td class="checkbox_container" width="30%">
                                                                                        <table>
                                                                                            <tr>
                                                                                                <td style="width: 32%">
                                                                                                    <input type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_ReviewWithChanges_C"
                                                                                                        value="C" name="RadioButton_CustomDocumentPsychiatricNoteExams_ReviewWithChanges"
                                                                                                        style="cursor: default" />
                                                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteExams_ReviewWithChanges_A"
                                                                                                        style="cursor: default">
                                                                                                        Review with changes</label>
                                                                                                </td>
                                                                                                <td style="width: 32%">
                                                                                                    <input type="radio" id="RadioButton_CustomDocumentPsychiatricNoteGenerals_ReviewWithChanges_N"
                                                                                                        value="N" name="RadioButton_CustomDocumentPsychiatricNoteExams_ReviewWithChanges"
                                                                                                        style="cursor: default" />
                                                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteExams_ReviewWithChanges_C"
                                                                                                        style="cursor: default">
                                                                                                        Review with no changes</label>
                                                                                                </td>
                                                                                                <td style="width: 32%">
                                                                                                    <input type="radio" id="RadioButton_CustomDocumentPsychiatricNoteExams_ReviewWithChanges_A"
                                                                                                        value="A" name="RadioButton_CustomDocumentPsychiatricNoteExams_ReviewWithChanges"
                                                                                                        style="cursor: default" />
                                                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteExams_ReviewWithChanges_A"
                                                                                                        style="cursor: default">
                                                                                                        N/A</label>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>

                                                                                    </td>

                                                                                    <%--<td class="checkbox_container" width="30%" style="padding-left: 30px;">
                                                                                        <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_GaitStationNormalTicsTremors" name="CheckBox_CustomDocumentPsychiatricNoteExams_GaitStationNormalTicsTremors" />
                                                                                        <span class="form_label" id="Span8">Tics, tremors or abnormal movements</span>
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_GaitStationNormalTicsTremors" style="cursor: default">Tics, tremors or abnormal movements</label>
                                                                                    </td>
                                                                                    <td class="checkbox_container" width="20%">
                                                                                        <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteExams_GaitStationEPS" name="CheckBox_CustomDocumentPsychiatricNoteExams_GaitStationEPS" />
                                                                                        <span class="form_label" id="Span9">EPS</span>
                                                                                        <label for="CheckBox_CustomDocumentPsychiatricNoteExams_GaitStationEPS" style="cursor: default">EPS</label>
                                                                                    </td>--%>
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
                </table>
            </td>
        </tr>
        <tr>
            <td class="height2"></td>
        </tr>
    </table>
</div>
