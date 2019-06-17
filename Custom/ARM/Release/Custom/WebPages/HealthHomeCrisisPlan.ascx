<%@ Control Language="C#" AutoEventWireup="true" CodeFile="HealthHomeCrisisPlan.ascx.cs"
    Inherits="SHS.SmartCare.HealthHomeCrisisPlan" %>
<%@ Register Src="~/CommonUserControls/CustomGrid.ascx" TagName="CustomGrid" TagPrefix="uc1" %>
<%@ Register Assembly="Streamline.DotNetDropDowns" Namespace="Streamline.DotNetDropDowns"
    TagPrefix="cc2" %>
<% if (HttpContext.Current == null)
   { %>
<link href="../../../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet"
    type="text/css" />
<%} %>

<script language="javascript" type="text/javascript" src="<%=RelativePath%>Custom/Scripts/CrisisPlan.js" ></script>


<input id="HiddenFieldPageTables" runat="server" name="HiddenFieldPageTables" type="hidden"
    value="CustomDocumentHealthHomeCrisisPlans" />
    <input id="HiddenFieldCustomAjaxCallType" runat="server" name="HiddenFieldCustomAjaxCallType" type="hidden" />
<table class="DocumentScreen" border="0" cellspacing="0" cellpadding="0" >
    <tr>
        <td style="padding-left: 10px; padding-right: 5px">
            <span class="form_label_text" id="Span1">Clinician facilitating plan development</span>
            &nbsp;&nbsp;&nbsp;
            <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentHealthHomeCrisisPlans_ClinicianFacilitatingDischarge"
                name="DropDownList_CustomDocumentHealthHomeCrisisPlans_ClinicianFacilitatingDischarge"
                Width="210px" runat="server" TabIndex="5">
            </cc2:StreamlineDropDowns>
        </td>
    </tr>
    <tr>
        <td class="height2">
        </td>
    </tr>
    <tr>
        <td>
            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                <tr>
                    <td align="left">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                    Current Mental Health Diagnoses
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
                                <td style="padding-left: 10px; padding-right: 5px">
                                    <textarea id="TextArea_CustomDocumentHealthHomeCrisisPlans_CurrentMentalHealthDiagnoses"
                                        name="TextArea_CustomDocumentHealthHomeCrisisPlans_CurrentMentalHealthDiagnoses"
                                        rows="4" cols="158" class="form_textarea" spellcheck="True"></textarea>
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
            <table cellspacing="0" cellpadding="0" border="0" width="100%">
                <tr>
                    <td align="left">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                    Physical Health Diagnosis
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
                    <td class="content_tab_bg" style="padding-left: 8px">
                        <!-- Table Child Control Name -->
                        <table cellspacing="0" cellpadding="0" border="0" id="TableChildControl_CustomDocumentHealthHomeCarePlanDiagnoses"
                            parentchildcontrols="True" width="100%" style="padding-right: 20px">
                            <tr id="TableChildControl_CustomDocumentHealthHomeCarePlanDiagnoses_DataRow">
                                <td>
                                    <!-- Primary and Foreign Keys -->
                                    <input type="hidden" id="HiddenField_CustomDocumentHealthHomeCarePlanDiagnoses_CustomDocumentHealthHomeCarePlanDiagnosisId" name="HiddenField_CustomDocumentHealthHomeCarePlanDiagnoses_CustomDocumentHealthHomeCarePlanDiagnosisId"  parentchildcontrols="True"  />
                                    <input type="hidden" id="HiddenFieldPrimaryKeyCustomDocumentHealthHomeCarePlanDiagnosisId" name="HiddenFieldPrimaryKeyCustomDocumentHealthHomeCarePlanDiagnosisId" value="CustomDocumentHealthHomeCarePlanDiagnosisId" parentchildcontrols="True" />
                                    <input type="hidden" id="HiddenField_CustomDocumentHealthHomeCarePlanDiagnoses_DocumentVersionId" name="HiddenField_CustomDocumentHealthHomeCarePlanDiagnoses_DocumentVersionId" value="-1" parentchildcontrols="True" /> 
                                    <input type="hidden" id="HiddenField_CustomDocumentHealthHomeCarePlanDiagnoses_SequenceNumber" name="HiddenField_CustomDocumentHealthHomeCarePlanDiagnoses_SequenceNumber" parentchildcontrols="True" includeinparentchildxml="true" />
                                    <!-- Table Columns -->
                                    <label for="TextBox_CustomDocumentHealthHomeCarePlanDiagnoses_ReportedDiagnosis"
                                        class="form_label">
                                        Reported Diagnosis</label>
                                </td>
                                <td>
                                <input type="text" id="TextBox_CustomDocumentHealthHomeCarePlanDiagnoses_ReportedDiagnosis"
                                            name="TextBox_CustomDocumentHealthHomeCarePlanDiagnoses_ReportedDiagnosis" bindautosaveevents="False"
                                            required="true" parentchildcontrols="True" class="form_textbox element" style="width: 200px;" />
                                </td>
                                <td>
                                    <label for="TextBox_CustomDocumentHealthHomeCarePlanDiagnoses_TreatmentProvider"
                                        class="form_label">
                                        Treatment Provider</label><input type="text" id="TextBox_CustomDocumentHealthHomeCarePlanDiagnoses_TreatmentProvider"
                                            name="TextBox_CustomDocumentHealthHomeCarePlanDiagnoses_TreatmentProvider" bindautosaveevents="False"
                                            required="true" parentchildcontrols="True" class="form_textbox element" style="width: 205px;" /><br />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="3" class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label for="<%=DropDownList_CustomDocumentHealthHomeCarePlanDiagnoses_DiagnosisSource.ClientID %>"
                                        class="form_label">
                                        Source</label>
                                   
                                </td>
                                <td>
                                 <asp:DropDownList ID="DropDownList_CustomDocumentHealthHomeCarePlanDiagnoses_DiagnosisSource"
                                        bindautosaveevents="False" parentchildcontrols="True" AddBlankRow="true" Width="205px"
                                        runat="server">
                                    </asp:DropDownList>
                                </td>
                                <td></td>
                            </tr>
                            <tr>
                                <td colspan="3" class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td colspan="3" style="text-align: right; padding: 5px;">
                                    <input type="button" id="TableChildControl_CustomDocumentHealthHomeCarePlanDiagnoses_ButtonInsert"
                                        style="padding-right: 5px" name="TableChildControl_CustomDocumentHealthHomeCarePlanDiagnoses_ButtonInsert"
                                        baseurl="<%=ResolveUrl("~") %>" onclick="return InsertGrid_CustomDocumentHealthHomeCarePlanDiagnosesData('TableChildControl_CustomDocumentHealthHomeCarePlanDiagnoses','InsertGrid_CustomDocumentHealthHomeCarePlanDiagnoses','CustomGrid_CustomDocumentHealthHomeCarePlanDiagnoses', this);"
                                        value="Insert" class="parentchildbutton" />
                                    <span id="Empty" style="width: 10px;"></span>
                                    <input type="button" id="Button2" onclick="Clear_CustomDocumentHealthHomeCarePlanDiagnoses_Data();"
                                        name="ButtonClear" value="Clear" class="parentchildbutton" />
                                </td>
                            </tr>
                            <!-- Custom Grid -->
                            <tr>
                                <td colspan="3">
                                    <div id="InsertGrid_CustomDocumentHealthHomeCarePlanDiagnoses" style="overflow-x: hidden;
                                        overflow-y: auto; height: 100px; width: 100%; padding-right: 10px">
                                        <uc1:CustomGrid ID="CustomGrid_CustomDocumentHealthHomeCarePlanDiagnoses" runat="server"
                                            TableName="CustomDocumentHealthHomeCarePlanDiagnoses" PrimaryKey="CustomDocumentHealthHomeCarePlanDiagnosisId"
                                            CustomGridTableName="TableChildControl_CustomDocumentHealthHomeCarePlanDiagnoses"
                                            GridPageName="CustomDocumentHealthHomeCarePlanDiagnoses_Grid" ColumnName="ReportedDiagnosis:TreatmentProvider"
                                            ColumnHeader="Reported Diagnosis:Treatment Provider" ColumnWidth="50%:50%" DivGridName="InsertGrid_CustomDocumentHealthHomeCarePlanDiagnoses"
                                            InsertButtonId="TableChildControl_CustomDocumentHealthHomeCarePlanDiagnoses_ButtonInsert"
                                            OrderByQuery="CustomDocumentHealthHomeCarePlanDiagnosisId" />
                                    </div>
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
            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                <tr>
                    <td align="left">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                                        Current Developmental Disabilities</td>
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
                                <td style="padding-left: 10px; padding-right: 5px">
                                    <textarea id="TextArea_CustomDocumentHealthHomeCrisisPlans_CurrentDDDiagnoses" name="TextArea_CustomDocumentHealthHomeCrisisPlans_CurrentDDDiagnoses"
                                        rows="4" cols="158" class="form_textarea" spellcheck="True"></textarea>
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
            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                <tr>
                    <td align="left">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                    Medications
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
                                <td style="padding-left: 10px; padding-right: 5px">
                                    <textarea id="TextArea_CustomDocumentHealthHomeCrisisPlans_CurrentMedication" name="TextArea_CustomDocumentHealthHomeCrisisPlans_CurrentMedication"
                                        rows="4" cols="158" class="form_textarea" spellcheck="True"></textarea>
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
            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                <tr>
                    <td align="left">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                    Physician/Support Contacts
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
                                <td style="padding-left: 10px; padding-right: 5px">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td colspan="2">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr>
                                                        <td style="width: 100%">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr>
                                                                    <td style="width: 21%">
                                                                        <span class="form_label_text" id="Span13">Primary Care Physician Name</span>&nbsp&nbsp
                                                                    </td>
                                                                    <td style="width: 29%">
                                                                        <input type="text" id="TextBox_CustomDocumentHealthHomeCrisisPlans_PrimaryCarePhysician"
                                                                            name="TextBox_CustomDocumentHealthHomeCrisisPlans_PrimaryCarePhysician" class="form_textbox element"
                                                                            style="width: 90%" />
                                                                    </td>
                                                                    <td style="width: 10%">
                                                                        <span class="form_label_text" id="Span2">Phone Number</span>&nbsp&nbsp
                                                                    </td>
                                                                    <td style="width: 40%;">
                                                                        <input type="text" id="TextBox_CustomDocumentHealthHomeCrisisPlans_PrimaryCarePhysicianPhone"
                                                                            name="TextBox_CustomDocumentHealthHomeCrisisPlans_PrimaryCarePhysicianPhone"
                                                                            class="form_textbox element" style="width: 90%" />
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
                                            <td colspan="2">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr>
                                                        <td style="width: 21%">
                                                            <span class="form_label_text" id="Span3">Pharmacy Name</span>&nbsp&nbsp
                                                        </td>
                                                        <td style="width: 29%">
                                                            <input type="text" id="TextBox_CustomDocumentHealthHomeCrisisPlans_PharmacyName"
                                                                name="TextBox_CustomDocumentHealthHomeCrisisPlans_PharmacyName" class="form_textbox element"
                                                                style="width: 90%" />
                                                        </td>
                                                        <td style="width: 10%">
                                                            <span class="form_label_text" id="Span4">Phone Number</span>&nbsp&nbsp
                                                        </td>
                                                        <td style="width: 40%">
                                                            <input type="text" id="TextBox_CustomDocumentHealthHomeCrisisPlans_PharmacyPhone"
                                                                name="TextBox_CustomDocumentHealthHomeCrisisPlans_PharmacyPhone" class="form_textbox element"
                                                                style="width: 90%" />
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
                                            <td colspan="2">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr>
                                                        <td style="width: 21%">
                                                            <span class="form_label_text" id="Span5">First Support Contact Name</span>&nbsp&nbsp
                                                        </td>
                                                        <td style="width: 29%">
                                                            <input type="text" id="TextBox_CustomDocumentHealthHomeCrisisPlans_FirstSupportContactName"
                                                                name="TextBox_CustomDocumentHealthHomeCrisisPlans_FirstSupportContactName" class="form_textbox element"
                                                                style="width: 90%" />
                                                        </td>
                                                        <td style="width: 10%">
                                                            <span class="form_label_text" id="Span6">Phone(s)</span>&nbsp&nbsp
                                                        </td>
                                                        <td style="width: 40%">
                                                            <input type="text" id="TextBox_CustomDocumentHealthHomeCrisisPlans_FirstSupportContactPhone"
                                                                name="TextBox_CustomDocumentHealthHomeCrisisPlans_FirstSupportContactPhone" class="form_textbox element"
                                                                style="width: 90%" />
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
                                            <td colspan="2">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr>
                                                        <td style="width: 21%">
                                                            <span class="form_label_text" id="Span7">Secondary Support Contact Name</span>&nbsp&nbsp
                                                        </td>
                                                        <td style="width: 29%">
                                                            <input type="text" id="TextBox_CustomDocumentHealthHomeCrisisPlans_SecondarySupportContactName"
                                                                name="TextBox_CustomDocumentHealthHomeCrisisPlans_SecondarySupportContactName"
                                                                class="form_textbox element" style="width: 90%" />
                                                        </td>
                                                        <td style="width: 10%">
                                                            <span class="form_label_text" id="Span8">Phone(s)</span>&nbsp&nbsp
                                                        </td>
                                                        <td style="width: 40%">
                                                            <input type="text" id="TextBox_CustomDocumentHealthHomeCrisisPlans_SecondarySupportContactPhone"
                                                                name="TextBox_CustomDocumentHealthHomeCrisisPlans_SecondarySupportContactPhone"
                                                                class="form_textbox element" style="width: 90%" />
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
        <td colspan="2">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td align="left">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                    <span id="FamilyCollaboration">Additional Social/Family/Community Supports to Use in
                                        Crisis Resolution </span>
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
                    <td class="content_tab_bg" style="padding-left: 10px; padding-right: 5px">
                        <!-- Table Parent Child Custom Grid Control for CustomDocumentHealthHomeCommPlanFamilyMembers -->
                        <table cellspacing="0" cellpasding="0" border="0" id="TableChildControl_CustomDocumentHealthHomeCommPlanFamilyMembers"
                            parentchildcontrols="True" clearcontrols="true" width="800px;">
                            <tr id="TableChildControl_CustomDocumentHealthHomeCommPlanFamilyMembers_DataRow">
                                <td>
                                    <!-- Primary and Foreign Keys -->
                                    <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                        <tr>
                                            <td colspan="2">
                                                NOTE: A signed authorization for disclosure may be required for collaboration with
                                                the partners listed below. This form does not replace a legally valid Authorization
                                                for Disclosure form.
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" class="height2">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="15%" align="left">
                                                <label for="TextBox_CustomDocumentHealthHomeCommPlanFamilyMembers_FamilyMemberName"
                                                    class="form_label">
                                                    Family Member Name</label>
                                            </td>
                                            <td align="left" width="85%" valign="top" style="padding-left: 9px;">
                                                <input type="text" id="TextBox_CustomDocumentHealthHomeCommPlanFamilyMembers_FamilyMemberName"
                                                    maxlength="300" style="width: 275px;" name="TextBox_CustomDocumentHealthHomeCommPlanFamilyMembers_FamilyMemberName"
                                                    bindautosaveevents="False" includeinparentchildxml="true" parentchildcontrols="True" required="true"
                                                    class="form_textbox element" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" class="height2">
                                                <input type="hidden" id="HiddenField_CustomDocumentHealthHomeCommPlanFamilyMembers_HealthHomeCommPlanFamilyMemberId"
                                                    name="HiddenField_CustomDocumentHealthHomeCommPlanFamilyMembers_HealthHomeCommPlanFamilyMemberId"
                                                    parentchildcontrols="True" includeinparentchildxml="true" value="-1" />
                                                <input type="hidden" id="HiddenFieldPrimaryKeyHealthHomeCommPlanFamilyMemberId" name="HiddenFieldPrimaryKeyHealthHomeCommPlanFamilyMemberId"
                                                    value="HealthHomeCommPlanFamilyMemberId" parentchildcontrols="True" />
                                                <input type="hidden" id="HiddenField_CustomDocumentHealthHomeCommPlanFamilyMembers_DocumentVersionId"
                                                    name="HiddenField_CustomDocumentHealthHomeCommPlanFamilyMembers_DocumentVersionId"
                                                    value="-1" parentchildcontrols="True" />
                                                <input type="hidden" id="HiddenField_CustomDocumentHealthHomeCommPlanFamilyMembers_FamilyMemberPhone"
                                                    name="HiddenField_CustomDocumentHealthHomeCommPlanFamilyMembers_FamilyMemberPhone"
                                                    parentchildcontrols="True" includeinparentchildxml="true" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="15%" align="left">
                                                <span class="form_label" id="Span38">Phone</span>
                                            </td>
                                            <td align="left" width="85%" valign="top">
                                                <span class="form_label" id="Span39">(</span>
                                                <input id="TextBox_CustomDocumentHealthHomeCommPlanFamilyMembers_FamilyMemberPhone1"
                                                    enabled="enabled" type="text" class="form_textbox" style="width: 6%" datatype="Numeric"
                                                    maxlength="3" bindautosaveevents="False" onkeyup="return autoTab(this, 3, event);"
                                                    onkeydown="AllowNumericOnly('TextBox_CustomDocumentHealthHomeCommPlanFamilyMembers_FamilyMemberPhone1');"
                                                    onblur="javascript:UpdatePhone('1');" />
                                                <span class="form_label" id="Span40">)</span>
                                                <input id="TextBox_CustomDocumentHealthHomeCommPlanFamilyMembers_FamilyMemberPhone2"
                                                    enabled="enabled" type="text" class="form_textbox" onkeyup="return autoTab(this, 3, event);"
                                                    style="width: 6%" datatype="Numeric" maxlength="3" bindautosaveevents="False"
                                                    onblur="javascript:UpdatePhone('2');" onkeydown="AllowNumericOnly('TextBox_CustomDocumentHealthHomeCommPlanFamilyMembers_FamilyMemberPhone2');" />
                                                <span class="form_label" id="Span41">-</span>
                                                <input id="TextBox_CustomDocumentHealthHomeCommPlanFamilyMembers_FamilyMemberPhone3"
                                                    enabled="enabled" type="text" class="form_textbox" onkeyup="return autoTab(this, 4, event);"
                                                    style="width: 8%" datatype="Numeric" maxlength="4" onkeydown="AllowNumericOnly('TextBox_CustomDocumentHealthHomeCommPlanFamilyMembers_FamilyMemberPhone3');"
                                                    bindautosaveevents="False" onblur="javascript:UpdatePhone('3');" />
                                                <span class="form_label" id="Span42">Ext</span>
                                                <input id="TextBox_CustomDocumentHealthHomeCommPlanFamilyMembers_FamilyMemberPhone4"
                                                    enabled="enabled" type="text" class="form_textbox" onkeyup="return autoTab(this, 6, event);"
                                                    style="width: 10%" datatype="Numeric" maxlength="6" bindautosaveevents="False"
                                                    onblur="javascript:UpdatePhone('4');" onkeydown="AllowNumericOnly('TextBox_CustomDocumentHealthHomeCommPlanFamilyMembers_FamilyMemberPhone4');" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" style="text-align: right; padding-right: 100px;">
                                                <!-- Insert and Clear Buttons for the Parent Table Control -->
                                                <input type="button" id="TableChildControl_CustomDocumentHealthHomeCommPlanFamilyMembers_ButtonInsert"
                                                    name="TableChildControl_CustomDocumentHealthHomeCommPlanFamilyMembers_ButtonInsert"
                                                    baseurl="<%=ResolveUrl("~") %>" onclick="return InsertGrid_CustomDocumentHealthHomeCommPlanFamilyMembersData('TableChildControl_CustomDocumentHealthHomeCommPlanFamilyMembers','InsertGrid_CustomDocumentHealthHomeCommPlanFamilyMembers','CustomGrid_CustomDocumentHealthHomeCommPlanFamilyMembers', this);"
                                                    value="Insert" class="parentchildbutton" />
                                                <input type="button" id="Button1" onclick="Clear_CustomDocumentHealthHomeCommPlanFamilyMembers_Data();"
                                                    name="ButtonClear" value="Clear" class="parentchildbutton" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" class="height2">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2">
                                                <!-- Parent Child Control Custom Grid -->
                                                <div id="InsertGrid_CustomDocumentHealthHomeCommPlanFamilyMembers" style="overflow-x: hidden;
                                                    overflow-y: auto; height: 100px; width: 800px;">
                                                    <uc1:CustomGrid ID="CustomGrid_CustomDocumentHealthHomeCommPlanFamilyMembers" runat="server"
                                                        TableName="CustomDocumentHealthHomeCommPlanFamilyMembers" PrimaryKey="HealthHomeCommPlanFamilyMemberId"
                                                        CustomGridTableName="TableChildControl_CustomDocumentHealthHomeCommPlanFamilyMembers"
                                                        GridPageName="CustomDocumentHealthHomeCommPlanFamilyMembers_Grid" ColumnName="FamilyMemberName:FamilyMemberPhone"
                                                        ColumnHeader="Family Member Name:Phone" ColumnWidth="343:343" DivGridName="InsertGrid_CustomDocumentHealthHomeCommPlanFamilyMembers"
                                                        InsertButtonId="TableChildControl_CustomDocumentHealthHomeCommPlanFamilyMembers_ButtonInsert"
                                                        OrderByQuery="FamilyMemberName" />
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                        <!-- End of Parent Child control table -->
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
            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                <tr>
                    <td align="left">
                        <table cellspacing="0" cellpadding="0" border="0" width="100%">
                            <tr>
                                <td>
                                    <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                        <tr>
                                            <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                Personal/FamilyConcerns
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
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="content_tab_bg">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0" id="TableChildControl_CustomDocumentHealthHomePriorAuthorizations">
                            <tr>
                                <td style="padding-left: 10px; padding-right: 5px">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td colspan="2">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr>
                                                        <td colspan="2">
                                                            <span class="form_label_text" id="Span9">Description of immediate needs: (ex. housing,
                                                                ongoing medication management) </span>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <textarea id="TextArea_CustomDocumentHealthHomeCrisisPlans_DescriptionImmediateNeed"
                                                                name="TextArea_CustomDocumentHealthHomeCrisisPlans_DescriptionImmediateNeed"
                                                                rows="4" cols="158" class="form_textarea" spellcheck="True"></textarea>
                                                        </td>
                                                    </tr>
                                                      <tr>
                                                        <td class="height2">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2">
                                                            <span class="form_label_text" id="Span11">Current Treatments and Healthcare Services
                                                            </span>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <textarea id="TextArea_CustomDocumentHealthHomeCrisisPlans_CurrentTreatment" name="TextArea_CustomDocumentHealthHomeCrisisPlans_CurrentTreatment"
                                                                rows="4" cols="158" class="form_textarea" spellcheck="True"></textarea>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2">
                                                            <span class="form_label_text" id="Span12">Personal/Family Safety Concerns </span>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <textarea id="TextArea_CustomDocumentHealthHomeCrisisPlans_PersonalSafetyConcern"
                                                                name="TextArea_CustomDocumentHealthHomeCrisisPlans_PersonalSafetyConcern" rows="4"
                                                                cols="158" class="form_textarea" spellcheck="True"></textarea>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2">
                                                            <span class="form_label_text" id="Span14">Situations that may trigger a mental health
                                                                crisis</span>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <textarea id="TextArea_CustomDocumentHealthHomeCrisisPlans_SituationsTriggerCrisis"
                                                                name="TextArea_CustomDocumentHealthHomeCrisisPlans_SituationsTriggerCrisis" rows="4"
                                                                cols="158" class="form_textarea" spellcheck="True"></textarea>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2">
                                                            <span class="form_label_text" id="Span15">In a mental health crisis, interventions preferred</span>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <textarea id="TextArea_CustomDocumentHealthHomeCrisisPlans_InterventionsPreferred"
                                                                name="TextArea_CustomDocumentHealthHomeCrisisPlans_InterventionsPreferred" rows="4"
                                                                cols="158" class="form_textarea" spellcheck="True"></textarea>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height2">
                                                <input type="hidden" id="HiddenField_CustomDocumentHealthHomePriorAuthorizations_HealthHomePriorAuthorizationId"
                                                    name="HiddenField_CustomDocumentHealthHomePriorAuthorizations_HealthHomePriorAuthorizationId"
                                                    parentchildcontrols="True" value="-1" />
                                                <input type="hidden" id="HiddenFieldPrimaryKeyHealthHomePriorAuthorizationId" name="HiddenFieldPrimaryKeyHealthHomePriorAuthorizationId"
                                                    value="HealthHomePriorAuthorizationId" parentchildcontrols="True" />
                                                <input type="hidden" id="HiddenField_CustomDocumentHealthHomePriorAuthorizations_DocumentVersionId"
                                                    name="HiddenField_CustomDocumentHealthHomePriorAuthorizations_DocumentVersionId"
                                                    value="-1" parentchildcontrols="True" />
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
        <td colspan="2">
            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                <tr>
                    <td align="left">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                    Mental Health Crisis Plan
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
                    <td class="content_tab_bg" style="padding-left: 10px; padding-right: 5px">
                        <table cellspacing="0" cellpadding="0" border="0" width="100%">
                            <tr>
                                <td>
                                    <!-- Table Parent Child Custom Grid Control for CustomDocumentHealthHomeCommPlanFamilyMembers -->
                                    <table cellspacing="0" cellpadding="0" border="0" id="TableChildControl_CustomDocumentHealthHomeMentalHealthCrisisPlanSteps"
                                        parentchildcontrols="True" clearcontrols="true" width="100%">
                                        <tr>
                                            <td>
                                                <!-- Primary and Foreign Keys -->
                                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                    <tr>
                                                        <td colspan="2">
                                                            <span class="form_label_text" id="Span10">In a mental health crisis, my plan is to:</span>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td width="20%" align="left">
                                                            <label for="TextBox_CustomDocumentHealthHomeMentalHealthCrisisPlanSteps_StepNumber" class="form_label">
                                                                Step Number</label>&nbsp&nbsp
                                                            <input type="text" id="TextBox_CustomDocumentHealthHomeMentalHealthCrisisPlanSteps_StepNumber" datatype="Numeric"
                                                                maxlength="8" style="width: 50px;" name="TextBox_CustomDocumentHealthHomeMentalHealthCrisisPlanSteps_StepNumber"
                                                                bindautosaveevents="False" includeinparentchildxml="true" parentchildcontrols="True" required="true"
                                                                class="form_textbox element" />
                                                        </td>
                                                        <td align="left" width="80%" valign="top">
                                                            <label for="TextBox_CustomDocumentHealthHomeMentalHealthCrisisPlanSteps_StepDescription" class="form_label">
                                                                Step Description</label>&nbsp&nbsp
                                                            <input type="text" id="TextBox_CustomDocumentHealthHomeMentalHealthCrisisPlanSteps_StepDescription"
                                                                style="width: 80%;" name="TextBox_CustomDocumentHealthHomeMentalHealthCrisisPlanSteps_StepDescription"
                                                                bindautosaveevents="False" includeinparentchildxml="true" parentchildcontrols="True" required="true"
                                                                class="form_textbox element" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2" class="height2">
                                                            <input type="hidden" id="HiddenField_CustomDocumentHealthHomeMentalHealthCrisisPlanSteps_HealthHomeMentalHealthCrisisPlanStepId"
                                                                name="HiddenField_CustomDocumentHealthHomeMentalHealthCrisisPlanSteps_HealthHomeMentalHealthCrisisPlanStepId"
                                                                parentchildcontrols="True" includeinparentchildxml="true" value="-1" />
                                                            <input type="hidden" id="HiddenFieldPrimaryKeyHealthHomeMentalHealthCrisisPlanStepId" name="HiddenFieldPrimaryKeyHealthHomeMentalHealthCrisisPlanStepId"
                                                                value="HealthHomeMentalHealthCrisisPlanStepId" parentchildcontrols="True" />
                                                            <input type="hidden" id="HiddenField_CustomDocumentHealthHomeMentalHealthCrisisPlanSteps_DocumentVersionId"
                                                                name="HiddenField_CustomDocumentHealthHomeMentalHealthCrisisPlanSteps_DocumentVersionId"
                                                                value="-1" parentchildcontrols="True" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2" style="text-align: right; padding-right: 100px;">
                                                            <!-- Insert and Clear Buttons for the Parent Table Control -->
                                                            <input type="button" id="TableChildControl_CustomDocumentHealthHomeMentalHealthCrisisPlanSteps_ButtonInsert" name="TableChildControl_CustomDocumentHealthHomeMentalHealthCrisisPlanSteps_ButtonInsert"
                                                                baseurl="<%=ResolveUrl("~") %>" onclick="return InsertGrid_CustomDocumentHealthHomeMentalHealthCrisisPlanStepsData('TableChildControl_CustomDocumentHealthHomeMentalHealthCrisisPlanSteps','InsertGrid_CustomDocumentHealthHomeMentalHealthCrisisPlanSteps','CustomGrid_CustomDocumentHealthHomeMentalHealthCrisisPlanSteps', this);"
                                                                 value="Insert" class="parentchildbutton" />
                                                            <input type="button" id="Button3"  onclick="Clear_CustomDocumentHealthHomeMentalHealthCrisisPlanSteps_Data();"
                                                                name="ButtonClear" value="Clear" class="parentchildbutton" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2" class="height2">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2">
                                                            <!-- Parent Child Control Custom Grid -->
                                                            <div id="InsertGrid_CustomDocumentHealthHomeMentalHealthCrisisPlanSteps" style="overflow-x: hidden; overflow-y: auto; height: 100px; width: 100%;">
                                                                <uc1:CustomGrid ID="CustomGrid_CustomDocumentHealthHomeMentalHealthCrisisPlanSteps" runat="server"
                                                                    TableName="CustomDocumentHealthHomeMentalHealthCrisisPlanSteps" PrimaryKey="HealthHomeMentalHealthCrisisPlanStepId"
                                                                    CustomGridTableName="TableChildControl_CustomDocumentHealthHomeMentalHealthCrisisPlanSteps"
                                                                    GridPageName="CustomDocumentHealthHomeMentalHealthCrisisPlanSteps_Grid" ColumnName="StepNumber:StepDescription"
                                                                    ColumnHeader="Step Number:Description" ColumnWidth="20%:80%" DivGridName="InsertGrid_CustomDocumentHealthHomeMentalHealthCrisisPlanSteps"
                                                                    InsertButtonId="TableChildControl_CustomDocumentHealthHomeMentalHealthCrisisPlanSteps_ButtonInsert"
                                                                    OrderByQuery="StepNumber" />
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                    <!-- End of Parent Child control table -->
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
            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                <tr>
                    <td align="left">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                    Planning for Other Types of Crisis
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
                    <td class="content_tab_bg" style="padding-left: 10px; padding-right: 5px">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <span class="form_label_text" id="Span16">Situations that may lead to appropriate emergency
                                        department/ Rescue Mental Health utilization</span>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                             <%--   <td>
                                    <textarea id="TextArea_CustomDocumentHealthHomeCrisisPlans_SituationsAppropriateToEmergencyDepartment"
                                        name="TextArea_CustomDocumentHealthHomeCrisisPlans_SituationsAppropriateToEmergencyDepartment"
                                        rows="4" cols="158" class="form_textarea" spellcheck="True"></textarea>
                                </td>--%>
                                 <td>
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td style="width: 90%">
                                                <textarea id="TextArea_CustomDocumentHealthHomeCrisisPlans_SituationsAppropriateToEmergencyDepartment"
                                        name="TextArea_CustomDocumentHealthHomeCrisisPlans_SituationsAppropriateToEmergencyDepartment"
                                        rows="4" cols="158" class="form_textarea" spellcheck="True"></textarea>
                                            </td>
                                            <td style="width: 10%; padding-left: 5px">
                                                <input type="checkbox" id="CheckBox_CustomDocumentHealthHomeCrisisPlans_SituationsAppropriateToEmergencyDepartmentNA"
                                                   class="RadioText" name="CheckBox_CustomDocumentHealthHomeCrisisPlans_SituationsAppropriateToEmergencyDepartmentNA" />
                                                <span class="RadioText">N/A</span>
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
                                <td colspan="2">
                                    <span class="form_label_text" id="Span17">Other types of Crisis, I may encounter (ex.
                                        high risk of homelessness, high risk health conditions, pet/ loved one illness)
                                        and my plan for them</span>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <!-- Table Parent Child Custom Grid Control for CustomDocumentHealthHomeCommPlanFamilyMembers -->
                                    <table cellspacing="0" cellpadding="0" border="0" id="TableChildControl_CustomDocumentHealthHomeCrisisPlanTypes"
                                        parentchildcontrols="True" clearcontrols="true" width="100%">
                                        <tr>
                                            <td>
                                                <!-- Primary and Foreign Keys -->
                                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                    <tr>
                                                        <td width="30%" align="left">
                                                            <label for="TextBox_CustomDocumentHealthHomeCrisisPlanTypes_CrisisTypeName" class="form_label">
                                                                Crisis Type</label>&nbsp&nbsp
                                                            <input type="text" id="TextBox_CustomDocumentHealthHomeCrisisPlanTypes_CrisisTypeName"
                                                                maxlength="300" style="width: 60%;" name="TextBox_CustomDocumentHealthHomeCrisisPlanTypes_CrisisTypeName"
                                                                bindautosaveevents="False" includeinparentchildxml="true" parentchildcontrols="True" required="true"
                                                                class="form_textbox element" />
                                                        </td>
                                                        <td align="left" width="70%" valign="top">
                                                            <label for="TextBox_CustomDocumentHealthHomeCrisisPlanTypes_StepDescription" class="form_label">
                                                                Plan</label>&nbsp&nbsp
                                                            <input type="text" id="TextBox_CustomDocumentHealthHomeCrisisPlanTypes_CrisisTypePlan"
                                                                maxlength="300" style="width: 90%;" name="TextBox_CustomDocumentHealthHomeCrisisPlanTypes_CrisisTypePlan"
                                                                bindautosaveevents="False" includeinparentchildxml="true" parentchildcontrols="True" required="true"
                                                                class="form_textbox element" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2" class="height2">
                                                            <input type="hidden" id="HiddenField_CustomDocumentHealthHomeCrisisPlanTypes_HomeCrisisPlanTypeId"
                                                                name="HiddenField_CustomDocumentHealthHomeCrisisPlanTypes_HomeCrisisPlanTypeId"
                                                                parentchildcontrols="True" includeinparentchildxml="true" value="-1" />
                                                            <input type="hidden" id="HiddenFieldPrimaryKeyHomeCrisisPlanTypeId" name="HiddenFieldPrimaryKeyHomeCrisisPlanTypeId"
                                                                value="HomeCrisisPlanTypeId" parentchildcontrols="True" />
                                                            <input type="hidden" id="HiddenField_CustomDocumentHealthHomeCrisisPlanTypes_DocumentVersionId"
                                                                name="HiddenField_CustomDocumentHealthHomeCrisisPlanTypes_DocumentVersionId"
                                                                value="-1" parentchildcontrols="True" />
                                                                <input type="hidden" id="HiddenField_CustomDocumentHealthHomeCrisisPlanTypes_SequenceNumber" name="HiddenField_CustomDocumentHealthHomeCrisisPlanTypes_SequenceNumber" parentchildcontrols="True" includeinparentchildxml="true" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2" style="text-align: right; padding-right: 100px;">
                                                            <!-- Insert and Clear Buttons for the Parent Table Control -->
                                                            <input type="button" id="TableChildControl_CustomDocumentHealthHomeCrisisPlanTypes_ButtonInsert" name="TableChildControl_CustomDocumentHealthHomeCrisisPlanTypes_ButtonInsert"
                                                                baseurl="<%=ResolveUrl("~") %>"  onclick="return InsertGrid_CustomDocumentHealthHomeCrisisPlanTypesData('TableChildControl_CustomDocumentHealthHomeCrisisPlanTypes','InsertGrid_CustomDocumentHealthHomeCrisisPlanTypes','CustomGrid_CustomDocumentHealthHomeCrisisPlanTypes', this);"
                                                                value="Insert" class="parentchildbutton" />
                                                            <input type="button" id="Button5" onclick="Clear_CustomDocumentHealthHomeCrisisPlanTypes_Data();"
                                                                name="ButtonClear" value="Clear" class="parentchildbutton" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2" class="height2">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2">
                                                            <!-- Parent Child Control Custom Grid -->
                                                            <div id="InsertGrid_CustomDocumentHealthHomeCrisisPlanTypes" style="overflow-x: hidden; overflow-y: auto; height: 100px; width: 100%;">
                                                                <uc1:CustomGrid ID="CustomGrid_CustomDocumentHealthHomeCrisisPlanTypes" runat="server"
                                                                    TableName="CustomDocumentHealthHomeCrisisPlanTypes" PrimaryKey="HomeCrisisPlanTypeId"
                                                                    CustomGridTableName="TableChildControl_CustomDocumentHealthHomeCrisisPlanTypes"
                                                                    GridPageName="CustomDocumentHealthHomeCrisisPlanTypes_Grid" ColumnName="CrisisTypeName:CrisisTypePlan"
                                                                    ColumnHeader="Crisis Type:Plan" ColumnWidth="40%:60%" DivGridName="InsertGrid_CustomDocumentHealthHomeCrisisPlanTypes"
                                                                    InsertButtonId="TableChildControl_CustomDocumentHealthHomeCrisisPlanTypes_ButtonInsert"
                                                                    OrderByQuery="HomeCrisisPlanTypeId" />
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                    <!-- End of Parent Child control table -->
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <span class="form_label_text" id="Span18">Special Situations Planning (ex. care of a
                                        dependent, pet, or a house if client is hospitalized or in long term care)</span>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td style="width: 90%">
                                                <textarea id="TextArea_CustomDocumentHealthHomeCrisisPlans_SpecialSituationsPlan"
                                                    name="TextArea_CustomDocumentHealthHomeCrisisPlans_SpecialSituationsPlan" rows="4"
                                                    cols="158" class="form_textarea" spellcheck="True"></textarea>
                                            </td>
                                            <td style="width: 10%; padding-left: 5px">
                                                <input type="checkbox" id="CheckBox_CustomDocumentHealthHomeCrisisPlans_SpecialSituationsPlanNA"
                                                  class="RadioText" name="CheckBox_CustomDocumentHealthHomeCrisisPlans_SpecialSituationsPlanNA" />
                                                <span class="RadioText">N/A</span>
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
            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                <tr>
                    <td align="left">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                    Professional Involvement
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
                    <td class="content_tab_bg" style="padding-left: 10px; padding-right: 5px">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td colspan="2">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td style="width: 100%">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr>
                                                        <td style="width: 24%">
                                                            <span class="form_label_text" id="Span20">Care Manager Name </span>&nbsp&nbsp
                                                        </td>
                                                        <td style="width: 26%">
                                                            <input type="text" id="TextBox_CustomDocumentHealthHomeCrisisPlans_CareManagerName"
                                                                name="TextBox_CustomDocumentHealthHomeCrisisPlans_CareManagerName" class="form_textbox element"
                                                                style="width: 80%" />
                                                        </td>
                                                        <td style="width: 10%;">
                                                            <span class="form_label_text" id="Span21">Phone</span>&nbsp&nbsp
                                                        </td>
                                                        <td style="width: 40%">
                                                            <input type="text" id="TextBox_CustomDocumentHealthHomeCrisisPlans_CareManagerPhone"
                                                                name="TextBox_CustomDocumentHealthHomeCrisisPlans_CareManagerPhone" class="form_textbox element"
                                                                style="width: 70%" />
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
                                <td colspan="2">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td style="width: 24%">
                                                <span class="form_label_text" id="Span22">Qualified Health Home Specialist Name
                                                </span>&nbsp&nbsp
                                            </td>
                                            <td style="width: 26%">
                                                <input type="text" id="TextBox_CustomDocumentHealthHomeCrisisPlans_QualifiedHealthHomeSpecialistName"
                                                    name="TextBox_CustomDocumentHealthHomeCrisisPlans_QualifiedHealthHomeSpecialistName"
                                                    class="form_textbox element" style="width: 80%" />
                                            </td>
                                            <td style="width: 10%;">
                                                <span class="form_label_text" id="Span23">Phone Number</span>&nbsp&nbsp
                                            </td>
                                            <td style="width: 40%">
                                                <input type="text" id="TextBox_CustomDocumentHealthHomeCrisisPlans_QualifiedHealthHomeSpecialistPhone"
                                                    name="TextBox_CustomDocumentHealthHomeCrisisPlans_QualifiedHealthHomeSpecialistPhone"
                                                    class="form_textbox element" style="width: 70%" />
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
                                <td colspan="2">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td style="width: 24%">
                                                <span class="form_label_text" id="Span24">After Hours Professional Contact </span>
                                            </td>
                                            <td style="width: 26%">
                                                <input type="text" id="TextBox_CustomDocumentHealthHomeCrisisPlans_AfterHoursProfessionalContactName"
                                                    name="TextBox_CustomDocumentHealthHomeCrisisPlans_AfterHoursProfessionalContactName"
                                                    class="form_textbox element" style="width: 80%" />
                                            </td>
                                            <td style="width: 10%;">
                                                <span class="form_label_text" id="Span25">Phone(s)</span>&nbsp&nbsp
                                            </td>
                                            <td style="width: 40%">
                                                <input type="text" id="TextBox_CustomDocumentHealthHomeCrisisPlans_AfterHoursProfessionalContactPhone"
                                                    name="TextBox_CustomDocumentHealthHomeCrisisPlans_AfterHoursProfessionalContactPhone"
                                                    class="form_textbox element" style="width: 70%" />
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
                <tr>
                    <td colspan="2" class="height2">
                    </td>
                </tr>
                <tr>
                    <td>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                            <tr>
                                <td align="left">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                Client Participation
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
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 10px; padding-right: 5px">
                                        <tr>
                                            <td >
                                                <input class="cursor_default" type="checkbox" id="Checkbox_CustomDocumentHealthHomeCrisisPlans_ClientGuardianParticipatedInPlan"
                                                    name="Checkbox_CustomDocumentHealthHomeCrisisPlans_ClientGuardianParticipatedInPlan"
                                                    style="vertical-align: bottom" onclick="" />
                                                <label for="Checkbox_CustomDocumentHealthHomeCrisisPlans_ClientGuardianParticipatedInPlan">
                                                    Client/Guardian participated in this plan and agrees to use the information in
                                                    this plan to update his/her Crisis Plan.</label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height2">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr>
                                                        <td colspan="2">
                                                            <span class="form_label_text" id="Span26">Provider: provide a copy of this plan to the
                                                                client each time it is updated. Also consider providing the client with a quick
                                                                reference wallet crisis plan.</span>
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
        </td>
    </tr>
</table>
<asp:Panel ID="PanelLoadUC" runat="server">
</asp:Panel>