<%@ Control Language="C#" AutoEventWireup="true" CodeFile="DiagnosticSubstanceUse.ascx.cs"
    Inherits="ActivityPages_Harbor_Client_Detail_Documents_DiagnosticAssessment_DiagnosticSubstanceUse" %>

<script src="<%=RelativePath%>Custom/Scripts/DiagnosticAssesment.js" type="text/javascript"></script>

<%@ Register Assembly="Streamline.DotNetDropDownGlobalCodes" Namespace="Streamline.DotNetDropDownGlobalCodes"
    TagPrefix="cc4" %>
<div>
    <table cellpadding="0" cellspacing="0" border="0" width="100%">
        <tr>
            <td class="height4">
            </td>
        </tr>
        <tr>
            <td>
                <table id='tblSubstanceUse' cellpadding="0" cellspacing="0" border="0" width="100%">
                    <tr class="checkbox_container">
                        <td style="width: 1%">
                        </td>
                        <td style="width: 2%">
                            <input type="checkbox" id="CheckBox_CustomDocumentDiagnosticAssessments_UpdateSubstanceUse"
                                name="CheckBox_CustomDocumentDiagnosticAssessments_UpdateSubstanceUse" tabindex="1"
                                class="cursor_default" />
                        </td>
                        <td style="width: 96%">
                            <%--<span class="form_label">Changes to substance use identified.</span>--%>
                            <label for="CheckBox_CustomDocumentDiagnosticAssessments_UpdateSubstanceUse">
                                                        Changes to substance use identified.</label>
                        </td>
                        <td style="width: 1%">
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td class="height3">
            </td>
        </tr>
        <tr>
            <td>
                <table cellpadding="0" cellspacing="0" width="100%" id="Table_SubUseTopSec">
                    <tr>
                        <td class="content_tab_left" align="left" nowrap='nowrap'>
                            Substances
                            <%--<span>Family history of substance use or abuse: </span>--%>
                        </td>
                        <td width="1%">
                            <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif"
                                height="26" alt="" />
                        </td>
                        <td class="content_tab_top" width="86%">
                        </td>
                        <td width="1%">
                            <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_right.gif"
                                height="26" alt="" />
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td class="content_tab_bg">
                <table cellpadding="0" cellspacing="0" border="0" width="100%">
                    <%-- <tr>
                        <td style="width: 1%">
                        </td>
                        <td colspan="4">
                            <textarea class="form_textarea" id="TextArea_CustomDocumentDiagnosticAssessments_FamilyHistorySubstanceUse"
                                name="TextArea_CustomDocumentDiagnosticAssessments_FamilyHistorySubstanceUse"
                                rows="3" cols="75" datatype="String" spellcheck="True" tabindex="33"></textarea>
                        </td>
                    </tr>--%>
                    <%-- <tr>
                        <td style="width: 1%">
                        </td>
                        <td style="width: 2%">
                            <input type="checkbox" id="CheckBox_CustomDocumentDiagnosticAssessments_UpdateSubstanceUse"
                                name="CheckBox_CustomDocumentDiagnosticAssessments_UpdateSubstanceUse" tabindex="1"
                                class="cursor_default" />
                        </td>
                        <td style="width: 96%">
                            <span class="form_label">Changes to substance use identified.</span>
                        </td>
                        <td style="width: 1%">
                        </td>
                    </tr>
                    <tr>
                        <td class="height3" colspan="4">
                        </td>
                    </tr>--%>
                    <tr>
                        <td colspan="4">
                            <table cellpadding="0" cellspacing="0" width="100%" id="Table_ClientReportSubstanceUse">
                                <tr>
                                    <td style="width: 1%">
                                    </td>
                                    <td style="width: 40%">
                                        <span><b>Does the client report alcohol, tobacco or other drug use?</b> </span>
                                    </td>
                                    <td style="width: 10%">
                                        <table class="checkbox_container">
                                            <tr>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_ClientReportAlcoholTobaccoDrugUse_Y"
                                                        name="RadioButton_CustomDocumentDiagnosticAssessments_ClientReportAlcoholTobaccoDrugUse"
                                                        value="Y" tabindex="2" />
                                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_ClientReportAlcoholTobaccoDrugUse_Y">
                                                        Yes</label>
                                                </td>
                                                <td>
                                                    <input style="padding-left: 4px;" type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_ClientReportAlcoholTobaccoDrugUse_N"
                                                        name="RadioButton_CustomDocumentDiagnosticAssessments_ClientReportAlcoholTobaccoDrugUse"
                                                        value="N" tabindex="3" />
                                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_ClientReportAlcoholTobaccoDrugUse_N">
                                                        No</label>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 49%" class="form_label">
                                        <span><em>If yes, explain:</em> </span>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height3" colspan="4">
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4">
                                        <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                            <tr>
                                                <td style="width: 1%">
                                                </td>
                                                <td style="width: 98%">
                                                    <textarea class="form_textarea" id="TextArea_CustomDocumentDiagnosticAssessments_ClientReportDrugUseComment"
                                                        name="TextArea_CustomDocumentDiagnosticAssessments_ClientReportDrugUseComment"
                                                        rows="3" cols="72" spellcheck="True" tabindex="4"></textarea>
                                                </td>
                                                <td style="width: 1%">
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height3" colspan="4">
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4">
                                        <table cellpadding="0" cellspacing="0" width="100%">
                                            <tr>
                                                <td style="width: 1%">
                                                </td>
                                                <td style="width: 33%">
                                                    <span><b>Is further substance use assessment indicated?</b> </span>
                                                </td>
                                                <td style="width: 66%; padding-left: 4px;" align="left">
                                                    <table class="checkbox_container">
                                                        <tr>
                                                            <td>
                                                                <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_FurtherSubstanceAssessmentIndicated_Y"
                                                                    name="RadioButton_CustomDocumentDiagnosticAssessments_FurtherSubstanceAssessmentIndicated"
                                                                    value="Y" tabindex="5" />
                                                                <label for="RadioButton_CustomDocumentDiagnosticAssessments_FurtherSubstanceAssessmentIndicated_Y">
                                                                    Yes</label>
                                                            </td>
                                                            <td>
                                                                <input type="radio" style="padding-left: 4px;" id="RadioButton_CustomDocumentDiagnosticAssessments_FurtherSubstanceAssessmentIndicated_N"
                                                                    name="RadioButton_CustomDocumentDiagnosticAssessments_FurtherSubstanceAssessmentIndicated"
                                                                    value="N" tabindex="6" />
                                                                <label for="RadioButton_CustomDocumentDiagnosticAssessments_FurtherSubstanceAssessmentIndicated_N">
                                                                    No</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4">
                            <table cellpadding="0" cellspacing="0" width="100%" id="Table_HistorySubstanceUse">
                                <tr>
                                    <td class="height3">
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 1%">
                                    </td>
                                    <td style="width: 21%">
                                        <span><b>Any history of substance use?</b> </span>
                                    </td>
                                    <td style="width: 10%; padding-left: 3px;">
                                        <table class="checkbox_container">
                                            <tr>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_ClientHasHistorySubstanceUse_Y"
                                                        name="RadioButton_CustomDocumentDiagnosticAssessments_ClientHasHistorySubstanceUse"
                                                        value="Y" tabindex="7" />
                                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_ClientHasHistorySubstanceUse_Y">
                                                        Yes</label>
                                                </td>
                                                <td>
                                                    <input style="padding-left: 4px;" type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_ClientHasHistorySubstanceUse_N"
                                                        name="RadioButton_CustomDocumentDiagnosticAssessments_ClientHasHistorySubstanceUse"
                                                        value="N" tabindex="8" />
                                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_ClientHasHistorySubstanceUse_N">
                                                        No</label>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 68%; padding-left: 6px;" class="form_label">
                                        <span><em>If yes, explain:</em> </span>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height3" colspan="4">
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4">
                                        <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                            <tr>
                                                <td style="width: 1%">
                                                </td>
                                                <td style="width: 98%">
                                                    <textarea class="form_textarea" id="TextArea_CustomDocumentDiagnosticAssessments_ClientHistorySubstanceUseComment"
                                                        name="TextArea_CustomDocumentDiagnosticAssessments_ClientHistorySubstanceUseComment"
                                                        rows="3" cols="75" datatype="String" spellcheck="True" tabindex="9"></textarea>
                                                </td>
                                                <td style="width: 1%">
                                                </td>
                                            </tr>
                                        </table>
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
                <table border="0" cellspacing="0" cellpadding="0" width="100%" id="Table_SubUseBotSec">
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
        <tr>
            <td colspan="4">
                <table>
                    <tr>
                        <td class="height3">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table cellspacing="0" class="substanceUsemyclass" cellpadding="0" width="100%" id="Table_Substance">
                                <tr>
                                    <td class="form_label labelHeaderRow" style="width: 20%">
                                        <span><b>Substance</b> </span>
                                    </td>
                                    <td class="form_label labelHeaderRow" style="width: 11%">
                                        <span><b>Use Within Past 30 Days</b> </span>
                                    </td>
                                    <td class="form_label labelHeaderRow" style="width: 22%">
                                        <span><b>Current Frequency Of Use</b> </span>
                                    </td>
                                    <td class="form_label labelHeaderRow" style="width: 11%">
                                        <span><b>Use Within Lifetime</b> </span>
                                    </td>
                                    <td class="form_label labelHeaderRow" style="width: 22%">
                                        <span><b>Past Frequency Of Use</b> </span>
                                    </td>
                                    <td class="form_label labelHeaderRow substanceUselasttd" style="width: 14%">
                                        <span><b>Ever Received Treatment for Use of this Substance</b> </span>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="form_label">
                                        <span>Alcohol </span>
                                    </td>
                                    <td>
                                        <table class="checkbox_container substanceUsenoneborder">
                                            <tr>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_AlcoholUseWithin30Days_Y"
                                                        name="RadioButton_CustomDocumentDiagnosticAssessments_AlcoholUseWithin30Days"
                                                        value="Y" tabindex="10" />
                                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_AlcoholUseWithin30Days_Y">
                                                        Yes</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_AlcoholUseWithin30Days_N"
                                                        name="RadioButton_CustomDocumentDiagnosticAssessments_AlcoholUseWithin30Days"
                                                        checked="checked" value="N" tabindex="11" />
                                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_AlcoholUseWithin30Days_N">
                                                        No</label>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td class="padding_4px">
                                        <cc4:DropDownGlobalCodes ID="DropDownList_CustomDocumentDiagnosticAssessments_AlcoholUseCurrentFrequency"
                                            TabIndex="12" Width="165px" runat="server" AddBlankRow="true" BlankRowText=""
                                            Category="XFREQUENCYUSE">
                                        </cc4:DropDownGlobalCodes>
                                    </td>
                                    <td>
                                        <table class="checkbox_container substanceUsenoneborder">
                                            <tr>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_AlcoholUseWithinLifetime_Y"
                                                        name="RadioButton_CustomDocumentDiagnosticAssessments_AlcoholUseWithinLifetime"
                                                        value="Y" tabindex="13" />
                                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_AlcoholUseWithinLifetime_Y">
                                                        Yes</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_AlcoholUseWithinLifetime_N"
                                                        name="RadioButton_CustomDocumentDiagnosticAssessments_AlcoholUseWithinLifetime"
                                                        value="N" tabindex="14" />
                                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_AlcoholUseWithinLifetime_N">
                                                        No</label>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td class="padding_4px">
                                        <cc4:DropDownGlobalCodes ID="DropDownList_CustomDocumentDiagnosticAssessments_AlcoholUsePastFrequency"
                                            TabIndex="15" Width="165px" runat="server" AddBlankRow="true" BlankRowText=""
                                            Category="XFREQUENCYUSE">
                                        </cc4:DropDownGlobalCodes>
                                    </td>
                                    <td class="substanceUselasttd">
                                        <table class="checkbox_container substanceUsenoneborder">
                                            <tr>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_AlcoholUseReceivedTreatment_Y"
                                                        name="RadioButton_CustomDocumentDiagnosticAssessments_AlcoholUseReceivedTreatment"
                                                        value="Y" tabindex="16" />
                                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_AlcoholUseReceivedTreatment_Y">
                                                        Yes</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_AlcoholUseReceivedTreatment_N"
                                                        name="RadioButton_CustomDocumentDiagnosticAssessments_AlcoholUseReceivedTreatment"
                                                        value="N" tabindex="17" />
                                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_AlcoholUseReceivedTreatment_N">
                                                        No</label>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="form_label">
                                        <span>Cocaine / Crack </span>
                                    </td>
                                    <td>
                                        <table class="checkbox_container substanceUsenoneborder">
                                            <tr>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_CocaineUseWithin30Days_Y"
                                                        name="RadioButton_CustomDocumentDiagnosticAssessments_CocaineUseWithin30Days"
                                                        value="Y" tabindex="18" />
                                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_CocaineUseWithin30Days_Y">
                                                        Yes</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_CocaineUseWithin30Days_N"
                                                        name="RadioButton_CustomDocumentDiagnosticAssessments_CocaineUseWithin30Days"
                                                        checked="checked" value="N" tabindex="19" />
                                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_CocaineUseWithin30Days_N">
                                                        No</label>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td class="padding_4px">
                                        <cc4:DropDownGlobalCodes ID="DropDownList_CustomDocumentDiagnosticAssessments_CocaineUseCurrentFrequency"
                                            TabIndex="20" Width="165px" runat="server" AddBlankRow="true" BlankRowText=""
                                            Category="XFREQUENCYUSE">
                                        </cc4:DropDownGlobalCodes>
                                    </td>
                                    <td>
                                        <table class="checkbox_container substanceUsenoneborder">
                                            <tr>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_CocaineUseWithinLifetime_Y"
                                                        name="RadioButton_CustomDocumentDiagnosticAssessments_CocaineUseWithinLifetime"
                                                        value="Y" tabindex="21" />
                                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_CocaineUseWithinLifetime_Y">
                                                        Yes</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_CocaineUseWithinLifetime_N"
                                                        name="RadioButton_CustomDocumentDiagnosticAssessments_CocaineUseWithinLifetime"
                                                        value="N" tabindex="22" />
                                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_CocaineUseWithinLifetime_N">
                                                        No</label>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td class="padding_4px">
                                        <cc4:DropDownGlobalCodes ID="DropDownList_CustomDocumentDiagnosticAssessments_CocaineUsePastFrequency"
                                            TabIndex="23" Width="165px" runat="server" AddBlankRow="true" BlankRowText=""
                                            Category="XFREQUENCYUSE">
                                        </cc4:DropDownGlobalCodes>
                                    </td>
                                    <td class="substanceUselasttd">
                                        <table class="checkbox_container substanceUsenoneborder">
                                            <tr>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_CocaineUseReceivedTreatment_Y"
                                                        name="RadioButton_CustomDocumentDiagnosticAssessments_CocaineUseReceivedTreatment"
                                                        value="Y" tabindex="24" />
                                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_CocaineUseReceivedTreatment_Y">
                                                        Yes</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_CocaineUseReceivedTreatment_N"
                                                        name="RadioButton_CustomDocumentDiagnosticAssessments_CocaineUseReceivedTreatment"
                                                        value="N" tabindex="25" />
                                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_CocaineUseReceivedTreatment_N">
                                                        No</label>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="form_label">
                                        <span>Sedatives /Hypnotics(Benzos, Xanax, Ativan, Valium, Ambien, etc.) </span>
                                    </td>
                                    <td>
                                        <table class="checkbox_container substanceUsenoneborder">
                                            <tr>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_SedtativeUseWithin30Days_Y"
                                                        name="RadioButton_CustomDocumentDiagnosticAssessments_SedtativeUseWithin30Days"
                                                        value="Y" tabindex="26" />
                                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_SedtativeUseWithin30Days_Y">
                                                        Yes</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_SedtativeUseWithin30Days_N"
                                                        name="RadioButton_CustomDocumentDiagnosticAssessments_SedtativeUseWithin30Days"
                                                        checked="checked" value="N" tabindex="27" />
                                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_SedtativeUseWithin30Days_N">
                                                        No</label>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td class="padding_4px">
                                        <cc4:DropDownGlobalCodes ID="DropDownList_CustomDocumentDiagnosticAssessments_SedtativeUseCurrentFrequency"
                                            TabIndex="28" Width="165px" runat="server" AddBlankRow="true" BlankRowText=""
                                            Category="XFREQUENCYUSE">
                                        </cc4:DropDownGlobalCodes>
                                    </td>
                                    <td>
                                        <table class="checkbox_container substanceUsenoneborder">
                                            <tr>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_SedtativeUseWithinLifetime_Y"
                                                        name="RadioButton_CustomDocumentDiagnosticAssessments_SedtativeUseWithinLifetime"
                                                        value="Y" tabindex="29" />
                                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_SedtativeUseWithinLifetime_Y">
                                                        Yes</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_SedtativeUseWithinLifetime_N"
                                                        name="RadioButton_CustomDocumentDiagnosticAssessments_SedtativeUseWithinLifetime"
                                                        value="N" tabindex="30" />
                                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_SedtativeUseWithinLifetime_N">
                                                        No</label>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td class="padding_4px">
                                        <cc4:DropDownGlobalCodes ID="DropDownList_CustomDocumentDiagnosticAssessments_SedtativeUsePastFrequency"
                                            TabIndex="31" Width="165px" runat="server" AddBlankRow="true" BlankRowText=""
                                            Category="XFREQUENCYUSE">
                                        </cc4:DropDownGlobalCodes>
                                    </td>
                                    <td class="substanceUselasttd">
                                        <table class="checkbox_container substanceUsenoneborder">
                                            <tr>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_SedtativeUseReceivedTreatment_Y"
                                                        name="RadioButton_CustomDocumentDiagnosticAssessments_SedtativeUseReceivedTreatment"
                                                        value="Y" tabindex="32" />
                                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_SedtativeUseReceivedTreatment_Y">
                                                        Yes</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_SedtativeUseReceivedTreatment_N"
                                                        name="RadioButton_CustomDocumentDiagnosticAssessments_SedtativeUseReceivedTreatment"
                                                        value="N" tabindex="33" />
                                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_SedtativeUseReceivedTreatment_N">
                                                        No</label>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="form_label">
                                        <span>Hallucinogens(Acid, LSD, Ecstasy, etc.) </span>
                                    </td>
                                    <td>
                                        <table class="checkbox_container substanceUsenoneborder">
                                            <tr>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_HallucinogenUseWithin30Days_Y"
                                                        name="RadioButton_CustomDocumentDiagnosticAssessments_HallucinogenUseWithin30Days"
                                                        value="Y" tabindex="34" />
                                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_HallucinogenUseWithin30Days_Y">
                                                        Yes</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_HallucinogenUseWithin30Days_N"
                                                        name="RadioButton_CustomDocumentDiagnosticAssessments_HallucinogenUseWithin30Days"
                                                        checked="checked" value="N" tabindex="35" />
                                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_HallucinogenUseWithin30Days_N">
                                                        No</label>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td class="padding_4px">
                                        <cc4:DropDownGlobalCodes ID="DropDownList_CustomDocumentDiagnosticAssessments_HallucinogenUseCurrentFrequency"
                                            TabIndex="36" Width="165px" runat="server" AddBlankRow="true" BlankRowText=""
                                            Category="XFREQUENCYUSE">
                                        </cc4:DropDownGlobalCodes>
                                    </td>
                                    <td>
                                        <table class="checkbox_container substanceUsenoneborder">
                                            <tr>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_HallucinogenUseWithinLifetime_Y"
                                                        name="RadioButton_CustomDocumentDiagnosticAssessments_HallucinogenUseWithinLifetime"
                                                        value="Y" tabindex="37" />
                                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_HallucinogenUseWithinLifetime_Y">
                                                        Yes</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_HallucinogenUseWithinLifetime_N"
                                                        name="RadioButton_CustomDocumentDiagnosticAssessments_HallucinogenUseWithinLifetime"
                                                        value="N" tabindex="38" />
                                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_HallucinogenUseWithinLifetime_N">
                                                        No</label>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td class="padding_4px">
                                        <cc4:DropDownGlobalCodes ID="DropDownList_CustomDocumentDiagnosticAssessments_HallucinogenUsePastFrequency"
                                            TabIndex="39" Width="165px" runat="server" AddBlankRow="true" BlankRowText=""
                                            Category="XFREQUENCYUSE">
                                        </cc4:DropDownGlobalCodes>
                                    </td>
                                    <td class="substanceUselasttd">
                                        <table class="checkbox_container substanceUsenoneborder">
                                            <tr>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_HallucinogenUseReceivedTreatment_Y"
                                                        name="RadioButton_CustomDocumentDiagnosticAssessments_HallucinogenUseReceivedTreatment"
                                                        value="Y" tabindex="40" />
                                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_HallucinogenUseReceivedTreatment_Y">
                                                        Yes</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_HallucinogenUseReceivedTreatment_N"
                                                        name="RadioButton_CustomDocumentDiagnosticAssessments_HallucinogenUseReceivedTreatment"
                                                        value="N" tabindex="41" />
                                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_HallucinogenUseReceivedTreatment_N">
                                                        No</label>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="form_label">
                                        <span>Stimulants </span>
                                    </td>
                                    <td>
                                        <table class="checkbox_container substanceUsenoneborder">
                                            <tr>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_StimulantUseWithin30Days_Y"
                                                        name="RadioButton_CustomDocumentDiagnosticAssessments_StimulantUseWithin30Days"
                                                        value="Y" tabindex="42" />
                                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_StimulantUseWithin30Days_Y">
                                                        Yes</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_StimulantUseWithin30Days_N"
                                                        name="RadioButton_CustomDocumentDiagnosticAssessments_StimulantUseWithin30Days"
                                                        checked="checked" value="N" tabindex="43" />
                                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_StimulantUseWithin30Days_N">
                                                        No</label>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td class="padding_4px">
                                        <cc4:DropDownGlobalCodes ID="DropDownList_CustomDocumentDiagnosticAssessments_StimulantUseCurrentFrequency"
                                            TabIndex="44" Width="165px" runat="server" AddBlankRow="true" BlankRowText=""
                                            Category="XFREQUENCYUSE">
                                        </cc4:DropDownGlobalCodes>
                                    </td>
                                    <td>
                                        <table class="checkbox_container substanceUsenoneborder">
                                            <tr>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_StimulantUseWithinLifetime_Y"
                                                        name="RadioButton_CustomDocumentDiagnosticAssessments_StimulantUseWithinLifetime"
                                                        value="Y" tabindex="45" />
                                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_StimulantUseWithinLifetime_Y">
                                                        Yes</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_StimulantUseWithinLifetime_N"
                                                        name="RadioButton_CustomDocumentDiagnosticAssessments_StimulantUseWithinLifetime"
                                                        value="N" tabindex="46" />
                                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_StimulantUseWithinLifetime_N">
                                                        No</label>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td class="padding_4px">
                                        <cc4:DropDownGlobalCodes ID="DropDownList_CustomDocumentDiagnosticAssessments_StimulantUsePastFrequency"
                                            TabIndex="47" Width="165px" runat="server" AddBlankRow="true" BlankRowText=""
                                            Category="XFREQUENCYUSE">
                                        </cc4:DropDownGlobalCodes>
                                    </td>
                                    <td class="substanceUselasttd">
                                        <table class="checkbox_container substanceUsenoneborder">
                                            <tr>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_StimulantUseReceivedTreatment_Y"
                                                        name="RadioButton_CustomDocumentDiagnosticAssessments_StimulantUseReceivedTreatment"
                                                        value="Y" tabindex="48" />
                                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_StimulantUseReceivedTreatment_Y">
                                                        Yes</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_StimulantUseReceivedTreatment_N"
                                                        name="RadioButton_CustomDocumentDiagnosticAssessments_StimulantUseReceivedTreatment"
                                                        value="N" tabindex="49" />
                                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_StimulantUseReceivedTreatment_N">
                                                        No</label>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="form_label">
                                        <span>Narcotics(Heroin, Opium,Morphine,Methadone, etc.) </span>
                                    </td>
                                    <td>
                                        <table class="checkbox_container substanceUsenoneborder">
                                            <tr>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_NarcoticUseWithin30Days_Y"
                                                        name="RadioButton_CustomDocumentDiagnosticAssessments_NarcoticUseWithin30Days"
                                                        value="Y" tabindex="50" />
                                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_NarcoticUseWithin30Days_Y">
                                                        Yes</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_NarcoticUseWithin30Days_N"
                                                        name="RadioButton_CustomDocumentDiagnosticAssessments_NarcoticUseWithin30Days"
                                                        checked="checked" value="N" tabindex="51" />
                                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_NarcoticUseWithin30Days_N">
                                                        No</label>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td class="padding_4px">
                                        <cc4:DropDownGlobalCodes ID="DropDownList_CustomDocumentDiagnosticAssessments_NarcoticUseCurrentFrequency"
                                            TabIndex="52" Width="165px" runat="server" AddBlankRow="true" BlankRowText=""
                                            Category="XFREQUENCYUSE">
                                        </cc4:DropDownGlobalCodes>
                                    </td>
                                    <td>
                                        <table class="checkbox_container substanceUsenoneborder">
                                            <tr>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_NarcoticUseWithinLifetime_Y"
                                                        name="RadioButton_CustomDocumentDiagnosticAssessments_NarcoticUseWithinLifetime"
                                                        value="Y" tabindex="53" />
                                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_NarcoticUseWithinLifetime_Y">
                                                        Yes</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_NarcoticUseWithinLifetime_N"
                                                        name="RadioButton_CustomDocumentDiagnosticAssessments_NarcoticUseWithinLifetime"
                                                        value="N" tabindex="54" />
                                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_NarcoticUseWithinLifetime_N">
                                                        No</label>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td class="padding_4px">
                                        <cc4:DropDownGlobalCodes ID="DropDownList_CustomDocumentDiagnosticAssessments_NarcoticUsePastFrequency"
                                            TabIndex="55" Width="165px" runat="server" AddBlankRow="true" BlankRowText=""
                                            Category="XFREQUENCYUSE">
                                        </cc4:DropDownGlobalCodes>
                                    </td>
                                    <td class="substanceUselasttd">
                                        <table class="checkbox_container substanceUsenoneborder">
                                            <tr>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_NarcoticUseReceivedTreatment_Y"
                                                        name="RadioButton_CustomDocumentDiagnosticAssessments_NarcoticUseReceivedTreatment"
                                                        value="Y" tabindex="56" />
                                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_NarcoticUseReceivedTreatment_Y">
                                                        Yes</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_NarcoticUseReceivedTreatment_N"
                                                        name="RadioButton_CustomDocumentDiagnosticAssessments_NarcoticUseReceivedTreatment"
                                                        value="N" tabindex="57" />
                                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_NarcoticUseReceivedTreatment_N">
                                                        No</label>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="form_label">
                                        <span>Marijuana </span>
                                    </td>
                                    <td>
                                        <table class="checkbox_container substanceUsenoneborder">
                                            <tr>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_MarijuanaUseWithin30Days_Y"
                                                        name="RadioButton_CustomDocumentDiagnosticAssessments_MarijuanaUseWithin30Days"
                                                        value="Y" tabindex="58" />
                                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_MarijuanaUseWithin30Days_Y">
                                                        Yes</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_MarijuanaUseWithin30Days_N"
                                                        name="RadioButton_CustomDocumentDiagnosticAssessments_MarijuanaUseWithin30Days"
                                                        checked="checked" value="N" tabindex="59" />
                                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_MarijuanaUseWithin30Days_N">
                                                        No</label>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td class="padding_4px">
                                        <cc4:DropDownGlobalCodes ID="DropDownList_CustomDocumentDiagnosticAssessments_MarijuanaUseCurrentFrequency"
                                            TabIndex="60" Width="165px" runat="server" AddBlankRow="true" BlankRowText=""
                                            Category="XFREQUENCYUSE">
                                        </cc4:DropDownGlobalCodes>
                                    </td>
                                    <td>
                                        <table class="checkbox_container substanceUsenoneborder">
                                            <tr>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_MarijuanaUseWithinLifetime_Y"
                                                        name="RadioButton_CustomDocumentDiagnosticAssessments_MarijuanaUseWithinLifetime"
                                                        value="Y" tabindex="61" />
                                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_MarijuanaUseWithinLifetime_Y">
                                                        Yes</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_MarijuanaUseWithinLifetime_N"
                                                        name="RadioButton_CustomDocumentDiagnosticAssessments_MarijuanaUseWithinLifetime"
                                                        value="N" tabindex="62" />
                                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_MarijuanaUseWithinLifetime_N">
                                                        No</label>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td class="padding_4px">
                                        <cc4:DropDownGlobalCodes ID="DropDownList_CustomDocumentDiagnosticAssessments_MarijuanaUsePastFrequency"
                                            TabIndex="63" Width="165px" runat="server" AddBlankRow="true" BlankRowText=""
                                            Category="XFREQUENCYUSE">
                                        </cc4:DropDownGlobalCodes>
                                    </td>
                                    <td class="substanceUselasttd">
                                        <table class="checkbox_container substanceUsenoneborder">
                                            <tr>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_MarijuanaUseReceivedTreatment_Y"
                                                        name="RadioButton_CustomDocumentDiagnosticAssessments_MarijuanaUseReceivedTreatment"
                                                        value="Y" tabindex="64" />
                                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_MarijuanaUseReceivedTreatment_Y">
                                                        Yes</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_MarijuanaUseReceivedTreatment_N"
                                                        name="RadioButton_CustomDocumentDiagnosticAssessments_MarijuanaUseReceivedTreatment"
                                                        value="N" tabindex="65" />
                                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_MarijuanaUseReceivedTreatment_N">
                                                        No</label>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="form_label">
                                        <span>Inhalants </span>
                                    </td>
                                    <td>
                                        <table class="checkbox_container substanceUsenoneborder">
                                            <tr>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_InhalantsUseWithin30Days_Y"
                                                        name="RadioButton_CustomDocumentDiagnosticAssessments_InhalantsUseWithin30Days"
                                                        value="Y" tabindex="66" />
                                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_InhalantsUseWithin30Days_Y">
                                                        Yes</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_InhalantsUseWithin30Days_N"
                                                        name="RadioButton_CustomDocumentDiagnosticAssessments_InhalantsUseWithin30Days"
                                                        checked="checked" value="N" tabindex="67" />
                                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_InhalantsUseWithin30Days_N">
                                                        No</label>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td class="padding_4px">
                                        <cc4:DropDownGlobalCodes ID="DropDownList_CustomDocumentDiagnosticAssessments_InhalantsUseCurrentFrequency"
                                            TabIndex="68" Width="165px" runat="server" AddBlankRow="true" BlankRowText=""
                                            Category="XFREQUENCYUSE">
                                        </cc4:DropDownGlobalCodes>
                                    </td>
                                    <td>
                                        <table class="checkbox_container substanceUsenoneborder">
                                            <tr>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_InhalantsUseWithinLifetime_Y"
                                                        name="RadioButton_CustomDocumentDiagnosticAssessments_InhalantsUseWithinLifetime"
                                                        value="Y" tabindex="69" />
                                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_InhalantsUseWithinLifetime_Y">
                                                        Yes</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_InhalantsUseWithinLifetime_N"
                                                        name="RadioButton_CustomDocumentDiagnosticAssessments_InhalantsUseWithinLifetime"
                                                        value="N" tabindex="70" />
                                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_InhalantsUseWithinLifetime_N">
                                                        No</label>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td class="padding_4px">
                                        <cc4:DropDownGlobalCodes ID="DropDownList_CustomDocumentDiagnosticAssessments_InhalantsUsePastFrequency"
                                            TabIndex="71" Width="165px" runat="server" AddBlankRow="true" BlankRowText=""
                                            Category="XFREQUENCYUSE">
                                        </cc4:DropDownGlobalCodes>
                                    </td>
                                    <td class="substanceUselasttd">
                                        <table class="checkbox_container substanceUsenoneborder">
                                            <tr>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_InhalantsUseReceivedTreatment_Y"
                                                        name="RadioButton_CustomDocumentDiagnosticAssessments_InhalantsUseReceivedTreatment"
                                                        value="Y" tabindex="72" />
                                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_InhalantsUseReceivedTreatment_Y">
                                                        Yes</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_InhalantsUseReceivedTreatment_N"
                                                        name="RadioButton_CustomDocumentDiagnosticAssessments_InhalantsUseReceivedTreatment"
                                                        value="N" tabindex="73" />
                                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_InhalantsUseReceivedTreatment_N">
                                                        No</label>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr class="substanceUselastrow">
                                    <td class="form_label">
                                        <span>Other </span>
                                        <input type="text" id="TextBox_CustomDocumentDiagnosticAssessments_OtherUseType"
                                            name="TextBox_CustomDocumentDiagnosticAssessments_OtherUseType" maxlength="20"
                                            maxlength="250" tabindex="74" class="form_textbox" />
                                    </td>
                                    <td>
                                        <table class="checkbox_container substanceUsenoneborder">
                                            <tr>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_OtherUseWithin30Days_Y"
                                                        name="RadioButton_CustomDocumentDiagnosticAssessments_OtherUseWithin30Days" value="Y"
                                                        tabindex="75" />
                                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_OtherUseWithin30Days_Y">
                                                        Yes</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_OtherUseWithin30Days_N"
                                                        name="RadioButton_CustomDocumentDiagnosticAssessments_OtherUseWithin30Days" value="N"
                                                        checked="checked" tabindex="76" />
                                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_OtherUseWithin30Days_N">
                                                        No</label>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td class="padding_4px">
                                        <cc4:DropDownGlobalCodes ID="DropDownList_CustomDocumentDiagnosticAssessments_OtherUseCurrentFrequency"
                                            TabIndex="77" Width="165px" runat="server" AddBlankRow="true" BlankRowText=""
                                            Category="XFREQUENCYUSE">
                                        </cc4:DropDownGlobalCodes>
                                    </td>
                                    <td>
                                        <table class="checkbox_container substanceUsenoneborder">
                                            <tr>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_OtherUseWithinLifetime_Y"
                                                        name="RadioButton_CustomDocumentDiagnosticAssessments_OtherUseWithinLifetime"
                                                        value="Y" tabindex="78" />
                                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_OtherUseWithinLifetime_Y">
                                                        Yes</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_OtherUseWithinLifetime_N"
                                                        name="RadioButton_CustomDocumentDiagnosticAssessments_OtherUseWithinLifetime"
                                                        value="N" tabindex="79" />
                                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_OtherUseWithinLifetime_N">
                                                        No</label>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td class="padding_4px">
                                        <cc4:DropDownGlobalCodes ID="DropDownList_CustomDocumentDiagnosticAssessments_OtherUsePastFrequency"
                                            TabIndex="80" Width="165px" runat="server" AddBlankRow="true" BlankRowText=""
                                            Category="XFREQUENCYUSE">
                                        </cc4:DropDownGlobalCodes>
                                    </td>
                                    <td class="substanceUselasttd">
                                        <table class="checkbox_container substanceUsenoneborder">
                                            <tr>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_OtherUseReceivedTreatment_Y"
                                                        name="RadioButton_CustomDocumentDiagnosticAssessments_OtherUseReceivedTreatment"
                                                        value="Y" tabindex="81" />
                                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_OtherUseReceivedTreatment_Y">
                                                        Yes</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_OtherUseReceivedTreatment_N"
                                                        name="RadioButton_CustomDocumentDiagnosticAssessments_OtherUseReceivedTreatment"
                                                        value="N" tabindex="82" />
                                                    <label for="RadioButton_CustomDocumentDiagnosticAssessments_OtherUseReceivedTreatment_N">
                                                        No</label>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td class="height3">
            </td>
        </tr>
        <tr>
            <td>
                <table cellpadding="0" cellspacing="0" width="100%" id="Table_HisSubReportResultsTop">
                    <tr>
                        <td colspan="4">
                            <table cellspacing="0" cellpadding="0" border="0" width="100%" nowrap='nowrap'>
                                <tr>
                                    <td class="form_label content_tab_left" style="width: 50%">
                                        <span>Report results of the substance abuse scales if they were used:</span>
                                    </td>
                                    <td width="17">
                                        <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif"
                                            width="17" height="26" alt="" />
                                    </td>
                                    <td class="content_tab_top" width="80%">
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
                        <td class="content_tab_bg" colspan="4">
                            <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                <tr id="TR_HisSuDastScore">
                                    <td>
                                        <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                            <tr>
                                                <td class="height3" colspan="4">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="width: 1%">
                                                </td>
                                                <td style="width: 8%">
                                                    <span>DAST Score:</span>
                                                </td>
                                                <td style="width: 20%">
                                                    <input type="text" id="TextBox_CustomDocumentDiagnosticAssessments_DASTScore" name="TextBox_CustomDocumentDiagnosticAssessments_DASTScore"
                                                        datatype="Numeric" style="width: 150px;" maxlength="20" tabindex="83" class="form_textbox" />
                                                </td>
                                                <td style="width: 71%" class="form_label">
                                                    <span>(6+ is significant, recommend treatment above education only)</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height3" colspan="4">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="width: 1%">
                                                </td>
                                                <td style="width: 8%">
                                                    <span>MAST Score:</span>
                                                </td>
                                                <td style="width: 20%">
                                                    <input type="text" id="TextBox_CustomDocumentDiagnosticAssessments_MASTScore" name="TextBox_CustomDocumentDiagnosticAssessments_MASTScore"
                                                        datatype="Numeric" style="width: 150px;" maxlength="20" tabindex="84" class="form_textbox" />
                                                </td>
                                                <td style="width: 71%" class="form_label">
                                                    <span>(3+ is significant, recommend treatment above education only)</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height3" colspan="4">
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4">
                                        <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                            <tr>
                                                <td style="width: 1%">
                                                </td>
                                                <td style="width: 99%">
                                                    <span>Was the client referred for substance abuse treatment or a full substance abuse
                                                        assessment, if indicated?</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height4" colspan="2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="2">
                                                    <table class="checkbox_container" cellpadding="0" cellspacing="0" border="0" width="100%">
                                                        <tr>
                                                            <td style="width: 1%">
                                                            </td>
                                                            <td style="width: 95%">
                                                                <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_ClientReferredSubstanceTreatment_Y"
                                                                    name="RadioButton_CustomDocumentDiagnosticAssessments_ClientReferredSubstanceTreatment"
                                                                    value="Y" tabindex="85" />
                                                                <label for="RadioButton_CustomDocumentDiagnosticAssessments_ClientReferredSubstanceTreatment_Y">
                                                                    Yes</label>&nbsp; &nbsp; <span>Where:</span>
                                                                <input type="text" id="TextBox_CustomDocumentDiagnosticAssessments_ClientReferredSubstanceTreatmentWhere"
                                                                    name="TextBox_CustomDocumentDiagnosticAssessments_ClientReferredSubstanceTreatmentWhere"
                                                                    maxlength="20" tabindex="86" class="form_textbox" style="width: 150px;" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height4" colspan="2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 1%">
                                                            </td>
                                                            <td style="width: 99%">
                                                                <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_ClientReferredSubstanceTreatment_N"
                                                                    name="RadioButton_CustomDocumentDiagnosticAssessments_ClientReferredSubstanceTreatment"
                                                                    value="N" tabindex="87" />
                                                                <label for="RadioButton_CustomDocumentDiagnosticAssessments_ClientReferredSubstanceTreatment_N">
                                                                    No, client refused referral.</label>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height4" colspan="2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 1%">
                                                            </td>
                                                            <td style="width: 99%">
                                                                <input type="radio" id="RadioButton_CustomDocumentDiagnosticAssessments_ClientReferredSubstanceTreatment_A"
                                                                    name="RadioButton_CustomDocumentDiagnosticAssessments_ClientReferredSubstanceTreatment"
                                                                    value="A" tabindex="88" />
                                                                <label for="RadioButton_CustomDocumentDiagnosticAssessments_ClientReferredSubstanceTreatment_A">
                                                                    No, client is already receiving substance abuse treatment or assessment.</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td colspan="4">
                <table border="0" cellspacing="0" cellpadding="0" width="100%" id="Table_HisSubReportResultsBot">
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
</div>
