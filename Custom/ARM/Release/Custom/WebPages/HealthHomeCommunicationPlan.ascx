<%@ Control Language="C#" AutoEventWireup="true" CodeFile="HealthHomeCommunicationPlan.ascx.cs"
    Inherits="SHS.SmartCare.HealthHomeCommunicationPlan" %>
<%@ Register Src="~/CommonUserControls/CustomGrid.ascx" TagName="CustomGrid" TagPrefix="uc1" %>
<%@ Register Assembly="Streamline.DotNetDropDowns" Namespace="Streamline.DotNetDropDowns"
    TagPrefix="cc2" %>
<% if (HttpContext.Current == null)
   { %>
<link href="../../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet"
    type="text/css" />
<%} %>

<script language="javascript" type="text/javascript" src="<%=RelativePath%>Custom/Scripts/HealthHomeCommunicationPlan.js" ></script>

<table class="DocumentScreen" border="0" cellspacing="0" cellpadding="0" style="padding-right:18px">
    <tr>
        <td>
            <table cellspacing="0" cellpadding="0" border="0" width="100%">
                <tr>
                    <td class="content_tab_left" align="left" nowrap='nowrap'>
                        <span id="Span15">A Renewed Mind Team</span>
                    </td>
                    <td width="17">
                        <img style="vertical-align: top;" height="26" width="17" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                    </td>
                    <td class="content_tab_top" width="100%">
                    </td>
                    <td width="7">
                        <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class="content_tab_bg" style="padding-left: 10px; padding-right: 5px">
            <table border="0" cellpadding="0" cellspacing="0" style="height: 100%; border-collapse: separate;
                width: 100%;">
               
                <tr>
                    <td>
                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td align="left" width="15%" >
                                    <span class="form_label_text" id="Span1">HH Team Member</span>
                                </td>
                                <td width="25%">
                                    <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamMember1"
                                        name="DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamMember1" Width="210px"
                                        runat="server" TabIndex="5">
                                    </cc2:StreamlineDropDowns>
                                </td>
                                <td width="6%">
                                </td>
                                <td width="13%" style="text-align: center;">
                                    <span class="form_label_text" id="Span3">Role</span>
                                </td>
                                <td width="37%">
                                    <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamRole1"
                                        name="DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamRole1" Width="210px"
                                        runat="server" TabIndex="5">
                                    </cc2:StreamlineDropDowns>
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
                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td align="left" width="15%">
                                    <span class="form_label_text" id="Span2">HH Team Member</span>
                                </td>
                                <td width="25%">
                                    <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamMember2"
                                        name="DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamMember2" Width="210px"
                                        runat="server" TabIndex="5">
                                    </cc2:StreamlineDropDowns>
                                </td>
                                <td width="6%">
                                </td>
                                <td width="13%" style="text-align: center;">
                                    <span class="form_label_text" id="Span4">Role</span>
                                </td>
                                <td width="37%">
                                    <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamRole2"
                                        name="DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamRole2" Width="210px"
                                        runat="server" TabIndex="5">
                                    </cc2:StreamlineDropDowns>
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
                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td align="left" width="15%">
                                    <span class="form_label_text" id="Span5">HH Team Member</span>
                                </td>
                                <td width="25%">
                                    <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamMember3"
                                        name="DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamMember3" Width="210px"
                                        runat="server" TabIndex="5">
                                    </cc2:StreamlineDropDowns>
                                </td>
                                <td width="6%">
                                </td>
                                <td width="13%" style="text-align: center;">
                                    <span class="form_label_text" id="Span6">Role</span>
                                </td>
                                <td width="37%">
                                    <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamRole3"
                                        name="DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamRole3" Width="210px"
                                        runat="server" TabIndex="5">
                                    </cc2:StreamlineDropDowns>
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
                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td align="left" width="15%" >
                                    <span class="form_label_text" id="Span7">HH Team Member</span>
                                </td>
                                <td width="25%">
                                    <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamMember4"
                                        name="DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamMember4" Width="210px"
                                        runat="server" TabIndex="5">
                                    </cc2:StreamlineDropDowns>
                                </td>
                                <td width="6%">
                                </td>
                                <td width="13%" style="text-align: center;">
                                    <span class="form_label_text" id="Span8">Role</span>
                                </td>
                                <td width="37%">
                                    <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamRole4"
                                        name="DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamRole4" Width="210px"
                                        runat="server" TabIndex="5">
                                    </cc2:StreamlineDropDowns>
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
                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td align="left" width="15%" >
                                    <span class="form_label_text" id="Span9">HH Team Member</span>
                                </td>
                                <td width="25%">
                                    <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamMember5"
                                        name="DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamMember5" Width="210px"
                                        runat="server" TabIndex="5">
                                    </cc2:StreamlineDropDowns>
                                </td>
                                <td width="6%">
                                </td>
                                <td width="13%" style="text-align: center;">
                                    <span class="form_label_text" id="Span10">Role</span>
                                </td>
                                <td width="37%">
                                    <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamRole5"
                                        name="DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamRole5" Width="210px"
                                        runat="server" TabIndex="5">
                                    </cc2:StreamlineDropDowns>
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
                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td align="left" width="15%" >
                                    <span class="form_label_text" id="Span11">HH Team Member</span>
                                </td>
                                <td width="25%">
                                    <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamMember6"
                                        name="DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamMember6" Width="210px"
                                        runat="server" TabIndex="5">
                                    </cc2:StreamlineDropDowns>
                                </td>
                                <td width="6%">
                                </td>
                                <td width="13%" style="text-align: center;">
                                    <span class="form_label_text" id="Span12">Role</span>
                                </td>
                                <td width="37%">
                                    <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamRole6"
                                        name="DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamRole6" Width="210px"
                                        runat="server" TabIndex="5">
                                    </cc2:StreamlineDropDowns>
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
                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td align="left" width="15%" >
                                    <span class="form_label_text" id="Span13">HH Team Member</span>
                                </td>
                                <td width="25%">
                                    <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamMember7"
                                        name="DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamMember7" Width="210px"
                                        runat="server" TabIndex="5">
                                    </cc2:StreamlineDropDowns>
                                </td>
                                <td width="6%">
                                </td>
                                <td width="13%" style="text-align: center;">
                                    <span class="form_label_text" id="Span14">Role</span>
                                </td>
                                <td width="37%">
                                    <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamRole7"
                                        name="DropDownList_CustomDocumentHealthHomeCommPlans_HealthHomeTeamRole7" Width="210px"
                                        runat="server" TabIndex="5">
                                    </cc2:StreamlineDropDowns>
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
    <tr>
        <td class="height2">
        </td>
    </tr>
    <tr>
        <td align="left">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class="content_tab_left" align="left" nowrap='nowrap'>
                        <span id="ExternalProviders">External Providers</span>
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
        <td class="content_tab_bg" style="padding-left: 10px; padding-right: 5px">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
               
                <tr>
                    <td >
                        <span id="ExternalProvidersNote" class="form_label_text">This section is for other healthcare
                            providers. No signed Authorization for Disclosure is needed for communication and
                            collaboration with these providers.
                            <br />
                            A Renewed Mind may contact and coordinate care with these providers, unless the client specifically
                            states he/she does not wish us to do so.</span>
                    </td>
                </tr>
                <tr>
                    <td class="height2">
                    </td>
                </tr>
                <tr>
                    <td>
                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td align="right" width="20%" style="padding-right: 3px;">
                                   <span class="form_label_text" id="Span17">Primary Care Physician</span>
                                </td>
                                <td width="39%" style="padding-left: 7px;">
                                    <input type="text" class="form_textbox" name="TextBox_CustomDocumentHealthHomeCommPlans_PrimaryCarePhysicianName"
                                        id="TextBox_CustomDocumentHealthHomeCommPlans_PrimaryCarePhysicianName" datatype="String"
                                        style="width: 270px" maxlength="300" />
                                </td>
                                <td width="37%">
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
                        <table cellspacing="0" cellpadding="0" border="0" width="100%">
                            <tr>
                                <td width="18%" class="LPadd8" style="text-align: right;">
                                    <span class="form_label" id="Span18">Telephone</span>
                                </td>
                                <td align="left" width="70%" valign="top">
                                    <span class="form_label" id="Span19">(</span>
                                    <input id="TextBox_CustomDocumentHealthHomeCommPlans_PrimaryCarePhysicianPhone1"
                                        enabled="enabled" type="text" class="form_textbox" style="width: 6%" datatype="Numeric"
                                        maxlength="3" bindautosaveevents="False" onkeyup="return autoTab(this, 3, event);"
                                        onkeydown="AllowNumericOnly('TextBox_CustomDocumentHealthHomeCommPlans_PrimaryCarePhysicianPhone1');"
                                        onblur="javascript:UpdatePhone('1','PrimaryCare');" />
                                    <span class="form_label" id="Span20">)</span>
                                    <input id="TextBox_CustomDocumentHealthHomeCommPlans_PrimaryCarePhysicianPhone2"
                                        enabled="enabled" type="text" class="form_textbox" onkeyup="return autoTab(this, 3, event);"
                                        style="width: 6%" datatype="Numeric" maxlength="3" bindautosaveevents="False"
                                        onblur="javascript:UpdatePhone('2','PrimaryCare');" onkeydown="AllowNumericOnly('TextBox_CustomDocumentHealthHomeCommPlans_PrimaryCarePhysicianPhone2');" />
                                    <span class="form_label" id="Span23">-</span>
                                    <input id="TextBox_CustomDocumentHealthHomeCommPlans_PrimaryCarePhysicianPhone3"
                                        enabled="enabled" type="text" class="form_textbox" onkeyup="return autoTab(this, 4, event);"
                                        style="width: 8%" datatype="Numeric" maxlength="4" onkeydown="AllowNumericOnly('TextBox_CustomDocumentHealthHomeCommPlans_PrimaryCarePhysicianPhone3');"
                                        bindautosaveevents="False" onblur="javascript:UpdatePhone('3','PrimaryCare');" />
                                    <span class="form_label" id="Span24">Ext</span>
                                    <input id="TextBox_CustomDocumentHealthHomeCommPlans_PrimaryCarePhysicianPhone4"
                                        enabled="enabled" type="text" class="form_textbox" onkeyup="return autoTab(this, 6, event);"
                                        style="width: 10%" datatype="Numeric" maxlength="6" bindautosaveevents="False"
                                        onblur="javascript:UpdatePhone('4','PrimaryCare');" onkeydown="AllowNumericOnly('TextBox_CustomDocumentHealthHomeCommPlans_PrimaryCarePhysicianPhone4');" />
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
                        <table cellspacing="0" cellpadding="0" border="0" width="100%">
                            <tr>
                                <td class="LPadd8" width="18%" style="text-align: right;">
                                    <span class="form_label" id="Span43">Fax</span>
                                </td>
                                <td style="width: 70%">
                                    <span class="form_label" id="Span44">(</span>
                                    <input id="TextBox_CustomDocumentHealthHomeCommPlans_PrimaryCarePhysicianFax1" enabled="enabled"
                                        type="text" class="form_textbox" onblur="javascript:CheckFaxNumber('TextBox_CustomDocumentHealthHomeCommPlans_PrimaryCarePhysicianFax1',3);"
                                        style="width: 6%" datatype="Numeric" maxlength="3" onkeyup="return autoTab(this, 3, event);"
                                        onkeydown="AllowNumericOnly('TextBox_CustomDocumentHealthHomeCommPlans_PrimaryCarePhysicianFax1');"
                                        bindautosaveevents="False" />
                                    <span class="form_label" id="Span45">)</span>
                                    <input id="TextBox_CustomDocumentHealthHomeCommPlans_PrimaryCarePhysicianFax2" enabled="enabled"
                                        type="text" class="form_textbox" onblur="javascript:CheckFaxNumber('TextBox_CustomDocumentHealthHomeCommPlans_PrimaryCarePhysicianFax2',3);"
                                        style="width: 6%" datatype="Numeric" onkeyup="return autoTab(this, 3, event);"
                                        maxlength="3" onkeydown="AllowNumericOnly('TextBox_CustomDocumentHealthHomeCommPlans_PrimaryCarePhysicianFax2');"
                                        bindautosaveevents="False" />
                                    <span class="form_label" id="Span46">-</span>
                                    <input id="TextBox_CustomDocumentHealthHomeCommPlans_PrimaryCarePhysicianFax3" enabled="enabled"
                                        type="text" class="form_textbox" onblur="javascript:CheckFaxNumber('TextBox_CustomDocumentHealthHomeCommPlans_PrimaryCarePhysicianFax3',4);"
                                        style="width: 8%" datatype="Numeric" onkeyup="return autoTab(this, 4, event);"
                                        maxlength="4" onkeydown="AllowNumericOnly('TextBox_CustomDocumentHealthHomeCommPlans_PrimaryCarePhysicianFax3');"
                                        bindautosaveevents="False" />
                                    <span class="form_label" id="Span47">Ext</span>
                                    <input id="TextBox_CustomDocumentHealthHomeCommPlans_PrimaryCarePhysicianFax4" enabled="enabled"
                                        type="text" class="form_textbox" onkeyup="return autoTab(this, 6, event);" style="width: 10%"
                                        datatype="Numeric" maxlength="6" bindautosaveevents="False" onblur="ValidateFax('TextBox_CustomDocumentHealthHomeCommPlans_PrimaryCarePhysicianFax1','TextBox_CustomDocumentHealthHomeCommPlans_PrimaryCarePhysicianFax2','TextBox_CustomDocumentHealthHomeCommPlans_PrimaryCarePhysicianFax3','TextBox_CustomDocumentHealthHomeCommPlans_PrimaryCarePhysicianFax4','PrimaryCare');"
                                        onkeydown="AllowNumericOnly('TextBox_CustomDocumentHealthHomeCommPlans_PrimaryCarePhysicianFax4');" />
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
                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td align="right" width="20%" style="padding-right: 80px;">
                                  <span class="form_label_text" id="Span30">Dentist</span>
                                </td>
                                <td width="39%" style="padding-left: 7px;">
                                    <input type="text" class="form_textbox" name="TextBox_CustomDocumentHealthHomeCommPlans_DentistName"
                                        id="TextBox_CustomDocumentHealthHomeCommPlans_DentistName" datatype="String"
                                        style="width: 270px" maxlength="300" />
                                </td>
                                <td width="37%">
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
                        <table cellspacing="0" cellpadding="0" border="0" width="100%">
                            <tr>
                                <td width="18%" class="LPadd8" style="text-align: right;">
                                    <span class="form_label" id="Span48">Telephone</span>
                                </td>
                                <td align="left" width="70%" valign="top">
                                    <span class="form_label" id="Span49">(</span>
                                    <input id="TextBox_CustomDocumentHealthHomeCommPlans_DentistPhone1" enabled="enabled"
                                        type="text" class="form_textbox" style="width: 6%" datatype="Numeric" maxlength="3"
                                        bindautosaveevents="False" onkeyup="return autoTab(this, 3, event);" onkeydown="AllowNumericOnly('TextBox_CustomDocumentHealthHomeCommPlans_DentistPhone1');"
                                        onblur="javascript:UpdatePhone('1','DentistPhone');" />
                                    <span class="form_label" id="Span50">)</span>
                                    <input id="TextBox_CustomDocumentHealthHomeCommPlans_DentistPhone2" enabled="enabled"
                                        type="text" class="form_textbox" onkeyup="return autoTab(this, 3, event);" style="width: 6%"
                                        datatype="Numeric" maxlength="3" bindautosaveevents="False" onblur="javascript:UpdatePhone('2','DentistPhone');"
                                        onkeydown="AllowNumericOnly('TextBox_CustomDocumentHealthHomeCommPlans_DentistPhone2');" />
                                    <span class="form_label" id="Span51">-</span>
                                    <input id="TextBox_CustomDocumentHealthHomeCommPlans_DentistPhone3" enabled="enabled"
                                        type="text" class="form_textbox" onkeyup="return autoTab(this, 4, event);" style="width: 8%"
                                        datatype="Numeric" maxlength="4" onkeydown="AllowNumericOnly('TextBox_CustomDocumentHealthHomeCommPlans_DentistPhone3');"
                                        bindautosaveevents="False" onblur="javascript:UpdatePhone('3','DentistPhone');" />
                                    <span class="form_label" id="Span52">Ext</span>
                                    <input id="TextBox_CustomDocumentHealthHomeCommPlans_DentistPhone4" enabled="enabled"
                                        type="text" class="form_textbox" onkeyup="return autoTab(this, 6, event);" style="width: 10%"
                                        datatype="Numeric" maxlength="6" bindautosaveevents="False" onblur="javascript:UpdatePhone('4','DentistPhone');"
                                        onkeydown="AllowNumericOnly('TextBox_CustomDocumentHealthHomeCommPlans_DentistPhone4');" />
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
                        <table cellspacing="0" cellpadding="0" border="0" width="100%">
                            <tr>
                                <td class="LPadd8" width="18%" style="text-align: right;">
                                    <span class="form_label" id="Span25">Fax</span>
                                </td>
                                <td style="width: 70%">
                                    <span class="form_label" id="Span26">(</span>
                                    <input id="TextBox_CustomDocumentHealthHomeCommPlans_DentistFax1" enabled="enabled"
                                        type="text" class="form_textbox" onblur="javascript:CheckFaxNumber('TextBox_CustomDocumentHealthHomeCommPlans_DentistFax1',3);"
                                        style="width: 6%" datatype="Numeric" maxlength="3" onkeyup="return autoTab(this, 3, event);"
                                        onkeydown="AllowNumericOnly('TextBox_CustomDocumentHealthHomeCommPlans_DentistFax1');"
                                        bindautosaveevents="False" />
                                    <span class="form_label" id="Span27">)</span>
                                    <input id="TextBox_CustomDocumentHealthHomeCommPlans_DentistFax2" enabled="enabled"
                                        type="text" class="form_textbox" onblur="javascript:CheckFaxNumber('TextBox_CustomDocumentHealthHomeCommPlans_DentistFax2',3);"
                                        style="width: 6%" datatype="Numeric" onkeyup="return autoTab(this, 3, event);"
                                        maxlength="3" onkeydown="AllowNumericOnly('TextBox_CustomDocumentHealthHomeCommPlans_DentistFax2');"
                                        bindautosaveevents="False" />
                                    <span class="form_label" id="Span28">-</span>
                                    <input id="TextBox_CustomDocumentHealthHomeCommPlans_DentistFax3" enabled="enabled"
                                        type="text" class="form_textbox" onblur="javascript:CheckFaxNumber('TextBox_CustomDocumentHealthHomeCommPlans_DentistFax3',4);"
                                        style="width: 8%" datatype="Numeric" onkeyup="return autoTab(this, 4, event);"
                                        maxlength="4" onkeydown="AllowNumericOnly('TextBox_CustomDocumentHealthHomeCommPlans_DentistFax3');"
                                        bindautosaveevents="False" />
                                    <span class="form_label" id="Span29">Ext</span>
                                    <input id="TextBox_CustomDocumentHealthHomeCommPlans_DentistFax4" enabled="enabled"
                                        type="text" class="form_textbox" onkeyup="return autoTab(this, 6, event);" style="width: 10%"
                                        datatype="Numeric" maxlength="6" bindautosaveevents="False" onblur="ValidateFax('TextBox_CustomDocumentHealthHomeCommPlans_DentistFax1','TextBox_CustomDocumentHealthHomeCommPlans_DentistFax2','TextBox_CustomDocumentHealthHomeCommPlans_DentistFax3','TextBox_CustomDocumentHealthHomeCommPlans_DentistFax4','DentistPhone');"
                                        onkeydown="AllowNumericOnly('TextBox_CustomDocumentHealthHomeCommPlans_DentistFax4');" />
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
    <tr>
        <td class="height2">
        </td>
    </tr>
    <tr>
        <td align="left">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class="content_tab_left" align="left" nowrap='nowrap'>
                        <span id="AdditionalSpecialtyProviders">Additional Specialty Providers</span>
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
        <td class="content_tab_bg" style="padding-left: 8px; padding-right: 5px">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td>
                        <!-- Table Parent Child Custom Grid Control for CustomDocumentHealthHomeCommPlanProviders -->
                        <table cellspacing="0" cellpasding="0" border="0" id="TableChildControl_CustomDocumentHealthHomeCommPlanProviders"
                            parentchildcontrols="True" clearcontrols="true">
                            <tr id="TableChildControl_CustomDocumentHealthHomeCommPlanProviders_DataRow">
                                <td>
                                    <!-- Primary and Foreign Keys -->
                                    <input type="hidden" id="HiddenField_CustomDocumentHealthHomeCommPlanProviders_HealthHomeCommPlanProviderId"
                                        name="HiddenField_CustomDocumentHealthHomeCommPlanProviders_HealthHomeCommPlanProviderId"
                                        parentchildcontrols="True" value="-1" />
                                    <input type="hidden" id="HiddenFieldPrimaryKeyHealthHomeCommPlanProviderId" name="HiddenFieldPrimaryKeyHealthHomeCommPlanProviderId"
                                        value="HealthHomeCommPlanProviderId" parentchildcontrols="True" />
                                    <input type="hidden" id="HiddenField_CustomDocumentHealthHomeCommPlanProviders_DocumentVersionId"
                                        name="HiddenField_CustomDocumentHealthHomeCommPlanProviders_DocumentVersionId"
                                        value="-1" />
                                    <input type="hidden" id="HiddenField_CustomDocumentHealthHomeCommPlanProviders_ProviderPhone"
                                        name="HiddenField_CustomDocumentHealthHomeCommPlanProviders_ProviderPhone" parentchildcontrols="True" />
                                    <input type="hidden" id="HiddenField_CustomDocumentHealthHomeCommPlanProviders_ProviderFax"
                                        name="HiddenField_CustomDocumentHealthHomeCommPlanProviders_ProviderFax" parentchildcontrols="True" />
                                    <table width="100%">
                                        <tr>
                                            <td colspan="4" style="width: 100%;">
                                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                    <tr>
                                                        <td width="15%"  align="left">
                                                            <span id="ProviderName" class="form_label_text">Provider Name</span>
                                                        </td>
                                                        <td align="left" width="85%" valign="top" style="padding-left: 10px;">
                                                            <input type="text" id="TextBox_CustomDocumentHealthHomeCommPlanProviders_ProviderName"
                                                                name="TextBox_CustomDocumentHealthHomeCommPlanProviders_ProviderName" bindautosaveevents="False"
                                                                parentchildcontrols="True" class="form_textbox element" maxlength="200" style="width: 270px;" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="4" class="height2">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td width="15%"  align="left">
                                                            <span id="ProviderSpeciality" class="form_label_text">Provider Specialty</span>
                                                        </td>
                                                        <td align="left" width="85%" valign="top" style="padding-left: 10px;">
                                                            <input id="TextBox_CustomDocumentHealthHomeCommPlanProviders_ProviderSpecialty" name="TextBox_CustomDocumentHealthHomeCommPlanProviders_ProviderSpecialty" bindautosaveevents="False"
                                                                parentchildcontrols="True" class="form_textbox element" maxlength="200" style="width: 270px;" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="4" class="height2">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td width="15%"  align="left">
                                                            <span class="form_label" id="Span16">Phone</span>
                                                        </td>
                                                        <td align="left" width="85%" valign="top">
                                                            <span class="form_label" id="Span21">(</span>
                                                            <input id="TextBox_CustomDocumentHealthHomeCommPlanProviders_ProviderPhone1" enabled="enabled"
                                                                type="text" class="form_textbox" style="width: 6%" datatype="Numeric" maxlength="3"
                                                                bindautosaveevents="False" onkeyup="return autoTab(this, 3, event);" onkeydown="AllowNumericOnly('TextBox_CustomDocumentHealthHomeCommPlanProviders_ProviderPhone1');"
                                                                onblur="javascript:UpdatePhone('1','Provider');" />
                                                            <span class="form_label" id="Span22">)</span>
                                                            <input id="TextBox_CustomDocumentHealthHomeCommPlanProviders_ProviderPhone2" enabled="enabled"
                                                                type="text" class="form_textbox" onkeyup="return autoTab(this, 3, event);" style="width: 6%"
                                                                datatype="Numeric" maxlength="3" bindautosaveevents="False" onblur="javascript:UpdatePhone('2','Provider');"
                                                                onkeydown="AllowNumericOnly('TextBox_CustomDocumentHealthHomeCommPlanProviders_ProviderPhone2');" />
                                                            <span class="form_label" id="Span31">-</span>
                                                            <input id="TextBox_CustomDocumentHealthHomeCommPlanProviders_ProviderPhone3" enabled="enabled"
                                                                type="text" class="form_textbox" onkeyup="return autoTab(this, 4, event);" style="width: 8%"
                                                                datatype="Numeric" maxlength="4" onkeydown="AllowNumericOnly('TextBox_CustomDocumentHealthHomeCommPlanProviders_ProviderPhone3');"
                                                                bindautosaveevents="False" onblur="javascript:UpdatePhone('3','Provider');" />
                                                            <span class="form_label" id="Span32">Ext</span>
                                                            <input id="TextBox_CustomDocumentHealthHomeCommPlanProviders_ProviderPhone4" enabled="enabled"
                                                                type="text" class="form_textbox" onkeyup="return autoTab(this, 6, event);" style="width: 10%"
                                                                datatype="Numeric" maxlength="6" bindautosaveevents="False" onblur="javascript:UpdatePhone('4','Provider');"
                                                                onkeydown="AllowNumericOnly('TextBox_CustomDocumentHealthHomeCommPlanProviders_ProviderPhone4');" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="4" class="height2">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td  width="15%" align="left" align="left">
                                                <span class="form_label" id="Span33">Fax</span>
                                            </td>
                                            <td style="width: 85%" valign="top">
                                                <span class="form_label" id="Span34">(</span>
                                                <input id="TextBox_CustomDocumentHealthHomeCommPlanProviders_ProviderFax1" enabled="enabled"
                                                    type="text" class="form_textbox" onblur="javascript:CheckFaxNumber('TextBox_CustomDocumentHealthHomeCommPlanProviders_ProviderFax1',3);"
                                                    style="width: 6%" datatype="Numeric" maxlength="3" onkeyup="return autoTab(this, 3, event);"
                                                    onkeydown="AllowNumericOnly('TextBox_CustomDocumentHealthHomeCommPlanProviders_ProviderFax1');"
                                                    bindautosaveevents="False" />
                                                <span class="form_label" id="Span35">)</span>
                                                <input id="TextBox_CustomDocumentHealthHomeCommPlanProviders_ProviderFax2" enabled="enabled"
                                                    type="text" class="form_textbox" onblur="javascript:CheckFaxNumber('TextBox_CustomDocumentHealthHomeCommPlanProviders_ProviderFax2',3);"
                                                    style="width: 6%" datatype="Numeric" onkeyup="return autoTab(this, 3, event);"
                                                    maxlength="3" onkeydown="AllowNumericOnly('TextBox_CustomDocumentHealthHomeCommPlanProviders_ProviderFax2');"
                                                    bindautosaveevents="False" />
                                                <span class="form_label" id="Span36">-</span>
                                                <input id="TextBox_CustomDocumentHealthHomeCommPlanProviders_ProviderFax3" enabled="enabled"
                                                    type="text" class="form_textbox" onblur="javascript:CheckFaxNumber('TextBox_CustomDocumentHealthHomeCommPlanProviders_ProviderFax3',4);"
                                                    style="width: 8%" datatype="Numeric" onkeyup="return autoTab(this, 4, event);"
                                                    maxlength="4" onkeydown="AllowNumericOnly('TextBox_CustomDocumentHealthHomeCommPlanProviders_ProviderFax3');"
                                                    bindautosaveevents="False" />
                                                <span class="form_label" id="Span37">Ext</span>
                                                <input id="TextBox_CustomDocumentHealthHomeCommPlanProviders_ProviderFax4" enabled="enabled"
                                                    type="text" class="form_textbox" onkeyup="return autoTab(this, 6, event);" style="width: 10%"
                                                    datatype="Numeric" maxlength="6" bindautosaveevents="False" onblur="ValidateFax('TextBox_CustomDocumentHealthHomeCommPlanProviders_ProviderFax1','TextBox_CustomDocumentHealthHomeCommPlanProviders_ProviderFax2','TextBox_CustomDocumentHealthHomeCommPlanProviders_ProviderFax3','TextBox_CustomDocumentHealthHomeCommPlanProviders_ProviderFax4','Provider');"
                                                    onkeydown="AllowNumericOnly('TextBox_CustomDocumentHealthHomeCommPlanProviders_ProviderFax4');" />
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align: right; padding: 5px;">
                                    <!-- Insert and Clear Buttons for the Parent Table Control -->
                                    <input type="button" id="TableChildControl_CustomDocumentHealthHomeCommPlanProviders_ButtonInsert"
                                        name="TableChildControl_CustomDocumentHealthHomeCommPlanProviders_ButtonInsert"
                                        baseurl="<%=ResolveUrl("~") %>" onclick="return InsertGrid_CustomDocumentHealthHomeCommPlanProvidersData('TableChildControl_CustomDocumentHealthHomeCommPlanProviders','InsertGrid_CustomDocumentHealthHomeCommPlanProviders','CustomGrid_CustomDocumentHealthHomeCommPlanProviders', this);"
                                        value="Insert" class="parentchildbutton" />
                                    <input type="button" id="ButtonClear" onclick="Clear_CustomDocumentHealthHomeCommPlanProviders_Data();"
                                        name="ButtonClear" value="Clear" class="parentchildbutton" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <!-- Parent Child Control Custom Grid -->
                                    <div id="InsertGrid_CustomDocumentHealthHomeCommPlanProviders" style="overflow-x: hidden;
                                        overflow-y: auto; height: 100px; width: 800px;">
                                        <uc1:CustomGrid ID="CustomGrid_CustomDocumentHealthHomeCommPlanProviders" runat="server"
                                            TableName="CustomDocumentHealthHomeCommPlanProviders" PrimaryKey="HealthHomeCommPlanProviderId"
                                            CustomGridTableName="TableChildControl_CustomDocumentHealthHomeCommPlanProviders"
                                            GridPageName="CustomDocumentHealthHomeCommPlanProviders_Grid" ColumnName="ProviderName:ProviderSpecialty:ProviderPhone:ProviderFax"
                                            ColumnHeader="Provider Name:Specialty:Phone:Fax" ColumnWidth="170:170:170:150"
                                            DivGridName="InsertGrid_CustomDocumentHealthHomeCommPlanProviders" InsertButtonId="TableChildControl_CustomDocumentHealthHomeCommPlanProviders_ButtonInsert"
                                            OrderByQuery="ProviderName" />
                                    </div>
                                </td>
                            </tr>
                        </table>
                        <!-- End of Parent Child control table -->
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
    <tr>
        <td class="height2">
        </td>
    </tr>
    <tr>
        <td align="left">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class="content_tab_left" align="left" nowrap='nowrap'>
                        <span id="AdditionalFacilityProviders">Additional Facility Providers</span>
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
        <td class="content_tab_bg" style="padding-left: 8px; padding-right: 5px">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td >
                        <table style="width: 100%" cellspacing="0" cellpadding="0" border="0">
                            <tr>
                                <td style="width: 30%">
                                    <label for="TextBox_CustomDocumentHealthHomeCommPlans_LongTermCareFacility" class="form_label">
                                        Long Term Care Facility</label>
                                </td>
                                <td style="width: 30%">
                                    <input type="text" id="TextBox_CustomDocumentHealthHomeCommPlans_LongTermCareFacility"
                                        style="width: 80%;" name="TextBox_CustomDocumentHealthHomeCommPlans_LongTermCareFacility"
                                        class="form_textbox element" maxlength="200" />
                                </td>
                                <td style="width: 2%">
                                    <input type="checkbox" id="CheckBox_CustomDocumentHealthHomeCommPlans_LongTermCareFacilityNA" onclick="DisableTextbox(this,'TextBox_CustomDocumentHealthHomeCommPlans_LongTermCareFacility');"
                                        name="CheckBox_CustomDocumentHealthHomeCommPlans_LongTermCareFacilityNA" class="form_checkbox element YorN" />
                                </td>
                                <td style="width: 38%">
                                    <label for="CheckBox_CustomDocumentHealthHomeCommPlans_LongTermCareFacilityNA" style="vertical-align: top;"
                                        class="form_label">
                                        N/A</label></td>
                            </tr>
                            <tr>
                                <td colspan="4" class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 30%">
                                    <label for="TextBox_CustomDocumentHealthHomeCommPlans_AODRehabFacility" class="form_label">
                                        AOD Rehabiliation Facility</label>
                                </td>
                                <td style="width: 30%">
                                    <input type="text" id="TextBox_CustomDocumentHealthHomeCommPlans_AODRehabFacility"
                                        style="width: 80%;" maxlength="200" name="TextBox_CustomDocumentHealthHomeCommPlans_AODRehabFacility"
                                        class="form_textbox element" />
                                </td>
                                <td style="width: 2%">
                                    <input type="checkbox" id="CheckBox_CustomDocumentHealthHomeCommPlans_AODRehabFacilityNA"
                                        name="CheckBox_CustomDocumentHealthHomeCommPlans_AODRehabFacilityNA" class="form_checkbox element YorN" onclick="DisableTextbox(this,'TextBox_CustomDocumentHealthHomeCommPlans_AODRehabFacility');" />
                                </td>
                                <td style="width: 38%">
                                    <label for="CheckBox_CustomDocumentHealthHomeCommPlans_AODRehabFacilityNA" style="vertical-align: top;"
                                        class="form_label">
                                        N/A</label></td>
                            </tr>
                            <tr>
                                <td colspan="4" class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 30%">
                                    <label for="TextBox_CustomDocumentHealthHomeCommPlans_PreferredHospital" class="form_label">
                                        Preferred Hospital</label>
                                </td>
                                <td style="width: 30%">
                                    <input type="text" id="TextBox_CustomDocumentHealthHomeCommPlans_PreferredHospital"
                                        maxlength="200" style="width: 80%;" name="TextBox_CustomDocumentHealthHomeCommPlans_PreferredHospital"
                                        class="form_textbox element" />
                                </td>
                                <td style="width: 2%">
                                </td>
                                <td style="width: 38%">
                                </td>
                            </tr>
                            <tr>
                                <td colspan="4" class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 30%">
                                    <label for="TextBox_CustomDocumentHealthHomeCommPlans_PreferredPsychHospital" class="form_label">
                                        Preferred Psychiatric Hospital</label>
                                </td>
                                <td style="width: 30%">
                                    <input type="text" id="TextBox_CustomDocumentHealthHomeCommPlans_PreferredPsychHospital"
                                        maxlength="200" style="width: 80%;" name="TextBox_CustomDocumentHealthHomeCommPlans_PreferredPsychHospital"
                                        class="form_textbox element" />
                                </td>
                                <td style="width: 2%">
                                    <input type="checkbox" id="CheckBox_CustomDocumentHealthHomeCommPlans_PreferredPsychHospitalNA" onclick="DisableTextbox(this,'TextBox_CustomDocumentHealthHomeCommPlans_PreferredPsychHospital');"
                                        name="CheckBox_CustomDocumentHealthHomeCommPlans_PreferredPsychHospitalNA" class="form_checkbox element YorN" />
                                </td>
                                <td style="width: 38%">
                                    <label for="CheckBox_CustomDocumentHealthHomeCommPlans_PreferredPsychHospitalNA"
                                        style="vertical-align: top;" class="form_label">
                                        N/A</label>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="4" class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 30%">
                                    <label for="TextBox_CustomDocumentHealthHomeCommPlans_PreferredCMHProvider" class="form_label">
                                        Preferred Community Mental Health Provider</label>
                                </td>
                                <td style="width: 30%">
                                    <input type="text" id="TextBox_CustomDocumentHealthHomeCommPlans_PreferredCMHProvider"
                                        maxlength="200" style="width: 80%;" name="TextBox_CustomDocumentHealthHomeCommPlans_PreferredCMHProvider"
                                        class="form_textbox element" />
                                </td>
                                <td style="width: 2%">
                                </td>
                                <td style="width: 38%">
                                </td>
                            </tr>
                            <tr>
                                <td colspan="4" class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 30%">
                                    <label for="TextArea_CustomDocumentHealthHomeCommPlans_SpecialCommentsRegardingProviders"
                                        class="form_label">
                                        Special Comments Regarding Providers</label>
                                </td>
                                <td style="width: 30%">
                                    <textarea id="TextArea_CustomDocumentHealthHomeCommPlans_SpecialCommentsRegardingProviders"
                                        name="TextArea_CustomDocumentHealthHomeCommPlans_SpecialCommentsRegardingProviders"
                                        class="form_textbox element" style="width: 80%; height: 40px;"></textarea>
                                </td>
                                <td style="width: 2%">
                                </td>
                                <td style="width: 38%">
                                </td>
                            </tr>
                            <tr>
                                <td colspan="4" class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 30%">
                                    <label for="<%=DropDownList_CustomDocumentHealthHomeCommPlans_MedicaidManagedCarePlan %>"
                                        class="form_label">
                                        Medicaid Managed Care Plan</label>
                                </td>
                                <td style="width: 30%">
                                    <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentHealthHomeCommPlans_MedicaidManagedCarePlan"
                                        Width="210px" runat="server">
                                    </cc2:StreamlineDropDowns>
                                </td>
                                <td style="width: 2%">
                                    <input type="checkbox" id="CheckBox_CustomDocumentHealthHomeCommPlans_MedicaidManagedCarePlanNA" onclick="DisableTextbox(this,'DropDownList_CustomDocumentHealthHomeCommPlans_MedicaidManagedCarePlan');"
                                        name="CheckBox_CustomDocumentHealthHomeCommPlans_MedicaidManagedCarePlanNA" class="form_checkbox element YorN" />
                                </td>
                                <td style="width: 38%">
                                    <label for="CheckBox_CustomDocumentHealthHomeCommPlans_MedicaidManagedCarePlanNA"
                                        style="vertical-align: top;" class="form_label">
                                        N/A</label>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="4">
                                    <span id="ManagedMedicaid" class="form_label">( This entity will provide A Renewed Mind with
                                        information regarding your treatment outside A Renewed Mind and A Renewed Mind will report information
                                        to this entity regarding your treatment. )</span>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="4" class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 30%">
                                    <label for="TextBox_CustomDocumentHealthHomeCommPlans_LegalGuardians" class="form_label">
                                        Guardian/Legally Authorized Representative</label>
                                </td>
                                <td style="width: 30%">
                                    <input type="text" id="TextBox_CustomDocumentHealthHomeCommPlans_LegalGuardians"
                                        maxlength="200" style="width: 80%;" name="TextBox_CustomDocumentHealthHomeCommPlans_LegalGuardians"
                                        class="form_textbox element" />
                                </td>
                                <td style="width: 2%">
                                </td>
                                <td style="width: 38%">
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
    <tr>
        <td class="height2">
        </td>
    </tr>
    <tr>
        <td align="left">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class="content_tab_left" align="left" nowrap='nowrap'>
                        <span id="FamilyCollaboration">Family Collaboration</span>
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
        <td class="content_tab_bg" style="padding-left: 10px; padding-right: 5px">
            <!-- Table Parent Child Custom Grid Control for CustomDocumentHealthHomeCommPlanFamilyMembers -->
            <table cellspacing="0" cellpasding="0" border="0" id="TableChildControl_CustomDocumentHealthHomeCommPlanFamilyMembers"
                parentchildcontrols="True" clearcontrols="true" width="800px;">
                <tr id="TableChildControl_CustomDocumentHealthHomeCommPlanFamilyMembers_DataRow">
                    <td>
                        <!-- Primary and Foreign Keys -->
                        <table cellspacing="0" cellpadding="0" border="0" width="100%">
                            <tr>
                                <td colspan="2" >
                                    NOTE: A signed authorization for disclosure may be required for collaboration with
                                    the partners listed below. This form does not replace a legally valid Authorization
                                    for Disclosure form.
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td width="15%" align="left" >
                                    <label for="TextBox_CustomDocumentHealthHomeCommPlanFamilyMembers_FamilyMemberName"
                                        class="form_label">
                                        Family Member Name</label>
                                </td>
                                <td align="left" width="85%" valign="top" style="padding-left: 9px;">
                                    <input type="text" id="TextBox_CustomDocumentHealthHomeCommPlanFamilyMembers_FamilyMemberName"
                                        maxlength="300" style="width: 275px;" name="TextBox_CustomDocumentHealthHomeCommPlanFamilyMembers_FamilyMemberName"
                                        bindautosaveevents="False" includeinparentchildxml="true" parentchildcontrols="True"
                                        class="form_textbox element" />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" class="height2">
                                    <input type="hidden" id="HiddenField_CustomDocumentHealthHomeCommPlanFamilyMembers_HealthHomeCommPlanFamilyMemberId"
                                        name="HiddenField_CustomDocumentHealthHomeCommPlanFamilyMembers_HealthHomeCommPlanFamilyMemberId"
                                        parentchildcontrols="True" includeinparentchildxml="true" value="-1" />
                                    <input type="hidden" id="HiddenFieldPrimaryKeyHealthHomeCommPlanFamilyMemberId" name="HiddenFieldPrimaryKeyHealthHomeCommPlanFamilyMemberId"
                                        value="HealthHomeCommPlanFamilyMemberId" parentchildcontrols="True" />
                                    <input type="hidden" id="HiddenField_CustomDocumentHealthHomeCommPlanFamilyMembers_DocumentVersionId"
                                        name="HiddenField_CustomDocumentHealthHomeCommPlanFamilyMembers_DocumentVersionId"
                                        value="-1" parentchildcontrols="True" />
                                    <input type="hidden" id="HiddenField_CustomDocumentHealthHomeCommPlanFamilyMembers_FamilyMemberPhone"
                                        name="HiddenField_CustomDocumentHealthHomeCommPlanFamilyMembers_FamilyMemberPhone"
                                        parentchildcontrols="True" includeinparentchildxml="true" />
                                </td>
                            </tr>
                            <tr>
                                <td width="15%" align="left" >
                                    <span class="form_label" id="Span38">Phone</span>
                                </td>
                                <td align="left" width="85%" valign="top">
                                    <span class="form_label" id="Span39">(</span>
                                    <input id="TextBox_CustomDocumentHealthHomeCommPlanFamilyMembers_FamilyMemberPhone1"
                                        enabled="enabled" type="text" class="form_textbox" style="width: 6%" datatype="Numeric"
                                        maxlength="3" bindautosaveevents="False" onkeyup="return autoTab(this, 3, event);"
                                        onkeydown="AllowNumericOnly('TextBox_CustomDocumentHealthHomeCommPlanFamilyMembers_FamilyMemberPhone1');"
                                        onblur="javascript:UpdatePhone('1','FamilyMember');" />
                                    <span class="form_label" id="Span40">)</span>
                                    <input id="TextBox_CustomDocumentHealthHomeCommPlanFamilyMembers_FamilyMemberPhone2"
                                        enabled="enabled" type="text" class="form_textbox" onkeyup="return autoTab(this, 3, event);"
                                        style="width: 6%" datatype="Numeric" maxlength="3" bindautosaveevents="False"
                                        onblur="javascript:UpdatePhone('2','FamilyMember');" onkeydown="AllowNumericOnly('TextBox_CustomDocumentHealthHomeCommPlanFamilyMembers_FamilyMemberPhone2');" />
                                    <span class="form_label" id="Span41">-</span>
                                    <input id="TextBox_CustomDocumentHealthHomeCommPlanFamilyMembers_FamilyMemberPhone3"
                                        enabled="enabled" type="text" class="form_textbox" onkeyup="return autoTab(this, 4, event);"
                                        style="width: 8%" datatype="Numeric" maxlength="4" onkeydown="AllowNumericOnly('TextBox_CustomDocumentHealthHomeCommPlanFamilyMembers_FamilyMemberPhone3');"
                                        bindautosaveevents="False" onblur="javascript:UpdatePhone('3','FamilyMember');" />
                                    <span class="form_label" id="Span42">Ext</span>
                                    <input id="TextBox_CustomDocumentHealthHomeCommPlanFamilyMembers_FamilyMemberPhone4"
                                        enabled="enabled" type="text" class="form_textbox" onkeyup="return autoTab(this, 6, event);"
                                        style="width: 10%" datatype="Numeric" maxlength="6" bindautosaveevents="False"
                                        onblur="javascript:UpdatePhone('4','FamilyMember');" onkeydown="AllowNumericOnly('TextBox_CustomDocumentHealthHomeCommPlanFamilyMembers_FamilyMemberPhone4');" />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" style="text-align: right; padding-right: 100px;">
                                    <!-- Insert and Clear Buttons for the Parent Table Control -->
                                    <input type="button" id="TableChildControl_CustomDocumentHealthHomeCommPlanFamilyMembers_ButtonInsert"
                                        name="TableChildControl_CustomDocumentHealthHomeCommPlanFamilyMembers_ButtonInsert"
                                        baseurl="<%=ResolveUrl("~") %>" onclick="return InsertGrid_CustomDocumentHealthHomeCommPlanFamilyMembersData('TableChildControl_CustomDocumentHealthHomeCommPlanFamilyMembers','InsertGrid_CustomDocumentHealthHomeCommPlanFamilyMembers','CustomGrid_CustomDocumentHealthHomeCommPlanFamilyMembers', this);"
                                        value="Insert" class="parentchildbutton" />
                                    <input type="button" id="Button1" onclick="Clear_CustomDocumentHealthHomeCommPlanFamilyMembers_Data();"
                                        name="ButtonClear" value="Clear" class="parentchildbutton" />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" >
                                    <!-- Parent Child Control Custom Grid -->
                                    <div id="InsertGrid_CustomDocumentHealthHomeCommPlanFamilyMembers" style="overflow-x: hidden;
                                        overflow-y: auto; height: 100px; width: 800px;">
                                        <uc1:CustomGrid ID="CustomGrid_CustomDocumentHealthHomeCommPlanFamilyMembers" runat="server"
                                            TableName="CustomDocumentHealthHomeCommPlanFamilyMembers" PrimaryKey="HealthHomeCommPlanFamilyMemberId"
                                            CustomGridTableName="TableChildControl_CustomDocumentHealthHomeCommPlanFamilyMembers"
                                            GridPageName="CustomDocumentHealthHomeCommPlanFamilyMembers_Grid" ColumnName="FamilyMemberName:FamilyMemberPhone"
                                            ColumnHeader="Family Member Name:Phone" ColumnWidth="343:343" DivGridName="InsertGrid_CustomDocumentHealthHomeCommPlanFamilyMembers"
                                            InsertButtonId="TableChildControl_CustomDocumentHealthHomeCommPlanFamilyMembers_ButtonInsert"
                                            OrderByQuery="FamilyMemberName" />
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
            <!-- End of Parent Child control table -->
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
    <tr>
        <td class="height2">
        </td>
    </tr>
    <tr>
        <td align="left">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class="content_tab_left" align="left" nowrap='nowrap'>
                        <span id="SocialSupports">Social Supports</span>
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
        <td class="content_tab_bg" style="padding-left: 8px; padding-right: 5px">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td >
                        <!-- Table Parent Child Custom Grid Control for CustomDocumentHealthHomeCommPlanSocialSupports -->
                        <table cellspacing="0" cellpadding="0" border="0" id="TableChildControl_CustomDocumentHealthHomeCommPlanSocialSupports"
                            parentchildcontrols="True" clearcontrols="true">
                            <tr id="TableChildControl_CustomDocumentHealthHomeCommPlanSocialSupports_DataRow">
                                <td>
                                    <!-- Primary and Foreign Keys -->
                                    <%--<input type="hidden" id="HiddenField_CustomDocumentHealthHomeCommPlanSocialSupports_CreatedBy" name="HiddenField_CustomDocumentHealthHomeCommPlanSocialSupports_CreatedBy" bindautosaveevents="False" parentchildcontrols="True" />
                                                     <input type="hidden" id="HiddenField_CustomDocumentHealthHomeCommPlanSocialSupports_CreatedDate" name="HiddenField_CustomDocumentHealthHomeCommPlanSocialSupports_CreatedDate" bindautosaveevents="False" parentchildcontrols="True" />
                                                     <input type="hidden" id="HiddenField_CustomDocumentHealthHomeCommPlanSocialSupports_ModifiedBy" name="HiddenField_CustomDocumentHealthHomeCommPlanSocialSupports_ModifiedBy" bindautosaveevents="False" parentchildcontrols="True" />
                                                     <input type="hidden" id="HiddenField_CustomDocumentHealthHomeCommPlanSocialSupports_ModifiedDate" name="HiddenField_CustomDocumentHealthHomeCommPlanSocialSupports_ModifiedDate" bindautosaveevents="False" parentchildcontrols="True" />--%>
                                    <input type="hidden" id="HiddenField_CustomDocumentHealthHomeCommPlanSocialSupports_HealthHomeCommPlanSocialSupportId"
                                        name="HiddenField_CustomDocumentHealthHomeCommPlanSocialSupports_HealthHomeCommPlanSocialSupportId"
                                        parentchildcontrols="True" value="-1" />
                                    <input type="hidden" id="HiddenFieldPrimaryKeyHealthHomeCommPlanSocialSupportId"
                                        name="HiddenFieldPrimaryKeyHealthHomeCommPlanSocialSupportId" value="HealthHomeCommPlanSocialSupportId"
                                        parentchildcontrols="True" />
                                    <input type="hidden" id="HiddenField_CustomDocumentHealthHomeCommPlanSocialSupports_DocumentVersionId"
                                        name="HiddenField_CustomDocumentHealthHomeCommPlanSocialSupports_DocumentVersionId"
                                        value="-1" parentchildcontrols="True" />
                                    <!-- Columns defined in the table and used inside the Parent Child Control -->
                                    <table style="width: 100%;" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td style="width: 20%;">
                                                <label for="TextBox_CustomDocumentHealthHomeCommPlanSocialSupports_SupportName" class="form_label">
                                                    Name of Entity</label>
                                            </td>
                                            <td style="width: 80%;">
                                                <input type="text" id="TextBox_CustomDocumentHealthHomeCommPlanSocialSupports_SupportName"
                                                    style="width: 50%;" name="TextBox_CustomDocumentHealthHomeCommPlanSocialSupports_SupportName"
                                                    bindautosaveevents="False" includeinparentchildxml="true" parentchildcontrols="True"
                                                    class="form_textbox element" maxlength="300" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" class="height2">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 20%;">
                                                <label for="TextArea_CustomDocumentHealthHomeCommPlanSocialSupports_PurposeOfCollaboration"
                                                    class="form_label">
                                                    Purpose/Goal of Collaboration</label>
                                            </td>
                                            <td style="width: 80%;">
                                                <textarea id="TextArea_CustomDocumentHealthHomeCommPlanSocialSupports_PurposeOfCollaboration"
                                                    name="TextArea_CustomDocumentHealthHomeCommPlanSocialSupports_PurposeOfCollaboration"
                                                    bindautosaveevents="False" includeinparentchildxml="true" parentchildcontrols="True"
                                                    class="form_textbox element" style="width: 50%; height: 40px;"></textarea>
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
                                <td style="text-align: right; padding-right: 5px;">
                                    <!-- Insert and Clear Buttons for the Parent Table Control -->
                                    <input type="button" id="TableChildControl_CustomDocumentHealthHomeCommPlanSocialSupports_ButtonInsert"
                                        name="TableChildControl_CustomDocumentHealthHomeCommPlanSocialSupports_ButtonInsert"
                                        baseurl="<%=ResolveUrl("~") %>" onclick="return InsertGrid_CustomDocumentHealthHomeCommPlanSocialSupportsData('TableChildControl_CustomDocumentHealthHomeCommPlanSocialSupports','InsertGrid_CustomDocumentHealthHomeCommPlanSocialSupports','CustomGrid_CustomDocumentHealthHomeCommPlanSocialSupports', this);"
                                        value="Insert" class="parentchildbutton" />
                                    <input type="button" id="Button2" onclick="Clear_CustomDocumentHealthHomeCommPlanSocialSupports_Data();"
                                        name="ButtonClear" value="Clear" class="parentchildbutton" />
                                </td>
                            </tr>
                             <tr>
                                <td  class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <!-- Parent Child Control Custom Grid -->
                                    <div id="InsertGrid_CustomDocumentHealthHomeCommPlanSocialSupports" style="overflow-x: hidden;
                                        overflow-y: auto; height: 100px; width: 800px;">
                                        <uc1:CustomGrid ID="CustomGrid_CustomDocumentHealthHomeCommPlanSocialSupports" runat="server"
                                            TableName="CustomDocumentHealthHomeCommPlanSocialSupports" PrimaryKey="HealthHomeCommPlanSocialSupportId"
                                            CustomGridTableName="TableChildControl_CustomDocumentHealthHomeCommPlanSocialSupports"
                                            GridPageName="CustomDocumentHealthHomeCommPlanSocialSupports_Grid" ColumnName="SupportName:PurposeOfCollaboration"
                                            ColumnHeader="Support Name:Purpose Of Collaboration" ColumnWidth="343:343" DivGridName="InsertGrid_CustomDocumentHealthHomeCommPlanSocialSupports"
                                            InsertButtonId="TableChildControl_CustomDocumentHealthHomeCommPlanSocialSupports_ButtonInsert"
                                            OrderByQuery="SupportName" />
                                    </div>
                                </td>
                            </tr>
                        </table>
                        <!-- End of Parent Child control table -->
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
    <tr>
        <td class="height2">
        </td>
    </tr>
    <tr>
        <td class="height2">
        </td>
    </tr>
    <tr>
        <td align="left">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class="content_tab_left" align="left" nowrap='nowrap'>
                        <span id="ClientParticipation">Client Participation</span>
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
                    <td style="padding-left: 5px; padding-right: 5px">
                        <table style="width: 100%;">
                            <tr>
                                <td valign="top">
                                    <input type="radio" id="RadioButton_CustomDocumentHealthHomeCommPlans_ClientGuardianParticipatedInPlan_Y"
                                        name="RadioButton_CustomDocumentHealthHomeCommPlans_ClientGuardianParticipatedInPlan"
                                        class="form_checkbox element YorN" value="Y" />
                                </td>
                                <td>
                                    <label id="CustomDocumentHealthHomeCommPlans_ClientGuardianParticipatedInPlan_Y"
                                        class="form_label" style="text-align: justify;">
                                        Client/Guardian participated in the development of this communication plan and
                                        provided the information listed above in order for A Renewed Mind to collaborate/communicate
                                        with these partners.</label>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td valign="top">
                                    <input type="radio" id="RadioButton_CustomDocumentHealthHomeCommPlans_ClientGuardianParticipatedInPlan_N"
                                        name="RadioButton_CustomDocumentHealthHomeCommPlans_ClientGuardianParticipatedInPlan"
                                        class="form_checkbox element YorN" value="N" />
                                </td>
                                <td>
                                    <label id="CustomDocumentHealthHomeCommPlans_ClientGuardianParticipatedInPlan_N"
                                        class="form_label" style="text-align: justify;">
                                        Client/Guardian chose not to provide information regarding other health providers,
                                        social supports, family members, significant others which would be necessary for
                                        A Renewed Mind to collaborate/communicate with these partners. The client/guardian indicates
                                        understanding that failing to do so may reduce Harbor’s ability to provide key components
                                        of the Health Home Services and may result in decreased health outcomes. (This option
                                        is selected for refusal to provide information, not for lack of information.)</label>
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
    <tr>
        <td class="height2">
        </td>
    </tr>
    <tr>
        <td>
            <input id="HiddenField_CustomDocumentHealthHomeCommPlans_DocumentVersionId" name="HiddenField_CustomDocumentHealthHomeCommPlans_DocumentVersionId"
                type="hidden" />
            <input id="HiddenFieldPageTables" runat="server" name="HiddenFieldPageTables" type="hidden"
                value="CustomDocumentHealthHomeCommPlans" />
        </td>
    </tr>
</table>
