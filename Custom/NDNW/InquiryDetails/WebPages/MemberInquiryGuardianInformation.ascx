<%@ Control Language="C#" AutoEventWireup="true" CodeFile="MemberInquiryGuardianInformation.ascx.cs"
    Inherits="SHS.SmartCare.ActivityPages_Client_Detail_Ionia_MemberInquiryGuardianInformation" %>
<%@ Register Assembly="Streamline.DotNetDropDownGlobalCodes" Namespace="Streamline.DotNetDropDownGlobalCodes"
    TagPrefix="DropDownGlobalCodes" %>
<%--<script type="text/javascript" language="javascript" src="../../../../JScripts/SystemScripts/jquery-1.3.2.js"></script>--%>

<script type="text/javascript" src="../../../../JScripts/SystemScripts/jquery.mcdropdown.js"></script>

<script type="text/javascript" src="../../../../JScripts/SystemScripts/jquery.bgiframe.js"></script>
<% if (HttpContext.Current == null)
   { %>
<link href="../../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet"
    type="text/css" />
<%} %>
<script type="text/javascript" language="javascript" src="<%=RelativePath%>Custom/InquiryDetails/Scripts/GuardianInfo.js"></script>

<%--<script src="<%=RelativePath%>JScripts/ApplicationScripts/ApplicationCommonFunctions.js" type="text/javascript"></script> --%>
<div style="width: 97%;">
    <table cellpadding="0" cellspacing="0" width="100%" class="LPadd5">
        <tr>
            <td>
                <table border="0" cellspacing="0" cellpadding="0" width="100%">
                    <tr>
                        <td class="height1">
                        </td>
                    </tr>
                    <tr>
                        <td class="content_tab_left" align="left" nowrap="nowrap">
                            Guardian Information
                        </td>
                        <td width="17">
                            <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif"
                                width="17" height="26" alt="" />
                        </td>
                        <td class="content_tab_top" width="100%">
                            <table>
                                <tr>
                                    <td>
                                        <input type="checkbox" id="CheckBox_CustomInquiries_GuardianSameAsCaller" tabindex="8" />
                                    </td>
                                    <td>
                                       <span class="form_label"> Same As Caller</span>
                                    </td>
                                </tr>
                            </table>
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
                        <td class="height2">
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 86%">
                            <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                <tr>
                                    <td class="LPadd5" style="width: 30%;padding-left:6px;">
                                        <span id="Span$$CustomInquiries$$GuardianFirstName" class="form_label">First Name</span>
                                    </td>
                                    <td class="LPadd5" align="left">
                                        <input type="text" id="TextBox_CustomInquiries_GuardianFirstName" name="TextBox_CustomInquiries_GuardianFirstName"
                                            class="form_textbox" datatype="String" tabindex="1" runat="server" maxlength="150" />
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" class="height2">
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td id="Span$$CustomInquiries$$GuardianLastName" class="LPadd5" style="padding-left:6px;">
                                        <span class="form_label">Last Name</span>
                                    </td>
                                    <td class="LPadd5" align="left">
                                    <input type="text" id="TextBox_CustomInquiries_GuardianLastName" name="TextBox_CustomInquiries_GuardianLastName"
                                            class="form_textbox" datatype="String" tabindex="2" maxlength="150" />
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" class="height2">
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td id="Span$$CustomInquiries$$GuardianDPOA" class="LPadd5" style="padding-left:6px;">
                                        <span class="form_label">DPOA</span>
                                    </td>
                                    <td class="LPadd5" align="left">
                                         <input type="checkbox" id="CheckBox_CustomInquiries_GurdianDPOAStatus" tabindex="3" />
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" class="height2">
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td class="LPadd5" style="padding-left:6px;">
                                        <span id="Span$$CustomInquiries$$GuardianPhoneNumber" class="form_label">Phone</span>
                                    </td>
                                    <td class="LPadd5" align="left">
                                        <input type="text" id="TextBox_CustomInquiries_GuardianPhoneNumber" name="TextBox_CustomInquiries_GuardianPhoneNumber"
                                            tabindex="4" class="form_textbox" datatype="PhoneNumber" onblur="PhoneFormatCheck(this)"
                                            maxlength="20" />
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" class="height2">
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td class="LPadd5" style="padding-left:6px;">
                                        <span id="Span$$CustomInquiries$$GuardianDOB" class="form_label">Date of Birth</span>
                                    </td>
                                    <td class="LPadd5" align="left">
                                        <input type="text" id="TextBox_CustomInquiries_GuardianDOB" name="TextBox_CustomInquiries_GuardianDOB"
                                            tabindex="5"  class="form_textbox" datatype="Date" 
                                            maxlength="20" />
                                    <img id="imgDateOfBirth" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                        onclick="return showCalendar('TextBox_CustomInquiries_GuardianDOB', '%m/%d/%Y');"
                                                        alt="" />
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" class="height2">
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td class="LPadd5" style="padding-left:6px;">
                                        <span id="Span$$CustomInquiries$$GuardianRelation" class="form_label">Relation to Client </span>
                                    </td>
                                    <td class="LPadd5" align="left">
                                        <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomInquiries_GuardianRelation"
                                                        Width="98%" runat="server" Category="RELATIONSHIP" AddBlankRow="true" tabindex="6" CssClass="form_dropdown">
                                                    </DropDownGlobalCodes:DropDownGlobalCodes>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" class="height2">
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td class="LPadd5" style="padding-left:6px;">
                                        <span id="Span$$CustomInquiries$$GuardianComment" class="form_label">Comment</span>
                                    </td>
                                    <td class="LPadd5" align="left">
                                         <textarea id="TextArea_CustomInquiries_GardianComment" name="TextArea_CustomInquiries_GardianComment"
                                            style="width: 100%; height: 50px" class="form_textarea" tabindex="7"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" class="height2">
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td class="LPadd5" style="padding-left:6px;">
                                        <%--<span id="Span$$CustomHRMAssessments$$GuardianType" class="form_label">Type of Guardian</span>--%>
                                    </td>
                                    <td class="LPadd5" align="left">
                                        <%--<asp:DropDownList CssClass="form_dropdown" ID="DropDownList_CustomHRMAssessments_GuardianType"
                                            EnableViewState="false" runat="server" TabIndex="4" Style="width: 82%">
                                        </asp:DropDownList>--%>
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td valign="top" style="width: 14%" align="left" class="RPadd2">
                            <table cellpadding="0" width="30%" cellspacing="0" border="0">
                                <tr>
                                    <td >
                                        <input type="button" id="buttonOk" name="buttonOk" value="OK" class="less_detail_btn"
                                            tabindex="9" onclick="CheckAddressMaxLength('buttonOk','<%=this.externalURL%>','<%=isPopUp%>');" />
                                        <%--<table cellspacing="0" cellpadding="0" border="0" width="75px">
                                            <tr>
                                                <td class="expandable_btn_left" align="center">
                                                    <%--<input type="button" value="OK" id="buttonOk" name="buttonOk" tabindex="5" onclick="UpdateScreen('buttonUpdate',<%=this.externalURL%>,<%=isPopUp%>);" />-
                                                    <input type="button" value="OK" id="buttonOk" name="buttonOk" tabindex="5" onclick="UpdateScreen('buttonOk','<%=this.externalURL%>','<%=isPopUp%>');" />
                                                </td>
                                                <td class="expandable_btn_right">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                        </table>--%>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2">
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td >
                                        <input type="button" id="buttonCancel" name="buttonCancel" value="Cancel" tabindex="10"
                                            class="less_detail_btn" onclick="parent.CloaseModalPopupWindow();" />
                                       
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
        <tr>
            <td>
                <input id="HiddenFieldPageTables" name="HiddenFieldPageTables" type="hidden" value="CustomInquiries" />
            </td>
        </tr>
    </table>
</div>
