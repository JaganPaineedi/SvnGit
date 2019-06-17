<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Substanceuse.ascx.cs"
    Inherits="Custom_SUAdmission_WebPages_Substanceuse" %>
<% if (HttpContext.Current == null)
   { %>
<link href="../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet" type="text/css" />
<%} %>
<%@ Register Assembly="Streamline.DotNetDropDownGlobalCodes" Namespace="Streamline.DotNetDropDownGlobalCodes"
    TagPrefix="cc2" %>
<div>
    <table border="0" cellpadding="0" cellspacing="0" class="DocumentScreen">
        <tr>
            <td class="height2">
            </td>
        </tr>
        <tr>
            <td>
                <table width="98%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td class="height1">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="content_tab_left" nowrap='nowrap'>
                                        Substance Use
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
                        <td class="content_tab_bg" style="padding-left: 10px">
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellpadding="0" cellspacing="2" width="100%">
                                            <tr>
                                                <td>
                                                    Preferred Usage
                                                </td>
                                                <td>
                                                    Detailed Drug Use
                                                </td>
                                                <td>
                                                    Severity
                                                </td>
                                                <td>
                                                    Frequency
                                                </td>
                                                <td>
                                                    Method
                                                </td>
                                                <td>
                                                    Age of First Use
                                                </td>
                                                <td>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height1">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <cc2:DropDownGlobalCodes ID="DropDownList_CustomDocumentSUDischarges_PreferredUsage1"
                                                        EnableViewState="false" AddBlankRow="true" Category="xPreferredUsage" BlankRowText=""
                                                        runat="server" Width="100px">
                                                    </cc2:DropDownGlobalCodes>
                                                </td>
                                                
                                                <td>
                                                    <cc2:DropDownGlobalCodes ID="DropDownList_CustomDocumentSUDischarges_DrugName1" EnableViewState="false"
                                                        AddBlankRow="true" Category="XSUDRUGUSE" BlankRowText="" runat="server" Width="100px">
                                                    </cc2:DropDownGlobalCodes>
                                                </td>
                                                <td>
                                                    <cc2:DropDownGlobalCodes ID="DropDownList_CustomDocumentSUDischarges_Severity1" EnableViewState="false"
                                                        AddBlankRow="true" Category="xSUSeverity" BlankRowText="" runat="server" Width="100px">
                                                    </cc2:DropDownGlobalCodes>
                                                </td>
                                                <td>
                                                    <cc2:DropDownGlobalCodes ID="DropDownList_CustomDocumentSUDischarges_Frequency1"
                                                        EnableViewState="false" AddBlankRow="true" Category="xSUDrugFrequency" BlankRowText=""
                                                        runat="server" Width="100px">
                                                    </cc2:DropDownGlobalCodes>
                                                </td>
                                                <td>
                                                    <cc2:DropDownGlobalCodes ID="DropDownList_CustomDocumentSUDischarges_Route1" EnableViewState="false"
                                                        AddBlankRow="true" Category="XSUMETHOD" BlankRowText="" runat="server" Width="100px">
                                                    </cc2:DropDownGlobalCodes>
                                                </td>
                                                <td>
                                                    <input type="text" id="text_CustomDocumentSUDischarges_AgeOfFirstUseText1" style="width: 80px"
                                                        class="form_textareaWithoutWidth" maxlength="7" />
                                                </td>
                                                <td rowspan="7" cell valign="top">
                                                    <table cellspacing="5">
                                                        <tr>
                                                            <td align="left" style="width: 2%">
                                                                <input type="radio" id="RadioButton_CustomDocumentSUDischarges_AgeOfFirstUse1_N"
                                                                    value="N" name="RadioButton_CustomDocumentSUDischarges_AgeOfFirstUse1" style="cursor: default" />
                                                            </td>
                                                            <td style="width: 7%; padding-left: 3px">
                                                                <label for="RadioButton_CustomDocumentSUDischarges_AgeOfFirstUse1_N" style="cursor: default">
                                                                    NA</label>
                                                            </td>
                                                            <td align="left" style="width: 2%; padding-left: 3px">
                                                                <input type="radio" id="RadioButton_CustomDocumentSUDischarges_AgeOfFirstUse1_U"
                                                                    value="U" name="RadioButton_CustomDocumentSUDischarges_AgeOfFirstUse1" style="cursor: default" />
                                                            </td>
                                                            <td style="padding-left: 3px">
                                                                <label for="RadioButton_CustomDocumentSUDischarges_AgeOfFirstUse1_U" style="cursor: default">
                                                                    UnKnown</label>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height1">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td align="left" style="width: 2%">
                                                                <input type="radio" id="RadioButton_CustomDocumentSUDischarges_AgeOfFirstUse2_N"
                                                                    value="N" name="RadioButton_CustomDocumentSUDischarges_AgeOfFirstUse2" style="cursor: default" />
                                                            </td>
                                                            <td style="width: 7%; padding-left: 3px">
                                                                <label for="RadioButton_CustomDocumentSUDischarges_AgeOfFirstUse2_N" style="cursor: default">
                                                                    NA</label>
                                                            </td>
                                                            <td align="left" style="width: 2%; padding-left: 3px">
                                                                <input type="radio" id="RadioButton_CustomDocumentSUDischarges_AgeOfFirstUse2_U"
                                                                    value="U" name="RadioButton_CustomDocumentSUDischarges_AgeOfFirstUse2" style="cursor: default" />
                                                            </td>
                                                            <td style="padding-left: 3px">
                                                                <label for="RadioButton_CustomDocumentSUDischarges_AgeOfFirstUse2_U" style="cursor: default">
                                                                    UnKnown</label>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height1">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td align="left" style="width: 2%">
                                                                <input type="radio" id="RadioButton_CustomDocumentSUDischarges_AgeOfFirstUse3_N"
                                                                    value="N" name="RadioButton_CustomDocumentSUDischarges_AgeOfFirstUse3" style="cursor: default" />
                                                            </td>
                                                            <td style="width: 7%; padding-left: 3px">
                                                                <label for="RadioButton_CustomDocumentSUDischarges_AgeOfFirstUse3_N" style="cursor: default">
                                                                    NA</label>
                                                            </td>
                                                            <td align="left" style="width: 2%; padding-left: 3px">
                                                                <input type="radio" id="RadioButton_CustomDocumentSUDischarges_AgeOfFirstUse3_U"
                                                                    value="U" name="RadioButton_CustomDocumentSUDischarges_AgeOfFirstUse3" style="cursor: default" />
                                                            </td>
                                                            <td style="padding-left: 3px">
                                                                <label for="RadioButton_CustomDocumentSUDischarges_AgeOfFirstUse3_U" style="cursor: default">
                                                                    UnKnown</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height1">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <cc2:DropDownGlobalCodes ID="DropDownList_CustomDocumentSUDischarges_PreferredUsage2"
                                                        EnableViewState="false" AddBlankRow="true" Category="xPreferredUsage" BlankRowText=""
                                                        runat="server" Width="100px">
                                                    </cc2:DropDownGlobalCodes>
                                                </td>
                                                <td>
                                                    <cc2:DropDownGlobalCodes ID="DropDownList_CustomDocumentSUDischarges_DrugName2" EnableViewState="false"
                                                        AddBlankRow="true" Category="XSUDRUGUSE" BlankRowText="" runat="server" Width="100px">
                                                    </cc2:DropDownGlobalCodes>
                                                </td>
                                                <td>
                                                    <cc2:DropDownGlobalCodes ID="DropDownList_CustomDocumentSUDischarges_Severity2" EnableViewState="false"
                                                        AddBlankRow="true" Category="xSUSeverity" BlankRowText="" runat="server" Width="100px">
                                                    </cc2:DropDownGlobalCodes>
                                                </td>
                                                <td>
                                                    <cc2:DropDownGlobalCodes ID="DropDownList_CustomDocumentSUDischarges_Frequency2"
                                                        EnableViewState="false" AddBlankRow="true" Category="xSUDrugFrequency" BlankRowText=""
                                                        runat="server" Width="100px">
                                                    </cc2:DropDownGlobalCodes>
                                                </td>
                                                <td>
                                                    <cc2:DropDownGlobalCodes ID="DropDownList_CustomDocumentSUDischarges_Route2" EnableViewState="false"
                                                        AddBlankRow="true" Category="XSUMETHOD" BlankRowText="" runat="server" Width="100px">
                                                    </cc2:DropDownGlobalCodes>
                                                </td>
                                                <td>
                                                    <input type="text" id="text_CustomDocumentSUDischarges_AgeOfFirstUseText2" style="width: 80px"
                                                        class="form_textareaWithoutWidth" maxlength="7" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height1">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <cc2:DropDownGlobalCodes ID="DropDownList_CustomDocumentSUDischarges_PreferredUsage3"
                                                        EnableViewState="false" AddBlankRow="true" Category="xPreferredUsage" BlankRowText=""
                                                        runat="server" Width="100px">
                                                    </cc2:DropDownGlobalCodes>
                                                </td>
                                                <td>
                                                    <cc2:DropDownGlobalCodes ID="DropDownList_CustomDocumentSUDischarges_DrugName3" EnableViewState="false"
                                                        AddBlankRow="true" Category="XSUDRUGUSE" BlankRowText="" runat="server" Width="100px">
                                                    </cc2:DropDownGlobalCodes>
                                                </td>
                                                <td>
                                                    <cc2:DropDownGlobalCodes ID="DropDownList_CustomDocumentSUDischarges_Severity3" EnableViewState="false"
                                                        AddBlankRow="true" Category="xSUSeverity" BlankRowText="" runat="server" Width="100px">
                                                    </cc2:DropDownGlobalCodes>
                                                </td>
                                                <td>
                                                    <cc2:DropDownGlobalCodes ID="DropDownList_CustomDocumentSUDischarges_Frequency3"
                                                        EnableViewState="false" AddBlankRow="true" Category="xSUDrugFrequency" BlankRowText=""
                                                        runat="server" Width="100px">
                                                    </cc2:DropDownGlobalCodes>
                                                </td>
                                                <td>
                                                    <cc2:DropDownGlobalCodes ID="DropDownList_CustomDocumentSUDischarges_Route3" EnableViewState="false"
                                                        AddBlankRow="true" Category="XSUMETHOD" BlankRowText="" runat="server" Width="100px">
                                                    </cc2:DropDownGlobalCodes>
                                                </td>
                                                <td>
                                                    <input type="text" id="text_CustomDocumentSUDischarges_AgeOfFirstUseText3" style="width: 80px"
                                                        class="form_textareaWithoutWidth" maxlength="7" />
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
        </tr>
        <tr>
            <td class="height2">
            </td>
        </tr>
    </table>
</div>
