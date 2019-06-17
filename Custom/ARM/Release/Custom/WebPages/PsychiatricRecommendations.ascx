<%@ Control Language="C#" AutoEventWireup="true" CodeFile="PsychiatricRecommendations.ascx.cs"
    Inherits="ActivityPages_Harbor_Client_Detail_Documents_PsychiatricEvaluation_PsychiatricRecommendations" %>
<%@ Register Src="~/CommonUserControls/CustomGrid.ascx" TagName="CustomGrid" TagPrefix="uc1" %>
<%@ Register Assembly="Streamline.DotNetDropDowns" Namespace="Streamline.DotNetDropDowns"
    TagPrefix="cc1" %>
<%@ Register Assembly="Streamline.DotNetDropDownGlobalCodes" Namespace="Streamline.DotNetDropDownGlobalCodes"
    TagPrefix="DropDownGlobalCodes" %>
<script type="text/javascript" language="javascript" src="<%=RelativePath%>Custom/Scripts/PsychiatricRecommendations.js"></script>

<div style="overflow-x: hidden">
    <asp:HiddenField id="hiddenFieldReferralTransferReferenceURL"   runat="server" />
    <table border="0" cellpadding="0" cellspacing="0" class="DocumentScreen">
        <tr>
            <td>
                <table border="0" cellpadding="0" cellspacing="0" width="99%">
                    <tr>
                        <td valign="top" >
                            <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricEvaluations_CreateMedicatlTxPlan"
                                name="CheckBox_CustomDocumentPsychiatricEvaluations_CreateMedicatlTxPlan" tabindex="1"
                                class="cursor_default" />&nbsp;
                        </td>
                        <td>
                            <span class="form_label">I recommend that this client begin receiving pharmacologic
                                management services and community psychiatric supportive treatment services, as needed. (Checking this box will auto-create a Medical Treatment Plan.)</span>
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
                <table border="0" cellpadding="0" cellspacing="0" width="99%">
                    <tr>
                        <td style="width: 37%">
                            <span>Do you wish to add any additional goals to the treatment plan?</span>
                        </td>
                        <td style="width: 10%">
                            <table class="checkbox_container">
                                <tr>
                                    <td>
                                        <input type="radio" id="RadioButton_CustomDocumentPsychiatricEvaluations_AddGoalsToTxPlan_Y"
                                            name="RadioButton_CustomDocumentPsychiatricEvaluations_AddGoalsToTxPlan" value="Y"
                                            tabindex="2" />
                                        <label for="RadioButton_CustomDocumentPsychiatricEvaluations_AddGoalsToTxPlan_Y">
                                            Yes</label>
                                    </td>
                                    <td>
                                        <input style="padding-left: 4px;" type="radio" id="RadioButton_CustomDocumentPsychiatricEvaluations_AddGoalsToTxPlan_N"
                                            name="RadioButton_CustomDocumentPsychiatricEvaluations_AddGoalsToTxPlan" value="N"
                                            tabindex="3" />
                                        <label for="RadioButton_CustomDocumentPsychiatricEvaluations_AddGoalsToTxPlan_N">
                                            No</label>
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td style="width: 52%" class="form_label">
                            <span>(No, will create a signed treatment plan, Yes, will create an in progress treatment
                                Plan)</span>
                                
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
                <span >Referrals for Additional Services: (Using this box will auto-create
                    referrals to these services</span>
            </td>
        </tr>
        <tr>
            <td class="height2">
            </td>
        </tr>
        <tr>
            <td>
                <table border="0" cellpadding="0" cellspacing="0" width="99%">
                    <tr>
                        <td>
                            <table id="TableServices" border="0" cellpadding="0" cellspacing="0" width="99%">
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                    A Renewed Mind Services/Evaluations Recommended:
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
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%" id="TableChildControl_CustomDocumentPsychiatricEvaluationReferrals">
                                            <tr>
                                                <td class="height1">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <table id="TableParent" border="0" cellspacing="0" cellpadding="0" width="100%">
                                                        <tr>
                                                            <td width="1.5%">
                                                            </td>
                                                            <td width="5%">
                                                                <span class="form_label">Service/Eval</span>
                                                            </td>
                                                            <td width="11%">
                                                                <cc1:StreamlineDropDowns ID="DropDownList_CustomDocumentPsychiatricEvaluationReferrals_ServiceRecommended"
                                                                    CssClass="form_dropdown" name="DropDownList_CustomDocumentPsychiatricEvaluationReferrals_ServiceRecommended"
                                                                    runat="server" Width="240px" bindautosaveevents="False" parentchildcontrols="True"
                                                                    Required="true">
                                                                </cc1:StreamlineDropDowns>
                                                            </td>
                                                            <td width="5%" align="center">
                                                                <span class="form_label">Amount</span>
                                                            </td>
                                                            <td width="4%">
                                                                <input type="text" style="width: 60px" class="form_textbox" id="TextBox_CustomDocumentPsychiatricEvaluationReferrals_ServiceAmount"
                                                                    datatype="Numeric" name="TextBox_CustomDocumentPsychiatricEvaluationReferrals_ServiceAmount" bindautosaveevents="False"
                                                                    parentchildcontrols="True" maxlength="7" required="true" />
                                                            </td>
                                                            <td width="5%" align="left">
                                                                <span id="Span_CustomDocumentPsychiatricEvaluationReferrals_ServiceUnitTypeValue" parentchildcontrols="True"
                                                                    class="form_label" name="Span_CustomDocumentPsychiatricEvaluationReferrals_ServiceUnitTypeValue"
                                                                    bindautosaveevents="False"></span>
                                                            </td>
                                                            <td width="5%">
                                                                <span class="form_label">Frequency</span>
                                                            </td>
                                                            <td width="9%">
                                                                <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentPsychiatricEvaluationReferrals_ServiceFrequency"
                                                                    bindautosaveevents="False" parentchildcontrols="True" Required="true" Category="TPFREQUENCYTYPE"
                                                                    runat="server" Width="140px" CssClass="form_dropdowns" AddBlankRow="true" BlankRowText="">
                                                                </DropDownGlobalCodes:DropDownGlobalCodes>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height1">
                                                                &nbsp;
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="1.5%">
                                                            </td>
                                                            <td colspan="7">
                                                                <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                                                    <tr>
                                                                        <td width="18%">
                                                                            <span class="form_label">Receiving Staff</span> &nbsp;&nbsp;<img id="imgFolderReferral"
                                                                                alt="" style="vertical-align: top; cursor: pointer;" src="<%=RelativePath%>App_Themes/Includes/Images/folder-icon.gif" />
                                                                        </td>
                                                                        <td>
                                                                            <cc1:StreamlineDropDowns ID="DropDownList_CustomDocumentPsychiatricEvaluationReferrals_ReceivingStaffId"
                                                                                Required="true" CssClass="form_dropdown" name="DropDownList_CustomDocumentPsychiatricEvaluationReferrals_ReceivingStaffId"
                                                                                runat="server" Width="360px" bindautosaveevents="False" parentchildcontrols="True">
                                                                            </cc1:StreamlineDropDowns>
                                                                        </td>
                                                                        <td width="165px">
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height1">
                                                                            &nbsp;
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <span class="form_label">Assessed Need for Referral</span>
                                                                        </td>
                                                                        <td>
                                                                            <input type="text" style="width: 350px" maxlength="500" class="form_textbox" id="TextBox_CustomDocumentPsychiatricEvaluationReferrals_AssessedNeedForReferral"
                                                                                name="TextBox_CustomDocumentPsychiatricEvaluationReferrals_AssessedNeedForReferral" bindautosaveevents="False"
                                                                                parentchildcontrols="True" />
                                                                        </td>
                                                                        <td align="left">
                                                                            <input name="TableChildControl_CustomDocumentPsychiatricEvaluationReferrals_ButtonInsert" class="parentchildbutton element"
                                                                                id="TableChildControl_CustomDocumentPsychiatricEvaluationReferrals_ButtonInsert" type="button"
                                                                                value="Insert" onclick="return  InsertGridCustomPsychiatricReferralData('TableChildControl_CustomDocumentPsychiatricEvaluationReferrals','InsertGridPsychiatricReferrals','CustomGridPsychiatricReferrals',this,'<%=ResolveUrl("~") %>');" />
                                                                            &nbsp;
                                                                            <input name="ButtonClear" class="parentchildbutton element" id="ButtonClear" onclick="ClearPsychiatricReferrals();ClearTable('TableChildControl_CustomDocumentPsychiatricEvaluationReferrals','TableChildControl_CustomDocumentPsychiatricEvaluationReferrals_ButtonInsert',false);"
                                                                                type="button" value="Clear" />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height1">
                                                                            &nbsp;
                                                                        </td>
                                                                    </tr>
                                                                    <tr class="checkbox_container">
                                                                        <td colspan="3">
                                                                            &nbsp;<input name="CheckBox_CustomDocumentPsychiatricEvaluationReferrals_ClientParticipatedReferral"
                                                                                class="element" id="CheckBox_CustomDocumentPsychiatricEvaluationReferrals_ClientParticipatedReferral"
                                                                                type="checkbox" bindautosaveevents="False" parentchildcontrols="True" />
                                                                            <span class="form_label">Client/guardian participated in this decision and agrees with
                                                                                the recommendation.</span>
                                                                        </td>
                                                                    </tr>
                                                                </table>
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
                                                <td class="padding_label1">
                                                    <div id="divCustomGridPsychiatricReferralContainer" style="width: 98%">
                                                        <table cellpadding="0" cellspacing="0" border="0" style="width: 98%">
                                                            <tr>
                                                                <td align="left" style="padding-left: 8px" colspan="4">
                                                                    <div id="InsertGridPsychiatricReferrals" style="overflow-x: hidden; overflow-y: auto;
                                                                        height: 100px; width: 100%;">
                                                                        <uc1:CustomGrid ID="CustomGridPsychiatricReferrals" runat="server" TableName="CustomDocumentPsychiatricEvaluationReferrals"
                                                                            PrimaryKey="ReferralId" CustomGridTableName="TableChildControl_CustomDocumentPsychiatricEvaluationReferrals"
                                                                            GridPageName="Diagnostic Psychiatric" ColumnName="ServiceRecommendedText:ServiceUnitTypeText:ServiceFrequencyText:ReceivingStaffIdText"
                                                                            ColumnHeader="Service:Amount:Frequency:Staff" ColumnWidth="150:110:130:260" DivGridName="InsertGridPsychiatricReferrals"
                                                                            InsertButtonId="TableChildControl_CustomDocumentPsychiatricEvaluationReferrals_ButtonInsert" />
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <input id="HiddenField_CustomDocumentPsychiatricEvaluationReferrals_ReferralId" parentchildcontrols="True"
                                                                        name="HiddenField_CustomDocumentPsychiatricEvaluationReferrals_ReferralId" type="hidden"
                                                                        value="-1" />
                                                                    <input type="hidden" id="HiddenFieldPrimaryKey" name="HiddenFieldPrimaryKey" value="ReferralId" />
                                                                    <input id="HiddenFieldForigenKey" name="HiddenFieldForigenKey" type="hidden" value="DocumentVersionId" />
                                                                    <input type="hidden" parentchildcontrols="True" id="HiddenField_CustomDocumentPsychiatricEvaluationReferrals_DocumentVersionId"
                                                                        name="HiddenField_CustomDocumentPsychiatricEvaluationReferrals_DocumentVersionId" value="-1" />
                                                                    <input type="hidden" parentchildcontrols="True" id="HiddenField_CustomDocumentPsychiatricEvaluationReferrals_ServiceUnitType"
                                                                        name="HiddenField_CustomDocumentPsychiatricEvaluationReferrals_ServiceUnitType" value="" />
                                                                    <input type="hidden" parentchildcontrols="True" id="HiddenField_CustomDocumentPsychiatricEvaluationReferrals_ServiceUnitTypeText"
                                                                        name="HiddenField_CustomDocumentPsychiatricEvaluationReferrals_ServiceUnitTypeText" value="" />
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>
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
                </table>
            </td>
        </tr>
    </table>
</div>
