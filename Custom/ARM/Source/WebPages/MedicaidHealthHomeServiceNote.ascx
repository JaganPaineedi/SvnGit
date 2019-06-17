<%@ Control Language="C#" AutoEventWireup="true" CodeFile="MedicaidHealthHomeServiceNote.ascx.cs"
    Inherits="SHS.SmartCare.MedicaidHealthHomeServiceNote" %>
<%@ Register Assembly="Streamline.DotNetDropDowns" Namespace="Streamline.DotNetDropDowns"
    TagPrefix="cc2" %>
<%@ Register Src="~/CommonUserControls/CustomGrid.ascx" TagName="CustomGrid" TagPrefix="uc1" %>
<% if (HttpContext.Current == null)
   { %>
<link href="../../../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet"
    type="text/css" />
<%} %>

<script src="<%=RelativePath%>JScripts/ApplicationScripts/jquery.tmpl.min.js" type="text/javascript"></script>

<script language="javascript" type="text/javascript" src="<%=RelativePath%>Custom/Scripts/MedicaidServiceNote.js"></script>

<script language="javascript" type="text/javascript" src="<%=RelativePath%>JScripts/ApplicationScripts/GeneralFormFunctions.js"></script>

<style>
    .ellipsis
    {
        max-width: 250px;
        text-overflow: ellipsis;
    }
</style>
<input id="HiddenFieldPageTables" runat="server" name="HiddenFieldPageTables" type="hidden"
    value="CustomDocumentHealthHomeServiceNotes" />
<table class="DocumentScreen" style="width: 832px" class="CrossBrowserAutoFixChrome_width_847px">
    <tr>
        <td style="padding-left: 10px; padding-right: 5px" class="style1">
            <span class="form_label_text" id="Span1">Last Health Home Visit</span>
            <input type="text" id="TextBox_CustomDocumentHealthHomeServiceNotes_LastVisitDate"
                datatype="Date" name="TextBox_CustomDocumentHealthHomeServiceNotes_LastVisitDate"
                class="form_textbox element" style="width: 75px;" />
            <img id="Img3" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                onclick="return showCalendar('TextBox_CustomDocumentHealthHomeServiceNotes_LastVisitDate', '%m/%d/%Y');"
                style="cursor: hand;" filter="false" />
        </td>
    </tr>
    <tr>
        <td class="style1">
        </td>
    </tr>
    <tr>
        <td class="style1">
            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                <tr>
                    <td align="left">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                    Current Mental Health Diagnosis
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
                        <table style="height: 100px" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                               <td align="left" style="width: 800px; padding-left: 10px;">
                     <div id="divPreviousDiagnosis" style="border: solid 1px #b1b1b1; background-color: #f5f5f5;overflow-y: scroll; min-height: 100px; width: 98%">
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
                                    <input type="hidden" id="HiddenField_CustomDocumentHealthHomeCarePlanDiagnoses_CustomDocumentHealthHomeCarePlanDiagnosisId"
                                        name="HiddenField_CustomDocumentHealthHomeCarePlanDiagnoses_CustomDocumentHealthHomeCarePlanDiagnosisId"
                                        parentchildcontrols="True" />
                                    <input type="hidden" id="HiddenFieldPrimaryKeyCustomDocumentHealthHomeCarePlanDiagnosisId"
                                        name="HiddenFieldPrimaryKeyCustomDocumentHealthHomeCarePlanDiagnosisId" value="CustomDocumentHealthHomeCarePlanDiagnosisId"
                                        parentchildcontrols="True" />
                                    <input type="hidden" id="HiddenField_CustomDocumentHealthHomeCarePlanDiagnoses_DocumentVersionId"
                                        name="HiddenField_CustomDocumentHealthHomeCarePlanDiagnoses_DocumentVersionId"
                                        value="-1" parentchildcontrols="True" />
                                    <input type="hidden" id="HiddenField_CustomDocumentHealthHomeCarePlanDiagnoses_SequenceNumber"
                                        name="HiddenField_CustomDocumentHealthHomeCarePlanDiagnoses_SequenceNumber" parentchildcontrols="True"
                                        includeinparentchildxml="true" />
                                    <!-- Table Columns -->
                                    <label for="TextBox_CustomDocumentHealthHomeCarePlanDiagnoses_ReportedDiagnosis"
                                        class="form_label">
                                        Reported Diagnosis:</label>
                                </td>
                                <td>
                                    <input type="text" id="TextBox_CustomDocumentHealthHomeCarePlanDiagnoses_ReportedDiagnosis"
                                        name="TextBox_CustomDocumentHealthHomeCarePlanDiagnoses_ReportedDiagnosis" bindautosaveevents="False"
                                        required="true" parentchildcontrols="True" class="form_textbox element" style="width: 200px;" />
                                </td>
                                <td>
                                    <label for="TextBox_CustomDocumentHealthHomeCarePlanDiagnoses_TreatmentProvider"
                                        class="form_label">
                                        Treatment Provider:</label><input type="text" id="TextBox_CustomDocumentHealthHomeCarePlanDiagnoses_TreatmentProvider"
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
                                        Source:</label>
                                </td>
                                <td>
                                    <asp:DropDownList ID="DropDownList_CustomDocumentHealthHomeCarePlanDiagnoses_DiagnosisSource"
                                        bindautosaveevents="False" parentchildcontrols="True" AddBlankRow="true" Width="205px"
                                        runat="server">
                                    </asp:DropDownList>
                                </td>
                                <td>
                                </td>
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
                                    Current Developmental Disabilities
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
                                    <textarea id="TextArea_CustomDocumentHealthHomeServiceNotes_CurrentDDDiagnoses" name="TextArea_CustomDocumentHealthHomeServiceNotes_CurrentDDDiagnoses"
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
                                    Integrated Care Plan goal/objective
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
                                    <textarea id="TextArea_CustomDocumentHealthHomeServiceNotes_IntegratedCarePlanGoalsAddressed"
                                        name="TextArea_CustomDocumentHealthHomeServiceNotes_IntegratedCarePlanGoalsAddressed"
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
                                    Today's Encounter
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
                        <table id="TransitionFrom" width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td style="padding-left: 10px; padding-right: 5px">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td style="width: 20%">
                                                <span class="form_label_text" id="Span7">Reason for Today’s Encounter</span>
                                            </td>
                                            <td style="width: 80%">
                                                <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentHealthHomeServiceNotes_ReasonTodaysEncounter"
                                                    name="DropDownList_CustomDocumentHealthHomeServiceNotes_ReasonTodaysEncounter"
                                                    Width="210px" runat="server">
                                                </cc2:StreamlineDropDowns>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height2">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 10%">
                                                <span class="form_label_text" id="Span8">Describe</span>
                                            </td>
                                            <td style="width: 90%">
                                                <textarea id="TextArea_CustomDocumentHealthHomeServiceNotes_ReasonTodaysEncounterDescription"
                                                    name="TextArea_CustomDocumentHealthHomeServiceNotes_ReasonTodaysEncounterDescription"
                                                    rows="4" cols="158" class="form_textarea" spellcheck="True"></textarea>
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
                                    Measures
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
                                            <td colspan="5">
                                                <span class="form_label_text" id="Span9">For Measures Below, If not measured today,
                                                    include date of measurement in field:</span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height2">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="5">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr id="rowldl">
                                                        <td style="width: 8%">
                                                            <span class="form_label_text" id="SpanLDL">LDL</span>
                                                        </td>
                                                        <td style="width: 12%">
                                                            <input type="text" id="TextBox_CustomDocumentHealthHomeServiceNotes_LDLValue" name="TextBox_CustomDocumentHealthHomeServiceNotes_LDLValue"
                                                                class="form_textbox element" style="width: 80%;" maxlength="25" />
                                                        </td>
                                                        <td style="width: 12%">
                                                            <span class="form_label_text" id="SpanLDLDate">LDL Date</span>
                                                        </td>
                                                        <td style="width: 18%">
                                                            <input type="text" id="TextBox_CustomDocumentHealthHomeServiceNotes_LDLDate" name="TextBox_CustomDocumentHealthHomeServiceNotes_LDLDate"
                                                                datatype="Date" class="form_textbox element" style="width: 75px;" />
                                                            <img id="Img1" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                onclick="return showCalendar('TextBox_CustomDocumentHealthHomeServiceNotes_LDLDate', '%m/%d/%Y');"
                                                                style="cursor: hand;" filter="false" />
                                                        </td>
                                                        <td style="width: 8%">
                                                            <input type="checkbox" id="CheckBox_CustomDocumentHealthHomeServiceNotes_LDLNA" class="RadioText"
                                                                name="CheckBox_CustomDocumentHealthHomeServiceNotes_LDLNA" onclick="DisableRow()" />
                                                            <span class="RadioText" id="spanldl">N/A</span>
                                                        </td>
                                                        <td style="width: 12%">
                                                        </td>
                                                        <td style="width: 12%">
                                                        </td>
                                                        <td style="width: 18%">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2">
                                                        </td>
                                                    </tr>
                                                    <tr id="rowalc">
                                                        <td style="width: 8%">
                                                            <span class="form_label_text" id="SpanALC">ALC</span>
                                                        </td>
                                                        <td style="width: 12%">
                                                            <input type="text" id="TextBox_CustomDocumentHealthHomeServiceNotes_ALCValue" name="TextBox_CustomDocumentHealthHomeServiceNotes_ALCValue"
                                                                class="form_textbox element" style="width: 80%;" maxlength="25" />
                                                        </td>
                                                        <td style="width: 12%">
                                                            <span class="form_label_text" id="SpanALCDate">ALC Date</span>
                                                        </td>
                                                        <td style="width: 18%">
                                                            <input type="text" id="TextBox_CustomDocumentHealthHomeServiceNotes_ALCDate" name="TextBox_CustomDocumentHealthHomeServiceNotes_ALCDate"
                                                                datatype="Date" class="form_textbox element" style="width: 75px;" />
                                                            <img id="Img2" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                onclick="return showCalendar('TextBox_CustomDocumentHealthHomeServiceNotes_ALCDate', '%m/%d/%Y');"
                                                                style="cursor: hand;" filter="false" />
                                                        </td>
                                                        <td style="width: 8%">
                                                            <input type="checkbox" id="CheckBox_CustomDocumentHealthHomeServiceNotes_ALCNA" class="RadioText"
                                                                name="CheckBox_CustomDocumentHealthHomeServiceNotes_ALCNA" onclick="DisableRow()" />
                                                            <span class="RadioText">N/A</span>
                                                        </td>
                                                        <td style="width: 12%">
                                                        </td>
                                                        <td style="width: 12%">
                                                        </td>
                                                        <td style="width: 18%">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td style="width: 8%">
                                                            <span class="form_label_text" id="Span15">VS</span>
                                                        </td>
                                                        <td style="width: 12%">
                                                            <input type="text" id="TextBox_CustomDocumentHealthHomeServiceNotes_HDVS" name="TextBox_CustomDocumentHealthHomeServiceNotes_HDVS"
                                                                class="form_textbox element" style="width: 80%;" maxlength="25" />
                                                        </td>
                                                        <td style="width: 12%">
                                                            <span class="form_label_text" id="Span16">VS Date</span>
                                                        </td>
                                                        <td style="width: 18%">
                                                            <input type="text" id="TextBox_CustomDocumentHealthHomeServiceNotes_HDVSDate" name="TextBox_CustomDocumentHealthHomeServiceNotes_HDVSDate"
                                                                datatype="Date" class="form_textbox element" style="width: 75px;" />
                                                            <img id="Img4" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                onclick="return showCalendar('TextBox_CustomDocumentHealthHomeServiceNotes_HDVSDate', '%m/%d/%Y');"
                                                                style="cursor: hand;" filter="false" />
                                                        </td>
                                                        <td style="width: 8%">
                                                            <span class="form_label_text" id="Span17">T</span>
                                                        </td>
                                                        <td style="width: 12%">
                                                            <input type="text" id="TextBox_CustomDocumentHealthHomeServiceNotes_HDT" maxlength="25"
                                                                name="TextBox_CustomDocumentHealthHomeServiceNotes_HDT" class="form_textbox element"
                                                                style="width: 80%;" />
                                                        </td>
                                                        <td style="width: 12%">
                                                            <span class="form_label_text" id="Span18">T Date</span>
                                                        </td>
                                                        <td style="width: 18%">
                                                            <input type="text" id="TextBox_CustomDocumentHealthHomeServiceNotes_HDTDate" name="TextBox_CustomDocumentHealthHomeServiceNotes_HDTDate"
                                                                datatype="Date" class="form_textbox element" style="width: 75px;" />
                                                            <img id="Img5" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                onclick="return showCalendar('TextBox_CustomDocumentHealthHomeServiceNotes_HDTDate', '%m/%d/%Y');"
                                                                style="cursor: hand;" filter="false" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <span class="form_label_text" id="Span19">P</span>
                                                        </td>
                                                        <td>
                                                            <input type="text" id="TextBox_CustomDocumentHealthHomeServiceNotes_HDP" maxlength="25"
                                                                name="TextBox_CustomDocumentHealthHomeServiceNotes_HDP" class="form_textbox element"
                                                                style="width: 80%;" />
                                                        </td>
                                                        <td>
                                                            <span class="form_label_text" id="Span20">P Date</span>
                                                        </td>
                                                        <td>
                                                            <input type="text" id="TextBox_CustomDocumentHealthHomeServiceNotes_HDPDate" name="TextBox_CustomDocumentHealthHomeServiceNotes_HDPDate"
                                                                datatype="Date" class="form_textbox element" style="width: 75px;" />
                                                            <img id="Img6" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                onclick="return showCalendar('TextBox_CustomDocumentHealthHomeServiceNotes_HDPDate', '%m/%d/%Y');"
                                                                style="cursor: hand;" filter="false" />
                                                        </td>
                                                        <td>
                                                            <span class="form_label_text" id="Span21">R</span>
                                                        </td>
                                                        <td>
                                                            <input type="text" id="TextBox_CustomDocumentHealthHomeServiceNotes_HDR" maxlength="25"
                                                                name="TextBox_CustomDocumentHealthHomeServiceNotes_HDR" class="form_textbox element"
                                                                style="width: 80%;" />
                                                        </td>
                                                        <td>
                                                            <span class="form_label_text" id="Span22">R Date</span>
                                                        </td>
                                                        <td>
                                                            <input type="text" id="TextBox_CustomDocumentHealthHomeServiceNotes_HDRDate" name="TextBox_CustomDocumentHealthHomeServiceNotes_HDRDate"
                                                                datatype="Date" class="form_textbox element" style="width: 75px;" />
                                                            <img id="Img7" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                onclick="return showCalendar('TextBox_CustomDocumentHealthHomeServiceNotes_HDRDate', '%m/%d/%Y');"
                                                                style="cursor: hand;" filter="false" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <span class="form_label_text" id="Span23">BP (diastolic)</span>
                                                        </td>
                                                        <td>
                                                            <input type="text" id="TextBox_CustomDocumentHealthHomeServiceNotes_HDBPDiastolic"
                                                                maxlength="25" name="TextBox_CustomDocumentHealthHomeServiceNotes_HDBPDiastolic"
                                                                class="form_textbox element" style="width: 80%;" />
                                                        </td>
                                                        <td>
                                                            <span class="form_label_text" id="Span24">BP (diastolic) Date</span>
                                                        </td>
                                                        <td>
                                                            <input type="text" id="TextBox_CustomDocumentHealthHomeServiceNotes_HDBPDiastolicDate"
                                                                datatype="Date" name="TextBox_CustomDocumentHealthHomeServiceNotes_HDBPDiastolicDate"
                                                                class="form_textbox element" style="width: 75px;" />
                                                            <img id="Img8" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                onclick="return showCalendar('TextBox_CustomDocumentHealthHomeServiceNotes_HDBPDiastolicDate', '%m/%d/%Y');"
                                                                style="cursor: hand;" filter="false" />
                                                        </td>
                                                        <td>
                                                            <span class="form_label_text" id="Span25">BP (systolic) </span>
                                                        </td>
                                                        <td>
                                                            <input type="text" id="TextBox_CustomDocumentHealthHomeServiceNotes_HDBPSystolic"
                                                                maxlength="25" name="TextBox_CustomDocumentHealthHomeServiceNotes_HDBPSystolic"
                                                                class="form_textbox element" style="width: 80%;" />
                                                        </td>
                                                        <td>
                                                            <span class="form_label_text" id="Span26">BP (systolic) Date</span>
                                                        </td>
                                                        <td>
                                                            <input type="text" id="TextBox_CustomDocumentHealthHomeServiceNotes_HDBPSystolicDate"
                                                                datatype="Date" name="TextBox_CustomDocumentHealthHomeServiceNotes_HDBPSystolicDate"
                                                                class="form_textbox element" style="width: 75px;" />
                                                            <img id="Img9" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                onclick="return showCalendar('TextBox_CustomDocumentHealthHomeServiceNotes_HDBPSystolicDate', '%m/%d/%Y');"
                                                                style="cursor: hand;" filter="false" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <span class="form_label_text" id="Span27">Ht</span>
                                                        </td>
                                                        <td>
                                                            <input type="text" id="TextBox_CustomDocumentHealthHomeServiceNotes_HDHt" maxlength="25"
                                                                name="TextBox_CustomDocumentHealthHomeServiceNotes_HDHt" class="form_textbox element"
                                                                style="width: 80%;" />
                                                        </td>
                                                        <td>
                                                            <span class="form_label_text" id="Span28">Ht Date</span>
                                                        </td>
                                                        <td>
                                                            <input type="text" id="TextBox_CustomDocumentHealthHomeServiceNotes_HDHtDate" name="TextBox_CustomDocumentHealthHomeServiceNotes_HDHtDate"
                                                                datatype="Date" class="form_textbox element" style="width: 75px;" />
                                                            <img id="Img10" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                onclick="return showCalendar('TextBox_CustomDocumentHealthHomeServiceNotes_HDHtDate', '%m/%d/%Y');"
                                                                style="cursor: hand;" filter="false" />
                                                        </td>
                                                        <td>
                                                            <span class="form_label_text" id="Span29">Wt</span>
                                                        </td>
                                                        <td>
                                                            <input type="text" id="TextBox_CustomDocumentHealthHomeServiceNotes_HDWt" maxlength="25"
                                                                name="TextBox_CustomDocumentHealthHomeServiceNotes_HDWt" class="form_textbox element"
                                                                style="width: 80%;" />
                                                        </td>
                                                        <td>
                                                            <span class="form_label_text" id="Span30">Wt Date</span>
                                                        </td>
                                                        <td>
                                                            <input type="text" id="TextBox_CustomDocumentHealthHomeServiceNotes_HDWtDate" name="TextBox_CustomDocumentHealthHomeServiceNotes_HDWtDate"
                                                                datatype="Date" class="form_textbox element" style="width: 75px;" />
                                                            <img id="Img11" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                onclick="return showCalendar('TextBox_CustomDocumentHealthHomeServiceNotes_HDWtDate', '%m/%d/%Y');"
                                                                style="cursor: hand;" filter="false" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <span class="form_label_text" id="Span31">WC</span>
                                                        </td>
                                                        <td>
                                                            <input type="text" id="TextBox_CustomDocumentHealthHomeServiceNotes_HDWC" name="TextBox_CustomDocumentHealthHomeServiceNotes_HDWC"
                                                                maxlength="25" class="form_textbox element" style="width: 80%;" />
                                                        </td>
                                                        <td>
                                                            <span class="form_label_text" id="Span32">WC Date</span>
                                                        </td>
                                                        <td>
                                                            <input type="text" id="TextBox_CustomDocumentHealthHomeServiceNotes_HDWCDate" name="TextBox_CustomDocumentHealthHomeServiceNotes_HDWCDate"
                                                                datatype="Date" class="form_textbox element" style="width: 75px;" />
                                                            <img id="Img12" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                onclick="return showCalendar('TextBox_CustomDocumentHealthHomeServiceNotes_HDWCDate', '%m/%d/%Y');"
                                                                style="cursor: hand;" filter="false" />
                                                        </td>
                                                        <td>
                                                            <span class="form_label_text" id="Span33">BMI</span>
                                                        </td>
                                                        <td>
                                                            <input type="text" id="TextBox_CustomDocumentHealthHomeServiceNotes_HDBMI" name="TextBox_CustomDocumentHealthHomeServiceNotes_HDBMI"
                                                                maxlength="25" class="form_textbox element" style="width: 80%;" />
                                                        </td>
                                                        <td>
                                                            <span class="form_label_text" id="Span34">BMI Date</span>
                                                        </td>
                                                        <td>
                                                            <input type="text" id="TextBox_CustomDocumentHealthHomeServiceNotes_HDBMIDate" name="TextBox_CustomDocumentHealthHomeServiceNotes_HDBMIDate"
                                                                datatype="Date" class="form_textbox element" style="width: 75px;" />
                                                            <img id="Img13" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                onclick="return showCalendar('TextBox_CustomDocumentHealthHomeServiceNotes_HDBMIDate', '%m/%d/%Y');"
                                                                style="cursor: hand;" filter="false" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <span class="form_label_text" id="Span35">SaO2</span>
                                                        </td>
                                                        <td>
                                                            <input type="text" id="TextBox_CustomDocumentHealthHomeServiceNotes_HDSaO2" name="TextBox_CustomDocumentHealthHomeServiceNotes_HDSaO2"
                                                                maxlength="25" class="form_textbox element" style="width: 80%;" />
                                                        </td>
                                                        <td>
                                                            <span class="form_label_text" id="Span36">SaO2 Date</span>
                                                        </td>
                                                        <td colspan="5">
                                                            <input type="text" id="TextBox_CustomDocumentHealthHomeServiceNotes_HDSaO2Date" name="TextBox_CustomDocumentHealthHomeServiceNotes_HDSaO2Date"
                                                                datatype="Date" class="form_textbox element" style="width: 75px;" />
                                                            <img id="Img14" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                onclick="return showCalendar('TextBox_CustomDocumentHealthHomeServiceNotes_HDSaO2Date', '%m/%d/%Y');"
                                                                style="cursor: hand;" filter="false" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2">
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
                                            <td colspan="5">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr>
                                                        <td colspan="2">
                                                            <input class="cursor_default" type="checkbox" style="vertical-align: bottom" id="Checkbox_CustomDocumentHealthHomeServiceNotes_MedAllergyListReviewed"
                                                                name="Checkbox_CustomDocumentHealthHomeServiceNotes_MedAllergyListReviewed" onclick="" />
                                                            <label for="Checkbox_CustomDocumentHealthHomeServiceNotes_MedAllergyListReviewed">
                                                                Med Allergy Reviewed</label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td style="width: 10%">
                                                            <span class="form_label_text" id="Span38">Comment</span>
                                                        </td>
                                                        <td style="width: 90%">
                                                            <textarea id="TextArea_CustomDocumentHealthHomeServiceNotes_MedAllergyListReviewedComment"
                                                                name="TextArea_CustomDocumentHealthHomeServiceNotes_MedAllergyListReviewedComment"
                                                                rows="4" cols="158" class="form_textarea" spellcheck="True"></textarea>
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
                                            <td colspan="5">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr>
                                                        <td colspan="2">
                                                            <input class="cursor_default" type="checkbox" style="vertical-align: bottom" id="Checkbox_CustomDocumentHealthHomeServiceNotes_ProblemListReviewed"
                                                                name="Checkbox_CustomDocumentHealthHomeServiceNotes_ProblemListReviewed" onclick="" />
                                                            <label for="Checkbox_CustomDocumentHealthHomeServiceNotes_ProblemListReviewed">
                                                                Problem List Reviewed</label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td style="width: 10%">
                                                            <span class="form_label_text" id="Span37">Comment</span>
                                                        </td>
                                                        <td style="width: 90%">
                                                            <textarea id="TextArea_CustomDocumentHealthHomeServiceNotes_ProblemListReviewedComment"
                                                                name="TextArea_CustomDocumentHealthHomeServiceNotes_ProblemListReviewedComment"
                                                                rows="4" cols="158" class="form_textarea" spellcheck="True"></textarea>
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
                                    Rescue Mental Health
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
                                            <td style="width: 100%" colspan="2">
                                                Recent Rescue Mental Health (non inpatient admission) encounter?&nbsp&nbsp
                                                <input class="cursor_default" type="radio" style="vertical-align: bottom" id="RadioButton_CustomDocumentHealthHomeServiceNotes_RescueMentalHealthEncounter_N"
                                                    name="RadioButton_CustomDocumentHealthHomeServiceNotes_RescueMentalHealthEncounter"
                                                    value="N" onclick="EnableOrDisableControls()" />
                                                <label for="RadioButton_CustomDocumentHealthHomeServiceNotes_RescueMentalHealthEncounter_N">
                                                    No</label>&nbsp&nbsp<input class="cursor_default" type="radio" style="vertical-align: bottom"
                                                        id="RadioButton_CustomDocumentHealthHomeServiceNotes_RescueMentalHealthEncounter_Y"
                                                        name="RadioButton_CustomDocumentHealthHomeServiceNotes_RescueMentalHealthEncounter"
                                                        value="Y" onclick="EnableOrDisableControls()" />
                                                <label for="RadioButton_CustomDocumentHealthHomeServiceNotes_RescueMentalHealthEncounter_Y">
                                                    Yes</label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height2">
                                            </td>
                                        </tr>
                                        <tr id="RescueEncounter">
                                            <td style="width: 40%">
                                                <span class="form_label_text" id="Span39">If yes, Encounter date</span>
                                                <input type="text" id="TextBox_CustomDocumentHealthHomeServiceNotes_RescueMentalHealthEncounterDate"
                                                    name="TextBox_CustomDocumentHealthHomeServiceNotes_RescueMentalHealthEncounterDate"
                                                    datatype="Date" class="form_textbox element" style="width: 75px;" />
                                                <img id="Img15" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                    onclick="return showCalendar('TextBox_CustomDocumentHealthHomeServiceNotes_RescueMentalHealthEncounterDate', '%m/%d/%Y');"
                                                    style="cursor: hand;" filter="false" />
                                            </td>
                                            <td style="width: 60%">
                                                <span class="form_label_text" id="Span40">Follow up date</span>
                                                <input type="text" id="TextBox_CustomDocumentHealthHomeServiceNotes_RescueMentalHealthFollowUpDate"
                                                    datatype="Date" name="TextBox_CustomDocumentHealthHomeServiceNotes_RescueMentalHealthFollowUpDate"
                                                    class="form_textbox element" style="width: 75px;" onchange="CheckDateRange('TextBox_CustomDocumentHealthHomeServiceNotes_RescueMentalHealthEncounterDate','TextBox_CustomDocumentHealthHomeServiceNotes_RescueMentalHealthFollowUpDate','Rescue');" />
                                                <img id="Img16" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                    onclick="return showCalendar('TextBox_CustomDocumentHealthHomeServiceNotes_RescueMentalHealthFollowUpDate', '%m/%d/%Y');"
                                                    style="cursor: hand;" filter="false" />
                                                <span class="form_label_text" id="Span41">(must be within 7 days)</span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height2">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 100%" colspan="2">
                                                Education regarding Rescue Mental Health utilization provided?&nbsp&nbsp
                                                <input class="cursor_default" type="radio" style="vertical-align: bottom" id="RadioButton_CustomDocumentHealthHomeServiceNotes_RescueMentalHealthEducationProvided_N"
                                                    name="RadioButton_CustomDocumentHealthHomeServiceNotes_RescueMentalHealthEducationProvided"
                                                    value="N" />
                                                <label for="RadioButton_CustomDocumentHealthHomeServiceNotes_RescueMentalHealthEducationProvided_N">
                                                    No</label>&nbsp&nbsp<input class="cursor_default" type="radio" style="vertical-align: bottom"
                                                        id="RadioButton_CustomDocumentHealthHomeServiceNotes_RescueMentalHealthEducationProvided_Y"
                                                        name="RadioButton_CustomDocumentHealthHomeServiceNotes_RescueMentalHealthEducationProvided"
                                                        value="Y" />
                                                <label for="RadioButton_CustomDocumentHealthHomeServiceNotes_RescueMentalHealthEducationProvided_Y">
                                                    Yes</label>&nbsp&nbsp<input class="cursor_default" type="radio" style="vertical-align: bottom"
                                                        id="RadioButton_CustomDocumentHealthHomeServiceNotes_RescueMentalHealthEducationProvided_A"
                                                        name="RadioButton_CustomDocumentHealthHomeServiceNotes_RescueMentalHealthEducationProvided"
                                                        value="A" />
                                                <label for="RadioButton_CustomDocumentHealthHomeServiceNotes_RescueMentalHealthEducationProvided_A">
                                                    N/A</label>
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
                                    Psychiatric Hospital Discharge
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
                                            <td style="width: 100%" colspan="2">
                                                Recent psychiatric hospital discharge? &nbsp&nbsp
                                                <input class="cursor_default" type="radio" style="vertical-align: bottom" id="RadioButton_CustomDocumentHealthHomeServiceNotes_RecentPsychHospitalDischarge_N"
                                                    name="RadioButton_CustomDocumentHealthHomeServiceNotes_RecentPsychHospitalDischarge"
                                                    value="N" onclick="EnableOrDisableControls()" />
                                                <label for="RadioButton_CustomDocumentHealthHomeServiceNotes_RecentPsychHospitalDischarge_N">
                                                    No</label>&nbsp&nbsp<input class="cursor_default" type="radio" style="vertical-align: bottom"
                                                        id="RadioButton_CustomDocumentHealthHomeServiceNotes_RecentPsychHospitalDischarge_Y"
                                                        name="RadioButton_CustomDocumentHealthHomeServiceNotes_RecentPsychHospitalDischarge"
                                                        value="Y" onclick="EnableOrDisableControls()" />
                                                <label for="RadioButton_CustomDocumentHealthHomeServiceNotes_RecentPsychHospitalDischarge_Y">
                                                    Yes</label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height2">
                                            </td>
                                        </tr>
                                        <tr id="psychiatric1">
                                            <td style="width: 40%">
                                                <span class="form_label_text" id="Span42">If yes, Discharge date</span>
                                                <input type="text" id="TextBox_CustomDocumentHealthHomeServiceNotes_RecentPsychHospitalDischargeDate"
                                                    name="TextBox_CustomDocumentHealthHomeServiceNotes_RecentPsychHospitalDischargeDate"
                                                    datatype="Date" class="form_textbox element" style="width: 75px;" />
                                                <img id="Img17" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                    onclick="return showCalendar('TextBox_CustomDocumentHealthHomeServiceNotes_RecentPsychHospitalDischargeDate', '%m/%d/%Y');"
                                                    style="cursor: hand;" filter="false" />
                                            </td>
                                            <td style="width: 60%">
                                                <span class="form_label_text" id="Span43">Follow up date</span>
                                                <input type="text" id="TextBox_CustomDocumentHealthHomeServiceNotes_RecentPsychHospitalFollowUpDate"
                                                    name="TextBox_CustomDocumentHealthHomeServiceNotes_RecentPsychHospitalFollowUpDate"
                                                    datatype="Date" onchange="CheckDateRange('TextBox_CustomDocumentHealthHomeServiceNotes_RecentPsychHospitalDischargeDate','TextBox_CustomDocumentHealthHomeServiceNotes_RecentPsychHospitalFollowUpDate','Psychiatric');"
                                                    class="form_textbox element" style="width: 75px;" />
                                                <img id="Img18" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                    onclick="return showCalendar('TextBox_CustomDocumentHealthHomeServiceNotes_RecentPsychHospitalFollowUpDate', '%m/%d/%Y');"
                                                    style="cursor: hand;" filter="false" />
                                                <span class="form_label_text" id="Span44">(must be within 7 days)</span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height2">
                                            </td>
                                        </tr>
                                        <tr id="psychiatric2">
                                            <td style="width: 100%" colspan="2">
                                                If yes, transition plan completed? &nbsp&nbsp
                                                <input class="cursor_default" type="radio" style="vertical-align: bottom" id="RadioButton_CustomDocumentHealthHomeServiceNotes_RecentPsychHospitalTransitionCompleted_N"
                                                    name="RadioButton_CustomDocumentHealthHomeServiceNotes_RecentPsychHospitalTransitionCompleted"
                                                    value="N" />
                                                <label for="RadioButton_CustomDocumentHealthHomeServiceNotes_RecentPsychHospitalTransitionCompleted_N">
                                                    No</label>&nbsp&nbsp<input class="cursor_default" type="radio" style="vertical-align: bottom"
                                                        id="RadioButton_CustomDocumentHealthHomeServiceNotes_RecentPsychHospitalTransitionCompleted_Y"
                                                        name="RadioButton_CustomDocumentHealthHomeServiceNotes_RecentPsychHospitalTransitionCompleted"
                                                        value="Y" />
                                                <label for="RadioButton_CustomDocumentHealthHomeServiceNotes_RecentPsychHospitalTransitionCompleted_Y">
                                                    Yes</label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height2">
                                            </td>
                                        </tr>
                                        <tr id="psychiatric3">
                                            <td style="width: 100%" colspan="2">
                                                (Reminder: Update Hospitalization tab)
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
                                    Emergency Department
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
                                            <td style="width: 100%" colspan="2">
                                                Recent Emergency Department (non inpatient admission) encounter? &nbsp&nbsp
                                                <input class="cursor_default" type="radio" style="vertical-align: bottom" id="RadioButton_CustomDocumentHealthHomeServiceNotes_RecentEmergencyDeptEncounter_N"
                                                    name="RadioButton_CustomDocumentHealthHomeServiceNotes_RecentEmergencyDeptEncounter"
                                                    value="N" onclick="EnableOrDisableControls()" />
                                                <label for="RadioButton_CustomDocumentHealthHomeServiceNotes_RecentEmergencyDeptEncounter">
                                                    No</label>&nbsp&nbsp<input class="cursor_default" type="radio" style="vertical-align: bottom"
                                                        id="RadioButton_CustomDocumentHealthHomeServiceNotes_RecentEmergencyDeptEncounter_Y"
                                                        name="RadioButton_CustomDocumentHealthHomeServiceNotes_RecentEmergencyDeptEncounter"
                                                        value="Y" onclick="EnableOrDisableControls()" />
                                                <label for="RadioButton_CustomDocumentHealthHomeServiceNotes_RecentEmergencyDeptEncounter_Y">
                                                    Yes</label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height2">
                                            </td>
                                        </tr>
                                        <tr id="EmergencyTr">
                                            <td style="width: 40%">
                                                <span class="form_label_text" id="Span45">If yes, Encounter date</span>
                                                <input type="text" id="TextBox_CustomDocumentHealthHomeServiceNotes_RecentEmergencyDeptEncounterDate"
                                                    name="TextBox_CustomDocumentHealthHomeServiceNotes_RecentEmergencyDeptEncounterDate"
                                                    class="form_textbox element" style="width: 75px;" datatype="Date" />
                                                <img id="Img19" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                    onclick="return showCalendar('TextBox_CustomDocumentHealthHomeServiceNotes_RecentEmergencyDeptEncounterDate', '%m/%d/%Y');"
                                                    style="cursor: hand;" filter="false" />
                                            </td>
                                            <td style="width: 60%">
                                                <span class="form_label_text" id="Span46">Follow up date</span>
                                                <input type="text" id="TextBox_CustomDocumentHealthHomeServiceNotes_RecentEmergencyDeptFollowUpDate"
                                                    datatype="Date" name="TextBox_CustomDocumentHealthHomeServiceNotes_RecentEmergencyDeptFollowUpDate"
                                                    class="form_textbox element" style="width: 75px;" onchange="CheckDateRange('TextBox_CustomDocumentHealthHomeServiceNotes_RecentEmergencyDeptEncounterDate','TextBox_CustomDocumentHealthHomeServiceNotes_RecentEmergencyDeptFollowUpDate','Emergency');" />
                                                <img id="Img20" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                    onclick="return showCalendar('TextBox_CustomDocumentHealthHomeServiceNotes_RecentEmergencyDeptFollowUpDate', '%m/%d/%Y');"
                                                    style="cursor: hand;" filter="false" />
                                                <span class="form_label_text" id="Span47">(must be within 14 days)</span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height2">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 100%" colspan="2">
                                                Education regarding ED Utilization provided? &nbsp&nbsp
                                                <input class="cursor_default" type="radio" style="vertical-align: bottom" id="RadioButton_CustomDocumentHealthHomeServiceNotes_RecentEmergencyDeptEducationProvided_N"
                                                    name="RadioButton_CustomDocumentHealthHomeServiceNotes_RecentEmergencyDeptEducationProvided"
                                                    value="N" />
                                                <label for="RadioButton_CustomDocumentHealthHomeServiceNotes_RecentEmergencyDeptEducationProvided_N">
                                                    No</label>&nbsp&nbsp<input class="cursor_default" type="radio" style="vertical-align: bottom"
                                                        id="RadioButton_CustomDocumentHealthHomeServiceNotes_RecentEmergencyDeptEducationProvided_Y"
                                                        name="RadioButton_CustomDocumentHealthHomeServiceNotes_RecentEmergencyDeptEducationProvided"
                                                        value="Y" />
                                                <label for="RadioButton_CustomDocumentHealthHomeServiceNotes_RecentEmergencyDeptEducationProvided_Y">
                                                    Yes</label>&nbsp&nbsp<input class="cursor_default" type="radio" style="vertical-align: bottom"
                                                        id="RadioButton_CustomDocumentHealthHomeServiceNotes_RecentEmergencyDeptEducationProvided_A"
                                                        name="RadioButton_CustomDocumentHealthHomeServiceNotes_RecentEmergencyDeptEducationProvided"
                                                        value="A" />
                                                <label for="RadioButton_CustomDocumentHealthHomeServiceNotes_RecentEmergencyDeptEducationProvided_A">
                                                    N/A</label>
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
                                    Physical Care </span>&nbsp;
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
                                            <td style="width: 100%" colspan="2">
                                                Recent physical care hospital discharge? &nbsp&nbsp
                                                <input class="cursor_default" type="radio" style="vertical-align: bottom" id="RadioButton_CustomDocumentHealthHomeServiceNotes_RecentPhysicalHospitalDischarge_N"
                                                    name="RadioButton_CustomDocumentHealthHomeServiceNotes_RecentPhysicalHospitalDischarge"
                                                    value="N" onclick="EnableOrDisableControls()" />
                                                <label for="RadioButton_CustomDocumentHealthHomeServiceNotes_RecentPhysicalHospitalDischarge">
                                                    No</label>&nbsp&nbsp<input class="cursor_default" type="radio" style="vertical-align: bottom"
                                                        id="RadioButton_CustomDocumentHealthHomeServiceNotes_RecentPhysicalHospitalDischarge_Y"
                                                        name="RadioButton_CustomDocumentHealthHomeServiceNotes_RecentPhysicalHospitalDischarge"
                                                        value="Y" onclick="EnableOrDisableControls()" />
                                                <label for="RadioButton_CustomDocumentHealthHomeServiceNotes_RecentPhysicalHospitalDischarge">
                                                    Yes</label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height2">
                                            </td>
                                        </tr>
                                        <tr id="Physical1">
                                            <td style="width: 40%">
                                                <span class="form_label_text" id="Span48">If yes, Discharge date</span>
                                                <input type="text" id="TextBox_CustomDocumentHealthHomeServiceNotes_RecentPhysicalHospitalDischargeDate"
                                                    name="TextBox_CustomDocumentHealthHomeServiceNotes_RecentPhysicalHospitalDischargeDate"
                                                    datatype="Date" class="form_textbox element" style="width: 75px;" />
                                                <img id="Img21" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                    onclick="return showCalendar('TextBox_CustomDocumentHealthHomeServiceNotes_RecentPhysicalHospitalDischargeDate', '%m/%d/%Y');"
                                                    style="cursor: hand;" filter="false" />
                                            </td>
                                            <td style="width: 60%">
                                                <span class="form_label_text" id="Span49">Follow up date</span>
                                                <input type="text" id="TextBox_CustomDocumentHealthHomeServiceNotes_RecentPhysicalHospitalFollowUpDate"
                                                    name="TextBox_CustomDocumentHealthHomeServiceNotes_RecentPhysicalHospitalFollowUpDate"
                                                    datatype="Date" onchange="CheckDateRange('TextBox_CustomDocumentHealthHomeServiceNotes_RecentPhysicalHospitalDischargeDate','TextBox_CustomDocumentHealthHomeServiceNotes_RecentPhysicalHospitalFollowUpDate','Physical');"
                                                    class="form_textbox element" style="width: 75px;" />
                                                <img id="Img22" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                    onclick="return showCalendar('TextBox_CustomDocumentHealthHomeServiceNotes_RecentPhysicalHospitalFollowUpDate', '%m/%d/%Y');"
                                                    style="cursor: hand;" filter="false" />
                                                <span class="form_label_text" id="Span50">(must be within 14 days)</span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height2">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 100%" colspan="2" id="Physical2">
                                                If yes, transition plan completed? &nbsp&nbsp
                                                <input class="cursor_default" type="radio" style="vertical-align: bottom" id="RadioButton_CustomDocumentHealthHomeServiceNotes_RecentPhysicalHospitalTransitionCompleted_N"
                                                    name="RadioButton_CustomDocumentHealthHomeServiceNotes_RecentPhysicalHospitalTransitionCompleted"
                                                    value="N" />
                                                <label for="RadioButton_CustomDocumentHealthHomeServiceNotes_RecentPhysicalHospitalTransitionCompleted_N">
                                                    No</label>&nbsp&nbsp<input class="cursor_default" type="radio" style="vertical-align: bottom"
                                                        id="RadioButton_CustomDocumentHealthHomeServiceNotes_RecentPhysicalHospitalTransitionCompleted_Y"
                                                        name="RadioButton_CustomDocumentHealthHomeServiceNotes_RecentPhysicalHospitalTransitionCompleted"
                                                        value="Y" />
                                                <label for="RadioButton_CustomDocumentHealthHomeServiceNotes_RecentPhysicalHospitalTransitionCompleted_Y">
                                                    Yes</label>
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
                                    P<span lang="EN-US">lanned Transitions </span>&nbsp;
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
                                            <td style="width: 100%" colspan="2">
                                                Any planned transitions to/from Long Term Care or AOD Rehabilitation? &nbsp&nbsp
                                                <input class="cursor_default" type="radio" style="vertical-align: bottom" id="RadioButton_CustomDocumentHealthHomeServiceNotes_PlannedTransitionsLongTermCareAOD_N"
                                                    name="RadioButton_CustomDocumentHealthHomeServiceNotes_PlannedTransitionsLongTermCareAOD"
                                                    onclick="EnableOrDisableControls()" value="N" />
                                                <label for="RadioButton_CustomDocumentHealthHomeServiceNotes_PlannedTransitionsLongTermCareAOD">
                                                    No</label>&nbsp&nbsp<input class="cursor_default" type="radio" style="vertical-align: bottom"
                                                        id="RadioButton_CustomDocumentHealthHomeServiceNotes_PlannedTransitionsLongTermCareAOD_Y"
                                                        name="RadioButton_CustomDocumentHealthHomeServiceNotes_PlannedTransitionsLongTermCareAOD"
                                                        onclick="EnableOrDisableControls()" value="Y" />
                                                <label for="RadioButton_CustomDocumentHealthHomeServiceNotes_PlannedTransitionsLongTermCareAOD">
                                                    Yes</label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height2">
                                            </td>
                                        </tr>
                                        <tr id="AODComments1">
                                            <td style="width: 100%">
                                                <span class="form_label_text" id="Span51">If Yes, describe including dates and location</span>
                                                <textarea id="TextArea_CustomDocumentHealthHomeServiceNotes_PlannedTransitionsLongTermCareAODComment"
                                                    name="TextArea_CustomDocumentHealthHomeServiceNotes_PlannedTransitionsLongTermCareAODComment"
                                                    rows="4" cols="158" class="form_textarea" spellcheck="True"></textarea>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height2">
                                            </td>
                                        </tr>
                                        <tr id="AODComments2">
                                            <td style="width: 100%" colspan="2">
                                                If yes, transition plan completed? &nbsp&nbsp
                                                <input class="cursor_default" type="radio" style="vertical-align: bottom" id="RadioButton_CustomDocumentHealthHomeServiceNotes_PlannedTransitionsLongTermCareAODTransitionCompleted_N"
                                                    name="RadioButton_CustomDocumentHealthHomeServiceNotes_PlannedTransitionsLongTermCareAODTransitionCompleted"
                                                    value="N" />
                                                <label for="RadioButton_CustomDocumentHealthHomeServiceNotes_PlannedTransitionsLongTermCareAODTransitionCompleted">
                                                    No</label>&nbsp&nbsp<input class="cursor_default" type="radio" style="vertical-align: bottom"
                                                        id="RadioButton_CustomDocumentHealthHomeServiceNotes_PlannedTransitionsLongTermCareAODTransitionCompleted_Y"
                                                        name="RadioButton_CustomDocumentHealthHomeServiceNotes_PlannedTransitionsLongTermCareAODTransitionCompleted"
                                                        value="Y" />
                                                <label for="RadioButton_CustomDocumentHealthHomeServiceNotes_PlannedTransitionsLongTermCareAODTransitionCompleted">
                                                    Yes</label>
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
                                    Comprehensive Care Management
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
                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                            <tr>
                                <td>
                                    <input class="cursor_default" type="checkbox" id="Checkbox_CustomDocumentHealthHomeServiceNotes_CCMIdentificationEligibility"
                                        name="Checkbox_CustomDocumentHealthHomeServiceNotes_CCMIdentificationEligibility"
                                        style="vertical-align: bottom" onclick="" />
                                    <label for="Checkbox_CustomDocumentHealthHomeServiceNotes_CCMIdentificationEligibility">
                                        Identification of eligibility for health home services</label>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input class="cursor_default" type="checkbox" id="Checkbox_CustomDocumentHealthHomeServiceNotes_CCMProvideServiceOrientation"
                                        name="Checkbox_CustomDocumentHealthHomeServiceNotes_CCMProvideServiceOrientation"
                                        style="vertical-align: bottom" onclick="" />
                                    <label for="Checkbox_CustomDocumentHealthHomeServiceNotes_CCMProvideServiceOrientation">
                                        Provide service orientation</label>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input class="cursor_default" type="checkbox" id="Checkbox_CustomDocumentHealthHomeServiceNotes_CCMComprehensiveHealthAssessment"
                                        name="Checkbox_CustomDocumentHealthHomeServiceNotes_CCMComprehensiveHealthAssessment"
                                        style="vertical-align: bottom" onclick="" />
                                    <label for="Checkbox_CustomDocumentHealthHomeServiceNotes_CCMComprehensiveHealthAssessment">
                                        Comprehensive health assessment</label>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input class="cursor_default" type="checkbox" id="Checkbox_CustomDocumentHealthHomeServiceNotes_CCMDevelopUpdateCarePlan"
                                        name="Checkbox_CustomDocumentHealthHomeServiceNotes_CCMDevelopUpdateCarePlan"
                                        style="vertical-align: bottom" onclick="" />
                                    <label for="Checkbox_CustomDocumentHealthHomeServiceNotes_CCMDevelopUpdateCarePlan">
                                        Develop/update Care Plan</label>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input class="cursor_default" type="checkbox" id="Checkbox_CustomDocumentHealthHomeServiceNotes_CCMDevelopUpdateCommPlan"
                                        name="Checkbox_CustomDocumentHealthHomeServiceNotes_CCMDevelopUpdateCommPlan"
                                        style="vertical-align: bottom" onclick="" />
                                    <label for="Checkbox_CustomDocumentHealthHomeServiceNotes_CCMDevelopUpdateCommPlan">
                                        Develop/update Communication Plan</label>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input class="cursor_default" type="checkbox" id="Checkbox_CustomDocumentHealthHomeServiceNotes_CCMDevelopUpdateCrisisPlan"
                                        name="Checkbox_CustomDocumentHealthHomeServiceNotes_CCMDevelopUpdateCrisisPlan"
                                        style="vertical-align: bottom" onclick="" />
                                    <label for="Checkbox_CustomDocumentHealthHomeServiceNotes_CCMDevelopUpdateCrisisPlan">
                                        Develop/update Crisis Management and Contingency Plan</label>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
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
                                    Care Coordination
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
                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                            <tr>
                                <td>
                                    <input class="cursor_default" type="checkbox" id="Checkbox_CustomDocumentHealthHomeServiceNotes_CCImplementationCarePlan"
                                        name="Checkbox_CustomDocumentHealthHomeServiceNotes_CCImplementationCarePlan"
                                        style="vertical-align: bottom" onclick="" />
                                    <label for="Checkbox_CustomDocumentHealthHomeServiceNotes_CCImplementationCarePlan">
                                        Implementation of care plan/monitoring of progress</label>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input class="cursor_default" type="checkbox" id="Checkbox_CustomDocumentHealthHomeServiceNotes_CCAssistanceObtainingHealthcare"
                                        name="Checkbox_CustomDocumentHealthHomeServiceNotes_CCAssistanceObtainingHealthcare"
                                        style="vertical-align: bottom" onclick="" />
                                    <label for="Checkbox_CustomDocumentHealthHomeServiceNotes_CCAssistanceObtainingHealthcare">
                                        Assistance in obtaining healthcare</label>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input class="cursor_default" type="checkbox" id="Checkbox_CustomDocumentHealthHomeServiceNotes_CCMedicationManagement"
                                        name="Checkbox_CustomDocumentHealthHomeServiceNotes_CCMedicationManagement" style="vertical-align: bottom"
                                        onclick="" />
                                    <label for="Checkbox_CustomDocumentHealthHomeServiceNotes_CCMedicationManagement">
                                        Medication management/Medication reconciliation</label>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input class="cursor_default" type="checkbox" id="Checkbox_CustomDocumentHealthHomeServiceNotes_CCTrackTests"
                                        name="Checkbox_CustomDocumentHealthHomeServiceNotes_CCTrackTests" style="vertical-align: bottom"
                                        onclick="" />
                                    <label for="Checkbox_CustomDocumentHealthHomeServiceNotes_CCTrackTests">
                                        Track tests, referrals, and follow-up</label>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input class="cursor_default" type="checkbox" id="Checkbox_CustomDocumentHealthHomeServiceNotes_CCCoordinationProviders"
                                        name="Checkbox_CustomDocumentHealthHomeServiceNotes_CCCoordinationProviders"
                                        style="vertical-align: bottom" onclick="" />
                                    <label for="Checkbox_CustomDocumentHealthHomeServiceNotes_CCCoordinationProviders">
                                        Coordination/collaboration with patient/supports/other providers</label>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input class="cursor_default" type="checkbox" id="Checkbox_CustomDocumentHealthHomeServiceNotes_CCDevelopmentCrisisPlan"
                                        name="Checkbox_CustomDocumentHealthHomeServiceNotes_CCDevelopmentCrisisPlan"
                                        style="vertical-align: bottom" onclick="" />
                                    <label for="Checkbox_CustomDocumentHealthHomeServiceNotes_CCDevelopmentCrisisPlan">
                                        Development of crisis management/contingency plan</label>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input class="cursor_default" type="checkbox" id="Checkbox_CustomDocumentHealthHomeServiceNotes_CCCoordinationReferrals"
                                        name="Checkbox_CustomDocumentHealthHomeServiceNotes_CCCoordinationReferrals"
                                        style="vertical-align: bottom" onclick="" />
                                    <label for="Checkbox_CustomDocumentHealthHomeServiceNotes_CCCoordinationReferrals">
                                        Coordination of referrals, scheduling appointments, appointment follow up</label>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input class="cursor_default" type="checkbox" id="Checkbox_CustomDocumentHealthHomeServiceNotes_CC90DayAssessment"
                                        name="Checkbox_CustomDocumentHealthHomeServiceNotes_CC90DayAssessment" style="vertical-align: bottom"
                                        onclick="" />
                                    <label for="Checkbox_CustomDocumentHealthHomeServiceNotes_CC90DayAssessment">
                                        90 day assessment</label>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input class="cursor_default" type="checkbox" id="Checkbox_CustomDocumentHealthHomeServiceNotes_CCPeriodicClinicalSummary"
                                        name="Checkbox_CustomDocumentHealthHomeServiceNotes_CCPeriodicClinicalSummary"
                                        style="vertical-align: bottom" onclick="" />
                                    <label for="Checkbox_CustomDocumentHealthHomeServiceNotes_CCPeriodicClinicalSummary">
                                        Creation of periodic clinical summary or routine report for treatment team/patient/supports</label>
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
                                    Health Promotion
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
                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                            <tr>
                                <td>
                                    <input class="cursor_default" type="checkbox" id="Checkbox_CustomDocumentHealthHomeServiceNotes_HPProvisionHealthEducation"
                                        name="Checkbox_CustomDocumentHealthHomeServiceNotes_HPProvisionHealthEducation"
                                        style="vertical-align: bottom" onclick="" />
                                    <label for="Checkbox_CustomDocumentHealthHomeServiceNotes_HPProvisionHealthEducation">
                                        Provision of health education/appropriate care settings</label>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input class="cursor_default" type="checkbox" id="Checkbox_CustomDocumentHealthHomeServiceNotes_HPAssistedSelfMonitoring"
                                        name="Checkbox_CustomDocumentHealthHomeServiceNotes_HPAssistedSelfMonitoring"
                                        style="vertical-align: bottom" onclick="" />
                                    <label for="Checkbox_CustomDocumentHealthHomeServiceNotes_HPAssistedSelfMonitoring">
                                        Assisted patient in self-monitoring and symptom management</label>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input class="cursor_default" type="checkbox" id="Checkbox_CustomDocumentHealthHomeServiceNotes_HPProvisionWellnessServices"
                                        name="Checkbox_CustomDocumentHealthHomeServiceNotes_HPProvisionWellnessServices"
                                        style="vertical-align: bottom" onclick="" />
                                    <label for="Checkbox_CustomDocumentHealthHomeServiceNotes_HPProvisionWellnessServices">
                                        Provision of/referral to wellness/healthy lifestyle services</label>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input class="cursor_default" type="checkbox" id="Checkbox_CustomDocumentHealthHomeServiceNotes_HPEngagePlanMonitoring"
                                        name="Checkbox_CustomDocumentHealthHomeServiceNotes_HPEngagePlanMonitoring" style="vertical-align: bottom"
                                        onclick="" />
                                    <label for="Checkbox_CustomDocumentHealthHomeServiceNotes_HPEngagePlanMonitoring">
                                        Engage patient in care plan development/monitoring</label>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input class="cursor_default" type="checkbox" id="Checkbox_CustomDocumentHealthHomeServiceNotes_HPReferralToSelfHelp"
                                        name="Checkbox_CustomDocumentHealthHomeServiceNotes_HPReferralToSelfHelp" style="vertical-align: bottom"
                                        onclick="" />
                                    <label for="Checkbox_CustomDocumentHealthHomeServiceNotes_HPReferralToSelfHelp">
                                        Referral to self-help/self-management/advocacy programs/peer supports</label>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input class="cursor_default" type="checkbox" id="Checkbox_CustomDocumentHealthHomeServiceNotes_HPDevelopmentCrisisPlan"
                                        name="Checkbox_CustomDocumentHealthHomeServiceNotes_HPDevelopmentCrisisPlan"
                                        style="vertical-align: bottom" onclick="" />
                                    <label for="Checkbox_CustomDocumentHealthHomeServiceNotes_HPDevelopmentCrisisPlan">
                                        Development of self-management crisis plan to reduce unscheduled service visits</label>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input class="cursor_default" type="checkbox" id="Checkbox_CustomDocumentHealthHomeServiceNotes_HPAppointmentServiceReminders"
                                        name="Checkbox_CustomDocumentHealthHomeServiceNotes_HPAppointmentServiceReminders"
                                        style="vertical-align: bottom" onclick="" />
                                    <label for="Checkbox_CustomDocumentHealthHomeServiceNotes_HPAppointmentServiceReminders">
                                        Appointment/service reminders</label>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input class="cursor_default" type="checkbox" id="Checkbox_CustomDocumentHealthHomeServiceNotes_HPPromotionHealthLifestyle"
                                        name="Checkbox_CustomDocumentHealthHomeServiceNotes_HPPromotionHealthLifestyle"
                                        style="vertical-align: bottom" onclick="" />
                                    <label for="Checkbox_CustomDocumentHealthHomeServiceNotes_HPPromotionHealthLifestyle">
                                        Promotion of behavioral and healthy lifestyle choices</label>
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
                                    Comprehensive Transitional Care & Follow Up
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
                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                            <tr>
                                <td>
                                    <input class="cursor_default" type="checkbox" id="Checkbox_CustomDocumentHealthHomeServiceNotes_CTCCoordinationProviders"
                                        name="Checkbox_CustomDocumentHealthHomeServiceNotes_CTCCoordinationProviders"
                                        style="vertical-align: bottom" onclick="" />
                                    <label for="Checkbox_CustomDocumentHealthHomeServiceNotes_CTCCoordinationProviders">
                                        Coordination with providers</label>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input class="cursor_default" type="checkbox" id="Checkbox_CustomDocumentHealthHomeServiceNotes_CTCFacilitateDischarge"
                                        name="Checkbox_CustomDocumentHealthHomeServiceNotes_CTCFacilitateDischarge" style="vertical-align: bottom"
                                        onclick="" />
                                    <label for="Checkbox_CustomDocumentHealthHomeServiceNotes_CTCFacilitateDischarge">
                                        Facilitate discharge plans/clinical hand-offs between service providers</label>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input class="cursor_default" type="checkbox" id="Checkbox_CustomDocumentHealthHomeServiceNotes_CTCDevelopComprehensiveDischargePlan"
                                        name="Checkbox_CustomDocumentHealthHomeServiceNotes_CTCDevelopComprehensiveDischargePlan"
                                        style="vertical-align: bottom" onclick="" />
                                    <label for="Checkbox_CustomDocumentHealthHomeServiceNotes_CTCDevelopComprehensiveDischargePlan">
                                        Development of comprehensive discharge plan</label>
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
                                    Individual and Family Supports
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
                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                            <tr>
                                <td>
                                    <input class="cursor_default" type="checkbox" id="Checkbox_CustomDocumentHealthHomeServiceNotes_IFSSupportRelationships"
                                        name="Checkbox_CustomDocumentHealthHomeServiceNotes_IFSSupportRelationships"
                                        style="vertical-align: bottom" onclick="" />
                                    <label for="Checkbox_CustomDocumentHealthHomeServiceNotes_IFSSupportRelationships">
                                        Support relationship between patient/supports and service providers</label>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input class="cursor_default" type="checkbox" id="Checkbox_CustomDocumentHealthHomeServiceNotes_IFSAdvocacyBenefits"
                                        name="Checkbox_CustomDocumentHealthHomeServiceNotes_IFSAdvocacyBenefits" style="vertical-align: bottom"
                                        onclick="" />
                                    <label for="Checkbox_CustomDocumentHealthHomeServiceNotes_IFSAdvocacyBenefits">
                                        Advocacy/Benefits analysis/Obtaining benefits</label>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input class="cursor_default" type="checkbox" id="Checkbox_CustomDocumentHealthHomeServiceNotes_IFSProvidedEducation"
                                        name="Checkbox_CustomDocumentHealthHomeServiceNotes_IFSProvidedEducation" style="vertical-align: bottom"
                                        onclick="" />
                                    <label for="Checkbox_CustomDocumentHealthHomeServiceNotes_IFSProvidedEducation">
                                        Provided education regarding self-management of chronic conditions including daily
                                        living skills</label>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input class="cursor_default" type="checkbox" id="Checkbox_CustomDocumentHealthHomeServiceNotes_IFSAssistedObtainingMedications"
                                        name="Checkbox_CustomDocumentHealthHomeServiceNotes_IFSAssistedObtainingMedications"
                                        style="vertical-align: bottom" onclick="" />
                                    <label for="Checkbox_CustomDocumentHealthHomeServiceNotes_IFSAssistedObtainingMedications">
                                        Assisted with obtaining medications and/or provided education regarding importance
                                        of adhering to medications and prescribed treatments</label>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input class="cursor_default" type="checkbox" id="Checkbox_CustomDocumentHealthHomeServiceNotes_IFSAssistanceOvercomeBarriers"
                                        name="Checkbox_CustomDocumentHealthHomeServiceNotes_IFSAssistanceOvercomeBarriers"
                                        style="vertical-align: bottom" onclick="" />
                                    <label for="Checkbox_CustomDocumentHealthHomeServiceNotes_IFSAssistanceOvercomeBarriers">
                                        Provided assistance or education to overcome behavioral or symptomatic barriers
                                        to education, employment, or meaningful activities/goals</label>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input class="cursor_default" type="checkbox" id="Checkbox_CustomDocumentHealthHomeServiceNotes_IFSFacilitatedFamilyInvolvement"
                                        name="Checkbox_CustomDocumentHealthHomeServiceNotes_IFSFacilitatedFamilyInvolvement"
                                        style="vertical-align: bottom" onclick="" />
                                    <label for="Checkbox_CustomDocumentHealthHomeServiceNotes_IFSFacilitatedFamilyInvolvement">
                                        Facilitated family involvement in assessment or care plan update</label>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input class="cursor_default" type="checkbox" id="Checkbox_CustomDocumentHealthHomeServiceNotes_IFSReferralsCommunitySupports"
                                        name="Checkbox_CustomDocumentHealthHomeServiceNotes_IFSReferralsCommunitySupports"
                                        style="vertical-align: bottom" onclick="" />
                                    <label for="Checkbox_CustomDocumentHealthHomeServiceNotes_IFSReferralsCommunitySupports">
                                        Referrals to community supports/strengthening natural supports</label>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input class="cursor_default" type="checkbox" id="Checkbox_CustomDocumentHealthHomeServiceNotes_IFSPromotionPersonalIndependence"
                                        name="Checkbox_CustomDocumentHealthHomeServiceNotes_IFSPromotionPersonalIndependence"
                                        style="vertical-align: bottom" onclick="" />
                                    <label for="Checkbox_CustomDocumentHealthHomeServiceNotes_IFSPromotionPersonalIndependence">
                                        Promotion of personal independence/empowering patient</label>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input class="cursor_default" type="checkbox" id="Checkbox_CustomDocumentHealthHomeServiceNotes_IFSObtainedFeedback"
                                        name="Checkbox_CustomDocumentHealthHomeServiceNotes_IFSObtainedFeedback" style="vertical-align: bottom"
                                        onclick="" />
                                    <label for="Checkbox_CustomDocumentHealthHomeServiceNotes_IFSObtainedFeedback">
                                        Obtained feedback regarding service provision</label>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input class="cursor_default" type="checkbox" id="Checkbox_CustomDocumentHealthHomeServiceNotes_IFSReviewedRecordWithPatient"
                                        name="Checkbox_CustomDocumentHealthHomeServiceNotes_IFSReviewedRecordWithPatient"
                                        style="vertical-align: bottom" onclick="" />
                                    <label for="Checkbox_CustomDocumentHealthHomeServiceNotes_IFSReviewedRecordWithPatient">
                                        Reviewed record with patient/family</label>
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
                                    Referral to Community and Social Support Services
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
                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                            <tr>
                                <td>
                                    <input class="cursor_default" type="checkbox" id="Checkbox_CustomDocumentHealthHomeServiceNotes_RCSSReferralSelfHelp"
                                        name="Checkbox_CustomDocumentHealthHomeServiceNotes_RCSSReferralSelfHelp" style="vertical-align: bottom"
                                        onclick="" />
                                    <label for="Checkbox_CustomDocumentHealthHomeServiceNotes_RCSSReferralSelfHelp">
                                        Referral to self-help/self-management/advocacy programs/peer supports</label>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input class="cursor_default" type="checkbox" id="Checkbox_CustomDocumentHealthHomeServiceNotes_RCSSReferralsCommunitySupports"
                                        name="Checkbox_CustomDocumentHealthHomeServiceNotes_RCSSReferralsCommunitySupports"
                                        style="vertical-align: bottom" onclick="" />
                                    <label for="Checkbox_CustomDocumentHealthHomeServiceNotes_RCSSReferralsCommunitySupports">
                                        Referrals to community supports/strengthening natural supports</label>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input class="cursor_default" type="checkbox" id="Checkbox_CustomDocumentHealthHomeServiceNotes_RCSSCoordinationReferrals"
                                        name="Checkbox_CustomDocumentHealthHomeServiceNotes_RCSSCoordinationReferrals"
                                        style="vertical-align: bottom" onclick="" />
                                    <label for="Checkbox_CustomDocumentHealthHomeServiceNotes_RCSSCoordinationReferrals">
                                        Coordination of referrals, scheduling appointments, appointment follow up</label>
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
                                    Tobacco Use Assessment
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
                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                            <tr>
                                <td>
                                    <input class="cursor_default" type="checkbox" id="Checkbox_CustomDocumentHealthHomeServiceNotes_TobaccoCurrentEveryDay"
                                        name="Checkbox_CustomDocumentHealthHomeServiceNotes_TobaccoCurrentEveryDay" style="vertical-align: bottom"
                                        onclick="" />
                                    <label for="Checkbox_CustomDocumentHealthHomeServiceNotes_TobaccoCurrentEveryDay">
                                        Current Everyday Smoker</label>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input class="cursor_default" type="checkbox" id="Checkbox_CustomDocumentHealthHomeServiceNotes_TobaccoCurrentSomeDay"
                                        name="Checkbox_CustomDocumentHealthHomeServiceNotes_TobaccoCurrentSomeDay" style="vertical-align: bottom"
                                        onclick="" />
                                    <label for="Checkbox_CustomDocumentHealthHomeServiceNotes_TobaccoCurrentSomeDay">
                                        Current some day smoker</label>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input class="cursor_default" type="checkbox" id="Checkbox_CustomDocumentHealthHomeServiceNotes_TobaccoUsesSmokeless"
                                        name="Checkbox_CustomDocumentHealthHomeServiceNotes_TobaccoUsesSmokeless" style="vertical-align: bottom"
                                        onclick="" />
                                    <label for="Checkbox_CustomDocumentHealthHomeServiceNotes_TobaccoUsesSmokeless">
                                        Uses Smokeless tobacco</label>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input class="cursor_default" type="checkbox" id="Checkbox_CustomDocumentHealthHomeServiceNotes_TobaccoCurrentStatusUnknown"
                                        name="Checkbox_CustomDocumentHealthHomeServiceNotes_TobaccoCurrentStatusUnknown"
                                        style="vertical-align: bottom" onclick="" />
                                    <label for="Checkbox_CustomDocumentHealthHomeServiceNotes_TobaccoCurrentStatusUnknown">
                                        Current status unknown</label>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input class="cursor_default" type="checkbox" id="Checkbox_CustomDocumentHealthHomeServiceNotes_TobaccoFormerSmoker"
                                        name="Checkbox_CustomDocumentHealthHomeServiceNotes_TobaccoFormerSmoker" style="vertical-align: bottom"
                                        onclick="" />
                                    <label for="Checkbox_CustomDocumentHealthHomeServiceNotes_TobaccoFormerSmoker">
                                        Former smoker</label>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input class="cursor_default" type="checkbox" id="Checkbox_CustomDocumentHealthHomeServiceNotes_TobaccoNeverSmoker"
                                        name="Checkbox_CustomDocumentHealthHomeServiceNotes_TobaccoNeverSmoker" style="vertical-align: bottom"
                                        onclick="" />
                                    <label for="Checkbox_CustomDocumentHealthHomeServiceNotes_TobaccoNeverSmoker">
                                        Never smoker</label>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input class="cursor_default" type="checkbox" id="Checkbox_CustomDocumentHealthHomeServiceNotes_TobaccoUnknownEverSmoked"
                                        name="Checkbox_CustomDocumentHealthHomeServiceNotes_TobaccoUnknownEverSmoked"
                                        style="vertical-align: bottom" onclick="" />
                                    <label for="Checkbox_CustomDocumentHealthHomeServiceNotes_TobaccoUnknownEverSmoked">
                                        Unknown if ever smoked</label>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Tobacco Reduction/Cessation Counseling:
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input class="cursor_default" type="checkbox" id="Checkbox_CustomDocumentHealthHomeServiceNotes_TobaccoReductionCessationCounselingProvided"
                                        name="Checkbox_CustomDocumentHealthHomeServiceNotes_TobaccoReductionCessationCounselingProvided"
                                        style="vertical-align: bottom" onclick="" />
                                    <label for="Checkbox_CustomDocumentHealthHomeServiceNotes_TobaccoReductionCessationCounselingProvided">
                                        If current smoker or smokeless tobacco user, counseled against tobacco use and/or
                                        provided reduction strategies</label>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
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
                                    Patient Notification
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
                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                            <tr>
                                <td>
                                    <input class="cursor_default" type="checkbox" id="Checkbox_CustomDocumentHealthHomeServiceNotes_PatientReportedInitationOfAODTreatment"
                                        name="Checkbox_CustomDocumentHealthHomeServiceNotes_PatientReportedInitationOfAODTreatment"
                                        style="vertical-align: bottom" onclick="" />
                                    <label for="Checkbox_CustomDocumentHealthHomeServiceNotes_PatientReportedInitationOfAODTreatment">
                                        Patient reported initiation of AOD treatment</label>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input class="cursor_default" type="checkbox" id="Checkbox_CustomDocumentHealthHomeServiceNotes_PatientReportedAnnualDentalVisit"
                                        name="Checkbox_CustomDocumentHealthHomeServiceNotes_PatientReportedAnnualDentalVisit"
                                        style="vertical-align: bottom" onclick="" />
                                    <label for="Checkbox_CustomDocumentHealthHomeServiceNotes_PatientReportedAnnualDentalVisit">
                                        Patient reported annual dental visit</label>
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
                                    Additional Treatments
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
                                <td>
                                    <label for="Checkbox_CustomDocumentHealthHomeServiceNotes_ServiceOrOtherTreatmentsProvided">
                                        Describe Service or Additional Treatments Provided</label>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <textarea id="TextArea_CustomDocumentHealthHomeServiceNotes_ServiceOrOtherTreatmentsProvided"
                                        name="TextArea_CustomDocumentHealthHomeServiceNotes_ServiceOrOtherTreatmentsProvided"
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
                                    Plan/Instructions
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
                                <td>
                                    <textarea id="TextArea_CustomDocumentHealthHomeServiceNotes_PlanInstructions" name="TextArea_CustomDocumentHealthHomeServiceNotes_PlanInstructions"
                                        rows="4" cols="158" class="form_textarea" spellcheck="True"></textarea>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Recommended Changes to the Care Plan? &nbsp&nbsp
                                    <input class="cursor_default" type="radio" style="vertical-align: bottom" id="RadioButton_CustomDocumentHealthHomeServiceNotes_RecommendChangesCarePlan_N"
                                        name="RadioButton_CustomDocumentHealthHomeServiceNotes_RecommendChangesCarePlan"
                                        value="N" />
                                    <label for="RadioButton_CustomDocumentHealthHomeServiceNotes_RecommendChangesCarePlan">
                                        No</label>&nbsp&nbsp<input class="cursor_default" type="radio" style="vertical-align: bottom"
                                            id="RadioButton_CustomDocumentHealthHomeServiceNotes_RecommendChangesCarePlan_Y"
                                            name="RadioButton_CustomDocumentHealthHomeServiceNotes_RecommendChangesCarePlan"
                                            value="Y" />
                                    <label for="RadioButton_CustomDocumentHealthHomeServiceNotes_RecommendChangesCarePlan">
                                        Yes</label>
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
<asp:Panel ID="PanelLoadUC" runat="server">
</asp:Panel>


