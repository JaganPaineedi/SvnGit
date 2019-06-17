<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Dimension4.ascx.cs" Inherits="SHS.SmartCare.Custom_ASAM_WebPages_Dimension4" %>
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
                                    <td class="content_tab_left" nowrap='nowrap'>Dimension 4: Readiness to Change
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
                                                    <input type="radio" id="RadioButton_CustomDocumentASAMs_Dimension4_A" value="A"
                                                        name="RadioButton_CustomDocumentASAMs_Dimension4" style="cursor: default" />
                                                </td>
                                                <td style="width: 98%">
                                                    <label for="RadioButton_CustomDocumentASAMs_Dimension4_A" style="cursor: default">No treatment recommended</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2"></td>
                                            </tr>
                                            <tr>
                                                <td align="left" valign="top" style="width: 2%">
                                                    <input type="radio" id="RadioButton_CustomDocumentASAMs_Dimension4_B" value="B"
                                                        name="RadioButton_CustomDocumentASAMs_Dimension4" style="cursor: default" />
                                                </td>
                                                <td style="width: 98%">
                                                    <label for="RadioButton_CustomDocumentASAMs_Dimension4_B" style="cursor: default">The patient is willing to explore how current alcohol or drug use may affect personal goals (Level 0.5)</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2"></td>
                                            </tr>
                                            <tr>
                                                <td align="left" valign="top" style="width: 2%">
                                                    <input type="radio" id="RadioButton_CustomDocumentASAMs_Dimension4_C" value="C"
                                                        name="RadioButton_CustomDocumentASAMs_Dimension4" style="cursor: default" />
                                                </td>
                                                <td style="width: 98%">
                                                    <label for="RadioButton_CustomDocumentASAMs_Dimension4_C" style="cursor: default">The patient is ready to change the negative effects of opiate use, but not ready for total abstinence (Opioid Maintenance Therapy)</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2"></td>
                                            </tr>
                                            <tr>
                                                <td align="left" valign="top" style="width: 2%">
                                                    <input type="radio" id="RadioButton_CustomDocumentASAMs_Dimension4_D" value="D"
                                                        name="RadioButton_CustomDocumentASAMs_Dimension4" style="cursor: default" />
                                                </td>
                                                <td style="width: 98%">
                                                    <label for="RadioButton_CustomDocumentASAMs_Dimension4_D" style="cursor: default">The patient is ready for recovery, but needs motivating & monitoring strategies to strengthen readiness. Or, has high severity in this dimension but not other Dimensions. Needs Level 1 motivational enhancement program (Level 1)</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2"></td>
                                            </tr>
                                            <tr>
                                                <td align="left" valign="top" style="width: 2%">
                                                    <input type="radio" id="RadioButton_CustomDocumentASAMs_Dimension4_E" value="E"
                                                        name="RadioButton_CustomDocumentASAMs_Dimension4" style="cursor: default" />
                                                </td>
                                                <td style="width: 98%">
                                                    <label for="RadioButton_CustomDocumentASAMs_Dimension4_E" style="cursor: default">The patient has variable engagement in treatment, ambivalence or lack of awareness of the substance use or mental health problem, <br />and requires a structured program several times a week to promote progress through the stages of change (Level 2.1)</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2"></td>
                                            </tr>
                                            <tr>
                                                <td align="left" valign="top" style="width: 2%">
                                                    <input type="radio" id="RadioButton_CustomDocumentASAMs_Dimension4_F" value="F"
                                                        name="RadioButton_CustomDocumentASAMs_Dimension4" style="cursor: default" />
                                                </td>
                                                <td style="width: 98%">
                                                    <label for="RadioButton_CustomDocumentASAMs_Dimension4_F" style="cursor: default">The patient has poor engagement in treatment, significant ambivalence, or lack of awareness of the substance use/mental health problem, <br />requiring a near-daily structured program or intensive engagement services to promote progress through the stages of change (Level 2.5)</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2"></td>
                                            </tr>
                                            <tr>
                                                <td align="left" valign="top" style="width: 2%">
                                                    <input type="radio" id="RadioButton_CustomDocumentASAMs_Dimension4_G" value="G"
                                                        name="RadioButton_CustomDocumentASAMs_Dimension4" style="cursor: default" />
                                                </td>
                                                <td style="width: 98%">
                                                    <label for="RadioButton_CustomDocumentASAMs_Dimension4_G" style="cursor: default">The patient is open to recover, but needs a structured environment to maintain therapeutic gains (Level 3.1)</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2"></td>
                                            </tr>
                                            <tr>
                                                <td align="left" valign="top" style="width: 2%">
                                                    <input type="radio" id="RadioButton_CustomDocumentASAMs_Dimension4_H" value="H"
                                                        name="RadioButton_CustomDocumentASAMs_Dimension4" style="cursor: default" />
                                                </td>
                                                <td style="width: 98%">
                                                    <label for="RadioButton_CustomDocumentASAMs_Dimension4_H" style="cursor: default">The patient has marked difficulty with, or opposition to, treatment with dangerous consequences. Or there is high severity in this dimension but not other Dimensions. Therefore, patient requires a Level 1 motivational enhancement program (3.5)</label>
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
                                                    <span id="Span_XLevel4">Level</span>
                                                </td>
                                                <td align="left" style="width: 26%">
                                                    <dropdownglobalcodes:dropdownglobalcodes id="DropDownList_CustomDocumentASAMs_D4Level"
                                                        style="width: 89%;" runat="server" category="XLEVEL" addblankrow="true"
                                                        cssclass="form_dropdown">
                                                    </dropdownglobalcodes:dropdownglobalcodes>
                                                </td>
                                                <td align="right" style="width: 15%; padding-right: 6px">
                                                    <span id="Span_XDocumentedrisk4">Documented Risk</span>
                                                </td>
                                                <td align="left" style="width: 55%">
                                                    <dropdownglobalcodes:dropdownglobalcodes id="DropDownList_CustomDocumentASAMs_D4Risk"
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
                                        <span id="Span_CustomComments4">Comments</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2" style="width: 100%;"></td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 100%;">
                                        <textarea class="form_textarea" id="TextArea_CustomDocumentASAMs_D4Comments"
                                            name="TextArea_CustomDocumentASAMs_D4Comments" rows="4" cols="1" style="width: 98%;"
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
