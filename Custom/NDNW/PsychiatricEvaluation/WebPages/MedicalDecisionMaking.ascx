<%@ Control Language="C#" AutoEventWireup="true" CodeFile="MedicalDecisionMaking.ascx.cs" Inherits="SHS.SmartCare.Custom_PsychiatricEvaluation_WebPages_MedicalDecisionMaking" %>
<%@ Register Assembly="Streamline.DotNetDropDowns" Namespace="Streamline.DotNetDropDowns"
    TagPrefix="cc2" %>
<%@ Register Assembly="Streamline.DotNetDropDownGlobalCodes" Namespace="Streamline.DotNetDropDownGlobalCodes"
    TagPrefix="cc3" %>
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
                                    <td class="content_tab_left" nowrap='nowrap'>Medical Records
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
                                        <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricEvaluations_MedicalRecords"
                                            name="CheckBox_CustomDocumentPsychiatricEvaluations_MedicalRecords" style="cursor: default" />
                                    </td>
                                    <td align="left" style="width: 15%; padding-left: 2px">
                                        <label for="CheckBox_CustomDocumentPsychiatricEvaluations_MedicalRecords" style="cursor: default">
                                            Medical Records</label>
                                    </td>
                                    <td align="center" style="width: 2%">
                                        <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricEvaluations_DiagnosticTest"
                                            name="CheckBox_CustomDocumentPsychiatricEvaluations_DiagnosticTest" style="cursor: default" />
                                    </td>
                                    <td align="left" style="width: 15%; padding-left: 2px">
                                        <label for="CheckBox_CustomDocumentPsychiatricEvaluations_DiagnosticTest" style="cursor: default">
                                            Diagnostic Test</label>
                                    </td>
                                    <td align="center" style="width: 2%">
                                        <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricEvaluations_Labs"
                                            name="CheckBox_CustomDocumentPsychiatricEvaluations_Labs" style="cursor: default" onclick="showHideLabsSelected('ctrl', null);" />
                                    </td>
                                    <td align="left" style="width: 6%; padding-left: 2px">
                                        <label for="CheckBox_CustomDocumentPsychiatricEvaluations_Labs" style="cursor: default">
                                            Labs</label>
                                    </td>
                                    <td align="left" style="width: 58%">
                                        <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentPsychiatricEvaluations_LabsSelected" name="DropDownList_CustomDocumentPsychiatricEvaluations_LabsSelected" CssClass="form_dropdown"
                                            Style="width: 55%" runat="server">
                                        </cc2:StreamlineDropDowns>
                                    </td>
                                </tr>
                            </table>
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td class="height2"></td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 100%;">
                                        <span id="Span_MedicalRecordsComments">Comments</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height1" style="width: 100%;"></td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 100%;">
                                        <textarea class="form_textarea" id="TextArea_CustomDocumentPsychiatricEvaluations_MedicalRecordsComments"
                                            name="TextArea_CustomDocumentPsychiatricEvaluations_MedicalRecordsComments" rows="4" cols="1" style="width: 98%;"
                                            spellcheck="True" datatype="String"></textarea>
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
                                    <td class="content_tab_left" nowrap='nowrap'>Problem/Condition
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
                            <div id="ProblemsContainer" border="0" cellpadding="3" cellspacing="3" width="100%">
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
                                    <td class="content_tab_left" nowrap='nowrap'>SmartCare RX
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
                            <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                <tr>
                                    <td valign="top" style="width: 100%; padding-left: 0px">
                                        <table border="0" width="100%" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td colspan="2" class="form_label_text" align="left">The information displayed in the SmartCare Rx section is entered into the SmartCare
                                                    Rx module and current read only information as applicable on the date of service
                                                    is specified below.
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height1">&nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="left">
                                                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                        <tr>
                                                            <td style="width: 16%;">
                                                                <input type="button" id="Button_CustomDocumentPsychiatricEvaluations_OpenSmartCareRX" name="Button_CustomDocumentPsychiatricEvaluations_OpenSmartCareRX"
                                                                    class="more_detail_btn_120" value="Open  SmartCare RX" />&nbsp;
                                                            </td>
                                                            <td style="width: 30%;">
                                                                <table cellpadding="0" cellspacing="0">
                                                                    <tr>
                                                                        <td class="glow_lt" width="3px" align="right"></td>
                                                                        <td class="glow_mid">
                                                                            <input type="button" id="Button_CustomDocumentPsychiatricEvaluations_ViewMedicationHistoryReport"
                                                                                name="Button_CustomDocumentPsychiatricEvaluations_ViewMedicationHistoryReport" class="Button"
                                                                                value="View Medication History Report" />
                                                                        </td>
                                                                        <td class="glow_rt" width="3px" align="left"></td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td style="width: 54%; padding-left: 130px;" align="left" class="checkbox_container">
                                                                <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricEvaluations_OrderedMedications" name="CheckBox_CustomDocumentPsychiatricEvaluations_OrderedMedications" />
                                                                <label for="CheckBox_CustomDocumentPsychiatricEvaluations_OrderedMedications" id="Label1"
                                                                    name="SpanRisksBenefit">
                                                                    Ordered Medications</label>
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
                                                <td style="width: 60%; padding-left: 0px;" align="left" class="checkbox_container">
                                                    <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricEvaluations_RisksBenefits" name="CheckBox_CustomDocumentPsychiatricEvaluations_RisksBenefits" />
                                                    <label for="CheckBox_CustomDocumentPsychiatricEvaluations_RisksBenefits" id="SpanRisksBenefit"
                                                        name="SpanRisksBenefit">
                                                        Risks/benefits have been discussed with the patient and understood</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="width: 60%; padding-left: 0px;" align="left" class="checkbox_container">
                                                    <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricEvaluations_NewlyEmergentSideEffects"
                                                        name="CheckBox_CustomDocumentPsychiatricEvaluations_NewlyEmergentSideEffects" />
                                                    <label for="CheckBox_CustomDocumentPsychiatricEvaluations_NewlyEmergentSideEffects" id="SpanEmergentSideEffect"
                                                        name="SpanEmergentSideEffect">
                                                        Any newly emergent side effects have been discussed with the patient</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height1">&nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="left" style="width: 100%;">
                                                    <span class="form_label_text" id="SpanCurrentMedications" name="SpanCurrentMedications">Current Medications</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td valign="top" align="left" style="width: 100%; padding-top: 2px;">
                                                    <div id="divCurrentMedications" style="border: solid 1px #b1b1b1; background-color: #f5f5f5; overflow-y: scroll; height: 100px; width: 803px">
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height1">&nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="left" style="width: 100%;">
                                                    <span class="form_label_text" id="SpanSelfReported" name="SpanSelfReported">Self Reported</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td valign="top" align="left" style="width: 100%; padding-top: 2px;">
                                                    <div id="divSelfReported" style="border: solid 1px #b1b1b1; background-color: #f5f5f5; overflow-y: scroll; height: 100px; width: 803px">
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height1">&nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="left" style="width: 100%;">
                                                    <span class="form_label_text" id="SpanMedicationsDiscontinued" name="SpanMedicationsDiscontinued">Medications Discontinued In This Session</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td valign="top" align="left" style="width: 100%; padding-top: 2px;">
                                                    <div id="divMedicationsDiscontinued" style="border: solid 1px #b1b1b1; background-color: #f5f5f5; overflow-y: scroll; height: 100px; width: 803px">
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
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="content_tab_left" nowrap='nowrap'>Orders
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
                                    <td align="left" style="width: 50%">
                                        <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                            <tr>
                                                <td align="left" style="width: 100%">
                                                    <span id="Span_OrderedLabsRadiologyTestsConsultations">Ordered Labs/Radiology/Tests/Consultations</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2"></td>
                                            </tr>
                                            <tr>
                                                <td align="left" style="width: 100%">
                                                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                        <tr>
                                                            <td align="center" style="width: 4%">
                                                                <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricEvaluations_LabOrder"
                                                                    name="CheckBox_CustomDocumentPsychiatricEvaluations_LabOrder" style="cursor: default" />
                                                            </td>
                                                            <td align="left" style="width: 15%; padding-left: 2px">
                                                                <label for="CheckBox_CustomDocumentPsychiatricEvaluations_LabOrder" style="cursor: default">
                                                                    Labs</label>
                                                            </td>
                                                            <td align="center" style="width: 4%">
                                                                <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricEvaluations_RadiologyOrder"
                                                                    name="CheckBox_CustomDocumentPsychiatricEvaluations_RadiologyOrder" style="cursor: default" />
                                                            </td>
                                                            <td align="left" style="width: 20%; padding-left: 2px">
                                                                <label for="CheckBox_CustomDocumentPsychiatricEvaluations_RadiologyOrder" style="cursor: default">
                                                                    Radiology</label>
                                                            </td>
                                                            <td align="center" style="width: 4%">
                                                                <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricEvaluations_Consultations"
                                                                    name="CheckBox_CustomDocumentPsychiatricEvaluations_Consultations" style="cursor: default" />
                                                            </td>
                                                            <td align="left" style="width: 53%; padding-left: 2px">
                                                                <label for="CheckBox_CustomDocumentPsychiatricEvaluations_Consultations" style="cursor: default">
                                                                    Consultations</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td align="right" valign="middle" style="width: 50%; padding-right: 15px">
                                        <table cellspacing="0" cellpadding="0" border="0" style="padding-left: 0px; text-align: right;">
                                            <tr>
                                                <td class="glow_lt">&nbsp;
                                                </td>
                                                <td class="glow_mid">
                                                    <input type="button" id="Button_CustomDocumentPsychiatricEvaluations_PlaceOrder" name="Button_CustomDocumentPsychiatricEvaluations_PlaceOrder"
                                                        value="Place Order" />
                                                </td>
                                                <td class="glow_rt">&nbsp;
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td class="height2"></td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 100%;">
                                        <textarea class="form_textarea" id="TextArea_CustomDocumentPsychiatricEvaluations_OrdersComments"
                                            name="TextArea_CustomDocumentPsychiatricEvaluations_OrdersComments" rows="4" cols="1" style="width: 98%;"
                                            spellcheck="True" datatype="String"></textarea>
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
    <cc3:DropDownGlobalCodes ID="DropDownListCommon_CustomDocumentPsychiatricEvaluations_ProblemStatus"
        name="DropDownListCommon_CustomDocumentPsychiatricEvaluations_ProblemStatus" runat="server"
        CssClass="form_dropdown" Width="250px" Category="XPSYCHEVALSTATUS" AddBlankRow="true"
        BlankRowText="" bindsetformdata="False" bindautosaveevents="False" Style="display: none">
    </cc3:DropDownGlobalCodes>
</div>
