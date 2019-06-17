<%@ Control Language="C#" AutoEventWireup="true" CodeFile="SubstanceUse.ascx.cs"
    Inherits="SHS.SmartCare.Custom_Screenings_WebPages_SubstanceUse" %>
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
                                            <span id="SpanSubstance">Substance Abuse Screening</span>
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
                            <td class="content_tab_bg"  style="padding-right: 8px">
                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                    <tr>
                                        <td style="padding-left: 10px; width: 80%;">
                                            <span id="School">1. Have you gotten in trouble at home, at school, at work, or in the
                                                community because of using alcohol, drugs, or inhalants?</span>
                                        </td>
                                        <td style="width: 20%;" align="left">
                                            <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentSubstanceAbuseScreenings_Inhalants"
                                                Style="width: 30%;" runat="server" ClientInstanceName="DropDownList_CustomDocumentSubstanceAbuseScreenings_InhalantsDevXInstance">
                                            </cc2:StreamlineDropDowns>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 10px; width: 80%;">
                                            <span id="Spandrugs">2. Have you missed school or work because of using alcohol, drugs,
                                                or inhalants?</span>
                                        </td>
                                        <td style="width: 20%;" align="left">
                                            <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentSubstanceAbuseScreenings_MissedSchool"
                                                Style="width: 30%;" runat="server" ClientInstanceName="DropDownList_CustomDocumentSubstanceAbuseScreenings_MissedSchoolDevXInstance">
                                            </cc2:StreamlineDropDowns>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 10px; width: 80%;">
                                            <span id="Spanpast">3. In the past year have you ever had 6 or more drinks at any one
                                                time?</span>
                                        </td>
                                        <td style="width: 20%;" align="left">
                                            <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentSubstanceAbuseScreenings_PastYearDrunk"
                                                Style="width: 30%;" runat="server" ClientInstanceName="DropDownList_CustomDocumentSubstanceAbuseScreenings_PastYearDrunkDevXInstance">
                                            </cc2:StreamlineDropDowns>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 10px; width: 80%;">
                                            <span id="Spanrisky">4. Have you done harmful or risky things when you were high?</span>
                                        </td>
                                        <td style="width: 20%;" align="left">
                                            <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentSubstanceAbuseScreenings_RiskyWhenHigh"
                                                Style="width: 30%;" runat="server" ClientInstanceName="DropDownList_CustomDocumentSubstanceAbuseScreenings_RiskyWhenHighDevXInstance">
                                            </cc2:StreamlineDropDowns>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 10px; width: 80%;">
                                            <span id="Spanproblem">5. Do you think you might have a problem with your drinking,
                                                drugs, or inhalant use?</span>
                                        </td>
                                        <td style="width: 20%;" align="left">
                                            <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentSubstanceAbuseScreenings_ProblemWithDrinking"
                                                Style="width: 30%;" runat="server" ClientInstanceName="DropDownList_CustomDocumentSubstanceAbuseScreenings_ProblemWithDrinkingDevXInstance">
                                            </cc2:StreamlineDropDowns>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 10px; width: 80%;">
                                            <span id="Spanalcohol">6. When using alcohol, drugs, or inhalants have you done things
                                                without thinking and later wished you had not?</span>
                                        </td>
                                        <td style="width: 20%;" align="left">
                                            <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentSubstanceAbuseScreenings_ThingsWithoutThinking"
                                                Style="width: 30%;" runat="server" ClientInstanceName="DropDownList_CustomDocumentSubstanceAbuseScreenings_ThingsWithoutThinkingDevXInstance">
                                            </cc2:StreamlineDropDowns>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 10px; width: 80%;">
                                            <span id="Spanpotlatches">7. Do you miss family activities, after school activities,
                                                community events, traditional ceremonies potlatches, or feasts because of using
                                                alcohol, drugs, or inhalants?</span>
                                        </td>
                                        <td style="width: 20%;" align="left">
                                            <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentSubstanceAbuseScreenings_MissFamilyActivities"
                                                Style="width: 30%;" runat="server" ClientInstanceName="DropDownList_CustomDocumentSubstanceAbuseScreenings_MissFamilyActivitiesDevXInstance">
                                            </cc2:StreamlineDropDowns>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 10px; width: 80%;">
                                            <span id="Spancomplain">8. Does anyone close to you worry or complain about using alcohol,
                                                drugs, or inhalants?</span>
                                        </td>
                                        <td style="width: 20%;" align="left">
                                            <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentSubstanceAbuseScreenings_WorryAboutUsingAlcohol"
                                                Style="width: 30%;" runat="server" ClientInstanceName="DropDownList_CustomDocumentSubstanceAbuseScreenings_WorryAboutUsingAlcoholDevXInstance">
                                            </cc2:StreamlineDropDowns>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 10px; width: 80%;">
                                            <span id="Spanfriend">9. Have you lost a friend or hurt a loved one because of your
                                                using alcohol, drugs, or inhalants?</span>
                                        </td>
                                        <td style="width: 20%;" align="left">
                                            <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentSubstanceAbuseScreenings_HurtLovedOne"
                                                Style="width: 30%;" runat="server" ClientInstanceName="DropDownList_CustomDocumentSubstanceAbuseScreenings_HurtLovedOneDevXInstance">
                                            </cc2:StreamlineDropDowns>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 10px; width: 80%;">
                                            <span id="Spanuse">10. Do you use alcohol, drugs, or inhalants to make you feel normal?</span>
                                        </td>
                                        <td style="width: 20%;" align="left">
                                            <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentSubstanceAbuseScreenings_ToFeelNormal"
                                                Style="width: 30%;" runat="server" ClientInstanceName="DropDownList_CustomDocumentSubstanceAbuseScreenings_ToFeelNormalDevXInstance">
                                            </cc2:StreamlineDropDowns>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 10px; width: 80%;">
                                            <span id="Spansomeone">11. Does it make you mad if someone tells you that you drink,
                                                use drugs, or use inhalants too much?</span>
                                        </td>
                                        <td style="width: 20%;" align="left">
                                            <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentSubstanceAbuseScreenings_MakeYouMad"
                                                Style="width: 30%;" runat="server" ClientInstanceName="DropDownList_CustomDocumentSubstanceAbuseScreenings_MakeYouMadDevXInstance">
                                            </cc2:StreamlineDropDowns>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 10px; width: 80%;">
                                            <span id="Spandrugs">12. Do you feel guilty about your alcohol, drug, or inhalant use?</span>
                                        </td>
                                        <td style="width: 20%;" align="left">
                                            <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentSubstanceAbuseScreenings_GuiltyAboutAlcohol"
                                                Style="width: 30%;" runat="server" ClientInstanceName="DropDownList_CustomDocumentSubstanceAbuseScreenings_GuiltyAboutAlcoholDevXInstance">
                                            </cc2:StreamlineDropDowns>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 10px; width: 80%;">
                                            <span id="SpanBingo">13. Do you or other people worry about the amount of money or time
                                                you spend at Bingo, pull tabs, or other gambling activities?</span>
                                        </td>
                                        <td style="width: 20%;" align="left">
                                            <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentSubstanceAbuseScreenings_WorryAboutGamblingActivities"
                                                Style="width: 30%;" runat="server" ClientInstanceName="DropDownList_CustomDocumentSubstanceAbuseScreenings_WorryAboutGamblingActivitiesDevXInstance">
                                            </cc2:StreamlineDropDowns>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 10px; width: 80%;">
                                            <span id="Spanconsumed">14. Has your mother ever consumed alcohol?</span>
                                        </td>
                                        <td  style="width: 20%;" align="left">
                                          <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentSubstanceAbuseScreenings_HasMotherConsumedAlcohol"
                                                Style="width: 30%;" runat="server" ClientInstanceName="DropDownList_CustomDocumentSubstanceAbuseScreenings_HasMotherConsumedAlcoholDevXInstance">
                                            </cc2:StreamlineDropDowns>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 10px; width: 80%;">
                                            <span id="Spanpregnancy">15. If yes, did she drink during her pregnancy with you?</span>
                                        </td>
                                        <td style="width: 20%;" align="left">
                                            <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentSubstanceAbuseScreenings_DidMotherDrinkInPregnancy"
                                                Style="width: 30%;" runat="server" ClientInstanceName="DropDownList_CustomDocumentSubstanceAbuseScreenings_DidMotherDrinkInPregnancyDevXInstance">
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
                                        <td  style="padding-left: 5px;">
                                            <span id="SpanComment" style="padding-left: 5px; padding-right: 5px;">Comments</span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 10px;">
                                            <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                <tr>
                                                    <td>
                                                        <textarea id="TextArea_CustomDocumentSubstanceAbuseScreenings_Comments" class="form_textarea"
                                                            spellcheck="True" name="TextArea_CustomDocumentSubstanceAbuseScreenings_Comments" 
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
