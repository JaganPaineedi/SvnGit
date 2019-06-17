<%@ Control Language="C#" AutoEventWireup="true" CodeFile="DiagnosticNarrativeSummary.ascx.cs"
    Inherits="ActivityPages_Harbor_Client_Detail_Documents_DiagnosticAssessment_DiagnosticNarrativeSummary" %>
<%@ Register Src="~/CommonUserControls/CustomGrid.ascx" TagName="CustomGrid" TagPrefix="uc1" %>
<%@ Register Assembly="Streamline.DotNetDropDowns" Namespace="Streamline.DotNetDropDowns"
    TagPrefix="cc1" %>
<%@ Register Assembly="Streamline.DotNetDropDownGlobalCodes" Namespace="Streamline.DotNetDropDownGlobalCodes"
    TagPrefix="DropDownGlobalCodes" %>
    
<% if (HttpContext.Current == null)
   { %>
<link href="../../../../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet"
    type="text/css" />
<%} %>
<%--<script type="text/javascript" language="javascript" src="<%=RelativePath%>JScripts/Scripts/DiagnosticNarrativeSummary.js"></script>
--%><div style="overflow-x: hidden">
    <table border="0" cellpadding="0" cellspacing="0" class="DocumentScreen">
        <tr>
            <td>
                <table border="0" cellpadding="0" cellspacing="0" width="99%">
                    <tr>
                        <td>
                            <table id="TablePreferences" border="0" cellpadding="0" cellspacing="0" width="99%">
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                    Client’s Preferences for treatment and people/agencies the client wishes to involve
                                                    in the treatment:
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
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td colspan="7" class="height1">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="padding_label1">
                                                    <textarea class="form_textarea" id="TextArea_CustomDocumentDiagnosticAssessments_ClientPreferencesForTreatment"
                                                        name="TextArea_CustomDocumentDiagnosticAssessments_ClientPreferencesForTreatment" rows="5" spellcheck="True"
                                                        cols="1" style="width: 790px" ></textarea>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="7">
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
                    
                     <tr>
                        <td>
                            <table id="TableServicePlan" border="0" cellpadding="0" cellspacing="0"
                                width="99%" >
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                    Service Plan / Recommended Referrals:
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
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td colspan="7" class="height1">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="padding_label1">
                                                    <textarea class="form_textarea" id="TextArea_CustomDocumentDiagnosticAssessments_ExternalSupportsReferrals"
                                                        name="TextArea_CustomDocumentDiagnosticAssessments_ExternalSupportsReferrals" rows="5" spellcheck="True"
                                                        cols="1" style="width: 790px" ></textarea>
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
                                                    Harbor Services/Evaluations Recommended:
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
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%"  id="TableChildControl_CustomDocumentAssessmentReferrals">
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
                                                                <cc1:StreamlineDropDowns ID="DropDownList_CustomDocumentAssessmentReferrals_ServiceRecommended"
                                                                    CssClass="form_dropdown" name="DropDownList_CustomDocumentAssessmentReferrals_ServiceRecommended"
                                                                    runat="server" Width="240px" bindautosaveevents="False" parentchildcontrols="True" Required="true">
                                                                </cc1:StreamlineDropDowns>
                                                            </td>
                                                            <td width="5%" align="center">
                                                                <span class="form_label">Amount</span>
                                                            </td>
                                                            <td width="4%">
                                                                <input type="text" style="width: 60px" class="form_textbox" id="TextBox_CustomDocumentAssessmentReferrals_ServiceAmount" datatype="Numeric"
                                                                    name="TextBox_CustomDocumentAssessmentReferrals_ServiceAmount" bindautosaveevents="False" parentchildcontrols="True" maxlength="7" Required="true"/>
                                                              </td>
                                                              <td width="5%" align="left">     
                                                                 <span id="Span_CustomDocumentAssessmentReferrals_ServiceUnitTypeValue" parentchildcontrols="True" class="form_label"
                                                                  name="Span_CustomDocumentAssessmentReferrals_ServiceUnitTypeValue" bindautosaveevents="False">
                                                                 </span>
                                                            </td>
                                                            <td width="5%">
                                                                <span class="form_label">Frequency</span>
                                                            </td>
                                                            <td width="9%">
                                                             <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentAssessmentReferrals_ServiceFrequency" bindautosaveevents="False" parentchildcontrols="True" Required="true"
                                                              Category="TPFREQUENCYTYPE" runat="server" Width="140px"  CssClass="form_dropdowns" AddBlankRow="true" BlankRowText="">
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
                                                                            <span class="form_label">Receiving Staff</span>
                                                                            &nbsp;&nbsp;<img id="imgFolderReferral" alt="" style="vertical-align: top; cursor:pointer;" src="<%=RelativePath%>App_Themes/Includes/Images/folder-icon.gif" />
                                                                        </td>
                                                                        <td>
                                                                            <cc1:StreamlineDropDowns ID="DropDownList_CustomDocumentAssessmentReferrals_ReceivingStaffId" Required="true"
                                                                                CssClass="form_dropdown" name="DropDownList_CustomDocumentAssessmentReferrals_ReceivingStaffId"
                                                                                runat="server" Width="360px" bindautosaveevents="False" parentchildcontrols="True">
                                                                            </cc1:StreamlineDropDowns>
                                                                        </td>
                                                                        <td width="165px"></td>
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
                                                                            <input type="text" style="width: 350px" maxlength="500" class="form_textbox" id="TextBox_CustomDocumentAssessmentReferrals_AssessedNeedForReferral"
                                                                                name="TextBox_CustomDocumentAssessmentReferrals_AssessedNeedForReferral" bindautosaveevents="False" parentchildcontrols="True" />
                                                                        </td>
                                                                        
                                                                        <td align="left"><input name="TableChildControl_CustomDocumentAssessmentReferrals_ButtonInsert" class="parentchildbutton element" id="TableChildControl_CustomDocumentAssessmentReferrals_ButtonInsert"  type="button" value="Insert"
                                                                        onclick="return  InsertGridCustomAssessmentReferralData('TableChildControl_CustomDocumentAssessmentReferrals','InsertGridAssessmentReferrals','CustomGridAssessmentReferrals',this,'<%=ResolveUrl("~") %>');" /> 
                                                                        &nbsp; 
                                                                        <input name="ButtonClear" class="parentchildbutton element" id="ButtonClear" onclick="ClearAssessmentReferrals();ClearTable('TableChildControl_CustomDocumentAssessmentReferrals','TableChildControl_CustomDocumentAssessmentReferrals_ButtonInsert',false);" type="button" value="Clear"/>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height1">
                                                                            &nbsp;
                                                                        </td>
                                                                    </tr>
                                                                    <tr class="checkbox_container"><td colspan="3">&nbsp;<input name="CheckBox_CustomDocumentAssessmentReferrals_ClientParticipatedReferral" class="element" id="CheckBox_CustomDocumentAssessmentReferrals_ClientParticipatedReferral" type="checkbox" bindautosaveevents="False" parentchildcontrols="True"/> 
                                                                    <label for="CheckBox_CustomDocumentAssessmentReferrals_ClientParticipatedReferral">
                                                       Client/guardian participated in this decision and agrees with the recommendation.</label>
                                                                   </td></tr>
                                                     
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
                                                    <div id="divCustomGridAssessmentReferralContainer" style="width:98%">
                                                        <table cellpadding="0" cellspacing="0" border="0" style="width: 98%">
                                                            <tr>
                                                                <td align="left" style="padding-left: 8px" colspan="4">
                                                                    <div id="InsertGridAssessmentReferrals" style="overflow-x: hidden; overflow-y: auto;
                                                                        height: 100px; width: 100%;">
                                                                        <uc1:CustomGrid ID="CustomGridAssessmentReferrals" runat="server" TableName="CustomDocumentAssessmentReferrals"
                                                                            PrimaryKey="AssessmentReferralId" CustomGridTableName="TableChildControl_CustomDocumentAssessmentReferrals"
                                                                            GridPageName="Diagnostic Assessment" ColumnName="ServiceRecommendedText:ServiceUnitTypeText:ServiceFrequencyText:ReceivingStaffIdText"
                                                                            ColumnHeader="Service:Amount:Frequency:Staff" ColumnWidth="150:110:130:260" DivGridName="InsertGridAssessmentReferrals"
                                                                            InsertButtonId="TableChildControl_CustomDocumentAssessmentReferrals_ButtonInsert" />
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <input id="HiddenField_CustomDocumentAssessmentReferrals_AssessmentReferralId" parentchildcontrols="True"
                                                                        name="HiddenField_CustomDocumentAssessmentReferrals_AssessmentReferralId" type="hidden"
                                                                        value="-1" />
                                                                    <input type="hidden" id="HiddenFieldPrimaryKey" name="HiddenFieldPrimaryKey" value="AssessmentReferralId" />
                                                                    <input id="HiddenFieldForigenKey" name="HiddenFieldForigenKey" type="hidden" value="DocumentVersionId" />
                                                                    <input type="hidden" parentchildcontrols="True" id="HiddenField_CustomDocumentAssessmentReferrals_DocumentVersionId"
                                                                        name="HiddenField_CustomDocumentAssessmentReferrals_DocumentVersionId" value="-1" />
                                                                        <input type="hidden" parentchildcontrols="True" id="HiddenField_CustomDocumentAssessmentReferrals_ServiceUnitType"
                                                                        name="HiddenField_CustomDocumentAssessmentReferrals_ServiceUnitType" value="" />
                                                                         <input type="hidden" parentchildcontrols="True" id="HiddenField_CustomDocumentAssessmentReferrals_ServiceUnitTypeText"
                                                                        name="HiddenField_CustomDocumentAssessmentReferrals_ServiceUnitTypeText" value="" />
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
                    <tr>
                        <td>
                            <table id="TableClientExternalSupport" border="0" cellpadding="0" cellspacing="0"
                                width="99%" >
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                    External Supports/Referrals:
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
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td colspan="7" class="height1">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="padding_label1">
                                                    <textarea class="form_textarea" id="TextArea_CustomDocumentDiagnosticAssessments_ExternalSupportsReferrals"
                                                        name="TextArea_CustomDocumentDiagnosticAssessments_ExternalSupportsReferrals" rows="5" spellcheck="True"
                                                        cols="1" style="width: 790px" ></textarea>
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
                    
                    <tr>
                        <td>
                            <table id="TablePrimaryClinicianAssignment" border="0" cellpadding="0" cellspacing="0"
                                width="99%" >
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                    Primary Clinician Assignment:
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
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td>
                                                    <table cellpadding="0" cellspacing="0" border="0">
                                                        <tr class="RadioText">
                                                            <td style="width: 5px">
                                                            </td>
                                                            <td><%-- By default, --%>
                                                                <label for="RadioButton_CustomDocumentDiagnosticAssessments_PrimaryClinicianTransfer_Y">
                                                                    &nbsp;The author of the DA is assigned as the primary clinician for
                                                                    this client. Do you wish to transfer the case to a different clinician?</label>
                                                            </td>
                                                            <td width="8px">
                                                                &nbsp;
                                                            </td>
                                                            <td class="padding_label1" width="45px">
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_PrimaryClinicianTransfer_Y"
                                                                    name="RadioButton_CustomDocumentDiagnosticAssessments_PrimaryClinicianTransfer" value="Y" onclick="EnableDisableTransfer(this);"/>
                                                                <label for="RadioButton_CustomDocumentDiagnosticAssessments_PrimaryClinicianTransfer_Y">
                                                                    Yes</label>
                                                            </td>
                                                            <td width="8px">
                                                                &nbsp;
                                                            </td>
                                                            <td>
                                                                <input class="cursor_default" type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_PrimaryClinicianTransfer_N"
                                                                    name="RadioButton_CustomDocumentDiagnosticAssessments_PrimaryClinicianTransfer" value="N" onclick="EnableDisableTransfer(this);"/>
                                                                <label for="RadioButton_CustomDocumentDiagnosticAssessments_PrimaryClinicianTransfer_N">
                                                                    No
                                                                </label>
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
                            <table id="TableTransfer" border="0" cellpadding="0" cellspacing="0" width="99%" >
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                    Transfer
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
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td>
                                                    <table  border="0" cellspacing="0" cellpadding="0" width="100%">
                                                        <tr>
                                                            <td colspan="2" class="height1">
                                                                &nbsp;
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="1.5%">
                                                            </td>
                                                            <td >
                                                                <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                                                    <tr>
                                                                        <td width="18%">
                                                                            <span class="form_label">Receiving Staff</span>  
                                                                            &nbsp;&nbsp;<img id="imgFolderTransfer" alt="" style="vertical-align: top; cursor:pointer;" src="<%=RelativePath%>App_Themes/Includes/Images/folder-icon.gif" />
                                                                        </td>
                                                                        <td>
                                                                            <cc1:StreamlineDropDowns ID="DropDownList_CustomDocumentDiagnosticAssessments_TransferReceivingStaff"
                                                                                CssClass="form_dropdown" name="DropDownList_CustomDocumentDiagnosticAssessments_TransferReceivingStaff"
                                                                                runat="server" Width="360px"  OnChange="DropDownFillRecProgramByReceivingStaff()"  BindAutoSaveEvents="False">
                                                                            </cc1:StreamlineDropDowns>
                                                                        </td>
                                                                        <td>
                                                                            <span class="form_label">Rec. Program</span>
                                                                        </td>
                                                                        <td>
                                                                            <%--Modifed By : Amit Kumar Srivastava, #1979, Harbor Go Live Issues, SPECIFICATION: Fill Receiving Program Drop-Down Dyanmically--%>
                                                                            <cc1:StreamlineDropDowns ID="DropDownList_CustomDocumentDiagnosticAssessments_TransferReceivingProgram"
                                                                                CssClass="form_dropdown" name="DropDownList_CustomDocumentDiagnosticAssessments_TransferReceivingProgram"
                                                                                runat="server" Width="160px">
                                                                            </cc1:StreamlineDropDowns>                                                                            
                                                                            <%--<DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentDiagnosticAssessments_TransferReceivingProgram"
                                                                                Category="PROGRAMTYPE" runat="server" Width="160px" CssClass="form_dropdowns" AddBlankRow="true" BlankRowText="">
                                                                            </DropDownGlobalCodes:DropDownGlobalCodes>--%>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height1">
                                                                            &nbsp;
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <span class="form_label">Assessed Need for Transfer</span>
                                                                        </td>
                                                                        <td colspan="3">
                                                                            <input type="text" style="width: 350px" class="form_textbox" maxlength="250" id="TextBox_CustomDocumentDiagnosticAssessments_TransferAssessedNeed"
                                                                                name="TextBox_CustomDocumentDiagnosticAssessments_TransferAssessedNeed" />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height1">
                                                                            &nbsp;
                                                                        </td>
                                                                    </tr>
                                                                    <tr class="checkbox_container">
                                                                        <td colspan="4">
                                                                            &nbsp;<input name="CheckBox_CustomDocumentDiagnosticAssessments_TransferClientParticipated"
                                                                                class="element" id="CheckBox_CustomDocumentDiagnosticAssessments_TransferClientParticipated"
                                                                                type="checkbox" />
                                                                                <label for="CheckBox_CustomDocumentDiagnosticAssessments_TransferClientParticipated">
                                                                                Client/guardian participated in this decision and agrees with the recommendation.</label>
                                                                         
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                             <tr><td>
                                             <table border="0" cellspacing="0" cellpadding="0" width="100%"  id="TableChildControl_CustomDocumentAssessmentTransferServices" >
                                                                    <tr>  
                                                                      <td class="height1">
                                                                            &nbsp;
                                                                        </td>
                                                                    </tr>
                                                        <tr>
                                                            <td>
                                                                <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                                                    <tr>
                                                                        <td width="7%" align="center">
                                                                            <span class="form_label">Service</span>
                                                                        </td>
                                                                        <td>
                                                                            <cc1:StreamlineDropDowns ID="DropDownList_CustomDocumentAssessmentTransferServices_TransferService"
                                                                                CssClass="form_dropdown" runat="server" Width="250px" bindautosaveevents="False" required="true"
                                                                                parentchildcontrols="True">
                                                                            </cc1:StreamlineDropDowns>
                                                                            &nbsp;
                                                                            <input name="TableChildControl_CustomDocumentAssessmentTransferServices_ButtonInsert"
                                                                                class="parentchildbutton" baseurl="<%=ResolveUrl("~") %>" id="TableChildControl_CustomDocumentAssessmentTransferServices_ButtonInsert"
                                                                                onclick="return InsertGridCustomAssessmentTransferServicesData(this,'TableChildControl_CustomDocumentAssessmentTransferServices','InsertGridAssessmentTransferServices','CustomAssessmentTransferServicesGrid','<%=ResolveUrl("~") %>');"
                                                                                type="button" value="Insert" />
                                                                                 &nbsp; 
                                                                        <input name="ButtonClear" class="parentchildbutton element" id="btnClear" onclick="ClearAssessmentTransferServices();ClearTable('TableChildControl_CustomDocumentAssessmentTransferServices','TableChildControl_CustomDocumentAssessmentTransferServices_ButtonInsert',false);" type="button" value="Clear"/>
                                                                       
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
                                                                                              
                                                 <div id="divCustomGridTransferServicesContainer" style="width: 99%">
                                                        <table cellpadding="0" cellspacing="0" border="0" style="width: 99%" >
                                                            <tr>
                                                                <td align="left" style="padding-left: 8px" >
                                                                    <div id="InsertGridAssessmentTransferServices" style="overflow-x: hidden; overflow-y: auto; height: 100px; width: 100%;">
                                                                         <uc1:CustomGrid ID="CustomAssessmentTransferServicesGrid" runat="server" TableName="CustomDocumentAssessmentTransferServices"
                                                                            PrimaryKey="AssessmentTransferServiceId" CustomGridTableName="TableChildControl_CustomDocumentAssessmentTransferServices"
                                                                            GridPageName="Diagnostic Assessment"  ColumnName="TransferServiceText" ColumnHeader="Service"
                                                                             ColumnWidth="100%"  DivGridName="InsertGridAssessmentTransferServices" InsertButtonId="TableChildControl_CustomDocumentAssessmentTransferServices_ButtonInsert" />
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                   <input id="HiddenField_CustomDocumentAssessmentTransferServices_AssessmentTransferServiceId"
                                                                        parentchildcontrols="True" name="HiddenField_CustomDocumentAssessmentTransferServices_AssessmentTransferServiceId"
                                                                        type="hidden" value="-1" />
                                                                    <input type="hidden" id="HiddenFieldPrimaryKey" name="HiddenFieldPrimaryKey" value="AssessmentTransferServiceId" />
                                                                    <input id="HiddenFieldForigenKey" name="HiddenFieldForigenKey" type="hidden" value="DocumentVersionId" />
                                                                    <input type="hidden" parentchildcontrols="True" id="HiddenField_CustomDocumentAssessmentTransferServices_DocumentVersionId"
                                                                        name="HiddenField_CustomDocumentAssessmentTransferServices_DocumentVersionId"
                                                                        value="-1" />
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
 