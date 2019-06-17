<%@ Control Language="C#" AutoEventWireup="true" CodeFile="SuAssessment.ascx.cs"
    Inherits="SHS.SmartCare.ActivityPages_Client_Detail_Assessment_SuAssessment" %>
<%@ Register Src="~/Custom/Assessment/WebPages/UCHRMCurrentSubstanceUse.ascx"
    TagName="UCHRMCurrentSubstanceUse" TagPrefix="UserControl" %>
<% if (HttpContext.Current == null)
   { %>
<link href="../../../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet"
    type="text/css" />
<%} %>
<style type="text/css">
    .style2
    {
        width: 348px;
    }
</style>
<div style="margin: 0px,0px,0px,0px; overflow-x: hidden">
    <table border="0" cellpadding="0" cellspacing="0" class="DocumentScreen">
        <tr>
            <td>
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                        <td>
                            <table border="0" cellpadding="0" cellspacing="0" width="99%">
                                <tr>
                                    <td class="height2"></td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap='nowrap'>Substance Use
                                                </td>
                                                <td width="17">
                                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif"
                                                        width="17" height="26" alt="" />
                                                </td>
                                                <td class="content_tab_top" width="100%"></td>
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
                                                <td class="padding_label1">
                                                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                        <tr>
                                                            <td style="width: 33%" class="style2" valign="top">
                                                                <table cellpadding="0" cellspacing="0" border="0">
                                                                    <tr class="checkbox_container">
                                                                        <td>
                                                                            <input class="cursor_default" type="checkbox" id="CheckBox_CustomSubstanceUseAssessments_SubstanceAbuseAdmittedOrSuspected"
                                                                                name="CheckBox_CustomSubstanceUseAssessments_SubstanceAbuseAdmittedOrSuspected" />
                                                                            <label for="CheckBox_CustomSubstanceUseAssessments_SubstanceAbuseAdmittedOrSuspected">
                                                                                Past Substance use admitted or suspected</label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr class="height2">
                                                                        <td></td>
                                                                    </tr>
                                                                    <tr class="checkbox_container">
                                                                        <td>
                                                                            <input type="checkbox" id="CheckBox_CustomSubstanceUseAssessments_FamilySAHistory"
                                                                                name="CheckBox_CustomSubstanceUseAssessments_FamilySAHistory" />
                                                                            <label for="CheckBox_CustomSubstanceUseAssessments_FamilySAHistory">
                                                                                Family has a history of substance use</label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr class="height2">
                                                                        <td></td>
                                                                    </tr>
                                                                    <tr class="checkbox_container">
                                                                        <td>
                                                                            <input class="cursor_default" type="checkbox" id="CheckBox_CustomSubstanceUseAssessments_ClientSAHistory"
                                                                                name="CheckBox_CustomSubstanceUseAssessments_ClientSAHistory" />
                                                                            <label for="CheckBox_CustomSubstanceUseAssessments_ClientSAHistory">
                                                                                Client has a history of substance use</label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr class="height2">
                                                                        <td></td>
                                                                    </tr>
                                                                    <tr class="checkbox_container">
                                                                        <td>
                                                                            <input class="cursor_default" type="checkbox" id="CheckBox_CustomSubstanceUseAssessments_CurrentSubstanceAbuse"
                                                                                name="CheckBox_CustomSubstanceUseAssessments_CurrentSubstanceAbuse" />
                                                                            <label for="CheckBox_CustomSubstanceUseAssessments_CurrentSubstanceAbuse">
                                                                                Client admits to current substance use</label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr class="height2">
                                                                        <td></td>
                                                                    </tr>
                                                                    <tr class="checkbox_container">
                                                                        <td>
                                                                            <input class="cursor_default" type="checkbox" id="CheckBox_CustomSubstanceUseAssessments_SuspectedSubstanceAbuse"
                                                                                name="CheckBox_CustomSubstanceUseAssessments_SuspectedSubstanceAbuse" />
                                                                            <label for="CheckBox_CustomSubstanceUseAssessments_SuspectedSubstanceAbuse">
                                                                                Current substance use is suspected</label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height2"></td>
                                                                    </tr>
                                                                    <%-- commented by Vineet Tiwari Ref to Task SC Web Phase II Bugs/Features #177 --%>
                                                                    <%-- <tr >
                                                                        <td>
                                                                            <table cellpadding="0" cellspacing="0" border="0">
                                                                                <tr class="checkbox_container">
                                                                                    <td>
                                                                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomSubstanceUseAssessments_SubstanceAbuseTxPlan"
                                                                                            name="CheckBox_CustomSubstanceUseAssessments_SubstanceAbuseTxPlan" />
                                                                                        
                                                                                    </td>
                                                                                    <td style="padding-left:3px;">
                                                                                    <label  class="form_label_dfa" for="CheckBox_CustomSubstanceUseAssessments_SubstanceAbuseTxPlan">
                                                                                            Clinician recommends substance use/abuse be addressed on treatment plan</label>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>--%>
                                                                </table>
                                                            </td>
                                                            <td style="width: 65%" align="left" valign="top">
                                                                <span class="form_label">Comment</span>
                                                                <textarea id="TextArea_CustomSubstanceUseAssessments_SubstanceAbuseDetail" name="TextArea_CustomSubstanceUseAssessments_SubstanceAbuseDetail"
                                                                    spellcheck="True" datatype="String" rows="7" cols="100" class="form_textareaWithoutWidth"></textarea>
                                                            </td>
                                                        </tr>
                                                        <%--<tr class="checkbox_container">
                                                            <td colspan="2">
                                                                <input class="cursor_default" type="checkbox" id="CheckBox_CustomSubstanceUseAssessments_SubstanceAbuseTxPlan"
                                                                    name="CheckBox_CustomSubstanceUseAssessments_SubstanceAbuseTxPlan" />
                                                                <label for="CheckBox_CustomSubstanceUseAssessments_SubstanceAbuseTxPlan">
                                                                    Clinician recommends substance use/abuse be addressed on treatment plan</label>
                                                            </td>
                                                        </tr>--%>
                                                        <tr>
                                                            <td class="height1" colspan="2"></td>
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
                                                <td class="right_bottom_cont_bottom_bg" width="100%"></td>
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
                            <table border="0" cellpadding="0" cellspacing="0" width="99%">
                                <tr>
                                    <td class="height2"></td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap='nowrap'>Substance Abuse Symptoms/Consequences (reported or observed)
                                                </td>
                                                <td width="17">
                                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif"
                                                        width="17" height="26" alt="" />
                                                </td>
                                                <td class="content_tab_top" width="100%"></td>
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
                                                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                        <tr>
                                                            <td valign="top" class="padding_label1">
                                                                <table cellpadding="0" cellspacing="0" width="100%" border="0">
                                                                    <tr class="checkbox_container">
                                                                        <td>
                                                                            <input class="cursor_default" type="checkbox" id="CheckBox_CustomSubstanceUseAssessments_OdorOfSubstance"
                                                                                name="CheckBox_CustomSubstanceUseAssessments_OdorOfSubstance" />
                                                                            <label for="CheckBox_CustomSubstanceUseAssessments_OdorOfSubstance">
                                                                                Odor of substance</label>
                                                                        </td>
                                                                        <td>
                                                                            <input class="cursor_default" type="checkbox" id="CheckBox_CustomSubstanceUseAssessments_SlurredSpeech"
                                                                                name="CheckBox_CustomSubstanceUseAssessments_SlurredSpeech" />
                                                                            <label for="CheckBox_CustomSubstanceUseAssessments_SlurredSpeech">
                                                                                Slurred Speech</label>
                                                                        </td>
                                                                        <td>
                                                                            <input class="cursor_default" type="checkbox" id="CheckBox_CustomSubstanceUseAssessments_WithdrawalSymptoms"
                                                                                name="CheckBox_CustomSubstanceUseAssessments_WithdrawalSymptoms" />
                                                                            <label for="CheckBox_CustomSubstanceUseAssessments_WithdrawalSymptoms">
                                                                                Withdrawal Symptoms</label>
                                                                        </td>
                                                                        <td>
                                                                            <input class="cursor_default" type="checkbox" id="CheckBox_CustomSubstanceUseAssessments_IncreasedTolerance"
                                                                                name="CheckBox_CustomSubstanceUseAssessments_IncreasedTolerance" />
                                                                            <label for="CheckBox_CustomSubstanceUseAssessments_IncreasedTolerance">
                                                                                Increased Tolerance</label>
                                                                        </td>
                                                                        <td>
                                                                            <input class="cursor_default" type="checkbox" id="CheckBox_CustomSubstanceUseAssessments_Blackouts"
                                                                                name="CheckBox_CustomSubstanceUseAssessments_Blackouts" />
                                                                            <label for="CheckBox_CustomSubstanceUseAssessments_Blackouts">
                                                                                Blackouts</label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr class="height2">
                                                                        <td colspan="5"></td>
                                                                    </tr>
                                                                    <tr class="checkbox_container">
                                                                        <td>
                                                                            <input id="CheckBox_CustomSubstanceUseAssessments_LossOfControl" class="cursor_default"
                                                                                name="CheckBox_CustomSubstanceUseAssessments_LossOfControl" type="checkbox" />
                                                                            <label for="CheckBox_CustomSubstanceUseAssessments_LossOfControl">
                                                                                Loss of Control</label>
                                                                        </td>
                                                                        <td>
                                                                            <input class="cursor_default" type="checkbox" id="CheckBox_CustomSubstanceUseAssessments_RelatedArrests"
                                                                                name="CheckBox_CustomSubstanceUseAssessments_RelatedArrests" />
                                                                            <label for="CheckBox_CustomSubstanceUseAssessments_RelatedArrests">
                                                                                Related Arrests</label>
                                                                        </td>
                                                                        <td>
                                                                            <input class="cursor_default" type="checkbox" id="CheckBox_CustomSubstanceUseAssessments_RelatedSocialProblems"
                                                                                name="CheckBox_CustomSubstanceUseAssessments_RelatedSocialProblems" />
                                                                            <label for="CheckBox_CustomSubstanceUseAssessments_RelatedSocialProblems">
                                                                                Related Social Problems</label>
                                                                        </td>
                                                                        <td>
                                                                            <input class="cursor_default" type="checkbox" id="CheckBox_CustomSubstanceUseAssessments_FrequentJobSchoolAbsence"
                                                                                name="CheckBox_CustomSubstanceUseAssessments_FrequentJobSchoolAbsence" />
                                                                            <label for="CheckBox_CustomSubstanceUseAssessments_FrequentJobSchoolAbsence">
                                                                                Frequent Job/ School Absence</label>
                                                                        </td>
                                                                        <td style="width: 15%">
                                                                            <input class="cursor_default" type="checkbox" id="CheckBox_CustomSubstanceUseAssessments_NoneSynptomsReportedOrObserved"
                                                                                name="CheckBox_CustomSubstanceUseAssessments_NoneSynptomsReportedOrObserved" />
                                                                            <label for="CheckBox_CustomSubstanceUseAssessments_NoneSynptomsReportedOrObserved">
                                                                                None</label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr class="height4">
                                                                        <td colspan="5"></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="5">
                                                                            <table width="100%" cellpadding="0" cellspacing="0">
                                                                                <tr class="checkbox_container">
                                                                                    <td style="width: 15%" class="padding_label1">
                                                                                        <span class="form_label">DUI</span>
                                                                                    </td>
                                                                                    <td style="width: 2%"></td>
                                                                                    <td style="width: 23%">
                                                                                        <span class="form_label">How Many Times last 30 days? </span>
                                                                                    </td>
                                                                                    <td style="width: 8%">
                                                                                        <input type="text" id="TextBox_CustomSubstanceUseAssessments_DUI30Days" name="TextBox_CustomSubstanceUseAssessments_DUI30Days"
                                                                                            datatype="Numeric" maxlength="6" style="width: 70px" class="form_textarea" />
                                                                                    </td>
                                                                                    <td style="width: 5%"></td>
                                                                                    <td style="width: 23%">
                                                                                        <span class="form_label">How Many Times last 5 years? </span>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input type="text" id="TextBox_CustomSubstanceUseAssessments_DUI5Years" datatype="Numeric"
                                                                                            maxlength="6" name="TextBox_CustomSubstanceUseAssessments_DUI5Years" style="width: 70px"
                                                                                            class="form_textarea" />
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <tr class="height2">
                                                                        <td colspan="5"></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="5">
                                                                            <table width="100%" cellpadding="0" cellspacing="0">
                                                                                <tr class="checkbox_container">
                                                                                    <td style="width: 15%" class="padding_label1">
                                                                                        <span class="form_label">DWI</span>
                                                                                    </td>
                                                                                    <td style="width: 2%"></td>
                                                                                    <td style="width: 23%">
                                                                                        <span class="form_label">How Many Times last 30 days? </span>
                                                                                    </td>
                                                                                    <td style="width: 8%">
                                                                                        <input type="text" id="TextBox_CustomSubstanceUseAssessments_DWI30Days" name="TextBox_CustomSubstanceUseAssessments_DWI30Days"
                                                                                            datatype="Numeric" maxlength="6" style="width: 70px" class="form_textarea" />
                                                                                    </td>
                                                                                    <td style="width: 5%"></td>
                                                                                    <td style="width: 23%">
                                                                                        <span class="form_label">How Many Times last 5 years? </span>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input type="text" id="TextBox_CustomSubstanceUseAssessments_DWI5Years" datatype="Numeric"
                                                                                            maxlength="6" name="TextBox_CustomSubstanceUseAssessments_DWI5Years" style="width: 70px"
                                                                                            class="form_textarea" />
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <tr class="height2">
                                                                        <td colspan="5"></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="5">
                                                                            <table width="100%" cellpadding="0" cellspacing="0">
                                                                                <tr class="checkbox_container">
                                                                                    <td style="width: 15%" class="padding_label1">
                                                                                        <span class="form_label">Possession</span>
                                                                                    </td>
                                                                                    <td style="width: 2%"></td>
                                                                                    <td style="width: 23%">
                                                                                        <span class="form_label">How Many Times last 30 days? </span>
                                                                                    </td>
                                                                                    <td style="width: 8%">
                                                                                        <input type="text" id="TextBox_CustomSubstanceUseAssessments_Possession30Days" name="TextBox_CustomSubstanceUseAssessments_Possession30Days"
                                                                                            datatype="Numeric" maxlength="6" style="width: 70px" class="form_textarea" />
                                                                                    </td>
                                                                                    <td style="width: 5%"></td>
                                                                                    <td style="width: 23%">
                                                                                        <span class="form_label">How Many Times last 5 years? </span>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input type="text" id="TextBox_CustomSubstanceUseAssessments_Possession5Years" datatype="Numeric"
                                                                                            maxlength="6" name="TextBox_CustomSubstanceUseAssessments_Possession5Years" style="width: 70px"
                                                                                            class="form_textarea" />
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <tr class="height2">
                                                                        <td colspan="5"></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="5">
                                                                            <table width="100%" cellpadding="0" cellspacing="0">
                                                                                <tr class="checkbox_container">
                                                                                    <td style="width: 15%; vertical-align: top" class="padding_label1">
                                                                                        <span class="form_label">Other Comments:</span>
                                                                                    </td>
                                                                                    <td style="width: 2%"></td>
                                                                                    <td>
                                                                                        <textarea id="TextArea_CustomSubstanceUseAssessments_Comment" name="TextArea_CustomSubstanceUseAssessments_Comment"
                                                                                            spellcheck="True" datatype="String" rows="3" cols="1" style="width: 650px" class="form_textarea"></textarea>
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
                                                <td class="right_bottom_cont_bottom_bg" width="100%"></td>
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
                            <table cellpadding="0" cellspacing="0" border="0" width="99%">
                                <tr>
                                    <td>
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr>
                                                <td class="height2"></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                                        <tr>
                                                            <td class="content_tab_left" align="left" nowrap='nowrap'>History and Current Use of Substances
                                                            </td>
                                                            <td width="17">
                                                                <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif"
                                                                    width="17" height="26" alt="" />
                                                            </td>
                                                            <td class="content_tab_top" width="100%"></td>
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
                                                                <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                                    <tr>
                                                                        <td style="width=100%">
                                                                            <UserControl:UCHRMCurrentSubstanceUse ID="UserControl_CurrentSubstanceUse" runat="server" />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height1"></td>
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
                                                            <td class="right_bottom_cont_bottom_bg" width="100%"></td>
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
                        <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="99%">
                                <tr>
                                    <td style="width: 49%">
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr>
                                                <td class="height2"></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                                        <tr>
                                                            <td class="content_tab_left" align="left" nowrap='nowrap'>Periods of Abstinence
                                                            </td>
                                                            <td width="17">
                                                                <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif"
                                                                    width="17" height="26" alt="" />
                                                            </td>
                                                            <td class="content_tab_top" width="100%"></td>
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
                                                                <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                                    <tr>
                                                                        <td class="padding_label1">
                                                                            <table>
                                                                                <tr class="RadioText">
                                                                                    <td>
                                                                                        <span class="form_label">How long did the abstinence last? Was the abstinence voluntary
                                                                                        or involuntary? When was the last period of abstinence?
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <tr class="height2">
                                                                        <td></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="padding_label1">
                                                                            <textarea id="TextArea_CustomSubstanceUseAssessments_VoluntaryAbstinenceTrial" name="TextArea_CustomSubstanceUseAssessments_VoluntaryAbstinenceTrial"
                                                                                spellcheck="True" datatype="String" rows="12" cols="74" class="form_textareaWithoutWidth" onchange="UpdateNeedsXML(74,'subtancelist');"></textarea>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height1"></td>
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
                                                            <td class="right_bottom_cont_bottom_bg" width="100%"></td>
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
                                    <td style="width: 2%"></td>
                                    <td style="width: 49%">
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr>
                                                <td class="height2"></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                                        <tr>
                                                            <td class="content_tab_left" align="left" nowrap='nowrap'>Toxicology Results (if available)
                                                            </td>
                                                            <td width="17">
                                                                <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif"
                                                                    width="17" height="26" alt="" />
                                                            </td>
                                                            <td class="content_tab_top" width="100%"></td>
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
                                                                <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                                    <tr>
                                                                        <td class="padding_label1">
                                                                            <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                                                <tr class="RadioText">
                                                                                    <td>
                                                                                        <span class="form_label">(BAL, positive screen, etc.)</span>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <tr class="height2">
                                                                        <td></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="padding_label1">
                                                                            <textarea id="TextArea_CustomSubstanceUseAssessments_ToxicologyResults" name="TextArea_CustomSubstanceUseAssessments_ToxicologyResults"
                                                                                spellcheck="True" datatype="String" rows="14" cols="75" class="form_textareaWithoutWidth"></textarea>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height1"></td>
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
                                                            <td class="right_bottom_cont_bottom_bg" width="100%"></td>
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
                        <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="99%">
                                <tr>
                                    <td style="width: 49%">
                                        <table id="Table1" border="0" cellpadding="0" cellspacing="0" width="100%"
                                            group="CurrentTreatment">
                                            <tr>
                                                <td class="height2"></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                                        <tr>
                                                            <td class="content_tab_left" align="left" nowrap='nowrap'>Previous / Current Treatment <span id="Span1"></span>
                                                            </td>
                                                            <td width="17">
                                                                <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif"
                                                                    width="17" height="26" alt="" />
                                                            </td>
                                                            <td class="content_tab_top" width="100%"></td>
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
                                                                <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                                    <tr>
                                                                        <td class="padding_label1">
                                                                            <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                                                <tr class="RadioText">
                                                                                    <td style="width: 50%">
                                                                                        <span class="form_label">Previous substance use treatment?</span>
                                                                                    </td>
                                                                                    <td>&nbsp;
                                                                                    </td>
                                                                                    <td style="width: 14%">
                                                                                        <input class="cursor_default" type="radio" id="RadioButton_CustomSubstanceUseAssessments_PreviousTreatment_Y"
                                                                                            name="RadioButton_CustomSubstanceUseAssessments_PreviousTreatment" value="Y" />
                                                                                        <label for="RadioButton_CustomSubstanceUseAssessments_PreviousTreatment_Y">
                                                                                            Yes</label>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input class="cursor_default" type="radio" id="RadioButton_CustomSubstanceUseAssessments_PreviousTreatment_N"
                                                                                            name="RadioButton_CustomSubstanceUseAssessments_PreviousTreatment" value="N" />
                                                                                        <label for="RadioButton_CustomSubstanceUseAssessments_PreviousTreatment_N">
                                                                                            No</label>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <tr class="height2">
                                                                        <td></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="padding_label1">
                                                                            <table cellpadding="0" cellspacing="0" width="100%">
                                                                                <tr class="RadioText">
                                                                                    <td style="width: 50%">
                                                                                        <span class="form_label">Current substance use treatment?</span>
                                                                                    </td>
                                                                                    <td>&nbsp;
                                                                                    </td>
                                                                                    <td style="width: 14%">
                                                                                        <input class="cursor_default" type="radio" id="RadioButton_CustomSubstanceUseAssessments_CurrentSubstanceAbuseTreatment_Y"
                                                                                            name="RadioButton_CustomSubstanceUseAssessments_CurrentSubstanceAbuseTreatment" value="Y" />
                                                                                        <label for="RadioButton_CustomSubstanceUseAssessments_CurrentSubstanceAbuseTreatment_Y">
                                                                                            Yes</label>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input class="cursor_default" type="radio" id="RadioButton_CustomSubstanceUseAssessments_CurrentSubstanceAbuseTreatment_N"
                                                                                            name="RadioButton_CustomSubstanceUseAssessments_CurrentSubstanceAbuseTreatment" value="N" />
                                                                                        <label for="RadioButton_CustomSubstanceUseAssessments_CurrentSubstanceAbuseTreatment_N">
                                                                                            No</label>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <tr class="height2">
                                                                        <td></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="padding_label1">
                                                                            <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                                                <tr class="RadioText">
                                                                                    <td style="width: 50%">
                                                                                        <span class="form_label">Previous medication assisted treatment?</span>
                                                                                    </td>
                                                                                    <td>&nbsp;
                                                                                    </td>
                                                                                    <td style="width: 14%">
                                                                                        <input class="cursor_default" type="radio" id="RadioButton_CustomSubstanceUseAssessments_PreviousMedication_Y"
                                                                                            name="RadioButton_CustomSubstanceUseAssessments_PreviousMedication" value="Y" />
                                                                                        <label for="RadioButton_CustomSubstanceUseAssessments_PreviousMedication_Y">
                                                                                            Yes</label>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input class="cursor_default" type="radio" id="RadioButton_CustomSubstanceUseAssessments_PreviousMedication_N"
                                                                                            name="RadioButton_CustomSubstanceUseAssessments_PreviousMedication" value="N" />
                                                                                        <label for="RadioButton_CustomSubstanceUseAssessments_PreviousMedication_N">
                                                                                            No</label>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <tr class="height2">
                                                                        <td></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="padding_label1">
                                                                            <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                                                <tr class="RadioText">
                                                                                    <td style="width: 50%">
                                                                                        <span class="form_label">Current medication assisted treatment?</span>
                                                                                    </td>
                                                                                    <td>&nbsp;
                                                                                    </td>
                                                                                    <td style="width: 14%">
                                                                                        <input class="cursor_default" type="radio" id="RadioButton_CustomSubstanceUseAssessments_CurrentSubstanceAbuseMedication_Y"
                                                                                            name="RadioButton_CustomSubstanceUseAssessments_CurrentSubstanceAbuseMedication" value="Y" />
                                                                                        <label for="RadioButton_CustomSubstanceUseAssessments_CurrentSubstanceAbuseMedication_Y">
                                                                                            Yes</label>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input class="cursor_default" type="radio" id="RadioButton_CustomSubstanceUseAssessments_CurrentSubstanceAbuseMedication_N"
                                                                                            name="RadioButton_CustomSubstanceUseAssessments_CurrentSubstanceAbuseMedication" value="N" />
                                                                                        <label for="RadioButton_CustomSubstanceUseAssessments_CurrentSubstanceAbuseMedication_N">
                                                                                            No</label>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <tr class="height2">
                                                                        <td></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <table width="100%" cellpadding="0" cellspacing="2">
                                                                                <tr>
                                                                                    <td style="width: 20%" class="padding_label1">
                                                                                        <span class="form_label">List Providers</span>
                                                                                    </td>
                                                                                    <td>&nbsp;
                                                                                    </td>
                                                                                    <td style="width: 77%">
                                                                                        <%--<input type="text" id="TextBox_CustomSubstanceUseAssessments_CurrentTreatmentProvider"
                                                                            name='TextBox_CustomSubstanceUseAssessments_CurrentTreatmentProvider" ' style="width: 290px" class="form_textarea"/>--%>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="padding_label1">
                                                                            <textarea id="TextArea_CustomSubstanceUseAssessments_CurrentTreatmentProvider" name="TextArea_CustomSubstanceUseAssessments_CurrentTreatmentProvider"
                                                                                spellcheck="True" datatype="String" rows="2" cols="3" style="width: 380px" class="form_textarea"></textarea>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="padding_label1">
                                                                            <table>
                                                                                <tr>
                                                                                    <td>
                                                                                        <span class="form_label">If current substance use symptoms, referral to SU or co-occuring
                                                                                            Tx?</span>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <tr class="height2">
                                                                        <td colspan="5"></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="padding_label1">
                                                                            <table cellpadding="0" cellspacing="0" width="100%">
                                                                                <tr class="RadioText">
                                                                                    <td class="padding_label1" width="10%">
                                                                                        <input class="cursor_default" type="radio" id="RadioButton_CustomSubstanceUseAssessments_CurrentSubstanceAbuseReferralToSAorTx_Y"
                                                                                            name="RadioButton_CustomSubstanceUseAssessments_CurrentSubstanceAbuseReferralToSAorTx"
                                                                                            value="Y" /><label for="RadioButton_CustomSubstanceUseAssessments_CurrentSubstanceAbuseReferralToSAorTx_Y">Yes</label>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input class="cursor_default" type="radio" id="RadioButton_CustomSubstanceUseAssessments_CurrentSubstanceAbuseReferralToSAorTx_N"
                                                                                            name="RadioButton_CustomSubstanceUseAssessments_CurrentSubstanceAbuseReferralToSAorTx"
                                                                                            value="N" /><label for="RadioButton_CustomSubstanceUseAssessments_CurrentSubstanceAbuseReferralToSAorTx_N">No</label>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <tr class="height2">
                                                                        <td></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="padding_label1">
                                                                            <table>
                                                                                <tr>
                                                                                    <td>
                                                                                        <span class="form_label">If Yes, where referred. If No, provide reason.</span>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="padding_label1">
                                                                            <textarea id="TextArea_CustomSubstanceUseAssessments_CurrentSubstanceAbuseRefferedReason"
                                                                                name="TextArea_CustomSubstanceUseAssessments_CurrentSubstanceAbuseRefferedReason"
                                                                                spellcheck="True" datatype="String" rows="2" cols="3" style="width: 380px" class="form_textarea"></textarea>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height1"></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="padding_label1">
                                                                            <table>
                                                                                <tr>
                                                                                    <td>
                                                                                        <span class="form_label">Is the client interested in medication assisted treatment?</span>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <tr class="height2">
                                                                        <td colspan="5"></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="padding_label1">
                                                                            <table cellpadding="0" cellspacing="0" width="100%">
                                                                                <tr class="RadioText">
                                                                                    <td class="padding_label1" width="10%">
                                                                                        <input class="cursor_default" type="radio" id="RadioButton_CustomSubstanceUseAssessments_MedicationAssistedTreatment_Y"
                                                                                            name="RadioButton_CustomSubstanceUseAssessments_MedicationAssistedTreatment"
                                                                                            value="Y" onchange="enableTextArea(this)" /><label for="RadioButton_CustomSubstanceUseAssessments_MedicationAssistedTreatment_Y">Yes</label>
                                                                                    </td>
                                                                                    <td class="padding_label1" width="10%">
                                                                                        <input class="cursor_default" type="radio" id="RadioButton_CustomSubstanceUseAssessments_MedicationAssistedTreatment_N"
                                                                                            name="RadioButton_CustomSubstanceUseAssessments_MedicationAssistedTreatment"
                                                                                            value="N" onchange="enableTextArea(this)" /><label for="RadioButton_CustomSubstanceUseAssessments_MedicationAssistedTreatment_N">No</label>
                                                                                    </td>
                                                                                    <td class="padding_label1" width="80%">
                                                                                        <input class="cursor_default" type="radio" id="RadioButton_CustomSubstanceUseAssessments_MedicationAssistedTreatment_A"
                                                                                            name="RadioButton_CustomSubstanceUseAssessments_MedicationAssistedTreatment"
                                                                                            value="A" onchange="enableTextArea(this)" /><label for="RadioButton_CustomSubstanceUseAssessments_MedicationAssistedTreatment_A">Not applicable</label>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <tr class="height2">
                                                                        <td></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="padding_label1">
                                                                            <table>
                                                                                <tr>
                                                                                    <td>
                                                                                        <span class="form_label">If Yes, where referred. If No, provide reason.</span>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="padding_label1">
                                                                            <textarea id="TextArea_CustomSubstanceUseAssessments_MedicationAssistedTreatmentRefferedReason"
                                                                                name="TextArea_CustomSubstanceUseAssessments_MedicationAssistedTreatmentRefferedReason"
                                                                                spellcheck="True" datatype="String" rows="2" cols="3" style="width: 380px" class="form_textarea"></textarea>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height1"></td>
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
                                                            <td class="right_bottom_cont_bottom_bg" width="100%"></td>
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
                                    <td style="width: 2%"></td>
                                    <td style="width: 49%">
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr>
                                                <td class="height2"></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                                        <tr>
                                                            <td class="content_tab_left" align="left" nowrap='nowrap'>Risk of Relapse
                                                            </td>
                                                            <td width="17">
                                                                <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif"
                                                                    width="17" height="26" alt="" />
                                                            </td>
                                                            <td class="content_tab_top" width="100%"></td>
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
                                                                <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                                    <tr>
                                                                        <td class="padding_label1">
                                                                            <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                                                <tr class="RadioText">
                                                                                    <td>
                                                                                        <span class="form_label">Indicate factors which would contribute to relapse.</span>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <tr class="height2">
                                                                        <td></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="padding_label1">
                                                                            <textarea id="TextArea_CustomSubstanceUseAssessments_RiskOfRelapse" name="TextArea_CustomSubstanceUseAssessments_RiskOfRelapse"
                                                                                spellcheck="True" datatype="String" rows="13" cols="75" class="form_textareaWithoutWidth"></textarea>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height1"></td>
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
                                                            <td class="right_bottom_cont_bottom_bg" width="100%"></td>
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
                    <tr class="height2">
                        <td></td>
                    </tr>
                    <tr>
                        <td class="padding_label1">
                            <table cellpadding="0" cellspacing="0" border="0">
                                <tr class="checkbox_container">
                                    <td>
                                        <input class="cursor_default" type="checkbox" id="CheckBox_CustomHRMAssessments_SubstanceUseNeedsList"
                                            name="CheckBox_CustomHRMAssessments_SubstanceUseNeedsList"  />
                                        <label for="CheckBox_AddSubstance">
                                            Add Substance Use Issues to Needs List</label>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</div>
