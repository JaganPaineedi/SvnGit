<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Outcomes.ascx.cs" Inherits="SHS.SmartCare.Custom_Screenings_WebPages_Outcomes" %>
<%@ Register Assembly="Streamline.DotNetDropDowns" Namespace="Streamline.DotNetDropDowns"
    TagPrefix="cc2" %>
<asp:Panel ID="PanelMain" runat="server">
    <div class="DocumentScreen">
        <table cellpadding="0" cellspacing="0" border="0" style="vertical-align: top;" class="DocumentScreen">
            <tr>
                <td>
                    <table cellspacing="0" cellpadding="0" border="0" width="100%">
                        <tr>
                            <td>
                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                    <tr>
                                        <td class="content_tab_left" align="left" nowrap='nowrap'>
                                            <span id="SpanOutComes">OutComes</span>
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
                        <tr style="vertical-align: top;">
                            <td class="content_tab_bg" style="padding-right: 8px">
                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                    <tr>
                                        <td align="center" style="padding-left: 10px; width: 30%;font-weight:bold;">
                                            <span id="SpanProblemArea">Problem Area</span>
                                        </td>
                                        <td align="center" style="width: 10%;font-weight:bold;">
                                            <span id="Spanoutcme">Outcome</span>
                                        </td>
                                        <td align="center" style="padding-left: 10px;font-weight:bold;">
                                            <span id="Spanfollowupsteps">Follow-up Steps</span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 10px; width: 30%;">
                                            <span id="SpanPotential">Potential Substance Abuse Consumer?</span>
                                        </td>
                                        <td style="width: 10%;">
                                            <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentOutComesScreenings_SubstanceAbuseConsumer"
                                                Style="width: 100%;" runat="server" ClientInstanceName="DropDownList_CustomDocumentOutComesScreenings_SubstanceAbuseConsumerDevXInstance">
                                            </cc2:StreamlineDropDowns>
                                        </td>
                                        <td align="right" style="padding-left: 10px;">
                                            <input id="TextBox_CustomDocumentOutComesScreenings_SubstanceAbuseConsumerSteps"
                                                name="TextBox_CustomDocumentOutComesScreenings_SubstanceAbuseConsumerSteps" type="text"
                                                maxlength="500" class="form_textbox" style="width: 500px" runat="server" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 10px; width: 30%;">
                                            <span id="SpanHealth">Potential Mental Health Consumer?</span>
                                        </td>
                                        <td style="width: 10%;">
                                            <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentOutComesScreenings_MentalHealthConsumer"
                                                Style="width: 100%;" runat="server" ClientInstanceName="DropDownList_CustomDocumentOutComesScreenings_MentalHealthConsumerDevXInstance">
                                            </cc2:StreamlineDropDowns>
                                        </td>
                                        <td align="right" style="padding-left: 10px;">
                                            <input id="TextBox_CustomDocumentOutComesScreenings_MentalHealthConsumerSteps" name="TextBox_CustomDocumentOutComesScreenings_MentalHealthConsumerSteps"
                                                type="text" maxlength="500" class="form_textbox" style="width: 500px" runat="server" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 10px; width: 30%;">
                                            <span id="Spanassessment">Does Consumer need FASD assessment?</span>
                                        </td>
                                        <td style="width: 10%;">
                                            <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentOutComesScreenings_FASDAssessment"
                                                Style="width: 100%;" runat="server" ClientInstanceName="DropDownList_CustomDocumentOutComesScreenings_FASDAssessmentDevXInstance">
                                            </cc2:StreamlineDropDowns>
                                        </td>
                                        <td align="right" style="padding-left: 10px;">
                                            <input id="TextBox_CustomDocumentOutComesScreenings_FASDAssessmentSteps" name="TextBox_CustomDocumentOutComesScreenings_FASDAssessmentSteps"
                                                type="text" maxlength="500" class="form_textbox" style="width: 500px" runat="server" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 10px;">
                                            <span id="SpanDiagnosed">Potential Dual Diagnosed (MH and SA) Consumer?</span>
                                        </td>
                                        <td style="width: 10%;">
                                            <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentOutComesScreenings_MHAndSAConsumer"
                                                Style="width: 100%;" runat="server" ClientInstanceName="DropDownList_CustomDocumentOutComesScreenings_MHAndSAConsumerDevXInstance">
                                            </cc2:StreamlineDropDowns>
                                        </td>
                                        <td align="right" style="padding-left: 10px;">
                                            <input id="TextBox_CustomDocumentOutComesScreenings_MHAndSAConsumerSteps" name="TextBox_CustomDocumentOutComesScreenings_MHAndSAConsumerSteps"
                                                type="text" maxlength="500" class="form_textbox" style="width: 500px" runat="server" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 10px; width: 30%;">
                                            <span id="SpanPotential">Evidence of Traumatic Brain Injury?</span>
                                        </td>
                                        <td style="width: 10%;">
                                            <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentOutComesScreenings_EvidenceOfInjury"
                                                Style="width: 100%;" runat="server" ClientInstanceName="DropDownList_CustomDocumentOutComesScreenings_EvidenceOfInjuryDevXInstance">
                                            </cc2:StreamlineDropDowns>
                                        </td>
                                        <td align="right" style="padding-left: 10px;">
                                            <input id="TextBox_CustomDocumentOutComesScreenings_EvidenceOfInjurySteps" name="TextBox_CustomDocumentOutComesScreenings_EvidenceOfInjurySteps"
                                                type="text" maxlength="500" class="form_textbox" style="width: 500px" runat="server" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2">
                                        </td>
                                    </tr>
                                </table>
                                <table>
                                    <tr>
                                        <td style="padding-left: 5px;">
                                            <span id="SpanComment" style="padding-left: 5px; padding-right: 5px;">Comments</span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 10px;">
                                            <table cellspacing="0" cellpadding="0" border="0" width="80%">
                                                <tr>
                                                    <td>
                                                        <textarea id="TextArea_CustomDocumentOutComesScreenings_Comments" class="form_textarea"
                                                            spellcheck="True" name="TextArea_CustomDocumentOutComesScreenings_Comments" style="width: 820px;
                                                            height: 100px;"></textarea>
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
                    </table>
                </td>
            </tr>
        </table>
    </div>
</asp:Panel>
