<%@ Control Language="C#" AutoEventWireup="true" CodeFile="FinalDetermination.ascx.cs" Inherits="SHS.SmartCare.Custom_ASAM_WebPages_FinalDetermination" %>
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
                                    <td class="content_tab_left" nowrap='nowrap'>Final Determination
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
                                    <td class="height2" colspan="2"></td>
                                </tr>
                                <tr>
                                    <td style="width: 50%">
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr>
                                                <td align="left" style="width: 100%;">
                                                    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                                        <tr>
                                                            <td align="left" style="width: 25%">Dimension1</td>
                                                            <td align="left" style="width: 50%"><span id="span_dimension1level">Level No treatment recommended</span></td>
                                                            <td align="right" style="width: 25%; padding-right: 18px"><span id="span_risk1level">Risk: Moderate</span></td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2" style="width: 100%;"></td>
                                            </tr>
                                            <tr>
                                                <td align="left" style="width: 100%;">
                                                    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                                        <tr>
                                                            <td align="center" style="width: 2%;">
                                                                <input type="checkbox" id="CheckBox_CustomDocumentASAMs_D1CarePlan"
                                                                    name="CheckBox_CustomDocumentASAMs_D1CarePlan" style="cursor: default" />
                                                            </td>
                                                            <td align="left" valign="left" style="width: 98%; padding-left: 2px">
                                                                <label for="CheckBox_CustomDocumentASAMs_D1CarePlan" style="cursor: default">
                                                                    Need to Update Care Plan</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2" style="width: 100%;"></td>
                                            </tr>
                                            <tr>
                                                <td align="left" colspan="4" style="width: 100%;">
                                                    <textarea class="form_textarea" id="TextAreaDimension1" bindautosaveevents="False" parentchildcontrols='True' bindsetformdata='False' rows="4" cols="1" style="width: 95%;" spellcheck="True" datatype="String" readonly="readonly"></textarea>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2"></td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 50%">
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr>
                                                <td align="left" style="width: 100%;">
                                                    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                                        <tr>
                                                            <td align="left" style="width: 25%">Dimension2</td>
                                                            <td align="left" style="width: 50%"><span id="span_dimension2level">Level No treatment recommended</span></td>
                                                            <td align="right" style="width: 25%; padding-right: 18px"><span id="span_risk2level">Risk: Moderate</span></td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2" style="width: 100%;"></td>
                                            </tr>
                                            <tr>
                                                <td align="left" style="width: 100%;">
                                                    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                                        <tr>
                                                            <td align="center" style="width: 2%;">
                                                                <input type="checkbox" id="CheckBox_CustomDocumentASAMs_D2CarePlan"
                                                                    name="CheckBox_CustomDocumentASAMs_D2CarePlan" style="cursor: default" />
                                                            </td>
                                                            <td align="left" valign="left" style="width: 98%; padding-left: 2px">
                                                                <label for="CheckBox_CustomDocumentASAMs_D2CarePlan" style="cursor: default">
                                                                    Need to Update Care Plan</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2" style="width: 100%;"></td>
                                            </tr>
                                            <tr>
                                                <td align="left" colspan="4" style="width: 100%;">
                                                    <textarea class="form_textarea" id="TextAreaDimension2" bindautosaveevents="False" parentchildcontrols='True' bindsetformdata='False' rows="4" cols="1" style="width: 95%;" spellcheck="True" datatype="String" readonly="readonly"></textarea>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2"></td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2" colspan="2"></td>
                                </tr>
                                <tr>
                                    <td style="width: 50%">
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr>
                                                <td align="left" style="width: 100%;">
                                                    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                                        <tr>
                                                            <td align="left" style="width: 25%">Dimension3</td>
                                                            <td align="left" style="width: 50%"><span id="span_dimension3level">Level No treatment recommended</span></td>
                                                            <td align="right" style="width: 25%; padding-right: 18px"><span id="span_risk3level">Risk: Moderate</span></td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2" style="width: 100%;"></td>
                                            </tr>
                                            <tr>
                                                <td align="left" style="width: 100%;">
                                                    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                                        <tr>
                                                            <td align="center" style="width: 2%;">
                                                                <input type="checkbox" id="CheckBox_CustomDocumentASAMs_D3CarePlan"
                                                                    name="CheckBox_CustomDocumentASAMs_D3CarePlan" style="cursor: default" />
                                                            </td>
                                                            <td align="left" valign="left" style="width: 98%; padding-left: 2px">
                                                                <label for="CheckBox_CustomDocumentASAMs_D3CarePlan" style="cursor: default">
                                                                    Need to Update Care Plan</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2" style="width: 100%;"></td>
                                            </tr>
                                            <tr>
                                                <td align="left" colspan="4" style="width: 100%;">
                                                    <textarea class="form_textarea" id="TextAreaDimension3" bindautosaveevents="False" parentchildcontrols='True' bindsetformdata='False' rows="4" cols="1" style="width: 95%;" spellcheck="True" datatype="String" readonly="readonly"></textarea>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2"></td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 50%">
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr>
                                                <td align="left" style="width: 100%;">
                                                    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                                        <tr>
                                                            <td align="left" style="width: 25%">Dimension4</td>
                                                            <td align="left" style="width: 50%"><span id="span_dimension4level">Level No treatment recommended</span></td>
                                                            <td align="right" style="width: 25%; padding-right: 18px"><span id="span_risk4level">Risk: Moderate</span></td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2" style="width: 100%;"></td>
                                            </tr>
                                            <tr>
                                                <td align="left" style="width: 100%;">
                                                    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                                        <tr>
                                                            <td align="center" style="width: 2%;">
                                                                <input type="checkbox" id="CheckBox_CustomDocumentASAMs_D4CarePlan"
                                                                    name="CheckBox_CustomDocumentASAMs_D4CarePlan" style="cursor: default" />
                                                            </td>
                                                            <td align="left" valign="left" style="width: 98%; padding-left: 2px">
                                                                <label for="CheckBox_CustomDocumentASAMs_D4CarePlan" style="cursor: default">
                                                                    Need to Update Care Plan</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2" style="width: 100%;"></td>
                                            </tr>
                                            <tr>
                                                <td align="left" colspan="4" style="width: 100%;">
                                                    <textarea class="form_textarea" id="TextAreaDimension4" bindautosaveevents="False" parentchildcontrols='True' bindsetformdata='False' rows="4" cols="1" style="width: 95%;" spellcheck="True" datatype="String" readonly="readonly"></textarea>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2"></td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2" colspan="2"></td>
                                </tr>
                                <tr>
                                    <td style="width: 50%">
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr>
                                                <td align="left" style="width: 100%;">
                                                    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                                        <tr>
                                                            <td align="left" style="width: 25%">Dimension5</td>
                                                            <td align="left" style="width: 50%"><span id="span_dimension5level">Level No treatment recommended</span></td>
                                                            <td align="right" style="width: 25%; padding-right: 18px"><span id="span_risk5level">Risk: Moderate</span></td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2" style="width: 100%;"></td>
                                            </tr>
                                            <tr>
                                                <td align="left" style="width: 100%;">
                                                    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                                        <tr>
                                                            <td align="center" style="width: 2%;">
                                                                <input type="checkbox" id="CheckBox_CustomDocumentASAMs_D5CarePlan"
                                                                    name="CheckBox_CustomDocumentASAMs_D5CarePlan" style="cursor: default" />
                                                            </td>
                                                            <td align="left" valign="left" style="width: 98%; padding-left: 2px">
                                                                <label for="CheckBox_CustomDocumentASAMs_D5CarePlan" style="cursor: default">
                                                                    Need to Update Care Plan</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2" style="width: 100%;"></td>
                                            </tr>
                                            <tr>
                                                <td align="left" colspan="4" style="width: 100%;">
                                                    <textarea class="form_textarea" id="TextAreaDimension5" bindautosaveevents="False" parentchildcontrols='True' bindsetformdata='False' rows="4" cols="1" style="width: 95%;" spellcheck="True" datatype="String" readonly="readonly"></textarea>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2"></td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 50%">
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr>
                                                <td align="left" style="width: 100%;">
                                                    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                                        <tr>
                                                            <td align="left" style="width: 25%">Dimension6</td>
                                                            <td align="left" style="width: 50%"><span id="span_dimension6level">Level No treatment recommended</span></td>
                                                            <td align="right" style="width: 25%; padding-right: 18px"><span id="span_risk6level">Risk: Moderate</span></td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2" style="width: 100%;"></td>
                                            </tr>
                                            <tr>
                                                <td align="left" style="width: 100%;">
                                                    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                                        <tr>
                                                            <td align="center" style="width: 2%;">
                                                                <input type="checkbox" id="CheckBox_CustomDocumentASAMs_D6CarePlan"
                                                                    name="CheckBox_CustomDocumentASAMs_D6CarePlan" style="cursor: default" />
                                                            </td>
                                                            <td align="left" valign="left" style="width: 98%; padding-left: 2px">
                                                                <label for="CheckBox_CustomDocumentASAMs_D6CarePlan" style="cursor: default">
                                                                    Need to Update Care Plan</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2" style="width: 100%;"></td>
                                            </tr>
                                            <tr>
                                                <td align="left" colspan="4" style="width: 100%;">
                                                    <textarea class="form_textarea" id="TextAreaDimension6" bindautosaveevents="False" parentchildcontrols='True' bindsetformdata='False' rows="4" cols="1" style="width: 95%;" spellcheck="True" datatype="String" readonly="readonly"></textarea>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2"></td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2" colspan="2"></td>
                                </tr>
                                <tr>
                                    <td align="left" colspan="2"><span id="span_FinalPlacementDetermination" style="font-weight: bold">Final Placement Determination</span></td>
                                </tr>
                                <tr>
                                    <td class="height2" colspan="2"></td>
                                </tr>
                                <tr>
                                    <td style="width: 50%">
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr>
                                                <td align="left" style="width: 33%;"><span id="span_IndicatedLevel">Indicated/Referred Level</span></td>
                                                <td align="left" style="width: 67%;">
                                                    <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentASAMs_IndicatedReferredLevel"
                                                        Style="width: 69%;" runat="server" Category="XINDICATEDLEVEL" AddBlankRow="true"
                                                        CssClass="form_dropdown">
                                                    </DropDownGlobalCodes:DropDownGlobalCodes>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 50%">&nbsp;</td>
                                </tr>
                                <tr>
                                    <td class="height2" colspan="2"></td>
                                </tr>
                                <tr>
                                    <td style="width: 50%">
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr>
                                                <td align="left" style="width: 33%;"><span id="span_Provided">Provided Level</span></td>
                                                <td align="left" style="width: 67%;">
                                                    <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentASAMs_ProvidedLevel"
                                                        Style="width: 69%;" runat="server" Category="XPROVIDEDLEVEL" AddBlankRow="true"
                                                        CssClass="form_dropdown">
                                                    </DropDownGlobalCodes:DropDownGlobalCodes>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 50%">&nbsp;</td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 100%;" colspan="2">
                                        <span id="Span_CustomComments1">Comments</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2" style="width: 100%;" colspan="2"></td>
                                </tr>
                                <tr>
                                    <td align="left" colspan="2" style="width: 100%;">
                                        <textarea class="form_textarea" id="TextArea_CustomDocumentASAMs_FinalDeterminationComments"
                                            name="TextArea_CustomDocumentASAMs_FinalDeterminationComments" rows="4" cols="1" style="width: 97.5%;"
                                            spellcheck="True" datatype="String"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2" colspan="2"></td>
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
    <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentASAMs_DummyD1Level" Style="width: 89%; display: none" runat="server" Category="XLEVEL" AddBlankRow="true" bindautosaveevents="False" parentchildcontrols='True' bindsetformdata='False' CssClass="form_dropdown"></DropDownGlobalCodes:DropDownGlobalCodes>
    <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentASAMs_DummyD1Risk" Style="width: 89%; display: none" runat="server" Category="XDOCUMENTEDRISK" AddBlankRow="true" bindautosaveevents="False" parentchildcontrols='True' bindsetformdata='False' CssClass="form_dropdown"></DropDownGlobalCodes:DropDownGlobalCodes>
</div>
