<%@ Control Language="C#" AutoEventWireup="true" CodeFile="MemberInquiryDetailGeneral.ascx.cs"
    Inherits="Custom_InquiryDetails_WebPages_MemberInquiryDetailGeneral" %>
<%@ Register Namespace="SHS.CustomControl" TagPrefix="SHSC" %>
<%@ Register Assembly="Streamline.DotNetDropDownGlobalCodes" Namespace="Streamline.DotNetDropDownGlobalCodes"
    TagPrefix="DropDownGlobalCodes" %>
<%@ Register Assembly="Streamline.DotNetDropDowns" Namespace="Streamline.DotNetDropDowns"
    TagPrefix="DotNetDropDowns" %>
<%@ Register Src="~/CommonUserControls/VerifyEligibility.ascx" TagName="VerifyEligibility"
    TagPrefix="uc1" %>
<asp:Panel ID="PanelMain" runat="server">
    <table cellspacing="0" cellpadding="0" border="0" style="width: 830px" id="tblCustomInquiryMain">
        <tr>
            <td>
                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                    <tr>
                        <td class="content_tab_left" align="left" nowrap='nowrap'>
                            <span id="Label_General">Inquirer Information</span>
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
                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                    <tr>
                        <td>
                            <table cellspacing="5" cellpadding="0" border="0">
                                <tr>
                                    <td align="left" style="white-space: nowrap">
                                        <span class="form_label" id="Span_InquirerRelationToMember">Relation To Client</span>
                                    </td>
                                    <td align="left">
                                        <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomInquiries_InquirerRelationToMember"
                                            Width="150px" runat="server" Category="RELATIONSHIP" AddBlankRow="true" CssClass="form_dropdown">
                                        </DropDownGlobalCodes:DropDownGlobalCodes>
                                    </td>
                                    <td align="left" style="white-space: nowrap">
                                        <span class="form_label" id="Span_InquirerFirstName">First Name</span>
                                    </td>
                                    <td align="left">
                                        <input type="text" name="TextBox_CustomInquiries_InquirerFirstName" class="form_textbox"
                                            id="TextBox_CustomInquiries_InquirerFirstName" maxlength="20" style="width: 110px" />
                                    </td>
                                    <td align="left" style="white-space: nowrap">
                                        <span class="form_label" id="Span_InquirerMiddleName">Middle Name</span>
                                    </td>
                                    <td align="left">
                                        <input id="TextBox_CustomInquiries_InquirerMiddleName" name="TextBox_CustomInquiries_InquirerMiddleName"
                                            type="text" class="form_textbox" maxlength="20" style="width: 110px" />
                                    </td>
                                    <td align="left" style="white-space: nowrap">
                                        <span class="form_label" id="Span_InquirerLastName">Last Name</span>
                                    </td>
                                    <td align="left">
                                        <input id="TextBox_CustomInquiries_InquirerLastName" name="TextBox_CustomInquiries_InquirerLastName"
                                            type="text" class="form_textbox" maxlength="30" style="width: 110px" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" style="white-space: nowrap">
                                        <span class="form_label" id="Span7">Call Back</span>
                                    </td>
                                    <td align="left">
                                        <input type="text" name="TextBox_CustomInquiries_InquirerPhone" class="form_textbox"
                                            id="TextBox_CustomInquiries_InquirerPhone" datatype="PhoneNumber" maxlength="15"
                                            style="width: 144px" />
                                    </td>
                                    <td align="left">
                                        <span class="form_label" id="Span_InquirerPhoneExtension">Ext</span>
                                    </td>
                                    <td align="left">
                                        <input id="TextBox_CustomInquiries_InquirerPhoneExtension" name="TextBox_CustomInquiries_InquirerPhoneExtension"
                                            type="text" class="form_textbox" datatype="Numeric" maxlength="10" style="width: 110px" />
                                    </td>
                                    <td align="left">
                                        <span class="form_label" id="Span_InquirerEmail">Email</span>
                                    </td>
                                    <td align="left" colspan="3">
                                        <input id="TextBox_CustomInquiries_InquirerEmail" name="TextBox_CustomInquiries_InquirerEmail"
                                            type="text" class="form_textbox" datatype="Email" maxlength="100" style="width: 200px" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" style="white-space: nowrap">
                                        <span class="form_label" id="Span_StartDate">Start Date</span>
                                    </td>
                                    <td>
                                        <table cellspacing="0" cellpadding="0" border="0">
                                            <tr>
                                                <td align="left">
                                                    <input type="text" name="TextBox_CustomInquiries_InquiryStartDate" class="date_text"
                                                        id="TextBox_CustomInquiries_InquiryStartDate" datatype="Date" />
                                                </td>
                                                <td align="left" style="padding-left: 5px">
                                                    <table cellpadding="0" cellspacing="0" border="0">
                                                        <tr>
                                                            <td>
                                                                <div class="glow_lt">
                                                                    &nbsp;
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <div class="glow_mid">
                                                                    <input type="button" style="width: 15px;" id="Button_SetTodayDate" value="T" />
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
                                                <td align="left" style="padding-left: 5px">
                                                    <table cellpadding="0" cellspacing="0" border="0">
                                                        <tr>
                                                            <td>
                                                                <div class="glow_lt">
                                                                    &nbsp;
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <div class="glow_mid">
                                                                    <input type="button" style="width: 15px;" id="Button_SetYesterDayDate" value="Y" />
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
                                                <td align="left" style="padding-left: 5px">
                                                    <img id="img3" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                        onclick="return showCalendar('TextBox_CustomInquiries_InquiryStartDate', '%m/%d/%Y');"
                                                        alt="" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td align="left" style="white-space: nowrap">
                                        <span class="form_label" id="Span_StartTime">Start Time</span>
                                    </td>
                                    <td colspan="5">
                                        <table cellpadding="0" cellspacing="0" border="0">
                                            <tr>
                                                <td align="left">
                                                    <input type="text" name="Text_CustomInquiries_InquiryStartTime" class="form_textbox"
                                                        id="Text_CustomInquiries_InquiryStartTime" datatype="Time" style="width: 50px" />
                                                    <input type="hidden" id='Hidden_CustomInquiries_InquiryStartTime' />
                                                </td>
                                                <td align="left" style="padding-left: 5px">
                                                    <table cellpadding="0" cellspacing="0" border="0">
                                                        <tr>
                                                            <td>
                                                                <div class="glow_lt">
                                                                    &nbsp;
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <div class="glow_mid">
                                                                    <input type="button" style="width: 30px;" id="Button_SetCurrentTime" value="Now" />
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
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <input type="hidden" id="HiddenField_CustomInquiries_InquiryStartDateTime" />
                        </td>
                    </tr>
                    <tr>
                        <td align="right">
                            <table cellspacing="5" cellpadding="0" border="0">
                                <tr>
                                    <td align="left">
                                        <table cellpadding="0" cellspacing="0" border="0">
                                            <tr>
                                                <td>
                                                    <div class="glow_lt">
                                                        &nbsp;
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="glow_mid">
                                                        <input type="button" id="Button_RemoveMemberLink" value="Remove Client Link" class="Button" />
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
                                    <%--<td align="left">
                                        <table cellpadding="0" cellspacing="0" border="0">
                                            <tr>
                                                <td>
                                                    <div class="glow_lt">
                                                        &nbsp;</div>
                                                </td>
                                                <td>
                                                    <div class="glow_mid">
                                                        <input type="button" style="width: 120px;" id="Button_LinkOrCreateMember" value="Link/Create Client..."
                                                            onclick="return ShowClientSearchForLink('<%=RelativePath%>');" />
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="glow_rt">
                                                        &nbsp;</div>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>--%>
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
        <tr>
            <td style="padding-top: 10px">
                <table cellspacing="0" cellpadding="0" border="0">
                    <tr>
                        <td class="content_tab_left" align="left" nowrap='nowrap'>
                            <span class="form_label" id="Span8">Client Information (Potential)</span>
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
                <table cellspacing="0" cellpadding="0" border="0">
                    <tr>
                        <td>
                            <table cellspacing="5" cellpadding="0" border="0">
                                <tr>
                                    <td align="left" style="white-space: nowrap">
                                        <span class="form_label" id="Span_MemberFirstName">First Name</span>
                                    </td>
                                    <td align="left">
                                        <input type="text" name="TextBox_CustomInquiries_MemberFirstName" class="form_textbox"
                                            id="TextBox_CustomInquiries_MemberFirstName" required="true" maxlength="20" style="width: 100px" />
                                    </td>
                                    <td align="left" style="white-space: nowrap">
                                        <span class="form_label" id="Span_MemberMiddleName">Middle Name</span>
                                    </td>
                                    <td align="left">
                                        <input id="TextBox_CustomInquiries_MemberMiddleName" name="TextBox_CustomInquiries_MemberMiddleName"
                                            type="text" class="form_textbox" maxlength="20" style="width: 100px" />
                                    </td>
                                    <td align="left" style="white-space: nowrap" colspan="2">
                                        <span class="form_label" id="Span_MemberLastName" style="margin-right: 27px;">Last Name</span>
                                        <input id="TextBox_CustomInquiries_MemberLastName" name="TextBox_CustomInquiries_MemberLastName"
                                            type="text" class="form_textbox" maxlength="20" required="true" style="width: 100px" />
                                    </td>
                                    <td align="left" style="white-space: nowrap">
                                        <span class="form_label" id="Span_ClientId">Client ID</span>
                                    </td>
                                    <td align="left">
                                        <input id="TextBox_CustomInquiries_ClientId" name="TextBox_CustomInquiries_ClientId"
                                            onclick="OpenClientSummary('<%=RelativePath%>    ');" type="text" class="form_textbox"
                                            readonly="readonly" style="color: Gray; text-decoration: underline; cursor: hand;
                                            width: 40px;" />
                                    </td>
                                    <td style="white-space: nowrap">
                                        <span class="form_label" id="Span6">Sex</span>
                                    </td>
                                    <td>
                                        <DotNetDropDowns:StreamlineDropDowns ID="DropDownList_CustomInquiries_Sex" runat="server"
                                            CssClass="form_dropdown" Width="66px">
                                        </DotNetDropDowns:StreamlineDropDowns>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" style="white-space: nowrap">
                                        <span class="form_label" id="Span_SSN">SSN</span>
                                    </td>
                                    <td align="left">
                                        <input id="TextBox_CustomInquiries_SSN" class="form_textbox" datatype="SSN" maxlength="9"
                                            name="TextBox_CustomInquiries_SSN" type="text" style="width: 100px" />
                                    </td>
                                    <td align="left" colspan="2">
                                        <table cellspacing="0" cellpadding="0" border="0">
                                            <tr>
                                                <td align="left">
                                                    <input id="CheckBox_CustomInquiries_SSNUnknown" type="checkbox" />
                                                </td>
                                                <td align="left" style="padding-left: 5px">
                                                    <label for="CheckBox_CustomInquiries_SSNUnknown">
                                                        SSN Unknown/Refused</label>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <%--<td align="left">
                                        <span class="form_label" id="Span1" style="margin-right: 25px;">DOB</span>

                                    </td>--%>
                                    <td align="left" colspan="4">
                                        <table cellspacing="0" cellpadding="0" border="0">
                                            <tr>
                                                <td align="left">
                                                    <span class="form_label" id="Span1" style="margin-right: 25px;">DOB</span>
                                                </td>
                                                <td align="left">
                                                    <input type="text" id="TextBox_CustomInquiries_DateOfBirth" style="margin-left: 36px;"
                                                        name="TextBox_CustomInquiries_DateOfBirth" class="date_text" datatype="Date" />
                                                </td>
                                                <td align="left" style="padding-left: 5px">
                                                    <img id="imgOrderDate" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                        onclick="return showCalendar('TextBox_CustomInquiries_DateOfBirth', '%m/%d/%Y');"
                                                        alt="" />
                                                </td>
                                                <td align="left">
                                                    <span class="form_label" id="Span_Age">Age</span>
                                                </td>
                                                <td align="left">
                                                    <span class="form_label" id="Span_CustomInquiries_Age"></span>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <%--<td align="left" colspan="2">
                                        <table cellspacing="0" cellpadding="0" border="0">
                                            <tr>
                                                <td align="left">
                                                    <span class="form_label" id="Span_Age">Age</span>
                                                </td>
                                                <td align="left">
                                                    <span class="form_label" id="Span_CustomInquiries_Age"></span>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>--%>
                                    <td align="left">
                                        <span class="form_label" id="Span_MedicaidId">MedicaidId</span>
                                    </td>
                                    <td align="left">
                                        <input type="text" name="TextBox_CustomInquiries_MedicaidId" class="form_textbox"
                                            id="TextBox_CustomInquiries_MedicaidId" datatype="Numeric"
                                            maxlength="25" style="width: 59px" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" style="white-space: nowrap">
                                        <span class="form_label" id="Span_MemberPhone">Home Phone</span>
                                    </td>
                                    <td align="left">
                                        <input type="text" name="TextBox_CustomInquiries_MemberPhone" class="form_textbox"
                                            id="TextBox_CustomInquiries_MemberPhone" datatype="PhoneNumber" maxlength="15"
                                            style="width: 100px" />
                                        <input type="hidden" id="TextBox_CustomInquiries_MemberPhoneExtension" />
                                    </td>
                                    <td align="left">
                                        <span class="form_label" id="Span_MemberCell">Cell</span>
                                    </td>
                                    <td align="left">
                                        <input id="TextBox_CustomInquiries_MemberCell" runat="server" name="TextBox_CustomInquiries_MemberCell"
                                            type="text" class="form_textbox" datatype="PhoneNumber" maxlength="20" style="width: 100px" />
                                    </td>
                                    <td align="left" colspan="4">
                                        <span class="form_label" id="Span_MemberEmail" style="margin-right: 52px;">Email</span>
                                        <input id="TextBox_CustomInquiries_MemberEmail" runat="server" name="TextBox_CustomInquiries_MemberEmail"
                                            type="text" class="form_textbox" style="width: 196px" datatype="Email" maxlength="100" />
                                    </td>
                                    <td align="left">
                                        <span class="form_label" id="Span_MasterId">MasterId</span>
                                    </td>
                                    <td align="left">
                                        <input type="text" name="TextBox_CustomInquiries_MasterId" class="form_textbox" id="TextBox_CustomInquiries_MasterId"
                                            datatype="Numeric" maxlength="25" disabled="disabled" style="width: 60px" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" colspan="4">
                                        <table>
                                            <tr>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomInquiries_Homeless_Y" name="RadioButton_CustomInquiries_Homeless"
                                                        value="Y" style="margin-right: 0px" />
                                                    <span class="form_label" id="Span9" style="font-size: 85%; vertical-align: top; margin-right: 4px;">
                                                        Client is not homeless</span>
                                                </td>
                                                <td align="left">
                                                    <input type="radio" style="margin-right: 0px" id="RadioButton_CustomInquiries_Homeless_N"
                                                        name="RadioButton_CustomInquiries_Homeless" value="N" />
                                                    <span class="form_label" id="Span11" style="font-size: 85%; vertical-align: top;
                                                        margin-right: 4px;">Client is homeless</span>
                                                </td>
                                                <td align="left" colspan="2">
                                                    <input type="radio" style="margin-right: 0px" id="RadioButton_CustomInquiries_Homeless_U"
                                                        name="RadioButton_CustomInquiries_Homeless" value="U" />
                                                    <span class="form_label" id="Span12" style="font-size: 85%; vertical-align: top;
                                                        margin-right: 4px;">Client is chronically homeless</span>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td align="left" colspan="6">
                                        <span class="form_label" id="Span_UrgencyLevel" style="margin-right: 15px;">Priority
                                            Level</span>
                                        <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomInquiries_UrgencyLevel"
                                            Width="350px" runat="server" Category="XPRIORITYLEVEL" AddBlankRow="true" CssClass="form_dropdown">
                                        </DropDownGlobalCodes:DropDownGlobalCodes>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left">
                                        <span class="form_label" id="Span_Address1">Address1</span>
                                    </td>
                                    <td align="left" colspan="3">
                                        <input type="text" name="TextBox_CustomInquiries_Address1" class="form_textbox" id="TextBox_CustomInquiries_Address1"
                                            maxlength="100" style="width: 280px" />
                                    </td>
                                    <td align="left" colspan="6">
                                        <span class="form_label" id="Span_Inquirytype" style="margin-right: 17px;">Inquiry Type</span>
                                        <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomInquiries_InquiryType"
                                            Width="350px" runat="server" Category="XINQUIRYTYPE" AddBlankRow="true" CssClass="form_dropdown">
                                        </DropDownGlobalCodes:DropDownGlobalCodes>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left">
                                        <span class="form_label" id="Span_Address2">Address2</span>
                                    </td>
                                    <td align="left" colspan="3">
                                        <input id="TextBox_CustomInquiries_Address2" maxlength="100" name="TextBox_CustomInquiries_Address2"
                                            type="text" class="form_textbox" style="width: 280px" />
                                    </td>
                                    <td align="left" colspan="6" width="100%">
                                        <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                            <tr>
                                                <td colspan="3">
                                                    <span id="Span_InitialContact" class="form_label" style="margin-right: 11px;">Initial
                                                        Contact</span>
                                                    <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomInquiries_InitialContact"
                                                        runat="server" AddBlankRow="true" Category="XINITIALCONTACT" CssClass="form_dropdown"
                                                        Width="350px">
                                                    </DropDownGlobalCodes:DropDownGlobalCodes>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="15" class="height4">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="left" colspan="6">
                                                    <span class="form_label" id="Span_ContactType" style="margin-right: 16px;">Contact Type</span>
                                                    <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomInquiries_ContactType"
                                                        Width="350px" runat="server" Category="XCONTACTTYPE" AddBlankRow="true" CssClass="form_dropdown">
                                                    </DropDownGlobalCodes:DropDownGlobalCodes>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left">
                                        <span class="form_label" id="Span_City">City</span>
                                    </td>
                                    <td align="left" colspan="3">
                                        <input type="text" name="TextBox_CustomInquiries_City" class="form_textbox" id="TextBox_CustomInquiries_City"
                                            maxlength="30" style="width: 150px" />
                                    </td>
                                    <td align="left" colspan="6">
                                        <span class="form_label" id="Span_Location" style="margin-right: 2px;">Inquiry Location</span>
                                        <DotNetDropDowns:StreamlineDropDowns ID="DropDownList_CustomInquiries_Location" runat="server"
                                            CssClass="form_dropdown" AddBlankRow="true" Style="width: 350px">
                                        </DotNetDropDowns:StreamlineDropDowns>
                                    </td>
                                </tr>
                                <tr style="vertical-align: bottom;">
                                    <td align="left">
                                        <span class="form_label" id="Span_State">State</span>
                                    </td>
                                    <td align="left" style="vertical-align: middle;">
                                        <DotNetDropDowns:StreamlineDropDowns ID="DropDownList_CustomInquiries_State" runat="server"
                                            CssClass="form_dropdown" AddBlankRow="true" Style="width: 106px">
                                        </DotNetDropDowns:StreamlineDropDowns>
                                    </td>
                                    <td align="left" colspan="2">
                                        <span class="form_label" id="Span_ZipCode">Zip</span>
                                        <input id="TextBox_CustomInquiries_ZipCode" name="TextBox_CustomInquiries_ZipCode"
                                            type="text" class="form_textbox" datatype="ZipCode" maxlength="12" style="width: 100px" />
                                    </td>
                                    <td align="left" colspan="4">
                                        <span id="Span5">Current Client Information(If any)</span>
                                    </td>
                                </tr>
                                <tr style="vertical-align: top;">
                                    <td colspan="4">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td>
                                                    <span class="form_label" id="Span_PresentingProblem">Presenting Problem</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <textarea id="TextArea_CustomInquiries_PresentingProblem" runat="server" name="TextArea_CustomInquiries_PresentingProblem"
                                                        spellcheck="True" cols="20" rows="3" class="form_textarea" style="width: 355px;
                                                        height: 50px;"></textarea>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td valign="middle">
                                                    <table cellspacing="0" cellpadding="0" border="0" style="margin-top: 10px;">
                                                        <tr>
                                                            <td align="left" style="white-space: nowrap">
                                                                <span class="form_label" id="Span_ClientCanLegallySign">Client Can Legally Sign</span>
                                                            </td>
                                                            <td align="left">
                                                                <table cellspacing="0" cellpadding="0" border="0">
                                                                    <tr>
                                                                        <td style="padding-left: 5px">
                                                                            <input type="radio" id="RadioButton_CustomInquiries_ClientCanLegalySign_Yes" name="RadioButton_CustomInquiries_ClientCanLegalySign"
                                                                                onclick="OpenGuardianInfoPopUp('<%=RelativePath%>    ',this);" value="Y" />
                                                                        </td>
                                                                        <td style="padding-left: 5px">
                                                                            <label for="RadioButton_CustomInquiries_ClientCanLegalySign_Yes">
                                                                                Yes</label>
                                                                        </td>
                                                                        <td style="padding-left: 5px">
                                                                            <input type="radio" id="RadioButton_CustomInquiries_ClientCanLegalySign_No" name="RadioButton_CustomInquiries_ClientCanLegalySign"
                                                                                onclick="OpenGuardianInfoPopUp('<%=RelativePath%>',this);" value="N" />
                                                                        </td>
                                                                        <td style="padding: 0 5px">
                                                                            <label for="RadioButton_CustomInquiries_ClientCanLegalySign_No">
                                                                                No</label>
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
                                    <td colspan="6">
                                        <table>
                                            <tr>
                                                <td>
                                                    <textarea id="TextArea_MemberInformation" name="TextArea_MemberInformation" rows="6"
                                                        cols="140" class="form_textarea" readonly="true"></textarea>
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
        <tr>
            <td colspan="15" class="height4">
            </td>
        </tr>
        <%--<tr>
            <td>
                <table cellspacing="0" cellpadding="0" border="0" width="99.5%">
                    <tr>
                        <td>
                            <uc1:VerifyEligibility runat="server" ID="eev1" />
                        </td>
                    </tr>
                </table>
            </td>
        </tr>--%>
        <tr>
            <td style="padding-top: 10px">
                <table cellspacing="0" cellpadding="0" border="0">
                    <tr>
                        <td class="content_tab_left" align="left" nowrap='nowrap'>
                            <span class="form_label" id="Span20">Risk Assessment</span>
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
            <td class="content_tab_bg" style="padding-left: 8px">
                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                    <tr>
                        <td style="width: 60%;">
                            <span id="Span13">Did consumer indicate that they are in eminent danger of harming self
                                or others?</span>
                        </td>
                        <td class="checkbox_container" style="width: 40%;">
                            <input type="radio" id="RadioButton_CustomInquiries_RiskAssessmentInDanger_Y" name="RadioButton_CustomInquiries_RiskAssessmentInDanger"
                                value="Y" />
                            <label for="RadioButton_CustomInquiries_RiskAssessmentInDanger_Yes">
                                Yes</label>
                            <input type="radio" id="RadioButton_CustomInquiries_RiskAssessmentInDanger_N" name="RadioButton_CustomInquiries_RiskAssessmentInDanger"
                                value="N" />
                            <label for="RadioButton_CustomInquiries_RiskAssessmentInDanger_No">
                                No</label>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <span id="Span14">If yes, document action taken</span>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <textarea id="TextArea_CustomInquiries_RiskAssessmentInDangerComment" name="TextArea_CustomInquiries_RiskAssessmentInDangerComment"
                                rows="3" cols="160" class="form_textarea" spellcheck="True"></textarea>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 60%;">
                            <span id="Span15">Was the consumer advised of the availability of a counselor </span>
                        </td>
                        <td class="checkbox_container" style="width: 40%;">
                            <input type="radio" id="RadioButton_CustomInquiries_RiskAssessmentCounselorAvailability_Y"
                                name="RadioButton_CustomInquiries_RiskAssessmentCounselorAvailability" value="Y" />
                            <label for="RadioButton_CustomInquiries_RiskAssessmentCounselorAvailability_Yes">
                                Yes</label>
                            <input type="radio" id="RadioButton_CustomInquiries_RiskAssessmentCounselorAvailability_N"
                                name="RadioButton_CustomInquiries_RiskAssessmentCounselorAvailability" value="N" />
                            <label for="RadioButton_CustomInquiries_RiskAssessmentCounselorAvailability_No">
                                No</label>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <span id="Span16">If no, explain</span>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <textarea id="TextArea_CustomInquiries_RiskAssessmentCounselorAvailabilityComment"
                                name="TextArea_CustomInquiries_RiskAssessmentCounselorAvailabilityComment" rows="3"
                                cols="160" class="form_textarea" spellcheck="True"></textarea>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 60%;">
                            <span id="Span17">Was the consumer advised of the availability of 24/7 crisis line
                            </span>
                        </td>
                        <td class="checkbox_container" style="width: 40%;">
                            <input type="radio" id="RadioButton_CustomInquiries_RiskAssessmentCrisisLine_Y" name="RadioButton_CustomInquiries_RiskAssessmentCrisisLine"
                                value="Y" />
                            <label for="RadioButton_CustomInquiries_RiskAssessmentCrisisLine_Yes">
                                Yes</label>
                            <input type="radio" id="RadioButton_CustomInquiries_RiskAssessmentCrisisLine_N" name="RadioButton_CustomInquiries_RiskAssessmentCrisisLine"
                                value="N" />
                            <label for="RadioButton_CustomInquiries_RiskAssessmentCrisisLine_No">
                                No</label>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <span id="Span18">If no, explain</span>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <textarea id="TextArea_CustomInquiries_RiskAssessmentCrisisLineComment" name="TextArea_CustomInquiries_RiskAssessmentCrisisLineComment"
                                rows="3" cols="160" class="form_textarea" spellcheck="True"></textarea>
                        </td>
                    </tr>
                    <tr style="line-height: 25px;">
                        <td align="left" class="checkbox_container" colspan="2">
                            <span id="Span19" style="margin-top: 10px;">Crisis Information Provided?</span>
                            <input type="radio" id="RadioButton_CustomInquiries_RiskAssessmentCrisisInformation_Y"
                                name="RadioButton_CustomInquiries_RiskAssessmentCrisisInformation" value="Y" />
                            <label for="RadioButton_CustomInquiries_RiskAssessmentCrisisInformation_Yes">
                                Yes</label>
                            <input type="radio" id="RadioButton_CustomInquiries_RiskAssessmentCrisisInformation_N"
                                name="RadioButton_CustomInquiries_RiskAssessmentCrisisInformation" value="N" />
                            <label for="RadioButton_CustomInquiries_RiskAssessmentCrisisInformation_No">
                                No</label>
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
        <tr>
            <td style="padding-top: 10px">
                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                    <tr>
                        <td class="content_tab_left" align="left" nowrap='nowrap'>
                            <span id="Span_EmergencyContact">Emergency Contact</span>
                        </td>
                        <td width="17px">
                            <img style="vertical-align: top;" height="26" width="17px" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                        </td>
                        <td class="content_tab_top" width="100%">
                            <table>
                                <tr>
                                    <td>
                                        <input type="checkbox" id="CheckBox_CustomInquiries_SameAsCaller" />
                                    </td>
                                    <td>
                                        Same As Caller
                                    </td>
                                </tr>
                            </table>
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
                <table cellspacing="0" cellpadding="0" border="0">
                    <tr>
                        <td>
                            <table cellspacing="5" cellpadding="0" border="0">
                                <tr>
                                    <td align="left" style="width: 65px">
                                        <span class="form_label" id="Span_EmergencyContactFirstName">First Name</span>
                                    </td>
                                    <td align="left">
                                        <input type="text" name="TextBox_CustomInquiries_EmergencyContactFirstName" class="form_textbox"
                                            id="TextBox_CustomInquiries_EmergencyContactFirstName" maxlength="20" />
                                    </td>
                                    <td align="left">
                                        <span class="form_label" id="Span_EmergencyContactMiddleName">Middle Name</span>
                                    </td>
                                    <td align="left">
                                        <input id="TextBox_CustomInquiries_EmergencyContactMiddleName" name="TextBox_CustomInquiries_EmergencyContactMiddleName"
                                            type="text" class="form_textbox" maxlength="20" />
                                    </td>
                                    <td align="left">
                                        <span class="form_label" id="Span_EmergencyContactLastName">Last Name</span>
                                    </td>
                                    <td align="left">
                                        <input id="TextBox_CustomInquiries_EmergencyContactLastName" name="TextBox_CustomInquiries_EmergencyContactLastName"
                                            type="text" class="form_textbox" maxlength="30" />
                                    </td>
                                    <td align="left">
                                        <span class="form_label" id="Span_EmergencyContactRelationToClient">Relation To Client</span>
                                    </td>
                                    <td align="left">
                                        <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomInquiries_EmergencyContactRelationToClient"
                                            Width="120px" runat="server" Category="RELATIONSHIP" AddBlankRow="true" CssClass="form_dropdown">
                                        </DropDownGlobalCodes:DropDownGlobalCodes>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 65px">
                                        <span class="form_label" id="Span_EmergencyContactHomePhone">Home Phone</span>
                                    </td>
                                    <td>
                                        <input type="text" name="TextBox_CustomInquiries_EmergencyContactHomePhone" class="form_textbox"
                                            id="TextBox_CustomInquiries_EmergencyContactHomePhone" datatype="PhoneNumber"
                                            maxlength="10" />
                                    </td>
                                    <td>
                                        <span class="form_label" id="Span_EmergencyContactCellPhone">Cell Phone</span>
                                    </td>
                                    <td>
                                        <input id="TextBox_CustomInquiries_EmergencyContactCellPhone" name="TextBox_CustomInquiries_EmergencyContactCellPhone"
                                            type="text" class="form_textbox" datatype="PhoneNumber" maxlength="20" />
                                    </td>
                                    <td>
                                        <span class="form_label" id="Span_EmergencyContactWorkPhone">Work Phone</span>
                                    </td>
                                    <td colspan="3">
                                        <input id="TextBox_CustomInquiries_EmergencyContactWorkPhone" name="TextBox_CustomInquiries_EmergencyContactWorkPhone"
                                            type="text" class="form_textbox" datatype="PhoneNumber" maxlength="20" />
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
        <tr>
            <td colspan="2" style="padding-top: 10px">
                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                    <tr>
                        <td>
                            <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                <tr>
                                    <td class="content_tab_left" align="left" nowrap='nowrap'>
                                        <span id="Span10">Referral Resource</span>
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
                                    <td align="left" width="100px">
                                        <span class="form_label" id="Span_ReferralDate">Referral Date</span>
                                    </td>
                                    <td align="left" colspan="3">
                                        <table cellspacing="0" cellpadding="0" border="0">
                                            <tr>
                                                <td align="left">
                                                    <input type="text" id="TextBox_CustomInquiries_ReferralDate" 
                                                        name="TextBox_CustomInquiries_ReferralDate" class="date_text" datatype="Date"
                                                        tabindex="1" />
                                                </td>
                                                <td align="left" style="padding-left: 5px">
                                                    <img id="img2" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                        onclick="return showCalendar('TextBox_CustomInquiries_ReferralDate', '%m/%d/%Y');"
                                                        alt="" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td align="left" width="100px">
                                        <span class="form_label" id="Span_ReferralType">Source of Referral</span>
                                    </td>
                                    <td align="left" colspan="3">
                                        <DotNetDropDowns:StreamlineDropDowns ID="DropDownList_CustomInquiries_ReferralType" TabIndex="2"
                                                        Width="276px" runat="server" CssClass="form_dropdown" EnableViewState="false">
                                                    </DotNetDropDowns:StreamlineDropDowns>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left">
                                        <span class="form_label" id="Span_ReferralSubtype">Referral Subtype</span>
                                    </td>
                                    <td align="left" colspan="3">
                                        <DotNetDropDowns:StreamlineDropDowns ID="DropDownList_CustomInquiries_ReferralSubtype" Width="326px"
                                            runat="server" CssClass="form_dropdown" EnableViewState="false" TabIndex="3">
                                        </DotNetDropDowns:StreamlineDropDowns>
                                    </td>
                                    <td align="left">
                                        <span class="form_label" id="Span_ReferralReason">Referral Reason</span>
                                    </td>
                                    <td align="left" colspan="3">
                                        <DotNetDropDowns:StreamlineDropDowns ID="DropDownList_CustomInquiries_ReferralReason" Width="276px"
                                            runat="server" CssClass="form_dropdown" EnableViewState="false" TabIndex="4">
                                        </DotNetDropDowns:StreamlineDropDowns>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left">
                                        <span class="form_label" id="Span_ReferralName">Organization Name</span>
                                    </td>
                                    <td align="left" colspan="3">
                                        <input id="TextBox_CustomInquiries_ReferalOrganizationName" runat="server" name="TextBox_CustomInquiries_ReferalOrganizationName"
                                            type="text" class="form_textbox" tabindex="4" style="width: 320px;" />
                                    </td>
                                    <td align="left">
                                        <span class="form_label" id="Span21">Phone</span>
                                    </td>
                                    <td align="left" colspan="3">
                                        <input id="TextBox_CustomInquiries_ReferalPhone" runat="server" name="TextBox_CustomInquiries_ReferalPhone"
                                            type="text" class="form_textbox" tabindex="4" style="width: 270px;" datatype="PhoneNumber"
                                            maxlength="20" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left">
                                        <span class="form_label" id="Span22">First Name</span>
                                    </td>
                                    <td align="left" colspan="3">
                                        <input id="TextBox_CustomInquiries_ReferalFirstName" runat="server" name="TextBox_CustomInquiries_ReferalFirstName"
                                            type="text" class="form_textbox" tabindex="4" style="width: 320px;" maxlength="20" />
                                    </td>
                                    <td align="left">
                                        <span class="form_label" id="Span23">Last Name</span>
                                    </td>
                                    <td align="left" colspan="3">
                                        <input id="TextBox_CustomInquiries_ReferalLastName" runat="server" name="TextBox_CustomInquiries_ReferalLastName"
                                            type="text" class="form_textbox" tabindex="4" style="width: 270px;" maxlength="30" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left">
                                        <span class="form_label" id="Span24">Address Line 1</span>
                                    </td>
                                    <td align="left" colspan="3">
                                        <input id="TextBox_CustomInquiries_ReferalAddressLine1" runat="server" name="TextBox_CustomInquiries_ReferalAddressLine1"
                                            type="text" class="form_textbox" tabindex="4" style="width: 320px;" maxlength="100" />
                                    </td>
                                    <td align="left">
                                        <span class="form_label" id="Span25">Address Line 2</span>
                                    </td>
                                    <td align="left" colspan="3">
                                        <input id="TextBox_CustomInquiries_ReferalAddressLine2" runat="server" name="TextBox_CustomInquiries_ReferalAddressLine2"
                                            type="text" class="form_textbox" tabindex="4" style="width: 270px;" maxlength="100" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left">
                                        <span class="form_label" id="Span26">City</span>
                                    </td>
                                    <td align="left">
                                        <input id="TextBox_CustomInquiries_ReferalCity" runat="server" name="TextBox_CustomInquiries_ReferalCity"
                                            type="text" class="form_textbox" tabindex="4" style="width: 100px;" maxlength="30" />
                                    </td>
                                    <td align="left">
                                        <span class="form_label" id="Span28">State</span>
                                        <DotNetDropDowns:StreamlineDropDowns ID="DropDownList_CustomInquiries_ReferalState"
                                            runat="server" CssClass="form_dropdown" AddBlankRow="true" Style="width: 60px;">
                                        </DotNetDropDowns:StreamlineDropDowns>
                                    </td>
                                    <td align="left">
                                        <span class="form_label" id="Span29">Zip</span>
                                        <input id="TextBox_CustomInquiries_ReferalZip" name="TextBox_CustomInquiries_ReferalZip"
                                            type="text" class="form_textbox" datatype="ZipCode" maxlength="12" style="width: 92px;" />
                                    </td>
                                    <td align="left">
                                        <span class="form_label" id="Span27">Email</span>
                                    </td>
                                    <td align="left" colspan="3">
                                        <input id="TextBox_CustomInquiries_ReferalEmail" runat="server" name="TextBox_CustomInquiries_ReferalEmail"
                                            type="text" class="form_textbox" tabindex="4" style="width: 270px;" datatype="Email"
                                            maxlength="100" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" colspan="8">
                                        <span class="form_label" id="Span_AdditionalInformation">Comments</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" colspan="8">
                                        <textarea id="TextArea_CustomInquiries_ReferalComments" runat="server" name="TextArea_CustomInquiries_ReferalComments"
                                            spellcheck="True" cols="20" rows="3" tabindex="5" class="form_textarea" style="width: 100%;
                                            height: 50px;"></textarea>
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
            <td style="padding-top: 10px">
                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                    <tr>
                        <td class="content_tab_left" align="left" nowrap='nowrap'>
                            <span id="Span_InquiryHandledBy">Inquiry Handled By</span>
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
                        <td align="left">
                            <span class="form_label" id="Span_RecordedBy">Recorded By</span>
                        </td>
                        <td align="left">
                            <DotNetDropDowns:StreamlineDropDowns ID="DropDownList_CustomInquiries_RecordedBy"
                                Width="250px" runat="server" CssClass="form_dropdown">
                            </DotNetDropDowns:StreamlineDropDowns>
                        </td>
                        <td align="left">
                            <span class="form_label" id="Span_InformationGatheredBy">Information Gathered By</span>
                        </td>
                        <td align="left">
                            <DotNetDropDowns:StreamlineDropDowns ID="DropDownList_CustomInquiries_GatheredBy"
                                Width="250px" runat="server" CssClass="form_dropdown">
                            </DotNetDropDowns:StreamlineDropDowns>
                        </td>
                    </tr>
                    <tr>
                        <td align="left">
                            <span class="form_label" id="Span_Program">Program</span>
                        </td>
                        <td align="left">
                            <DotNetDropDowns:StreamlineDropDowns ID="DropDownList_CustomInquiries_ProgramId"
                                Width="250px" AddBlankRow="true" runat="server" CssClass="form_dropdown">
                            </DotNetDropDowns:StreamlineDropDowns>
                        </td>
                        <td align="left">
                            <span class="form_label" id="Span_GatherdByOther">Gathered By Other</span>
                        </td>
                        <td align="left">
                            <input type="text" name="TextBox_CustomInquiries_GatheredByOther" class="form_textbox"
                                maxlength="50" style="width: 244px" id="TextBox_CustomInquiries_GatheredByOther" />
                        </td>
                    </tr>
                    <tr>
                        <td align="left">
                            <span class="form_label" id="Span_Facility" style="margin-right: 16px;">Facility</span>
                        </td>
                        <td align="left">
                            <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomInquiries_Facility"
                                Width="250px" runat="server" Category="XFACILITY" AddBlankRow="true" CssClass="form_dropdown">
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
        <tr>
            <td style="padding-top: 10px">
                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                    <tr>
                        <td class="content_tab_left" align="left" nowrap='nowrap'>
                            <span id="Span_Population">Provisional Disability Designation</span>
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
                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                    <tr>
                        <td>
                            <table cellspacing="5" cellpadding="0" border="0">
                                <tr>
                                    <td align="left">
                                        <span class="form_label" id="Span_PopulationDD">DD</span>
                                    </td>
                                    <td align="left" style="padding-left: 8px">
                                        <input type="radio" id="RadioButton_CustomInquiries_PopulationDD_Yes" name="RadioButton_CustomInquiries_PopulationDD"
                                            value="Y" />
                                    </td>
                                    <td align="left">
                                        <label for="RadioButton_CustomInquiries_PopulationDD_Yes" style="margin-right: 20px;">
                                            Yes</label>
                                    </td>
                                    <td align="left">
                                        <input type="radio" id="RadioButton_CustomInquiries_PopulationDD_No" name="RadioButton_CustomInquiries_PopulationDD"
                                            value="N" />
                                    </td>
                                    <td align="left">
                                        <label for="RadioButton_CustomInquiries_PopulationDD_No" style="margin-right: 20px;">
                                            No</label>
                                    </td>
                                    <td align="left">
                                        <input type="radio" id="RadioButton_CustomInquiries_PopulationDD_NotEvaluated" checked="checked"
                                            name="RadioButton_CustomInquiries_PopulationDD" value="U" />
                                    </td>
                                    <td align="left">
                                        <label for="RadioButton_CustomInquiries_PopulationDD_NotEvaluated" style="margin-right: 20px;">
                                            Not Evaluated</label>
                                    </td>
                                    <td class="checkbox_container">
                                        <input type="checkbox" id="CheckBox_CustomInquiries_PopulationDDClientSeeking" class="element"
                                            name="CheckBox_CustomInquiries_PopulationDDClientSeeking" tabindex="6" value="" />
                                        <label class="form_label" style="vertical-align: top">
                                            Client is seeking services
                                        </label>
                                        <input type="hidden" id="HiddenField_CustomInquiries_PopulationDD" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left">
                                        <span class="form_label" id="Span_PopulationMI">Autism</span>
                                    </td>
                                    <td align="left" style="padding-left: 8px">
                                        <input type="radio" id="RadioButton_CustomInquiries_PopulationAutism_Yes" name="RadioButton_CustomInquiries_PopulationAutism"
                                            value="Y" />
                                    </td>
                                    <td align="left">
                                        <label for="RadioButton_CustomInquiries_PopulationAutism_Yes">
                                            Yes</label>
                                    </td>
                                    <td align="left">
                                        <input type="radio" id="RadioButton_CustomInquiries_PopulationAutism_No" name="RadioButton_CustomInquiries_PopulationAutism"
                                            value="N" />
                                    </td>
                                    <td align="left">
                                        <label for="RadioButton_CustomInquiries_PopulationAutism_No">
                                            No</label>
                                    </td>
                                    <td align="left">
                                        <input type="radio" id="RadioButton_CustomInquiries_PopulationAutism_NotEvaluated"
                                            checked="checked" name="RadioButton_CustomInquiries_PopulationAutism" value="U" />
                                    </td>
                                    <td align="left">
                                        <label for="RadioButton_CustomInquiries_PopulationAutism_NotEvaluated">
                                            Not Evaluated</label>
                                    </td>
                                    <td>
                                        <input type="checkbox" id="CheckBox_CustomInquiries_PopulationAutismClientSeeking"
                                            class="element" name="CheckBox_CustomInquiries_PopulationAutismClientSeeking"
                                            tabindex="6" value="" />
                                        <label class="form_label" style="vertical-align: top">
                                            Client is seeking services
                                        </label>
                                        <input type="hidden" id="HiddenField_CustomInquiries_PopulationAutism" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left">
                                        <span class="form_label" id="Span_PopulationSA">MH</span>
                                    </td>
                                    <td align="left" style="padding-left: 8px">
                                        <input type="radio" id="RadioButton_CustomInquiries_PopulationMH_Yes" name="RadioButton_CustomInquiries_PopulationMH"
                                            value="Y" />
                                    </td>
                                    <td align="left">
                                        <label for="RadioButton_CustomInquiries_PopulationMH_Yes">
                                            Yes</label>
                                    </td>
                                    <td align="left">
                                        <input type="radio" id="RadioButton_CustomInquiries_PopulationMH_No" name="RadioButton_CustomInquiries_PopulationMH"
                                            value="N" />
                                    </td>
                                    <td align="left">
                                        <label for="RadioButton_CustomInquiries_PopulationMH_No">
                                            No</label>
                                    </td>
                                    <td align="left">
                                        <input type="radio" id="RadioButton_CustomInquiries_PopulationMH_NotEvaluated" checked="checked"
                                            name="RadioButton_CustomInquiries_PopulationMH" value="U" />
                                    </td>
                                    <td align="left">
                                        <label for="RadioButton_CustomInquiries_PopulationMH_NotEvaluated">
                                            Not Evaluated</label>
                                    </td>
                                    <td align="left">
                                        <input type="checkbox" id="CheckBox_CustomInquiries_PopulationMHClientSeeking" class="element"
                                            name="CheckBox_CustomInquiries_PopulationMHClientSeeking" tabindex="6" value="" />
                                        <label class="form_label" style="vertical-align: top">
                                            Client is seeking services
                                        </label>
                                        <input type="hidden" id="HiddenField_CustomInquiries_PopulationMH" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left">
                                        <span class="form_label" id="Span30">SUD</span>
                                    </td>
                                    <td align="left" style="padding-left: 8px">
                                        <input type="radio" id="RadioButton_CustomInquiries_PopulationSUD_Yes" name="RadioButton_CustomInquiries_PopulationSUD"
                                            value="Y" />
                                    </td>
                                    <td align="left">
                                        <label for="RadioButton_CustomInquiries_PopulationSUD_Yes">
                                            Yes</label>
                                    </td>
                                    <td align="left">
                                        <input type="radio" id="RadioButton_CustomInquiries_PopulationSUD_No" name="RadioButton_CustomInquiries_PopulationSUD"
                                            value="N" />
                                    </td>
                                    <td align="left">
                                        <label for="RadioButton_CustomInquiries_PopulationSUD_No">
                                            No</label>
                                    </td>
                                    <td align="left">
                                        <input type="radio" id="RadioButton_CustomInquiries_PopulationSUD_NotEvaluated" checked="checked"
                                            name="RadioButton_CustomInquiries_PopulationSUD" value="U" />
                                    </td>
                                    <td align="left">
                                        <label for="RadioButton_CustomInquiries_PopulationSUD_NotEvaluated">
                                            Not Evaluated</label>
                                    </td>
                                    <td>
                                        <input type="checkbox" id="CheckBox_CustomInquiries_PopulationSUDClientSeeking" class="element"
                                            name="CheckBox_CustomInquiries_PopulationSUDClientSeeking" tabindex="6" value="" />
                                        <label class="form_label" style="vertical-align: top">
                                            Client is seeking services
                                        </label>
                                        <input type="hidden" id="HiddenField_CustomInquiries_PopulationSUD" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        &nbsp;
                                    </td>
                                    <td align="left" colspan="7" style="padding-left: 8px">
                                        <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomInquiries_SAType"
                                            Width="360px" runat="server" Category="XSATYPE" AddBlankRow="true" CssClass="form_dropdown">
                                        </DropDownGlobalCodes:DropDownGlobalCodes>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left">
                                        <span class="form_label" id="Span32">Injection Drug User</span>
                                    </td>
                                    <td align="left" style="padding-left: 8px">
                                        <input type="radio" id="RadioButton_CustomInquiries_InjectingDrugs_Yes" name="RadioButton_CustomInquiries_InjectingDrugs"
                                            value="Y" />
                                    </td>
                                    <td align="left">
                                        <label for="RadioButton_CustomInquiries_InjectingDrugs_Yes">
                                            Yes</label>
                                    </td>
                                    <td align="left">
                                        <input type="radio" id="RadioButton_CustomInquiries_InjectingDrugs_No" name="RadioButton_CustomInquiries_InjectingDrugs"
                                            value="N" />
                                    </td>
                                    <td align="left">
                                        <label for="RadioButton_CustomInquiries_InjectingDrugs_No">
                                            No</label>
                                    </td>
                                    <td align="left">
                                        <input type="radio" id="RadioButton_CustomInquiries_InjectingDrugs_Denies" 
                                            name="RadioButton_CustomInquiries_InjectingDrugs" value="U" /> 
                                    </td>
                                    <td align="left">
                                        <label for="RadioButton_CustomInquiries_InjectingDrugs_Denies">
                                            Denies</label>
                                    </td>
                                    <td class="checkbox_container">
                                        <input type="hidden" id="HiddenField_CustomInquiries_InjectingDrugs" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left">
                                        <span class="form_label" id="Span31">Pregnant</span>
                                    </td>
                                    <td align="left" style="padding-left: 8px">
                                        <input type="radio" id="RadioButton_CustomInquiries_Pregnant_Yes" class="Pregnant"
                                            name="RadioButton_CustomInquiries_Pregnant" value="Y" />
                                    </td>
                                    <td align="left">
                                        <label for="RadioButton_CustomInquiries_PopulationDD_Yes">
                                            Yes</label>
                                    </td>
                                    <td align="left">
                                        <input type="radio" id="RadioButton_CustomInquiries_Pregnant_No" class="Pregnant"
                                            name="RadioButton_CustomInquiries_Pregnant" value="N" />
                                    </td>
                                    <td align="left">
                                        <label for="RadioButton_CustomInquiries_PopulationDD_No">
                                            No</label>
                                    </td>
                                    <td align="left">
                                        <input type="radio" id="RadioButton_CustomInquiries_Pregnant_Unknown" class="Pregnant"
                                           name="RadioButton_CustomInquiries_Pregnant" value="U" />
                                    </td>
                                    <td align="left">
                                        <label for="RadioButton_CustomInquiries_PopulationDD_NotEvaluated">
                                            Unknown</label>
                                    </td>
                                    <td class="checkbox_container">
                                        <input type="radio" id="RadioButton_CustomInquiries_Pregnant_NotApplicable" class="Pregnant"
                                            name="RadioButton_CustomInquiries_Pregnant" value="A" />
                                        <label class="form_label" style="vertical-align: top">
                                            Not Applicable
                                        </label>
                                      
                                    </td>
                                     <td class="checkbox_container">
                                        <input type="radio" id="RadioButton_CustomInquiries_Pregnant_NotCollected" class="Pregnant"
                                            name="RadioButton_CustomInquiries_Pregnant" value="C" />
                                        <label class="form_label" style="vertical-align: top">
                                            Not Collected
                                        </label>
                                          <input type="hidden" id="HiddenField_CustomInquiries_Pregnant" />
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
        <tr>
            <td>
                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                    <tr>
                        <td class="content_tab_left" align="left" nowrap='nowrap'>
                            <span id="Span_Disposition">Disposition</span>
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
                <table cellspacing="5" cellpadding="0" border="0" width="100%">
                    <tr>
                        <td colspan="2">
                            <asp:Panel ID="PanelDispositionMain" runat="server">
                            </asp:Panel>
                        </td>
                    </tr>
                    <tr>
                        <td align="left" colspan="2">
                            <span class="form_label" id="Span_DispositionComment">Disposition Comments</span>
                        </td>
                    </tr>
                    <tr>
                        <td align="left" colspan="2" style="padding-left: 4px">
                            <textarea id="TextArea_CustomInquiries_DispositionComment" name="TextArea_CustomInquiries_DispositionComment"
                                style="width: 97%; height: 50px" class="form_textarea" spellcheck="True"></textarea>
                        </td>
                    </tr>
                    <tr>
                        <td align="left" colspan="2">
                            <span class="form_label" id="Span4" style="margin-right: 10px;">Assigned To</span>
                            <DotNetDropDowns:StreamlineDropDowns ID="DropDownList_CustomInquiries_AssignedToStaffId"
                                AddBlankRow="true" Width="300px" runat="server" CssClass="form_dropdown">
                            </DotNetDropDowns:StreamlineDropDowns>
                        </td>
                    </tr>
                    <tr>
                        <td width="100%">
                            <table width="100%">
                                <tr>
                                    <td align="left" width="100%" colspan="2">
                                        <table width="100%">
                                            <tr>
                                                <td width="50%">
                                                    <span class="form_label" id="Span_InquiryDetails">Screening Comment - Include Follow
                                                        Up and Contact Information</span>
                                                </td>
                                                <td width="50%">
                                                    <span class="form_label" id="Span34">Additional Waitlist information</span>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" width="100%" colspan="2">
                                        <table width="100%">
                                            <tr>
                                                <td width="50%">
                                                    <textarea id="TextArea_CustomInquiries_InquiryDetails" name="TextArea_CustomInquiries_InquiryDetails"
                                                        style="width: 97%; height: 100px" class="form_textarea" spellcheck="True"></textarea>
                                                </td>
                                                <td width="50%">
                                                    <textarea id="TextArea_CustomInquiries_DispositionWaitListInformation" name="TextArea_CustomInquiries_DispositionWaitListInformation"
                                                        style="width: 97%; height: 100px" class="form_textarea" spellcheck="True"></textarea>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <%--                        <td align="left" >
                            <table width="100%">
                                <tr>
                                   
                                </tr>
                            </table>
                            </td>--%>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <table cellspacing="0" cellpadding="0" border="0">
                                <tr>
                                    <td align="left">
                                        <span class="form_label" id="Span2">End Date</span>
                                    </td>
                                    <td align="left" style="padding-left: 5px">
                                        <input type="text" name="TextBox_CustomInquiries_InquiryEndDate" class="date_text"
                                            id="TextBox_CustomInquiries_InquiryEndDate" datatype="Date" />
                                    </td>
                                    <td align="left" style="padding-left: 5px">
                                        <table cellpadding="0" cellspacing="0" border="0">
                                            <tr>
                                                <td>
                                                    <div class="glow_lt">
                                                        &nbsp;
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="glow_mid">
                                                        <input type="button" style="width: 15px;" id="Button_SetEndDate" value="T" />
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
                                    <td align="left" style="padding-left: 5px">
                                        <table cellpadding="0" cellspacing="0" border="0">
                                            <tr>
                                                <td>
                                                    <div class="glow_lt">
                                                        &nbsp;
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="glow_mid">
                                                        <input type="button" style="width: 15px;" id="Button_SetEndYesterDate" value="Y" />
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
                                    <td align="left" style="padding-left: 5px">
                                        <img id="img1" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                            onclick="return showCalendar('TextBox_CustomInquiries_InquiryEndDate', '%m/%d/%Y');"
                                            alt="" />
                                    </td>
                                    <td align="left" style="padding-left: 5px">
                                        <span class="form_label" id="Span3">End Time</span>
                                    </td>
                                    <td align="left" style="padding-left: 5px">
                                        <input type="text" name="Text_CustomInquiries_InquiryEndTime" class="form_textbox"
                                            id="Text_CustomInquiries_InquiryEndTime" datatype="Time" style="width: 50px" />
                                        <input type="hidden" id='Hidden_CustomInquiries_InquiryEndTime' />
                                    </td>
                                    <td align="left" style="padding-left: 5px">
                                        <table cellpadding="0" cellspacing="0" border="0">
                                            <tr>
                                                <td>
                                                    <div class="glow_lt">
                                                        &nbsp;
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="glow_mid">
                                                        <input type="button" style="width: 30px;" id="Button_SetEndTime" value="Now" />
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
                                    <td align="left" style="padding-left: 5px">
                                        <span class="form_label" id="Span_InquiryStatus">Status</span>
                                    </td>
                                    <td style="padding-left: 5px">
                                        <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomInquiries_InquiryStatus"
                                            Width="200px" runat="server" TabIndex="3" CssClass="form_dropdown" Category="XINQUIRYSTATUS">
                                        </DropDownGlobalCodes:DropDownGlobalCodes>
                                    </td>
                                    <%--<td>
                                        &nbsp;&nbsp;Inquiry is Complete&nbsp;&nbsp;
                                    </td>--%>
                                    <%-- <td>
                                        <input type="checkbox" id="CheckBox_CustomInquiries_InquiryIsComplete" />
                                    </td>--%>
                                </tr>
                            </table>
                            <input type="hidden" id="HiddenField_CustomInquiries_InquiryEndDateTime" />
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
        <tr>
            <td class="height2" width="100%">
            </td>
        </tr>
    </table>
</asp:Panel>
<asp:Panel ID="PanelLoadUC" runat="server">
</asp:Panel>
<%--<input type="hidden" id="HiddenFieldPageTables" name="HiddenFieldPageTables" value="CustomInquiries" />--%>
<input type="hidden" id="HiddenField_CustomInquiries_InquiryId" name="HiddenField_CustomInquiries_InquiryId" />
<input type="hidden" id="HiddenField_CustomInquiries_InquiryEventId" name="HiddenField_CustomInquiries_InquiryEventId" />
<input type="hidden" id="HiddenField_CustomInquiries_ClientId" name="HiddenField_CustomInquiries_ClientId" />
