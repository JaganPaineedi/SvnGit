<%@ Control Language="C#" AutoEventWireup="true" CodeFile="HRMPsychosocialAdult.ascx.cs"
    Inherits="SHS.SmartCare.ActivityPages_Client_Detail_Assessment_HRMPsychosocialAdult" %>
<%-- <%@ Register Src="~/ActivityPages/Client/Detail/Assessment/HRMAssessmentMedicationArea.ascx" TagName="MedicationArea" TagPrefix="uc"  %>--%>
<%--<%@ Register Src="~/Custom/Assessment/WebPages/HRMAssessmentMedicationArea.ascx" TagName="MedicationArea" TagPrefix="uc" %>--%>
<%@ Register Assembly="Streamline.DotNetDropDownGlobalCodes" Namespace="Streamline.DotNetDropDownGlobalCodes"
    TagPrefix="cc1" %>
<%@ Register Assembly="Streamline.DotNetDropDowns" Namespace="Streamline.DotNetDropDowns"
    TagPrefix="cc2" %>
<%@ Register Src="~/CommonUserControls/CustomGrid.ascx" TagName="CustomGrid" TagPrefix="uc1" %>
<% if (HttpContext.Current == null)
   { %>
<link href="../../../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet"
    type="text/css" />
<%} %>
<div style="overflow-x: hidden">
    <table border="0" cellpadding="0" cellspacing="0" class="DocumentScreen">
        <tr>
            <td>
                <table border="0" cellpadding="0" cellspacing="0" style="width: 99%">
                    <tr>
                        <td>
                            <%----%>
                            <table id="TableCurrentHealthIssue" border="0" cellpadding="0" cellspacing="0" style="width: 99%"
                                group="CurrentHealthIssue">
                                <tr>
                                    <td align="right">
                                        <span class="span_textunderline_cursor" id="SpanAccessQQ" style="color: #0000ff;">Access
                                            OQ Clinician Report</span>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp <span class="span_textunderline_cursor"
                                                id="Span3" style="color: #0000ff;">Access OQ History</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" style="width: 100%">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                    Health <span id="Group_CurrentHealthIssue"></span>
                                                </td>
                                                <td style="width: 17">
                                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif"
                                                        style="width: 17" height="26" alt="" />
                                                </td>
                                                <td class="content_tab_top" style="width: 100%">
                                                </td>
                                                <td style="width: 7">
                                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_right.gif"
                                                        style="width: 7" height="26" alt="" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="content_tab_bg">
                                        <table border="0" cellspacing="0" cellpadding="0" style="width: 100%">
                                            <tr>
                                                <td class="padding_label1">
                                                    <table cellpadding="0" cellspacing="0" border="0">
                                                        <tr>
                                                            <td>
                                                                Current or Past Health Issues (List known current or past medical conditions. Include
                                                                the dates and providers of past and current treatment. List interventions and responses.)
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr class="RadioText">
                                                            <td>
                                                                <table cellpadding="0" cellspacing="0" border="0">
                                                                    <tr>
                                                                        <td>
                                                                            <input class="cursor_default" type="radio" id="RadioButton_CustomHRMAssessments_PsCurrentHealthIssues_Y"
                                                                                name="RadioButton_CustomHRMAssessments_PsCurrentHealthIssues" value="Y" />
                                                                            <label for="RadioButton_CustomHRMAssessments_PsCurrentHealthIssues_Y">
                                                                                Yes</label>
                                                                        </td>
                                                                        <td style="width: 8px">
                                                                            &nbsp;
                                                                        </td>
                                                                        <td>
                                                                            <input class="cursor_default" type="radio" id="RadioButton_CustomHRMAssessments_PsCurrentHealthIssues_N"
                                                                                name="RadioButton_CustomHRMAssessments_PsCurrentHealthIssues" value="N" />
                                                                            <label for="RadioButton_CustomHRMAssessments_PsCurrentHealthIssues_N">
                                                                                No Concerns</label>
                                                                        </td>
                                                                        <td style="width: 8px">
                                                                            &nbsp;
                                                                        </td>
                                                                        <td>
                                                                            <input class="cursor_default" type="radio" id="RadioButton_CustomHRMAssessments_PsCurrentHealthIssues_U"
                                                                                name="RadioButton_CustomHRMAssessments_PsCurrentHealthIssues" value="U" />
                                                                            <label for="RadioButton_CustomHRMAssessments_PsCurrentHealthIssues_U">
                                                                                Unknown</label>
                                                                        </td>
                                                                        <td style="width: 15px">
                                                                            &nbsp;
                                                                        </td>
                                                                        <td id="HealthNeedList" notgroup="CurrentHealthIssue">
                                                                            <input class="cursor_default" type="checkbox" id="Checkbox_CustomHRMAssessments_PsCurrentHealthIssuesNeedsList"
                                                                                name="Checkbox_CustomHRMAssessments_PsCurrentHealthIssuesNeedsList" />
                                                                            <label for="Checkbox_CustomHRMAssessments_PsCurrentHealthIssuesNeedsList">
                                                                                Add Health Issues to Needs List</label>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="7" class="height2">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="padding_label1">
                                                    Comments
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="7" class="height2">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="padding_label1">
                                                    <textarea class="form_textareaWithoutWidth" id="TextArea_CustomHRMAssessments_PsCurrentHealthIssuesComment"
                                                        name="TextArea_CustomHRMAssessments_PsCurrentHealthIssuesComment" rows="5" spellcheck="True"
                                                        cols="155" onblur="UpdateNeedsXML(75,'CurrentHealthIssues');"></textarea>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="7" class="height1">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" style="width: 100%">
                                            <tr>
                                                <td style="width: 2" class="right_bottom_cont_bottom_bg">
                                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                                                        height="7" alt="" />
                                                </td>
                                                <td class="right_bottom_cont_bottom_bg" style="width: 100%">
                                                </td>
                                                <td style="width: 2" class="right_bottom_cont_bottom_bg" align="right">
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
                            <table id="TableMedication" border="0" cellpadding="0" cellspacing="0" width="99%"
                                notgroup="Health">
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                    <span>Medications</span>
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
                                    <td class="content_tab_bg" style="padding-left: 6px;">
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td>
                                                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                        <tr>
                                                            <td class="RadioText" style="width: 16%" nowrap="nowrap">
                                                                <input type="radio" id="RadioButton_CustomHRMAssessments_PsMedications_I" name="RadioButton_CustomHRMAssessments_PsMedications"
                                                                    value="I" onclick="IntializeMedication('#RadioButton_CustomHRMAssessments_PsMedications_I', '#TextArea_CustomHRMAssessments_PsMedicationsComment', '#DivMedications', 'CustomHRMAssessments', 'PsMedicationsListToBeModified');" />
                                                                <label for="RadioButton_CustomHRMAssessments_PsMedications_I">
                                                                    Initialize Medications</label>
                                                            </td>
                                                            <td width="8px">
                                                                &nbsp;
                                                            </td>
                                                            <td style="width: 12%" class="RadioText">
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomHRMAssessments_PsMedications_L"
                                                                    name="RadioButton_CustomHRMAssessments_PsMedications" value="L" onclick="DisappearMedication('#TextArea_CustomHRMAssessments_PsMedicationsComment', '#DivMedications');" />
                                                                <label for="RadioButton_CustomHRMAssessments_PsMedications_L">
                                                                    List Medications</label>
                                                            </td>
                                                            <td width="8px">
                                                                &nbsp;
                                                            </td>
                                                            <td style="width: 12%" class="RadioText">
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomHRMAssessments_PsMedications_N"
                                                                    name="RadioButton_CustomHRMAssessments_PsMedications" value="N" onclick="DisableMedication('#TextArea_CustomHRMAssessments_PsMedicationsComment', '#DivMedications');" />
                                                                <label for="RadioButton_CustomHRMAssessments_PsMedications_N">
                                                                    No Medications</label>
                                                            </td>
                                                            <td width="8px">
                                                                &nbsp;
                                                            </td>
                                                            <td style="width: 10%" class="RadioText">
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomHRMAssessments_PsMedications_U"
                                                                    name="RadioButton_CustomHRMAssessments_PsMedications" value="U" onclick="DisableMedication('#TextArea_CustomHRMAssessments_PsMedicationsComment', '#DivMedications');" />
                                                                <label for="RadioButton_CustomHRMAssessments_PsMedications_U">
                                                                    Unknown</label>
                                                            </td>
                                                            <td width="8px">
                                                                &nbsp;
                                                            </td>
                                                            <td class="checkbox_container">
                                                                <input class="cursor_default" type="checkbox" id="Checkbox_CustomHRMAssessments_PsMedicationsNeedsList"
                                                                    name="Checkbox_CustomHRMAssessments_PsMedicationsNeedsList" />
                                                                <label for="Checkbox_CustomHRMAssessments_PsMedicationsNeedsList">
                                                                    Add Medications to Needs List
                                                                </label>
                                                                <span id="Group_Medications"></span>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="7" class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="7">
                                                    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                                        <tr id="listMedication">
                                                            <td>
                                                                <table id="TableChildControl_CustomHRMAssessmentMedications" border="0" cellpadding="0"
                                                                    cellspacing="0" style="width: 100%" parentchildcontrols="True">
                                                                    <tr>
                                                                        <td align="left">
                                                                            <table width="100%" border="0" cellpadding="0" cellspacing="0" style="width: 100%;
                                                                                padding-right: 8px">
                                                                                <tr>
                                                                                    <td style="padding-left: 5px" align="left" width="7%">
                                                                                        <span class="form_label" id="Span9">Name</span>
                                                                                    </td>
                                                                                    <td width="14%">
                                                                                        <input type="text" name="TextBox_CustomHRMAssessmentMedications_Name" parentchildcontrols="True"
                                                                                            id="TextBox_CustomHRMAssessmentMedications_Name" required="required" class="form_textbox"
                                                                                            tabindex="20" maxlength="11" style="width: 100px" />
                                                                                    </td>
                                                                                    <td align="left" width="14%">
                                                                                        <span class="form_label" id="Span1">Dosage/Freequency</span>
                                                                                    </td>
                                                                                    <td width="10%">
                                                                                        <input type="text" name="TextBox_CustomHRMAssessmentMedications_Dosage" parentchildcontrols="True"
                                                                                            id="TextBox_CustomHRMAssessmentMedications_Dosage" class="form_textbox" tabindex="20"
                                                                                            maxlength="11" style="width: 100px" />
                                                                                    </td>
                                                                                    <td align="left" width="10%" style="padding-left: 10px">
                                                                                        <span class="form_label" id="Span2">Purpose</span>
                                                                                    </td>
                                                                                    <td width="8%">
                                                                                        <input type="text" name="TextBox_CustomHRMAssessmentMedications_Purpose" parentchildcontrols="True"
                                                                                            id="TextBox_CustomHRMAssessmentMedications_Purpose" class="form_textbox" tabindex="20"
                                                                                            maxlength="11" style="width: 100px" />
                                                                                    </td>
                                                                                    <td align="left" width="15%" style="padding-left: 5px">
                                                                                        <span class="form_label" id="Span11">Prescribing Physician</span>
                                                                                    </td>
                                                                                    <td width="16%">
                                                                                        <input type="text" parentchildcontrols="True" name="TextBox_CustomHRMAssessmentMedications_PrescribingPhysician"
                                                                                            class="form_textbox" tabindex="22" id="TextBox_CustomHRMAssessmentMedications_PrescribingPhysician"
                                                                                            datatype="text" style="width: 95%" value="" />
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height2">
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td align="right">
                                                                            <table width="100%" border="0" cellpadding="0" cellspacing="0" style="padding-right: 8px">
                                                                                <tr>
                                                                                    <td>
                                                                                        <input class="parentchildbutton" type="button" id="TableChildControl_CustomHRMAssessmentMedications_ButtonInsert"
                                                                                            tabindex="23" name="TableChildControl_CustomHRMAssessmentMedications_ButtonInsert"
                                                                                            baseurl="<%=ResolveUrl("~") %>" value="Insert" onclick="InsertGridData('TableChildControl_CustomHRMAssessmentMedications', 'InsertGrid', 'CustomGrid', this);" />
                                                                                        &nbsp&nbsp
                                                                                        <input class="parentchildbutton" type="button" id="ButtonClear" name="ButtonClear"
                                                                                            tabindex="24" value="Clear" onclick=" ClearTable('TableChildControl_CustomHRMAssessmentMedications');" />
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height2">
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                                <tr>
                                                                                    <td>
                                                                                        <div id="InsertGrid" runat="server" style="width: 98%; height: 90px; overflow-x: hidden;
                                                                                            overflow-y: auto; padding-left: 8px; padding-right: 2px">
                                                                                            <uc1:CustomGrid ID="CustomGrid" width="100%" height="90px" runat="server" TableName="CustomHRMAssessmentMedications"
                                                                                                PrimaryKey="HRMAssessmentMedicationId" CustomGridTableName="TableChildControl_CustomHRMAssessmentMedications"
                                                                                                ColumnHeader="Name:Dosage/Frequency:Purpose:PrescribingPhysician" ColumnName="Name:Dosage:Purpose:PrescribingPhysician"
                                                                                                ColumnWidth="25%:25%:25%:25%" DivGridName="InsertGrid" InsertButtonId="TableChildControl_CustomHRMAssessmentMedications_ButtonInsert" />
                                                                                        </div>
                                                                                        <input type="hidden" id="HiddenField_CustomHRMAssessmentMedications_HRMAssessmentMedicationId"
                                                                                            parentchldcontrols="True" name="HiddenField_CustomHRMAssessmentMedications_HRMAssessmentMedicationId"
                                                                                            includeinparentchildxml="true" />
                                                                                        <input type="hidden" id="HiddenFieldPrimaryKey" name="HiddenFieldPrimaryKey" value="HRMAssessmentMedicationId"
                                                                                            parentchildcontrols="True" />
                                                                                        <input type="hidden" parentchildcontrols="True" id="HiddenField_CustomHRMAssessmentMedications_DocumentVersionId"
                                                                                            name="HiddenField_CustomHRMAssessmentMedications_DocumentVersionId" />
                                                                                        <input id="HiddenFieldForigenKey" name="HiddenFieldForigenKey" type="hidden" value="DocumentVersionId" />
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
                                                <td colspan="7" class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <div id="DivMedications">
                                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                                            <tr class="RadioText">
                                                                <td width="42%" nowrap="nowrap">
                                                                    <span class="form_label">List has been reviewed with client. Does the list need to be
                                                                        modified?</span>
                                                                </td>
                                                                <td width="8px">
                                                                    &nbsp;
                                                                </td>
                                                                <td width="5%" class="RadioText">
                                                                    <input class="cursor_default" type="radio" id="RadioButton_CustomHRMAssessments_PsMedicationsListToBeModified_Y"
                                                                        name="RadioButton_CustomHRMAssessments_PsMedicationsListToBeModified" value="Y"
                                                                        onclick="EnabledMedicationsList('#RadioButton_CustomHRMAssessments_PsMedicationsListToBeModified_Y', '#TextArea_CustomHRMAssessments_PsMedicationsComment')" />
                                                                    <label for="RadioButton_CustomHRMAssessments_PsMedicationsListToBeModified_Y">
                                                                        Yes</label>
                                                                </td>
                                                                <td width="8px">
                                                                    &nbsp;
                                                                </td>
                                                                <td class="RadioText">
                                                                    <input class="cursor_default" type="radio" id="RadioButton_CustomHRMAssessments_PsMedicationsListToBeModified_N"
                                                                        name="RadioButton_CustomHRMAssessments_PsMedicationsListToBeModified" value="N"
                                                                        onclick="DisabledMedicationsList('#RadioButton_CustomHRMAssessments_PsMedicationsListToBeModified_N', '#TextArea_CustomHRMAssessments_PsMedicationsComment')" />
                                                                    <label for="RadioButton_CustomHRMAssessments_PsMedicationsListToBeModified_N">
                                                                        No
                                                                    </label>
                                                                </td>
                                                                <td width="30%">
                                                                </td>
                                                            </tr>
                                                            <tr colspan="6" class="height2">
                                                                <td colspan="7" class="height2">
                                                                    &nbsp;
                                                                </td>
                                                            </tr>
                                                        </table>
                                                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="tablecomments">
                                                            <tr colspan="6" class="height2">
                                                                <td>
                                                                    Comments
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="8" width="100%">
                                                                    <textarea class="form_textareaWithoutWidth" id="TextArea_CustomHRMAssessments_PsMedicationsComment"
                                                                        name="TextArea_CustomHRMAssessments_PsMedicationsComment" rows="5" spellcheck="True"
                                                                        cols="154" onblur="UpdateNeedsXML(136,'Medications');"></textarea>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="7" class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="7" class="height2">
                                                    Note efficacy of current and historical medications and their side effect:
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="7" class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="7" class="height2">
                                                    <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                                        <tr>
                                                            <td colspan="8" width="100%">
                                                                <textarea class="form_textareaWithoutWidth" id="TextArea_CustomHRMAssessments_PsMedicationsSideEffects"
                                                                    name="TextArea_CustomHRMAssessments_PsMedicationsSideEffects" rows="5" spellcheck="True"
                                                                    cols="154" onblur="UpdateNeedsXML(136,'Medications');"></textarea>
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
                            <table id="TableClientAbuseIssues" border="0" cellpadding="0" cellspacing="0" style="width: 99%"
                                group="ClientAbuseIssues">
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" style="width: 100%">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                    Client experienced abuse or neglect either as victim or perpetrator and / or has
                                                    had a previous traumatic incident? <span id="Group_ClientAbuseIssues"></span>
                                                </td>
                                                <td style="width: 17">
                                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif"
                                                        style="width: 17" height="26" alt="" />
                                                </td>
                                                <td class="content_tab_top" style="width: 100%">
                                                </td>
                                                <td style="width: 7">
                                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_right.gif"
                                                        style="width: 7" height="26" alt="" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="content_tab_bg">
                                        <table border="0" cellspacing="0" cellpadding="0" style="width: 100%">
                                            <tr>
                                                <td>
                                                    <table cellpadding="0" cellspacing="0" border="0">
                                                        <tr class="RadioText">
                                                            <td class="padding_label1" style="width: 45px">
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomHRMAssessments_PsClientAbuseIssues_Y"
                                                                    name="RadioButton_CustomHRMAssessments_PsClientAbuseIssues" value="Y" />
                                                                <label for="RadioButton_CustomHRMAssessments_PsClientAbuseIssues_Y">
                                                                    Yes</label>
                                                            </td>
                                                            <td style="width: 8px">
                                                                &nbsp;
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomHRMAssessments_PsClientAbuseIssues_N"
                                                                    name="RadioButton_CustomHRMAssessments_PsClientAbuseIssues" value="N" />
                                                                <label for="RadioButton_CustomHRMAssessments_PsClientAbuseIssues_N">
                                                                    No Concerns</label>
                                                            </td>
                                                            <td style="width: 8px">
                                                                &nbsp;
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomHRMAssessments_PsClientAbuseIssues_U"
                                                                    name="RadioButton_CustomHRMAssessments_PsClientAbuseIssues" value="U" />
                                                                <label for="RadioButton_CustomHRMAssessments_PsClientAbuseIssues_U">
                                                                    Unknown</label>
                                                            </td>
                                                            <td style="width: 15px">
                                                                &nbsp;
                                                            </td>
                                                            <td id="TraumaticNeedList" notgroup="ClientAbuseIssues">
                                                                <input class="cursor_default" type="checkbox" id="RadioButton_CustomHRMAssessments_PsClientAbuseIssuesNeedsList"
                                                                    name="RadioButton_CustomHRMAssessments_PsClientAbuseIssuesNeedsList" />
                                                                <label for="RadioButton_CustomHRMAssessments_PsClientAbuseIssuesNeedsList">
                                                                    Add Abuse / Neglect / Trauma to Needs List</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="7" class="height2">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="padding_label1">
                                                    Comments
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="7" class="height1">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="padding_label1">
                                                    <textarea class="form_textareaWithoutWidth" id="TextArea_CustomHRMAssessments_PsClientAbuesIssuesComment"
                                                        name="TextArea_CustomHRMAssessments_PsClientAbuesIssuesComment" rows="5" spellcheck="True"
                                                        cols="155" onblur="UpdateNeedsXML(76,'AbuseNeglect');"></textarea>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="7" class="height1">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" style="width: 100%">
                                            <tr>
                                                <td style="width: 2" class="right_bottom_cont_bottom_bg">
                                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                                                        height="7" alt="" />
                                                </td>
                                                <td class="right_bottom_cont_bottom_bg" style="width: 100%">
                                                </td>
                                                <td style="width: 2" class="right_bottom_cont_bottom_bg" align="right">
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
                            <table id="TableCulturalEthnicIssues" border="0" cellpadding="0" cellspacing="0"
                                style="width: 99%" group="CulturalEthnicIssues">
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" style="width: 100%">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                    Are there cultural / ethnic issues that are of concern or need to be addressed?
                                                    Describe cultural / ethnic values / beliefs. <span id="Group_CulturalEthnicIssues">
                                                    </span>
                                                </td>
                                                <td style="width: 17">
                                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif"
                                                        style="width: 17" height="26" alt="" />
                                                </td>
                                                <td class="content_tab_top" style="width: 100%">
                                                </td>
                                                <td style="width: 7">
                                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_right.gif"
                                                        style="width: 7" height="26" alt="" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="content_tab_bg">
                                        <table border="0" cellspacing="0" cellpadding="0" style="width: 100%">
                                            <tr>
                                                <td>
                                                    <table cellpadding="0" cellspacing="0" border="0">
                                                        <tr class="RadioText">
                                                            <td class="padding_label1" style="width: 45px">
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomHRMAssessments_PsCulturalEthnicIssues_Y"
                                                                    name="RadioButton_CustomHRMAssessments_PsCulturalEthnicIssues" value="Y" />
                                                                <label for="RadioButton_CustomHRMAssessments_PsCulturalEthnicIssues_Y">
                                                                    Yes</label>
                                                            </td>
                                                            <td style="width: 8px">
                                                                &nbsp;
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomHRMAssessments_PsCulturalEthnicIssues_N"
                                                                    name="RadioButton_CustomHRMAssessments_PsCulturalEthnicIssues" value="N" />
                                                                <label for="RadioButton_CustomHRMAssessments_PsCulturalEthnicIssues_N">
                                                                    No Concerns</label>
                                                            </td>
                                                            <td style="width: 8px">
                                                                &nbsp;
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomHRMAssessments_PsCulturalEthnicIssues_U"
                                                                    name="RadioButton_CustomHRMAssessments_PsCulturalEthnicIssues" value="U" />
                                                                <label for="RadioButton_CustomHRMAssessments_PsCulturalEthnicIssues_U">
                                                                    Unknown</label>
                                                            </td>
                                                            <td style="width: 15px">
                                                                &nbsp;
                                                            </td>
                                                            <td id="CulturalEthnicIssuesNeedList" notgroup="CulturalEthnicIssues">
                                                                <input class="cursor_default" type="checkbox" id="RadioButton_CustomHRMAssessments_PsCulturalEthnicIssuesNeedsList"
                                                                    name="RadioButton_CustomHRMAssessments_PsCulturalEthnicIssuesNeedsList" />
                                                                <label for="RadioButton_CustomHRMAssessments_PsCulturalEthnicIssuesNeedsList">
                                                                    Add Cultural / Ethnic Values to Needs List</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="7" class="height2">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="padding_label1">
                                                    Comments
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="7" class="height1">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="padding_label1">
                                                    <textarea class="form_textareaWithoutWidth" id="TextArea_CustomHRMAssessments_PsCulturalEthnicIssuesComment"
                                                        name="TextArea_CustomHRMAssessments_PsCulturalEthnicIssuesComment" rows="5" spellcheck="True"
                                                        cols="155" onblur="UpdateNeedsXML(78,'CulturalEthnicity');"></textarea>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="7" class="height1">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" style="width: 100%">
                                            <tr>
                                                <td style="width: 2" class="right_bottom_cont_bottom_bg">
                                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                                                        height="7" alt="" />
                                                </td>
                                                <td class="right_bottom_cont_bottom_bg" style="width: 100%">
                                                </td>
                                                <td style="width: 2" class="right_bottom_cont_bottom_bg" align="right">
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
                            <table id="TableEducationNeedsList" border="0" cellpadding="0" cellspacing="0" style="width: 99%"
                                group="EducationNeedsList">
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" style="width: 100%">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                    Educational Challenges/Barriers<span id="Group_EducationNeedsList"></span>
                                                </td>
                                                <td style="width: 17">
                                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif"
                                                        style="width: 17" height="26" alt="" />
                                                </td>
                                                <td class="content_tab_top" style="width: 100%">
                                                </td>
                                                <td style="width: 7">
                                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_right.gif"
                                                        style="width: 7" height="26" alt="" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="content_tab_bg">
                                        <table border="0" cellspacing="0" cellpadding="0" style="width: 100%">
                                            <tr>
                                                <td colspan="7" class="height1" style="padding-left: 8px">
                                                    <table cellpadding="0" cellspacing="0" border="0" style="width: 100%">
                                                        <tr class="checkbox_container">
                                                            <td>
                                                                <input class="cursor_default" type="checkbox" id="CheckBox_CustomHRMAssessments_AutisticallyImpaired"
                                                                    name="CheckBox_CustomHRMAssessments_AutisticallyImpaired" />
                                                                <label for="CheckBox_CustomHRMAssessments_AutisticallyImpaired">
                                                                    Autistically Impaired</label>
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="checkbox" id="CheckBox_CustomHRMAssessments_CognitivelyImpaired"
                                                                    name="CheckBox_CustomHRMAssessments_CognitivelyImpaired" />
                                                                <label for="CheckBox_CustomHRMAssessments_CognitivelyImpaired">
                                                                    Cognitively Impaired</label>
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="checkbox" id="CheckBox_CustomHRMAssessments_EmotionallyImpaired"
                                                                    name="CheckBox_CustomHRMAssessments_EmotionallyImpaired" />
                                                                <label for="CheckBox_CustomHRMAssessments_EmotionallyImpaired">
                                                                    Emotionally Impaired</label>
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="checkbox" id="CheckBox_CustomHRMAssessments_BehavioralConcern"
                                                                    name="CheckBox_CustomHRMAssessments_BehavioralConcern" />
                                                                <label for="CheckBox_CustomHRMAssessments_BehavioralConcern">
                                                                    Behavioral Concerns</label>
                                                            </td>
                                                        </tr>
                                                        <tr class="checkbox_container">
                                                            <td>
                                                                <input class="cursor_default" type="checkbox" id="CheckBox_CustomHRMAssessments_LearningDisabilities"
                                                                    name="CheckBox_CustomHRMAssessments_LearningDisabilities" />
                                                                <label for="CheckBox_CustomHRMAssessments_LearningDisabilities">
                                                                    Learning Disabilities</label>
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="checkbox" id="CheckBox_CustomHRMAssessments_PhysicalImpaired"
                                                                    name="CheckBox_CustomHRMAssessments_PhysicalImpaired" />
                                                                <label for="CheckBox_CustomHRMAssessments_PhysicalImpaired">
                                                                    Physical/Other Health Impaired</label>
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="checkbox" id="CheckBox_CustomHRMAssessments_IEP"
                                                                    name="CheckBox_CustomHRMAssessments_IEP" />
                                                                <label for="CheckBox_CustomHRMAssessments_IEP">
                                                                    Has IEP</label>
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="checkbox" id="CheckBox_CustomHRMAssessments_ChallengesBarrier"
                                                                    name="CheckBox_CustomHRMAssessments_ChallengesBarrier" />
                                                                <label for="CheckBox_CustomHRMAssessments_ChallengesBarrier">
                                                                    No Challenges/Barriers Known</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="7" class="height1">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="padding_label1">
                                                    <table cellpadding="0" cellspacing="0" border="0">
                                                        <tr class="checkbox_container">
                                                            <td id="EducationNeedsLst" notgroup="EducationNeedsList">
                                                                <input class="cursor_default" type="checkbox" id="RadioButton_CustomHRMAssessments_PsEducationNeedsList"
                                                                    name="RadioButton_CustomHRMAssessments_PsEducationNeedsList" />
                                                                <label for="RadioButton_CustomHRMAssessments_PsEducationNeedsList">
                                                                    Add Educational Challenges/Barriers to Needs List</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="7" class="height1">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="padding_label1">
                                                    Please discuss any issues with school, number of schools attended, and current and
                                                    past academic performance.
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="7" class="height1">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="padding_label1">
                                                    <textarea class="form_textareaWithoutWidth" id="TextArea_CustomHRMAssessments_PsEducationComment"
                                                        name="TextArea_CustomHRMAssessments_PsEducationComment" rows="5" spellcheck="True"
                                                        cols="155" onblur="UpdateNeedsXML(135,'Education');"></textarea>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="7" class="height2">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" style="width: 100%">
                                            <tr>
                                                <td style="width: 2" class="right_bottom_cont_bottom_bg">
                                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                                                        height="7" alt="" />
                                                </td>
                                                <td class="right_bottom_cont_bottom_bg" style="width: 100%">
                                                </td>
                                                <td style="width: 2" class="right_bottom_cont_bottom_bg" align="right">
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
                            <table id="TableHistMentalHealthTx" border="0" cellpadding="0" cellspacing="0" style="width: 99%"
                                group="HistMentalHealthTx">
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" style="width: 100%">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                    Mental health treatment history. List previous diagnosis, family history, treatment
                                                    history / efficacy, etc. <span id="Group_HistMentalHealthTx"></span>
                                                </td>
                                                <td style="width: 17">
                                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif"
                                                        style="width: 17" height="26" alt="" />
                                                </td>
                                                <td class="content_tab_top" style="width: 100%">
                                                </td>
                                                <td style="width: 7">
                                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_right.gif"
                                                        style="width: 7" height="26" alt="" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="content_tab_bg">
                                        <table border="0" cellspacing="0" cellpadding="0" style="width: 100%">
                                            <tr>
                                                <td>
                                                    <table cellpadding="0" cellspacing="0" border="0">
                                                        <tr class="RadioText">
                                                            <td class="padding_label1" style="width: 45px">
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomHRMAssessments_HistMentalHealthTx_Y"
                                                                    name="RadioButton_CustomHRMAssessments_HistMentalHealthTx" value="Y" />
                                                                <label for="RadioButton_CustomHRMAssessments_HistMentalHealthTx_Y">
                                                                    Yes</label>
                                                            </td>
                                                            <td style="width: 8px">
                                                                &nbsp;
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomHRMAssessments_HistMentalHealthTx_N"
                                                                    name="RadioButton_CustomHRMAssessments_HistMentalHealthTx" value="N" />
                                                                <label for="RadioButton_CustomHRMAssessments_HistMentalHealthTx_N">
                                                                    No history reported</label>
                                                            </td>
                                                            <td style="width: 8px">
                                                                &nbsp;
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomHRMAssessments_HistMentalHealthTx_U"
                                                                    name="RadioButton_CustomHRMAssessments_HistMentalHealthTx" value="U" />
                                                                <label for="RadioButton_CustomHRMAssessments_HistMentalHealthTx_U">
                                                                    Unknown</label>
                                                            </td>
                                                            <td style="width: 15px">
                                                                &nbsp;
                                                            </td>
                                                            <td id="HistMentalHealthTxNeedList" notgroup="HistMentalHealthTx">
                                                                <input class="cursor_default" type="checkbox" id="RadioButton_CustomHRMAssessments_HistMentalHealthTxNeedsList"
                                                                    name="RadioButton_CustomHRMAssessments_HistMentalHealthTxNeedsList" />
                                                                <label for="RadioButton_CustomHRMAssessments_HistMentalHealthTxNeedsList">
                                                                    Add Mental Health History to Needs List</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="7" class="height2">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="padding_label1">
                                                    Please list previous diagnosis, family history, treatment history/efficacy, etc.
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="7" class="height1">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="padding_label1">
                                                    <textarea class="form_textareaWithoutWidth" id="TextArea_CustomHRMAssessments_HistMentalHealthTxComment"
                                                        name="TextArea_CustomHRMAssessments_HistMentalHealthTxComment" rows="5" spellcheck="True"
                                                        cols="155" onblur="UpdateNeedsXML(72,'PreviousTraumatic');"></textarea>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="7" class="height1">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" style="width: 100%">
                                            <tr>
                                                <td style="width: 2" class="right_bottom_cont_bottom_bg">
                                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                                                        height="7" alt="" />
                                                </td>
                                                <td class="right_bottom_cont_bottom_bg" style="width: 100%">
                                                </td>
                                                <td style="width: 2" class="right_bottom_cont_bottom_bg" align="right">
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
                            <table id="TableCustomerAtRisk" border="0" cellpadding="0" cellspacing="0" style="width: 99%"
                                group="CustomerAtRisk">
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" style="width: 100%">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                    Client is At risk of.... <span id="Group_CustomerAtRisk"></span>
                                                </td>
                                                <td style="width: 17">
                                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif"
                                                        style="width: 17" height="26" alt="" />
                                                </td>
                                                <td class="content_tab_top" style="width: 100%">
                                                </td>
                                                <td style="width: 7">
                                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_right.gif"
                                                        style="width: 7" height="26" alt="" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="content_tab_bg">
                                        <table border="0" cellspacing="0" cellpadding="0" style="width: 100%">
                                            <tr>
                                                <td colspan="4" class="height1">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr class="RadioText">
                                                <td style="width: 35%" class="padding_label1">
                                                    <input style="padding-left: 11px" class="cursor_default" type="checkbox" id="Checkbox_CustomHRMAssessments_PsRiskLossOfPlacement"
                                                        name="Checkbox_CustomHRMAssessments_PsRiskLossOfPlacement" />
                                                    <label for="Checkbox_CustomHRMAssessments_PsRiskLossOfPlacement">
                                                        Loss/lack of placement</label>
                                                </td>
                                                <td style="width: 35%" align="left" valign="top">
                                                    <label for="DropDownList_CustomHRMAssessments_PsRiskLossOfPlacementDueTo">
                                                        Due to:
                                                    </label>
                                                    <asp:DropDownList ID="DropDownList_CustomHRMAssessments_PsRiskLossOfPlacementDueTo"
                                                        runat="server" EnableViewState="false" CssClass="form_dropdown" Style="width: 150px">
                                                    </asp:DropDownList>
                                                </td>
                                                <td style="width: 15%">
                                                </td>
                                                <td style="width: 15%">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" class="height1">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr class="RadioText">
                                                <td style="width: 35%" class="padding_label1">
                                                    <input style="padding-left: 11px" class="cursor_default" type="checkbox" id="Checkbox_CustomHRMAssessments_PsRiskLossOfSupport"
                                                        name="Checkbox_CustomHRMAssessments_PsRiskLossOfSupport" />
                                                    <label for="Checkbox_CustomHRMAssessments_PsRiskLossOfSupport">
                                                        Loss of support</label>
                                                </td>
                                                <td style="width: 35%" align="left" valign="top">
                                                    <label for="DropDownList_CustomHRMAssessments_PsRiskLossOfSupportDueTo">
                                                        Due to:
                                                    </label>
                                                    <asp:DropDownList ID="DropDownList_CustomHRMAssessments_PsRiskLossOfSupportDueTo"
                                                        runat="server" EnableViewState="false" CssClass="form_dropdown" Style="width: 150px">
                                                    </asp:DropDownList>
                                                </td>
                                                <td style="width: 15%">
                                                </td>
                                                <td style="width: 15%">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" class="height1">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr class="RadioText">
                                                <td style="width: 35%" class="padding_label1">
                                                    <input style="padding-left: 11px" class="cursor_default" type="checkbox" id="Checkbox_CustomHRMAssessments_PsRiskExpulsionFromSchool"
                                                        name="Checkbox_CustomHRMAssessments_PsRiskExpulsionFromSchool" />
                                                    <label for="Checkbox_CustomHRMAssessments_PsRiskExpulsionFromSchool">
                                                        Expulsion from school</label>
                                                </td>
                                                <td style="width: 35%" align="left" valign="top">
                                                    <label for="DropDownList_CustomHRMAssessments_PsRiskExpulsionFromSchoolDueTo">
                                                        Due to:
                                                    </label>
                                                    <asp:DropDownList ID="DropDownList_CustomHRMAssessments_PsRiskExpulsionFromSchoolDueTo"
                                                        runat="server" EnableViewState="false" CssClass="form_dropdown" Style="width: 150px">
                                                    </asp:DropDownList>
                                                </td>
                                                <td style="width: 15%">
                                                </td>
                                                <td style="width: 15%">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" class="height1">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr class="RadioText">
                                                <td style="width: 35%" class="padding_label1">
                                                    <input style="padding-left: 11px" class="cursor_default" type="checkbox" id="Checkbox_CustomHRMAssessments_PsRiskHospitalization"
                                                        name="Checkbox_CustomHRMAssessments_PsRiskHospitalization" />
                                                    <label for="Checkbox_CustomHRMAssessments_PsRiskHospitalization">
                                                        Hospitalization</label>
                                                </td>
                                                <td style="width: 35%" align="left" valign="top">
                                                    <label for="DropDownList_CustomHRMAssessments_PsRiskHospitalizationDueTo">
                                                        Due to:
                                                    </label>
                                                    <asp:DropDownList ID="DropDownList_CustomHRMAssessments_PsRiskHospitalizationDueTo"
                                                        runat="server" EnableViewState="false" CssClass="form_dropdown" Style="width: 150px">
                                                    </asp:DropDownList>
                                                </td>
                                                <td style="width: 15%">
                                                </td>
                                                <td style="width: 15%">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" class="height1">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr class="RadioText">
                                                <td style="width: 35%" class="padding_label1">
                                                    <input style="padding-left: 11px" class="cursor_default" type="checkbox" id="Checkbox_CustomHRMAssessments_PsRiskHigherLevelOfCare"
                                                        name="Checkbox_CustomHRMAssessments_PsRiskHigherLevelOfCare" />
                                                    <label for="Checkbox_CustomHRMAssessments_PsRiskHigherLevelOfCare">
                                                        Higher level of care</label>
                                                </td>
                                                <td style="width: 35%" align="left" valign="top">
                                                    <label for="DropDownList_CustomHRMAssessments_PsRiskHigherLevelOfCareDueTo">
                                                        Due to:
                                                    </label>
                                                    <asp:DropDownList ID="DropDownList_CustomHRMAssessments_PsRiskHigherLevelOfCareDueTo"
                                                        runat="server" EnableViewState="false" CssClass="form_dropdown" Style="width: 150px">
                                                    </asp:DropDownList>
                                                </td>
                                                <td style="width: 15%">
                                                </td>
                                                <td style="width: 15%">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" class="height1">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr class="RadioText">
                                                <td style="width: 35%" class="padding_label1">
                                                    <input style="padding-left: 11px" class="cursor_default" type="checkbox" id="Checkbox_CustomHRMAssessments_PsRiskCriminalJusticeSystem"
                                                        name="Checkbox_CustomHRMAssessments_PsRiskCriminalJusticeSystem" />
                                                    <label for="Checkbox_CustomHRMAssessments_PsRiskCriminalJusticeSystem">
                                                        Involvement with the criminal justice system</label>
                                                </td>
                                                <td style="width: 35%" align="left" valign="top">
                                                    <label for="DropDownList_CustomHRMAssessments_PsRiskCriminalJusticeSystemDueTo">
                                                        Due to:
                                                    </label>
                                                    <asp:DropDownList ID="DropDownList_CustomHRMAssessments_PsRiskCriminalJusticeSystemDueTo"
                                                        runat="server" EnableViewState="false" CssClass="form_dropdown" Style="width: 150px">
                                                    </asp:DropDownList>
                                                </td>
                                                <td style="width: 15%">
                                                </td>
                                                <td style="width: 15%">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" class="height1">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr class="RadioText">
                                                <td style="width: 35%" class="padding_label1">
                                                    <input style="padding-left: 11px" class="cursor_default" type="checkbox" id="Checkbox_CustomHRMAssessments_PsRiskElopementFromHome"
                                                        name="Checkbox_CustomHRMAssessments_PsRiskElopementFromHome" />
                                                    <label for="Checkbox_CustomHRMAssessments_PsRiskElopementFromHome">
                                                        Elopement from home</label>
                                                </td>
                                                <td style="width: 35%" align="left" valign="top">
                                                    <label for="DropDownList_CustomHRMAssessments_PsRiskElopementFromHomeDueTo">
                                                        Due to:
                                                    </label>
                                                    <asp:DropDownList ID="DropDownList_CustomHRMAssessments_PsRiskElopementFromHomeDueTo"
                                                        runat="server" EnableViewState="false" CssClass="form_dropdown" Style="width: 150px">
                                                    </asp:DropDownList>
                                                </td>
                                                <td style="width: 15%">
                                                </td>
                                                <td style="width: 15%">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" class="height1">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr class="RadioText">
                                                <td style="width: 35%" class="padding_label1">
                                                    <input style="padding-left: 11px" class="cursor_default" type="checkbox" id="Checkbox_CustomHRMAssessments_PsRiskLossOfFinancialStatus"
                                                        name="Checkbox_CustomHRMAssessments_PsRiskLossOfFinancialStatus" />
                                                    <label for="Checkbox_CustomHRMAssessments_PsRiskLossOfFinancialStatus">
                                                        Loss of financial status</label>
                                                </td>
                                                <td style="width: 35%" align="left" valign="top">
                                                    <label for="DropDownList_CustomHRMAssessments_PsRiskLossOfFinancialStatusDueTo">
                                                        Due to:
                                                    </label>
                                                    <asp:DropDownList ID="DropDownList_CustomHRMAssessments_PsRiskLossOfFinancialStatusDueTo"
                                                        runat="server" EnableViewState="false" CssClass="form_dropdown" Style="width: 150px">
                                                    </asp:DropDownList>
                                                </td>
                                                <td style="width: 15%">
                                                </td>
                                                <td style="width: 15%">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" class="height1">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr class="RadioText">
                                                <td style="width: 35%" class="padding_label1">
                                                    <input style="padding-left: 11px" class="cursor_default" type="checkbox" id="Checkbox_CustomHRMAssessments_PsRiskOutOfCountryPlacement"
                                                        name="Checkbox_CustomHRMAssessments_PsRiskOutOfCountryPlacement" />
                                                    <label for="Checkbox_CustomHRMAssessments_PsRiskOutOfCountryPlacement">
                                                        Out of country placement</label>
                                                </td>
                                                <td style="width: 35%" align="left" valign="top">
                                                    <label for="DropDownList_CustomHRMAssessments_PsRiskOutOfCountryPlacementDueTo">
                                                        Due to:
                                                    </label>
                                                    <asp:DropDownList ID="DropDownList_CustomHRMAssessments_PsRiskOutOfCountryPlacementDueTo" runat="server" EnableViewState="false" CssClass="form_dropdown"
                                                        Style="width: 150px">
                                                    </asp:DropDownList>
                                                </td>
                                                <td style="width: 15%">
                                                </td>
                                                <td style="width: 15%">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" class="height1">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr class="RadioText">
                                                <td style="width: 35%" class="padding_label1">
                                                    <input style="padding-left: 11px" class="cursor_default" type="checkbox" id="Checkbox_CustomHRMAssessments_PsRiskOutOfHomePlacement"
                                                        name="Checkbox_CustomHRMAssessments_PsRiskOutOfHomePlacement" />
                                                    <label for="Checkbox_CustomHRMAssessments_PsRiskOutOfHomePlacement">
                                                        Out of home placement</label>
                                                </td>
                                                <td style="width: 35%" align="left" valign="top">
                                                    <label for="DropDownList_CustomHRMAssessments_PsRiskOutOfHomePlacementDueTo">
                                                        Due to:
                                                    </label>
                                                    <asp:DropDownList ID="DropDownList_CustomHRMAssessments_PsRiskOutOfHomePlacementDueTo" runat="server" EnableViewState="false" CssClass="form_dropdown"
                                                        Style="width: 150px">
                                                    </asp:DropDownList>
                                                </td>
                                                <td style="width: 15%">
                                                </td>
                                                <td style="width: 15%">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" class="height1">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" style="width: 100%">
                                            <tr>
                                                <td style="width: 2" class="right_bottom_cont_bottom_bg">
                                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                                                        height="7" alt="" />
                                                </td>
                                                <td class="right_bottom_cont_bottom_bg" style="width: 100%">
                                                </td>
                                                <td style="width: 2" class="right_bottom_cont_bottom_bg" align="right">
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
                        <td class="height2">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table width="99%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td>
                                        <table cellspacing="0" cellpadding="0" border="0">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                    Communicable Disease Risk Assessment
                                                </td>
                                                <td width="17" style="overflow: hidden">
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
                                    <td class="content_tab_bg" style="padding-left: 7px">
                                        <table cellspacing="5" width="100%">
                                            <tr>
                                                <td colspan="3" align="left">
                                                    Have you had any of the below factors that may have put you at risk for a communicable
                                                    disease such as HIV/AIDs, STDs, Hepatitis B or C, or TB?
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="3">
                                                    <table border="0" cellpadding="0" cellspacing="5" style="padding-left: 5px">
                                                        <tr class="checkbox_container">
                                                            <td>
                                                                <label for="Checkbox_CustomHRMAssessments_UnProtectedSexualRelationMoreThenOnePartner">
                                                                    Unprotected sexual relations with more than one partner during the past 24 months?</label>
                                                            </td>
                                                            <td colspan="2" align="left">
                                                                <input type="checkbox" id="Checkbox_CustomHRMAssessments_UnProtectedSexualRelationMoreThenOnePartner" />
                                                            </td>
                                                        </tr>
                                                        <tr class="checkbox_container">
                                                            <td>
                                                                <label for="Checkbox_CustomHRMAssessments_SexualRelationWithHIVInfected">
                                                                    Sexual relations with anyone who is infected with HIV/AIDS, Hepatitis, or an STD?</label>
                                                            </td>
                                                            <td colspan="2" align="left">
                                                                <input type="checkbox" id="Checkbox_CustomHRMAssessments_SexualRelationWithHIVInfected" />
                                                            </td>
                                                        </tr>
                                                        <tr class="checkbox_container">
                                                            <td>
                                                                <label for="Checkbox_CustomHRMAssessments_SexualRelationWithDrugInject">
                                                                    Sexual relations with anyone who injects drugs?</label>
                                                            </td>
                                                            <td colspan="2" align="left">
                                                                <input type="checkbox" id="Checkbox_CustomHRMAssessments_SexualRelationWithDrugInject" />
                                                            </td>
                                                        </tr>
                                                        <tr class="checkbox_container">
                                                            <td>
                                                                <label for="Checkbox_CustomHRMAssessments_InjectsDrugsSharedNeedle">
                                                                    Injected drugs or shared needles?</label>
                                                            </td>
                                                            <td colspan="2" align="left">
                                                                <input type="checkbox" id="Checkbox_CustomHRMAssessments_InjectsDrugsSharedNeedle" />
                                                            </td>
                                                        </tr>
                                                        <tr class="checkbox_container">
                                                            <td>
                                                                <label for="Checkbox_CustomHRMAssessments_ReceivedAnyFavorsForSexualRelation">
                                                                    Received money, drugs, or other favors for sexual relations?</label>
                                                            </td>
                                                            <td colspan="2" align="left">
                                                                <input type="checkbox" id="Checkbox_CustomHRMAssessments_ReceivedAnyFavorsForSexualRelation" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr class="checkbox_container">
                                                <td colspan="3">
                                                    <input type="checkbox" id="Checkbox_CustomHRMAssessments_CommunicableDiseaseRecommendation"
                                                        showhideid="TD_CustomDocumentPhysicalHealths_CommunicableDiseaseRecommendationComment"
                                                        recommendation="true" />
                                                    <label for="Checkbox_CustomHRMAssessments_CommunicableDiseaseRecommendation">
                                                        Add Communicable Disease Risk to Needs List</label>
                                                </td>
                                            </tr>
                                            <tr>
                                             
                                                <td>
                                                 <label for="DropDownGlobalCodes_CustomHRMAssessments_CommunicableDiseaseAssessed" Width="20%">
                                                                    Client has been assessed for communicable disease </label>
                                                    <cc1:DropDownGlobalCodes ID="DropDownGlobalCodes_CustomHRMAssessments_CommunicableDiseaseAssessed"
                                                        EnableViewState="false" AddBlankRow="true" BlankRowText="" BlankRowValue="" runat="server" Category="XCommunicableDisease"
                                                        Width="127" TabIndex="82">
                                                    </cc1:DropDownGlobalCodes>
                                                </td>
                                                <td>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                   Further information and Justification
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <textarea class="form_textareaWithoutWidth" id="TextArea_CustomHRMAssessments_CommunicableDiseaseFurtherInfo"
                                                        name="TextArea_CustomHRMAssessments_CommunicableDiseaseFurtherInfo" rows="5" spellcheck="True"
                                                        cols="155""></textarea>
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
                        <td class="height2">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table width="99%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td>
                                        <table cellspacing="0" cellpadding="0" border="0">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                    Anxiety
                                                </td>
                                                <td width="17" style="overflow: hidden">
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
                                    <td class="content_tab_bg" style="padding-left: 5px">
                                        <table border="0" cellpadding="0" cellspacing="5" width="100%">
                                            <tr>
                                                <td>
                                                    Have your feelings caused you distress or interfered with your ability to get along
                                                    socially with friends or family?
                                                </td>
                                                <td>
                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td>
                                                                <input type="radio" id="RadioButton_CustomHRMAssessments_FamilyFriendFeelingsCausedDistress_Y"
                                                                    name="RadioButton_CustomHRMAssessments_FamilyFriendFeelingsCausedDistress" tabindex="81"
                                                                    value="Y" class="cursor_default" />
                                                            </td>
                                                            <td style="padding-left: 5px">
                                                                <label for="RadioButton_CustomHRMAssessments_FamilyFriendFeelingsCausedDistress_Y"
                                                                    class="form_label cursor_default">
                                                                    Yes</label>
                                                            </td>
                                                            <td style="padding-left: 5px">
                                                                <input type="radio" id="RadioButton_CustomHRMAssessments_FamilyFriendFeelingsCausedDistress_N"
                                                                    name="RadioButton_CustomHRMAssessments_FamilyFriendFeelingsCausedDistress" tabindex="82"
                                                                    value="N" class="cursor_default" />
                                                            </td>
                                                            <td style="padding-left: 5px">
                                                                <label for="RadioButton_CustomHRMAssessments_FamilyFriendFeelingsCausedDistress_N"
                                                                    class="form_label cursor_default">
                                                                    No</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    How often have you felt nervous,anxious,or on edge?
                                                </td>
                                                <td>
                                                    <cc1:DropDownGlobalCodes ID="DropDownList_CustomHRMAssessments_FeltNervousAnxious"
                                                        EnableViewState="false" AddBlankRow="true" BlankRowText="" runat="server" Category="XHHoptions1"
                                                        Width="127" TabIndex="82">
                                                    </cc1:DropDownGlobalCodes>
                                                </td>
                                                <td>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    How often were you not able to stop worrying or controlling your worry?
                                                </td>
                                                <td>
                                                    <cc1:DropDownGlobalCodes ID="DropDownList_CustomHRMAssessments_NotAbleToStopWorrying"
                                                        EnableViewState="false" AddBlankRow="true" BlankRowText="" runat="server" Category="XHHoptions1"
                                                        Width="127" TabIndex="83">
                                                    </cc1:DropDownGlobalCodes>
                                                </td>
                                                <td>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    How often is stress a problem for you handling such things as:Health,Finances,Family
                                                    or Social Relations,Work
                                                </td>
                                                <td>
                                                    <cc1:DropDownGlobalCodes ID="DropDownList_CustomHRMAssessments_StressPeoblemForHandlingThing"
                                                        EnableViewState="false" AddBlankRow="true" BlankRowText="" runat="server" Category="XHHoptions1"
                                                        Width="127" TabIndex="84">
                                                    </cc1:DropDownGlobalCodes>
                                                </td>
                                                <td>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    How often do you get the social and emotional support you need?
                                                </td>
                                                <td>
                                                    <cc1:DropDownGlobalCodes ID="DropDownList_CustomHRMAssessments_SocialAndEmotionalNeed"
                                                        EnableViewState="false" AddBlankRow="true" BlankRowText="" runat="server" Category="XHHoptions1"
                                                        Width="127" TabIndex="85">
                                                    </cc1:DropDownGlobalCodes>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="2">
                                                    <input type="checkbox" id="CheckBox_CustomHRMAssessments_DepressionAnxietyRecommendation"
                                                        name="CheckBox_CustomHRMAssessments_DepressionAnxietyRecommendation" showhideid="TD_CustomHRMAssessments_DepressionAnxietyRecommendationComment"
                                                        recommendation="true" tabindex="86" class="cursor_default" />
                                                    <label for="CheckBox_CustomHRMAssessments_DepressionAnxietyRecommendation" class="cursor_default">
                                                        Add Anxiety to Needs List</label>
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
                        <td class="height2">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table cellspacing="0" cellpadding="0" border="0" style="width: 99%">
                                <tr>
                                    <td phq9="PHQ9">
                                        <table cellspacing="0" cellpadding="0" border="0">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                    PHQ-9
                                                </td>
                                                <td width="17" style="overflow: hidden">
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
                                    <td class="content_tab_bg" phq9="PHQ9" style="padding-left: 7px">
                                        <table cellspacing="5" border="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td style="font-weight: bold">
                                                    Over the last 2 weeks,how often have you been bothered by any of the following problems?
                                                </td>
                                                <td>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Little interest or pleasure in doing things
                                                </td>
                                                <td>
                                                    <cc1:DropDownGlobalCodes ID="DropDownList_CustomHRMAssessments_PleasureInDoingThings"
                                                        EnableViewState="false" AddBlankRow="true" BlankRowText="" runat="server" Category="XHHPHQ9"
                                                        Width="127" TabIndex="88" PHQ9="PHQ9DD" onchange="AddToPHQ9Total();">
                                                    </cc1:DropDownGlobalCodes>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Feeling down,depressed,or hopeless
                                                </td>
                                                <td>
                                                    <cc1:DropDownGlobalCodes ID="DropDownList_CustomHRMAssessments_DepressedHopelessFeeling"
                                                        EnableViewState="false" AddBlankRow="true" BlankRowText="" runat="server" Category="XHHPHQ9"
                                                        Width="127" TabIndex="89" PHQ9="PHQ9DD" onchange="AddToPHQ9Total();">
                                                    </cc1:DropDownGlobalCodes>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Trouble falling or staying asleep,or sleeping too much
                                                </td>
                                                <td>
                                                    <cc1:DropDownGlobalCodes ID="DropDownList_CustomHRMAssessments_AsleepSleepingFalling"
                                                        EnableViewState="false" AddBlankRow="true" BlankRowText="" runat="server" Category="XHHPHQ9"
                                                        Width="127" TabIndex="89" PHQ9="PHQ9DD" onchange="AddToPHQ9Total();">
                                                    </cc1:DropDownGlobalCodes>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Feeling tired or having little energy
                                                </td>
                                                <td>
                                                    <cc1:DropDownGlobalCodes ID="DropDownList_CustomHRMAssessments_TiredFeeling" EnableViewState="false"
                                                        AddBlankRow="true" BlankRowText="" runat="server" Category="XHHPHQ9" Width="127"
                                                        TabIndex="90" PHQ9="PHQ9DD" onchange="AddToPHQ9Total();">
                                                    </cc1:DropDownGlobalCodes>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Poor appetite or overeating
                                                </td>
                                                <td>
                                                    <cc1:DropDownGlobalCodes ID="DropDownList_CustomHRMAssessments_OverEating" EnableViewState="false"
                                                        AddBlankRow="true" BlankRowText="" runat="server" Category="XHHPHQ9" Width="127"
                                                        TabIndex="91" PHQ9="PHQ9DD" onchange="AddToPHQ9Total();">
                                                    </cc1:DropDownGlobalCodes>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Feeling bad about yourself,or that you are a failure or have let yourself or your
                                                    family down
                                                </td>
                                                <td>
                                                    <cc1:DropDownGlobalCodes ID="DropDownList_CustomHRMAssessments_BadAboutYourselfFeeling"
                                                        EnableViewState="false" AddBlankRow="true" BlankRowText="" runat="server" Category="XHHPHQ9"
                                                        Width="127" TabIndex="92" PHQ9="PHQ9DD" onchange="AddToPHQ9Total();">
                                                    </cc1:DropDownGlobalCodes>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Trouble concentrating on things,such as reading the newspaper or watching television
                                                </td>
                                                <td>
                                                    <cc1:DropDownGlobalCodes ID="DropDownList_CustomHRMAssessments_TroubleConcentratingOnThings"
                                                        EnableViewState="false" AddBlankRow="true" BlankRowText="" runat="server" Category="XHHPHQ9"
                                                        Width="127" TabIndex="93" PHQ9="PHQ9DD" onchange="AddToPHQ9Total();">
                                                    </cc1:DropDownGlobalCodes>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Moving or speaking so slowly that other people could have noticed.Or the opposite-being
                                                    so fidgety or restless that you have been moving around a lot more than usual.
                                                </td>
                                                <td>
                                                    <cc1:DropDownGlobalCodes ID="DropDownList_CustomHRMAssessments_SpeakingSlowlyOrOpposite"
                                                        EnableViewState="false" AddBlankRow="true" BlankRowText="" runat="server" Category="XHHPHQ9"
                                                        Width="127" TabIndex="94" PHQ9="PHQ9DD" onchange="AddToPHQ9Total();">
                                                    </cc1:DropDownGlobalCodes>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Thoughts that you would be better off dead,or of hurting yourself in some way
                                                </td>
                                                <td>
                                                    <cc1:DropDownGlobalCodes ID="DropDownList_CustomHRMAssessments_BetterOffDeadThought"
                                                        EnableViewState="false" AddBlankRow="true" BlankRowText="" runat="server" Category="XHHPHQ9"
                                                        Width="127" TabIndex="95" PHQ9="PHQ9DD" onchange="AddToPHQ9Total();">
                                                    </cc1:DropDownGlobalCodes>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    If you checked off any problems,how difficult have these problems made if you to
                                                    do your work,take care of things at home,or get along with other people?
                                                </td>
                                                <td>
                                                    <cc1:DropDownGlobalCodes ID="DropDownList_CustomHRMAssessments_DifficultProblem"
                                                        EnableViewState="false" AddBlankRow="true" BlankRowText="" runat="server" Category="PHQ9ASEVERITYOTHER"
                                                        Width="127" TabIndex="96">
                                                    </cc1:DropDownGlobalCodes>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                </td>
                                                <td>
                                                    <table cellpadding="0" cellspacing="0" border="0">
                                                        <tr>
                                                            <td>
                                                                <b>Total</b>
                                                            </td>
                                                            <td phq9="PHQ9Total" style="padding-left: 10px;">
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="2">
                                                    <input type="checkbox" id="CheckBox_CustomHRMAssessments_DepressionPHQToNeedList"
                                                        name="CheckBox_CustomHRMAssessments_DepressionPHQToNeedList" showhideid="TD_CustomHRMAssessments_DepressionAnxietyRecommendationComment"
                                                        recommendation="true" tabindex="86" class="cursor_default" />
                                                    <label for="CheckBox_CustomHRMAssessments_DepressionPHQToNeedList" class="cursor_default">
                                                        Add Depression to Needs List</label>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td phq9="PHQ9">
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
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
                        <td class="height2">
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</div>
