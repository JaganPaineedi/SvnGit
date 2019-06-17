<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Discharge.ascx.cs" Inherits="SHS.SmartCare.Custom_SUDischarge_WebPages_Discharge" %>
<%@ Register Assembly="Streamline.DotNetDropDownGlobalCodes" Namespace="Streamline.DotNetDropDownGlobalCodes"
    TagPrefix="cc1" %>
<div>
    <table border="0" cellpadding="0" cellspacing="0" class="DocumentScreen">
        <tr>
            <td>
                <table cellpadding="0" width="98%" cellspacing="0" border="0">
                    <tr>
                        <td class="height2"></td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="content_tab_left" align="left" nowrap='nowrap'><span id="Span_SectionDischarge">Discharge - Discharge</span>
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
                        <td class="content_tab_bg" style="padding-left: 10px">
                            <table border="0" cellpadding="0" cellspacing="0px" width="100%">
                                <tr>
                                    <td class="height2"></td>
                                </tr>
                                <tr>
                                    <td>
                                        <span id="SpanDischargeTreatmentServices">When a client “completes” a treatment services and a “discharge” occurs, this event is to be reported.  In circumstances where a discharge is not done timely.  As a guideline, in such circumstances, <b>a treatment episode is assumed to have ended at the time the client has not been seen for 3 days for residential treatment, and 45 days in the case of outpatient care.</b>  In all cases, the date of discharge should revert to the last date of face-to-face contact.</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2"></td>
                                </tr>
                                <tr>
                                    <td align="left">
                                        <table border="0" cellpadding="0" cellspacing="0px" width="100%">
                                            <tr>
                                                <td style="width: 12%">
                                                    <span id="SpanDateOfDischarge">Date of Discharge </span>
                                                </td>
                                                <td style="width: 88%">
                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                        <tr class="date_Container">
                                                            <td>
                                                                <input type="text" id="TextBox_CustomDocumentSUDischarges_DateOfDischarge" name="TextBox_CustomDocumentSUDischarges_DateOfDischarge" datatype="Date"
                                                                    class="form_textbox" />
                                                            </td>
                                                            <td>&nbsp;
                                                            </td>
                                                            <td>
                                                                <img id="imgDateOfDischarge" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                    onclick="return showCalendar('TextBox_CustomDocumentSUDischarges_DateOfDischarge', '%m/%d/%Y');" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="2" class="height2"></td>
                                            </tr>
                                            <tr>
                                                <td style="width: 12%">
                                                    <span id="SpanDischargeReason">Discharge Reason</span>
                                                </td>
                                                <td style="width: 88%">
                                                    <cc1:DropDownGlobalCodes ID="DropDownList_CustomDocumentSUDischarges_DischargeReason"
                                                        EnableViewState="false" AddBlankRow="true" BlankRowText="" runat="server" Category="XDISCHARGEREASON"
                                                        Style="width: 25%;" CssClass="form_dropdown">
                                                    </cc1:DropDownGlobalCodes>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr class="tmplrow">
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
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
