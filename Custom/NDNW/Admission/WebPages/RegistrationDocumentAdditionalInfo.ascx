<%@ Control Language="C#" AutoEventWireup="true" CodeFile="RegistrationDocumentAdditionalInfo.ascx.cs"
    Inherits="RegistrationDocumentAdditionalInfo" %>
<%@ Register Assembly="Streamline.DotNetDropDowns" Namespace="Streamline.DotNetDropDowns"
    TagPrefix="cc2" %>
<% if (HttpContext.Current == null)
   { %>
<link href="../../../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet"
    type="text/css" />
<%} %>
<div style="overflow-x: hidden;overflow: auto;height:400px;width: 845px" id="divAdditionalInfo">
    <table cellpadding="0" cellspacing="0" border="0" style="width: 833px" class="CrossBrowserAutoFixChrome_width_847px">
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
                                    <td class="content_tab_left" align="left" nowrap='nowrap'>Additional Information
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
                                    <td style="width: 27%;"><span class="form_label" style="padding-top: 2px; padding-left: 10px;">Citizenship</span>
                                    </td>
                                    <td style="width: 16%;">
                                        <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentRegistrations_Citizenship" runat="server"
                                            EnableViewState="false" CssClass="form_dropdown" Width="130px" AddBlankRow="true" BlankRowText="" BlankRowValue="">
                                        </cc2:StreamlineDropDowns>
                                    </td>
                                    <td></td>
                                    <td>Justice System Involvement
                                    </td>
                                    <td style="width: 16%;">
                                        <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentRegistrations_JusticeSystemInvolvement" runat="server"
                                            EnableViewState="false" CssClass="form_dropdown" Width="120px" AddBlankRow="true" BlankRowText="" BlankRowValue="">
                                        </cc2:StreamlineDropDowns>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2"></td>
                                </tr>
                                <tr>
                                    <td><span class="form_label" style="padding-top: 2px; padding-left: 10px;">Birth Place</span>
                                    </td>
                                    <td style="width: 16%;">

                                        <input type="text" name="TextBox_CustomDocumentRegistrations_BirthPlace" class="form_textbox"
                                            id="TextBox_CustomDocumentRegistrations_BirthPlace"
                                            style="width: 123px" />

                                    </td>
                                    <td style="width: 15%;">

                                        <input type="checkbox" id="CheckBox_CustomDocumentRegistrations_BirthCertificate"
                                            name="CheckBox_CustomDocumentRegistrations_BirthCertificate" />
                                        <label for="CheckBox_CustomDocumentRegistrations_BirthCertificate">
                                            Birth Certificate</label>

                                    </td>
                                    <td>Registered Sex Offender
                                    </td>
                                    <td style="width: 16%;">
                                        <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentRegistrations_RegisteredSexOffender" runat="server"
                                            EnableViewState="false" CssClass="form_dropdown" Width="120px" AddBlankRow="true" BlankRowText="" BlankRowValue="">
                                        </cc2:StreamlineDropDowns>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2"></td>
                                </tr>
                                <tr>
                                    <td><span class="form_label" style="padding-top: 2px; padding-left: 10px;">Religion</span>
                                    </td>
                                    <td style="width: 16%;">
                                        <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentRegistrations_Religion" runat="server"
                                            EnableViewState="false" CssClass="form_dropdown" Width="130px" AddBlankRow="true" BlankRowText="" BlankRowValue="">
                                        </cc2:StreamlineDropDowns>
                                    </td>
                                    <td></td>
                                    <td># of Arrests in the last 30 days
                                    </td>
                                    <td style="width: 16%;">

                                        <input type="text" name="TextBox_CustomDocumentRegistrations_NumberOfArrestsLast30Days" class="form_textbox"
                                            id="TextBox_CustomDocumentRegistrations_NumberOfArrestsLast30Days"
                                            style="width: 30px" datatype="Numeric" maxlength="8"/>

                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2"></td>
                                </tr>
                                <tr>
                                    <td><span class="form_label" style="padding-top: 2px; padding-left: 10px;">Forensic court ordered Treatment</span>
                                    </td>
                                    <td style="width: 16%;">
                                        <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentRegistrations_ForensicTreatment" runat="server"
                                            EnableViewState="false" CssClass="form_dropdown" Width="130px" AddBlankRow="true" BlankRowText="" BlankRowValue="">
                                        </cc2:StreamlineDropDowns>
                                    </td>
                                    <td></td>
                                    <td># of Arrests in the last 12 months
                                    </td>

                                    <td style="width: 16%;">

                                        <input type="text" name="TextBox_CustomDocumentRegistrations_NumberOfArrestPast12Months" class="form_textbox"
                                            id="TextBox_CustomDocumentRegistrations_NumberOfArrestPast12Months"
                                            style="width: 30px" datatype="Numeric" maxlength="8"/>

                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2"></td>
                                </tr>
                                <tr>
                                    <td><span class="form_label" style="padding-top: 2px; padding-left: 10px;">Co-Occurring Health Problem</span>
                                    </td>
                                    <td style="width: 16%;">
                                        <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentRegistrations_ScreenForMHSUD" runat="server"
                                            EnableViewState="false" CssClass="form_dropdown" Width="130px" AddBlankRow="true" BlankRowText="" BlankRowValue="">
                                        </cc2:StreamlineDropDowns>
                                    </td>
                                    <td></td>
                                    <td>Tobacco Use
                                    </td>
                                    <td style="width: 16%;">
                                        <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentRegistrations_SmokingStatus" runat="server"
                                            EnableViewState="false" CssClass="form_dropdown" Width="120px" AddBlankRow="true" BlankRowText="" BlankRowValue="">
                                        </cc2:StreamlineDropDowns>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2"></td>
                                </tr>
                                <tr>
                                    <td><span class="form_label" style="padding-top: 2px; padding-left: 10px;">Employment Status</span>
                                    </td>
                                    <td style="width: 16%;">
                                        <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentRegistrations_EmploymentStatus" runat="server"
                                            EnableViewState="false" CssClass="form_dropdown" Width="130px" AddBlankRow="true" BlankRowText="" BlankRowValue="">
                                        </cc2:StreamlineDropDowns>
                                    </td>
                                    <td></td>
                                    <td>Client Type
                                    </td>
                                    <td style="width: 16%;">
                                        <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentRegistrations_ClientType" runat="server"
                                            EnableViewState="false" CssClass="form_dropdown" Width="120px" AddBlankRow="true" BlankRowText="" BlankRowValue="">
                                        </cc2:StreamlineDropDowns>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2"></td>
                                </tr>
                                <tr>
                                    <td><span class="form_label" style="padding-top: 2px; padding-left: 10px;">Education Completed</span>
                                    </td>
                                    <td style="width: 16%;">
                                        <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentRegistrations_EducationalLevel" runat="server"
                                            EnableViewState="false" CssClass="form_dropdown" Width="130px" AddBlankRow="true" BlankRowText="" BlankRowValue="">
                                        </cc2:StreamlineDropDowns>
                                    </td>
                                    <td></td>
                                    <td>Mental Health Advance Directive
                                    </td>
                                    <td style="width: 16%;">
                                        <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentRegistrations_AdvanceDirective" runat="server"
                                            EnableViewState="false" CssClass="form_dropdown" Width="120px" AddBlankRow="true" BlankRowText="" BlankRowValue="">
                                        </cc2:StreamlineDropDowns>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2"></td>
                                </tr>
                                <tr>
                                    <td><span class="form_label" style="padding-top: 2px; padding-left: 10px;">School Attendance</span>
                                    </td>
                                    <td style="width: 16%;">
                                        <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentRegistrations_SchoolAttendance" runat="server"
                                            EnableViewState="false" CssClass="form_dropdown" Width="130px" AddBlankRow="true" BlankRowText="" BlankRowValue="">
                                        </cc2:StreamlineDropDowns>
                                    </td>
                                    <td></td>
                                    <td>SSI/SSD Status
                                    </td>
                                    <td style="width: 16%;">
                                        <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentRegistrations_SSISSDStatus" runat="server"
                                            EnableViewState="false" CssClass="form_dropdown" Width="120px" AddBlankRow="true" BlankRowText="" BlankRowValue="">
                                        </cc2:StreamlineDropDowns>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2"></td>
                                </tr>
                                <tr>
                                    <td><span class="form_label" style="padding-top: 2px; padding-left: 10px;">Education Status</span>
                                    </td>
                                    <td style="width: 16%;">
                                        <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentRegistrations_EducationStatus" runat="server"
                                            EnableViewState="false" CssClass="form_dropdown" Width="130px" AddBlankRow="true" BlankRowText="" BlankRowValue="">
                                        </cc2:StreamlineDropDowns>
                                    </td>
                                    <td></td>
                                    <td>Living Arrangements
                                    </td>
                                    <td style="width: 16%;">
                                        <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentRegistrations_LivingArrangments" runat="server"
                                            EnableViewState="false" CssClass="form_dropdown" Width="120px" AddBlankRow="true" BlankRowText="" BlankRowValue="">
                                        </cc2:StreamlineDropDowns>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2"></td>
                                </tr>
                                <tr>
                                    <td><span class="form_label" style="padding-top: 2px; padding-left: 10px;">Does Client have IEP?</span>
                                    </td>
                                    <td style="width: 16%;">
                                        <table>
                                            <tr>
                                                <td>
                                                    <input style="height: 13px; padding: 0; margin: 0; vertical-align: bottom; position: relative; top: -1px; *overflow: hidden; left: 0px;" type="radio" id="RadioButton_CustomDocumentRegistrations_IEP_Y"
                                                        name="RadioButton_CustomDocumentRegistrations_IEP" value="Y" />
                                                    <label for="RadioButton_CustomDocumentRegistrations_IEP_Y">
                                                        Yes</label>
                                                </td>
                                                <td>
                                                    <input style="height: 13px; padding: 0; margin: 0; vertical-align: bottom; position: relative; top: -1px; *overflow: hidden; left: 0px;" type="radio" id="RadioButton_CustomDocumentRegistrations_IEP_N"
                                                        name="RadioButton_CustomDocumentRegistrations_IEP" value="N" />
                                                    <label for="RadioButton_CustomDocumentRegistrations_IEP_N">
                                                        No</label>
                                                </td>
                                            </tr>
                                        </table>

                                    </td>
                                    <td></td>
                                    <td>Client is registered voter
                                    </td>
                                    <td style="width: 16%;">
                                        <table>
                                            <tr>
                                                <td>
                                                    <input style="height: 13px; padding: 0; margin: 0; vertical-align: bottom; position: relative; top: -1px; *overflow: hidden; left: 0px;" type="radio" id="RadioButton_CustomDocumentRegistrations_RegisteredVoter_Y"
                                                        name="RadioButton_CustomDocumentRegistrations_RegisteredVoter" value="Y" onclick="checkAdditionalInfo();"/>
                                                    <label for="RadioButton_CustomDocumentRegistrations_RegisteredVoter_Y">
                                                        Yes</label>
                                                </td>
                                                <td>
                                                    <input style="height: 13px; padding: 0; margin: 0; vertical-align: bottom; position: relative; top: -1px; *overflow: hidden; left: 0px;" type="radio" id="RadioButton_CustomDocumentRegistrations_RegisteredVoter_N"
                                                        name="RadioButton_CustomDocumentRegistrations_RegisteredVoter" value="N" onclick="checkAdditionalInfo();" />
                                                    <label for="RadioButton_CustomDocumentRegistrations_RegisteredVoter_N">
                                                        No</label>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2"></td>
                                </tr>
                                <tr>
                                    <td><span class="form_label" style="padding-top: 2px; padding-left: 10px;">Have you ever or are you currently &nbsp;&nbsp;&nbsp;serving in the military?</span>
                                    </td>
                                    <td style="width: 16%;">
                                        <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentRegistrations_MilitaryService" runat="server"
                                            EnableViewState="false" CssClass="form_dropdown" Width="130px" AddBlankRow="true" BlankRowText="" BlankRowValue="">
                                        </cc2:StreamlineDropDowns>
                                    </td>
                                    <td></td>
                                    <td>Client has been provided voting information
                                    </td>
                                    <td style="width: 16%;">
                                        <input type="text" name="TextBox_CustomDocumentRegistrations_VotingInformation" class="form_textbox"
                                            id="TextBox_CustomDocumentRegistrations_VotingInformation"
                                            style="width: 114px" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2"></td>
                                </tr>
                                <tr>
                                    <td><span class="form_label" style="padding-top: 2px; padding-left: 10px;">Enrolled in vocational rehab</span>
                                    </td>
                                    <td style="width: 16%;">
                                        <table>
                                            <tr>
                                                <td>
                                                    <input style="height: 13px; padding: 0; margin: 0; vertical-align: bottom; position: relative; top: -1px; *overflow: hidden; left: 0px;" type="radio" id="RadioButton_CustomDocumentRegistrations_VocationalRehab_Y"
                                                        name="RadioButton_CustomDocumentRegistrations_VocationalRehab" value="Y" />
                                                    <label for="RadioButton_CustomDocumentRegistrations_VocationalRehab_Y">
                                                        Yes</label>
                                                </td>
                                                <td>
                                                    <input style="height: 13px; padding: 0; margin: 0; vertical-align: bottom; position: relative; top: -1px; *overflow: hidden; left: 0px;" type="radio" id="RadioButton_CustomDocumentRegistrations_VocationalRehab_N"
                                                        name="RadioButton_CustomDocumentRegistrations_VocationalRehab" value="N" />
                                                    <label for="RadioButton_CustomDocumentRegistrations_VocationalRehab_N">
                                                        No</label>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2"></td>
                                </tr>
                                <tr>
                                    <td colspan="5">
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td style="width: 3%;">
                                                    <span class="form_label" style="padding-top: 2px; padding-left: 10px;">Number of employers in the last 12 months</span>

                                                </td>

                                                <td style="width: 8%;">
                                                    <input type="text" name="TextBox_CustomDocumentRegistrations_NumberOfEmployersLast12Months" class="form_textbox"
                                                        id="TextBox_CustomDocumentRegistrations_NumberOfEmployersLast12Months"
                                                        style="width: 30px" datatype="Numeric" maxlength="8"/>
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
                <table border="0" cellpadding="0" cellspacing="0" width="99%">
                    <tr>
                        <td class="height2"></td>
                    </tr>
                    <tr>
                        <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                <tr>
                                    <td class="content_tab_left" align="left" nowrap='nowrap'>Current Treatment
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
                                                <td style="width: 100%" class="style2" valign="top">
                                                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                        <tr>
                                                            <td width="60%" align="left">
                                                                <span class="form_label" id="Span10">Primary Care Physician</span>
                                                                <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentRegistrations_PrimaryCarePhysician"
                                                                    Width="250px" runat="server" AddBlankRow="True" DataTextField="Name" DataValueField="ExternalReferralProviderId">
                                                                </cc2:StreamlineDropDowns>
                                                                <span id="span_modiyProviderReferral" onclick="ModifyProvider(this)" style="color: blue; cursor: pointer; display: none">Edit Provider...</span>
                                                            </td>
                                                            <td width="10%" align="left">
                                                                <span class="form_label" id="Span3">Organization:</span>
                                                            </td>
                                                            <td width="30%" align="left">
                                                                <span class="form_label" id="Span_CustomDocumentRegistrations_OrganizationName" runat="server"></span>
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td></td>
                                                        </tr>
                                                        <tr class="checkbox_container">
                                                            <td width="60%" align="left">
                                                                <input type="checkbox" id="CheckBox_CustomDocumentRegistrations_ClientWithOutPCP"
                                                                    name="CheckBox_CustomDocumentRegistrations_ClientWithOutPCP" />
                                                                <label for="CheckBox_CustomDocumentRegistrations_ClientWithOutPCP">
                                                                    Client does not have PCP</label>
                                                            </td>
                                                            <td width="10%" align="left">
                                                                <span class="form_label" id="Span5">Phone #:</span>
                                                            </td>
                                                            <td width="30%" align="left">
                                                                <span class="form_label" id="Span_CustomDocumentRegistrations_Phone" runat="server"></span>
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td></td>
                                                        </tr>
                                                        <tr class="checkbox_container">
                                                            <td width="60%" align="left">
                                                                <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentRegistrations_ClientSeenByOtherProvider"
                                                                    name="CheckBox_CustomDocumentRegistrations_ClientSeenByOtherProvider" />
                                                                <label for="CheckBox_CustomDocumentRegistrations_ClientSeenByOtherProvider">
                                                                    Client is being seen by another behavioral health care provider. If so,name and
                                                        contact information</label>
                                                            </td>
                                                            <td width="10%" align="left">
                                                                <span class="form_label" id="Span4">PCP Email:</span>
                                                            </td>
                                                            <td width="30%" align="left">
                                                                <span class="form_label" id="Span_CustomDocumentRegistrations_PCPEmail" runat="server"></span>
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td></td>
                                                        </tr>
                                                    </table>
                                                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                        <tr class="checkbox_container">
                                                            <td width="100%">
                                                                <textarea id="TextArea_CustomDocumentRegistrations_OtherProviders" name="TextArea_CustomDocumentRegistrations_OtherProviders"
                                                                    class="form_textarea" spellcheck="True" style="width: 98%; height: 60px;"></textarea>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2"></td>
                                                        </tr>
                                                        <tr>
                                                            <td width="100%" align="left">
                                                                <span class="form_label" id="Span1">List Other Health Care Providers Currently Treating
                                                        the Client</span>
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td></td>
                                                        </tr>
                                                        <tr class="checkbox_container">
                                                            <td width="100%">
                                                                <textarea id="TextArea_CustomDocumentRegistrations_OtherProvidersCurrentlyTreating" name="TextArea_CustomDocumentRegistrations_OtherProvidersCurrentlyTreating"
                                                                    class="form_textarea" spellcheck="True" style="width: 98%; height: 60px;"></textarea>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2"></td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
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
                                    <td class="content_tab_left" align="left" nowrap='nowrap'>Previous Treatment
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
                                                <td style="width: 100%" class="style2" valign="top">
                                                    <table cellpadding="0" cellspacing="0" border="0">
                                                        <tr>
                                                            <td width="50%" align="left">
                                                                <span class="form_label" id="Span6">Previous Mental Health Services</span>
                                                                <input type="radio" id="RadioButton_CustomDocumentRegistrations_PreviousMentalHealthServices_Y"
                                                                    name="RadioButton_CustomDocumentRegistrations_PreviousMentalHealthServices" value="Y" />
                                                                <label id="spanYes" for="RadioButton_CustomDocumentRegistrations_PreviousMentalHealthServices_Y">
                                                                    Yes</label>
                                                                <input type="radio" id="RadioButton_CustomDocumentRegistrations_PreviousMentalHealthServices_N"
                                                                    name="RadioButton_CustomDocumentRegistrations_PreviousMentalHealthServices" value="N" />
                                                                <label id="spanNo" for="RadioButton_CustomDocumentRegistrations_PreviousMentalHealthServices_N">
                                                                    No</label>
                                                            </td>
                                                            <td width="50%" align="left">
                                                                <span class="form_label" id="Span7">Previous Substance Abuse Services</span>
                                                                <input type="radio" id="RadioButton_CustomDocumentRegistrations_PreviousSubstanceAbuseServices_Y"
                                                                    name="RadioButton_CustomDocumentRegistrations_PreviousSubstanceAbuseServices"
                                                                    value="Y" />
                                                                <label id="Label1" for="RadioButton_CustomDocumentRegistrations_PreviousSubstanceAbuseServices_Y">
                                                                    Yes</label>
                                                                <input type="radio" id="RadioButton_CustomDocumentRegistrations_PreviousSubstanceAbuseServices_N"
                                                                    name="RadioButton_CustomDocumentRegistrations_PreviousSubstanceAbuseServices"
                                                                    value="N" />
                                                                <label id="Label2" for="RadioButton_CustomDocumentRegistrations_PreviousSubstanceAbuseServices_N">
                                                                    No</label>
                                                                <input type="radio" id="RadioButton_CustomDocumentRegistrations_PreviousSubstanceAbuseServices_U"
                                                                    name="RadioButton_CustomDocumentRegistrations_PreviousSubstanceAbuseServices"
                                                                    value="U" />
                                                                <label id="Label3" for="RadioButton_CustomDocumentRegistrations_PreviousSubstanceAbuseServices_U">
                                                                    Unknown</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                        <tr class="height2">
                                                            <td></td>
                                                        </tr>
                                                        <tr class="checkbox_container">
                                                            <td width="100%" align="left">
                                                                <label for="CheckBox_CustomDocumentRegistrations_FamilySAHistory">
                                                                    if 'Yes', please select the type of services the client has received</label>
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td></td>
                                                        </tr>
                                                        <tr class="checkbox_container">
                                                            <td width="10%" align="left">
                                                                <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentRegistrations_VBHService"
                                                                    name="CheckBox_CustomDocumentRegistrations_VBHService" />
                                                                <label for="CheckBox_CustomDocumentRegistrations_VBHService">
                                                                    VBH</label>
                                                                <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentRegistrations_StateHospitalService"
                                                                    name="CheckBox_CustomDocumentRegistrations_StateHospitalService" />
                                                                <label for="CheckBox_CustomDocumentRegistrations_StateHospitalService">
                                                                    State Hospital</label>
                                                                <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentRegistrations_PsychiatricHospitalService"
                                                                    name="CheckBox_CustomDocumentRegistrations_PsychiatricHospitalService" />
                                                                <label for="CheckBox_CustomDocumentRegistrations_PsychiatricHospitalService">
                                                                    Psychiatric Hospital</label>
                                                                <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentRegistrations_GeneralHospitalService"
                                                                    name="CheckBox_CustomDocumentRegistrations_GeneralHospitalService" />
                                                                <label for="CheckBox_CustomDocumentRegistrations_GeneralHospitalService">
                                                                    General Hospital</label>
                                                                <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentRegistrations_OutPatientService"
                                                                    name="CheckBox_CustomDocumentRegistrations_OutPatientService" />
                                                                <label for="CheckBox_CustomDocumentRegistrations_OutPatientService">
                                                                    Outpatient</label>
                                                                <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentRegistrations_ResidentialService"
                                                                    name="CheckBox_CustomDocumentRegistrations_ResidentialService" />
                                                                <label for="CheckBox_CustomDocumentRegistrations_ResidentialService">
                                                                    Residential (Non-Hospital)</label>
                                                                <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentRegistrations_CivilCommitment"
                                                                    name="CheckBox_CustomDocumentRegistrations_CivilCommitment " />
                                                                <label for="CheckBox_CustomDocumentRegistrations_CivilCommitment">
                                                                    Substance Abuse</label>
                                                                <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentRegistrations_SubAbuseOutPatientService"
                                                                    name="CheckBox_CustomDocumentRegistrations_SubAbuseOutPatientService" />
                                                                <label for="CheckBox_CustomDocumentRegistrations_SubAbuseOutPatientService">
                                                                    Civil commitment</label>
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td></td>
                                                        </tr>
                                                    </table>
                                                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                        <tr>
                                                            <td width="100%" align="left">
                                                                <span class="form_label" id="Span15">Comment</span>
                                                            </td>
                                                        </tr>
                                                        <tr class="height2">
                                                            <td></td>
                                                        </tr>
                                                        <tr class="checkbox_container">
                                                            <td width="100%">
                                                                <textarea id="TextArea_CustomDocumentRegistrations_PreviousTreatmentComments" class="form_textarea"
                                                                    spellcheck="True" style="width: 98%; height: 60px;"></textarea>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2"></td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
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
    </table>
</div>
