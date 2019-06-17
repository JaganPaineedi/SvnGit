<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ProgressReview.ascx.cs"
    Inherits="Custom_Discharge_WebPages_ProgressReview" %>
<% if (HttpContext.Current == null)
   { %>
<link href="../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet" type="text/css" />
<%} %>
<%@ Register Assembly="Streamline.DotNetDropDownGlobalCodes" Namespace="Streamline.DotNetDropDownGlobalCodes"
    TagPrefix="cc2" %>
<%@ Register Assembly="Streamline.DotNetDropDowns" Namespace="Streamline.DotNetDropDowns"
    TagPrefix="cc3" %>
<%@ Register Assembly="Streamline.DotNetDropDownGlobalCodes" Namespace="Streamline.DotNetDropDownGlobalCodes"
    TagPrefix="DropDownGlobalCodes" %>
<style type="text/css">
    .auto-style1
    {
        color: #000000;
    }
</style>
<div>
    <table border="0" cellpadding="0" cellspacing="0" class="DocumentScreen">
        <tr>
            <td class="height2">
            </td>
        </tr>
        <tr>
            <td>
                <table width="98%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td class="height2">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="content_tab_left" nowrap='nowrap'>
                                        Objective Progress
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
                        <td class="content_tab_bg" style="padding-left: 10px">
                            <table border="0" cellpadding="0" cellspacing="0" width="98%">
                                <tr>
                                    <td>
                                        <%-- <div style="height: 10px">
                                            &nbsp;
                                        </div>--%>
                                        <div id="DivGoals" style="border: solid 1px #b1b1b1; background-color: #f5f5f5; overflow-y: scroll">
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
                <table width="98%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td class="height2">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="content_tab_left" nowrap='nowrap'>
                                        Overall Progress
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
                        <td class="content_tab_bg" style="padding-left: 10px">
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td class="height2">
                                        <tr>
                                            <td valign="top">
                                                Overall progress and movement toward recovery
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height3">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <textarea rows="4" cols="153" id="TextArea_CustomDocumentDischarges_OverallProgress"
                                                    class="form_textareaWithoutWidth element" spellcheck="True">
                                        </textarea>
                                            </td>
                                        </tr>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2">
                                        <tr>
                                            <td valign="top">
                                                Status at last contact
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height3">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <textarea rows="4" cols="153" id="TextArea_CustomDocumentDischarges_StatusLastContact"
                                                    class="form_textareaWithoutWidth element" spellcheck="True">
                                        </textarea>
                                            </td>
                                        </tr>
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
                <table width="98%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td class="height2">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="content_tab_left" nowrap='nowrap'>
                                        Treatment Completion
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
                        <td class="content_tab_bg" style="padding-left: 10px">
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td valign="top" style="width: 20%">
                                        Treatment Completion
                                    </td>
                                    <td>
                                        <cc2:DropDownGlobalCodes ID="DropDownList_CustomDocumentDischarges_TreatmentCompletion"
                                            name="DropDownList_CustomDocumentDischarges_TreatmentCompletion" runat="server"
                                            CssClass="form_dropdown" Width="250px" Category="XTreatmentCompletion" AddBlankRow="true"
                                            BlankRowText="">
                                        </cc2:DropDownGlobalCodes>
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
                <table width="98%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td class="height2">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="content_tab_left" nowrap='nowrap'>
                                       Additional Information
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
                        <td class="content_tab_bg" style="padding-left: 10px">
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td align="left" style="width: 22%" class="auto-style1">
                                        <span id="Span_EducationLevel">Education Level</span>
                                    </td>
                                    <td align="left"  style="width: 23%">
                                       <cc3:StreamlineDropDowns ID="DropDownList_CustomDocumentDischarges_EducationLevel"
                                            Style="width: 75%;" runat="server" EnableViewState="false" AddBlankRow="true" BlankRowText="" BlankRowValue=""
                                            CssClass="form_dropdown">
                                        </cc3:StreamlineDropDowns>
                                    </td>
                                    <td align="left" style="width: 21%" class="auto-style1">
                                        <span id="Span_MaritalStatus">Marital Status</span>
                                    </td>
                                    <td align="left" style="width: 29%">
                                        <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentDischarges_MaritalStatus"
                                            Style="width: 75%;" runat="server" Category="MARITALSTATUS" AddBlankRow="true"
                                            CssClass="form_dropdown">
                                        </DropDownGlobalCodes:DropDownGlobalCodes>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 22%" class="auto-style1">
                                        <span id="Span_EducationStatus">Education Status</span>
                                    </td>
                                    <td align="left">
                                        <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentDischarges_EducationStatus"
                                            Style="width: 75%;" runat="server" Category="XEDUCATIONALSTATUS" AddBlankRow="true"
                                            CssClass="form_dropdown">
                                        </DropDownGlobalCodes:DropDownGlobalCodes>
                                    </td>
                                    <td align="left" style="width: 21%" class="auto-style1">
                                        <span id="Span_EmploymentStatus">Employment Status</span>
                                    </td>
                                    <td align="left" style="width: 29%">
                                        <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentDischarges_EmploymentStatus"
                                            Style="width: 75%;" runat="server" Category="EMPLOYMENTSTATUS" AddBlankRow="true"
                                            CssClass="form_dropdown">
                                        </DropDownGlobalCodes:DropDownGlobalCodes>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 28%" class="auto-style1"><span>Currently enrolled in vocational rehab</span>
                                    </td>
                                    <td align="left">
                                        <table>
                                            <tr>
                                                <td>
                                                    <input style="height: 13px; padding: 0; margin: 0; vertical-align: bottom; position: relative; top: -1px; *overflow: hidden; left: 0px;" type="radio" id="RadioButton_CustomDocumentDischarges_VocationalRehab_Y"
                                                        name="RadioButton_CustomDocumentDischarges_VocationalRehab" value="Y" />
                                                    <label for="RadioButton_CustomDocumentDischarges_VocationalRehab_Y">
                                                        Yes</label>
                                                </td>
                                                <td>
                                                    <input style="height: 13px; padding: 0; margin: 0; vertical-align: bottom; position: relative; top: -1px; *overflow: hidden; left: 0px;" type="radio" id="RadioButton_CustomDocumentDischarges_VocationalRehab_N"
                                                        name="RadioButton_CustomDocumentDischarges_VocationalRehab" value="N" />
                                                    <label for="RadioButton_CustomDocumentDischarges_VocationalRehab_N">
                                                        No</label>
                                                </td>
                                            </tr>
                                        </table>

                                    </td>
                                    <td class="auto-style1"># of Months Employed
                                    </td>
                                    <td align="left" style="width: 29%">
                                        <input class="form_textbox" style="width: 20%; height: 13px;" type="text" datatype="Numeric"
                                            id="TextBox_CustomDocumentDischarges_NumberOfMonthsEmployed" runat="server"
                                            name="TextBox_CustomDocumentDischarges_NumberOfMonthsEmployed" maxlength="5" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 22%" class="auto-style1">
                                        <span id="Span1">School Attendance</span>
                                    </td>
                                    <td align="left">
                                        <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentDischarges_SchoolAttendance"
                                            Style="width: 75%;" runat="server" Category="XSCHOOLATTENDENCE" AddBlankRow="true"
                                            CssClass="form_dropdown">
                                        </DropDownGlobalCodes:DropDownGlobalCodes>
                                    </td>
                                    <td align="left" style="width: 21%" class="auto-style1">
                                        <span id="Span2"># of Employers</span>
                                    </td>
                                    <td align="left" style="width: 29%">
                                        <input class="form_textbox" style="width: 20%; height: 13px;" type="text" datatype="Numeric"
                                            id="TextBox_CustomDocumentDischarges_NumberOfEmployers" runat="server"
                                            name="TextBox_CustomDocumentDischarges_NumberOfEmployers" maxlength="5" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 22%" class="auto-style1">
                                        <span id="Span_ForensicCourtOrderedTreatment">Forensic Court Ordered Treatment</span>
                                    </td>
                                    <td align="left">
                                        <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentDischarges_ForensicCourtOrdered"
                                            Style="width: 75%;" runat="server" Category="XFORENSICTREATMENT" AddBlankRow="true"
                                            CssClass="form_dropdown">
                                        </DropDownGlobalCodes:DropDownGlobalCodes>
                                    </td>
                                    <td align="left" style="width: 21%" class="auto-style1">
                                        <span id="Span_ServingMilitary">Have you ever or are you<br />
                                            currently serving in the military?</span>
                                    </td>
                                    <td align="left" style="width: 29%">
                                        <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentDischarges_CurrentlyServingMilitary"
                                            Style="width: 75%;" runat="server" Category="XMILITARYSERVICE" AddBlankRow="true" CssClass="form_dropdown">
                                        </DropDownGlobalCodes:DropDownGlobalCodes>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 22%" class="auto-style1">
                                        <span id="Span_Legal">Legal</span>
                                    </td>
                                    <td align="left">
                                        <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentDischarges_Legal"
                                            Style="width: 75%;" runat="server" Category="XCDLEGAL" AddBlankRow="true" CssClass="form_dropdown">
                                        </DropDownGlobalCodes:DropDownGlobalCodes>
                                    </td>
                                    <td align="left" style="width: 21%" class="auto-style1">
                                        <span id="Span_JusticeSystemInvolvement">Justice System Involvement</span>
                                    </td>
                                    <td align="left" style="width: 29%">
                                        <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentDischarges_JusticeSystem"
                                            Style="width: 75%;" runat="server" Category="XJUSTICESYSTEMINVOLV" AddBlankRow="true"
                                            CssClass="form_dropdown">
                                        </DropDownGlobalCodes:DropDownGlobalCodes>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 22%" class="auto-style1">
                                        <span id="Span_LivingArrangement">Living Arrangement</span>
                                    </td>
                                    <td align="left">
                                        <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentDischarges_LivingArrangement"
                                            Style="width: 75%;" runat="server" Category="LIVINGARRANGEMENT" AddBlankRow="true"
                                            CssClass="form_dropdown">
                                        </DropDownGlobalCodes:DropDownGlobalCodes>
                                    </td>
                                    <td align="left" style="width: 21%" class="auto-style1">
                                        <span id="Span_ArrestsLast30Days"># of Arrests Last 30 Days</span>
                                    </td>
                                    <td align="left" style="width: 29%">
                                        <input class="form_textbox" style="width: 20%; height: 13px;" type="text" datatype="Numeric"
                                            id="TextBox_CustomDocumentDischarges_Arrests" runat="server"
                                            name="TextBox_CustomDocumentDischarges_Arrests" maxlength="5" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                 <tr>
                                    <td align="left" style="width: 22%" class="auto-style1">
                                        <span id="Span3"># of Days in Stable Housing in Last 90 Days</span>
                                    </td>
                                    <td align="left">
                                        <input class="form_textbox" style="width: 20%; height: 13px;" type="text" datatype="Numeric"
                                            id="TextBox_CustomDocumentDischarges_StableHousing" runat="server"
                                            name="TextBox_CustomDocumentDischarges_StableHousing" maxlength="5" />
                                    </td>
                                    <td align="left" style="width: 21%" class="auto-style1">
                                        <span id="Span4"># of Arrests in Last 12 Months</span>
                                    </td>
                                    <td align="left" style="width: 29%">
                                        <input class="form_textbox" style="width: 20%; height: 13px;" type="text" datatype="Numeric"
                                            id="TextBox_CustomDocumentDischarges_ArrestsInLast12Months" runat="server"
                                            name="TextBox_CustomDocumentDischarges_ArrestsInLast12Months" maxlength="5" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 22%" class="auto-style1">
                                        <span id="Span_AdvanceDirective">Advance Directive</span>
                                    </td>
                                    <td align="left">
                                        <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentDischarges_AdvanceDirective"
                                            Style="width: 75%;" runat="server" Category="XADVANCEDIRECTIVE" AddBlankRow="true"
                                            CssClass="form_dropdown">
                                        </DropDownGlobalCodes:DropDownGlobalCodes>
                                    </td>
                                    <td align="left" style="width: 26%" class="auto-style1">
                                      # of Days Incarcerated in Last 12 Months 
                                    </td>
                                    <td align="left" style="width: 29%">
                                       <input class="form_textbox" style="width: 20%; height: 13px;" type="text" datatype="Numeric"
                                            id="TextBox_CustomDocumentDischarges_IncarceratedInLast12Months" runat="server"
                                            name="TextBox_CustomDocumentDischarges_IncarceratedInLast12Months" maxlength="3" /> 
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td valign="top" align="left" style="width: 22%" class="auto-style1">
                                        <span id="Span_ClientHomeAddress">Client Home Address</span>
                                    </td>
                                    <td align="left">
                                        <span id="Span_Address" runat="server"></span><span id="Span_City" runat="server">
                                        </span><span id="Span_State" runat="server"></span><span id="Span_Zip" runat="server">
                                        </span>
                                    </td>
                                    <td align="left" style="width: 21%" class="auto-style1">
                                         <span id="Span_TobaccoUse">Tobacco Use</span>
                                    </td>
                                    <td align="left" style="width: 29%">
                                        <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentDischarges_TobaccoUse"
                                            Style="width: 75%;" runat="server" Category="XSMOKINGSTATUS" AddBlankRow="true"
                                            CssClass="form_dropdown">
                                        </DropDownGlobalCodes:DropDownGlobalCodes>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 22%" class="auto-style1">
                                        <span id="Span_CountyofResidence">County of Residence</span>
                                    </td>
                                    <td align="left" style="width: 15%">
                                        <cc3:StreamlineDropDowns ID="DropDownList_CustomDocumentDischarges_CountyResidence"
                                            Style="width: 75%;" name="DropDownList_CustomDocumentDischarges_CountyResidence"
                                            runat="server" AddBlankRow="True" BlankRowText="" valuetype="">
                                        </cc3:StreamlineDropDowns>
                                    </td>
                                    <td align="left" style="width: 21%" class="auto-style1">
                                       <span id="Span_AgeofFirstTobaccoUse">Age of First Tobacco Use</span>
                                    </td>
                                    <td align="left" style="width: 28%">
                                       <input class="form_textbox" style="width: 20%; height: 13px;" type="text" datatype="Numeric"
                                            id="TextBox_CustomDocumentDischarges_AgeOfFirstTobaccoUse" runat="server"
                                            name="TextBox_CustomDocumentDischarges_AgeOfFirstTobaccoUse" maxlength="3" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 22%" class="auto-style1">
                                        <span id="Span_CountyofFinancialResponsibility">County of Financial Responsibility</span>
                                    </td>
                                    <td align="left" style="width: 15%">
                                        <cc3:StreamlineDropDowns ID="DropDownList_CustomDocumentDischarges_CountyFinancialResponsibility"
                                            Style="width: 75%;" name="DropDownList_CustomDocumentDischarges_CountyFinancialResponsibility"
                                            runat="server" AddBlankRow="True" BlankRowText="" valuetype="">
                                        </cc3:StreamlineDropDowns>
                                    </td>
                                    <td align="left" style="width: 21%" class="auto-style1">
                                       Gross Annual Household Income
                                    </td>
                                    <td align="left" style="width: 29%">
                                     <input class="form_textbox" style="width: 20%; height: 13px;" type="text" datatype="Decimal"
                                            id="TextBox_CustomDocumentDischarges_GrossAnnualHouseholdIncome" runat="server"
                                            name="TextBox_CustomDocumentDischarges_GrossAnnualHouseholdIncome" maxlength="10" />
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

<script id="goalTmpl" type="text/html">
<table cellpadding="0" cellspacing="0" border="0" width="100%">
    <tr>
        <td>
            <table border="0" cellpadding="0" cellspacing="0" width="98%">
                <tr>
                    <td class="height2">
                    </td>
                </tr>
                <tr>
                    <td>
                        <table cellspacing="0" cellpadding="0" border="0" width="100%">
                            <tr>
                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                    Goal #{{:GoalNumber}}
                                </td>
                                <td width="17">
                                    <img style="vertical-align: top;" height="26" width="17" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                                </td>
                                <td class="content_tab_top" width="100%" />
                                <td width="7">
                                    <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="content_tab_bg" style="padding-left: 7px">
                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                            <tr>
                                <td class="height4">
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 100%; padding-left: 15px">
                                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                        <tr>
                                            <td valign="top" style="width: 13%;">
                                                Long Term Goal:
                                            </td>
                                            <td valign="top" style="width: 87%; padding-right: 10px; word-break: break-all;">
                                                {{:GoalText}}
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 100%">                                    
                                    {{for ShortTermGoals tmpl="#objectiveTmpl"/}}                                    
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
            </table>
        </td>
    </tr>
</table>
</script>

<script id="objectiveTmpl" type="text/html">
<table border="0" cellpadding="0" cellspacing="0" width="100%">
    <tr>
        <td class="height4">
        </td>
    </tr>
    <tr>
        <td style="width: 100%; padding-left: 15px">
            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                <tr>
                    <td valign="top" style="width: 21%; padding-left: 30px">
                        Short Term Goal #{{:ObjectiveNumber}}:
                    </td>
                    <td valign="top" style="width: 79%; padding-right: 10px; word-break: break-all;">
                        {{:ObjectiveText}}
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class="height4">
        </td>
    </tr>
    <tr>
        <td style="width: 100%; padding-left: 55px">
            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                <tr>
                    <td valign="top" style="width: 35%; padding-left: 30px; padding-top: 1px">
                        Rating of progress toward short term goal
                    </td>
                    <td valign="top" align="left" style="width: 65%; padding-right: 10px;">
                        <img style="vertical-align: top;" alt="" title="{{:PreviousProgressTowardsShortGoal}}" src="<%=RelativePath%>App_Themes/Includes/images/info.png" />
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class="height4">
        </td>
    </tr>
    <tr>
        <td style="width: 100%; padding-left: 85px">
            <table width="600px" border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td style="width: 5px">
                        {{if ProgressTowardsShortGoal == 'D'}}
                        <input type="radio" checked="checked" id="radio{{:ObjectiveId}}objectiveD" name="radio{{:ObjectiveId}}objective"
                            onclick="UpdateProgressTowardsShortGoal({{:ObjectiveId}},this,'D')" style="cursor: default"
                            parentchildcontrols='True' bindsetformdata='False' bindautosaveevents="False" />
                        {{else}}
                        <input type="radio" id="radio{{:ObjectiveId}}objectiveD" name="radio{{:ObjectiveId}}objective"
                            onclick="UpdateProgressTowardsShortGoal({{:ObjectiveId}},this,'D')" style="cursor: default"
                            parentchildcontrols='True' bindsetformdata='False' bindautosaveevents="False" />
                        {{/if}}
                    </td>
                    <td align="left" style="width: 85px; padding-left: 2px">
                        <label for="radio{{:ObjectiveId}}objectiveD" style="cursor: default">
                            Deterioration</label>
                    </td>
                    <td style="width: 5px">
                        {{if ProgressTowardsShortGoal == 'N'}}
                        <input type="radio" checked="checked" id="radio{{:ObjectiveId}}objectiveN" name="radio{{:ObjectiveId}}objective"
                            onclick="UpdateProgressTowardsShortGoal({{:ObjectiveId}},this,'N')" style="cursor: default"
                            parentchildcontrols='True' bindsetformdata='False' bindautosaveevents="False" />
                        {{else}}
                        <input type="radio" id="radio{{:ObjectiveId}}objectiveN" name="radio{{:ObjectiveId}}objective"
                            onclick="UpdateProgressTowardsShortGoal({{:ObjectiveId}},this,'N')" style="cursor: default"
                            parentchildcontrols='True' bindsetformdata='False' bindautosaveevents="False" />
                        {{/if}}
                    </td>
                    <td align="left" style="width: 85px; padding-left: 2px">
                        <label for="radio{{:ObjectiveId}}objectiveN" style="cursor: default">
                            No change</label>
                    </td>
                    <td style="width: 5px">
                        {{if ProgressTowardsShortGoal == 'S'}}
                        <input type="radio" checked="checked" id="radio{{:ObjectiveId}}objectiveS" name="radio{{:ObjectiveId}}objective"
                            onclick="UpdateProgressTowardsShortGoal({{:ObjectiveId}},this,'S')" style="cursor: default"
                            parentchildcontrols='True' bindsetformdata='False' bindautosaveevents="False" />
                        {{else}}
                        <input type="radio" id="radio{{:ObjectiveId}}objectiveS" name="radio{{:ObjectiveId}}objective"
                            onclick="UpdateProgressTowardsShortGoal({{:ObjectiveId}},this,'S')" style="cursor: default"
                            parentchildcontrols='True' bindsetformdata='False' bindautosaveevents="False" />
                        {{/if}}
                    </td>
                    <td align="left" style="width: 135px; padding-left: 2px">
                        <label for="radio{{:ObjectiveId}}objectiveS" style="cursor: default">
                            Some improvement</label>
                    </td>
                    <td style="width: 5px">
                        {{if ProgressTowardsShortGoal == 'M'}}
                        <input type="radio" checked="checked" id="radio{{:ObjectiveId}}objectiveM" name="radio{{:ObjectiveId}}objective"
                            onclick="UpdateProgressTowardsShortGoal({{:ObjectiveId}},this,'M')" style="cursor: default"
                            parentchildcontrols='True' bindsetformdata='False' bindautosaveevents="False" />
                        {{else}}
                        <input type="radio" id="radio{{:ObjectiveId}}objectiveM" name="radio{{:ObjectiveId}}objective"
                            onclick="UpdateProgressTowardsShortGoal({{:ObjectiveId}},this,'M')" style="cursor: default"
                            parentchildcontrols='True' bindsetformdata='False' bindautosaveevents="False" />
                        {{/if}}
                    </td>
                    <td align="left" style="width: 155px; padding-left: 2px">
                        <label for="radio{{:ObjectiveId}}objectiveM" style="cursor: default">
                            Moderate improvement</label>
                    </td>
                    <td style="width: 5px">
                        {{if ProgressTowardsShortGoal == 'A'}}
                        <input type="radio" checked="checked" id="radio{{:ObjectiveId}}objectiveA" name="radio{{:ObjectiveId}}objective"
                            onclick="UpdateProgressTowardsShortGoal({{:ObjectiveId}},this,'A')" style="cursor: default"
                            parentchildcontrols='True' bindsetformdata='False' bindautosaveevents="False" />
                        {{else}}
                        <input type="radio" id="radio{{:ObjectiveId}}objectiveA" name="radio{{:ObjectiveId}}objective"
                            onclick="UpdateProgressTowardsShortGoal({{:ObjectiveId}},this,'A')" style="cursor: default"
                            parentchildcontrols='True' bindsetformdata='False' bindautosaveevents="False" />
                        {{/if}}
                    </td>
                    <td align="left" style="width: 115px; padding-left: 2px">
                        <label for="radio{{:ObjectiveId}}objectiveA" style="cursor: default">
                            Achieved
                        </label>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class="height4">
        </td>
    </tr>
    <tr>
        <td style="width: 100%; padding-left: 55px">
            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                <tr>
                    <td valign="top" style="width: 19%; padding-left: 45px; padding-top: 1px">
                        Progress review
                    </td>
                    <td valign="top" align="left" style="width: 81%; padding-right: 10px;">
                        <textarea onchange="UpdateProgressReview({{:ObjectiveId}},this)" class="form_textarea element"
                            cols="100" rows="4" spellcheck="True" style="width: 99%; height: 50px" parentchildcontrols='True'
                            bindsetformdata='False' bindautosaveevents="False">{{:ProgressReview}}</textarea>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</script>

