<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ASAM4.ascx.cs" Inherits="ASAM4" %>
<% if (HttpContext.Current == null)
   { %>
<link href="../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet" type="text/css" />
<%} %>
<%--<div style="overflow-x: hidden">--%>
<div style="height: 420px;">
    <table border="0" cellpadding="0" cellspacing="0" class="DocumentScreen" style="width: 98%">
        <tr>
            <td valign="top">
                <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                    <tr>
                        <td style="width: 54%">
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="content_tab_left" align="left" width="40%" nowrap="nowrap">
                                        Dimension
                                    </td>
                                    <td width="17">
                                        <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif"
                                            width="17" height="26" alt="" />
                                    </td>
                                    <td class="content_tab_top" width="100%">
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td style="width: 46%">
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="content_tab_left_dual" align="left" width="40%" nowrap="nowrap">
                                        Specified Level
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
                        <td class="content_tab_bg" colspan="2">
                            <table id="Table_ASAMLevelOfCares" border="0" cellpadding="0" cellspacing="5" width="100%">
                                <tr>
                                    <td valign="top" style="width: 55%" class="LPadd2">
                                        <span id="Span$$CustomASAMPlacements$$Dimension1LevelOfCare" class="form_label">Dimension
                                            1: Alcohol Intoxication and/or Withdrawal Potential</span>
                                    </td>
                                    <td valign="top" align="left" class="LPadd2" style="width: 45%; padding-right: 10px;">
                                        <input type="text" id="TextBox_CustomASAMPlacements_Dimension1LevelOfCareName" name="TextBox_CustomASAMPlacements_Dimension1LevelOfCareName"
                                            class="form_textbox" style="width: 99%" datatype="String" disabled="disabled" />
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" class="LPadd5" valign="top" style="padding-right: 4px;">
                                        <textarea class="form_textarea" id="TextArea_CustomASAMPlacements_Dimension1Need"
                                            rows="5" cols="100" datatype="String" name="TextArea_CustomASAMPlacements_Dimension1Need"
                                            disabled="disabled"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td valign="top" class="LPadd2">
                                        <span id="Span$$CustomASAMPlacements$$Dimension2LevelOfCare" class="form_label">Dimension
                                            2: Biomedical Conditions and Complications</span>
                                    </td>
                                    <td valign="top" align="left" class="LPadd2" style="padding-right: 10px;">
                                        <input type="text" id="TextBox_CustomASAMPlacements_Dimension2LevelOfCareName" name="TextBox_CustomASAMPlacements_Dimension2LevelOfCareName"
                                            class="form_textbox" style="width: 99%" datatype="String" disabled="disabled" />
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" class="LPadd5" valign="top" style="padding-right: 4px;">
                                        <textarea class="form_textarea" id="TextArea_CustomASAMPlacements_Dimension2Need"
                                            datatype="String" rows="5" cols="100" name="TextArea_CustomASAMPlacements_Dimension2Need"
                                            disabled="disabled"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td valign="top" class="LPadd2">
                                        <span id="Span$$CustomASAMPlacements$$Dimension3LevelOfCare" class="form_label">Dimension
                                            3: Emotional, Behavioral or Cognitive Conditions and Complications</span>
                                    </td>
                                    <td valign="top" align="left" class="LPadd2" style="padding-right: 10px;">
                                        <input type="text" id="TextBox_CustomASAMPlacements_Dimension3LevelOfCareName" name="TextBox_CustomASAMPlacements_Dimension3LevelOfCareName"
                                            class="form_textbox" style="width: 99%" datatype="String" disabled="disabled" />
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" class="LPadd5" valign="top" style="padding-right: 4px;">
                                        <textarea class="form_textarea" id="TextArea_CustomASAMPlacements_Dimension3Need"
                                            datatype="String" rows="5" cols="100" name="TextArea_CustomASAMPlacements_Dimension3Need"
                                            disabled="disabled"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td valign="top" class="LPadd2">
                                        <span id="Span$$CustomASAMPlacements$$Dimension4LevelOfCare" class="form_label">Dimension
                                            4: Readiness to Change</span>
                                    </td>
                                    <td valign="top" align="left" class="LPadd2" style="padding-right: 10px;">
                                        <input type="text" id="TextBox_CustomASAMPlacements_Dimension4LevelOfCareName" name="TextBox_CustomASAMPlacements_Dimension4LevelOfCareName"
                                            class="form_textbox" style="width: 99%" datatype="String" disabled="disabled" />
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" class="LPadd5" valign="top" style="padding-right: 4px;">
                                        <textarea class="form_textarea" id="TextArea_CustomASAMPlacements_Dimension4Need"
                                            datatype="String" rows="5" cols="100" name="TextArea_CustomASAMPlacements_Dimension4Need"
                                            disabled="disabled"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td valign="top" class="LPadd2">
                                        <span id="Span$$CustomASAMPlacements$$Dimension5LevelOfCare" class="form_label">Dimension
                                            5: Relapse, Continued Use, Continued Problem Potential</span>
                                    </td>
                                    <td valign="top" align="left" class="LPadd2" style="padding-right: 10px;">
                                        <input type="text" id="TextBox_CustomASAMPlacements_Dimension5LevelOfCareName" name="TextBox_CustomASAMPlacements_Dimension5LevelOfCareName"
                                            class="form_textbox" style="width: 99%" datatype="String" disabled="disabled" />
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" class="LPadd5" valign="top" style="padding-right: 4px;">
                                        <textarea class="form_textarea" id="TextArea_CustomASAMPlacements_Dimension5Need"
                                            datatype="String" rows="5" cols="100" name="TextArea_CustomASAMPlacements_Dimension5Need"
                                            disabled="disabled"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td valign="top" class="LPadd2">
                                        <span id="Span$$CustomASAMPlacements$$Dimension6LevelOfCare" class="form_label">Dimension
                                            6: Recovery Environment</span>
                                    </td>
                                    <td valign="top" align="left" class="LPadd2" style="padding-right: 10px;">
                                        <input type="text" id="TextBox_CustomASAMPlacements_Dimension6LevelOfCareName" name="TextBox_CustomASAMPlacements_Dimension6LevelOfCareName"
                                            class="form_textbox" style="width: 99%" datatype="String" disabled="disabled" />
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" class="LPadd5" valign="top" style="padding-right: 4px;">
                                        <textarea class="form_textarea" id="TextArea_CustomASAMPlacements_Dimension6Need"
                                            datatype="String" rows="5" cols="100" name="TextArea_CustomASAMPlacements_Dimension6Need"
                                            disabled="disabled"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td valign="top" class="LPadd2">
                                        <br />
                                        <span id="Span$$CustomASAMPlacements$$FinalPlacementComment" class="form_label">Final
                                            Placement Determination</span>
                                    </td>
                                    <td valign="top" align="left">
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr>
                                                <td>
                                                    <span id="Span$$CustomASAMPlacements$$SuggestedPlacementName" class="form_label">Suggested
                                                        Placement:</span><a href="javascript:void(0);" border="0" onclick="javascript:SuggestedPlacement();"
                                                            id="AnchorSuggestedPlacementName" style="text-decoration: underline;"><span id="Span_CustomASAMPlacements_SuggestedPlacementName"
                                                                class="form_label"></span></a>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height4">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="LPadd2" style="padding-right: 4px;">
                                                    <asp:DropDownList CssClass="form_dropdown" ID="DropDownList_CustomASAMPlacements_FinalPlacement"
                                                        runat="server" EnableViewState="false" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" class="LPadd5" valign="top" style="padding-right: 4px;">
                                        <textarea class="form_textarea" id="TextArea_CustomASAMPlacements_FinalPlacementComment"
                                            spellcheck="True" datatype="String" rows="5" cols="100" name="TextArea_CustomASAMPlacements_FinalPlacementComment"></textarea>
                                    </td>
                                </tr>
                                <%-- <tr>
                                    <td align="right" class="LPadd5" style="width: 50%">
                                        <asp:DropDownList CssClass="form_dropdown" ID="DropDownList1" runat="server" viewstate="false"
                                            Width="40%" />
                                    </td>
                                </tr>--%>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                <tbody>
                                    <tr>
                                        <td width="2" class="right_bottom_cont_bottom_bg">
                                            <img height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                                                style="vertical-align: top;" />
                                        </td>
                                        <td width="100%" class="right_bottom_cont_bottom_bg">
                                        </td>
                                        <td align="right" width="2" class="right_bottom_cont_bottom_bg">
                                            <img height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif"
                                                style="vertical-align: top;" />
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td>
                <input id="HiddenField_CustomASAMPlacements_SuggestedPlacement" name="HiddenField_CustomASAMPlacements_SuggestedPlacement"
                    type="hidden" />
            </td>
        </tr>
    </table>
</div>