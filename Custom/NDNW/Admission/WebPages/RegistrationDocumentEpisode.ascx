<%@ Control Language="C#" AutoEventWireup="true" CodeFile="RegistrationDocumentEpisode.ascx.cs"
    Inherits="Custom_Registration_WebPages_RegistrationDocumentEpisode" %>
<%@ Register Src="~/CommonUserControls/DynamicForms.ascx" TagName="DynamicForms"
    TagPrefix="uc2" %>
<%@ Register Assembly="Streamline.DotNetDropDownGlobalCodes" Namespace="Streamline.DotNetDropDownGlobalCodes"
    TagPrefix="DropDownGlobalCodes" %>
<%@ Register Assembly="Streamline.DotNetDropDowns" Namespace="Streamline.DotNetDropDowns"
    TagPrefix="cc2" %>
<style type="text/css">
    .style1
    {
        height: 26px;
    }
</style>
<div id="DivEpisodeDFA" class="DocumentScreen" style="overflow-y: auto; height: 450px">
    <table border="0" cellspacing="0" cellpadding="0" style="width: 100%">
        <tr>
            <td class="height2">
            </td>
        </tr>
        <tr>
            <td>
                <uc2:DynamicForms ID="DynamicFormsEpisode" width="820px" runat="server" />
            </td>
        </tr>
    </table>
    <table border="0" cellpadding="0" cellspacing="0" width="99%">
        <tr>
            <td class="height2">
            </td>
        </tr>
        <tr>
            <td>
                <table border="0" cellspacing="0" cellpadding="0" width="100%">
                    <tr>
                        <td class="content_tab_left" align="left" nowrap='nowrap'>
                            Referral Resource
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
                        <td class="padding_label1">
                            <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                <tr>
                                    <td style="width: 100%" class="style2" valign="top">
                                        <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                            <tr>
                                                <td width="12%" align="left">
                                                    <span class="form_label" id="Span4">Referral Date</span>
                                                </td>
                                                <td width="12%" align="left">
                                                    <input id="TextBox_CustomDocumentRegistrations_ReferralDate" class="date_text element"
                                                        name="TextBox_CustomDocumentRegistrations_ReferralDate" maxlength="10" type="text"
                                                        datatype="Date">
                                                    <img style="vertical-align: text-bottom; cursor: pointer;" id="img_CustomDocumentRegistrations_ReferralDate"
                                                        class="cursor_default element" onclick='return showCalendar("TextBox_CustomDocumentRegistrations_ReferralDate" ,"%m/%d/%Y");'
                                                        <img id="img1" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                </td>
                                                <td width="12%" align="left">
                                                    <span class="form_label" id="Span2">Source of Referral</span>
                                                </td>
                                                <td width="17%" align="left">
                                                    <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentRegistrations_ReferralType"
                                                        runat="server" Category="REFERRALTYPE" AddBlankRow="true" CssClass="form_dropdown" style="width: 140px;">
                                                    </DropDownGlobalCodes:DropDownGlobalCodes>
                                                </td>
                                                <td width="12%" align="left">
                                                    <span class="form_label" id="Span12">Referral Subtype</span>
                                                </td>
                                                <td width="23%" align="left">
                                                        <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentRegistrations_ReferralSubtype"
                                                        runat="server" AddBlankRow="true" CssClass="form_dropdown" style="width: 150px;">
                                                    </DropDownGlobalCodes:DropDownGlobalCodes>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                        </table>
                                        <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                            <tr>
                                                <td width="12%" align="left" class="style1">
                                                    <span class="form_label" id="Span1">Organization Name</span>
                                                </td>
                                                <td width="41%" align="left" class="style1">
                                                    <input style="width: 327px;" id="TextBox_CustomDocumentRegistrations_ReferralOrganization"
                                                        class="form_textbox element" name="TextBox_CustomDocumentRegistrations_ReferralOrganization"
                                                        maxlength="100" type="text">
                                                </td>
                                                <td width="12%" align="left" class="style1">
                                                    <span class="form_label" id="Span10">Phone</span>
                                                </td>
                                                <td width="23%" align="left" class="style1">
                                                    <input style="width: 150px;" id="TextBox_CustomDocumentRegistrations_ReferrralPhone"
                                                        class="form_textbox element" name="TextBox_CustomDocumentRegistrations_ReferrralPhone"
                                                        maxlength="100" type="text" datatype="PhoneNumber">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                        </table>
                                        <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                            <tr>
                                                <td width="12%" align="left">
                                                    <span class="form_label" id="Span3">First Name</span>
                                                </td>
                                                <td width="41%" align="left">
                                                    <input style="width: 210;" id="TextBox_CustomDocumentRegistrations_ReferrralFirstName"
                                                        class="form_textbox element" name="TextBox_CustomDocumentRegistrations_ReferrralFirstName"
                                                        maxlength="20" type="text">
                                                </td>
                                                <td width="12%" align="left">
                                                    <span class="form_label" id="Span13">Last Name</span>
                                                </td>
                                                <td width="23%" align="left">
                                                    <input style="width: 150px;" id="TextBox_CustomDocumentRegistrations_ReferrralLastName"
                                                        class="form_textbox element" name="TextBox_CustomDocumentRegistrations_ReferrralLastName"
                                                        maxlength="30" type="text">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                        </table>
                                        <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                            <tr>
                                                <td width="12%" align="left">
                                                    <span class="form_label" id="Span7">Address Line 1</span>
                                                </td>
                                                <td width="41%" align="left">
                                                    <input style="width: 327px;" id="TextBox_CustomDocumentRegistrations_ReferrralAddress1"
                                                        class="form_textbox element" name="TextBox_CustomDocumentRegistrations_ReferrralAddress1"
                                                        maxlength="100" type="text">
                                                </td>
                                                <td width="12%" align="left">
                                                    <span class="form_label" id="Span5">Address Line 2</span>
                                                </td>
                                                <td width="23%" align="left">
                                                    <input style="width: 150px;" id="TextBox_CustomDocumentRegistrations_ReferrralAddress2"
                                                        class="form_textbox element" name="TextBox_CustomDocumentRegistrations_ReferrralAddress2"
                                                        maxlength="100" type="text">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                        </table>
                                        <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                            <tr>
                                                <td width="12%" align="left">
                                                    <span class="form_label" id="Span11">City</span>
                                                </td>
                                                <td width="10%" align="left">
                                                    <input style="width: 80px;" id="TextBox_CustomDocumentRegistrations_ReferrralCity"
                                                        class="form_textbox element" name="TextBox_CustomDocumentRegistrations_ReferrralCity"
                                                        maxlength="30" type="text">
                                                </td>
                                                <td width="4%" align="left">
                                                    <span class="form_label" id="Span9">State</span>
                                                </td>
                                                <td width="10%" align="left">
                                                    <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentRegistrations_ReferrralState"
                                                        Width="90px" runat="server" AddBlankRow="True" BlankRowText="" clientinstancename="DropDownList_CustomDocumentRegistrations_StateDevXInstance"
                                                        BlankRowValue="-1" valuetype="System.Int32">
                                                    </cc2:StreamlineDropDowns>
                                                </td>
                                                <td width="3%" align="left">
                                                    <span class="form_label" id="Span14">ZIP</span>
                                                </td>
                                                <td width="14%" align="left">
                                                    <input style="width: 80px;" id="TextBox_CustomDocumentRegistrations_ReferrralZipCode"
                                                        class="form_textbox element" name="TextBox_CustomDocumentRegistrations_ReferrralZipCode"
                                                        maxlength="12" type="text" datatype="ZipCode">
                                                </td>
                                                <td width="12%" align="left">
                                                    <span class="form_label" style="padding-left: 5px" id="Span11">Email</span>
                                                </td>
                                                <td width="23%" align="left">
                                                    <input style="width: 150px;" id="TextBox_CustomDocumentRegistrations_ReferrralEmail"
                                                        class="form_textbox element" name="TextBox_CustomDocumentRegistrations_ReferrralEmail"
                                                        maxlength="50" type="text" datatype="Email">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                        </table>
                                        <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                            <tr>
                                                <td width="12%" align="left">
                                                    <span class="form_label" style="padding-left: 5px" id="Span17">Comments</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                        </table>
                                        <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                            <tr>
                                                <td width="88%" align="left">
                                                        <textarea id="TextBox_CustomDocumentRegistrations_ReferrralComment" class="form_textarea"
                                                        spellcheck="True" style="width: 98%; height: 60px;"></textarea>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                        </table>
                                        
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height1" colspan="2">
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
    <%--<input id="HiddenField_CustomRegistrations_DocumentVersionId" name="HiddenField_CustomRegistrations_DocumentVersionId"
        type="hidden" value="-1" />--%>
</div>
