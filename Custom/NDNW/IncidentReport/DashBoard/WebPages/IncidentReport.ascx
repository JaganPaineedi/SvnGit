<%@ Control Language="C#" AutoEventWireup="true" CodeFile="IncidentReport.ascx.cs"
    Inherits="IncidentReport" %>

<script language="javascript" type="text/javascript" src="../../../../JScripts/Scripts/IncidentReport.js"></script>

<div>
     <table border="0" class="WidgetsBorder" cellpadding="0" cellspacing="0" width="100%">
        <tr>
            <td>
                <table border="0" cellpadding="0" cellspacing="0" width="98%">
                    <tr>
                        <td class="title_txt" align="left">
                            <asp:Label ID="LabelHeading" runat="server"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table border="0" cellpadding="0" cellspacing="0" width="100%" style="padding-left: 10px">
                                <tr>
                                    <td style="width: 24%">
                                        &nbsp;
                                    </td>
                                    <td style="width: 19%;" align="center" class="black_txt">
                                        <span>Progress</span>
                                    </td>
                                    <td style="width: 19%;" align="center" class="black_txt">
                                        <span>Assigned for Review</span>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td height="10px">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td style="width: 24%; padding-left: 12px" align="left" class="black_txt">
                                        <span>Incident Reports</span>
                                    </td>
                                    <td style="border-top-style: solid; border-left-style: solid; border-top-width: 1px;
                                        border-left-width: 1px; width: 19%; border-top-color: #000000; border-left-color: #000000;"
                                        align="center" style="class="white_bg">
                                        <a id="LinkButtonIncidentReportsProgress" runat="server" class="span_textunderline_cursor">
                                            0</a>
                                    </td>
                                    <td style="width: 19%; border-bottom-style: none;" align="center" class="white_bg">
                                        <a id="LinkButtonIncidentReportsAssignedReview" runat="server" class="span_textunderline_cursor">
                                            0</a>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding-left: 12px" align="left" class="black_txt" align="center">
                                        <span>Restrictive Procedure Forms</span>
                                    </td>
                                    <td align="center" class="white_bg" style="border-right-style: none">
                                        <a id="LinkButtonRestrictiveProgress" runat="server" class="span_textunderline_cursor">
                                            0</a>
                                    </td>
                                    <td align="center" class="white_bg">
                                        <a id="LinkButtonRestrictiveAssignedReview" runat="server" class="span_textunderline_cursor">
                                            0</a>
                                    </td>
                                </tr>                               
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td style="height: 5px">
            </td>
        </tr>
    </table>
</div>
