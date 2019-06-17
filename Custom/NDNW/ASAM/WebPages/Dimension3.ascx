<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Dimension3.ascx.cs" Inherits="SHS.SmartCare.Custom_ASAM_WebPages_Dimension3" %>
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
                                    <td class="content_tab_left" nowrap='nowrap'>Dimension 3: Emotional, Behavioral or Cognitive conditions and Complications
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
                                                    <input type="radio" id="RadioButton_CustomDocumentASAMs_Dimension3_A" value="A"
                                                        name="RadioButton_CustomDocumentASAMs_Dimension3" style="cursor: default" />
                                                </td>
                                                <td style="width: 98%">
                                                    <label for="RadioButton_CustomDocumentASAMs_Dimension3_A" style="cursor: default">No treatment recommended</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2"></td>
                                            </tr>
                                            <tr>
                                                <td align="left" valign="top" style="width: 2%">
                                                    <input type="radio" id="RadioButton_CustomDocumentASAMs_Dimension3_B" value="B"
                                                        name="RadioButton_CustomDocumentASAMs_Dimension3" style="cursor: default" />
                                                </td>
                                                <td style="width: 98%">
                                                    <label for="RadioButton_CustomDocumentASAMs_Dimension3_B" style="cursor: default">None or very stable (Level 0.5)</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2"></td>
                                            </tr>
                                            <tr>
                                                <td align="left" valign="top" style="width: 2%">
                                                    <input type="radio" id="RadioButton_CustomDocumentASAMs_Dimension3_C" value="C"
                                                        name="RadioButton_CustomDocumentASAMs_Dimension3" style="cursor: default" />
                                                </td>
                                                <td style="width: 98%">
                                                    <label for="RadioButton_CustomDocumentASAMs_Dimension3_C" style="cursor: default">None or manageable with outpatient medical monitoring (Opioid Maintenance Therapy) </label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2"></td>
                                            </tr>
                                            <tr>
                                                <td align="left" valign="top" style="width: 2%">
                                                    <input type="radio" id="RadioButton_CustomDocumentASAMs_Dimension3_D" value="D"
                                                        name="RadioButton_CustomDocumentASAMs_Dimension3" style="cursor: default" />
                                                </td>
                                                <td style="width: 98%">
                                                    <label for="RadioButton_CustomDocumentASAMs_Dimension3_D" style="cursor: default">None or very stable, or the patient is receiving concurrent mental health monitoring (Level 1)</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2"></td>
                                            </tr>
                                            <tr>
                                                <td align="left" valign="top" style="width: 2%">
                                                    <input type="radio" id="RadioButton_CustomDocumentASAMs_Dimension3_E" value="E"
                                                        name="RadioButton_CustomDocumentASAMs_Dimension3" style="cursor: default" />
                                                </td>
                                                <td style="width: 98%">
                                                    <label for="RadioButton_CustomDocumentASAMs_Dimension3_E" style="cursor: default">Mild severity, with the potential to distract from recovery; the patient needs monitoring (Level 2.1)</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2"></td>
                                            </tr>
                                            <tr>
                                                <td align="left" valign="top" style="width: 2%">
                                                    <input type="radio" id="RadioButton_CustomDocumentASAMs_Dimension3_F" value="F"
                                                        name="RadioButton_CustomDocumentASAMs_Dimension3" style="cursor: default" />
                                                </td>
                                                <td style="width: 98%">
                                                    <label for="RadioButton_CustomDocumentASAMs_Dimension3_F" style="cursor: default">Mild to moderate severity, with potential to distract from recovery; the patient needs stabilization (Level 2.5)</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2"></td>
                                            </tr>
                                            <tr>
                                                <td align="left" valign="top" style="width: 2%">
                                                    <input type="radio" id="RadioButton_CustomDocumentASAMs_Dimension3_G" value="G"
                                                        name="RadioButton_CustomDocumentASAMs_Dimension3" style="cursor: default" />
                                                </td>
                                                <td style="width: 98%">
                                                    <label for="RadioButton_CustomDocumentASAMs_Dimension3_G" style="cursor: default">None or minimal; not distracting to recovery. If stable, a co-occurring capable program is  appropriate. If not a co-occurring enhanced program is required <br />(Level 3.1)</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2"></td>
                                            </tr>
                                            <tr>
                                                <td align="left" valign="top" style="width: 2%">
                                                    <input type="radio" id="RadioButton_CustomDocumentASAMs_Dimension3_H" value="H"
                                                        name="RadioButton_CustomDocumentASAMs_Dimension3" style="cursor: default" />
                                                </td>
                                                <td style="width: 98%">
                                                    <label for="RadioButton_CustomDocumentASAMs_Dimension3_H" style="cursor: default">Demonstrates repeated inability to control impulses, or unstable and dangerous signs/symptoms require stabilization and a 24 hour setting to prepare for community Integration and continuing care. A co-occurring enhanced setting is required for those with servers and chronic mental illness (Level 3.5)</label>
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
                                                    <span id="Span_XLevel3">Level</span>
                                                </td>
                                                <td align="left" style="width: 26%">
                                                    <dropdownglobalcodes:dropdownglobalcodes id="DropDownList_CustomDocumentASAMs_D3Level"
                                                        style="width: 89%;" runat="server" category="XLEVEL" addblankrow="true"
                                                        cssclass="form_dropdown">
                                                    </dropdownglobalcodes:dropdownglobalcodes>
                                                </td>
                                                <td align="right" style="width: 15%; padding-right: 6px">
                                                    <span id="Span_XDocumentedrisk3">Documented Risk</span>
                                                </td>
                                                <td align="left" style="width: 55%">
                                                    <dropdownglobalcodes:dropdownglobalcodes id="DropDownList_CustomDocumentASAMs_D3Risk"
                                                        style="width: 49%;" runat="server" category="XDOCUMENTEDRISK" addblankrow="true"
                                                        cssclass="form_dropdown">
                                                    </dropdownglobalcodes:dropdownglobalcodes>
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
                                        <span id="Span_CustomComments3">Comments</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2" style="width: 100%;"></td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 100%;">
                                        <textarea class="form_textarea" id="TextArea_CustomDocumentASAMs_D3Comments"
                                            name="TextArea_CustomDocumentASAMs_D3Comments" rows="4" cols="1" style="width: 98%;"
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
