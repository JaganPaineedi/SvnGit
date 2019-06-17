<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CustomComprehensiveHealthEvaluation.ascx.cs"
    Inherits="SHS.SmartCare.CustomComprehensiveHealthEvaluation" %>
<%@ Register Src="~/CommonUserControls/CustomGrid.ascx" TagName="CustomGrid" TagPrefix="uc1" %>
<%@ Register Src="~/CommonUserControls/DynamicForms.ascx" TagName="DynamicForms"
    TagPrefix="uc2" %>
<% if (HttpContext.Current == null)
   { %>
<link href="../../../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet"
    type="text/css" />
<%} %>

<script language="javascript" type="text/javascript" src="<%=RelativePath%>Custom/Scripts/ComprehensiveHealthEvaluation.js" ></script>

<input id="HiddenFieldPageTables" runat="server" name="HiddenFieldPageTables" type="hidden" value="CustomDocumentHealthHomeHealthEvaluations" />
<table class="DocumentScreen" border="0" cellspacing="0" cellpadding="0" style="padding-right: 25px">
    <tr>
        <td>
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
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td style="padding-left: 10px; padding-right: 5px">
                                    <textarea id="TextArea_CustomDocumentHealthHomeHealthEvaluations_CurrentMentalHealthDiagnoses"
                                        name="TextArea_CustomDocumentHealthHomeHealthEvaluations_CurrentMentalHealthDiagnoses"
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
                                        baseurl="<%=ResolveUrl("~") %>" onclick="return ComprehensiveHealthEvaluation.InsertGrid_CustomDocumentHealthHomeCarePlanDiagnosesData('TableChildControl_CustomDocumentHealthHomeCarePlanDiagnoses','InsertGrid_CustomDocumentHealthHomeCarePlanDiagnoses','CustomGrid_CustomDocumentHealthHomeCarePlanDiagnoses', this);"
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
                                    <textarea id="TextArea_CustomDocumentHealthHomeHealthEvaluations_CurrentDDDiagnoses"
                                        name="TextArea_CustomDocumentHealthHomeHealthEvaluations_CurrentDDDiagnoses"
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
                                    Suicide/Threats to Personal Safety Risk
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
                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                            <tr>
                                <td>
                                    <div id="DivDiagnosticRiskAssessmentDFA">
                                        <uc2:DynamicForms ID="DynamicFormsDiagnosticRiskAssessment" runat="server" />
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
                                    Substance/Tobacco: Current or Historic
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
                        <table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 8px">
                            <tr>
                                <td style="padding-right: 5px; width: 18%">
                                    Alcohol Use
                                </td>
                                <td style="padding-right: 5px; width: 82%">
                                    <textarea id="TextArea_CustomDocumentHealthHomeHealthEvaluations_AlcoholUse" name="TextArea_CustomDocumentHealthHomeHealthEvaluations_AlcoholUse"
                                        rows="4" cols="158" class="form_textarea" style="width: 95%" spellcheck="True"></textarea>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td style="padding-right: 5px">
                                    Tobacco Use:
                                </td>
                                <td style="padding-left: 10px; padding-right: 5px">
                                </td>
                            </tr>
                            <tr>
                                <td class="height2" colspan="2">
                                </td>
                            </tr>
                            <tr>
                                <td class="height2" colspan="2">
                                    <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                        <tr>
                                            <td>
                                                <input class="cursor_default" type="checkbox" style="vertical-align: bottom" id="Checkbox_CustomDocumentHealthHomeHealthEvaluations_TobaccoCurrentEveryDay"
                                                    name="Checkbox_CustomDocumentHealthHomeHealthEvaluations_TobaccoCurrentEveryDay"
                                                    onclick="" />
                                                <label for="Checkbox_CustomDocumentHealthHomeHealthEvaluations_TobaccoCurrentEveryDay">
                                                    Current Everyday Smoker</label>
                                            </td>
                                            <td width="8px">
                                                &nbsp;
                                            </td>
                                            <td>
                                                <input class="cursor_default" type="checkbox" style="vertical-align: bottom" id="Checkbox_CustomDocumentHealthHomeHealthEvaluations_TobaccoCurrentSomeDay"
                                                    name="Checkbox_CustomDocumentHealthHomeHealthEvaluations_TobaccoCurrentSomeDay"
                                                    onclick="" />
                                                <label for="Checkbox_CustomDocumentHealthHomeHealthEvaluations_TobaccoCurrentSomeDay">
                                                    Current Someday Smoker</label>
                                            </td>
                                            <td width="8px">
                                                &nbsp;
                                            </td>
                                            <td>
                                                <input class="cursor_default" type="checkbox" style="vertical-align: bottom" id="Checkbox_CustomDocumentHealthHomeHealthEvaluations_TobaccoUsesSmokeless"
                                                    name="Checkbox_CustomDocumentHealthHomeHealthEvaluations_TobaccoUsesSmokeless"
                                                    onclick="" />
                                                <label for="Checkbox_CustomDocumentHealthHomeHealthEvaluations_TobaccoUsesSmokeless">
                                                    Uses Smokeless Tobacco</label>
                                            </td>
                                            <td width="8px">
                                                &nbsp;
                                            </td>
                                            <td>
                                                <input class="cursor_default" style="vertical-align: bottom" type="checkbox" id="Checkbox_CustomDocumentHealthHomeHealthEvaluations_TobaccoCurrentStatusUnknown"
                                                    name="Checkbox_CustomDocumentHealthHomeHealthEvaluations_TobaccoCurrentStatusUnknown"
                                                    onclick="" />
                                                <label for="Checkbox_CustomDocumentHealthHomeHealthEvaluations_TobaccoCurrentStatusUnknown">
                                                    Current Status Unknown</label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height2">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <input class="cursor_default" type="checkbox" style="vertical-align: bottom" id="Checkbox_CustomDocumentHealthHomeHealthEvaluations_TobaccoFormerSmoke"
                                                    name="Checkbox_CustomDocumentHealthHomeHealthEvaluations_TobaccoFormerSmoke"
                                                    onclick="" />
                                                <label for="Checkbox_CustomDocumentHealthHomeHealthEvaluations_TobaccoFormerSmoke">
                                                    Former Smoker</label>
                                            </td>
                                            <td width="8px">
                                                &nbsp;
                                            </td>
                                            <td>
                                                <input class="cursor_default" type="checkbox" style="vertical-align: bottom" id="Checkbox_CustomDocumentHealthHomeHealthEvaluations_TobaccoNeverSmoker"
                                                    name="Checkbox_CustomDocumentHealthHomeHealthEvaluations_TobaccoNeverSmoker"
                                                    onclick="" />
                                                <label for="Checkbox_CustomDocumentHealthHomeHealthEvaluations_TobaccoNeverSmoker">
                                                    Never Smoker</label>
                                            </td>
                                            <td width="8px">
                                                &nbsp;
                                            </td>
                                            <td>
                                                <input class="cursor_default" type="checkbox" style="vertical-align: bottom" id="Checkbox_CustomDocumentHealthHomeHealthEvaluations_TobaccoUnknownEverSmoked"
                                                    name="Checkbox_CustomDocumentHealthHomeHealthEvaluations_TobaccoUnknownEverSmoked"
                                                    onclick="" />
                                                <label for="Checkbox_CustomDocumentHealthHomeHealthEvaluations_TobaccoUnknownEverSmoked">
                                                    Unknown if ever smoked</label>
                                            </td>
                                            <td width="8px">
                                                &nbsp;
                                            </td>
                                            <td>
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
                                <td style="width: 18%">
                                    Other Drug/Substance Use
                                </td>
                                <td style="padding-right: 5px; width: 82%">
                                    <textarea id="TextArea_CustomDocumentHealthHomeHealthEvaluations_SubstanceUseOther"
                                        name="TextArea_CustomDocumentHealthHomeHealthEvaluations_SubstanceUseOther" rows="4"
                                        style="width: 95%" cols="158" class="form_textarea" spellcheck="True"></textarea>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2" colspan="2">
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    Subtance Use History Questions:
                                </td>
                            </tr>
                            <tr>
                                <td class="height2" colspan="2">
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td style="width: 100%">
                                                Has the client ever been referred for substance abuse or tobacco cessation treatment?&nbsp&nbsp
                                                 <input class="cursor_default" type="radio" style="vertical-align: bottom" id="RadioButton_CustomDocumentHealthHomeHealthEvaluations_SubstanceUseEverReferredTreatment_Y"
                                                    name="RadioButton_CustomDocumentHealthHomeHealthEvaluations_SubstanceUseEverReferredTreatment"
                                                    value="Y" />
                                                <label for="RadioButton_CustomDocumentHealthHomeHealthEvaluations_SubstanceUseEverReferredTreatment_Y">
                                                    Yes</label>&nbsp&nbsp <input class="cursor_default" type="radio" style="vertical-align: bottom" id="RadioButton_CustomDocumentHealthHomeHealthEvaluations_SubstanceUseEverReferredTreatment_N"
                                                    name="RadioButton_CustomDocumentHealthHomeHealthEvaluations_SubstanceUseEverReferredTreatment"
                                                    value="N" />
                                                <label for="RadioButton_CustomDocumentHealthHomeHealthEvaluations_SubstanceUseEverReferredTreatment_N">
                                                    No</label>
                                            </td>
                                          
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2" colspan="2">
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td style="width: 18%">
                                                if Yes, Comment:
                                            </td>
                                            <td style="width: 82%">
                                                <textarea id="TextArea_CustomDocumentHealthHomeHealthEvaluations_SubstanceUseEverReferredTreatmentComment"
                                                    name="TextArea_CustomDocumentHealthHomeHealthEvaluations_SubstanceUseEverReferredTreatmentComment"
                                                    rows="4" cols="158" class="form_textarea" style="width: 95%" spellcheck="True"></textarea>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2" colspan="2">
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td style="width: 100%">
                                                Is the client currently in substance abuse treatment or receiving tobacco cessation
                                                treatment?&nbsp&nbsp  <input class="cursor_default" type="radio" style="vertical-align: bottom" id="Radio1"
                                                    name="RadioButton_CustomDocumentHealthHomeHealthEvaluations_SubstanceUseCurrentTreatment"
                                                    value="Y" />
                                                <label for="RadioButton_CustomDocumentHealthHomeHealthEvaluations_SubstanceUseCurrentTreatment_Y">
                                                    Yes</label>&nbsp&nbsp  <input class="cursor_default" type="radio" style="vertical-align: bottom" id="Radio2"
                                                    name="RadioButton_CustomDocumentHealthHomeHealthEvaluations_SubstanceUseCurrentTreatment"
                                                    value="N" />
                                                <label for="RadioButton_CustomDocumentHealthHomeHealthEvaluations_SubstanceUseCurrentTreatment_N">
                                                    No</label>
                                            </td>
                                           
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2" colspan="2">
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td style="width: 18%">
                                                if Yes, Comment:
                                            </td>
                                            <td style="width: 82%">
                                                <%-- <input class="LPadd8 form_textbox" style="width: 65%" type="text" id="TextBox_CustomDocumentHealthHomeHealthEvaluations_SubstanceUseCurrentTreatmentComment" />--%>
                                                <textarea id="TextArea_CustomDocumentHealthHomeHealthEvaluations_SubstanceUseCurrentTreatmentComment"
                                                    name="TextArea_CustomDocumentHealthHomeHealthEvaluations_SubstanceUseCurrentTreatmentComment"
                                                    rows="4" cols="158" class="form_textarea" style="width: 95%" spellcheck="True"></textarea>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2" colspan="2">
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td style="width: 100%">
                                                Is the client currently in an AOD rehabilitation facility or anticipating transitioning
                                                in or out of an AOD rehabilitation facility in the next 90 days?&nbsp&nbsp <input class="cursor_default" type="radio" style="vertical-align: bottom" id="Radio3"
                                                    name="RadioButton_CustomDocumentHealthHomeHealthEvaluations_CurrentAODFacility"
                                                    value="Y" />
                                                <label for="RadioButton_CustomDocumentHealthHomeHealthEvaluations_CurrentAODFacility_Y">
                                                    Yes</label>&nbsp&nbsp <input class="cursor_default" type="radio" style="vertical-align: bottom" id="Radio4"
                                                    name="RadioButton_CustomDocumentHealthHomeHealthEvaluations_CurrentAODFacility"
                                                    value="N" />
                                                <label for="RadioButton_CustomDocumentHealthHomeHealthEvaluations_CurrentAODFacility_N">
                                                    No</label>
                                            </td>
                                          
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2" colspan="2">
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td style="width: 18%">
                                                if Yes, Comment:
                                            </td>
                                            <td style="width: 82%">
                                                <%--<input class="LPadd8 form_textbox" style="width: 65%" type="text" id="TextBox_CustomDocumentHealthHomeHealthEvaluations_CurrentAODFacilityComment" />--%>
                                                <textarea id="TextArea_CustomDocumentHealthHomeHealthEvaluations_CurrentAODFacilityComment"
                                                    name="TextArea_CustomDocumentHealthHomeHealthEvaluations_CurrentAODFacilityComment"
                                                    rows="4" cols="158" class="form_textarea" style="width: 95%" spellcheck="True"></textarea>
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
                    <td class="height2" colspan="2">
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
                                                Health Conditions
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
                                                            Does the client report any of the following (historically or currently)
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2" class="height2">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2">
                                                            <input class="cursor_default" type="checkbox" id="Checkbox_CustomDocumentHealthHomeHealthEvaluations_ClientReportsHighCholesterol"
                                                                name="Checkbox_CustomDocumentHealthHomeHealthEvaluations_ClientReportsHighCholesterol"
                                                                style="vertical-align: bottom" onclick="" />
                                                            <label for="Checkbox_CustomDocumentHealthHomeHealthEvaluations_ClientReportsHighCholesterol">
                                                                High Cholesterol</label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2" class="height2">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2">
                                                            <input class="cursor_default" type="checkbox" id="Checkbox_CustomDocumentHealthHomeHealthEvaluations_ClientReportsDiabetes"
                                                                name="Checkbox_CustomDocumentHealthHomeHealthEvaluations_ClientReportsDiabetes"
                                                                style="vertical-align: bottom" onclick="" />
                                                            <label for="Checkbox_CustomDocumentHealthHomeHealthEvaluations_ClientReportsDiabetes">
                                                                Diabetes</label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2" class="height2">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2">
                                                            <input class="cursor_default" type="checkbox" id="Checkbox_CustomDocumentHealthHomeHealthEvaluations_ClientReportsHypertension"
                                                                name="Checkbox_CustomDocumentHealthHomeHealthEvaluations_ClientReportsHypertension"
                                                                style="vertical-align: bottom" onclick="" />
                                                            <label for="Checkbox_CustomDocumentHealthHomeHealthEvaluations_ClientReportsHypertension">
                                                                Hypertension</label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2" class="height2">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2">
                                                            <input class="cursor_default" type="checkbox" id="Checkbox_CustomDocumentHealthHomeHealthEvaluations_ClientReportsAsthmaCOPDChronicInfection"
                                                                name="Checkbox_CustomDocumentHealthHomeHealthEvaluations_ClientReportsAsthmaCOPDChronicInfection"
                                                                style="vertical-align: bottom" onclick="" />
                                                            <label for="Checkbox_CustomDocumentHealthHomeHealthEvaluations_ClientReportsAsthmaCOPDChronicInfection">
                                                                Asthma/COPD/Chronic Upper Respiratory Infections</label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2" class="height2">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2">
                                                            <input class="cursor_default" type="checkbox" id="Checkbox_CustomDocumentHealthHomeHealthEvaluations_ClientReportsChronicPain"
                                                                name="Checkbox_CustomDocumentHealthHomeHealthEvaluations_ClientReportsChronicPain"
                                                                style="vertical-align: bottom" onclick="" />
                                                            <label for="Checkbox_CustomDocumentHealthHomeHealthEvaluations_ClientReportsAsthmaCOPDChronicInfection">
                                                                Chronic Pain</label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2" class="height2">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2">
                                                            <input class="cursor_default" type="checkbox" id="Checkbox_CustomDocumentHealthHomeHealthEvaluations_ClientReportsCardiovascularDisease"
                                                                name="Checkbox_CustomDocumentHealthHomeHealthEvaluations_ClientReportsCardiovascularDisease"
                                                                style="vertical-align: bottom" onclick="" />
                                                            <label for="Checkbox_CustomDocumentHealthHomeHealthEvaluations_ClientReportsCardiovascularDisease">
                                                                Cardiovascular disease</label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2" class="height2">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2">
                                                            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                                                <tr>
                                                                    <td style="width: 25%" valign="middle">
                                                                        <span id="Height">Height </span>
                                                                        <input type="text" id="TextBox_CustomDocumentHealthHomeHealthEvaluations_ClientHeight"
                                                                            name="TextBox_CustomDocumentHealthHomeHealthEvaluations_ClientHeight" class="form_textbox element"
                                                                            style="width: 108px;" datatype="Decimal" /><span id="Span1">&nbsp Inches</span>
                                                                    </td>
                                                                    <td width="5px">
                                                                        &nbsp;
                                                                    </td>
                                                                    <td style="width: 25%">
                                                                        <span id="Weight">Weight </span>
                                                                        <input type="text" id="TextBox_CustomDocumentHealthHomeHealthEvaluations_ClientWeight"
                                                                            onchange="ComprehensiveHealthEvaluation.CalculateBMI();" name="TextBox_CustomDocumentHealthHomeHealthEvaluations_ClientWeight"
                                                                            datatype="Decimal" class="form_textbox element" style="width: 108px;" /><span id="Span2">&nbsp lbs</span>
                                                                    </td>
                                                                    <td width="5px">
                                                                        &nbsp;
                                                                    </td>
                                                                    <td style="width: 40%">
                                                                        <span id="BMI">BMI </span>
                                                                        <input type="text" id="TextBox_CustomDocumentHealthHomeHealthEvaluations_ClientBMI"
                                                                            name="TextBox_CustomDocumentHealthHomeHealthEvaluations_ClientBMI" class="form_textbox element"
                                                                            style="width: 108px;" datatype="Decimal" />
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
                                                        <td style="width: 28%">
                                                            Date of Most Recent Metabolic Syndrome Screening :
                                                        </td>
                                                        <td style="width: 72%">
                                                            <input type="text" id="TextBox_CustomDocumentHealthHomeHealthEvaluations_MostRecentMetabolicScreeningDate"
                                                                name="TextBox_CustomDocumentHealthHomeHealthEvaluations_MostRecentMetabolicScreeningDate"
                                                                class="form_textbox element" style="width: 75px;" />
                                                            <img id="Img3" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                onclick="return showCalendar('TextBox_CustomDocumentHealthHomeHealthEvaluations_MostRecentMetabolicScreeningDate', '%m/%d/%Y');"
                                                                style="cursor: hand;" filter="false" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2" class="height2">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2">
                                                            Result of Metabolic Syndrome Screening
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2" class="height2">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2">
                                                            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                                                <tr>
                                                                    <td style="width: 12%">
                                                                        <span id="WaistCircumference">Waist Circumference</span>
                                                                    </td>
                                                                    <td style="width: 15%">
                                                                        <input type="text" id="TextBox_CustomDocumentHealthHomeHealthEvaluations_ClientWaistCircumference"
                                                                            name="TextBox_CustomDocumentHealthHomeHealthEvaluations_ClientWaistCircumference"
                                                                            class="form_textbox element" style="width: 70px;" datatype="Decimal" /><span id="Span3">&nbsp Inches</span>
                                                                    </td>
                                                                    <td style="width: 10%">
                                                                        Triglyceride Level
                                                                    </td>
                                                                    <td style="width: 14%">
                                                                        <input type="text" id="TextBox_CustomDocumentHealthHomeHealthEvaluations_ClientTriglycerideLevel"
                                                                            name="TextBox_CustomDocumentHealthHomeHealthEvaluations_ClientTriglycerideLevel"
                                                                            datatype="Decimal" class="form_textbox element" style="width: 70px;" /><span id="Span4"> &nbsp mg/dL</span>
                                                                    </td>
                                                                    <td style="width: 3%">
                                                                        HDL
                                                                    </td>
                                                                    <td style="width: 14%">
                                                                        <input type="text" id="TextBox_CustomDocumentHealthHomeHealthEvaluations_ClientHDL"
                                                                            datatype="Decimal" name="TextBox_CustomDocumentHealthHomeHealthEvaluations_ClientHDL"
                                                                            class="form_textbox element" style="width: 70px;" /><span id="Span5">&nbsp mg/dL</span>
                                                                    </td>
                                                                    <td style="width: 9%">
                                                                        <span id="BloodPressure">Blood Pressure</span>
                                                                    </td>
                                                                    <td style="width: 14%">
                                                                        <input type="text" id="TextBox_CustomDocumentHealthHomeHealthEvaluations_ClientBloodPressure"
                                                                            name="TextBox_CustomDocumentHealthHomeHealthEvaluations_ClientBloodPressure"
                                                                            onblur="return onlyNumbers(this);" class="form_textbox element" style="width: 70px;" /><span id="Span6"> &nbsp mm Hg</span>
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
                                                        <td colspan="2" class="height2">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr>
                                                                    <td style="width: 25%">
                                                                        Any other health conditions?
                                                                    </td>
                                                                    <td style="width: 75%">
                                                                        <%-- <input type="text" id="TextBox_CustomDocumentHealthHomeHealthEvaluations_AnyOtherHealthCondition"
                                                                name="TextBox_CustomDocumentHealthHomeHealthEvaluations_AnyOtherHealthCondition"
                                                                class="form_textbox element" style="width: 200px;" />--%>
                                                                        <textarea id="TextArea_CustomDocumentHealthHomeHealthEvaluations_AnyOtherHealthCondition"
                                                                            name="TextArea_CustomDocumentHealthHomeHealthEvaluations_AnyOtherHealthCondition"
                                                                            rows="4" cols="158" class="form_textarea" style="width: 95%" spellcheck="True"></textarea>
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
                                                        <td colspan="2">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr>
                                                                    <td colspan="2">
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr>
                                                                                <td style="width: 100%">
                                                                                    Is the client's lab work, monitoring tests(ex.EKG), and any other ordered testing
                                                                                   from the client's PCP, any specialists, and A Renewed Mind treatment providers up to date?</br><input class="cursor_default" type="radio" id="Radio5" name="RadioButton_CustomDocumentHealthHomeHealthEvaluations_LabWorkOtherTestsUpToDate"
                                                                                        value="Y" style="vertical-align:bottom" />
                                                                                    <label for="RadioButton_CustomDocumentHealthHomeHealthEvaluations_LabWorkOtherTestsUpToDate_Y">
                                                                                        Yes</label>&nbsp&nbsp <input class="cursor_default" type="radio" id="Radio6" name="RadioButton_CustomDocumentHealthHomeHealthEvaluations_LabWorkOtherTestsUpToDate"
                                                                                        value="N" style="vertical-align:bottom" />
                                                                                    <label for="RadioButton_CustomDocumentHealthHomeHealthEvaluations_LabWorkOtherTestsUpToDate_N">
                                                                                        No</label>
                                                                                </td>
                                                                              
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="height2" colspan="2">
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td colspan="2">
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr>
                                                                                <td style="width: 18%">
                                                                                    if No, Comment:
                                                                                </td>
                                                                                <td style="width: 82%">
                                                                                    <%--  <input class="LPadd8 form_textbox" style="width: 65%" type="text" id="TextBox_CustomDocumentHealthHomeHealthEvaluations_LabWorkOtherTestsComment" />--%>
                                                                                    <textarea id="TextArea_CustomDocumentHealthHomeHealthEvaluations_LabWorkOtherTestsComment"
                                                                                        name="TextArea_CustomDocumentHealthHomeHealthEvaluations_LabWorkOtherTestsComment"
                                                                                        rows="4" cols="158" class="form_textarea" style="width: 95%" spellcheck="True"></textarea>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="height2" colspan="2">
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td colspan="2">
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr>
                                                                                <td style="width: 100%">
                                                                                    Is the client in long term care or anticipating transitioning to or out of a long
                                                                                    term care facility within the next 90 days?&nbsp&nbsp <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentHealthHomeHealthEvaluations_LongTermCareCurrent_Y"
                                                                                        name="RadioButton_CustomDocumentHealthHomeHealthEvaluations_LongTermCareCurrent"
                                                                                        value="Y" style="vertical-align:bottom"/>
                                                                                    <label for="RadioButton_CustomDocumentHealthHomeHealthEvaluations_LongTermCareCurrent_Y">
                                                                                        Yes</label>&nbsp&nbsp <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentHealthHomeHealthEvaluations_LongTermCareCurrent_N"
                                                                                        name="RadioButton_CustomDocumentHealthHomeHealthEvaluations_LongTermCareCurrent"
                                                                                        value="N" style="vertical-align:bottom"/>
                                                                                    <label for="RadioButton_CustomDocumentHealthHomeHealthEvaluations_LongTermCareCurrent_N">
                                                                                        No</label>
                                                                                </td>
                                                                               
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="height2" colspan="2">
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td colspan="2">
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr>
                                                                                <td style="width: 18%">
                                                                                    if Yes, Comment:
                                                                                </td>
                                                                                <td style="width: 82%">
                                                                                    <%-- <input class="LPadd8 form_textbox" style="width: 65%" type="text" id="TextBox_CustomDocumentHealthHomeHealthEvaluations_LongTermCareComment" />--%>
                                                                                    <textarea id="TextArea_CustomDocumentHealthHomeHealthEvaluations_LongTermCareComment"
                                                                                        name="TextArea_CustomDocumentHealthHomeHealthEvaluations_LongTermCareComment"
                                                                                        rows="4" cols="158" class="form_textarea" style="width: 95%" spellcheck="True"></textarea>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="height2" colspan="2">
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td colspan="2">
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr>
                                                                                <td style="width: 100%">
                                                                                    Has the client been hospitalized (for any reason) in the past 90 days or does the
                                                                                    client anticipate being hospitalized (ex.planned surgery) within the next 90 days?</br> <input class="cursor_default" type="radio" id="Radio9" name="RadioButton_CustomDocumentHealthHomeHealthEvaluations_HospitalCareCurrent"
                                                                                        value="Y" style="vertical-align:bottom"/>
                                                                                    <label for="RadioButton_CustomDocumentHealthHomeHealthEvaluations_HospitalCareCurrent_Y">
                                                                                        Yes</label>&nbsp&nbsp <input class="cursor_default" type="radio" id="Radio10" name="RadioButton_CustomDocumentHealthHomeHealthEvaluations_HospitalCareCurrent"
                                                                                        value="N" style="vertical-align:bottom"/>
                                                                                    <label for="RadioButton_CustomDocumentHealthHomeHealthEvaluations_HospitalCareCurrent_N">
                                                                                        No</label>
                                                                                </td>
                                                                               
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="height2" colspan="2">
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td colspan="2">
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr>
                                                                                <td style="width: 18%">
                                                                                    if Yes, Comment:
                                                                                </td>
                                                                                <td style="width: 82%">
                                                                                    <%--<input class="LPadd8 form_textbox" style="width: 65%" type="text" id="TextBox_CustomDocumentHealthHomeHealthEvaluations_HospitalCareComment" />--%>
                                                                                    <textarea id="TextArea_CustomDocumentHealthHomeHealthEvaluations_HospitalCareComment"
                                                                                        name="TextArea_CustomDocumentHealthHomeHealthEvaluations_HospitalCareComment"
                                                                                        rows="4" cols="158" class="form_textarea" style="width: 95%" spellcheck="True"></textarea>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="height2" colspan="2">
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
                            <tr>
                                <td class="height2" colspan="2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                        <tr>
                                            <td>
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr>
                                                        <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                            Psychosocial and Environmental Support Needs
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
                                                <!-- Table Child Control Name -->
                                                <table cellspacing="0" cellpasding="0" border="0" id="TableChildControl_CustomDocumentHealthHomeCarePlanPESNeeds"
                                                    parentchildcontrols="True">
                                                    <tr id="TableChildControl_CustomDocumentHealthHomeCarePlanPESNeeds_DataRow">
                                                        <td>
                                                            <!-- Primary and Foreign Keys -->
                                                            
                                                            <input type="hidden" id="HiddenField_CustomDocumentHealthHomeCarePlanPESNeeds_CustomDocumentHealthHomeCarePlanPESNeedId" name="HiddenField_CustomDocumentHealthHomeCarePlanPESNeeds_CustomDocumentHealthHomeCarePlanPESNeedId"  parentchildcontrols="True" value="-1"  />
                                                            <input type="hidden" id="HiddenFieldPrimaryKeyCustomDocumentHealthHomeCarePlanPESNeedId" name="HiddenFieldPrimaryKeyCustomDocumentHealthHomeCarePlanPESNeedId" value="CustomDocumentHealthHomeCarePlanPESNeedId" parentchildcontrols="True" />
                                                            <input type="hidden" id="HiddenField_CustomDocumentHealthHomeCarePlanPESNeeds_DocumentVersionId" name="HiddenField_CustomDocumentHealthHomeCarePlanPESNeeds_DocumentVersionId" value="-1" parentchildcontrols="True" />                                                             
                                                            <input type="hidden" id="HiddenField_CustomDocumentHealthHomeCarePlanPESNeeds_SupportNeed" name="HiddenField_CustomDocumentHealthHomeCarePlanPESNeeds_SupportNeed"  parentchildcontrols="True" />
                                                            <!-- Table Columns -->
                                                            <label for="<%=DropDownList_CustomDocumentHealthHomeCarePlanPESNeeds_PsychosocialSupportNeedType.ClientID %>"
                                                                class="form_label">
                                                                Need:
                                                            </label>
                                                            </td>
                                                            <td>
                                                            <asp:DropDownList ID="DropDownList_CustomDocumentHealthHomeCarePlanPESNeeds_PsychosocialSupportNeedType"
                                                                bindautosaveevents="False" parentchildcontrols="True" AddBlankRow="true" Width="300px"
                                                                runat="server">
                                                            </asp:DropDownList>
                                                            </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="2" class="height2">
                                                                 </td>
                                                            </tr>
                                                            <tr>
                                                            <td valign="top">
                                                            <label for="TextArea_CustomDocumentHealthHomeCarePlanPESNeeds_PsychosocialSupportNeedPlan" class="form_label">Plan:</label>
                                                             </td>
                                                                <td>
                                                            <textarea id="TextArea_CustomDocumentHealthHomeCarePlanPESNeeds_PsychosocialSupportNeedPlan"
                                                                name="TextArea_CustomDocumentHealthHomeCarePlanPESNeeds_PsychosocialSupportNeedPlan"
                                                                bindautosaveevents="False" parentchildcontrols="True" class="form_textbox element"
                                                                required="true" style="width: 600px; height: 60px;"></textarea>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                                <td colspan="2" class="height2">
                                                                 </td>
                                                            </tr>
                                                    <tr>
                                                        <td colspan="2" style="text-align: right; padding: 5px;">
                                                            <input type="button" id="TableChildControl_CustomDocumentHealthHomeCarePlanPESNeeds_ButtonInsert"
                                                                name="TableChildControl_CustomDocumentHealthHomeCarePlanPESNeeds_ButtonInsert"
                                                                baseurl="<%=ResolveUrl("~") %>" onclick="InsertGrid_CustomDocumentHealthHomeCarePlanPESNeedsData('TableChildControl_CustomDocumentHealthHomeCarePlanPESNeeds','InsertGrid_CustomDocumentHealthHomeCarePlanPESNeeds','CustomGrid_CustomDocumentHealthHomeCarePlanPESNeeds', this);"
                                                                value="Insert" class="parentchildbutton" />&nbsp;<input type="button" id="Button3" onclick="Clear_CustomDocumentHealthHomeCarePlanPESNeeds_Data();$('[Id$=DropDownList_CustomDocumentHealthHomeCarePlanPESNeeds_PsychosocialSupportNeedType]').focus();"
                                                                    name="ButtonClear" value="Clear" class="parentchildbutton" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                                <td colspan="2" class="height2">
                                                                 </td>
                                                            </tr>
                                                    <!-- Custom Grid -->
                                                    <tr>
                                                        <td colspan="2">
                                                            <div id="InsertGrid_CustomDocumentHealthHomeCarePlanPESNeeds" style="overflow-x: hidden;
                                                                overflow-y: auto; height: 100px; width: 100%;">
                                                                <uc1:CustomGrid ID="CustomGrid_CustomDocumentHealthHomeCarePlanPESNeeds" runat="server"
                                                                    TableName="CustomDocumentHealthHomeCarePlanPESNeeds" PrimaryKey="CustomDocumentHealthHomeCarePlanPESNeedId"
                                                                    CustomGridTableName="TableChildControl_CustomDocumentHealthHomeCarePlanPESNeeds"
                                                                    GridPageName="CustomDocumentHealthHomeCarePlanPESNeeds_Grid" ColumnName="SupportNeed:PsychosocialSupportNeedPlan"
                                                                    ColumnHeader="Need:Plan" ColumnWidth="50%:50%" DivGridName="InsertGrid_CustomDocumentHealthHomeCarePlanPESNeeds"
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
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td style="padding-left: 10px; padding-right: 5px">
                                                <input class="cursor_default" type="checkbox" id="Checkbox_CustomDocumentHealthHomeHealthEvaluations_ClientGuardianParticipatedInPlan"
                                                    name="Checkbox_CustomDocumentHealthHomeHealthEvaluations_ClientGuardianParticipatedInPlan"
                                                    style="vertical-align: bottom" onclick="" />
                                                <label for="Checkbox_CustomDocumentHealthHomeHealthEvaluations_ClientGuardianParticipatedInPlan">
                                                    Client/Guardian participated in this evaluation and agrees to use the information
                                                    in this evaluation to update his/her Integrated Care Plan.</label>
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
