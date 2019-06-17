<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Frequency.ascx.cs" Inherits="SHS.SmartCare.Custom_SUDischarge_WebPages_Frequency" %>
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
                                    <td class="content_tab_left" align="left" nowrap='nowrap'><span id="Span_SectionSubstanceUse">Substance Use</span>
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
                                        <span id="SpanListOfDrugs">Below is the list of drugs the client has used in the past (as determined by the last assessment).  Specify the frequency of use over the past 30 days.</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2"></td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td align="left" nowrap='nowrap' style="font-weight: bold"><span id="SpanFrquencyDrugName">Drug Name</span><span style="padding-left: 120px">&nbsp;</span></td>
                                                <td align="left" nowrap='nowrap' style="font-weight: bold"><span id="SpanFrquencyAdmissionFrequency">Admission Frequency</span><span style="padding-left: 80px">&nbsp;</span></td>
                                                <td align="left" nowrap='nowrap' style="font-weight: bold"><span id="SpanFrquencyDischargeFrequency">Discharge Frequency</span></td>
                                            </tr>
                                            <tr section="trFirstSubstanceUse">
                                                <td class="height2"></td>
                                            </tr>
                                            <tr section="trFirstSubstanceUse">
                                                <td align="left" nowrap='nowrap'><span id="Span_CustomDocumentSUDischarges_SUAdmissionDrugNameOneText"></span>&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                                <td align="left" nowrap='nowrap'><span id="Span_CustomDocumentSUDischarges_SUAdmissionFrequencyOneText"></span>&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                                <td align="left" nowrap='nowrap'>
                                                    <cc1:DropDownGlobalCodes ID="DropDownList_CustomDocumentSUDischarges_SUDischargeFrequencyOne"
                                                        EnableViewState="false" AddBlankRow="true" BlankRowText="" runat="server" Category="XSUDRUGFREQUENCY"
                                                        Style="width: 190px;" CssClass="form_dropdown">
                                                    </cc1:DropDownGlobalCodes>
                                                </td>
                                            </tr>
                                            <tr section="trSecondSubstanceUse">
                                                <td class="height2"></td>
                                            </tr>
                                            <tr section="trSecondSubstanceUse">
                                                <td align="left" nowrap='nowrap'><span id="Span_CustomDocumentSUDischarges_SUAdmissionDrugNameTwoText"></span>&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                                <td align="left" nowrap='nowrap'><span id="Span_CustomDocumentSUDischarges_SUAdmissionFrequencyTwoText"></span>&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                                <td align="left" nowrap='nowrap'>
                                                    <cc1:DropDownGlobalCodes ID="DropDownList_CustomDocumentSUDischarges_SUDischargeFrequencyTwo"
                                                        EnableViewState="false" AddBlankRow="true" BlankRowText="" runat="server" Category="XSUDRUGFREQUENCY"
                                                        Style="width: 190px;" CssClass="form_dropdown">
                                                    </cc1:DropDownGlobalCodes>
                                                </td>
                                            </tr>
                                            <tr section="trThirdSubstanceUse">
                                                <td class="height2"></td>
                                            </tr>
                                            <tr section="trThirdSubstanceUse">
                                                <td align="left" nowrap='nowrap'><span id="Span_CustomDocumentSUDischarges_SUAdmissionDrugNameThreeText"></span>&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                                <td align="left" nowrap='nowrap'><span id="Span_CustomDocumentSUDischarges_SUAdmissionFrequencyThreeText"></span>&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                                <td align="left" nowrap='nowrap'>
                                                    <cc1:DropDownGlobalCodes ID="DropDownList_CustomDocumentSUDischarges_SUDischargeFrequencyThree"
                                                        EnableViewState="false" AddBlankRow="true" BlankRowText="" runat="server" Category="XSUDRUGFREQUENCY"
                                                        Style="width: 190px;" CssClass="form_dropdown">
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
                    <tr>
                        <td class="height2"></td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="content_tab_left" align="left" nowrap='nowrap'><span id="Span_SectionTobaccoUse">Tobacco Use</span>
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
                                        <table border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td align="left" nowrap='nowrap' style="font-weight: bold"><span style="padding-left: 182px">&nbsp;</span></td>
                                                <td align="left" nowrap='nowrap' style="font-weight: bold"><span id="SpanAdmissionTobaccoUseFrequency">Admission Frequency</span><span style="padding-left: 80px">&nbsp;</span></td>
                                                <td align="left" nowrap='nowrap' style="font-weight: bold"><span id="SpanTobaccoDischargeUseFrequency">Discharge Frequency</span></td>
                                            </tr>
                                            <tr section="trTobaccoUse">
                                                <td class="height2"></td>
                                            </tr>
                                            <tr section="trTobaccoUse">
                                                <td align="left" nowrap='nowrap'><span id="SpanTobaccoUse">Tobacco Use</span>&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                                <td align="left" nowrap='nowrap'><span id="Span_CustomDocumentSUDischarges_SUAdmissionsTobaccoUseText"></span>&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                                <td align="left" nowrap='nowrap'>
                                                    <cc1:DropDownGlobalCodes ID="DropDownList_CustomDocumentSUDischarges_SUDischargeTobaccoUse"
                                                        EnableViewState="false" AddBlankRow="true" BlankRowText="" runat="server" Category="XTOBACCOUSE"
                                                        Style="width: 190px;" CssClass="form_dropdown">
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
