<%@ Control Language="C#" AutoEventWireup="true" CodeFile="HRMInitial.ascx.cs" Inherits="SHS.SmartCare.ActivityPages_Client_Detail_Assessment_HRMInitial" %>

<% if (HttpContext.Current == null)
   { %>
<link href="../../../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet"
    type="text/css" />
<%} %>
<div style="overflow-x: hidden; overflow: auto;">
    <table border="0" cellpadding="0" cellspacing="0" class="DocumentScreen">
        <tr>
            <td>
                <table border="0" cellpadding="0" cellspacing="0" width="99%">
                    <tr>
                        <td class="height1"></td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <table cellpadding="0" cellspacing="0" width="100%" border="0">
                                <tr>
                                    <td colspan="3" class="height2"></td>
                                </tr>
                                <tr>
                                    <td colspan="3">
                                        <table cellpadding="0" cellspacing="0" width="100%" border="0">
                                            <tr>
                                                <td>
                                                    <table cellpadding="0" cellspacing="0" width="100%" border="0">
                                                        <tr>
                                                            <td style="width: 90px; padding-left: 8px;" align="left" valign="middle">
                                                                <span id="span_AssessmentDate" class="form_label">Assessment Date</span>
                                                            </td>
                                                            <td align="left">
                                                                <table cellpadding="0" cellspacing="0" width="100%" border="0">
                                                                    <tr>
                                                                        <td style="width: 36%">
                                                                            <input type="text" id="TextBox_CustomHRMAssessments_CurrentAssessmentDate" name="TextBox_CustomHRMAssessments_CurrentAssessmentDate"
                                                                                datatype="Date" tabindex="1" class="date_text" align="top" />
                                                                        </td>
                                                                        <td style="padding: 2px;">
                                                                            <img style="cursor: default" id="imgCurrentAssessmentDate" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                                onclick="return showCalendar('TextBox_CustomHRMAssessments_CurrentAssessmentDate', '%m/%d/%Y');"
                                                                                alt="" class="cursor_default" />
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td>
                                                    <table cellpadding="0" cellspacing="0" width="100%" border="0">
                                                        <tr>
                                                            <td style="width: 150px"></td>
                                                            <td align="left">
                                                                <span style="padding-left: 21px;" class="form_label">Inquiry date</span>
                                                                <input type="text" id="TextBox_CustomHRMAssessments_InitialRequestDate" name="TextBox_CustomHRMAssessments_InitialRequestDate"
                                                                    datatype="Date" class="date_text" disabled="disabled" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="2" class="height4"></td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="3" class="padding_label1">
                                        <table cellpadding="0" cellspacing="0" width="100%" border="0">
                                            <tr>
                                                <td style="width: 50%" align="left">
                                                    <table cellpadding="0" cellspacing="0" border="0">
                                                        <tr id="TrCustomHRMAssessmentAssessmentType">
                                                            <td colspan="8">
                                                                <table cellpadding="0" cellspacing="0" border="0">
                                                                    <tr class="checkbox_container">
                                                                        <%-- <td>
                                                                            <input type="radio" id="RadioButton_CustomHRMAssessments_AssessmentType_S" name="RadioButton_CustomHRMAssessments_AssessmentType"
                                                                                tabindex="5" class="cursor_default" value="S" required="true" onclick="ReInitializeAssessment(this.id)" />
                                                                        </td>
                                                                        <td style="padding-left: 2px;" align="left" class="RadioText">
                                                                            <label for="RadioButton_CustomHRMAssessments_AssessmentType_S">
                                                                                Screen</label>
                                                                        </td>--%>
                                                                        <td style="padding-left: 0px;">
                                                                            <input type="radio" id="RadioButton_CustomHRMAssessments_AssessmentType_I" onclick="ReInitializeAssessment(this.id)"
                                                                                name="RadioButton_CustomHRMAssessments_AssessmentType" tabindex="2" value="I"
                                                                                required="true" class="cursor_default" />
                                                                        </td>
                                                                        <td style="padding-left: 0px;" align="left" class="RadioText">
                                                                            <label for="RadioButton_CustomHRMAssessments_AssessmentType_I">
                                                                                Initial</label>
                                                                        </td>
                                                                        <td id="TdAssessmentTypeUpdate" style="padding-left: 6px;">
                                                                            <input type="radio" id="RadioButton_CustomHRMAssessments_AssessmentType_U" name="RadioButton_CustomHRMAssessments_AssessmentType"
                                                                                onclick="ReInitializeAssessment(this.id)" tabindex="3" class="cursor_default"
                                                                                value="U" required="true" />
                                                                        </td>
                                                                        <td id="TdAssessmentTypeLabelUpdate" style="padding-left: 2px;" align="left" class="RadioText">
                                                                            <label for="RadioButton_CustomHRMAssessments_AssessmentType_U">
                                                                                Update</label>
                                                                        </td>
                                                                        <td id="TdAssessmentTypeAnnual" style="padding-left: 6px;">
                                                                            <input type="radio" id="RadioButton_CustomHRMAssessments_AssessmentType_A" name="RadioButton_CustomHRMAssessments_AssessmentType"
                                                                                onclick="ReInitializeAssessment(this.id)" tabindex="4" class="cursor_default"
                                                                                value="A" required="true" />
                                                                        </td>
                                                                        <td id="TdAssessmentTypeLabelAnnual" style="padding-left: 2px;" align="left" class="RadioText">
                                                                            <label for="RadioButton_CustomHRMAssessments_AssessmentType_A">
                                                                                Annual</label>
                                                                        </td>

                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="8" class="height4"></td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="8">
                                                                <table cellpadding="0" cellspacing="0" border="0">
                                                                    <tr class="checkbox_container">
                                                                        <td>
                                                                            <input type="radio" id="RadioButton_CustomHRMAssessments_AdultOrChild_A" class="cursor_default"
                                                                                value="A" name="RadioButton_CustomHRMAssessments_AdultOrChild" onclick="ShowHideAdultChildTabsEvent();"
                                                                                tabindex="6" class="cursor_default" />
                                                                        </td>
                                                                        <td style="padding-left: 0px;" align="left" class="RadioText">
                                                                            <label for="RadioButton_CustomHRMAssessments_AdultOrChild_A">
                                                                                Adult</label>
                                                                        </td>
                                                                        <td style="padding-left: 7px;">
                                                                            <input type="radio" id="RadioButton_CustomHRMAssessments_AdultOrChild_C" name="RadioButton_CustomHRMAssessments_AdultOrChild"
                                                                                tabindex="7" value="C" class="cursor_default" onclick="ShowHideAdultChildTabsEvent();" />
                                                                        </td>
                                                                        <td style="padding-left: 2px;" class="RadioText" align="left">
                                                                            <label for="RadioButton_CustomHRMAssessments_AdultOrChild_C">
                                                                                Child</label>
                                                                        </td>
                                                                        <td colspan="4" style="padding-left: 4px;" class="RadioText" align="left" nowrap="nowrap">
                                                                            <span id="Span_ClientDOB" class="form_label">( Date of Birth = </span><span id="Span_CustomHRMAssessments_ClientDOB"
                                                                                name="Span_CustomHRMAssessments_ClientDOB" datatype="Date"></span>;<span id="Span_ClientAge">
                                                                                    Age = </span><span id="Span_CustomHRMAssessments_clientAge" name="Span_CustomHRMAssessments_clientAge"></span><span class="form_label">)</span>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="8" class="height4"></td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="0" align="left">
                                                                <table cellspacing="0" cellpadding="0" border="0">
                                                                    <tr>
                                                                        <td>
                                                                            <input type="checkbox" id="CheckBox_CustomHRMAssessments_ClientHasGuardian" name="CheckBox_CustomHRMAssessments_ClientHasGuardian"
                                                                                tabindex="11" class="cursor_default" onclick="OpenGuardianInfoPopUp(<%=RelativePath%>);" />
                                                                        </td>
                                                                        <td style="padding-left: 2px;" class="checkbox_container">
                                                                            <label for="CheckBox_CustomHRMAssessments_ClientHasGuardian">
                                                                                Does the client have a guardian?</label>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td align="right" colspan="7">
                                                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                                    <tr>
                                                                        <td style="padding-left: 0px;" align="left">
                                                                            <input type="button" tabindex="12" id="ButtonEditGuardian" name="ButtonEditGuardian" value="Edit..."
                                                                                class="less_detail_btn" onclick="OpenGuardianInfoPopUp(<%=RelativePath%>);" />
                                                                            <%--<span valign="top" type="button" style="width: 30px;" disabled="disabled" id="ButtonEditGuardian"
                                                                                onclick="OpenGuardianInfoPopUp(<%=RelativePath%>);" name="ButtonEditGuardian"
                                                                                text="    Edit    "></span>--%>
                                                                        </td>
                                                                        <td></td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="8" class="height2"></td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="8">
                                                                <textarea id="TextArea_CustomHRMAssessments_GuardianAddressToDisplayOnly" name="TextArea__CustomHRMAssessments_GuardianAddressToDisplayOnly"
                                                                    cols="62" rows="4" readonly="readonly" datatype="String"
                                                                    class="form_textareaWithoutWidth"></textarea>
                                                                <asp:HiddenField ID="HiddenAddress" runat="server" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td style="width: 50%" valign="top">
                                                    <table cellpadding="0" cellspacing="0" width="100%" border="0">
                                                        <tr>
                                                            <td style="width: 22%" align="left">
                                                                <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                                    <tr>
                                                                        <td style="width: 58%" align="left"></td>
                                                                        <td style="width: 10%" align="left" valign="top" class="cursor_default">
                                                                            <input type="checkbox" id="CheckBox_CustomHRMAssessments_ClientInDDPopulation" name="CheckBox_CustomHRMAssessments_ClientInDDPopulation"
                                                                                tabindex="8" onclick="javascript:SetTabsType();" />
                                                                        </td>
                                                                        <td style="width: 32%; padding-left: 4px;" align="left" class="checkbox_container">
                                                                            <label for="CheckBox_CustomHRMAssessments_ClientInDDPopulation">
                                                                                DD</label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr style="height: 4px">
                                                                    </tr>
                                                                    <tr>
                                                                        <td align="left"></td>
                                                                        <td align="left" class="cursor_default">
                                                                            <input type="checkbox" id="CheckBox_CustomHRMAssessments_ClientInSAPopulation" name="CheckBox_CustomHRMAssessments_ClientInSAPopulation"
                                                                                tabindex="9" onclick="javascript:SetTabsType();" />
                                                                        </td>
                                                                        <td align="left" style="width: 32%; padding-left: 4px;" class="checkbox_container">
                                                                            <label for="CheckBox_CustomHRMAssessments_ClientInSAPopulation">
                                                                                SUD</label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr style="height: 4px">
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="width: 10%" align="left"></td>
                                                                        <td align="left" class="cursor_default">
                                                                            <input type="checkbox" id="CheckBox_CustomHRMAssessments_ClientInMHPopulation" name="CheckBox_CustomHRMAssessments_ClientInMHPopulation"
                                                                                tabindex="10" onclick="javascript:SetTabsType();" />
                                                                        </td>
                                                                        <td style="width: 32%; padding-left: 4px;" align="left" class="checkbox_container">
                                                                            <label for="CheckBox_CustomHRMAssessments_ClientInMHPopulation">
                                                                                MH</label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr style="height: 4px">
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="width: 10%" align="left"></td>
                                                                        <td align="left" class="cursor_default">
                                                                            <input type="checkbox" id="CheckBox_CustomHRMAssessments_ClientInAutsimPopulation" name="CheckBox_CustomHRMAssessments_ClientInAutsimPopulation"
                                                                                tabindex="10" onclick="javascript:SetTabsType();" />
                                                                        </td>
                                                                        <td style="width: 32%; padding-left: 4px; padding-right: 5px;" align="left" class="checkbox_container">
                                                                            <label for="CheckBox_CustomHRMAssessments_ClientInAutsimPopulation">
                                                                                Gambling</label>
                                                                        </td>
                                                                </table>
                                                            </td>
                                                            <td style="width: 80%" valign="top">
                                                                <textarea id="TextArea_CustomHRMAssessments_PreviousDiagnosisText" name="TextArea_CustomHRMAssessments_PreviousDiagnosisText"
                                                                    readonly="readonly" cols="56" rows="5" datatype="String" class="form_textareaWithoutWidth"></textarea>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2" class="height2">&nbsp;
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2" class="height2">&nbsp;
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <table cellpadding="0" cellspacing="0" width="100%" border="0">
                                                                    <tr>
                                                                        <td nowrap="nowrap" style="width: 12%" align="left"></td>
                                                                        <td style="width: 88%" align="left">
                                                                            <span class="form_label">Referral Source</span> &nbsp;&nbsp;
                                                                            <asp:DropDownList CssClass="form_dropdown" ID="DropDownList_CustomHRMAssessments_ReferralType"
                                                                                runat="server" TabIndex="13" Width="55%">
                                                                            </asp:DropDownList>
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
                                    <td colspan="3" class="height2"></td>
                                </tr>
                                <tr>
                                    <td colspan="3">
                                        <table cellpadding="0" cellspacing="0" width="100%" border="0">
                                            <tr>
                                                <td style="width: 22%; padding-left: 4px;" align="left" class="padding_label1">
                                                    <span class="form_label">Current Living Arrangement</span>
                                                </td>
                                                <td style="width: 78%" align="left">
                                                    <asp:DropDownList CssClass="form_dropdown" ID="DropDownList_CustomHRMAssessments_CurrentLivingArrangement"
                                                        runat="server" TabIndex="14" Width="630px">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr style="width: 2px">
                                                <td colspan="2">&nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="width: 22%; padding-left: 4px;" align="left" class="padding_label1">
                                                    <span class="form_label">Current Employment Status</span>
                                                </td>
                                                <td style="width: 78%" align="left">
                                                    <asp:DropDownList CssClass="form_dropdown" ID="DropDownList_CustomHRMAssessments_EmploymentStatus" runat="server"
                                                        TabIndex="15" Width="630px">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr style="width: 2px">
                                                <td colspan="2">&nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="left" style="padding-left: 4px;" class="padding_label1">
                                                    <span class="form_label">Current Primary Care Physician</span>
                                                </td>
                                                <td align="left">
                                                    <input type="text" class="form_textbox" id="TextBox_CustomHRMAssessments_CurrentPrimaryCarePhysician"
                                                        name="TextBox_CustomHRMAssessments_CurrentPrimaryCarePhysician" style="width: 97%;"
                                                        tabindex="16" datatype="String" maxlength="50" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="2">&nbsp;
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td id="ReasonforUpdate" colspan="2" class="padding_label1">
                            <table border="0" cellspacing="0" cellpadding="0" width="98%">
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                    <span id="SpanReasonforUpdate" class="form_label">Reason for Update</span>
                                                </td>
                                                <td width="17">
                                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif"
                                                        width="17" height="26" alt="" />
                                                </td>
                                                <td class="content_tab_top" width="70%"></td>
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
                                                <td class="height2"></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <table cellpadding="0" cellspacing="0" width="100%" border="0">
                                                        <tr>
                                                            <td class="padding_label1">
                                                                <textarea id="TextArea_CustomHRMAssessments_ReasonForUpdate" cols="155" rows="4" tabindex="17" spellcheck="True" class="form_textareaWithoutWidth"></textarea>
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
                        <td colspan="2" class="height2"></td>
                    </tr>
                    <tr>
                        <td id="SummaryOfProgress" colspan="2" class="padding_label1">
                            <table border="0" cellspacing="0" cellpadding="0" width="98%">
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                    <span id="SpanSummaryOfProgress" class="form_label">Summary of Progress</span>
                                                </td>
                                                <td width="17">
                                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif"
                                                        width="17" height="26" alt="" />
                                                </td>
                                                <td class="content_tab_top" width="70%"></td>
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
                                                <td class="height2"></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <table cellpadding="0" cellspacing="0" width="100%" border="0">
                                                        <tr>
                                                            <td class="padding_label1">
                                                                <textarea id="TextArea_CustomHRMAssessments_ReasonForUpdate" cols="155" rows="4" tabindex="17" spellcheck="True" class="form_textareaWithoutWidth"></textarea>
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
                        <td colspan="2" class="height2"></td>
                    </tr>
                    <tr>
                        <td colspan="2" class="padding_label1">
                            <table border="0" cellspacing="0" cellpadding="0" width="98%">
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap='nowrap'>Presenting Problem
                                                </td>
                                                <td width="17">
                                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif"
                                                        width="17" height="26" alt="" />
                                                </td>
                                                <td class="content_tab_top" width="70%"></td>
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
                                                <td class="height2"></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <table cellpadding="0" cellspacing="0" width="100%" border="0">
                                                        <tr>
                                                            <td class="padding_label1">
                                                                <textarea id="TextArea_CustomHRMAssessments_PresentingProblem"
                                                                    cols="155" rows="4" tabindex="17" spellcheck="True" class="form_textareaWithoutWidth"></textarea>
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
                        <td colspan="2" class="height2"></td>
                    </tr>
                    <tr>
                        <td colspan="2" class="padding_label1">
                            <table border="0" cellspacing="0" cellpadding="0" width="98%">
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap='nowrap'>Presence or Absence of Relevant Legal Issues of the Client and/or Family
                                                </td>
                                                <td width="17">
                                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif"
                                                        width="17" height="26" alt="" />
                                                </td>
                                                <td class="content_tab_top" width="70%"></td>
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
                                                <td class="height2"></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <table cellpadding="0" cellspacing="0" width="100%" border="0">
                                                        <tr>
                                                            <td class="padding_label1">
                                                                <textarea id="TextArea_CustomHRMAssessments_LegalIssues" cols="155" rows="4" tabindex="17" spellcheck="True" class="form_textareaWithoutWidth"></textarea>
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
                        <td colspan="2" class="height2"></td>
                    </tr>
                    <%--<tr>
                        <td id="SummaryOfProgress" class="padding_label1" width="50%">
                            <table cellpadding="0" cellspacing="0" width="100%" border="0">
                                <tr>
                                    <td class="height1">
                                        <span class="form_label"></span>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <span id="SpanSummaryOfProgress" class="form_label">Summary of Progress</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left">
                                        <textarea id="TextArea_CustomHRMAssessments_ReasonForUpdate" name="TextArea_CustomHRMAssessments_ReasonForUpdate"
                                             tabindex="18" rows="4" cols="60" spellcheck="True" class="form_textareaWithoutWidth"></textarea>
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td class="padding_label1" width="50%">
                            <table cellpadding="0" cellspacing="0" width="100%" border="0">
                                <tr>
                                    <td>
                                        <table cellpadding="0" cellspacing="0" width="350px" border="0">
                                            <tr>
                                                <td>
                                                    <span class="form_label_dfa">Desired outcomes of service (hopes and dreams) as specified
                                                        by the person/guardian</span>
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
                                    <td align="left">
                                        <textarea id="TextArea_CustomHRMAssessments_DesiredOutcomes" name="TextArea_CustomHRMAssessments_DesiredOutcomes"
                                             tabindex="19" rows="4" cols="60" spellcheck="True" class="form_textareaWithoutWidth"></textarea>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>--%>
                    <tr>
                        <td colspan="2" class="padding_label1">
                            <table border="0" cellspacing="0" cellpadding="0" width="98%">
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap='nowrap'>Desired Outcomes of Service (Hopes and Dreams) As Specified By The Person/Guardian
                                                </td>
                                                <td width="17">
                                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif"
                                                        width="17" height="26" alt="" />
                                                </td>
                                                <td class="content_tab_top" width="70%"></td>
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
                                                <td class="height2"></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <table cellpadding="0" cellspacing="0" width="100%" border="0">
                                                        <tr>
                                                            <td class="padding_label1">
                                                                <textarea id="TextArea_CustomHRMAssessments_DesiredOutcomes" name="TextArea_CustomHRMAssessments_DesiredOutcomes"
                                                                    tabindex="19" rows="4" cols="155" spellcheck="True" class="form_textareaWithoutWidth"></textarea>
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
                        <td colspan="2" class="height2"></td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</div>
