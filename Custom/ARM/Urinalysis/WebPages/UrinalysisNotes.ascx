<%@ Control Language="C#" AutoEventWireup="true" CodeFile="UrinalysisNotes.ascx.cs" Inherits="SHS.SmartCare.Custom_Urinalysis_WebPages_UrinalysisNotes" %>
<%@ Register Src="~/CommonUserControls/CustomGrid.ascx" TagName="CustomGrid" TagPrefix="uc1" %>
<%@ Register Assembly="Streamline.DotNetDropDownGlobalCodes" Namespace="Streamline.DotNetDropDownGlobalCodes" TagPrefix="cc2" %>

<% if (HttpContext.Current == null)
   { %>
<link href="../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet"
    type="text/css" />
<%} %>

<%--<script language="javascript" type="text/javascript" src="<%=RelativePath%>Custom/Scripts/CrisisPlan.js" ></script>--%>

<input id="HiddenFieldPageTables" runat="server" name="HiddenFieldPageTables" type="hidden"
    value="CustomDocumentUrinalysis" />
    <input id="HiddenFieldCustomAjaxCallType" runat="server" name="HiddenFieldCustomAjaxCallType" type="hidden" />
    
<table class="DocumentScreen" border="0" cellspacing="0" cellpadding="0" >
    <tr>
        <td style="padding-left: 10px; padding-right: 5px">
            <%--<span class="form_label_text" id="Span1">Clinician facilitating plan development</span>
            &nbsp;&nbsp;&nbsp;--%>
            <table>
                <tr>
                    <td colspan="3" class="form_label_text">New Issues Presented Today: Observed/Reported Changes in Medical Condition, Stressors, Extraordinary Events, and Actions Taken</td>
                </tr>
                <tr>
                    <td class="height2" colspan="3">
                    </td>
                </tr>
                <tr>
                    <td>
                        <input type="radio" id="RadioButton_CustomDocumentUrinalysis_IssuesPresentedToday_A"
                         name="RadioButton_CustomDocumentUrinalysis_IssuesPresentedToday" value="A"
                         class="form_checkbox element YorN" /><label for="RadioButton_CustomDocumentUrinalysis_IssuesPresentedToday_A" class="form_label">None Reported</label>
                    </td>
                    <td>
                        <input type="radio" id="RadioButton_CustomDocumentUrinalysis_IssuesPresentedToday_Y"
                         name="RadioButton_CustomDocumentUrinalysis_IssuesPresentedToday" value="Y"
                         class="form_checkbox element YorN" /><label for="RadioButton_CustomDocumentUrinalysis_IssuesPresentedToday_Y" class="form_label">DA Update Required</label>
                    </td>
                    <td>
                    <input type="radio" id="RadioButton_CustomDocumentUrinalysis_IssuesPresentedToday_N"
                         name="RadioButton_CustomDocumentUrinalysis_IssuesPresentedToday" value="N"
                         class="form_checkbox element YorN" /><label for="RadioButton_CustomDocumentUrinalysis_IssuesPresentedToday_N" class="form_label">New information, No DA Update Required</label>
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
            <table border="0" cellspacing="0" cellpadding="0" width="90%">
                <tr>
                    <td align="left">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                    Client's Condition(for face-to-face visit)
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
                                <td class="height2" colspan="6">
                                </td>
                            </tr>
                            <tr>
                                <td style="padding-left: 10px; padding-right: 5px" colspan="6" class="form_label_text">
                                Mood/Affect/Thought Process/Orientation/Behavior/Functioning
                                </td>
                            </tr>
                            <tr>
                                <td style="padding-left: 10px; padding-right: 5px" colspan="6">
                                    <textarea id="TextArea_CustomDocumentUrinalysis_MoodAffectComment"
                                        name="TextArea_CustomDocumentUrinalysis_MoodAffectComment"
                                        rows="4" cols="158" class="form_textarea" spellcheck="True"></textarea>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2" colspan="6">
                                </td>
                            </tr>
                            <tr>
                                <td style="padding-left: 10px; padding-right: 5px" colspan="6"  class="form_label_text">
                                Danger to
                                </td>
                            </tr>
                            <tr>
                                <td class="height2" colspan="6">
                                </td>
                            </tr>
                            <tr>
                                <td style="padding-left: 10px; padding-right: 5px">
                                    <input type="checkbox" id="CheckBox_CustomDocumentUrinalysis_RiskNone"
                                       class="RadioText" name="CheckBox_CustomDocumentUrinalysis_RiskNone" />
                                    <span class="RadioText">None</span>
                                </td>
                                <td >
                                    <input type="checkbox" id="CheckBox_CustomDocumentUrinalysis_RiskSelf"
                                       class="RadioText" name="CheckBox_CustomDocumentUrinalysis_RiskSelf" />
                                    <span class="RadioText">Self</span>
                                </td>
                                <td >
                                    <input type="checkbox" id="CheckBox_CustomDocumentUrinalysis_RiskOthers"
                                       class="RadioText" name="CheckBox_CustomDocumentUrinalysis_RiskOthers" />
                                    <span class="RadioText">Others</span>
                                </td>
                                <td colspan="3">
                                    <input type="checkbox" id="CheckBox_CustomDocumentUrinalysis_RiskProperty"
                                       class="RadioText" name="CheckBox_CustomDocumentUrinalysis_RiskProperty" />
                                    <span class="RadioText">Property</span>
                                </td>
                                
                            </tr>
                            <tr>
                                <td style="padding-left: 10px; padding-right: 5px">
                                    <input type="checkbox" id="CheckBox_CustomDocumentUrinalysis_RiskIdeation"
                                       class="RadioText" name="CheckBox_CustomDocumentUrinalysis_RiskIdeation" />
                                    <span class="RadioText">Ideation</span>
                                </td>
                                <td >
                                    <input type="checkbox" id="CheckBox_CustomDocumentUrinalysis_RiskPlan"
                                       class="RadioText" name="CheckBox_CustomDocumentUrinalysis_RiskPlan" />
                                    <span class="RadioText">Plan</span>
                                </td>
                                <td >
                                    <input type="checkbox" id="CheckBox_CustomDocumentUrinalysis_RiskIntent"
                                       class="RadioText" name="CheckBox_CustomDocumentUrinalysis_RiskIntent" />
                                    <span class="RadioText">Intent</span>
                                </td>
                                <td>
                                    <input type="checkbox" id="CheckBox_CustomDocumentUrinalysis_RiskAttempt"
                                       class="RadioText" name="CheckBox_CustomDocumentUrinalysis_RiskAttempt" />
                                    <span class="RadioText">Attempt</span>
                                </td>
                                <td>
                                    <input type="checkbox" id="CheckBox_CustomDocumentUrinalysis_RiskOther"
                                       class="RadioText" name="CheckBox_CustomDocumentUrinalysis_RiskOther" />
                                    <span class="RadioText">Other</span>
                                </td>
                                <td>
                                    <input type="text" id="TextBox_CustomDocumentUrinalysis_RiskOtherComment"
                                    maxlength="300" style="width: 60%;" name="TextBox_CustomDocumentUrinalysis_RiskOtherComment"
                                    class="form_textbox element" />
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
        <td class="height2">
        </td>
    </tr>
   <%-- ---intervention ----%>
   <tr>
        <td>
            <table border="0" cellspacing="0" cellpadding="0" width="90%">
                <tr>
                    <td align="left">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                    Therapeutic Interventions Provided/Planned
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
                                <td class="height2" colspan="9">
                                </td>
                            </tr>
                            <tr>
                                <td style="padding-left: 10px; padding-right: 5px" colspan="9" class="form_label_text">
                                Substances checked were screened
                                </td>
                            </tr>
                            <tr>
                                <td class="height2" colspan="9">
                                </td>
                            </tr>
                            <tr>
                                <td style="padding-left: 10px; padding-right: 5px">
                                    <input type="checkbox" id="CheckBox_CustomDocumentUrinalysis_InterventionADUL"
                                       class="RadioText" name="CheckBox_CustomDocumentUrinalysis_InterventionADUL" />
                                    <span class="RadioText">ADUL</span>
                                </td>
                                <td >
                                    <input type="checkbox" id="CheckBox_CustomDocumentUrinalysis_InterventionAMP"
                                       class="RadioText" name="CheckBox_CustomDocumentUrinalysis_InterventionAMP" />
                                    <span class="RadioText">AMP</span>
                                </td>
                                <td >
                                    <input type="checkbox" id="CheckBox_CustomDocumentUrinalysis_InterventionBZO"
                                       class="RadioText" name="CheckBox_CustomDocumentUrinalysis_InterventionBZO" />
                                    <span class="RadioText">BZO</span>
                                </td>
                                <td>
                                    <input type="checkbox" id="CheckBox_CustomDocumentUrinalysis_InterventionCOC"
                                       class="RadioText" name="CheckBox_CustomDocumentUrinalysis_InterventionCOC" />
                                    <span class="RadioText">COC</span>
                                </td>
                                <td>
                                    <input type="checkbox" id="CheckBox_CustomDocumentUrinalysis_InterventionMET"
                                       class="RadioText" name="CheckBox_CustomDocumentUrinalysis_InterventionMET" />
                                    <span class="RadioText">MET</span>
                                </td>
                                <td>
                                    <input type="checkbox" id="CheckBox_CustomDocumentUrinalysis_InterventionMOP"
                                       class="RadioText" name="CheckBox_CustomDocumentUrinalysis_InterventionMOP" />
                                    <span class="RadioText">MOP</span>
                                </td>
                                <td>
                                    <input type="checkbox" id="CheckBox_CustomDocumentUrinalysis_InterventionTHC"
                                       class="RadioText" name="CheckBox_CustomDocumentUrinalysis_InterventionTHC" />
                                    <span class="RadioText">THC</span>
                                </td>
                                <td colspan="2">
                                    <input type="checkbox" id="CheckBox_CustomDocumentUrinalysis_InterventionOXY"
                                       class="RadioText" name="CheckBox_CustomDocumentUrinalysis_InterventionOXY" />
                                    <span class="RadioText">OXY</span>
                                </td>
                            </tr>
                            <tr>
                                <td style="padding-left: 10px; padding-right: 5px">
                                    <input type="checkbox" id="CheckBox_CustomDocumentUrinalysis_InterventionMDMA"
                                       class="RadioText" name="CheckBox_CustomDocumentUrinalysis_InterventionMDMA" />
                                    <span class="RadioText">MDMA</span>
                                </td>
                                <td >
                                    <input type="checkbox" id="CheckBox_CustomDocumentUrinalysis_InterventionMTD"
                                       class="RadioText" name="CheckBox_CustomDocumentUrinalysis_InterventionMTD" />
                                    <span class="RadioText">MTD</span>
                                </td>
                                <td>
                                    <input type="checkbox" id="CheckBox_CustomDocumentUrinalysis_InterventionOPI"
                                       class="RadioText" name="CheckBox_CustomDocumentUrinalysis_InterventionOPI" />
                                    <span class="RadioText">OPI</span>
                                </td>
                                <td>
                                    <input type="checkbox" id="CheckBox_CustomDocumentUrinalysis_InterventionBUP"
                                       class="RadioText" name="CheckBox_CustomDocumentUrinalysis_InterventionBUP" />
                                    <span class="RadioText">BUP</span>
                                </td>
                                <td>
                                    <input type="checkbox" id="CheckBox_CustomDocumentUrinalysis_InterventionPCP"
                                       class="RadioText" name="CheckBox_CustomDocumentUrinalysis_InterventionPCP" />
                                    <span class="RadioText">PCP</span>
                                </td>
                                <td>
                                    <input type="checkbox" id="CheckBox_CustomDocumentUrinalysis_InterventionPPX"
                                       class="RadioText" name="CheckBox_CustomDocumentUrinalysis_InterventionPPX" />
                                    <span class="RadioText">PPX</span>
                                </td>
                                <td>
                                    <input type="checkbox" id="CheckBox_CustomDocumentUrinalysis_InterventionK2"
                                       class="RadioText" name="CheckBox_CustomDocumentUrinalysis_InterventionK2" />
                                    <span class="RadioText">K2</span>
                                </td>
                                <td>
                                    <input type="checkbox" id="CheckBox_CustomDocumentUrinalysis_InterventionOther"
                                       class="RadioText" name="CheckBox_CustomDocumentUrinalysis_InterventionOther" />
                                    <span class="RadioText">Other</span>
                                </td>
                                <td>
                                    <input type="text" id="TextBox_CustomDocumentUrinalysis_InterventionOtherComment"
                                    maxlength="300" style="width: 60%;" name="TextBox_CustomDocumentUrinalysis_InterventionOtherComment"
                                    class="form_textbox element" />
                                </td>
                            </tr>
                            <tr>
                                <td style="padding-left: 10px; padding-right: 5px" colspan="7">&nbsp;
                                </td>
                                <td colspan="2">
                                <input type="checkbox" id="CheckBox_CustomDocumentUrinalysis_SampleSendToLab"
                                       class="RadioText" name="CheckBox_CustomDocumentUrinalysis_SampleSendToLab" />
                                    <span class="RadioText">This urine sample will be sent to the lab for further testing</span>
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
        <td class="height2">
        </td>
    </tr>
    <%----response to intervention ----%>
    <tr>
        <td>
            <table border="0" cellspacing="0" cellpadding="0" width="90%">
                <tr>
                    <td align="left">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                    Response to Intervention/Progress Towards Goals and Objectives
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
                                <td class="height2" colspan="3">
                                </td>
                            </tr>
                            <tr>
                                <td style="padding-left: 10px; padding-right: 5px" colspan="3" class="form_label_text">
                                Result of Urinalysis:
                                </td>
                            </tr>
                            <tr>
                                <td class="height2" colspan="3">
                                </td>
                            </tr>
                            <tr>
                                <td style="padding-left: 10px; padding-right: 5px">
                                    <span class="RadioText">Temperature of urine sample:</span>
                                </td>
                                <td>
                                    <input type="radio" id="RadioButton_CustomDocumentUrinalysis_UrinalysisTemperature_Y"
                                     name="RadioButton_CustomDocumentUrinalysis_UrinalysisTemperature" value="Y"
                                     class="form_checkbox element YorN" /><label for="RadioButton_CustomDocumentUrinalysis_UrinalysisTemperature_Y" class="form_label">Appropriate</label>
                                </td>
                                <td>
                                    <input type="radio" id="RadioButton_CustomDocumentUrinalysis_UrinalysisTemperature_N"
                                     name="RadioButton_CustomDocumentUrinalysis_UrinalysisTemperature" value="N"
                                     class="form_checkbox element YorN" /><label for="RadioButton_CustomDocumentUrinalysis_UrinalysisTemperature_N" class="form_label">Inappropriate</label>
                                </td>
                                
                            </tr>
                            <tr>
                                <td class="height2" colspan="3">
                                </td>
                            </tr>
                            <tr>
                                <td style="padding-left: 10px; padding-right: 5px">
                                    <span class="RadioText">Share with Client:</span>
                                </td>
                                <td>
                                    <input type="radio" id="RadioButton_CustomDocumentUrinalysis_UrinalysisShareWithClient_Y"
                                     name="RadioButton_CustomDocumentUrinalysis_UrinalysisShareWithClient" value="Y"
                                     class="form_checkbox element YorN" /><label for="RadioButton_CustomDocumentUrinalysis_UrinalysisShareWithClient_Y" class="form_label">Yes</label>
                                </td>
                                <td>
                                    <input type="radio" id="RadioButton_CustomDocumentUrinalysis_UrinalysisShareWithClient_N"
                                     name="RadioButton_CustomDocumentUrinalysis_UrinalysisShareWithClient" value="N"
                                     class="form_checkbox element YorN" /><label for="RadioButton_CustomDocumentUrinalysis_UrinalysisShareWithClient_N" class="form_label">No</label>
                                </td>
                                
                            </tr>
                            <tr>
                                <td class="height2" colspan="3">
                                </td>
                            </tr>
                            <tr>
                                <td style="padding-left: 10px; padding-right: 5px">
                                    <span class="RadioText">Consistent with Client report:</span>
                                </td>
                                <td>
                                    <input type="radio" id="RadioButton_CustomDocumentUrinalysis_UrinalysisConsistentWithClientReport_Y"
                                     name="RadioButton_CustomDocumentUrinalysis_UrinalysisConsistentWithClientReport" value="Y"
                                     class="form_checkbox element YorN" /><label for="RadioButton_CustomDocumentUrinalysis_UrinalysisConsistentWithClientReport_Y" class="form_label">Yes</label>
                                </td>
                                <td>
                                    <input type="radio" id="RadioButton_CustomDocumentUrinalysis_UrinalysisConsistentWithClientReport_N"
                                     name="RadioButton_CustomDocumentUrinalysis_UrinalysisConsistentWithClientReport" value="N"
                                     class="form_checkbox element YorN" /><label for="RadioButton_CustomDocumentUrinalysis_UrinalysisConsistentWithClientReport_N" class="form_label">No</label>
                                </td>
                                
                            </tr>
                            <tr>
                                <td class="height2" colspan="3">
                                </td>
                            </tr>
                            <tr>
                                <td style="padding-left: 10px; padding-right: 5px">
                                    <span class="RadioText">Staff Rating of Client Progress:</span>
                                </td>
                                <td colspan="2">
                                    <cc2:DropDownGlobalCodes ID="DropDownList_CustomDocumentUrinalysis_UrineNoteStaffRating"
                                        CssClass="form_dropdown" name="DropDownList_CustomDocumentUrinalysis_UrineNoteStaffRating"    
                                        AddBlankRow="false" runat="server" Width="240px" Category="XURINENOTESTAFRATING"> <%--BlankRowValue="0" BlankRowText=""--%>
                                    </cc2:DropDownGlobalCodes>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2" colspan="3">
                                </td>
                            </tr>
                            <tr>
                                <td style="padding-left: 10px; padding-right: 5px" colspan="3">
                                    <span class="RadioText">Comments:</span>
                                    <br />
                                    <textarea id="TextArea_CustomDocumentUrinalysis_UrinalysisComment"
                                        name="TextArea_CustomDocumentUrinalysis_UrinalysisComment"
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
</table>        