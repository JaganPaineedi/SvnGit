<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ChildAdolescent.ascx.cs" Inherits="Custom_PsychiatricNote_WebPages_ChildAdolescent" %>

<div style="overflow-x: hidden">
    <table border="0" cellpadding="0" cellspacing="0" class="DocumentScreen">
        <tr>
            <td>
                <table border="0" cellpadding="0" cellspacing="0" width="99%">
                    <tr>
                        <td class="padding_label1">
                            <table id="TableHealth" border="0" cellpadding="0" cellspacing="0" width="99%" group="Health">
                                <tr>
                                    <td class="height2"></td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap="nowrap">Health <span id="Group_Health"></span>
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
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td class="padding_label1">
                                                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                        <tr class="RadioText">
                                                            <td align="left" width="55%">
                                                                <span>Problems with labor and delivery</span>
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_ProblemsLabors_Y"
                                                                    name="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_ProblemsLabors" value="Y" />
                                                                <label for="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_ProblemsLabors_Y">
                                                                    Yes</label>
                                                            </td>
                                                            <td width="8px">&nbsp;
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_ProblemsLabors_N"
                                                                    name="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_ProblemsLabors" value="N" />
                                                                <label for="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_ProblemsLabors_N">
                                                                    No</label>
                                                            </td>
                                                            <td width="8px">&nbsp;
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_ProblemsLabors_U"
                                                                    name="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_ProblemsLabors" value="U" />
                                                                <label for="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_ProblemsLabors_U">
                                                                    Unknown</label>
                                                            </td>
                                                            <td width="15px">&nbsp;
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="8" class="height1"></td>
                                                        </tr>
                                                        <tr class="RadioText">
                                                            <td align="left" width="55%">
                                                                <span>Problems with the pregnancy</span>
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_ProblemsPregnancy_Y"
                                                                    name="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_ProblemsPregnancy" value="Y" />
                                                                <label for="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_ProblemsPregnancy_Y">
                                                                    Yes</label>
                                                            </td>
                                                            <td width="8px">&nbsp;
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_ProblemsPregnancy_N"
                                                                    name="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_ProblemsPregnancy" value="N" />
                                                                <label for="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_ProblemsPregnancy_N">
                                                                    No</label>
                                                            </td>
                                                            <td width="8px">&nbsp;
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_ProblemsPregnancy_U"
                                                                    name="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_ProblemsPregnancy" value="U" />
                                                                <label for="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_ProblemsPregnancy_U">
                                                                    Unknown</label>
                                                            </td>
                                                            <td width="15px">&nbsp;
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="8" class="height1"></td>
                                                        </tr>
                                                        <tr class="RadioText">
                                                            <td align="left" width="55%">
                                                                <span>Prenatal exposure to substances?</span>
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_PrenatalExposure_Y"
                                                                    name="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_PrenatalExposure" value="Y" />
                                                                <label for="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_PrenatalExposure_Y">
                                                                    Yes</label>
                                                            </td>
                                                            <td width="8px">&nbsp;
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_PrenatalExposure_N"
                                                                    name="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_PrenatalExposure" value="N" />
                                                                <label for="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_PrenatalExposure_N">
                                                                    No</label>
                                                            </td>
                                                            <td width="8px">&nbsp;
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_PrenatalExposure_U"
                                                                    name="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_PrenatalExposure" value="U" />
                                                                <label for="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_PrenatalExposure_U">
                                                                    Unknown</label>
                                                            </td>
                                                            <td width="15px">&nbsp;
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="8" class="height1"></td>
                                                        </tr>
                                                        <tr class="RadioText">
                                                            <td align="left" width="55%">
                                                                <span>Are there current physical health issues facing the child?</span>
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_CurrentHealthIssues_Y"
                                                                    name="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_CurrentHealthIssues" value="Y" />
                                                                <label for="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_CurrentHealthIssues_Y">
                                                                    Yes</label>
                                                            </td>
                                                            <td width="8px">&nbsp;
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_CurrentHealthIssues_N"
                                                                    name="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_CurrentHealthIssues" value="N" />
                                                                <label for="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_CurrentHealthIssues_N">
                                                                    No</label>
                                                            </td>
                                                            <td width="8px">&nbsp;
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_CurrentHealthIssues_U"
                                                                    name="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_CurrentHealthIssues" value="U" />
                                                                <label for="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_CurrentHealthIssues_U">
                                                                    Unknown</label>
                                                            </td>
                                                            <td width="15px">&nbsp;
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="8" class="height1"></td>
                                                        </tr>
                                                        <tr class="RadioText">
                                                            <td align="left" width="55%">
                                                                <span>Has the child met developmental milestones? </span>
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_ChildDevlopmental_Y"
                                                                    name="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_ChildDevlopmental" value="Y" />
                                                                <label for="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_ChildDevlopmental_Y">
                                                                    Yes</label>
                                                            </td>
                                                            <td width="8px">&nbsp;
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_ChildDevlopmental_N"
                                                                    name="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_ChildDevlopmental" value="N" />
                                                                <label for="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_ChildDevlopmental_N">
                                                                    No</label>
                                                            </td>
                                                            <td width="8px">&nbsp;
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_ChildDevlopmental_U"
                                                                    name="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_ChildDevlopmental" value="U" />
                                                                <label for="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_ChildDevlopmental_U">
                                                                    Unknown</label>
                                                            </td>
                                                            <td width="15px">&nbsp;
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="8" class="height1"></td>
                                                        </tr>
                                                        <tr class="RadioText">
                                                            <td align="left" width="55%">
                                                                <span>Are there any issues around sexuality that are of concern?</span>
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_SexualityIssues_Y"
                                                                    name="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_SexualityIssues" value="Y" />
                                                                <label for="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_SexualityIssues_Y">
                                                                    Yes</label>
                                                            </td>
                                                            <td width="8px">&nbsp;
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_SexualityIssues_N"
                                                                    name="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_SexualityIssues" value="N" />
                                                                <label for="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_SexualityIssues_N">
                                                                    No</label>
                                                            </td>
                                                            <td width="8px">&nbsp;
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_SexualityIssues_U"
                                                                    name="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_SexualityIssues" value="U" />
                                                                <label for="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_SexualityIssues_U">
                                                                    Unknown</label>
                                                            </td>
                                                            <td width="15px">&nbsp;
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="8" class="height1"></td>
                                                        </tr>
                                                        <tr class="RadioText">
                                                            <td align="left" width="55%">
                                                                <span>Are immunizations current?</span>
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_CurrentImmunizations_Y"
                                                                    name="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_CurrentImmunizations" value="Y" />
                                                                <label for="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_CurrentImmunizations_Y">
                                                                    Yes</label>
                                                            </td>
                                                            <td width="8px">&nbsp;
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_CurrentImmunizations_N"
                                                                    name="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_CurrentImmunizations" value="N" />
                                                                <label for="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_CurrentImmunizations_N">
                                                                    No</label>
                                                            </td>
                                                            <td width="8px">&nbsp;
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_CurrentImmunizations_U"
                                                                    name="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_CurrentImmunizations" value="U" />
                                                                <label for="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_CurrentImmunizations_U">
                                                                    Unknown</label>
                                                            </td>
                                                            <td width="15px">&nbsp;
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="8" class="height1"></td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr class="RadioText">
                                                <td width="100%" class="padding_label1">
                                                    <span>Please address all of the above items that have been identified as areas of concern
                                        and describe overall health functioning. </span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height1"></td>
                                            </tr>
                                            <tr>
                                                <td class="padding_label1">
                                                    <textarea class="form_textareaWithoutWidth" id="TextArea_CustomDocumentPsychiatricNoteChildAdolescents_HealthFunctioningComment" name="TextArea_CustomDocumentPsychiatricNoteChildAdolescents_HealthFunctioningComment"
                                                        rows="5" spellcheck="True" cols="155"></textarea>
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
                        <td class="padding_label1">
                            <table id="TableFunctioning" border="0" cellpadding="0" cellspacing="0" width="99%" group="Functioning">
                                <tr>
                                    <td class="height2"></td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap="nowrap">Functioning <span id="Group_Functioning"></span>
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
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td class="padding_label1">
                                                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                        <tr class="RadioText">
                                                            <td align="left" width="55%">
                                                                <span>Are there concerns with language functioning (speech and hearing)</span>
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FunctioningLanguage_Y"
                                                                    name="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FunctioningLanguage" value="Y" />
                                                                <label for="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FunctioningLanguage_Y">
                                                                    Yes</label>
                                                            </td>
                                                            <td width="8px">&nbsp;
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FunctioningLanguage_N"
                                                                    name="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FunctioningLanguage" value="N" />
                                                                <label for="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FunctioningLanguage_N">
                                                                    No</label>
                                                            </td>
                                                            <td width="8px">&nbsp;
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FunctioningLanguage_U"
                                                                    name="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FunctioningLanguage" value="U" />
                                                                <label for="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FunctioningLanguage_U">
                                                                    Unknown</label>
                                                            </td>
                                                            <td width="15px">&nbsp;
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="8" class="height1"></td>
                                                        </tr>
                                                        <tr class="RadioText">
                                                            <td align="left" width="55%">
                                                                <span>Are there concerns with visual functioning</span>
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FunctioningVisual_Y"
                                                                    name="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FunctioningVisual" value="Y" />
                                                                <label for="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FunctioningVisual_Y">
                                                                    Yes</label>
                                                            </td>
                                                            <td width="8px">&nbsp;
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FunctioningVisual_N"
                                                                    name="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FunctioningVisual" value="N" />
                                                                <label for="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FunctioningVisual_N">
                                                                    No</label>
                                                            </td>
                                                            <td width="8px">&nbsp;
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FunctioningVisual_U"
                                                                    name="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FunctioningVisual" value="U" />
                                                                <label for="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FunctioningVisual_U">
                                                                    Unknown</label>
                                                            </td>
                                                            <td width="15px">&nbsp;
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="8" class="height1"></td>
                                                        </tr>
                                                        <tr class="RadioText">
                                                            <td align="left" width="55%">
                                                                <span>Are there concerns with intellectual functioning?</span>
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FunctioningIntellectual_Y"
                                                                    name="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FunctioningIntellectual" value="Y" />
                                                                <label for="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FunctioningIntellectual_Y">
                                                                    Yes</label>
                                                            </td>
                                                            <td width="8px">&nbsp;
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FunctioningIntellectual_N"
                                                                    name="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FunctioningIntellectual" value="N" />
                                                                <label for="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FunctioningIntellectual_N">
                                                                    No</label>
                                                            </td>
                                                            <td width="8px">&nbsp;
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FunctioningIntellectual_U"
                                                                    name="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FunctioningIntellectual" value="U" />
                                                                <label for="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FunctioningIntellectual_U">
                                                                    Unknown</label>
                                                            </td>
                                                            <td width="15px">&nbsp;
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="8" class="height1"></td>
                                                        </tr>
                                                        <tr class="RadioText">
                                                            <td align="left" width="55%">
                                                                <span>Are there concerns with learning ability</span>
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FunctioningLearning_Y"
                                                                    name="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FunctioningLearning" value="Y" />
                                                                <label for="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FunctioningLearning_Y">
                                                                    Yes</label>
                                                            </td>
                                                            <td width="8px">&nbsp;
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FunctioningLearning_N"
                                                                    name="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FunctioningLearning" value="N" />
                                                                <label for="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FunctioningLearning_N">
                                                                    No</label>
                                                            </td>
                                                            <td width="8px">&nbsp;
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FunctioningLearning_U"
                                                                    name="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FunctioningLearning" value="U" />
                                                                <label for="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FunctioningLearning_U">
                                                                    Unknown</label>
                                                            </td>
                                                            <td width="15px">&nbsp;
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="8" class="height1"></td>
                                                        </tr>
                                                        <tr class="RadioText">
                                                            <td align="left" colspan="8">
                                                                <span>Please address all of the above items that have been identified as areas of concern.
                                                                </span>
                                                            </td>

                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="8" class="height1"></td>
                                            </tr>
                                            <tr>
                                                <td class="padding_label1" colspan="8">
                                                    <textarea class="form_textareaWithoutWidth" id="TextArea_CustomDocumentPsychiatricNoteChildAdolescents_AreasOfConcernComment"
                                                        name="TextArea_CustomDocumentPsychiatricNoteChildAdolescents_AreasOfConcernComment" rows="5" spellcheck="True"
                                                        cols="155"></textarea>
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
                        <td class="padding_label1">
                            <table id="TableFamilyFunctioning" border="0" cellpadding="0" cellspacing="0" width="99%" group="FamilyFunctioning">
                                <tr>
                                    <td class="height2"></td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap="nowrap">Family Functioning <span id="Group_FamilyFunctioning"></span>
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
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td class="padding_label1">
                                                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                        <tr class="RadioText">
                                                            <td align="left" colspan="4">
                                                                <span>Mental health history of child/family?</span>
                                                                <span class="RadioText" style="margin-left: 50px">
                                                                    <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FamilyMentalHealth_Y"
                                                                        name="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FamilyMentalHealth" value="Y" />
                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FamilyMentalHealth_Y">
                                                                        Yes</label></span>
                                                                <span class="RadioText" style="margin-left: 70px">
                                                                    <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FamilyMentalHealth_N"
                                                                        name="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FamilyMentalHealth" value="N" />
                                                                    <label for="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FamilyMentalHealth_N">
                                                                        No previous diagnosis or treatment history</label></span>
                                                            </td>
                                                            <td width="8px">&nbsp;
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FamilyMentalHealth_U"
                                                                    name="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FamilyMentalHealth" value="U" />
                                                                <label for="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FamilyMentalHealth_U">
                                                                    Unknown</label>
                                                            </td>
                                                            <td width="15px">&nbsp;
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="8" class="height1"></td>
                                                        </tr>
                                                        <tr class="RadioText">
                                                            <td align="left" width="50%">
                                                                <span>Are there current housing issues for the child?</span>
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FamilyCurrentHousingIssues_Y"
                                                                    name="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FamilyCurrentHousingIssues" value="Y" />
                                                                <label for="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FamilyCurrentHousingIssues_Y">
                                                                    Yes</label>
                                                            </td>
                                                            <td width="8px">&nbsp;
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FamilyCurrentHousingIssues_N"
                                                                    name="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FamilyCurrentHousingIssues" value="N" />
                                                                <label for="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FamilyCurrentHousingIssues_N">
                                                                    No</label>
                                                            </td>
                                                            <td width="8px">&nbsp;
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FamilyCurrentHousingIssues_U"
                                                                    name="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FamilyCurrentHousingIssues" value="U" />
                                                                <label for="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FamilyCurrentHousingIssues_U">
                                                                    Unknown</label>
                                                            </td>
                                                            <td width="15px">&nbsp;
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="8" class="height1"></td>
                                                        </tr>
                                                        <tr class="RadioText">
                                                            <td align="left" width="50%">
                                                                <span>Are parents/guardians willing to participate in treatment?</span>
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FamilyParticipate_Y"
                                                                    name="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FamilyParticipate" value="Y" />
                                                                <label for="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FamilyParticipate_Y">
                                                                    Yes</label>
                                                            </td>
                                                            <td width="8px">&nbsp;
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FamilyParticipate_N"
                                                                    name="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FamilyParticipate" value="N" />
                                                                <label for="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FamilyParticipate_N">
                                                                    No</label>
                                                            </td>
                                                            <td width="8px">&nbsp;
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FamilyParticipate_U"
                                                                    name="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FamilyParticipate" value="U" />
                                                                <label for="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_FamilyParticipate_U">
                                                                    Unknown</label>
                                                            </td>
                                                            <td width="15px">&nbsp;
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="8" class="height1"></td>
                                                        </tr>
                                                        <tr class="RadioText">
                                                            <td align="left" width="50%">
                                                                <span>Has the child experienced abuse or neglect either as a victim or perpetrator
                                                                </span>
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_ChildAbuse_Y"
                                                                    name="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_ChildAbuse" value="Y" />
                                                                <label for="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_ChildAbuse_Y">
                                                                    Yes</label>
                                                            </td>
                                                            <td width="8px">&nbsp;
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_ChildAbuse_N"
                                                                    name="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_ChildAbuse" value="N" />
                                                                <label for="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_ChildAbuse_N">
                                                                    No</label>
                                                            </td>
                                                            <td width="8px">&nbsp;
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_ChildAbuse_U"
                                                                    name="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_ChildAbuse" value="U" />
                                                                <label for="RadioButton_CustomDocumentPsychiatricNoteChildAdolescents_ChildAbuse_U">
                                                                    Unknown</label>
                                                            </td>
                                                            <td width="15px">&nbsp;
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="8" class="height1"></td>
                                                        </tr>
                                                        <tr class="RadioText">
                                                            <td align="left" width="50%" colspan="8">
                                                                <span>or any previous physical or emotional trauma
                                                                </span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="8" class="height1"></td>
                                                        </tr>
                                                        <tr class="RadioText">
                                                            <td align="left" colspan="8">
                                                                <span>Please address all of the above items that have been identified as areas of concern
                                                                    or previous history and describe overall Family Dynamics.&nbsp;
                                                                </span>
                                                            </td>

                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="8" class="height1"></td>
                                            </tr>
                                            <tr>
                                                <td class="padding_label1" colspan="8">
                                                    <textarea class="form_textareaWithoutWidth" id="TextArea_CustomDocumentPsychiatricNoteChildAdolescents_FamilyDynamicsComment"
                                                        name="TextArea_CustomDocumentPsychiatricNoteChildAdolescents_FamilyDynamicsComment" rows="5" spellcheck="True"
                                                        cols="155"></textarea>
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
</div>
