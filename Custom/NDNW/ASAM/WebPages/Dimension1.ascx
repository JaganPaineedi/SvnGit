<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Dimension1.ascx.cs" Inherits="SHS.SmartCare.Custom_ASAM_WebPages_Dimension1" %>
<%@ Register Assembly="Streamline.DotNetDropDownGlobalCodes" Namespace="Streamline.DotNetDropDownGlobalCodes"
    TagPrefix="DropDownGlobalCodes" %>
<div>
    <table border="0" cellpadding="0" cellspacing="0" class="DocumentScreen">
        <tr>
            <td class="height2"></td>
        </tr>
        <tr>
            <td>
                <table width="98%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td class="height1"></td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="content_tab_left" nowrap='nowrap'>Dimension 1: Alcohol Intoxication and/or Withdrawal Potential
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
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td class="height2"></td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr>
                                                <td align="left" valign="top" style="width: 2%">
                                                    <input type="radio" id="RadioButton_CustomDocumentASAMs_Dimension1_A" value="A"
                                                        name="RadioButton_CustomDocumentASAMs_Dimension1" style="cursor: default" />
                                                </td>
                                                <td style="width: 98%">
                                                    <label for="RadioButton_CustomDocumentASAMs_Dimension1_A" style="cursor: default">No treatment recommended</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2"></td>
                                            </tr>
                                            <tr>
                                                <td align="left" valign="top" style="width: 2%">
                                                    <input type="radio" id="RadioButton_CustomDocumentASAMs_Dimension1_B" value="B"
                                                        name="RadioButton_CustomDocumentASAMs_Dimension1" style="cursor: default" />
                                                </td>
                                                <td style="width: 98%">
                                                    <label for="RadioButton_CustomDocumentASAMs_Dimension1_B" style="cursor: default">The patient is not at risk of withdrawal (Level 0.5)</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2"></td>
                                            </tr>
                                            <tr>
                                                <td align="left" valign="top" style="width: 2%">
                                                    <input type="radio" id="RadioButton_CustomDocumentASAMs_Dimension1_C" value="C"
                                                        name="RadioButton_CustomDocumentASAMs_Dimension1" style="cursor: default" />
                                                </td>
                                                <td style="width: 98%">
                                                    <label for="RadioButton_CustomDocumentASAMs_Dimension1_C" style="cursor: default">The patient is physiologically dependent on opiates and requires Opioid Maintenance Therapy to prevent withdrawal (Opioid Maintenance Therapy)</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2"></td>
                                            </tr>
                                            <tr>
                                                <td align="left" valign="top" style="width: 2%">
                                                    <input type="radio" id="RadioButton_CustomDocumentASAMs_Dimension1_D" value="D"
                                                        name="RadioButton_CustomDocumentASAMs_Dimension1" style="cursor: default" />
                                                </td>
                                                <td style="width: 98%">
                                                    <label for="RadioButton_CustomDocumentASAMs_Dimension1_D" style="cursor: default">The patient is not experiencing significant withdrawal or is at minimal risk of sever withdrawal (Level 1)</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2"></td>
                                            </tr>
                                            <tr>
                                                <td align="left" valign="top" style="width: 2%">
                                                    <input type="radio" id="RadioButton_CustomDocumentASAMs_Dimension1_E" value="E"
                                                        name="RadioButton_CustomDocumentASAMs_Dimension1" style="cursor: default" />
                                                </td>
                                                <td style="width: 98%">
                                                    <label for="RadioButton_CustomDocumentASAMs_Dimension1_E" style="cursor: default">The patient is at minimal risk of severe withdrawal (Level 2.1)</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2"></td>
                                            </tr>
                                            <tr>
                                                <td align="left" valign="top" style="width: 2%">
                                                    <input type="radio" id="RadioButton_CustomDocumentASAMs_Dimension1_F" value="F"
                                                        name="RadioButton_CustomDocumentASAMs_Dimension1" style="cursor: default" />
                                                </td>
                                                <td style="width: 98%">
                                                    <label for="RadioButton_CustomDocumentASAMs_Dimension1_F" style="cursor: default">The patient is at moderate risk of severe withdrawal manageable at Level 2 (Level 2.5)</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2"></td>
                                            </tr>
                                            <tr>
                                                <td align="left" valign="top" style="width: 2%">
                                                    <input type="radio" id="RadioButton_CustomDocumentASAMs_Dimension1_G" value="G"
                                                        name="RadioButton_CustomDocumentASAMs_Dimension1" style="cursor: default" />
                                                </td>
                                                <td style="width: 98%">
                                                    <label for="RadioButton_CustomDocumentASAMs_Dimension1_G" style="cursor: default">
                                                        The patient is not at risk of withdrawal, or is experiencing minimal or stable withdrawal. The patient is concurrently receiving
                                                        <br />
                                                        Level I-WM (minimal) or Level II-WM (Moderate) services (Level 3.1)</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2"></td>
                                            </tr>
                                            <tr>
                                                <td align="left" valign="top" style="width: 2%">
                                                    <input type="radio" id="RadioButton_CustomDocumentASAMs_Dimension1_H" value="H"
                                                        name="RadioButton_CustomDocumentASAMs_Dimension1" style="cursor: default" />
                                                </td>
                                                <td style="width: 98%">
                                                    <label for="RadioButton_CustomDocumentASAMs_Dimension1_H" style="cursor: default">The patient is at minimal risk of severe withdrawal. If withdrawal is present, manageable at Level 3.2 WM (Level 3.5)</label>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2"></td>
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
                                    <td class="right_bottom_cont_bottom_bg" width="100%"></td>
                                    <td width="2" class="right_bottom_cont_bottom_bg" align="right">
                                        <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif"
                                            height="7" alt="" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="height2"></td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="content_tab_left" nowrap='nowrap'>General
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
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td class="height2"></td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr>
                                                <td align="left" style="width: 4%">
                                                    <span id="Span_XLevel1">Level</span>
                                                </td>
                                                <td align="left" style="width: 26%">
                                                    <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentASAMs_D1Level"
                                                        Style="width: 89%;" runat="server" Category="XLEVEL" AddBlankRow="true"
                                                        CssClass="form_dropdown">
                                                    </DropDownGlobalCodes:DropDownGlobalCodes>
                                                </td>
                                                <td align="right" style="width: 15%; padding-right: 6px">
                                                    <span id="Span_XDocumentedrisk1">Documented Risk</span>
                                                </td>
                                                <td align="left" style="width: 55%">
                                                    <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentASAMs_D1Risk"
                                                        Style="width: 49%;" runat="server" Category="XDOCUMENTEDRISK" AddBlankRow="true"
                                                        CssClass="form_dropdown">
                                                    </DropDownGlobalCodes:DropDownGlobalCodes>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2" style="width: 100%;"></td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 100%;">
                                        <span id="Span_CustomComments1">Comments</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2" style="width: 100%;"></td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 100%;">
                                        <textarea class="form_textarea" id="TextArea_CustomDocumentASAMs_D1Comments"
                                            name="TextArea_CustomDocumentASAMs_D1Comments" rows="4" cols="1" style="width: 98%;"
                                            spellcheck="True" datatype="String"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2"></td>
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
