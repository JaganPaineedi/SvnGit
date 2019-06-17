<%@ Control Language="C#" AutoEventWireup="true" CodeFile="BrainInjury.ascx.cs" Inherits="SHS.SmartCare.Custom_Screenings_WebPages_BrainInjury" %>
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
                                            <span id="SpanBrain">Traumatic Brain Injury Screening</span>
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
                                        <td style="padding-left: 10px; width: 45%;">
                                            <span id="Spanconsciousness">1. Have you ever had a blow to the head that was severe
                                                enough to make you lose consciousness?</span>
                                        </td>
                                        <td style="width: 30%;" align="left">
                                            <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_BlowToTheHead"
                                                Style="width: 30%;" runat="server" ClientInstanceName="DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_BlowToTheHeadDevXInstance">
                                            </cc2:StreamlineDropDowns>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                <tr>
                                                    <td align="left" style="padding-left: 18px; padding-right: 5px; width: 22%;">
                                                        <span id="Spanblow">If yes, when did it occur?</span>
                                                    </td>
                                                    <td align="left">
                                                        <input id="TextBox_CustomDocumentTraumaticBrainInjuryScreenings_HeadBlowWhenDidItOccur"
                                                            name="TextBox_CustomDocumentTraumaticBrainInjuryScreenings_HeadBlowWhenDidItOccur"
                                                            type="text" maxlength="500" class="form_textbox" style="width: 300px" runat="server" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="height2">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="right" style="padding-left: 10px; padding-right: 5px; width: 22%;">
                                                        <span id="Spanunconscious">How long were you unconscious?</span>
                                                    </td>
                                                    <td align="left">
                                                        <input id="TextBox_CustomDocumentTraumaticBrainInjuryScreenings_HowLongUnconscious"
                                                            name="TextBox_CustomDocumentTraumaticBrainInjuryScreenings_HowLongUnconscious"
                                                            type="text" maxlength="500" class="form_textbox" style="width: 300px;" runat="server" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 10px; width: 45%;">
                                            <span id="SpanSevere">2. Have you ever had a blow to the head that was severe enough
                                                to cause a concussion?</span>
                                        </td>
                                        <td style="width: 30%;" align="left">
                                            <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_CauseAConcussion"
                                                Style="width: 30%;" runat="server" ClientInstanceName="DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_CauseAConcussionDevXInstance">
                                            </cc2:StreamlineDropDowns>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                <tr>
                                                    <td style="padding-left: 18px; width: 22%;">
                                                        <span id="SpanWhen">If yes, when did it occur?</span>
                                                    </td>
                                                    <td align="left">
                                                        <input id="TextBox_CustomDocumentTraumaticBrainInjuryScreenings_ConcussionWhenDidItOccur"
                                                            name="TextBox_CustomDocumentTraumaticBrainInjuryScreenings_ConcussionWhenDidItOccur"
                                                            type="text" maxlength="500" class="form_textbox" style="width: 300px" runat="server" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="height2">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="padding-left: 17px; width: 22%;">
                                                        <span id="Spanconcussion">How long did the concussion last?</span>
                                                    </td>
                                                    <td align="left">
                                                        <input id="TextBox_CustomDocumentTraumaticBrainInjuryScreenings_HowLongConcussionLast"
                                                            name="TextBox_CustomDocumentTraumaticBrainInjuryScreenings_HowLongConcussionLast"
                                                            type="text" maxlength="500" class="form_textbox" style="width: 300px" runat="server" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 10px; width: 45%;">
                                            <span id="SpanTreatment">3. Did you receive treatment for the head injury?</span>
                                        </td>
                                        <td style="width: 30%;" align="left">
                                            <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_ReceiveTreatmentForHeadInjury"
                                                Style="width: 30%;" runat="server" ClientInstanceName="DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_ReceiveTreatmentForHeadInjuryDevXInstance">
                                            </cc2:StreamlineDropDowns>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" style="padding-left: 10px; width: 85%;">
                                            <span id="SpanCaused">4. If you had a blow to the head that caused unconsciousness or
                                                a concussion, has there been a permanent change in any of the following:</span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                <tr>
                                                    <td style="width: 3%;">
                                                    </td>
                                                    <td style="width: 35%;">
                                                        <span id="SpanAbilities">Physical Abilities?</span>
                                                    </td>
                                                    <td style="width: 12%;">
                                                        <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_PhysicalAbilities"
                                                            runat="server" ClientInstanceName="DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_PhysicalAbilitiesDevXInstance"
                                                            Style="width: 100%;">
                                                        </cc2:StreamlineDropDowns>
                                                    </td>
                                                    <td style="width: 40%; padding-left: 10px;">
                                                        <span id="SpanMood">Mood?</span>
                                                    </td>
                                                    <td style="width: 10%;">
                                                        <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_Mood"
                                                            runat="server" ClientInstanceName="DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_MoodDevXInstance"
                                                            Style="width: 130%;">
                                                        </cc2:StreamlineDropDowns>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="height2">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 3%;">
                                                    </td>
                                                    <td>
                                                        <span id="SpanAbilitycare">Ability to care for yourself?</span>
                                                    </td>
                                                    <td>
                                                        <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_CareForYourSelf"
                                                            runat="server" ClientInstanceName="DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_CareForYourSelfDevXInstance"
                                                            Style="width: 100%;">
                                                        </cc2:StreamlineDropDowns>
                                                    </td>
                                                    <td style="padding-left: 10px;">
                                                        <span id="SpanTemper">Temper?</span>
                                                    </td>
                                                    <td>
                                                        <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_Temper"
                                                            runat="server" ClientInstanceName="DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_TemperDevXInstance"
                                                            Style="width: 130%;">
                                                        </cc2:StreamlineDropDowns>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="height2">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 3%;">
                                                    </td>
                                                    <td>
                                                        <span id="SpanSpeech">Speech?</span>
                                                    </td>
                                                    <td>
                                                        <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_Speech"
                                                            runat="server" ClientInstanceName="DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_SpeechDevXInstance"
                                                            Style="width: 100%;">
                                                        </cc2:StreamlineDropDowns>
                                                    </td>
                                                    <td style="padding-left: 10px;">
                                                        <span id="SpanRelationships">Relationships with others?</span>
                                                    </td>
                                                    <td>
                                                        <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_RelationshipWithOthers"
                                                            runat="server" ClientInstanceName="DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_RelationshipWithOthersDevXInstance"
                                                            Style="width: 130%;">
                                                        </cc2:StreamlineDropDowns>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="height2">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 3%;">
                                                    </td>
                                                    <td>
                                                        <span id="SpanHearing">Hearing, vision, or other senses?</span>
                                                    </td>
                                                    <td>
                                                        <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_Hearing"
                                                            runat="server" ClientInstanceName="DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_HearingDevXInstance"
                                                            Style="width: 100%;">
                                                        </cc2:StreamlineDropDowns>
                                                    </td>
                                                    <td style="padding-left: 10px;">
                                                        <span id="Spanschool">Ability to work, or do school work?</span>
                                                    </td>
                                                    <td>
                                                        <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_AbilityToWork"
                                                            runat="server" ClientInstanceName="DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_AbilityToWorkDevXInstance"
                                                            Style="width: 130%;">
                                                        </cc2:StreamlineDropDowns>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="height2">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 3%;">
                                                    </td>
                                                    <td>
                                                        <span id="SpanMemory">Memory?</span>
                                                    </td>
                                                    <td>
                                                        <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_Memory"
                                                            runat="server" ClientInstanceName="DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_MemoryDevXInstance"
                                                            Style="width: 100%;">
                                                        </cc2:StreamlineDropDowns>
                                                    </td>
                                                    <td style="padding-left: 10px;">
                                                        <span id="Spanalcohol">Use of alcohol or other drugs?</span>
                                                    </td>
                                                    <td>
                                                        <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_UseOfAlcohol"
                                                            runat="server" ClientInstanceName="DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_UseOfAlcoholDevXInstance"
                                                            Style="width: 130%;">
                                                        </cc2:StreamlineDropDowns>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="height2">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 3%;">
                                                    </td>
                                                    <td>
                                                        <span id="Spanconcentrate">Ability to concentrate?</span>
                                                    </td>
                                                    <td>
                                                        <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_AbilityToConcentrate"
                                                            runat="server" ClientInstanceName="DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_AbilityToConcentrateDevXInstance"
                                                            Style="width: 100%;">
                                                        </cc2:StreamlineDropDowns>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="height2">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="padding-left: 10px;" colspan="4">
                                                        <span id="Spanreceive">5. Did you receive treatment for any of the things that changed
                                                            after head injury?</span>
                                                    </td>
                                                    <td>
                                                        <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_ChangedAfterInjury"
                                                            runat="server" ClientInstanceName="DropDownList_CustomDocumentTraumaticBrainInjuryScreenings_ChangedAfterInjuryDevXInstance"
                                                            Style="width: 130%;">
                                                        </cc2:StreamlineDropDowns>
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
                                        <td class="height2">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 10px;">
                                            <span id="SpanComment" style="padding-left: 5px; padding-right: 5px;">Comments</span>
                                        </td>
                                    </tr>
                                </table>
                                <table>
                                    <tr>
                                        <td  style="padding-left: 10px;">
                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                <tr>
                                                    <td>
                                                        <textarea id="TextArea_CustomDocumentTraumaticBrainInjuryScreenings_Comments" class="form_textarea"
                                                            spellcheck="True" name="TextArea_CustomDocumentTraumaticBrainInjuryScreenings_Comments"
                                                            style="width: 700px; height: 100px"></textarea>
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
