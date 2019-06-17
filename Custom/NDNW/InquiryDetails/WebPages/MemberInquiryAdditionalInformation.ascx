<%@ Control Language="C#" AutoEventWireup="true" CodeFile="MemberInquiryAdditionalInformation.ascx.cs"
    Inherits="Custom_InquiryDetails_WebPages_MemberInquiryAdditionalInformation" %>
<%@ Register Assembly="Streamline.DotNetDropDownGlobalCodes" Namespace="Streamline.DotNetDropDownGlobalCodes"
    TagPrefix="DropDownGlobalCodes" %>
<%@ Register Assembly="Streamline.DotNetDropDowns" Namespace="Streamline.DotNetDropDowns"
    TagPrefix="DotNetDropDowns" %>
<%@ Register Namespace="SHS.CustomControl" TagPrefix="SHSC" %>
<style type="text/css">
    .style3
    {
        width: 135px;
    }
</style>
<table cellspacing="0" cellpadding="0" border="0" style="width: 830px" id="tblInquiryOtherInfo">
    <tr>
        <td width="100%" align="left" valign="top">
            <table cellspacing="0" cellpadding="0" border="0" width="99%">
                <tr>
                    <td>
                        <table align="right">
                            <tr>
                                <td>
                                    <table cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td>
                                                <div class="glow_lt">
                                                    &nbsp;
                                                </div>
                                            </td>
                                            <td>
                                                <div class="glow_mid">
                                                    <input type="button" id="Button_RegisterMember" value="Admission" class="Button" onclick="return ShowClientSearchForNewRegistration('<%=RelativePath%>    ');" />
                                                </div>
                                            </td>
                                            <td>
                                                <div class="glow_rt">
                                                    &nbsp;
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                                <td>
                                    <table cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td>
                                                <div class="glow_lt">
                                                    &nbsp;
                                                </div>
                                            </td>
                                            <td>
                                                <div class="glow_mid">
                                                    <input type="button" style="width: 120px;" id="Button_LinkOrCreateMember" value="Create Client"
                                                        onclick="return ShowClientSearchForLink('<%=RelativePath%>    ');" />
                                                </div>
                                            </td>
                                            <td>
                                                <div class="glow_rt">
                                                    &nbsp;
                                                </div>
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
                        <table cellspacing="0" cellpadding="0" border="0" width="100%">
                            <tr>
                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                    <span id="Span_LivingArrangement">Other Demographics</span>
                                </td>
                                <td width="17px">
                                    <img style="vertical-align: top;" height="26" width="17px" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                                </td>
                                <td class="content_tab_top" width="100%" style="vertical-align: top;" align="right">
                                    &nbsp;
                                </td>
                                <td width="7">
                                    <img style="vertical-align: top;" height="26" width="17px" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="content_tab_bg" style="padding-right: 8px">
                        <table cellspacing="5" cellpadding="0" border="0">
                            <tr>
                                <td align="left" class="style3">
                                    <span class="form_label" id="Span_Living">Living Arrangment</span>
                                </td>
                                <td align="left">
                                    <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomInquiries_Living"
                                        Width="150px" runat="server" Category="LIVINGARRANGEMENT" AddBlankRow="true"
                                        CssClass="form_dropdown">
                                    </DropDownGlobalCodes:DropDownGlobalCodes>
                                </td>
                            </tr>
                            <tr class="ofbeds">
                                <td align="left" class="style3">
                                    <span class="form_label" id="Span_#ofBeds">County of Residence</span>
                                </td>
                                <td align="left" width="80%">
                                    <DotNetDropDowns:StreamlineDropDowns ID="DropDownList_CustomInquiries_CountyOfResidence"
                                        Width="150px" name="DropDownList_Clients_CountyOfResidence" runat="server" AddBlankRow="True"
                                        BlankRowText="" valuetype="">
                                    </DotNetDropDowns:StreamlineDropDowns>
                                    <%--<DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomInquiries_CountyOfResidence"
                                        Width="150px" runat="server" Category="XINQCOUNTY" AddBlankRow="true" CssClass="form_dropdown">
                                    </DropDownGlobalCodes:DropDownGlobalCodes>--%>
                                </td>
                            </tr>
                            <tr>
                                <td align="left" class="style3">
                                    <span class="form_label" id="Span_CountyofResidence">Legal</span>
                                </td>
                                <td align="left">
                                    <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomInquiries_OtherDemographicsLegal"
                                        Width="150px" runat="server" Category="XCDLEGAL" AddBlankRow="true" CssClass="form_dropdown">
                                    </DropDownGlobalCodes:DropDownGlobalCodes>
                                </td>
                            </tr>
                            <tr>
                                <td align="left" class="style3">
                                    <span class="form_label" id="Span_COFR">Marital Status</span>
                                </td>
                                <td align="left">
                                    <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomInquiries_OtherDemographicsMaritalStatus"
                                        Width="150px" runat="server" Category="MARITALSTATUS" AddBlankRow="true" CssClass="form_dropdown">
                                    </DropDownGlobalCodes:DropDownGlobalCodes>
                                </td>
                            </tr>
                            <tr>
                                <td align="left" class="style3">
                                    <span class="form_label" id="Span5">Employment Status</span>
                                </td>
                                <td align="left">
                                    <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomInquiries_EmploymentStatus"
                                        Width="150px" runat="server" Category="EMPLOYMENTSTATUS" AddBlankRow="true" CssClass="form_dropdown">
                                    </DropDownGlobalCodes:DropDownGlobalCodes>
                                </td>
                            </tr>
                            <tr>
                                <td align="left" class="style3">
                                    <span class="form_label" id="Span_CorrectionStatus">Primary Spoken Language</span>
                                </td>
                                <td align="left">
                                    <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomInquiries_PrimarySpokenLanguage"
                                        Width="150px" runat="server" Category="LANGUAGE" AddBlankRow="true" CssClass="form_dropdown">
                                    </DropDownGlobalCodes:DropDownGlobalCodes>
                                    <span class="form_label" id="Span1">If 'Other', please specify</span>
                                    <input type="text" name="TextBox_CustomInquiries_PrimarySpokenLanguageOther" class="form_textbox"
                                        style="width: 244px" id="TextBox_CustomInquiries_PrimarySpokenLanguageOther" />
                                </td>
                            </tr>
                            <tr>
                                <td align="left" class="style3">
                                    <span class="form_label" id="Span_DHSStatus">Limited English Proficiency</span>
                                </td>
                                <td>
                                    <table cellspacing="0" cellpadding="0" border="0">
                                        <tr>
                                            <td>
                                                <input type="radio" id="RadioButton_CustomInquiries_LimitedEnglishProficiency_Yes"
                                                    name="RadioButton_CustomInquiries_LimitedEnglishProficiency" value="Y" tabindex="11" />
                                            </td>
                                            <td style="padding-left: 5px">
                                                <label for="RadioButton_CustomInquiries_LimitedEnglishProficiency_Yes">
                                                    Yes</label>
                                            </td>
                                            <td style="padding-left: 20px">
                                                <input type="radio" id="RadioButton_CustomInquiries_LimitedEnglishProficiency_No"
                                                    name="RadioButton_CustomInquiries_LimitedEnglishProficiency" tabindex="12" value="N" />
                                            </td>
                                            <td style="padding-left: 5px">
                                                <label for="RadioButton_CustomInquiries_LimitedEnglishProficiency_No">
                                                    No</label>
                                            </td>
                                            <td style="padding-left: 20px">
                                                <input type="radio" id="RadioButton_CustomInquiries_LimitedEnglishProficiency_Unknown"
                                                    name="RadioButton_CustomInquiries_LimitedEnglishProficiency"
                                                    tabindex="13" value="U" />
                                            </td>
                                            <td style="padding-left: 5px">
                                                <label for="RadioButton_CustomInquiries_LimitedEnglishProficiency_Unknown">
                                                    Unknown</label>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                             <tr>
                                <td align="left" class="style3">
                                    <span class="form_label" id="Span7">Race</span>
                                </td>
                                <td align="left">
                                    <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomInquiries_Race"
                                        Width="150px" runat="server" Category="XRACE" AddBlankRow="true" CssClass="form_dropdown">
                                    </DropDownGlobalCodes:DropDownGlobalCodes>
                                </td>
                            </tr>
                             <tr>
                                <td align="left" class="style3">
                                    <span class="form_label" id="Span8">Ethnicity</span>
                                </td>
                                <td align="left">
                                    <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomInquiries_Ethnicity"
                                        Width="150px" runat="server" Category="XETHNICITY" AddBlankRow="true" CssClass="form_dropdown">
                                    </DropDownGlobalCodes:DropDownGlobalCodes>
                                </td>
                            </tr>
                             <tr>
                                <td align="left" class="style3">
                                    <span class="form_label" id="Span9">Interpreter Needed</span>
                                </td>
                                <td align="left">
                                    <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomInquiries_InterpreterNeeded"
                                        Width="150px" runat="server" Category="XINTERPRETERNEEDED" AddBlankRow="true" CssClass="form_dropdown">
                                    </DropDownGlobalCodes:DropDownGlobalCodes>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <span class="form_label" id="Span_AccomodationNeeded">Accommodation Needed</span>
                                </td>
                                <td>
                                    <table cellspacing="0" cellpadding="0" border="0">
                                        <tr>
                                            <td>
                                                <input type="checkbox" id="CheckBox_CustomInquiries_AccomodationNeeded_0" name="CheckBox_CustomInquiries_AccomodationNeeded"
                                                    value="0" bindautosaveevents="False" />
                                            </td>
                                            <td style="padding-left: 5px">
                                                <label for="CheckBox_CustomInquiries_AccomodationNeeded_0">
                                                    Interpreter</label>
                                            </td>
                                            <td style="padding-left: 20px">
                                                <input type="checkbox" id="CheckBox_CustomInquiries_AccomodationNeeded_1" name="CheckBox_CustomInquiries_AccomodationNeeded"
                                                    value="1" bindautosaveevents="False" />
                                            </td>
                                            <td style="padding-left: 5px">
                                                <label for="CheckBox_CustomInquiries_AccomodationNeeded_1">
                                                    Reading Assistance</label>
                                            </td>
                                            <td style="padding-left: 20px">
                                                <input type="checkbox" id="CheckBox_CustomInquiries_AccomodationNeeded_2" name="CheckBox_CustomInquiries_AccomodationNeeded"
                                                    value="2" bindautosaveevents="False" />
                                                <input type="hidden" id="HiddenField_CustomInquiries_AccomodationNeeded" />
                                            </td>
                                            <td style="padding-left: 5px">
                                                <label for="CheckBox_CustomInquiries_AccomodationNeeded_2">
                                                    Sign Language</label>
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
                                <td width="1%" class="right_bottom_cont_bottom_bg">
                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                                        height="7" alt="" />
                                </td>
                                <td class="right_bottom_cont_bottom_bg" width="98%">
                                </td>
                                <td width="1%" class="right_bottom_cont_bottom_bg" align="right">
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
        <td colspan="2">
        </td>
    </tr>
    <tr>
        <td width="100%" align="left" style="padding-top: 10px" valign="top">
            <table cellspacing="0" cellpadding="0" border="0" width="99%">
                <tr>
                    <td>
                        <table cellspacing="0" cellpadding="0" border="0" width="100%">
                            <tr>
                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                    <span id="Span2">Education</span>
                                </td>
                                <td width="17px">
                                    <img style="vertical-align: top;" height="26" width="17px" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                                </td>
                                <td class="content_tab_top" width="100%">
                                </td>
                                <td width="7">
                                    <img style="vertical-align: top;" height="26" width="17px" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="content_tab_bg" style="padding-right: 8px">
                        <table cellspacing="5" cellpadding="0" border="0">
                            <tr>
                                <td align="left" style="width: 10%">
                                    <span class="form_label" id="Span3">School Name</span>
                                </td>
                                <td align="left">
                                    <input type="text" name="TextBox_CustomInquiries_SchoolName" class="form_textbox"
                                        style="width: 244px" id="TextBox_CustomInquiries_SchoolName" />
                                </td>
                            </tr>
                            <tr class="ofbeds">
                                <td align="left" style="width: 10%">
                                    <span class="form_label" id="Span4">School District</span>
                                </td>
                                <td align="left" width="80%">
                                    <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomInquiries_SchoolDistric"
                                        Width="150px" runat="server" Category="XINQSDICT" AddBlankRow="true" CssClass="form_dropdown">
                                    </DropDownGlobalCodes:DropDownGlobalCodes>
                                </td>
                            </tr>
                            <tr>
                                <td align="left" style="width: 10%">
                                    <span class="form_label" id="Span6">Education</span>
                                </td>
                                <td align="left">
                                    <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomInquiries_Education"
                                        Width="150px" runat="server" Category="EDUCATIONALSTATUS" AddBlankRow="true"
                                        CssClass="form_dropdown">
                                    </DropDownGlobalCodes:DropDownGlobalCodes>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td width="1%" class="right_bottom_cont_bottom_bg">
                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                                        height="7" alt="" />
                                </td>
                                <td class="right_bottom_cont_bottom_bg" width="98%">
                                </td>
                                <td width="1%" class="right_bottom_cont_bottom_bg" align="right">
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
<input type="hidden" id="HiddenField_CustomInquiries_InquiryId" name="HiddenField_CustomInquiries_InquiryId" />