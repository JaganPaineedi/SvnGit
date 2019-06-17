<%@ Control Language="C#" AutoEventWireup="true" CodeFile="PsychiatricServiceMDM.ascx.cs" Inherits="Custom_PsychiatricService_WebPages_PsychiatricServiceMDM" %>
<%@ Register Assembly="Streamline.DotNetDropDownGlobalCodes" Namespace="Streamline.DotNetDropDownGlobalCodes"
    TagPrefix="cc2" %>
<% if (HttpContext.Current == null)
   { %>
<link href="<%= RelativePath%>App_Themes/Styles/smartcare_styles.css" rel="stylesheet"
    type="text/css" />
<%} %>
    <script src="<%=RelativePath%>JScripts/ApplicationScripts/jquery.tmpl.min.js" type="text/javascript"></script>
<script type="text/javascript" src="<%=RelativePath%>JScripts/ApplicationScripts/GeneralArrayHelpers.js"></script>

<script type="text/javascript" src="<%=RelativePath%>JScripts/ApplicationScripts/GeneralFormFunctions.js"></script>
<div id="divPsychNoteTab" style="width: 820px;">
    <table width="820px" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td class="height2">
            </td>
        </tr>
          <tr>
            <td valign="top" align="left" width="100%" colspan="2">
                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                    <tr>
                        <td align="left" width="100%" colspan="2">
                            <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                <tr>
                                    <td class="height1">
                                    </td>
                                </tr>
                                <tr>
                                    <td class="content_tab_left" align="left" nowrap='nowrap'>
                                        Medical Records Reviewed
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
                        <td class="content_tab_bg" style="padding-left: 10px">
                            <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                <tr>
                                    <td align="center" style="width: 2%">
                                        <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricServiceNoteMDMs_MedicalRecords"
                                            name="CheckBox_CustomDocumentPsychiatricServiceNoteMDMs_MedicalRecords" style="cursor: default" />
                                    </td>
                                    <td align="left" style="width: 18%; padding-left: 2px">
                                        <label for="CheckBox_CustomDocumentPsychiatricServiceNoteMDMs_MedicalRecords" style="cursor: default">
                                            Medical Records Reviewed</label>
                                    </td>
                                    <td align="center" style="width: 2%">
                                        <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricServiceNoteMDMs_DiagnosticTest"
                                            name="CheckBox_CustomDocumentPsychiatricServiceNoteMDMs_DiagnosticTest" style="cursor: default" />
                                    </td>
                                    <td align="left" style="width: 18%; padding-left: 2px">
                                        <label for="CheckBox_CustomDocumentPsychiatricServiceNoteMDMs_DiagnosticTest" style="cursor: default">
                                            Diagnostic Test Reviewed</label>
                                    </td>
                                    <td align="center" style="width: 2%">
                                        <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricServiceNoteMDMs_Labs"
                                            name="CheckBox_CustomDocumentPsychiatricServiceNoteMDMs_Labs" style="cursor: default" />
                                    </td>
                                    <td align="left" style="width: 18%; padding-left: 2px">
                                        <label for="CheckBox_CustomDocumentPsychiatricServiceNoteMDMs_Labs" style="cursor: default">
                                            Labs Reviewed</label>
                                    </td>
                                    <td align="left" style="width: 40%; padding-right:5px;">
                                         <asp:DropDownList ID="DropDownList_CustomDocumentPsychiatricServiceNoteMDMs_LabsSelected" tabindex="2"
                                        name="DropDownList_CustomDocumentPsychiatricServiceNoteMDMs_LabsSelected" EnableViewState="false"
                                        runat="server" CssClass="form_dropdown">
                                    </asp:DropDownList>
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
                                        <textarea class="form_textarea" id="TextArea_CustomDocumentPsychiatricServiceNoteMDMs_MedicalRecordsComments"
                                            name="TextArea_CustomDocumentPsychiatricServiceNoteMDMs_MedicalRecordsComments" rows="4" cols="1" style="width: 98%;"
                                            spellcheck="True" datatype="String"></textarea>
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
            <td valign="top" class="height2">
                &nbsp;
            </td>
        </tr>
          <tr>
            <td valign="top" align="left" width="100%" colspan="2">
                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                    <tr>
                        <td align="left" width="100%" colspan="2">
                            <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                <tr>
                                    <td class="height1">
                                    </td>
                                </tr>
                                <tr>
                                    <td class="content_tab_left" align="left" nowrap='nowrap'>
                                        Problem/Condition
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
                        <td valign="top" class="content_tab_bg_padding" align="left" width="100%">
                           <div id="ProblemsContainer" border="0" cellpadding="3" cellspacing="3" width="100%">
                           </div>
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
            <td valign="top" class="height2">
                &nbsp;
            </td>
        </tr>
          <tr>
            <td valign="top" align="left">
                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                    <tr>
                        <td>
                            <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                <tr>
                                    <td class="content_tab_left" align="left" nowrap='nowrap'>
                                        SmartCare RX
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
                        <td valign="top" class="content_tab_bg_padding" align="left">
                            <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                <tr>
                                    <td valign="top" style="width: 100%; padding-left: 0px">
                                        <table border="0" width="100%" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td colspan="2" class="form_label_text" align="left">
                                                    The information displayed in the SmartCare Rx section is entered into the SmartCare
                                                    Rx module and current read only information as applicable on the date of service
                                                    is specified below.
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height1">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="left">
                                                    <table cellpadding="0" cellspacing="0" width= "80%">
                                                        <tr>
                                                            <td>
                                                                <input type="button" id="Button_CustomDocumentPsychiatricServiceNoteMDMs_OpenSmartCareRX" name="Button_CustomDocumentPsychiatricServiceNoteMDMs_OpenSmartCareRX"
                                                                    class="more_detail_btn_120" value="Open  SmartCare RX" />&nbsp;
                                                            </td>
                                                            <td style="padding-left: 5px;">
                                                                <table cellpadding="0" cellspacing="0">
                                                                    <tr>
                                                                        <td class="glow_lt" width="3px" align="right">
                                                                        </td>
                                                                        <td class="glow_mid">
                                                                            <input type="button" id="Button_CustomDocumentPsychiatricServiceNoteMDMs_ViewMedicationHistoryReport"
                                                                                name="Button_CustomDocumentPsychiatricServiceNoteMDMs_ViewMedicationHistoryReport" class="Button"
                                                                                value="View Medication History Report" />
                                                                        </td>
                                                                        <td class="glow_rt" width="3px" align="left">
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                             <td style="padding-left: 70px;" align="right" class="checkbox_container">
                                                    <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricServiceNoteMDMs_OrderedMedications" name="CheckBox_CustomDocumentPsychiatricServiceNoteMDMs_OrderedMedications" />
                                                    <label for="CheckBox_CustomDocumentPsychiatricServiceNoteMDMs_OrderedMedications" id="Label1"
                                                        name="SpanRisksBenefit">
                                                        Ordered Medications</label>
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
                                                <td style="width: 60%; padding-left: 0px;" align="left" class="checkbox_container">
                                                    <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricServiceNoteMDMs_RisksBenefits" name="CheckBox_CustomDocumentPsychiatricServiceNoteMDMs_RisksBenefits" />
                                                    <label for="CheckBox_CustomDocumentPsychiatricServiceNoteMDMs_RisksBenefits" id="SpanRisksBenefit"
                                                        name="SpanRisksBenefit">
                                                        Risks/benefits have been discussed with the patient and understood</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="width: 60%; padding-left: 0px;" align="left" class="checkbox_container">
                                                    <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricServiceNoteMDMs_NewlyEmergentSideEffects"
                                                        name="CheckBox_CustomDocumentPsychiatricServiceNoteMDMs_NewlyEmergentSideEffects" />
                                                    <label for="CheckBox_CustomDocumentPsychiatricServiceNoteMDMs_NewlyEmergentSideEffects" id="SpanEmergentSideEffect"
                                                        name="SpanEmergentSideEffect">
                                                        Any newly emergent side effects have been discussed with the patient</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height1">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="left" style="width: 100%;">
                                                    <span class="form_label_text" id="SpanCurrentMedications" name="SpanCurrentMedications">
                                                        Current Medications</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td valign="top" align="left" style="width: 100%;padding-top:2px;">
                                                    <div id="divCurrentMedications" style="border: solid 1px #b1b1b1; background-color: #f5f5f5;
                                                        overflow-y: scroll; height: 100px; width: 797px">
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height1">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="left" style="width: 100%;">
                                                    <span class="form_label_text" id="SpanSelfReported" name="SpanSelfReported">Self Reported</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td valign="top" align="left" style="width: 100%;padding-top:2px;">
                                                    <div id="divSelfReported" style="border: solid 1px #b1b1b1; background-color: #f5f5f5;
                                                        overflow-y: scroll; height: 100px; width: 797px">
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height1">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="left" style="width: 100%;">
                                                    <span class="form_label_text" id="SpanMedicationsDiscontinued" name="SpanMedicationsDiscontinued">
                                                        Medications Discontinued In This Session</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td valign="top" align="left" style="width: 100%;padding-top:2px;">
                                                    <div id="divMedicationsDiscontinued" style="border: solid 1px #b1b1b1; background-color: #f5f5f5;
                                                        overflow-y: scroll; height: 100px; width: 797px">
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
                            <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                <tr>
                                    <td class="right_bottom_cont_bottom_bg" width="2">
                                        <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_left.gif" />
                                    </td>
                                    <td class="right_bottom_cont_bottom_bg" width="100%">
                                    </td>
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
            <td valign="top" class="height2">
                &nbsp;
            </td>
        </tr>
          <tr>
            <td valign="top" align="left" width="100%" colspan="2">
                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                    <tr>
                        <td align="left" width="100%" colspan="2">
                            <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                <tr>
                                    <td class="height1">
                                    </td>
                                </tr>
                                <tr>
                                    <td class="content_tab_left" align="left" nowrap='nowrap'>
                                        Orders
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
                        <td valign="top" class="content_tab_bg_padding" align="left" width="100%">
                            <table cellspacing="0" cellpadding="0" border="0" width="100%">
                            <tr>
                                    <td colspan = "4" class="height1">
                                        &nbsp;
                                    </td>
                                </tr>
                                 <tr>
                                    <td class="form_label_text" colspan = "4" align="left" valign="top">
                                        Ordered Labs/Radiology/Tests/Consultations
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height1">
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                   <td style="width: 15%; padding-left: 0px;" align="left" class="checkbox_container">
                                    <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricServiceNoteMDMs_LabOrder" name="CheckBox_CustomDocumentPsychiatricServiceNoteMDMs_LabOrder" />
                                    <label for="CheckBox_CustomDocumentPsychiatricServiceNoteMDMs_LabOrder" id="LabelCustomDocumentPsychiatricServiceNoteMDMs_LabOrder"
                                        name="LabelCustomDocumentPsychiatricServiceNoteMDMs_LabOrder">
                                        Labs</label>
                                </td>
                                 <td style="width: 15%; padding-left: 0px;" align="left" class="checkbox_container">
                                    <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricServiceNoteMDMs_RadiologyOrder" name="CheckBox_CustomDocumentPsychiatricServiceNoteMDMs_RadiologyOrder" />
                                    <label for="CheckBox_CustomDocumentPsychiatricServiceNoteMDMs_RadiologyOrder" id="LabelCustomDocumentPsychiatricServiceNoteMDMs_RadiologyOrder"
                                        name="LabelCustomDocumentPsychiatricServiceNoteMDMs_RadiologyOrder">
                                        Radiology</label>
                                </td>
                                 <td style="width: 40%; padding-left: 0px;" align="left" class="checkbox_container">
                                    <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricServiceNoteMDMs_Consultations" name="CheckBox_CustomDocumentPsychiatricServiceNoteMDMs_Consultations" />
                                    <label for="CheckBox_CustomDocumentPsychiatricServiceNoteMDMs_Consultations" id="LabelCustomDocumentPsychiatricServiceNoteMDMs_Consultations"
                                        name="LabelCustomDocumentPsychiatricServiceNoteMDMs_Consultations">
                                        Consultations</label>
                                </td>
                                  <td style="width: 30%; padding-left: 0px;" align="right">
                                    <input type="button" id="Button_CustomDocumentPsychiatricServiceNoteMDMs_PlaceOrder" name="Button_CustomDocumentPsychiatricServiceNoteMDMs_PlaceOrder"
                                        class="more_detail_btn_120" value="Place Orders" />&nbsp;
                                </td>
                                </tr>
                                <tr>
                                    <td colspan = "4" class="height1">
                                        &nbsp;
                                    </td>
                                </tr>
                                 <tr>
                                    <td colspan = "4" align="left" width="100%" style="padding-top:0px;">
                                        <textarea id="TextArea_CustomDocumentPsychiatricServiceNoteMDMs_OrdersComments" class="form_textareaWithoutWidth"
                                            name="TextArea_CustomDocumentPsychiatricServiceNoteMDMs_OrdersComments" rows="5" cols="159" spellcheck="True"></textarea>
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
            <td valign="top" class="height2">
                &nbsp;
            </td>
        </tr>
         <tr>
        <td style="visibility:hidden">
            <cc2:DropDownGlobalCodes ID="DropDownListCommon_CustomDocumentPsychiatricServiceNoteMDMs_ProblemStatus"
                name="DropDownListCommon_CustomDocumentPsychiatricServiceNoteMDMs_ProblemStatus" runat="server"
                CssClass="form_dropdown" Width="250px" Category="XPROBLEMSTATUS" AddBlankRow="true"
                BlankRowText="">
            </cc2:DropDownGlobalCodes>
        </td>
    </tr>
        
    </table> 
</div> 


        