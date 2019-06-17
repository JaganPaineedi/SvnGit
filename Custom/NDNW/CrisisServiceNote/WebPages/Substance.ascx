<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Substance.ascx.cs" Inherits="SHS.SmartCare.ActivityPages_Client_CMDocuments_Substance" %>
<%@ Register Src="~/CommonUserControls/CustomGrid.ascx" TagName="CustomGrid" TagPrefix="uc1" %>
<% if (HttpContext.Current == null)
   { %>
<link href="../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet" type="text/css" />
<%} %>
<div style="overflow-x: hidden">
    <table border="0" cellpadding="0" cellspacing="0" style="width:100%">
        <tr>
            <td class="height2">
            </td>
        </tr>
        <tr>
            <td>
                <table border="0" cellpadding="0" cellspacing="0" width="99%">
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="content_tab_left" align="left" width="22%">
                                        Substance Use
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
                            <table width="100%" border="0" cellspacing="0" cellpadding="0" id="TableChildControl_CustomSUSubstances"
                                parentchildcontrols="True">
                                <tr>
                                    <td>
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                                <td align="left" style="width: 19%; padding-left: 7px;">
                                                    <span id="Span$$CustomAcuteServicesPrescreens$$SUCurrentUse" class="form_label">Current
                                                        Use</span>
                                                </td>
                                                <td>
                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                        <tr class="checkbox_container">
                                                            <td>
                                                                <input type="radio" id="RadioButton_CustomAcuteServicesPrescreens_SUCurrentUse_Y"
                                                                    name="RadioButton_CustomAcuteServicesPrescreens_SUCurrentUse" value="Y" parentchildcontrols="False" onclick="SetSUCurrentUse(this,'Y');" DoNotClear='true' />
                                                            </td>
                                                            <td>
                                                                <label for="RadioButton_CustomAcuteServicesPrescreens_SUCurrentUse_Y">
                                                                    Yes</label>
                                                            </td>
                                                            <td>
                                                                &nbsp;
                                                            </td>
                                                            <td>
                                                                <input type="radio" id="RadioButton_CustomAcuteServicesPrescreens_SUCurrentUse_N"
                                                                    name="RadioButton_CustomAcuteServicesPrescreens_SUCurrentUse" value="N" parentchildcontrols="False" onclick="SetSUCurrentUse(this,'N');" DoNotClear='true' />
                                                            </td>
                                                            <td>
                                                                <label for="RadioButton_CustomAcuteServicesPrescreens_SUCurrentUse_N">
                                                                    No</label>
                                                            </td>
                                                            <td>
                                                                &nbsp;
                                                            </td>
                                                            <td>
                                                                <input type="radio" id="RadioButton_CustomAcuteServicesPrescreens_SUCurrentUse_R"
                                                                    name="RadioButton_CustomAcuteServicesPrescreens_SUCurrentUse" value="R" parentchildcontrols="False" onclick="SetSUCurrentUse(this,'R');" DoNotClear='true' />
                                                            </td>
                                                            <td>
                                                                <label for="RadioButton_CustomAcuteServicesPrescreens_SUCurrentUse_R">
                                                                    Refused to answer</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" style="padding-left: 7px;">
                                        <span class="form_label">Sustance (s)</span>
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" colspan="2">
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr>
                                                <td align="left" style="width: 6%; padding-left: 7px;">
                                                    <span id="Span$$CustomSUSubstances$$SubstanceName" class="form_label">Name</span>
                                                </td>
                                                <td align="left" style="width: 24%" class="LPadd2">
                                                    <input type="text" class="form_textbox" id="TextBox_CustomSUSubstances_SubstanceName"
                                                        name="TextBox_CustomSUSubstances_SubstanceName" size="30" parentchildcontrols="True"
                                                        datatype="String" required="true" style="width: 160px" maxlength="100" />
                                                </td>
                                                <td style="width: 8%" class="LPadd8">
                                                    <span id="Span$$CustomSUSubstances$$Amount" class="form_label">Amount</span>
                                                </td>
                                                <td style="width: 24%">
                                                    <input type="text" class="form_textbox" id="TextBox_CustomSUSubstances_Amount" name="TextBox_CustomSUSubstances_Amount"
                                                        size="30" parentchildcontrols="True" datatype="String" required="true" style="width: 160px"
                                                        maxlength="100" />
                                                </td>
                                                <td style="width: 9%" class="LPadd8">
                                                    <span id="Span$$CustomSUSubstances$$Frequency" class="form_label">Frequency</span>
                                                </td>
                                                <td style="padding-left: 3px;">
                                                    <input type="text" class="form_textbox" id="TextBox_CustomSUSubstances_Frequency"
                                                        name="TextBox_CustomSUSubstances_Frequency" size="30" parentchildcontrols="True"
                                                        datatype="String" required="true" style="width: 160px" maxlength="100" />
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
                                    </td>
                                    <td align="right" style="padding-right:67px;">
                                        <table cellspacing="0" cellpadding="0" border="0">
                                            <tr>
                                                <td align="right">
                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <div class="glow_lt">
                                                                        &nbsp;</div>
                                                                </td>
                                                                <td>
                                                                    <div class="glow_mid">
                                                                        <input type="button" id="TableChildControl_CustomSUSubstances_ButtonInsert" name="TableChildControl_CustomSUSubstances_ButtonInsert"
                                                                            value=" Insert " onclick="return  InsertGridData('TableChildControl_CustomSUSubstances','InsertGridSubstance','CustomGrid',this);" />
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div class="glow_rt">
                                                                        &nbsp;</div>
                                                                </td>
                                                                <%--<td class="expandable_btn_left" align="center">
                                                                    <input type="button" id="ButtonInsert" name="ButtonInsert" value="Insert" onclick="return  InsertGridData('TableChildControl_CustomSUSubstances','InsertGridSubstance');" />
                                                                </td>
                                                                <td class="expandable_btn_right">
                                                                    &nbsp;
                                                                </td>--%>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </td>
                                                <td style="padding-right: 10px">
                                                </td>
                                                <td>
                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <div class="glow_lt">
                                                                        &nbsp;</div>
                                                                </td>
                                                                <td>
                                                                    <div class="glow_mid">
                                                                        <input type="button" id="ButtonClear" name="ButtonClear" value=" Clear " onclick="ClearSubstance();" />
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div class="glow_rt">
                                                                        &nbsp;</div>
                                                                </td>
                                                                <%--<td class="expandable_btn_left" align="center">
                                                                    <input type="button" id="ButtonClear" name="ButtonClear" value="Clear" onclick="ClearSubstance();" />
                                                                </td>
                                                                <td class="expandable_btn_right">
                                                                    &nbsp;
                                                                </td>--%>
                                                            </tr>
                                                        </tbody>
                                                    </table>
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
                                    <td colspan="2" align="center">
                                        <table cellspacing="0" cellpadding="0" border="0" width="98%">
                                            <tr>
                                                <td>
                                                    <div id="InsertGridSubstance" runat="server" style="width: 97%; overflow-y: auto;
                                                        overflow-x: hidden; height: 50%; text-align: left; padding-left: 5px;">
                                                        <uc1:CustomGrid ID="CustomGrid" runat="server" TableName="CustomSUSubstances" PrimaryKey="SUSubstanceId"
                                                            CustomGridTableName="TableChildControl_CustomSUSubstances" GridPageName="CustomSUSubstances"
                                                            ColumnName="SubstanceName:Amount:Frequency" ColumnHeader="Name:Amount:Frequency"
                                                            ColumnWidth="34%:33%:33%" DivGridName="InsertGridSubstance" InsertButtonId="TableChildControl_CustomSUSubstances_ButtonInsert" />
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <input type="hidden" parentchildcontrols="True" id="HiddenField_CustomSUSubstances_SUSubstanceId"
                                                        name="HiddenField_CustomSUSubstances_SUSubstanceId" value="-1" />
                                                    <input type="hidden" id="HiddenField_CustomSUSubstances_DocumentVersionId" value="-1"
                                                        name="HiddenField_CustomSUSubstances_DocumentVersionId" />
                                                    <input type="hidden" parentchildcontrols="True" id="HiddenFieldPrimaryKey" name="HiddenFieldPrimaryKey"
                                                        value="SUSubstanceId" />
                                                    <input type="hidden" parentchildcontrols="True" id="HiddenFieldForigenKey" name="HiddenFieldForigenKey"
                                                        value="DocumentVersionId" />
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
                <table width="99%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="content_tab_left" align="left" width="40%" nowrap="nowrap">
                                        Substance Abuse Symptoms (reported or observed)
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
                                    <td colspan="4">
                                        <table border="0" cellspacing="0" cellpadding="0">
                                            <tr class="checkbox_container">
                                                <td align="left" style="padding-left: 10px;">
                                                    <input type="checkbox" id="CheckBox_CustomAcuteServicesPrescreens_SUOdorOfSubstance"
                                                        name="CheckBox_CustomAcuteServicesPrescreens_SUOdorOfSubstance" />
                                                </td>
                                                <td>
                                                    <label for="CheckBox_CustomAcuteServicesPrescreens_SUOdorOfSubstance">
                                                        Odor of Substance</label>
                                                </td>
                                                <td>
                                                    &nbsp;
                                                </td>
                                                <td align="left">
                                                    <input type="checkbox" id="CheckBox_CustomAcuteServicesPrescreens_SUSlurredSpeech"
                                                        name="CheckBox_CustomAcuteServicesPrescreens_SUSlurredSpeech" />
                                                </td>
                                                <td>
                                                    <label for="CheckBox_CustomAcuteServicesPrescreens_SUSlurredSpeech">
                                                        Slurred Speech</label>
                                                </td>
                                                <td>
                                                    &nbsp;
                                                </td>
                                                <td align="left">
                                                    <input type="checkbox" id="CheckBox_CustomAcuteServicesPrescreens_SUWithdrawalSymptoms"
                                                        name="CheckBox_CustomAcuteServicesPrescreens_SUWithdrawalSymptoms" />
                                                </td>
                                                <td>
                                                    <label for="CheckBox_CustomAcuteServicesPrescreens_SUWithdrawalSymptoms">
                                                        Withdrawal Symptoms</label>
                                                </td>
                                                <td>
                                                    &nbsp;
                                                </td>
                                                <td align="left">
                                                    <input type="checkbox" id="CheckBox_CustomAcuteServicesPrescreens_SUDTOther" name="CheckBox_CustomAcuteServicesPrescreens_SUDTOther" />
                                                </td>
                                                <td>
                                                    <label for="CheckBox_CustomAcuteServicesPrescreens_SUDTOther">
                                                        DT's (other)</label>
                                                </td>
                                                <td style="cursor: text; padding-left: 12px;">
                                                    <input type="text" class="form_textbox" id="TextBox_CustomAcuteServicesPrescreens_SUOtherDescribe"
                                                        name="TextBox_CustomAcuteServicesPrescreens_SUOtherDescribe" datatype="String"
                                                        maxlength="100" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr class="checkbox_container">
                                                <td align="left" style="padding-left: 10px;">
                                                    <input type="checkbox" id="CheckBox_CustomAcuteServicesPrescreens_SUBlackOuts" name="CheckBox_CustomAcuteServicesPrescreens_SUBlackOuts" />
                                                </td>
                                                <td>
                                                    <label for="CheckBox_CustomAcuteServicesPrescreens_SUBlackOuts">
                                                        Blackouts</label>
                                                </td>
                                                <td>
                                                    &nbsp;
                                                </td>
                                                <td align="left">
                                                    <input type="checkbox" id="CheckBox_CustomAcuteServicesPrescreens_SURelatedArrests"
                                                        name="CheckBox_CustomAcuteServicesPrescreens_SURelatedArrests" />
                                                </td>
                                                <td>
                                                    <label for="CheckBox_CustomAcuteServicesPrescreens_SURelatedArrests">
                                                        Related arrests</label>
                                                </td>
                                                <td>
                                                    &nbsp;
                                                </td>
                                                <td align="left">
                                                    <input type="checkbox" id="CheckBox_CustomAcuteServicesPrescreens_SURelatedSocialProblems"
                                                        name="CheckBox_CustomAcuteServicesPrescreens_SURelatedSocialProblems" />
                                                </td>
                                                <td>
                                                    <label for="CheckBox_CustomAcuteServicesPrescreens_SURelatedSocialProblems">
                                                        Related social problems</label>
                                                </td>
                                                <td>
                                                    &nbsp;
                                                </td>
                                                <td colspan="3">
                                                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                        <tr class="checkbox_container">
                                                            <td align="left">
                                                                <input type="checkbox" id="CheckBox_CustomAcuteServicesPrescreens_SUFrequentAbsences"
                                                                    name="CheckBox_CustomAcuteServicesPrescreens_SUFrequentAbsences" />
                                                            </td>
                                                            <td>
                                                                <label for="CheckBox_CustomAcuteServicesPrescreens_SUFrequentAbsences">
                                                                    Frequent job/ Social absences</label>
                                                            </td>
                                                        </tr>
                                                    </table>
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
                                    <td align="left" style="padding-left: 7px;" width="31%">
                                        <span id="Span$$CustomAcuteServicesPrescreens$$SUCurrentTreatment" class="form_label">
                                            Current substance abuse treatment?</span>
                                    </td>
                                    <td>
                                        <table border="0" cellpadding="0" cellspacing="0" width="90%">
                                            <tr>
                                                <td style="width: 24%;">
                                                    <table border="0" cellspacing="0" cellpadding="0">
                                                        <tr class="checkbox_container">
                                                            <td>
                                                                <input type="radio" id="RadioButton_CustomAcuteServicesPrescreens_SUCurrentTreatment_Y"
                                                                    name="RadioButton_CustomAcuteServicesPrescreens_SUCurrentTreatment" value="Y" />
                                                            </td>
                                                            <td>
                                                                <label for="RadioButton_CustomAcuteServicesPrescreens_SUCurrentTreatment_Y">
                                                                    Yes</label>
                                                            </td>
                                                            <td>
                                                                &nbsp;
                                                            </td>
                                                            <td>
                                                                <input type="radio" id="RadioButton_CustomAcuteServicesPrescreens_SUCurrentTreatment_N"
                                                                    name="RadioButton_CustomAcuteServicesPrescreens_SUCurrentTreatment" value="N" />
                                                            </td>
                                                            <td>
                                                                <label for="RadioButton_CustomAcuteServicesPrescreens_SUCurrentTreatment_N">
                                                                    No</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td style="cursor: text; width: 10%">
                                                    <span id="Span$$CustomAcuteServicesPrescreens$$SUCurrentTreatmentProvider" class="form_label">
                                                        Provider</span>
                                                </td>
                                                <td style="cursor: text; padding-left: 2px;">
                                                    <input type="text" class="form_textbox" id="TextBox_CustomAcuteServicesPrescreens_SUCurrentTreatmentProvider"
                                                        name="TextBox_CustomAcuteServicesPrescreens_SUCurrentTreatmentProvider" datatype="String"
                                                        maxlength="100" />
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
                                    <td style="padding-left: 7px;" align="left">
                                       <%--Changes Made by Vikas Kashyup - 22/Oct/2011 Ref Task No. 359 to Change Lable phone to Contact Number if Provided to Contact if Provided--%>
                                    <span id="Span$$CustomAcuteServicesPrescreens$$SUProviderContactNumber" class="form_label">
                                            Contact if Provided</span>
                                       <%-- <span id="Span$$CustomAcuteServicesPrescreens$$SUProviderContactNumber" class="form_label">
                                            Contact Number if Provided</span>--%>
                                    </td>
                                    <td>
                                        <input type="text" class="form_textbox" id="TextBox_CustomAcuteServicesPrescreens_SUProviderContactNumber"
                                            name="TextBox_CustomAcuteServicesPrescreens_SUProviderContactNumber" datatype="PhoneNumber"
                                            maxlength="25" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" style="padding-left: 7px;">
                                        <span id="Span$$CustomAcuteServicesPrescreens$$SUHistory" class="form_label">Does consumer
                                            have history of substance abuse?</span>
                                    </td>
                                    <td>
                                        <table border="0" cellpadding="0" cellspacing="0" width="40%">
                                            <tr>
                                                <td style="width: 24%">
                                                    <table border="0" cellspacing="0" cellpadding="0">
                                                        <tr class="checkbox_container">
                                                            <td>
                                                                <input type="radio" id="RadioButton_CustomAcuteServicesPrescreens_SUHistory_Y" name="RadioButton_CustomAcuteServicesPrescreens_SUHistory"
                                                                    value="Y" />
                                                            </td>
                                                            <td>
                                                                <label for="RadioButton_CustomAcuteServicesPrescreens_SUHistory_Y">
                                                                    Yes</label>
                                                            </td>
                                                            <td>
                                                                &nbsp;
                                                            </td>
                                                            <td>
                                                                <input type="radio" id="RadioButton_CustomAcuteServicesPrescreens_SUHistory_N" name="RadioButton_CustomAcuteServicesPrescreens_SUHistory"
                                                                    value="N" />
                                                            </td>
                                                            <td>
                                                                <label for="RadioButton_CustomAcuteServicesPrescreens_SUHistory_N">
                                                                    No</label>
                                                            </td>
                                                        </tr>
                                                    </table>
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
                                    <td align="left" style="padding-left: 7px;">
                                        <span id="Span$$CustomAcuteServicesPrescreens$$SUHistorySpecify" class="form_label">
                                            Specify</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2" colspan="2">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" style="padding-left: 10px; padding-right: 12px;" colspan="3">
                                        <textarea id="TextArea_CustomAcuteServicesPrescreens_SUHistorySpecify" name="TextArea_CustomAcuteServicesPrescreens_SUHistorySpecify"
                                            rows="3" cols="158" class="form_textareaWithoutWidth" datatype="String"
                                            spellcheck="True"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2" colspan="2">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" style="padding-left: 7px;">
                                        <span id="Span$$CustomAcuteServicesPrescreens$$SUPreviousTreatment" class="form_label">
                                            Previous substance abuse treatment?</span>
                                    </td>
                                    <td>
                                        <table border="0" cellpadding="0" cellspacing="0">
                                            <tr class="checkbox_container">
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomAcuteServicesPrescreens_SUPreviousTreatment_Y"
                                                        name="RadioButton_CustomAcuteServicesPrescreens_SUPreviousTreatment" value="Y" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomAcuteServicesPrescreens_SUPreviousTreatment_Y">
                                                        Yes</label>
                                                </td>
                                                <td>
                                                    &nbsp;
                                                </td>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomAcuteServicesPrescreens_SUPreviousTreatment_N"
                                                        name="RadioButton_CustomAcuteServicesPrescreens_SUPreviousTreatment" value="N" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomAcuteServicesPrescreens_SUPreviousTreatment_N">
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
                                    <td align="left" style="padding-left: 7px;" colspan="3">
                                        <span id="Span$$CustomAcuteServicesPrescreens$$SUReferralToSA" class="form_label">If
                                            current Substance Abuse symptoms, referral to SA or co-occurring tx?</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2" colspan="2">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" colspan="2">
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr>
                                                <td style="width: 17%;">
                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                        <tr class="checkbox_container">
                                                            <td style="padding-left: 9px;">
                                                                <input type="radio" id="RadioButton_CustomAcuteServicesPrescreens_SUReferralToSA_Y"
                                                                    name="RadioButton_CustomAcuteServicesPrescreens_SUReferralToSA" value="Y" />
                                                            </td>
                                                            <td>
                                                                <label for="RadioButton_CustomAcuteServicesPrescreens_SUReferralToSA_Y">
                                                                    Yes, where referred</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td style="cursor: text;">
                                                    <input type="text" class="form_textbox" id="TextBox_CustomAcuteServicesPrescreens_SUWhereReferred"
                                                        name="TextBox_CustomAcuteServicesPrescreens_SUWhereReferred" datatype="String"
                                                        maxlength="100" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2" colspan="2">
                                    </td>
                                </tr>
                                <tr class="checkbox_container">
                                    <td align="left">
                                        <table border="0" cellpadding="0" cellspacing="0">
                                            <tr class="checkbox_container">
                                                <td style="padding-left: 9px;">
                                                    <input type="radio" id="RadioButton_CustomAcuteServicesPrescreens_SUReferralToSA_N"
                                                        name="RadioButton_CustomAcuteServicesPrescreens_SUReferralToSA" value="N" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomAcuteServicesPrescreens_SUReferralToSA_N">
                                                        No, because</label>
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
                                    <td align="left" style="padding-left: 10px; padding-right: 12px;" colspan="4">
                                        <textarea id="TextArea_CustomAcuteServicesPrescreens_SUNotReferredBecause" name="TextArea_CustomAcuteServicesPrescreens_SUNotReferredBecause"
                                            rows="3" cols="158" class="form_textareaWithoutWidth" datatype="String"
                                            spellcheck="True"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2" colspan="2">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" style="padding-left: 7px;" colspan="3">
                                        <span id="Span$$CustomAcuteServicesPrescreens$$SUToxicologyResults" class="form_label">
                                            Toxicology results if available (BAL, positive screens, etc.)</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2" colspan="2">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" style="padding-left: 10px; padding-right: 12px;" colspan="4">
                                        <textarea id="TextArea_CustomAcuteServicesPrescreens_SUToxicologyResults" name="TextArea_CustomAcuteServicesPrescreens_SUToxicologyResults"
                                            rows="3" cols="158" class="form_textareaWithoutWidth" datatype="String"
                                            spellcheck="True"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2" colspan="2">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" style="padding-left: 7px;" colspan="4">
                                        <span class="form_label">*If under the influence, the consumer should be capable of
                                            participating in a prescreen to achieve a reasonably reliable level of clinical
                                            validity.</span>
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
</div>
