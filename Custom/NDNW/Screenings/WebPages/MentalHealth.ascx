<%@ Control Language="C#" AutoEventWireup="true" CodeFile="MentalHealth.ascx.cs"
    Inherits="SHS.SmartCare.Custom_Screenings_WebPages_MentalHealth" %>
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
                                            <span id="SpanMental">Mental Health Screening</span>
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
                                        <td style="padding-left: 10px; width: 80%;">
                                            <span id="Spandifficulty">1. Do you often have difficulty sitting still and paying attention
                                                at school, work, or social setting?</span>
                                        </td>
                                        <td style="width: 20%;" align="left">
                                            <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentMentalHealthScreenings_PayingAttentionAtSchool"
                                                Style="width: 30%;" runat="server" ClientInstanceName="DropDownList_CustomDocumentMentalHealthScreenings_PayingAttentionAtSchoolDevXInstance">
                                            </cc2:StreamlineDropDowns>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 10px; width: 80%;">
                                            <span id="Spandisturbing">2. Do disturbing thoughts that you can’t get rid of come into
                                                your mind?</span>
                                        </td>
                                        <td style="width: 20%;" align="left">
                                            <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentMentalHealthScreenings_CanNotGetRidOfThought"
                                                Style="width: 30%;" runat="server" ClientInstanceName="DropDownList_CustomDocumentMentalHealthScreenings_CanNotGetRidOfThoughtDevXInstance">
                                            </cc2:StreamlineDropDowns>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 10px; width: 80%;">
                                            <span id="Spanpeople">3. Do you ever hear voices or see things that other people tell
                                                you they don’t see or hear?</span>
                                        </td>
                                        <td style="width: 20%;" align="left">
                                            <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentMentalHealthScreenings_HearVoices"
                                                Style="width: 30%;" runat="server" ClientInstanceName="DropDownList_CustomDocumentMentalHealthScreenings_HearVoicesDevXInstance">
                                            </cc2:StreamlineDropDowns>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 10px; width: 80%;">
                                            <span id="Spankilling">4. Do you spend time thinking about hurting or killing yourself
                                                or anyone else?</span>
                                        </td>
                                        <td style="width: 20%;" align="left">
                                            <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentMentalHealthScreenings_SpendTimeKilling"
                                                Style="width: 30%;" runat="server" ClientInstanceName="DropDownList_CustomDocumentMentalHealthScreenings_SpendTimeKillingDevXInstance">
                                            </cc2:StreamlineDropDowns>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 10px; width: 80%;">
                                            <span id="Spantried">5. Have you ever tried to hurt yourself or commit suicide?</span></td>
                                        <td style="width: 20%;" align="left">
                                            <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentMentalHealthScreenings_TriedToCommitSuicide"
                                                Style="width: 30%;" runat="server" ClientInstanceName="DropDownList_CustomDocumentMentalHealthScreenings_TriedToCommitSuicideDevXInstance">
                                            </cc2:StreamlineDropDowns>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 10px; width: 80%;">
                                            <span id="Spanthink">6. Do you think people are out to get you and you have to watch
                                                your step?</span>
                                        </td>
                                        <td style="width: 20%;" align="left">
                                            <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentMentalHealthScreenings_WatchYourStep"
                                                Style="width: 30%;" runat="server" ClientInstanceName="DropDownList_CustomDocumentMentalHealthScreenings_WatchYourStepDevXInstance">
                                            </cc2:StreamlineDropDowns>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 10px; width: 80%;">
                                            <span id="Spanpounds">7. Do you often find yourself in situations where your heart pounds
                                                and you feel anxious and want to get away?</span>
                                        </td>
                                        <td style="width: 20%;" align="left">
                                            <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentMentalHealthScreenings_FeelAnxious"
                                                Style="width: 30%;" runat="server" ClientInstanceName="DropDownList_CustomDocumentMentalHealthScreenings_FeelAnxiousDevXInstance">
                                            </cc2:StreamlineDropDowns>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 10px; width: 80%;">
                                            <span id="Spanlike">8. Do you sometimes have so much energy that your thoughts come
                                                quickly, you jump from one activity to another, you feel like you don’t need sleep,
                                                like you can do anything?</span>
                                        </td>
                                        <td style="width: 20%;" align="left">
                                            <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentMentalHealthScreenings_ThoughtsComeQuickly"
                                                Style="width: 30%;" runat="server" ClientInstanceName="DropDownList_CustomDocumentMentalHealthScreenings_ThoughtsComeQuicklyDevXInstance">
                                            </cc2:StreamlineDropDowns>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 10px; width: 80%;">
                                            <span id="Spanfire">9. Have you destroyed property or set a fire that caused damage?</span>
                                        </td>
                                        <td style="width: 20%;" align="left">
                                            <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentMentalHealthScreenings_DestroyedProperty"
                                                Style="width: 30%;" runat="server" ClientInstanceName="DropDownList_CustomDocumentMentalHealthScreenings_DestroyedPropertyDevXInstance">
                                            </cc2:StreamlineDropDowns>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 10px; width: 80%;">
                                            <span id="Spanconfused">10. Do you feel trapped, lonely, confused, lost, or 
                                            hopeless about your future?</span>
                                        </td>
                                        <td style="width: 20%;" align="left">
                                            <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentMentalHealthScreenings_FeelTrapped"
                                                Style="width: 30%;" runat="server" ClientInstanceName="DropDownList_CustomDocumentMentalHealthScreenings_FeelTrappedDevXInstance">
                                            </cc2:StreamlineDropDowns>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 10px; width: 80%;">
                                            <span id="Spandissatisfied">11. Do you feel dissatisfied with your life and relationships?</span>
                                        </td>
                                        <td style="width: 20%;" align="left">
                                            <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentMentalHealthScreenings_DissatifiedWithLife"
                                                Style="width: 30%;" runat="server" ClientInstanceName="DropDownList_CustomDocumentMentalHealthScreenings_DissatifiedWithLifeDevXInstance">
                                            </cc2:StreamlineDropDowns>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 10px; width: 80%;">
                                            <span id="Spanearthquake">12. Do you have nightmares, flashbacks, or unpleasant thoughts
                                                because of a terrible event like rape, domestic violence, incest/unwanted touching,
                                                warfare, a bad accident, fights, being or seeing someone shot or stabbed, knowing
                                                or seeing someone who has committed suicide, fire, or natural disasters like earthquake
                                                or flood?</span>
                                        </td>
                                        <td style="width: 20%;" align="left">
                                            <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentMentalHealthScreenings_UnPleasantThoughts"
                                                Style="width: 30%;" runat="server" ClientInstanceName="DropDownList_CustomDocumentMentalHealthScreenings_UnPleasantThoughtsDevXInstance">
                                            </cc2:StreamlineDropDowns>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 10px; width: 80%;">
                                            <span id="Spansleeping">13. Do you have difficulty sleeping or eating?</span>
                                        </td>
                                        <td style="width: 20%;" align="left">
                                            <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentMentalHealthScreenings_DifficultyInSleeping"
                                                Style="width: 30%;" runat="server" ClientInstanceName="DropDownList_CustomDocumentMentalHealthScreenings_DifficultyInSleepingDevXInstance">
                                            </cc2:StreamlineDropDowns>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 10px; width: 80%;">
                                            <span id="Spanthreatened">14. Have you physically harmed or threatened to harm an animal
                                                or person on purpose?</span>
                                        </td>
                                        <td style="width: 20%;" align="left">
                                            <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentMentalHealthScreenings_PhysicallyHarmed"
                                                Style="width: 30%;" runat="server" ClientInstanceName="DropDownList_CustomDocumentMentalHealthScreenings_PhysicallyHarmedDevXInstance">
                                            </cc2:StreamlineDropDowns>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 10px; width: 80%;">
                                            <span id="Spaninterest">15. Have you lost interest or pleasure in school, work, friends,
                                                activities, or other things that you once cared about</span>
                                        </td>
                                        <td style="width: 20%;" align="left">
                                            <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentMentalHealthScreenings_LostInterest"
                                                Style="width: 30%;" runat="server" ClientInstanceName="DropDownList_CustomDocumentMentalHealthScreenings_LostInterestDevXInstance">
                                            </cc2:StreamlineDropDowns>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 10px; width: 80%;">
                                            <span id="Spanwrong">16. Do you feel angry and think about doing things that you know
                                                are wrong?</span>
                                        </td>
                                        <td style="width: 20%;" align="left">
                                            <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentMentalHealthScreenings_FeelAngry"
                                                Style="width: 30%;" runat="server" ClientInstanceName="DropDownList_CustomDocumentMentalHealthScreenings_FeelAngryDevXInstance">
                                            </cc2:StreamlineDropDowns>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 10px; width: 80%;">
                                            <span id="Spantrouble">17. Do you often get into trouble because of breaking the rules?</span>
                                        </td>
                                        <td style="width: 20%;" align="left">
                                            <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentMentalHealthScreenings_GetIntoTrouble"
                                                Style="width: 30%;" runat="server" ClientInstanceName="DropDownList_CustomDocumentMentalHealthScreenings_GetIntoTroubleDevXInstance">
                                            </cc2:StreamlineDropDowns>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 10px; width: 80%;">
                                            <span id="Spanpanicky">18. Do you sometimes feel afraid, panicky, nervous, or scared?</span>
                                        </td>
                                        <td style="width: 20%;" align="left">
                                            <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentMentalHealthScreenings_FeelAfraid"
                                                Style="width: 30%;" runat="server" ClientInstanceName="DropDownList_CustomDocumentMentalHealthScreenings_FeelAfraidDevXInstance">
                                            </cc2:StreamlineDropDowns>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 10px; width: 80%;">
                                            <span id="Spandepressed">19. Do you feel sad or depressed much of the time?</span>
                                        </td>
                                        <td style="width: 20%;" align="left">
                                            <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentMentalHealthScreenings_FeelDepressed"
                                                Style="width: 30%;" runat="server" ClientInstanceName="DropDownList_CustomDocumentMentalHealthScreenings_FeelDepressedDevXInstance">
                                            </cc2:StreamlineDropDowns>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 10px; width: 80%;">
                                            <span id="Spanweight">20. Do you spend a lot of time thinking about your weight or how
                                                much you eat?</span>
                                        </td>
                                        <td style="width: 20%;" align="left">
                                            <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentMentalHealthScreenings_SpendTimeOnThinkingAboutWeight"
                                                Style="width: 30%;" runat="server" ClientInstanceName="DropDownList_CustomDocumentMentalHealthScreenings_SpendTimeOnThinkingAboutWeightDevXInstance">
                                            </cc2:StreamlineDropDowns>
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
                                            <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                <tr>
                                                    <td>
                                                        <textarea id="TextArea_CustomDocumentMentalHealthScreenings_Comments" class="form_textarea"
                                                            spellcheck="True" name="TextArea_CustomDocumentMentalHealthScreenings_Comments"
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
