<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CustomIntegratedCarePlan.ascx.cs"
    Inherits="SHS.SmartCare.ActivityPages_Harbor_Client_Detail_Documents_CustomIntegratedCarePlan" %>
<%@ Register Src="~/CommonUserControls/CustomGrid.ascx" TagName="CustomGrid" TagPrefix="uc1" %>
<link href="<%=RelativePath%>App_Themes/Styles/smartcare_styles.css" rel="stylesheet"
    type="text/css" />

<script type="text/javascript" src="<%=RelativePath%>JScripts/ApplicationScripts/GeneralFormFunctions.js"></script>
<script language="javascript" type="text/javascript" src="<%=RelativePath%>Custom/Scripts/CustomIntegratedCarePlan.js" ></script>

<asp:Panel ID="PanelMain" runat="server">
    <style type="text/css">
        #IntegratedCarePlanDiv td.content_tab_bg { padding-left: 8px; }
        #IntegratedCarePlanDiv td.content_tab_top { width: 100%; }
        #IntegratedCarePlanDiv { line-height: 22px; }
        .requiredfield { border-color: red;}
    </style>

    <input id="HiddenFieldPageTables" name="HiddenFieldPageTables" type="hidden" value="CustomDocumentHealthHomeCarePlans,CustomDocumentHealthHomeCarePlanOutcomes,CustomDocumentHealthHomeCarePlanBHGoals,CustomDocumentHealthHomeCarePlanPESNeeds,CustomDocumentHealthHomeCarePlanDiagnoses,CustomDocumentHealthHomeCarePlanLongTermCareOutcomes" />
    <input type="hidden" id="HiddenField_CustomDocumentHealthHomeCarePlans_DocumentVersionId"
        name="HiddenField_CustomDocumentHealthHomeCarePlans_DocumentVersionId" />
    <input type="hidden" id="HiddenField_CustomDocumentHealthHomeCarePlans_RecordDeleted"
        name="HiddenField_CustomDocumentHealthHomeCarePlans_RecordDeleted" />
    <input type="hidden" id="HiddenField_CustomDocumentHealthHomeCarePlans_DeletedBy"
        name="HiddenField_CustomDocumentHealthHomeCarePlans_DeletedBy" />
    <input type="hidden" id="HiddenField_CustomDocumentHealthHomeCarePlans_DeletedDate"
        name="HiddenField_CustomDocumentHealthHomeCarePlans_DeletedDate" />
    <div id="IntegratedCarePlanDiv" class="DocumentScreen">
        <input type="hidden" id="IntegratedCarePlanCreatedBy" name="IntegratedCarePlanCreatedBy"
            value="<%=IntegratedCarePlanCreatedBy %>" />
        <table cellpadding="0" cellspacing="0" border="0">
            <tr>
                <td>
                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                        <tr>
                            <td class="height2">
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                    <tr>
                                        <td class="content_tab_left" align="left" nowrap='nowrap'>
                                            Physical Health
                                        </td>
                                        <td width="17">
                                            <img style="vertical-align: top;" height="26" width="17" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                                        </td>
                                        <td class="content_tab_top" />
                                        <td width="7">
                                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td class="content_tab_bg">
                                <label class="form_label" for="TextBox_CustomDocumentHealthHomeCarePlans_PrimaryCareProviderFirstName">
                                    Primary Care Provider (first name):</label><input type="text" id="TextBox_CustomDocumentHealthHomeCarePlans_PrimaryCareProviderFirstName"
                                        class="form_textbox element" />
                                <label class="form_label" for="TextBox_CustomDocumentHealthHomeCarePlans_PrimaryCareProviderLastName">
                                    Primary Care Provider (last name):</label><input type="text" id="TextBox_CustomDocumentHealthHomeCarePlans_PrimaryCareProviderLastName"
                                        class="form_textbox element" /><br />
                                <label class="form_label" for="TextBox_CustomDocumentHealthHomeCarePlans_PrimaryCareProviderOrganization">
                                    Primary Care Provider Organization (name):</label><input type="text" id="TextBox_CustomDocumentHealthHomeCarePlans_PrimaryCareProviderOrganization"
                                        class="form_textbox element" /><br />
                                <label class="form_label" for="TextArea_CustomDocumentHealthHomeCarePlans_ProblemList">
                                    Problem List:</label><br />
                                <textarea style="width: 600px; height: 60px;" id="TextArea_CustomDocumentHealthHomeCarePlans_ProblemList"
                                    class="form_textbox element"></textarea><br />
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
                                        <td style="vertical-align: top;" class="right_bottom_cont_bottom_bg" align="right"
                                            width="2">
                                            <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_right.gif" />
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
                                        <td class="content_tab_left" align="left" nowrap='nowrap'>
                                            Diagnosis / Treatment Provider
                                        </td>
                                        <td width="17">
                                            <img style="vertical-align: top;" height="26" width="17" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                                        </td>
                                        <td class="content_tab_top" />
                                        <td width="7">
                                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td class="content_tab_bg">
                                <!-- Table Child Control Name -->
                                <table cellspacing="0" cellpasding="0" border="0" id="TableChildControl_CustomDocumentHealthHomeCarePlanDiagnoses"
                                    parentchildcontrols="True">
                                    <tr id="TableChildControl_CustomDocumentHealthHomeCarePlanDiagnoses_DataRow">
                                        <td>
                                            <!-- Primary and Foreign Keys -->
                                            <input type="hidden" id="HiddenFieldPrimaryKey" name="HiddenFieldPrimaryKey" value="CustomDocumentHealthHomeCarePlanDiagnosisId" />
                                            <input type="hidden" id="HiddenFieldForigenKey" name="HiddenFieldForigenKey" value="DocumentVersionId" />
                                            <!-- Table Columns -->
                                            <input type="hidden" id="HiddenField_CustomDocumentHealthHomeCarePlanDiagnoses_CustomDocumentHealthHomeCarePlanDiagnosisId"
                                                name="HiddenField_CustomDocumentHealthHomeCarePlanDiagnoses_CustomDocumentHealthHomeCarePlanDiagnosisId"
                                                bindautosaveevents="False" parentchildcontrols="True" />
                                            <input type="hidden" id="HiddenField_CustomDocumentHealthHomeCarePlanDiagnoses_RecordDeleted"
                                                name="HiddenField_CustomDocumentHealthHomeCarePlanDiagnoses_RecordDeleted" bindautosaveevents="False"
                                                parentchildcontrols="True" />
                                            <input type="hidden" id="HiddenField_CustomDocumentHealthHomeCarePlanDiagnoses_DeletedBy"
                                                name="HiddenField_CustomDocumentHealthHomeCarePlanDiagnoses_DeletedBy" bindautosaveevents="False"
                                                parentchildcontrols="True" />
                                            <input type="hidden" id="HiddenField_CustomDocumentHealthHomeCarePlanDiagnoses_DeletedDate"
                                                name="HiddenField_CustomDocumentHealthHomeCarePlanDiagnoses_DeletedDate" bindautosaveevents="False"
                                                parentchildcontrols="True" />
                                            <input type="hidden" id="HiddenField_CustomDocumentHealthHomeCarePlanDiagnoses_DocumentVersionId"
                                                name="HiddenField_CustomDocumentHealthHomeCarePlanDiagnoses_DocumentVersionId"
                                                bindautosaveevents="False" parentchildcontrols="True" />
                                            <input type="hidden" id="HiddenField_CustomDocumentHealthHomeCarePlanDiagnoses_SequenceNumber"
                                                name="HiddenField_CustomDocumentHealthHomeCarePlanDiagnoses_SequenceNumber" bindautosaveevents="False"
                                                parentchildcontrols="True" />
                                            <label for="TextBox_CustomDocumentHealthHomeCarePlanDiagnoses_ReportedDiagnosis"
                                                class="form_label">
                                                Reported Diagnosis:</label><input type="text" id="TextBox_CustomDocumentHealthHomeCarePlanDiagnoses_ReportedDiagnosis"
                                                    name="TextBox_CustomDocumentHealthHomeCarePlanDiagnoses_ReportedDiagnosis" bindautosaveevents="False" required="true"
                                                    parentchildcontrols="True" class="form_textbox element" style="width: 290px;" />
                                            <label for="TextBox_CustomDocumentHealthHomeCarePlanDiagnoses_TreatmentProvider"
                                                class="form_label">
                                                Treatment Provider:</label><input type="text" id="TextBox_CustomDocumentHealthHomeCarePlanDiagnoses_TreatmentProvider"
                                                    name="TextBox_CustomDocumentHealthHomeCarePlanDiagnoses_TreatmentProvider" bindautosaveevents="False" required="true"
                                                    parentchildcontrols="True" class="form_textbox element" style="width: 290px;" /><br />
                                            <label for="<%=DropDownList_CustomDocumentHealthHomeCarePlanDiagnoses_DiagnosisSource.ClientID %>"
                                                class="form_label">
                                                Source:</label><asp:DropDownList ID="DropDownList_CustomDocumentHealthHomeCarePlanDiagnoses_DiagnosisSource"
                                                    bindautosaveevents="False" parentchildcontrols="True" AddBlankRow="true" Width="300px"
                                                    runat="server">
                                                </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="text-align: right; padding: 10px;">
                                            <input type="button" id="TableChildControl_CustomDocumentHealthHomeCarePlanDiagnoses_ButtonInsert"
                                                name="TableChildControl_CustomDocumentHealthHomeCarePlanDiagnoses_ButtonInsert"
                                                baseurl="<%=ResolveUrl("~") %>" onclick="return CustomIntegratedCarePlan.InsertGrid_CustomDocumentHealthHomeCarePlanDiagnosesData('TableChildControl_CustomDocumentHealthHomeCarePlanDiagnoses','InsertGrid_CustomDocumentHealthHomeCarePlanDiagnoses','CustomGrid_CustomDocumentHealthHomeCarePlanDiagnoses', this);"
                                                value="Insert" class="parentchildbutton" />
                                            <input type="button" id="Button2" onclick="CustomIntegratedCarePlan.Clear_CustomDocumentHealthHomeCarePlanDiagnoses_Data();$('#TextBox_CustomDocumentHealthHomeCarePlanDiagnoses_ReportedDiagnosis').focus();"
                                                    name="ButtonClear" value="Clear" class="parentchildbutton" />
                                        </td>
                                    </tr>
                                    <!-- Custom Grid -->
                                    <tr>
                                        <td>
                                            <div id="InsertGrid_CustomDocumentHealthHomeCarePlanDiagnoses" style="overflow-x: hidden;
                                                overflow-y: auto; height: 100px; width: 99%;">
                                                <uc1:CustomGrid ID="CustomGrid_CustomDocumentHealthHomeCarePlanDiagnoses" width="99%" runat="server"
                                                    TableName="CustomDocumentHealthHomeCarePlanDiagnoses" PrimaryKey="CustomDocumentHealthHomeCarePlanDiagnosisId"
                                                    CustomGridTableName="TableChildControl_CustomDocumentHealthHomeCarePlanDiagnoses"
                                                    GridPageName="CustomDocumentHealthHomeCarePlanDiagnoses_Grid" ColumnName="ReportedDiagnosis:TreatmentProvider"
                                                    ColumnHeader="Reported Diagnosis:Treatment Provider" ColumnWidth="50%:49%" DivGridName="InsertGrid_CustomDocumentHealthHomeCarePlanDiagnoses"
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
                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                    <tr>
                                        <td class="right_bottom_cont_bottom_bg" width="2">
                                            <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_left.gif" />
                                        </td>
                                        <td class="right_bottom_cont_bottom_bg" width="100%">
                                        </td>
                                        <td style="vertical-align: top;" class="right_bottom_cont_bottom_bg" align="right"
                                            width="2">
                                            <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_right.gif" />
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
                                        <td class="content_tab_left" align="left" nowrap='nowrap'>
                                            Outcomes
                                        </td>
                                        <td width="17">
                                            <img style="vertical-align: top;" height="26" width="17" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                                        </td>
                                        <td class="content_tab_top" />
                                        <td width="7">
                                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td class="content_tab_bg">
                                <!-- Table Child Control Name -->
                                <table cellspacing="0" cellpasding="0" border="0" id="TableChildControl_CustomDocumentHealthHomeCarePlanOutcomes"
                                    parentchildcontrols="True">
                                    <tr id="TableChildControl_CustomDocumentHealthHomeCarePlanOutcomes_DataRow">
                                        <td>
                                            <!-- Primary and Foreign Keys -->
                                            <input type="hidden" id="HiddenFieldPrimaryKey" name="HiddenFieldPrimaryKey" value="CustomDocumentHealthHomeCarePlanOutcomeId" />
                                            <input type="hidden" id="HiddenFieldForigenKey" name="HiddenFieldForigenKey" value="DocumentVersionId" />
                                            <!-- Table Columns -->
                                            <input type="hidden" id="HiddenField_CustomDocumentHealthHomeCarePlanOutcomes_CustomDocumentHealthHomeCarePlanOutcomeId"
                                                name="HiddenField_CustomDocumentHealthHomeCarePlanOutcomes_CustomDocumentHealthHomeCarePlanOutcomeId"
                                                bindautosaveevents="False" parentchildcontrols="True" />
                                            <input type="hidden" id="HiddenField_CustomDocumentHealthHomeCarePlanOutcomes_RecordDeleted"
                                                name="HiddenField_CustomDocumentHealthHomeCarePlanOutcomes_RecordDeleted" bindautosaveevents="False"
                                                parentchildcontrols="True" />
                                            <input type="hidden" id="HiddenField_CustomDocumentHealthHomeCarePlanOutcomes_DeletedBy"
                                                name="HiddenField_CustomDocumentHealthHomeCarePlanOutcomes_DeletedBy" bindautosaveevents="False"
                                                parentchildcontrols="True" />
                                            <input type="hidden" id="HiddenField_CustomDocumentHealthHomeCarePlanOutcomes_DeletedDate"
                                                name="HiddenField_CustomDocumentHealthHomeCarePlanOutcomes_DeletedDate" bindautosaveevents="False"
                                                parentchildcontrols="True" />
                                            <input type="hidden" id="HiddenField_CustomDocumentHealthHomeCarePlanOutcomes_DocumentVersionId"
                                                name="HiddenField_CustomDocumentHealthHomeCarePlanOutcomes_DocumentVersionId"
                                                bindautosaveevents="False" parentchildcontrols="True" />
                                            <input type="hidden" id="HiddenField_CustomDocumentHealthHomeCarePlanOutcomes_OutcomeSequence"
                                                name="HiddenField_CustomDocumentHealthHomeCarePlanOutcomes_OutcomeSequence" bindautosaveevents="False"
                                                parentchildcontrols="True" />
                                            <div style="float: left;">
                                                <label for="TextArea_CustomDocumentHealthHomeCarePlanOutcomes_OutcomeDescription"
                                                    class="form_label">
                                                    Expected Outcomes:</label><br />
                                                <textarea required="true" style="width: 330px; height: 60px;" id="TextArea_CustomDocumentHealthHomeCarePlanOutcomes_OutcomeDescription"
                                                    name="TextArea_CustomDocumentHealthHomeCarePlanOutcomes_OutcomeDescription" bindautosaveevents="False"
                                                    parentchildcontrols="True" class="form_textbox element"></textarea>
                                            </div>
                                            <div style="float: left; margin-left: 10px;">
                                                <label for="TextArea_CustomDocumentHealthHomeCarePlanOutcomes_OutcomeCriteria" class="form_label">
                                                    Outcome Criteria:</label><br />
                                                <textarea required="true" style="width: 330px; height: 60px;" id="TextArea_CustomDocumentHealthHomeCarePlanOutcomes_OutcomeCriteria"
                                                    name="TextArea_CustomDocumentHealthHomeCarePlanOutcomes_OutcomeCriteria" bindautosaveevents="False"
                                                    parentchildcontrols="True" class="form_textbox element"></textarea>
                                            </div>
                                            <div style="float: left; margin-left: 10px;">
                                                <label for="TextBox_CustomDocumentHealthHomeCarePlanOutcomes_TargetDate" class="form_label">
                                                    Target Date:</label><br />
                                                <input required="true" datatype="Date" type="text" id="TextBox_CustomDocumentHealthHomeCarePlanOutcomes_TargetDate"
                                                    name="TextBox_CustomDocumentHealthHomeCarePlanOutcomes_TargetDate" bindautosaveevents="False"
                                                    donotclear="true" parentchildcontrols="True" class="form_textbox date_text" />
                                                <img style="cursor: default" id="img_CustomDocumentHealthHomeCarePlanOutcomes_TargetDate"
                                                    src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif" onclick="return showCalendar('TextBox_CustomDocumentHealthHomeCarePlanOutcomes_TargetDate', '%m/%d/%Y');"
                                                    alt="calendar" />
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="text-align: right; padding: 10px;">
                                            <input type="button" id="TableChildControl_CustomDocumentHealthHomeCarePlanOutcomes_ButtonInsert"
                                                name="TableChildControl_CustomDocumentHealthHomeCarePlanOutcomes_ButtonInsert"
                                                baseurl="<%=ResolveUrl("~") %>" onclick="return CustomIntegratedCarePlan.InsertGrid_CustomDocumentHealthHomeCarePlanOutcomesData('TableChildControl_CustomDocumentHealthHomeCarePlanOutcomes','InsertGrid_CustomDocumentHealthHomeCarePlanOutcomes','CustomGrid_CustomDocumentHealthHomeCarePlanOutcomes', this);"
                                                value="Insert" class="parentchildbutton" />
                                            <input type="button" id="Button1" onclick="CustomIntegratedCarePlan.Clear_CustomDocumentHealthHomeCarePlanOutcomes_Data();$('#TextArea_CustomDocumentHealthHomeCarePlanOutcomes_OutcomeDescription').fosus();"
                                                    name="ButtonClear" value="Clear" class="parentchildbutton" />
                                        </td>
                                    </tr>
                                    <!-- Custom Grid -->
                                    <tr>
                                        <td>
                                            <div id="InsertGrid_CustomDocumentHealthHomeCarePlanOutcomes" style="overflow-x: hidden;
                                                overflow-y: auto; height: 100px; width: 99%;">
                                                <uc1:CustomGrid ID="CustomGrid_CustomDocumentHealthHomeCarePlanOutcomes" runat="server" width= "99%"
                                                    TableName="CustomDocumentHealthHomeCarePlanOutcomes" PrimaryKey="CustomDocumentHealthHomeCarePlanOutcomeId"
                                                    CustomGridTableName="TableChildControl_CustomDocumentHealthHomeCarePlanOutcomes"
                                                    GridPageName="CustomDocumentHealthHomeCarePlanOutcomes_Grid" ColumnName="OutcomeDescription:OutcomeCriteria:TargetDate"
                                                    ColumnHeader="Expected Outcomes:Outcome Criteria:Target Date" ColumnWidth="40%:40%:19%"
                                                    ColumnFormat="::date" DivGridName="InsertGrid_CustomDocumentHealthHomeCarePlanOutcomes"
                                                    InsertButtonId="TableChildControl_CustomDocumentHealthHomeCarePlanOutcomes_ButtonInsert"
                                                    OrderByQuery="CustomDocumentHealthHomeCarePlanOutcomeId" />
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                                <label class="form_label" for="CheckBox_CustomDocumentHealthHomeCarePlans_ClientHasLivingWillOrDurablePOA">
                                    Does the client have a Living Will or a Durable Power of Attorney?</label>
                                <input type="radio" id="CheckBox_CustomDocumentHealthHomeCarePlans_ClientHasLivingWillOrDurablePOA_Y"
                                    name="CheckBox_CustomDocumentHealthHomeCarePlans_ClientHasLivingWillOrDurablePOA" value="Y"
                                    class="form_checkbox element YorN" /><label class="form_label" for="CheckBox_CustomDocumentHealthHomeCarePlans_ClientHasLivingWillOrDurablePOA_Y">Yes</label>
                                <input type="radio" id="CheckBox_CustomDocumentHealthHomeCarePlans_ClientHasLivingWillOrDurablePOA_N"
                                    name="CheckBox_CustomDocumentHealthHomeCarePlans_ClientHasLivingWillOrDurablePOA" value="N"
                                    class="form_checkbox element YorN" /><label class="form_label" for="CheckBox_CustomDocumentHealthHomeCarePlans_ClientHasLivingWillOrDurablePOA_N">No</label><br />
                                <span class="form_label">If yes, scan/ upload a copy to the client’s record.</span>
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
                                        <td style="vertical-align: top;" class="right_bottom_cont_bottom_bg" align="right"
                                            width="2">
                                            <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_right.gif" />
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
                                        <td class="content_tab_left" align="left" nowrap='nowrap'>
                                            Behavioral Health Care
                                        </td>
                                        <td width="17">
                                            <img style="vertical-align: top;" height="26" width="17" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                                        </td>
                                        <td class="content_tab_top" />
                                        <td width="7">
                                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td class="content_tab_bg">
                                <p>
                                    <table cellspacing="0" cellpasding="0" border="0" id="TableChildControl_CustomDocumentHealthHomeCarePlanBHGoals"
                                        parentchildcontrols="True">
                                        <tr id="TableChildControl_CustomDocumentHealthHomeCarePlanBHGoals_DataRow">
                                            <td>
                                                <input type="hidden" id="HiddenFieldPrimaryKey" name="HiddenFieldPrimaryKey" value="CustomDocumentHealthHomeCarePlanBHGoalId" />
                                                <input type="hidden" id="HiddenFieldForigenKey" name="HiddenFieldForigenKey" value="DocumentVersionId" />
                                                <input bindautosaveevents="False" parentchildcontrols="True" type="hidden" id="HiddenField_CustomDocumentHealthHomeCarePlanBHGoals_CustomDocumentHealthHomeCarePlanBHGoalId"
                                                    name="HiddenField_CustomDocumentHealthHomeCarePlanBHGoals_CustomDocumentHealthHomeCarePlanBHGoalId" />
                                                <input bindautosaveevents="False" parentchildcontrols="True" type="hidden" id="HiddenField_CustomDocumentHealthHomeCarePlanBHGoals_RecordDeleted"
                                                    name="HiddenField_CustomDocumentHealthHomeCarePlanBHGoals_RecordDeleted" />
                                                <input bindautosaveevents="False" parentchildcontrols="True" type="hidden" id="HiddenField_CustomDocumentHealthHomeCarePlanBHGoals_DeletedBy"
                                                    name="HiddenField_CustomDocumentHealthHomeCarePlanBHGoals_DeletedBy" />
                                                <input bindautosaveevents="False" parentchildcontrols="True" type="hidden" id="HiddenField_CustomDocumentHealthHomeCarePlanBHGoals_DeletedDate"
                                                    name="HiddenField_CustomDocumentHealthHomeCarePlanBHGoals_DeletedDate" />
                                                <input bindautosaveevents="False" parentchildcontrols="True" type="hidden" id="HiddenField_CustomDocumentHealthHomeCarePlanBHGoals_DocumentVersionId"
                                                    name="HiddenField_CustomDocumentHealthHomeCarePlanBHGoals_DocumentVersionId" />
                                                <input bindautosaveevents="False" parentchildcontrols="True" type="hidden" id="HiddenField_CustomDocumentHealthHomeCarePlanBHGoals_GoalNumber"
                                                    name="HiddenField_CustomDocumentHealthHomeCarePlanBHGoals_GoalNumber" />
                                                <input type="hidden" id="HiddenField_CustomDocumentHealthHomeCarePlanBHGoals_SourceDocumentVersionId"
                                                    name="HiddenField_CustomDocumentHealthHomeCarePlanBHGoals_SourceDocumentVersionId"
                                                    bindautosaveevents="False" parentchildcontrols="True" />
                                                <label for="TextBox_CustomDocumentHealthHomeCarePlanBHGoals_GoalProvider" class="form_label">
                                                    Provider:
                                                </label>
                                                <input bindautosaveevents="False" parentchildcontrols="True" type="text" id="TextBox_CustomDocumentHealthHomeCarePlanBHGoals_GoalProvider"
                                                    name="TextBox_CustomDocumentHealthHomeCarePlanBHGoals_GoalProvider" class="form_textbox element"
                                                    style="width: 300px;" /><br />
                                                <div style="float: left; clear: left;">
                                                    <label for="TextArea_CustomDocumentHealthHomeCarePlanBHGoals_NeedDescription" class="form_label">
                                                        Need:</label><br />
                                                    <textarea bindautosaveevents="False" parentchildcontrols="True" style="width: 600px;
                                                        height: 60px;" id="TextArea_CustomDocumentHealthHomeCarePlanBHGoals_NeedDescription"
                                                        name="TextArea_CustomDocumentHealthHomeCarePlanBHGoals_NeedDescription" class="form_textbox element"></textarea>
                                                </div>
                                                <div style="float: left; margin-left: 30px;">
                                                    <label for="TextBox_CustomDocumentHealthHomeCarePlanBHGoals_NeedIdentifiedDate" class="form_label">
                                                        Need Identified:</label><br />
                                                    <input bindautosaveevents="False" parentchildcontrols="True" type="text" id="TextBox_CustomDocumentHealthHomeCarePlanBHGoals_NeedIdentifiedDate" datatype="date"
                                                        donotclear="true" name="TextBox_CustomDocumentHealthHomeCarePlanBHGoals_NeedIdentifiedDate"
                                                        class="form_textbox date_text" />
                                                    <img style="cursor: default" id="img_CustomDocumentHealthHomeCarePlanBHGoals_NeedIdentifiedDate"
                                                        src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif" onclick="return showCalendar('TextBox_CustomDocumentHealthHomeCarePlanBHGoals_NeedIdentifiedDate', '%m/%d/%Y');"
                                                        alt="calendar" />
                                                </div>
                                                <div style="float: left; clear: left;">
                                                    <label for="TextArea_CustomDocumentHealthHomeCarePlanBHGoals_GoalDescription" class="form_label">
                                                        Goal:</label><br />
                                                    <textarea bindautosaveevents="False" parentchildcontrols="True" style="width: 600px;
                                                        height: 60px;" id="TextArea_CustomDocumentHealthHomeCarePlanBHGoals_GoalDescription"
                                                        name="TextArea_CustomDocumentHealthHomeCarePlanBHGoals_GoalDescription" required="true" class="form_textbox element"></textarea>
                                                </div>
                                                <div style="float: left; margin-left: 30px;">
                                                    <label for="TextBox_CustomDocumentHealthHomeCarePlanBHGoals_GoalTargetDate" class="form_label">
                                                        Target Date:</label><br />
                                                    <input bindautosaveevents="False" parentchildcontrols="True" type="text" id="TextBox_CustomDocumentHealthHomeCarePlanBHGoals_GoalTargetDate"
                                                        donotclear="true" name="TextBox_CustomDocumentHealthHomeCarePlanBHGoals_GoalTargetDate" datatype="date" required="true"
                                                        class="form_textbox date_text" />
                                                    <img style="cursor: default" id="img_CustomDocumentHealthHomeCarePlanBHGoals_GoalTargetDate"
                                                        src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif" onclick="return showCalendar('TextBox_CustomDocumentHealthHomeCarePlanBHGoals_GoalTargetDate', '%m/%d/%Y');"
                                                        alt="calendar" /><br />
                                                </div>
                                                <div style="float: left; clear: left;">
                                                    <label for="TextArea_CustomDocumentHealthHomeCarePlanBHGoals_GoalObjectives" class="form_label">
                                                        Objectives:</label><br />
                                                    <textarea bindautosaveevents="False" parentchildcontrols="True" id="TextArea_CustomDocumentHealthHomeCarePlanBHGoals_GoalObjectives"
                                                        name="TextArea_CustomDocumentHealthHomeCarePlanBHGoals_GoalObjectives" class="form_textbox element"
                                                        style="width: 600px; height: 60px;"></textarea>
                                                </div>
                                                <div style="float: left; clear: left;">
                                                    <label for="TextArea_CustomDocumentHealthHomeCarePlanBHGoals_GoalServices" class="form_label">
                                                        Services:</label><br />
                                                    <textarea bindautosaveevents="False" parentchildcontrols="True" id="TextArea_CustomDocumentHealthHomeCarePlanBHGoals_GoalServices"
                                                        name="TextArea_CustomDocumentHealthHomeCarePlanBHGoals_GoalServices" class="form_textbox element" required="true"
                                                        style="width: 600px; height: 60px;"></textarea>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="text-align: right; padding: 10px;">
                                                <input type="button" id="TableChildControl_CustomDocumentHealthHomeCarePlanBHGoals_ButtonInsert"
                                                    name="TableChildControl_CustomDocumentHealthHomeCarePlanBHGoals_ButtonInsert"
                                                    baseurl="<%=ResolveUrl("~") %>" onclick="return CustomIntegratedCarePlan.InsertGrid_CustomDocumentHealthHomeCarePlanBHGoalsData('TableChildControl_CustomDocumentHealthHomeCarePlanBHGoals','InsertGrid_CustomDocumentHealthHomeCarePlanBHGoals','CustomGrid_CustomDocumentHealthHomeCarePlanBHGoals', this);"
                                                    value="Insert" class="parentchildbutton" />
                                                <input type="button" id="ButtonClear" onclick="CustomIntegratedCarePlan.Clear_CustomDocumentHealthHomeCarePlanBHGoals_Data();$('#TextBox_CustomDocumentHealthHomeCarePlanBHGoals_GoalProvider').focus();"
                                                    name="ButtonClear" value="Clear" class="parentchildbutton" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <div id="InsertGrid_CustomDocumentHealthHomeCarePlanBHGoals" style="overflow-x: hidden;
                                                    overflow-y: auto; height: 100px; width: 99%;">
                                                    <uc1:CustomGrid ID="CustomGrid_CustomDocumentHealthHomeCarePlanBHGoals" runat="server" width= "99%"
                                                        TableName="CustomDocumentHealthHomeCarePlanBHGoals" PrimaryKey="CustomDocumentHealthHomeCarePlanBHGoalId"
                                                        CustomGridTableName="TableChildControl_CustomDocumentHealthHomeCarePlanBHGoals"
                                                        GridPageName="CustomDocumentHealthHomeCarePlanBHGoalsGrid" ColumnName="GoalDescription:GoalServices:GoalTargetDate:NeedIdentifiedDate"
                                                        ColumnHeader="Goal:Services:Target Date:" ColumnWidth="40%:40%:19%" DivGridName="InsertGrid_CustomDocumentHealthHomeCarePlanBHGoals"
                                                        InsertButtonId="TableChildControl_CustomDocumentHealthHomeCarePlanBHGoals_ButtonInsert" ColumnFormat="::date:date"
                                                        OrderByQuery="NeedIdentifiedDate" />
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </p>
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
                                        <td style="vertical-align: top;" class="right_bottom_cont_bottom_bg" align="right"
                                            width="2">
                                            <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_right.gif" />
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
                                        <td class="content_tab_left" align="left" nowrap='nowrap'>
                                            Psychosocial and Environmental Support Needs
                                        </td>
                                        <td width="17">
                                            <img style="vertical-align: top;" height="26" width="17" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                                        </td>
                                        <td class="content_tab_top" />
                                        <td width="7">
                                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td class="content_tab_bg">
                                <!-- Table Child Control Name -->
                                <table cellspacing="0" cellpasding="0" border="0" id="TableChildControl_CustomDocumentHealthHomeCarePlanPESNeeds"
                                    parentchildcontrols="True">
                                    <tr id="TableChildControl_CustomDocumentHealthHomeCarePlanPESNeeds_DataRow">
                                        <td>
                                            <!-- Primary and Foreign Keys -->
                                            <input type="hidden" id="HiddenFieldPrimaryKey" name="HiddenFieldPrimaryKey" value="CustomDocumentHealthHomeCarePlanPESNeedId" />
                                            <input type="hidden" id="HiddenFieldForigenKey" name="HiddenFieldForigenKey" value="DocumentVersionId" />
                                            <!-- Table Columns -->
                                            <input type="hidden" id="HiddenField_CustomDocumentHealthHomeCarePlanPESNeeds_CustomDocumentHealthHomeCarePlanPESNeedId"
                                                name="HiddenField_CustomDocumentHealthHomeCarePlanPESNeeds_CustomDocumentHealthHomeCarePlanPESNeedId"
                                                bindautosaveevents="False" parentchildcontrols="True" />
                                            <input type="hidden" id="HiddenField_CustomDocumentHealthHomeCarePlanPESNeeds_RecordDeleted"
                                                name="HiddenField_CustomDocumentHealthHomeCarePlanPESNeeds_RecordDeleted" bindautosaveevents="False"
                                                parentchildcontrols="True" />
                                            <input type="hidden" id="HiddenField_CustomDocumentHealthHomeCarePlanPESNeeds_DeletedBy"
                                                name="HiddenField_CustomDocumentHealthHomeCarePlanPESNeeds_DeletedBy" bindautosaveevents="False"
                                                parentchildcontrols="True" />
                                            <input type="hidden" id="HiddenField_CustomDocumentHealthHomeCarePlanPESNeeds_DeletedDate"
                                                name="HiddenField_CustomDocumentHealthHomeCarePlanPESNeeds_DeletedDate" bindautosaveevents="False"
                                                parentchildcontrols="True" />
                                            <input type="hidden" id="HiddenField_CustomDocumentHealthHomeCarePlanPESNeeds_DocumentVersionId"
                                                name="HiddenField_CustomDocumentHealthHomeCarePlanPESNeeds_DocumentVersionId"
                                                bindautosaveevents="False" parentchildcontrols="True" />
                                            <input type="hidden" id="HiddenField_CustomDocumentHealthHomeCarePlanPESNeeds_PsychosocialSupportNeedSequence"
                                                name="HiddenField_CustomDocumentHealthHomeCarePlanPESNeeds_PsychosocialSupportNeedSequence"
                                                bindautosaveevents="False" parentchildcontrols="True" />
                                            <input type="hidden" id="HiddenField_CustomDocumentHealthHomeCarePlanPESNeeds_PsychosocialSupportNeedTypeName"
                                                name="HiddenField_CustomDocumentHealthHomeCarePlanPESNeeds_PsychosocialSupportNeedTypeName"
                                                bindautosaveevents="False" parentchildcontrols="True" />
                                            <label for="<%=DropDownList_CustomDocumentHealthHomeCarePlanPESNeeds_PsychosocialSupportNeedType.ClientID %>"
                                                class="form_label">
                                                Need:
                                            </label>
                                            <asp:DropDownList ID="DropDownList_CustomDocumentHealthHomeCarePlanPESNeeds_PsychosocialSupportNeedType"
                                                bindautosaveevents="False" parentchildcontrols="True" AddBlankRow="true" Width="300px" runat="server">
                                            </asp:DropDownList>
                                            <br />
                                            <label for="TextArea_CustomDocumentHealthHomeCarePlanPESNeeds_PsychosocialSupportNeedPlan"
                                                class="form_label">
                                                Plan:</label><br />
                                            <textarea id="TextArea_CustomDocumentHealthHomeCarePlanPESNeeds_PsychosocialSupportNeedPlan"
                                                name="TextArea_CustomDocumentHealthHomeCarePlanPESNeeds_PsychosocialSupportNeedPlan"
                                                bindautosaveevents="False" parentchildcontrols="True" class="form_textbox element" required="true"
                                                style="width: 600px; height: 60px;"></textarea>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="text-align: right; padding: 10px;">
                                            <input type="button" id="TableChildControl_CustomDocumentHealthHomeCarePlanPESNeeds_ButtonInsert"
                                                name="TableChildControl_CustomDocumentHealthHomeCarePlanPESNeeds_ButtonInsert"
                                                baseurl="<%=ResolveUrl("~") %>" onclick="return CustomIntegratedCarePlan.InsertGrid_CustomDocumentHealthHomeCarePlanPESNeedsData('TableChildControl_CustomDocumentHealthHomeCarePlanPESNeeds','InsertGrid_CustomDocumentHealthHomeCarePlanPESNeeds','CustomGrid_CustomDocumentHealthHomeCarePlanPESNeeds', this);"
                                                value="Insert" class="parentchildbutton" />
                                            <input type="button" id="Button3" onclick="CustomIntegratedCarePlan.Clear_CustomDocumentHealthHomeCarePlanPESNeeds_Data();$('[Id$=DropDownList_CustomDocumentHealthHomeCarePlanPESNeeds_PsychosocialSupportNeedType]').focus();"
                                                    name="ButtonClear" value="Clear" class="parentchildbutton" />
                                        </td>
                                    </tr>
                                    <!-- Custom Grid -->
                                    <tr>
                                        <td>
                                            <div id="InsertGrid_CustomDocumentHealthHomeCarePlanPESNeeds" style="overflow-x: hidden;
                                                overflow-y: auto; height: 100px; width: 99%;">
                                                <uc1:CustomGrid ID="CustomGrid_CustomDocumentHealthHomeCarePlanPESNeeds" runat="server" width="99%"
                                                    TableName="CustomDocumentHealthHomeCarePlanPESNeeds" PrimaryKey="CustomDocumentHealthHomeCarePlanPESNeedId"
                                                    CustomGridTableName="TableChildControl_CustomDocumentHealthHomeCarePlanPESNeeds"
                                                    GridPageName="CustomDocumentHealthHomeCarePlanPESNeeds_Grid" ColumnName="PsychosocialSupportNeedTypeName:PsychosocialSupportNeedPlan"
                                                    ColumnHeader="Need:Plan" ColumnWidth="50%:49%" DivGridName="InsertGrid_CustomDocumentHealthHomeCarePlanPESNeeds"
                                                    InsertButtonId="TableChildControl_CustomDocumentHealthHomeCarePlanPESNeeds_ButtonInsert"
                                                    OrderByQuery="CustomDocumentHealthHomeCarePlanPESNeedId" />
                                            </div>
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
                                        <td style="vertical-align: top;" class="right_bottom_cont_bottom_bg" align="right"
                                            width="2">
                                            <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_right.gif" />
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
                                        <td class="content_tab_left" align="left" nowrap='nowrap'>
                                            Long Term Care Needs
                                        </td>
                                        <td width="17">
                                            <img style="vertical-align: top;" height="26" width="17" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                                        </td>
                                        <td class="content_tab_top" />
                                        <td width="7">
                                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td class="content_tab_bg">
                                <p>
                                    <input type="checkbox" id="CheckBox_CustomDocumentHealthHomeCarePlans_LongTermCareNotNeeded"
                                        name="CheckBox_CustomDocumentHealthHomeCarePlans_LongTermCareNotNeeded" class="form_checkbox element YorN" />
                                    <label for="CheckBox_CustomDocumentHealthHomeCarePlans_LongTermCareNotNeeded">
                                        Long Term Care Not Needed</label><br />
                                    <input type="checkbox" id="CheckBox_CustomDocumentHealthHomeCarePlans_LongTermCareNeeded"
                                        name="CheckBox_CustomDocumentHealthHomeCarePlans_LongTermCareNeeded" class="form_checkbox element YorN" /><label
                                            for="CheckBox_CustomDocumentHealthHomeCarePlans_LongTermCareNeeded" style="margin-left: 3px;">Long
                                            Term Care Needed (30 days or longer)</label>
                                    <span style="display: block; margin-left: 30px;">
                                        <label for="<%=DropDownList_CustomDocumentHealthHomeCarePlans_AdmitToFacilityType.ClientID %>" class="form_label">
                                            Type:</label>
                                        <asp:DropDownList ID="DropDownList_CustomDocumentHealthHomeCarePlans_AdmitToFacilityType" AddBlankRow="true"
                                            Width="290px" runat="server">
                                        </asp:DropDownList>
                                        <br />
                                        <label for="TextBox_CustomDocumentHealthHomeCarePlans_AdmitToFacility" class="form_label">
                                            Admit To:</label><input type="text" id="TextBox_CustomDocumentHealthHomeCarePlans_AdmitToFacility"
                                                name="TextBox_CustomDocumentHealthHomeCarePlans_AdmitToFacility" class="form_textbox element"
                                                style="width: 400px;" />
                                        <input type="checkbox" id="CheckBox_CustomDocumentHealthHomeCarePlans_AdmitToFacilityNotApplicable"
                                            class="form_checkbox element YorN" /><label for="CheckBox_CustomDocumentHealthHomeCarePlans_AdmitToFacilityNotApplicable"
                                                class="form_label">N/A (in home)</label>
                                        <div style="float: left;">
                                            <label for="TextArea_CustomDocumentHealthHomeCarePlans_AdmissionComments" class="form_label">
                                                Admission Comments:</label><br />
                                            <textarea style="width: 400px; height: 60px;" id="TextArea_CustomDocumentHealthHomeCarePlans_AdmissionComments"
                                                class="form_textbox element"></textarea>
                                        </div>
                                        <div style="float: left; margin-left: 30px;">
                                            <label for="TextBox_CustomDocumentHealthHomeCarePlans_PrimaryTreatingProviderInCare"
                                                class="form_label">
                                                Primary treating provider in care:</label><br />
                                            <input type="text" id="TextBox_CustomDocumentHealthHomeCarePlans_PrimaryTreatingProviderInCare"
                                                class="form_textbox element" style="width: 200px;" /><input type="checkbox" id="CheckBox1"
                                                    class="form_checkbox element YorN" style="margin-left: 5px;" /><label for="TextBox_CustomDocumentHealthHomeCarePlans_PrimaryTreatingProviderInCare"
                                                        class="form_label">N/A</label>
                                        </div>
                                    </span>
                                    <div style="clear: left; padding-top: 10px;">
                                        <div style="width: 99%; height: 1px; border-top-color: #c5d5e5; border-top-width: 2px;
                                            margin-bottom: 5px; border-top-style: dashed;">
                                            &nbsp;</div>
                                        <!-- Table Parent Child Custom Grid Control for CustomDocumentHealthHomeCarePlanLongTermCareOutcomes -->
                                        <table cellspacing="0" cellpasding="0" border="0" id="TableChildControl_CustomDocumentHealthHomeCarePlanLongTermCareOutcomes"
                                            parentchildcontrols="True">
                                            <tr id="TableChildControl_CustomDocumentHealthHomeCarePlanLongTermCareOutcomes_DataRow">
                                                <td>
                                                    <!-- Primary and Foreign Keys -->
                                                    <input type="hidden" id="HiddenFieldPrimaryKey" name="HiddenFieldPrimaryKey" value="CustomDocumentHealthHomeCarePlanLongTermCareOutcomeId" />
                                                    <input type="hidden" id="HiddenFieldForigenKey" name="HiddenFieldForigenKey" value="DocumentVersionId" />
                                                    <!-- Columns defined in the table and used inside the Parent Child Control -->
                                                    <input type="hidden" id="HiddenField_CustomDocumentHealthHomeCarePlanLongTermCareOutcomes_CustomDocumentHealthHomeCarePlanLongTermCareOutcomeId"
                                                        name="HiddenField_CustomDocumentHealthHomeCarePlanLongTermCareOutcomes_CustomDocumentHealthHomeCarePlanLongTermCareOutcomeId"
                                                        bindautosaveevents="False" parentchildcontrols="True" />
                                                    <input type="hidden" id="HiddenField_CustomDocumentHealthHomeCarePlanLongTermCareOutcomes_RecordDeleted"
                                                        name="HiddenField_CustomDocumentHealthHomeCarePlanLongTermCareOutcomes_RecordDeleted"
                                                        bindautosaveevents="False" parentchildcontrols="True" />
                                                    <input type="hidden" id="HiddenField_CustomDocumentHealthHomeCarePlanLongTermCareOutcomes_DeletedBy"
                                                        name="HiddenField_CustomDocumentHealthHomeCarePlanLongTermCareOutcomes_DeletedBy"
                                                        bindautosaveevents="False" parentchildcontrols="True" />
                                                    <input type="hidden" id="HiddenField_CustomDocumentHealthHomeCarePlanLongTermCareOutcomes_DeletedDate"
                                                        name="HiddenField_CustomDocumentHealthHomeCarePlanLongTermCareOutcomes_DeletedDate"
                                                        bindautosaveevents="False" parentchildcontrols="True" />
                                                    <input type="hidden" id="HiddenField_CustomDocumentHealthHomeCarePlanLongTermCareOutcomes_DocumentVersionId"
                                                        name="HiddenField_CustomDocumentHealthHomeCarePlanLongTermCareOutcomes_DocumentVersionId"
                                                        bindautosaveevents="False" parentchildcontrols="True" />
                                                    <input type="hidden" id="HiddenField_CustomDocumentHealthHomeCarePlanLongTermCareOutcomes_OutcomeSequence"
                                                        name="HiddenField_CustomDocumentHealthHomeCarePlanLongTermCareOutcomes_OutcomeSequence"
                                                        bindautosaveevents="False" parentchildcontrols="True" />
                                                    <div style="float: left;">
                                                        <label for="TextArea_CustomDocumentHealthHomeCarePlanLongTermCareOutcomes_OutcomeDescription"
                                                            class="form_label">
                                                            Expected Outcome:</label><br />
                                                        <textarea id="TextArea_CustomDocumentHealthHomeCarePlanLongTermCareOutcomes_OutcomeDescription"
                                                            name="TextArea_CustomDocumentHealthHomeCarePlanLongTermCareOutcomes_OutcomeDescription"
                                                            bindautosaveevents="False" parentchildcontrols="True" class="form_textbox element" required="true"
                                                            style="width: 400px; height: 60px;"></textarea>
                                                    </div>
                                                    <div style="float: left; margin-left: 10px;">
                                                        <label for="TextBox_CustomDocumentHealthHomeCarePlanLongTermCareOutcomes_TargetDate"
                                                            class="form_label">
                                                            Target Date:</label><br />
                                                        <input type="text" id="TextBox_CustomDocumentHealthHomeCarePlanLongTermCareOutcomes_TargetDate"
                                                            name="TextBox_CustomDocumentHealthHomeCarePlanLongTermCareOutcomes_TargetDate" required="true"
                                                            donotclear="true" bindautosaveevents="False" parentchildcontrols="True" class="form_textbox date_text" />
                                                        <img style="cursor: default" id="img_CustomDocumentHealthHomeCarePlanLongTermCareOutcomes_TargetDate"
                                                            src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif" onclick="return showCalendar('TextBox_CustomDocumentHealthHomeCarePlanLongTermCareOutcomes_TargetDate', '%m/%d/%Y');"
                                                            alt="calendar" />
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="text-align: right; padding: 10px;">
                                                    <!-- Insert and Clear Buttons for the Parent Table Control -->
                                                    <input type="button" id="TableChildControl_CustomDocumentHealthHomeCarePlanLongTermCareOutcomes_ButtonInsert"
                                                        name="TableChildControl_CustomDocumentHealthHomeCarePlanLongTermCareOutcomes_ButtonInsert"
                                                        baseurl="<%=ResolveUrl("~") %>" onclick="return CustomIntegratedCarePlan.InsertGrid_CustomDocumentHealthHomeCarePlanLongTermCareOutcomesData('TableChildControl_CustomDocumentHealthHomeCarePlanLongTermCareOutcomes','InsertGrid_CustomDocumentHealthHomeCarePlanLongTermCareOutcomes','CustomGrid_CustomDocumentHealthHomeCarePlanLongTermCareOutcomes', this);"
                                                        value="Insert" class="parentchildbutton" />
                                                    <input type="button" id="Button4" onclick="CustomIntegratedCarePlan.Clear_CustomDocumentHealthHomeCarePlanLongTermCareOutcomes_Data();$('#TextArea_CustomDocumentHealthHomeCarePlanLongTermCareOutcomes_OutcomeDescription').focus();"
                                                            name="ButtonClear" value="Clear" class="parentchildbutton" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <!-- Parent Child Control Custom Grid -->
                                                    <div id="InsertGrid_CustomDocumentHealthHomeCarePlanLongTermCareOutcomes" style="overflow-x: hidden;
                                                        overflow-y: auto; height: 100px; width: 99%;">
                                                        <uc1:CustomGrid ID="CustomGrid_CustomDocumentHealthHomeCarePlanLongTermCareOutcomes" width="99%" 
                                                            runat="server" TableName="CustomDocumentHealthHomeCarePlanLongTermCareOutcomes"
                                                            PrimaryKey="CustomDocumentHealthHomeCarePlanLongTermCareOutcomeId" CustomGridTableName="TableChildControl_CustomDocumentHealthHomeCarePlanLongTermCareOutcomes"
                                                            GridPageName="CustomDocumentHealthHomeCarePlanLongTermCareOutcomes_Grid" ColumnName="OutcomeDescription:TargetDate"
                                                            ColumnFormat=":date" ColumnHeader="Expected Outcomes:Target Date" ColumnWidth="70%:29%"
                                                            DivGridName="InsertGrid_CustomDocumentHealthHomeCarePlanLongTermCareOutcomes"
                                                            InsertButtonId="TableChildControl_CustomDocumentHealthHomeCarePlanLongTermCareOutcomes_ButtonInsert"
                                                            OrderByQuery="CustomDocumentHealthHomeCarePlanLongTermCareOutcomeId" />
                                                    </div>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </p>
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
                                        <td style="vertical-align: top;" class="right_bottom_cont_bottom_bg" align="right"
                                            width="2">
                                            <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_right.gif" />
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
                                        <td class="content_tab_left" align="left" nowrap='nowrap'>
                                            Health Home team plan toward achieving these outcomes
                                        </td>
                                        <td width="17">
                                            <img style="vertical-align: top;" height="26" width="17" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                                        </td>
                                        <td class="content_tab_top" />
                                        <td width="7">
                                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td class="content_tab_bg">
                                <p>
                                    <span style="margin: auto 5px auto 5px; font-size: 12px; font-weight: bold;">(Check
                                        as many as apply)</span>
                                    <p>
                                        <div style="float: left; width: 45%; margin-left: 20px;">
                                            <input type="checkbox" id="CheckBox_CustomDocumentHealthHomeCarePlans_AchievingOutcomeAssistanceObtainingHealthcare"
                                                name="CheckBox_CustomDocumentHealthHomeCarePlans_AchievingOutcomeAssistanceObtainingHealthcare"
                                                class="form_checkbox element YorN" /><label for="CheckBox_CustomDocumentHealthHomeCarePlans_AchievingOutcomeAssistanceObtainingHealthcare"
                                                    class="form_label">Assistance obtaining healthcare</label><br />
                                            <input type="checkbox" id="CheckBox_CustomDocumentHealthHomeCarePlans_AchievingOutcomeMedicationManagement"
                                                name="CheckBox_CustomDocumentHealthHomeCarePlans_AchievingOutcomeMedicationManagement"
                                                class="form_checkbox element YorN" /><label for="CheckBox_CustomDocumentHealthHomeCarePlans_AchievingOutcomeMedicationManagement"
                                                    class="form_label">Medication management/ medication reconciliation</label><br />
                                            <input type="checkbox" id="CheckBox_CustomDocumentHealthHomeCarePlans_AchievingOutcomeTrackTestsReferrals"
                                                name="CheckBox_CustomDocumentHealthHomeCarePlans_AchievingOutcomeTrackTestsReferrals"
                                                class="form_checkbox element YorN" /><label for="CheckBox_CustomDocumentHealthHomeCarePlans_AchievingOutcomeTrackTestsReferrals"
                                                    class="form_label">Track tests, referrals, and follow up</label><br />
                                            <input type="checkbox" id="CheckBox_CustomDocumentHealthHomeCarePlans_AchievingOutcomeCoordinateCollaborate"
                                                name="CheckBox_CustomDocumentHealthHomeCarePlans_AchievingOutcomeCoordinateCollaborate"
                                                class="form_checkbox element YorN" /><label for="CheckBox_CustomDocumentHealthHomeCarePlans_AchievingOutcomeCoordinateCollaborate"
                                                    class="form_label">Coordinate/ Collaborate with Providers/ Patient/ Other Supports</label><br />
                                            <input type="checkbox" id="CheckBox_CustomDocumentHealthHomeCarePlans_AchievingOutcomeCoordinateReferrals"
                                                name="CheckBox_CustomDocumentHealthHomeCarePlans_AchievingOutcomeCoordinateReferrals"
                                                class="form_checkbox element YorN" /><label for="CheckBox_CustomDocumentHealthHomeCarePlans_AchievingOutcomeCoordinateReferrals"
                                                    class="form_label">Coordination of referrals/ appointments</label><br />
                                            <input type="checkbox" id="CheckBox_CustomDocumentHealthHomeCarePlans_AchievingOutcomeProvideHealthEducation"
                                                name="CheckBox_CustomDocumentHealthHomeCarePlans_AchievingOutcomeProvideHealthEducation"
                                                class="form_checkbox element YorN" /><label for="CheckBox_CustomDocumentHealthHomeCarePlans_AchievingOutcomeProvideHealthEducation"
                                                    class="form_label">Provision of health education (self monitoring/ symptom management,
                                                    appropriate care settings, wellness and healthy lifestyle, healthy behaviors)</label><br />
                                        </div>
                                        <div style="float: left; width: 45%; margin-left: 5%;">
                                            <input type="checkbox" id="CheckBox_CustomDocumentHealthHomeCarePlans_AchievingOutcomeProvideHealthEducation"
                                                name="CheckBox_CustomDocumentHealthHomeCarePlans_AchievingOutcomeProvideReferralsToSelfHelpSupport"
                                                class="form_checkbox element YorN" /><label for="CheckBox_CustomDocumentHealthHomeCarePlans_AchievingOutcomeProvideHealthEducation"
                                                    class="form_label">Provision of referrals to self help/ peer support groups</label><br />
                                            <input type="checkbox" id="CheckBox_CustomDocumentHealthHomeCarePlans_AchievingOutcomeAppointmentReminders"
                                                name="CheckBox_CustomDocumentHealthHomeCarePlans_AchievingOutcomeAppointmentReminders"
                                                class="form_checkbox element YorN" /><label for="CheckBox_CustomDocumentHealthHomeCarePlans_AchievingOutcomeAppointmentReminders"
                                                    class="form_label">Appointment service reminders</label><br />
                                            <input type="checkbox" id="CheckBox_CustomDocumentHealthHomeCarePlans_AchievingOutcomeFacilitateTransitionDischarge"
                                                name="CheckBox_CustomDocumentHealthHomeCarePlans_AchievingOutcomeFacilitateTransitionDischarge"
                                                class="form_checkbox element YorN" /><label for="CheckBox_CustomDocumentHealthHomeCarePlans_AchievingOutcomeFacilitateTransitionDischarge"
                                                    class="form_label">Facilitate transition/ discharge</label><br />
                                            <input type="checkbox" id="CheckBox_CustomDocumentHealthHomeCarePlans_AchievingOutcomeAdvocacyAnalysisApplications"
                                                name="CheckBox_CustomDocumentHealthHomeCarePlans_AchievingOutcomeAdvocacyAnalysisApplications"
                                                class="form_checkbox element YorN" /><label for="CheckBox_CustomDocumentHealthHomeCarePlans_AchievingOutcomeAdvocacyAnalysisApplications"
                                                    class="form_label">Advocacy/ Benefits Analysis/ Assistance with benefits application
                                                    process</label><br />
                                            <input type="checkbox" id="CheckBox_CustomDocumentHealthHomeCarePlans_AchievingOutcomeReviewRecords"
                                                name="CheckBox_CustomDocumentHealthHomeCarePlans_AchievingOutcomeReviewRecords"
                                                class="form_checkbox element YorN" /><label for="CheckBox_CustomDocumentHealthHomeCarePlans_AchievingOutcomeReviewRecords"
                                                    class="form_label">Review records with patient/ family</label><br />
                                            <input type="checkbox" id="CheckBox_CustomDocumentHealthHomeCarePlans_AchievingOutcomeSupportRelationships"
                                                name="CheckBox_CustomDocumentHealthHomeCarePlans_AchievingOutcomeSupportRelationships"
                                                class="form_checkbox element YorN" /><label for="CheckBox_CustomDocumentHealthHomeCarePlans_AchievingOutcomeSupportRelationships"
                                                    class="form_label">Provide support for patient’s relationships with family/ community/
                                                    others</label><br />
                                            <input type="checkbox" id="CheckBox_CustomDocumentHealthHomeCarePlans_AchievingOutcomeOther"
                                                name="CheckBox_CustomDocumentHealthHomeCarePlans_AchievingOutcomeOther" class="form_checkbox element YorN" /><label
                                                    for="CheckBox_CustomDocumentHealthHomeCarePlans_AchievingOutcomeOther" class="form_label">Other:</label><input
                                                        type="text" id="TextBox_CustomDocumentHealthHomeCarePlans_AchievingOutcomeOtherComment"
                                                        class="form_textbox element" />
                                        </div>
                                    </p>
                                </p>
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
                                        <td style="vertical-align: top;" class="right_bottom_cont_bottom_bg" align="right"
                                            width="2">
                                            <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_right.gif" />
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
                                        <td class="content_tab_left" align="left" nowrap='nowrap'>
                                            Client Participation
                                        </td>
                                        <td width="17">
                                            <img style="vertical-align: top;" height="26" width="17" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                                        </td>
                                        <td class="content_tab_top" />
                                        <td width="7">
                                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td class="content_tab_bg">
                                <p>
                                    <input type="radio" id="RadioButton_CustomDocumentHealthHomeCarePlans_ClientGuardianParticipatedInPlan_Y"
                                        name="RadioButton_CustomDocumentHealthHomeCarePlans_ClientGuardianParticipatedInPlan" value="Y"
                                        class="form_checkbox element YorN" /><label for="RadioButton_CustomDocumentHealthHomeCarePlans_ClientGuardianParticipatedInPlan_Y" class="form_label">The patient/ guardian
                                            participated in the development or update of this care plan and has been provided
                                            the necessary information to consent to participation in Health Home Services.</label><br />
                                            <input type="radio" id="RadioButton_CustomDocumentHealthHomeCarePlans_ClientGuardianParticipatedInPlan_N"
                                                name="RadioButton_CustomDocumentHealthHomeCarePlans_ClientGuardianParticipatedInPlan" value="N"
                                                class="form_checkbox element YorN" /><label for="RadioButton_CustomDocumentHealthHomeCarePlans_ClientGuardianParticipatedInPlan_N" class="form_label">The patient/ guardian
                                                    did not participate in the development or update of this care plan.</label>
                                                    <br />
                                                    <span style="margin-left: 20px;">Reason:</span><br />
                                                    <textarea style="width: 500px; height: 60px; margin-left: 20px;" id="TextArea_CustomDocumentHealthHomeCarePlans_ClientCardianReasonForNonParticipation"
                                                        class="form_textbox element"></textarea>
                                </p>
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
                                        <td style="vertical-align: top;" class="right_bottom_cont_bottom_bg" align="right"
                                            width="2">
                                            <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_right.gif" />
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
</asp:Panel>
<asp:Panel ID="PanelAjaxResponse" runat="server" Visible="false">
    <input type="hidden" id="IntegratedCarePlanResponseType" value="<%=IntegratedCarePlanResponseType %>" />
    <asp:Panel ID="PanelDeleteResponse" runat="server" Visible="false">
        <input type="hidden" id="IntegratedCarePlanDeleteResponse" value="<%=IntegratedCarePlanDeleteResponse %>" />
        <input type="hidden" id="IntegratedCarePlanDeleteMessage" value="<%=IntegratedCarePlanMessage %>" />
    </asp:Panel>
    <asp:Panel runat="server" ID="PanelOutcomeSequence" Visible="False">
        <input type="hidden" id="IntegratedCarePlanOutcomeSequence" value="<%=IntegratedCarePlanOutcomeSequence %>" />
    </asp:Panel>
</asp:Panel>
