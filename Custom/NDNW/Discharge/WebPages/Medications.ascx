<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Medications.ascx.cs" Inherits="Custom_Discharge_WebPages_Medications" %>
<% if (HttpContext.Current == null)
   { %>
<link href="<%= RelativePath%>App_Themes/Styles/smartcare_styles.css" rel="stylesheet"
    type="text/css" />
<%} %>
<div class="DocumentScreen">
    <table cellpadding="0" cellspacing="0" border="0" style="width: 98.5%">
        <tr>
            <td>
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                        <td class="height2">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td class="content_tab_left" align="left" nowrap='nowrap'>
                                        Current Medications
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
                        <td class="content_tab_bg_padding">
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" width="100%">
                                            <tr>
                                                <td style="width: 60%">
                                                    Name (Dosage, Frequency), Prescribed by, Self Report / ordered locally
                                                </td>
                                                <td>
                                                    <table style="width: 35%" border="0" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td class="glow_lt" align="right">
                                                                &nbsp;
                                                            </td>
                                                            <td class="glow_mid" align="left">
                                                                <input style="width: 250px" id="Button_GetCurrentMedication" class="element" onclick=""
                                                                    name="Button_GetCurrentMedication" value="Get current medication list from SmartCareRx"
                                                                    type="button">
                                                            </td>
                                                            <td class="glow_rt">
                                                                &nbsp;
                                                            </td>
                                                        </tr>
                                                    </table>
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
                                    <td colspan="2">
                                        <table>
                                            <tr>
                                                <td style="height: 100px;">
                                                    <div id="divCurrentMedicationsLMH" style="border: solid 1px #b1b1b1; background-color: #f5f5f5;
                                                        overflow-y: scroll; height: 100px; width: 800px">
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
                </table>
            </td>
        </tr>
    </table>
</div>
