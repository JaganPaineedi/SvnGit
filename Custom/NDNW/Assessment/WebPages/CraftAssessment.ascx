<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CraftAssessment.ascx.cs"
    Inherits="ActivityPages_Client_Detail_Kalamazoo_KalamazooAssessment_CraftAssessment" %>
<% if (HttpContext.Current == null)
   { %>
<link href="../../../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet"
    type="text/css" />
<%} %>
<div style="overflow-x: hidden">
    <table border="0" cellpadding="0" cellspacing="0" class="DocumentScreen">
        <tr>
            <td class="height2"></td>
        </tr>
        <tr>
            <td>
                <table border="0" cellpadding="0" cellspacing="0" width="99%">
                    <tr>
                        <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                <tr>
                                    <td class="content_tab_left" align="left" nowrap='nowrap'>Substance Use
                                    </td>
                                    <td width="17">
                                        <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif"
                                            width="17" height="26" alt="" />
                                    </td>
                                    <td class="content_tab_top" width="100%"></td>
                                    <td width="7">
                                        <img style="vertical-align: top" src="<%=RelativePath %>App_Themes/Includes/Images/content_tab_right.gif"
                                            width="7" height="26" alt="" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="content_tab_bg">
                            <table border="0" cellspacing="0" cellpadding="0" width="99%" style="padding-left:6px;padding-top:5px;">
                                <tr class="RadioText">
                                    <td>
                                        <span class="form_label" style="padding-right: 50px;">Use of Alcohol:</span>
                                    </td>
                                    <td class="RadioText">
                                        <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentAssessmentSubstanceUsess_UseOfAlcohol_N"
                                            name="RadioButton_CustomDocumentAssessmentSubstanceUses_UseOfAlcohol" value="N"
                                            onclick="" tabindex="2" />
                                        <label for="RadioButton_CustomDocumentAssessmentSubstanceUses_UseOfAlcohol">
                                            Never</label>
                                    </td>
                                    <td class="RadioText" colspan="2" style="padding-left:4px;">
                                        <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentAssessmentSubstanceUses_UseOfAlcohol_R"
                                            name="RadioButton_CustomDocumentAssessmentSubstanceUses_UseOfAlcohol" value="R"
                                            onclick="" tabindex="2" />
                                        <label for="RadioButton_CustomDocumentAssessmentSubstanceUses_UseOfAlcohol">
                                            Rarely</label>&nbsp;
                                        <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentAssessmentSubstanceUses_UseOfAlcohol_M"
                                            name="RadioButton_CustomDocumentAssessmentSubstanceUses_UseOfAlcohol" value="M"
                                            onclick="" tabindex="2" />
                                        <label for="RadioButton_CustomDocumentAssessmentSubstanceUses_UseOfAlcohol">
                                            Moderate</label>&nbsp;
                                        <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentAssessmentSubstanceUses_UseOfAlcohol_D"
                                            name="RadioButton_CustomDocumentAssessmentSubstanceUses_UseOfAlcohol" value="D"
                                            onclick="" tabindex="2" />
                                        <label for="RadioButton_CustomDocumentAssessmentSubstanceUses_UseOfAlcohol">
                                            Daily</label>
                                    </td>                                    
                                    <td style="padding-left: 7px;" class="checkbox_container">
                                        <input type="checkbox" id="CheckBox_CustomDocumentAssessmentSubstanceUses _AlcoholAddToNeedsList"
                                            name="CheckBox_CustomDocumentAssessmentSubstanceUses_AlcoholAddToNeedsList" />&nbsp;<label
                                                for="CheckBox_CustomDocumentAssessmentSubstanceUses_AlcoholAddToNeedsList">Add to
                                                    Needs List</label>
                                    </td>

                                </tr>
                                <tr>
                                    <td class="height1">&nbsp;
                                    </td>
                                </tr>
                                <tr class="RadioText">
                                    <td>
                                        <span class="form_label" style="padding-right: 6px;">Use of Tobacco/Nicotine </span>
                                    </td>
                                    <td>
                                        <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentAssessmentSubstanceUses_UseOfTobaccoNicotine_N"
                                            name="RadioButton_CustomDocumentAssessmentSubstanceUses_UseOfTobaccoNicotine"
                                            value="N" onclick="" tabindex="2" />
                                        <label for="RadioButton_CustomDocumentAssessmentSubstanceUses_UseOfTobaccoNicotine">
                                            Never</label>
                                    </td>
                                    <td style="padding-left:4px;">
                                        <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentAssessmentSubstanceUses_UseOfTobaccoNicotine_P"
                                            name="RadioButton_CustomDocumentAssessmentSubstanceUses_UseOfTobaccoNicotine"
                                            value="P" onclick="" tabindex="2" />
                                        <label for="RadioButton_CustomDocumentAssessmentSubstanceUses_UseOfTobaccoNicotine">
                                            Previously,but Quit:</label>
                                    </td>
                                    <td>
                                        <input type="text" id="TextBox_CustomDocumentAssessmentSubstanceUses_UseOfTobaccoNicotineQuit"
                                            name="TextBox_CustomDocumentAssessmentSubstanceUses_UseOfTobaccoNicotineQuit"
                                            datatype="Date" tabindex="2" class="date_text"/>
                                        <img id="img_CustomDocumentAssessmentSubstanceUses_UseOfTobaccoNicotineQuit" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                            style="padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px;" onclick="return showCalendar('TextBox_CustomDocumentAssessmentSubstanceUses_UseOfTobaccoNicotineQuit', '%m/%d/%Y');" align="center" />
                                        &nbsp;&nbsp;&nbsp;
                                        <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentAssessmentSubstanceUses_UseOfTobaccoNicotine_T"
                                            name="RadioButton_CustomDocumentAssessmentSubstanceUses_UseOfTobaccoNicotine"
                                            value="T" onclick="" tabindex="2" />&nbsp;&nbsp;
                                        <label for="TextBox_CustomDocumentAssessmentSubstanceUses_UseOfTobaccoNicotineTypeOfFrequency" style="padding-right: 10px;">
                                            Type/Frequency:</label>&nbsp;
                                        <input type="text" id="TextBox_CustomDocumentAssessmentSubstanceUses_UseOfTobaccoNicotineTypeOfFrequency"
                                            name="TextBox_CustomDocumentAssessmentSubstanceUses_UseOfTobaccoNicotineTypeOfFrequency"
                                            tabindex="2" maxlength="100" />
                                    </td>
                                    
                                    <td style="padding-left: 7px;" class="checkbox_container">
                                        <input type="checkbox" id="CheckBox_CustomDocumentAssessmentSubstanceUses_UseOfTobaccoNicotineAddToNeedsList" name="CheckBox_CustomDocumentAssessmentSubstanceUses_UseOfTobaccoNicotineAddToNeedsList"
                                            onclick="" />&nbsp;<label for="CheckBox_CustomDocumentAssessmentSubstanceUses_UseOfTobaccoNicotineAddToNeedsList">Add
                                                to Needs List</label>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height1">&nbsp;
                                    </td>
                                </tr>
                                <tr class="RadioText">
                                    <td>
                                        <span class="form_label" style="padding-right: 35px;">Use of illicit Drugs </span>
                                    </td>
                                    <td>
                                         <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentAssessmentSubstanceUses_UseOfIllicitDrugs_N"
                                            name="RadioButton_CustomDocumentAssessmentSubstanceUses_UseOfIllicitDrugs" value="N"
                                            onclick="" tabindex="2" />
                                        <label for="RadioButton_CustomDocumentAssessmentSubstanceUses_UseOfIllicitDrugs">
                                            Never</label>
                                    </td>
                                    <td style="padding-left:4px;">
                                        <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentAssessmentSubstanceUses_UseOfIllicitDrugs_Y"
                                            name="RadioButton_CustomDocumentAssessmentSubstanceUses_UseOfIllicitDrugs" value="Y"
                                            onclick="" tabindex="2" />
                                        <label for="RadioButton_CustomDocumentAssessmentSubstanceUses_UseOfIllicitDrugs" style="padding-right: 15px;">
                                            Type/Frequency:</label>
                                    </td>
                                    <td>
                                        <input type="text" id="TextBox_CustomDocumentAssessmentSubstanceUses_UseOfIllicitDrugsTypeFrequency"
                                            name="TextBox_CustomDocumentAssessmentSubstanceUses_UseOfIllicitDrugsTypeFrequency"
                                            tabindex="2" maxlength="100" />
                                    </td>
                                    
                                    <td style="padding-left: 7px;" class="checkbox_container">
                                        <input type="checkbox" id="CheckBox_CustomDocumentAssessmentSubstanceUses_UseOfIllicitDrugsAddToNeedsList"
                                            name="CheckBox_CustomDocumentAssessmentSubstanceUses_UseOfIllicitDrugsAddToNeedsList"
                                            onclick="" />
                                        <label for="CheckBox_CustomDocumentAssessmentSubstanceUses_UseOfIllicitDrugsAddToNeedsList">
                                            Add to Needs List</label>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height1">&nbsp;
                                    </td>
                                </tr>
                                <tr class="RadioText">
                                    <td>
                                        <span class="form_label" style="padding-right: 10px;">Prescription/OTC Drugs </span>
                                    </td>
                                    <td>
                                        <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentAssessmentSubstanceUses_PrescriptionOTCDrugs_N"
                                            name="RadioButton_CustomDocumentAssessmentSubstanceUses_PrescriptionOTCDrugs"
                                            value="N" onclick="" tabindex="2" />
                                        <label for="RadioButton_CustomDocumentAssessmentSubstanceUses_PrescriptionOTCDrugs">
                                            Never</label>
                                    </td>
                                    <td style="padding-left:4px;">
                                        <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentAssessmentSubstanceUses_PrescriptionOTCDrugs_Y"
                                            name="RadioButton_CustomDocumentAssessmentSubstanceUses_PrescriptionOTCDrugs"
                                            value="Y" onclick="" tabindex="2" />
                                        <label for="RadioButton_CustomDocumentAssessmentSubstanceUses_PrescriptionOTCDrugs" style="padding-right: 15px;">
                                            Type/Frequency:</label>
                                    </td>
                                    <td>
                                        <input type="text" id="TextBox_CustomDocumentAssessmentSubstanceUses_PrescriptionOTCDrugsTypeFrequency"
                                            name="TextBox_CustomDocumentAssessmentSubstanceUses_PrescriptionOTCDrugsTypeFrequency"
                                            tabindex="2" maxlength="100" />
                                    </td>                                    
                                    <td style="padding-left: 7px;" class="checkbox_container">
                                        <input type="checkbox" id="CheckBox_CustomDocumentAssessmentSubstanceUses_PrescriptionOTCDrugsAddtoNeedsList"
                                            name="CheckBox_CustomDocumentAssessmentSubstanceUses_PrescriptionOTCDrugsAddtoNeedsList"
                                            onclick="" />
                                        <label for="CheckBox_CustomDocumentAssessmentSubstanceUses_PrescriptionOTCDrugsAddtoNeedsList">
                                            Add to Needs List</label>
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
                                        <img style="vertical-align: top" src="<%=RelativePath %>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                                            height="7" alt="" />
                                    </td>
                                    <td class="right_bottom_cont_bottom_bg" width="100%"></td>
                                    <td width="2" class="right_bottom_cont_bottom_bg" align="right">
                                        <img style="vertical-align: top" src="<%=RelativePath %>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif"
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
                <table border="0" cellpadding="0" cellspacing="0" width="99%">
                    <tr>
                        <td class="height2"></td>
                    </tr>
                    <tr>
                        <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                <tr>
                                    <td class="content_tab_left" align="left" nowrap='nowrap'>CRAFFT
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
                            <table id="TableUncope" border="0" cellspacing="0" cellpadding="0" width="100%" group="Uncope">
                                <tr>
                                    <td class="height2"></td>
                                </tr>
                                <tr>
                                    <td class="padding_label1">
                                        <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                            <tr>
                                                <td style="width: 5%;" align="left" class="RadioText">
                                                    <input type="radio" id="RadioButton_CustomDocumentCRAFFTs_CrafftApplicable_Y" name="RadioButton_CustomDocumentCRAFFTs_CrafftApplicable"
                                                        value="Y" onclick="SetEnableDisableCrafft('Y');" />
                                                    <label style="padding-left: 2px;"
                                                        for="RadioButton_CustomDocumentCRAFFTs_CrafftApplicable_Y">
                                                        Yes</label>
                                                </td>
                                                <td style="width: 5%;" align="left" class="RadioText">
                                                    <input type="radio" id="RadioButton_CustomDocumentCRAFFTs_CrafftApplicable_N" name="RadioButton_CustomDocumentCRAFFTs_CrafftApplicable"
                                                        value="N" onclick="SetEnableDisableCrafft('N');" />
                                                    <label style="padding-left: 2px;"
                                                        for="RadioButton_CustomDocumentCRAFFTs_CrafftApplicable_N">
                                                        No</label>
                                                </td>
                                                <td style="width: 89%;" align="left">
                                                    <span class="form_label">Is CRAFFT applicable? (If no, specify reason below)</span>
                                                    <span id="Group_Uncope"></span>
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
                                        <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                            <tr>
                                                <td style="padding-left: 10px;">
                                                    <textarea class="form_textareaWithoutWidth" id="TextArea_CustomDocumentCRAFFTs_CrafftApplicableReason"
                                                        name="TextArea_CustomDocumentCRAFFTs_CrafftApplicableReason" spellcheck="True"
                                                        rows="5" cols="156" style="width: 770px"></textarea>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height9"></td>
                                            </tr>
                                            <tr>
                                                <td class="padding_label1">
                                                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                        <tr>
                                                            <td style="width: 6%;" class="RadioText" align="left">
                                                                <input type="radio" id="RadioButton_CustomDocumentCRAFFTs_CrafftQuestionC_Y" name="RadioButton_CustomDocumentCRAFFTs_CrafftQuestionC"
                                                                    value="Y" onclick="javascript: AddExtraTabCrafftEvent();" /><label style="padding-left: 4px;"
                                                                        for="RadioButton_CustomDocumentCRAFFTs_CrafftQuestionC_Y">Yes</label>
                                                            </td>
                                                            <td style="width: 5%;" class="RadioText" align="left">
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentCRAFFTs_CrafftQuestionC_N"
                                                                    name="RadioButton_CustomDocumentCRAFFTs_CrafftQuestionC" value="N" onclick="javascript: AddExtraTabCrafftEvent();" /><label
                                                                        style="padding-left: 4px;" for="RadioButton_CustomDocumentCRAFFTs_CrafftQuestionC_N">No</label>
                                                            </td>
                                                            <td style="width: 89%;">
                                                                <span class="form_label">Have you ever ridden in a CAR driven by someone 
                                                                (including yourself) who was &quot;high&quot; or bad been using alcohol or drugs?</span>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height1">&nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="padding_label1">
                                                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                        <tr>
                                                            <td style="width: 6%;" class="RadioText" align="left">
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentCRAFFTs_CrafftQuestionR_Y"
                                                                    name="RadioButton_CustomDocumentCRAFFTs_CrafftQuestionR" value="Y" onclick="javascript: AddExtraTabCrafftEvent();" /><label
                                                                        style="padding-left: 4px;" for="RadioButton_CustomDocumentCRAFFTs_CrafftQuestionR_Y">Yes</label>
                                                            </td>
                                                            <td style="width: 5%;" class="RadioText" align="left">
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentCRAFFTs_CrafftQuestionR_N"
                                                                    name="RadioButton_CustomDocumentCRAFFTs_CrafftQuestionR" value="N" onclick="javascript: AddExtraTabCrafftEvent();" /><label
                                                                        style="padding-left: 4px;" for="RadioButton_CustomDocumentCRAFFTs_CrafftQuestionR_N">No</label>
                                                            </td>
                                                            <td style="width: 89%;">
                                                                <span class="form_label">Do you ever use alcohol or drugs to RELAX, feel better 
                                                                about yourself, or fit in?</span>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height1">&nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="padding_label1">
                                                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                        <tr>
                                                            <td style="width: 6%;" class="RadioText" align="left">
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentCRAFFTs_CrafftQuestionA_Y"
                                                                    name="RadioButton_CustomDocumentCRAFFTs_CrafftQuestionA" value="Y" onclick="javascript: AddExtraTabCrafftEvent();" /><label
                                                                        style="padding-left: 4px;" for="RadioButton_CustomDocumentCRAFFTs_CrafftQuestionA_Y">Yes</label>
                                                            </td>
                                                            <td style="width: 5%;" class="RadioText" align="left">
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentCRAFFTs_CrafftQuestionA_N"
                                                                    name="RadioButton_CustomDocumentCRAFFTs_CrafftQuestionA" value="N" onclick="javascript: AddExtraTabCrafftEvent();" /><label
                                                                        style="padding-left: 4px;" for="RadioButton_CustomDocumentCRAFFTs_CrafftQuestionA_N">No</label>
                                                            </td>
                                                            <td style="width: 89%;">
                                                                <span class="form_label">Do you ever use alcohol/drugs while you are by 
                                                                yourself, ALONE?</span>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height1">&nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="padding_label1">
                                                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                        <tr>
                                                            <td style="width: 6%;" class="RadioText" align="left">
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentCRAFFTs_CrafftQuestionF_Y"
                                                                    name="RadioButton_CustomDocumentCRAFFTs_CrafftQuestionF" value="Y" onclick="javascript: AddExtraTabCrafftEvent();" /><label
                                                                        style="padding-left: 4px;" for="RadioButton_CustomDocumentCRAFFTs_CrafftQuestionF_Y">Yes</label>
                                                            </td>
                                                            <td style="width: 5%;" class="RadioText" align="left">
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentCRAFFTs_CrafftQuestionF_N"
                                                                    name="RadioButton_CustomDocumentCRAFFTs_CrafftQuestionF" value="N" onclick="javascript: AddExtraTabCrafftEvent();" /><label
                                                                        style="padding-left: 4px;" for="RadioButton_CustomDocumentCRAFFTs_CrafftQuestionF_N">No</label>
                                                            </td>
                                                            <td style="width: 89%;">
                                                                <span class="form_label">Do you ever FORGET things you did while using alcohol 
                                                                or drugs?</span>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height1">&nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="padding_label1">
                                                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                        <tr>
                                                            <td style="width: 6%;" class="RadioText" align="left">
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentCRAFFTs_CrafftQuestionFR_Y"
                                                                    name="RadioButton_CustomDocumentCRAFFTs_CrafftQuestionFR" value="Y" onclick="javascript: AddExtraTabCrafftEvent();" /><label
                                                                        style="padding-left: 4px;" for="RadioButton_CustomDocumentCRAFFTs_CrafftQuestionFR_Y">Yes</label>
                                                            </td>
                                                            <td style="width: 5%;" class="RadioText" align="left">
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentCRAFFTs_CrafftQuestionFR_N"
                                                                    name="RadioButton_CustomDocumentCRAFFTs_CrafftQuestionFR" value="N" onclick="javascript: AddExtraTabCrafftEvent();" /><label
                                                                        style="padding-left: 4px;" for="RadioButton_CustomDocumentCRAFFTs_CrafftQuestionFR_N">No</label>
                                                            </td>
                                                            <td style="width: 89%;">
                                                                <span class="form_label">Do your family or FRIENDS ever tell you that you should 
                                                                cut down on your drinking or drug use?</span>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height1">&nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="padding_label1">
                                                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                        <tr>
                                                            <td style="width: 6%;" class="RadioText" align="left">
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentCRAFFTs_CrafftQuestionT_Y"
                                                                    name="RadioButton_CustomDocumentCRAFFTs_CrafftQuestionT" value="Y" onclick="javascript: AddExtraTabCrafftEvent();" /><label
                                                                        style="padding-left: 4px;" for="RadioButton_CustomDocumentCRAFFTs_CrafftQuestionT_Y">Yes</label>
                                                            </td>
                                                            <td style="width: 5%;" class="RadioText" align="left">
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentCRAFFTs_CrafftQuestionT_N"
                                                                    name="RadioButton_CustomDocumentCRAFFTs_CrafftQuestionT" value="N" onclick="javascript: AddExtraTabCrafftEvent();" /><label
                                                                        style="padding-left: 4px;" for="RadioButton_CustomDocumentCRAFFTs_CrafftQuestionT_N">No</label>
                                                            </td>
                                                            <td style="width: 89%;">
                                                                <span class="form_label">Have you gotten into TROUBLE while you were using 
                                                                alcohol or drugs?</span>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height1">&nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="padding-left: 7px;" valign="top">
                                                    <span class="form_label">Stage of Change</span>&nbsp;
                                                    <asp:DropDownList ID="DropDownList_CustomDocumentCRAFFTs_CrafftStageOfChange" runat="server"
                                                        EnableViewState="false" CssClass="form_dropdown" Width="150px">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height3"></td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <%--<tr class="checkbox_container">
                                    <td style="padding-left: 7px;" class="checkbox_container">
                                        <table>
                                            <tr class="checkbox_container">
                                                <td class="checkbox_container">
                                                    <input type="checkbox" id="CheckBox_CustomDocumentCRAFFTs_CrafftCompleteFullSUAssessment"
                                                        name="CheckBox_CustomDocumentCRAFFTs_CrafftCompleteFullSUAssessment" onclick="javascript: AddExtraTabCrafftEvent();" /><label
                                                            for="CheckBox_CustomDocumentCRAFFTs_CrafftCompleteFullSUAssessment">Complete Full
                                                            SU Assessment</label>
                                                </td>
                                                <td style="padding-left: 20px;">
                                                    <span class="span_textunderline_cursor" id="SpanCompleteASAM" onclick="OpenAsamPopup()" style="color: #0000ff;">Complete ASAM</span>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>--%>
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
</div>
