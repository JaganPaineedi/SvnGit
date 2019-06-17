<%@ Control Language="C#" AutoEventWireup="true" CodeFile="RegistrationDocumentInsurance.ascx.cs"
    Inherits="RegistrationDocumentInsurance" %>
<%@ Register Assembly="Streamline.DotNetDropDownGlobalCodes" Namespace="Streamline.DotNetDropDownGlobalCodes"
    TagPrefix="DropDownGlobalCodes" %>
<%@ Register Assembly="Streamline.DotNetDropDowns" Namespace="Streamline.DotNetDropDowns"
    TagPrefix="DotNetDropDowns" %>
<%@ Register Src="~/CommonUserControls/VerifyEligibility.ascx" TagName="VerifyEligibility"
    TagPrefix="uc1" %>
<style type="text/css">
    .auto-style1
    {
        width: 26%;
    }
</style>
<div class="DocumentScreen" style="overflow-y: auto; height: 450px">
    <table cellspacing="0" cellpadding="0" border="0" width="99%" id="tblInquiryOtherInfo">
        <tr>
            <td>
                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                    <tr>
                        <td>
                            <uc1:VerifyEligibility runat="server" ID="eev1" />
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td colspan="6" align="right" style="padding-right: 10px">
                <div style="float: right; margin-top: 3px">
                    <table border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td>
                                <div class="glow_lt">
                                    &nbsp;
                                </div>
                            </td>
                            <td>
                                <div class="glow_mid">
                                    <input type="button" id="Button_Cards" name="Button_Cards" value="Scan Insurance Card"
                                        onclick="ScanBtnClick('<%=SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.Client.ClientId%>');return false;" />
                                </div>
                            </td>
                            <td>
                                <div class="glow_rt">
                                    &nbsp;
                                </div>
                            </td>
                            <td style="width: 20px">
                            </td>
                        </tr>
                    </table>
                </div>
            </td>
        </tr>
        <tr>
            <td>
                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                    <tr>
                        <td class="content_tab_left" align="left" nowrap='nowrap'>
                            Coverage Information
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
            <td class="content_tab_bg">
                <table border="0" cellpadding="3" cellspacing="3" width="100%" id="tableid">
                   <tr>
                       <td align="left" style="width: 26%;">
                                                    <span class="form_label" id="Span17">&nbsp;Medicaid</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                    <input style="height: 13px; padding: 0; margin: 0; vertical-align: bottom; position: relative; top: -1px; *overflow: hidden; left: 0px;" type="radio" id="RadioButton_CustomDocumentRegistrations_Medicaid_Y"
                                                        name="RadioButton_CustomDocumentRegistrations_Medicaid" value="Y" />
                                                    <label id="spanYes" for="RadioButton_CustomDocumentRegistrations_Medicaid_Y">
                                                        Yes&nbsp; </label>
                                                    &nbsp;<input style="height: 13px; padding: 0; margin: 0; vertical-align: bottom; position: relative; top: -1px; *overflow: hidden; left: 0px;" type="radio" id="RadioButton_CustomDocumentRegistrations_Medicaid_N"
                                                        name="RadioButton_CustomDocumentRegistrations_Medicaid" value="N" />
                                                    <label id="spanNo" for="RadioButton_CustomDocumentRegistrations_Medicaid_N">
                                                        No</label>
                                                </td>
                   </tr>
                    <tr>
                       <td class="auto-style1">
                                    </td>
                    </tr>
                     <tr>
                        <%--<td style="white-space: nowrap; padding-left: 10px; width: 3%">
                        </td>--%>
                        <td style="white-space: nowrap; padding-left: 30px" class="auto-style1">
                            <b><u>Plan</u></b>
                        </td>
                        <td style="white-space: nowrap; width: 14%">
                            <b><u>Insured ID</u></b>
                        </td>
                        <td style="white-space: nowrap; width: 19%">
                            <b><u>Group ID</u></b>
                        </td>
                        <td style="white-space: nowrap; width: 20%">
                            <b><u>Comment</u></b>
                        </td>
                    </tr>
                </table>
                <table id="appointmentContainer" border="0" cellpadding="3" cellspacing="3" width="100%">
                </table>
                <table border="0" cellpadding="3" cellspacing="3" width="100%">
                    <tr>
                        <td align="right" style="white-space: nowrap; width: 100%; padding-right: 10px">
                            <span type="button" text="Add" onclick="return AddNewCoverageInformation();"></span>
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
            <td colspan="6" align="right" style="padding-right: 10px">
                <div style="float: right; margin-top: 3px">
                    <table border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td>
                                <div class="glow_lt">
                                    &nbsp;
                                </div>
                            </td>
                            <td>
                                <div class="glow_mid">
                                    <input type="button" id="Button_ScanIncomeCard" name="Button_ScanIncomeCard" value="Scan Income Information"
                                        onclick="OpenPage(5765, 23, 'ClientID=<%=SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.Client.ClientId%>', null, <%=RelativePath%>, null, null, null, null, null, null);" />
                                </div>
                            </td>
                            <td>
                                <div class="glow_rt">
                                    &nbsp;
                                </div>
                            </td>
                            <td style="width: 20px">
                            </td>
                        </tr>
                    </table>
                </div>
            </td>
        </tr>
        <tr>
            <td style="padding-top: 10px">
                <table cellspacing="0" cellpadding="0" border="0">
                    <tr>
                        <td class="content_tab_left" align="left" nowrap='nowrap'>
                            <span class="form_label" id="Span20">Income/Fee</span>
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
                <table cellspacing="0" cellpadding="0" border="0" width="99%">
                    <tr>
                        <td style="padding-top: 10px">
                            <table cellspacing="0" cellpadding="0" border="0">
                                <tr>
                                    <td class="content_tab_left" align="left" nowrap='nowrap'>
                                        <span class="form_label" id="Span1">General</span>
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
                            <table cellspacing="0" cellpadding="0" border="0" width="90%">
                                <tr>
                                    <td class="checkbox_container" colspan="4">
                                        <input type="checkbox" id="CheckBox_CustomDocumentRegistrations_HeadOfHousehold" />
                                        <label for="CheckBox_CustomDocumentRegistrations_HeadOfHousehold">
                                            Head of household</label>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 15%;">
                                        <%--<span id="Span17">Residence Type</span>--%>
                                    </td>
                                    <td style="width: 30%;">
                                        <%--<DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentRegistrations_ResidenceType"
                                            runat="server" Category="XRESIDENCETYPE" AddBlankRow="true" CssClass="form_dropdown">
                                        </DropDownGlobalCodes:DropDownGlobalCodes>--%>
                                    </td>
                                    <%--<td style="width: 5%;">
                                    </td>--%>
                                    <td style="width: 25%;">
                                        <span id="Span_EmergencyContact">Household Composition</span>
                                    </td>
                                    <td style="width: 30%;">
                                        <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentRegistrations_HouseholdComposition"
                                            runat="server" Category="XINQUIRYHOUSEHOLD" AddBlankRow="true" CssClass="form_dropdown">
                                        </DropDownGlobalCodes:DropDownGlobalCodes>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 15%;">
                                        <span id="Span3"># in Household</span>
                                    </td>
                                    <td style="width: 30%;">
                                        <input id="TextBox_CustomDocumentRegistrations_NumberInHousehold" name="TextBox_CustomDocumentRegistrations_NumberInHousehold"
                                            type="text" class="form_textbox" style="width: 60px;" datatype="Numeric" maxlength="8"/>
                                    </td>
                                    <%--<td style="width: 5%;">
                                    </td>--%>
                                    <td style="width: 25%;">
                                        <span id="Span2"># of Dependents</span>
                                    </td>
                                    <td style="width: 30%;">
                                        <input id="TextBox_CustomDocumentRegistrations_DependentsInHousehold" name="TextBox_CustomDocumentRegistrations_DependentsInHousehold"
                                            type="text" class="form_textbox" style="width: 75px;" datatype="Numeric" maxlength="8"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 15%;">
                                        <span id="Span5">Client Annual Income</span>
                                    </td>
                                    <td style="width: 30%;">
                                        <input id="TextBox_CustomDocumentRegistrations_ClientAnnualIncome" name="TextBox_CustomDocumentRegistrations_ClientAnnualIncome"
                                            type="text" class="form_textbox" style="width: 100px;" datatype="Currency" onblur="CalculateIncome(this)" maxlength="15"/>
                                    </td>
                                    
                                    <td style="width: 25%;">
                                        <span id="Span4">Gross Household Annual Income</span>
                                    </td>
                                    <td style="width: 30%;">
                                        <input id="TextBox_CustomDocumentRegistrations_HouseholdAnnualIncome" name="TextBox_CustomDocumentRegistrations_HouseholdAnnualIncome"
                                            type="text" class="form_textbox" style="width: 100px;" datatype="Currency" maxlength="15"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 17%;">
                                        <span id="Span7">Client Monthly Income</span>
                                    </td>
                                    <td style="width: 28%;">
                                        <input id="TextBox_CustomDocumentRegistrations_ClientMonthlyIncome" name="TextBox_CustomDocumentRegistrations_ClientMonthlyIncome"
                                            type="text" class="form_textbox" style="width: 100px;" datatype="Currency" onblur="CalculateIncome(this)" maxlength="15"/>
                                    </td>
                                    <%--<td style="width: 5%;">
                                    </td>--%>
                                    <td style="width: 25%;">
                                        <span id="Span6">Primary Source</span>
                                    </td>
                                    <td style="width: 30%;">
                                        <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentRegistrations_PrimarySource"
                                            runat="server" Category="XINQUIRYPSOURCE" AddBlankRow="true" CssClass="form_dropdown">
                                        </DropDownGlobalCodes:DropDownGlobalCodes>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                    </td>
                                    <td>
                                    </td>
                                    <%--<td style="width: 5%;">
                                    </td>--%>
                                    <td style="width: 25%;">
                                        <span id="Span8">Alternative Source</span>
                                    </td>
                                    <td style="width: 30%;">
                                        <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentRegistrations_AlternativeSource"
                                            runat="server" Category="XINQUIRYPSOURCE" AddBlankRow="true" CssClass="form_dropdown">
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
        <tr>
            <td class="content_tab_bg" style="padding-left: 8px">
                <table cellspacing="0" cellpadding="0" border="0" width="99%">
                    <tr>
                        <td style="padding-top: 10px">
                            <table cellspacing="0" cellpadding="0" border="0">
                                <tr>
                                    <td class="content_tab_left" align="left" nowrap='nowrap'>
                                        <span class="form_label" id="Span9">Special Fee</span>
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
                                    <td align="left" style="width: 22%">
                                        <span class="form_label" id="Span10">Charge client % of standard rate</span>
                                    </td>
                                    <td align="left" style="width: 10%">
                                        <input type="text" id="TextBox_CustomDocumentRegistrations_ClientStandardRate" name="TextBox_CustomDocumentRegistrations_ClientStandardRate"
                                            class="date_text" tabindex="1" datatype="Currency" maxlength="15"/>
                                    </td>
                                    <td align="left" style="width: 9%">
                                        <span class="form_label" id="Span11">Begin Date</span>
                                    </td>
                                    <td align="left" style="width: 10%">
                                        <input type="text" id="TextBox_CustomDocumentRegistrations_SpecialFeeBeginDate" name="TextBox_CustomDocumentRegistrations_SpecialFeeBeginDate"
                                            class="date_text" datatype="Date" tabindex="1" />
                                    </td>
                                    <td align="left" style="width: 5%">
                                        <img id="img2" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                            onclick="return showCalendar('TextBox_CustomDocumentRegistrations_SpecialFeeBeginDate', '%m/%d/%Y');"
                                            alt="" />
                                    </td>
                                    <td align="left" style="width: 9%">
                                        <span class="form_label" id="Span12">Comment</span>
                                    </td>
                                    <td align="left">
                                        <input id="TextBox_CustomDocumentRegistrations_SpecialFeeComment" name="TextBox_CustomDocumentRegistrations_SpecialFeeComment"
                                            type="text" class="form_textbox" style="width: 260px" />
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
                                        <span class="form_label" id="Span13">Sliding Fee Determination</span>
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
                                    <td align="left" style="width: 9%">
                                        <span class="form_label" id="Span14">Start Date</span>
                                    </td>
                                    <td align="left" style="width: 15%">
                                        <input type="text" id="TextBox_CustomDocumentRegistrations_SlidingFeeStartDate" name="TextBox_CustomDocumentRegistrations_SlidingFeeStartDate"
                                            class="date_text" datatype="Date" tabindex="1" />
                                        <img id="img1" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                            onclick="return showCalendar('TextBox_CustomDocumentRegistrations_SlidingFeeStartDate', '%m/%d/%Y');"
                                            alt="" />
                                    </td>
                                    <td align="left" style="width: 9%">
                                        <span class="form_label" id="Span15">End Date</span>
                                    </td>
                                    <td align="left" style="width: 15%">
                                        <input type="text" id="TextBox_CustomDocumentRegistrations_SlidingFeeEndDate" name="TextBox_CustomDocumentRegistrations_SlidingFeeEndDate"
                                            class="date_text" datatype="Date" tabindex="1" />
                                        <img id="img3" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                            onclick="return showCalendar('TextBox_CustomDocumentRegistrations_SlidingFeeEndDate', '%m/%d/%Y');"
                                            alt="" />
                                    </td>
                                    <td class="checkbox_container">
                                        <input id="CheckBox_CustomDocumentRegistrations_IncomeVerified" type="checkbox" />
                                        <label for="CheckBox_CustomDocumentRegistrations_IncomeVerified">
                                            Income Verified</label>
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
                                                        <input type="button" style="width: 100px;" id="Button_SetEndTime" value="Calculate Fee"
                                                            onclick="return CalculateFee();" />
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
                                        <span id="Span16">Per Session Fee</span>
                                    </td>
                                    <td>
                                        <input id="TextBox_CustomDocumentRegistrations_PerSessionFee" name="TextBox_CustomDocumentRegistrations_PerSessionFee" maxlength="15"
                                            type="text" class="form_textbox" style="width: 100px;" datatype="Currency" />
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
                                        <span class="form_label" id="Span18">Financial Comments</span>
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
                                    <td width="100%">
                                        <textarea id="TextArea_CustomDocumentRegistrations_Financialcomment" class="form_textarea"
                                            spellcheck="True" style="width: 98%; height: 60px;"></textarea>
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
</div>
<asp:HiddenField runat="server" ID="HiddenFieldAppointments" />
<asp:HiddenField runat="server" ID="HiddenFieldsPlan" />

<script id="appointmentHTML" type="text/x-jsrender">    
        <tr id="trhtml">
            <td valign="top" style="white-space: nowrap; padding-left: 8px; width: 3%">
                <img style="vertical-align: top; cursor: pointer" alt="" src="<%=RelativePath%>App_Themes/Includes/images/deleteIcon.gif" onclick="removeCoverageInfo(this,{{:RegistrationCoveragePlanId}});" />
            </td>
            <td valign="top" style="white-space: nowrap; width: 24%">                
                {{*     
                        var txtid= "DropDownList_CustomRegistrationCoveragePlans_CoveragePlanId_" + view.data.RegistrationCoveragePlanId;    
                        view.data.textid=txtid;    
                }}                  
                <select   style="width: 95%;" class="form_dropdown form_dropdown_wo_width element"  bindautosaveevents="False" id={{:textid}} onchange="CustomRegistrationCoveragePlans(this,'CoveragePlanId',{{:RegistrationCoveragePlanId}})" >
   
                             <option  text=""  value="-1"></option>
                             {{for plansdropdownarray}}
                                <option  text="{{:PlanName}}"  value="{{:CoveragePlanId}}" {{if IsSelected=='Y'}}selected{{/if}}>{{:PlanName}}</option>
                             {{/for}}
                </select>
     
            </td>
            <td valign="top" align="left" style="white-space: nowrap; width: 14%">   
                {{*     
                        var txinsuretid= "TextBox_CustomRegistrationCoveragePlans_InsuredId_" + view.data.RegistrationCoveragePlanId;    
                        view.data.textinsureid=txinsuretid;    
                }}             
                <input class="form_textbox GetIds" type="text" style="width: 85%"  maxlength="25" bindautosaveevents="False" id={{:textinsureid}} value="{{:InsuredId}}" onchange="CustomRegistrationCoveragePlans(this,'InsuredId',{{:RegistrationCoveragePlanId}})" />
            </td>
            <td valign="top" style="white-space: nowrap; width: 10%">
                    <input class="form_textbox" type="text" maxlength="35" value="{{:GroupId}}" onchange="CustomRegistrationCoveragePlans(this,'GroupId',{{:RegistrationCoveragePlanId}})" />
            </td>            
            <td valign="top" style="white-space: nowrap; width: 29%">                
                <input class="form_textbox" type="text"  style="width: 95%" value="{{:Comment}}" onchange="CustomRegistrationCoveragePlans(this,'Comment',{{:RegistrationCoveragePlanId}})" />
            </td>
        </tr>
</script>

