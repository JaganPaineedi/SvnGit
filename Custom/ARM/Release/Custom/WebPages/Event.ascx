<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Event.ascx.cs" Inherits="SHS.SmartCare.Event" %>
<%@ Register Assembly="Streamline.DotNetDropDownGlobalCodes" Namespace="Streamline.DotNetDropDownGlobalCodes"
    TagPrefix="cc1" %>
<%@ Register Assembly="Streamline.DropDowns" Namespace="Streamline.DropDowns" TagPrefix="cc2" %>
<%@ Register Assembly="Streamline.DotNetDropDowns" Namespace="Streamline.DotNetDropDowns"
    TagPrefix="DotNetDropDowns" %>

<script type="text/javascript" language="javascript" src="<%=RelativePath%>JScripts/ApplicationScripts/SCEvents.js"></script>

<table border="0" cellpadding="0" cellspacing="0" style="width: 30%;">
    <tr>
        <td valign="top" style="width: 49%">
            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                <tr>
                    <td>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                    Details
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
                        <table style="height: 50px;" cellpadding="0" cellspacing="2" border="0" width="100%">
                            <tr>
                                <td style="width: 6%;" class="LPadd5">
                                    <span name="Span_Date" class="form_label" id="Span_Date">Date</span>
                                </td>
                                <td align="left" colspan="0" style="padding-left: 8px">
                                    <table cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td>
                                                <table cellpadding="0" cellspacing="0" border="0">
                                                    <tr class="date_Container">
                                                        <td>
                                                            <input type="text" tabindex="2" name="TextBox_CustomDocumentEventInformations_EventDateTime"
                                                                class="date_text" id="TextBox_CustomDocumentEventInformations_EventDateTime"
                                                                datatype="Date" onchange="ResetDocumentEffectiveDate(this);" />
                                                        </td>
                                                        <td>
                                                            &nbsp;
                                                        </td>
                                                        <td>
                                                            <img id="ImgServicesDateOfEvent" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                onclick="return showCalendar('TextBox_CustomDocumentEventInformations_EventDateTime', '%m/%d/%Y');"
                                                                style="cursor: hand;" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td>
                                                <table cellpadding="0" cellspacing="0" border="0">
                                                    <tr>
                                                        <td align="left" style="padding-left: 8px">
                                                            <span name="Span_Time" class="form_label" id="Span_Time">Time</span>
                                                        </td>
                                                        <td colspan="2" style="padding-left: 5px">
                                                            <input type="text" tabindex="3" name="TextBoxTime_CustomDocumentEventInformations_EventDateTime"
                                                                id="TextBoxTime_CustomDocumentEventInformations_EventDateTime" class="form_textbox"
                                                                datatype="Time" style="width: 63px;" maxlength="9" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td class="LPadd5">
                                    <span name="Span$$Insurer" class="form_label" id="Span$$Insurer">Insurer</span>
                                </td>
                                <td style="width: 25%; padding-left: 8px;" colspan="3">
                                    <cc1:DropDownGlobalCodes ID="DropDownList_CustomDocumentEventInformations_InsurerId"
                                        BlankRowText="" AddBlankRow="true" BlankRowValue="" runat="server" Width="210px" 
                                        TabIndex="6" CssClass="form_dropdown" Category="XEVENTINSURER" onchange="SetInsurerId(this)">
                                    </cc1:DropDownGlobalCodes>
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
        <td style="width: 2%">
            &nbsp;
        </td>
    </tr>
</table>
<asp:HiddenField ID="HiddenFieldDocumentVersionId" runat="server" />
<asp:HiddenField ID="HiddenFieldDocumentId" runat="server" />
<%--<input type="hidden" id="Hidden_Events_DisplayNextEventGroup" name="Hidden_Events_DisplayNextEventGroup" />--%>