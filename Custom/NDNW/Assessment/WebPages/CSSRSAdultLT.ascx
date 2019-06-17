<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CSSRSAdultLT.ascx.cs"
    Inherits="SHS.SmartCare.Custom_Assessment_WebPages_CSSRSAdultLT" %>
<% if (HttpContext.Current == null)
   { %>
<link href="../../../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet"
    type="text/css" />
<%} %>
<div style="overflow-x: hidden">
    <table cellpadding="0" cellspacing="0" border="0" class="DocumentScreen">
        <tr>
            <td>
                <table id="mainTable" border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                        <td class="height1">&nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                <tr>
                                    <td class="content_tab_left" align="left" nowrap="nowrap">
                                        <span id="SpanSuicidalIdeationBehavior" title="Suicidal Ideation/ Behavior">Suicidal
                                            Ideation/ Behavior</span>
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
                        <td class="content_tab_bg">
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td colspan="6" style="padding-left: 5px; background-color: #dce5ea; height: 20px;">
                                        <span id="SpanSuicidalIdeation" title="Suicidal Ideation" class="form_label"><b>Suicidal
                                            Ideation</b></span>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" style="width: 84%; padding-left: 5px; border-style: solid; border-width: 1px; border-color: #dce5ea; vertical-align: top;">
                                        <span id="SpanAskQuestions" class="form_label">Ask questions 1 and 2.If both are negative,
                                            proceed to "Suicidal Behavior" section. If the answer to question 2 is "Yes", ask
                                            </br> questions 3,4 and 5. If the answer to question 1 and/ or 2 is "Yes", complete
                                            "Intensity of Ideation" section below.</span>
                                    </td>
                                    <td style="width: 8%; border-style: solid; border-width: 1px; border-color: #dce5ea;">
                                        <span id="SpanLifetine" class="form_label"><b>Lifetime: Time He/She Felt Most Suicidal</b></span>
                                    </td>
                                    <td style="width: 8%; border-style: solid; border-width: 1px; border-color: #dce5ea;">
                                        <span id="SpanPast1Month" class="form_label"><b>Past 1 month</b></span>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" style="width: 84%; padding-left: 3px; padding-bottom: 2px; border-style: solid; border-width: 1px; border-color: #dce5ea;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td style="text-align: left;">
                                                    <span id="SpanWishtobeDead" class="form_label"><b>1. Wish to be dead</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="SpanSubject" class="form_label">Subject endorses thoughts about a wish to
                                                        be dead or not alive anymore, or wish to fall asleep and wake up.</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="Spamhaveyouwished" class="form_label"><b>Have you wished you were dead or
                                                        wised you could go to sleep and not wake up?</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="SpanIfYes" class="form_label">If yes, describe:</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <textarea class="form_textarea" id="TextArea_CustomDocumentAdultLTs_DeadDescription"
                                                        name="TextArea_CustomDocumentAdultLTs_DeadDescription" rows="4" cols="1" style="width: 98%;"
                                                        spellcheck="True" datatype="String"></textarea>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 8%; border-style: solid; border-width: 1px; border-color: #dce5ea; text-align: center;">
                                        <asp:DropDownList ID="DropDownList_CustomDocumentAdultLTs_DeadLifeTime" runat="server"
                                            EnableViewState="false" CssClass="form_dropdown" Width="50px">
                                        </asp:DropDownList>
                                    </td>
                                    <td style="width: 8%; border-style: solid; border-width: 1px; border-color: #dce5ea; text-align: center;">
                                        <asp:DropDownList ID="DropDownList_CustomDocumentAdultLTs_DeadPast1Month" runat="server"
                                            EnableViewState="false" CssClass="form_dropdown" Width="50px">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" style="width: 84%; padding-left: 3px; padding-top: 2px; border-style: solid; border-width: 1px; border-color: #dce5ea;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td style="text-align: left;">
                                                    <span id="SpanNonSpecific" class="form_label"><b>2. Non-Specific Active Suicidal Thoughts</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="SpanGeneralNonSpecific" class="form_label">General non-specific thoughts of
                                                        wanting to end one's life/commit suicide (e.g.,"I've thought about killing myself")
                                                        without thoughts of ways</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="Spankilloneself" class="form_label">to kill oneself/associated methods, intent,
                                                        or plan during the assessment period.</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="SpanHaveyouactuallyhad" class="form_label"><b>Have you actually had any thoughts
                                                        of killing yourself?</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="SpanIfYes2" class="form_label">If yes, describe:</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <textarea class="form_textarea" id="TextArea_CustomDocumentAdultLTs_NonSpecificDescription"
                                                        name="TextArea_CustomDocumentAdultLTs_NonSpecificDescription" rows="4" cols="1"
                                                        style="width: 98%;" spellcheck="True" datatype="String"></textarea>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 8%; padding-top: 2px; border-style: solid; border-width: 1px; border-color: #dce5ea; text-align: center;">
                                        <asp:DropDownList ID="DropDownList_CustomDocumentAdultLTs_NonSpecificLifeTime" runat="server"
                                            EnableViewState="false" CssClass="form_dropdown" Width="50px">
                                        </asp:DropDownList>
                                    </td>
                                    <td style="width: 8%; padding-top: 2px; border-style: solid; border-width: 1px; border-color: #dce5ea; text-align: center;">
                                        <asp:DropDownList ID="DropDownList_CustomDocumentAdultLTs_NonSpecificPast1Month" runat="server"
                                            EnableViewState="false" CssClass="form_dropdown" Width="50px">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" style="width: 84%; padding-left: 3px; padding-top: 2px; border-style: solid; border-width: 1px; border-color: #dce5ea;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td>
                                                    <span id="SpanActiveSuicidalIdeation" class="form_label"><b>3.Active Suicidal Ideation
                                                        with Any Methods (Not Plan) without Intent to Act</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="SpanSubjectendorsesthoughts" class="form_label">Subject endorses thoughts
                                                        of suicide and has thought of at least one method during the assessment period.
                                                        This is different than a specific</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="Spanplanwithtime" class="form_label">plan with time, place or method details
                                                        worked out (e.g., thought of method to kill self but not a specific plan). Includes
                                                        person who would</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="spanthoughtabouttaking" class="form_label">say, "I thought about taking an
                                                        overdose but I never made a specific plan as to when, where or how I would actually
                                                        do it... and I would never</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="SpangoThroughwithit" class="form_label">go through with it."</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="Spanyoumightdothis" class="form_label"><b>Have you been thinking about how
                                                        you might do this?</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="SpanIfYes3" class="form_label">If yes, describe:</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <textarea class="form_textarea" id="TextArea_CustomDocumentAdultLTs_ActiveSuicidalIdeationDescription"
                                                        name="TextArea_CustomDocumentAdultLTs_ActiveSuicidalIdeationDescription" rows="4"
                                                        cols="1" style="width: 98%;" spellcheck="True" datatype="String"></textarea>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 8%; padding-top: 2px; border-style: solid; border-width: 1px; border-color: #dce5ea; text-align: center;">
                                        <asp:DropDownList ID="DropDownList_CustomDocumentAdultLTs_ActiveSuicidalIdeationLifeTime"
                                            runat="server" EnableViewState="false" CssClass="form_dropdown" Width="50px">
                                        </asp:DropDownList>
                                    </td>
                                    <td style="width: 8%; padding-top: 2px; border-style: solid; border-width: 1px; border-color: #dce5ea; text-align: center;">
                                        <asp:DropDownList ID="DropDownList_CustomDocumentAdultLTs_ActiveSuicidalIdeationPast1Month"
                                            runat="server" EnableViewState="false" CssClass="form_dropdown" Width="50px">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" style="width: 84%; padding-left: 3px; padding-top: 2px; border-style: solid; border-width: 1px; border-color: #dce5ea;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td>
                                                    <span id="SpanwithSomeIntenttoAct" class="form_label"><b>4. Active Suicidal Ideation
                                                        with Some Intent to Act, without Specific Plan</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="SpanIhavethethoughts" class="form_label">Active suicidal thoughts of killing
                                                        oneself and subject reports having <u>some intent to act on such thoughts,</u> as
                                                        opposed to "I have the thoughts</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="SpanbutIdefinitelywill" class="form_label">but I definitely will not do anything
                                                        about them."</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="spanHaveyouhadthesethoughts" class="form_label"><b>Have you had these thoughts
                                                        and had some intention of acting on them?</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="SpanIfyes4" class="form_label">If yes, describe:</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <textarea class="form_textarea" id="TextArea_CustomDocumentAdultLTs_ASISomeIntentActDescription"
                                                        name="TextArea_CustomDocumentAdultLTs_ASISomeIntentActDescription" rows="4" cols="1"
                                                        style="width: 98%;" spellcheck="True" datatype="String"></textarea>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 8%; padding-top: 2px; border-style: solid; border-width: 1px; border-color: #dce5ea; text-align: center;">
                                        <asp:DropDownList ID="DropDownList_CustomDocumentAdultLTs_ASILifeTime" runat="server"
                                            EnableViewState="false" CssClass="form_dropdown" Width="50px">
                                        </asp:DropDownList>
                                    </td>
                                    <td style="width: 8%; padding-top: 2px; border-style: solid; border-width: 1px; border-color: #dce5ea; text-align: center;">
                                        <asp:DropDownList ID="DropDownList_CustomDocumentAdultLTs_ASIPast1Month" runat="server"
                                            EnableViewState="false" CssClass="form_dropdown" Width="50px">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" style="width: 84%; padding-left: 3px; padding-top: 2px; border-style: solid; border-width: 1px; border-color: #dce5ea;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td>
                                                    <span id="SpanSpecificPlanandIntent" class="form_label"><b>5. Active Suicidal Ideation
                                                        with Specific Plan and Intent</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="Spanworkedoutandsubjecthas" class="form_label">Thoughts of killing oneself
                                                        with details of plan fully or Partially worked out and subject has some intent to
                                                        carry it out. </span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="SpanDoyouintendtocarryout" class="form_label"><b>Have you started to work
                                                        out or worked out the details of how to kill yourself? Do you intend to carry out
                                                        this plan?</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="SpanIfyes5" class="form_label">If Yes, describe:</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <textarea class="form_textarea" id="TextArea_CustomDocumentAdultLTs_ASISpecificPlanAndIntentDescription"
                                                        name="TextArea_CustomDocumentAdultLTs_ASISpecificPlanAndIntentDescription" rows="4"
                                                        cols="1" style="width: 98%;" spellcheck="True" datatype="String"></textarea>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 8%; padding-top: 2px; border-style: solid; border-width: 1px; border-color: #dce5ea; text-align: center;">
                                        <asp:DropDownList ID="DropDownList_CustomDocumentAdultLTs_ASISPILifeTime" runat="server"
                                            EnableViewState="false" CssClass="form_dropdown" Width="50px">
                                        </asp:DropDownList>
                                    </td>
                                    <td style="width: 8%; padding-top: 2px; border-style: solid; border-width: 1px; border-color: #dce5ea; text-align: center;">
                                        <asp:DropDownList ID="DropDownList_CustomDocumentAdultLTs_ASISPIPast1Month" runat="server"
                                            EnableViewState="false" CssClass="form_dropdown" Width="50px">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="content_tab_bg">
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td colspan="6" style="padding-left: 5px; background-color: #dce5ea; height: 20px;">
                                        <span id="SpanINTENSITYOFIDEATION" title="INTENSITY OF IDEATION" class="form_label">
                                            <b>INTENSITY OF IDEATION</b></span>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" style="width: 84%; padding-left: 5px; border-style: solid; border-width: 1px; border-color: #dce5ea; vertical-align: top;">
                                        <span id="Spanfollowingfeatures" class="form_label">The following features should be
                                            rated with respect to the most severe type of ideation (i.e., 1-5 from above, with
                                            1 being the </br> least severe and 5 being the most severe). Ask about time he/she
                                            was feeling the most suicidal. </span>
                                        <table style="width: 100%;">
                                            <tr>
                                                <td style="width: 30%;"></td>
                                                <td style="width: 10%;"></td>
                                                <td style="width: 60%;">
                                                    <span id="SpanEnterDescription" class="form_label">Enter Description of Ideation</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="width: 30%;">
                                                    <span id="SpanLifetimeMostSevere" class="form_label">Lifetime - Most Severe Ideation:</span>
                                                </td>
                                                <td style="width: 10%;">
                                                    <asp:DropDownList ID="DropDownList_CustomDocumentAdultLTs_LifeTimeMostSevere" runat="server"
                                                        EnableViewState="false" CssClass="form_dropdown" Width="50px">
                                                    </asp:DropDownList>
                                                </td>
                                                <td style="width: 60%;">
                                                    <input type="text" class="form_textbox" name="TextBox_CustomDocumentAdultLTs_MostSevereDescription"
                                                        id="TextBox_CustomDocumentAdultLTs_MostSevereDescription" datatype="String" style="width: 87%"
                                                        maxlength="200" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="width: 30%;">
                                                    <span id="SpanRecentMostSevere" class="form_label">Recent - Most Severe Ideation:</span>
                                                </td>
                                                <td style="width: 10%;">
                                                    <asp:DropDownList ID="DropDownList_CustomDocumentAdultLTs_RecentMostSevere" runat="server"
                                                        EnableViewState="false" CssClass="form_dropdown" Width="50px">
                                                    </asp:DropDownList>
                                                </td>
                                                <td style="width: 60%;">
                                                    <input type="text" class="form_textbox" name="TextBox_CustomDocumentAdultLTs_RecentMostSevereDescription"
                                                        id="TextBox_CustomDocumentAdultLTs_RecentMostSevereDescription" datatype="String"
                                                        style="width: 87%" maxlength="2000" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 8%; border-style: solid; border-width: 1px; border-color: #dce5ea;">
                                        <span id="SpanMostSevere1" class="form_label">Most Severe</span>
                                    </td>
                                    <td style="width: 8%; border-style: solid; border-width: 1px; border-color: #dce5ea;">
                                        <span id="SpanMostSevere2" class="form_label">Most Severe</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" style="width: 84%; padding-left: 5px; border-style: solid; border-width: 1px; border-color: #dce5ea; vertical-align: top;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td>
                                                    <span id="SpanFrequency" class="form_label"><b>Frequency</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="SpanHowmanytimeshave" class="form_label"><b>How many times have you had these
                                                        thoughts?</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="padding-left: 5px;">
                                                    <table>
                                                        <tr>
                                                            <td>
                                                                <span id="Span1" class="form_label">(1) Less than once a week</span>
                                                            </td>
                                                            <td>
                                                                <span id="Span2" class="form_label">(2) Once a week</span>
                                                            </td>
                                                            <td>
                                                                <span id="Span3" class="form_label">(3) 2-5 times in week</span>
                                                            </td>
                                                            <td>
                                                                <span id="Span4" class="form_label">(4) Daily or almost daily</span>
                                                            </td>
                                                            <td>
                                                                <span id="Span5" class="form_label">(5) Many times each day</span>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 8%; border-style: solid; border-width: 1px; border-color: #dce5ea; text-align: center;">
                                        <asp:DropDownList ID="DropDownList_CustomDocumentAdultLTs_FrequencyMostSevereOne"
                                            runat="server" EnableViewState="false" CssClass="form_dropdown" Width="50px">
                                        </asp:DropDownList>
                                    </td>
                                    <td style="width: 8%; border-style: solid; border-width: 1px; border-color: #dce5ea; text-align: center;">
                                        <asp:DropDownList ID="DropDownList_CustomDocumentAdultLTs_FrequencyMostSevereTwo"
                                            runat="server" EnableViewState="false" CssClass="form_dropdown" Width="50px">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" style="width: 84%; padding-left: 5px; border-style: solid; border-width: 1px; border-color: #dce5ea; vertical-align: top;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td>
                                                    <span id="SpanDuration" class="form_label"><b>Duration</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="Spanhowlongdotheylast" class="form_label"><b>When you have the thoughts how
                                                        long do they last?</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <table>
                                                        <tr>
                                                            <td style="width: 50%;">
                                                                <span id="SpanFleeting" class="form_label">(1) Fleeting - few seconds or minutes</span>
                                                            </td>
                                                            <td style="width: 50%;">
                                                                <span id="Span48hours" class="form_label">(4) 4-8 hours/most of day </span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 50%;">
                                                                <span id="SpanLessthan1hour" class="form_label">(2) Less than 1 hour/some of the time</span>
                                                            </td>
                                                            <td style="width: 50%;">
                                                                <span id="SpanMorethan8hours" class="form_label">(5) More than 8 hours/persistent or
                                                                    continuous</span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 50%;">
                                                                <span id="Span14hours" class="form_label">(3) 1-4 hours/a lot of time </span>
                                                            </td>
                                                            <td></td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 8%; border-style: solid; border-width: 1px; border-color: #dce5ea; text-align: center;">
                                        <asp:DropDownList ID="DropDownList_CustomDocumentAdultLTs_DurationMostSevereOne" runat="server"
                                            EnableViewState="false" CssClass="form_dropdown" Width="50px">
                                        </asp:DropDownList>
                                    </td>
                                    <td style="width: 8%; border-style: solid; border-width: 1px; border-color: #dce5ea; text-align: center;">
                                        <asp:DropDownList ID="DropDownList_CustomDocumentAdultLTs_DurationMostSevereTwo" runat="server"
                                            EnableViewState="false" CssClass="form_dropdown" Width="50px">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" style="width: 84%; padding-left: 5px; border-style: solid; border-width: 1px; border-color: #dce5ea; vertical-align: top;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td>
                                                    <span id="SpanControllability" class="form_label"><b>Controllability</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="SpanCouldcanyoustop" class="form_label"><b>Could/can you stop thinking about
                                                        killing yourself or wanting to die if you want to?</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <table style="width: 100%;">
                                                        <tr>
                                                            <td style="width: 50%;">
                                                                <span id="SpanEasillyable" class="form_label">(1) Easilly able to control thoughts</span>
                                                            </td>
                                                            <td style="width: 50%;">
                                                                <span id="Spanlotofdifficulty" class="form_label">(4) Can control thoughts with a lot
                                                                    of difficulty</span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 50%;">
                                                                <span id="Spanlittledifficulty" class="form_label">(2) Can control thoughts with little
                                                                    difficulty</span>
                                                            </td>
                                                            <td style="width: 50%;">
                                                                <span id="SpanUnableto" class="form_label">(5) Unable to control thoughts</span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 50%;">
                                                                <span id="Spansomedifficulty" class="form_label">(3) Can control thoughts with some
                                                                    difficulty</span>
                                                            </td>
                                                            <td style="width: 50%;">
                                                                <span id="SpanDoesnotattempt" class="form_label">(0) Does not attempt to control thaughts</span>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 8%; border-style: solid; border-width: 1px; border-color: #dce5ea; text-align: center;">
                                        <asp:DropDownList ID="DropDownList_CustomDocumentAdultLTs_ControllabilityMostSevereOne"
                                            runat="server" EnableViewState="false" CssClass="form_dropdown" Width="50px">
                                        </asp:DropDownList>
                                    </td>
                                    <td style="width: 8%; border-style: solid; border-width: 1px; border-color: #dce5ea; text-align: center;">
                                        <asp:DropDownList ID="DropDownList_CustomDocumentAdultLTs_ControllabilityMostSevereTwo"
                                            runat="server" EnableViewState="false" CssClass="form_dropdown" Width="50px">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" style="width: 84%; padding-left: 5px; border-style: solid; border-width: 1px; border-color: #dce5ea; vertical-align: top;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td>
                                                    <span id="SpanDeterrents" class="form_label"><b>Deterrents</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="SpanAretherethings" class="form_label"><b>Are there things - anyone or anything
                                                        (e.g., family, religion, pain of death) - that stopped you from wanting to die or
                                                        acting on thoughts of committing suicide?</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <table style="width: 100%;">
                                                        <tr>
                                                            <td style="width: 50%;">
                                                                <span id="Spandefinitelystopped" class="form_label">(1) Deterrents definitely stopped
                                                                    you from attempting suicide </span>
                                                            </td>
                                                            <td style="width: 50%;">
                                                                <span id="Spanmostlikely" class="form_label">(4) Deterrents most likely did not stop
                                                                    you</span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 50%;">
                                                                <span id="Spanprobably" class="form_label">(2) Deterrents probably stopped you</span>
                                                            </td>
                                                            <td style="width: 50%;">
                                                                <span id="Spandefinitely" class="form_label">(5) Deterrents definitely did not stop
                                                                    you</span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 50%;">
                                                                <span id="SpanUncertain" class="form_label">(3) Uncertain that deterrents stopped you
                                                                </span>
                                                            </td>
                                                            <td style="width: 50%;">
                                                                <span id="SpanDoesnotapply" class="form_label">(0) Does not apply</span>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 8%; border-style: solid; border-width: 1px; border-color: #dce5ea; text-align: center;">
                                        <asp:DropDownList ID="DropDownList_CustomDocumentAdultLTs_DeterrentsMostSevereOne"
                                            runat="server" EnableViewState="false" CssClass="form_dropdown" Width="50px">
                                        </asp:DropDownList>
                                    </td>
                                    <td style="width: 8%; border-style: solid; border-width: 1px; border-color: #dce5ea; text-align: center;">
                                        <asp:DropDownList ID="DropDownList_CustomDocumentAdultLTs_DeterrentsMostSevereTwo"
                                            runat="server" EnableViewState="false" CssClass="form_dropdown" Width="50px">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" style="width: 84%; padding-left: 5px; border-style: solid; border-width: 1px; border-color: #dce5ea; vertical-align: top;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td>
                                                    <span id="SpanReasonsforIdeation" class="form_label"><b>Reasons for Ideation</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="SpanWhatsortofreasons" class="form_label"><b>What sort of reasons did you
                                                        have for thinking about wanting do die or killing yourself? Was it to end the pain
                                                        or stop the way you were felling (in other words you couldn't go on living with
                                                        this pain or how you were feeling) or was it to get attention, revenge or a reaction
                                                        from others? or both?</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <table style="width: 100%;">
                                                        <tr>
                                                            <td style="width: 50%;">
                                                                <span id="SpanCompletelyto" class="form_label">(1) Completely to get attention, revenge
                                                                    or a reaction from others</span>
                                                            </td>
                                                            <td style="width: 50%;">
                                                                <span id="SpanMostlyto" class="form_label">(4) Mostly to end or stop the pain (you couldn't
                                                                    go on living with the pain or how you were feeling)</span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 50%;">
                                                                <span id="SpanMostlytoget" class="form_label">(2) Mostly to get attention, revenge or
                                                                    a reaction from others</span>
                                                            </td>
                                                            <td style="width: 50%;">
                                                                <span id="SpanCompletelytoend" class="form_label">(5) Completely to end or stop the
                                                                    pain (you couldn't go on living with the pain or how you were feeling)</span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 50%;">
                                                                <span id="SpanEquallyto" class="form_label">(3) Equally to get attention, revenge or
                                                                    a reaction from others and to end/stop the pain</span>
                                                            </td>
                                                            <td style="width: 50%;">
                                                                <span id="SpanDoesnot" class="form_label">(0) Does not apply</span>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 8%; border-style: solid; border-width: 1px; border-color: #dce5ea; text-align: center;">
                                        <asp:DropDownList ID="DropDownList_CustomDocumentAdultLTs_ReasonsMostSevereOne" runat="server"
                                            EnableViewState="false" CssClass="form_dropdown" Width="50px">
                                        </asp:DropDownList>
                                    </td>
                                    <td style="width: 8%; border-style: solid; border-width: 1px; border-color: #dce5ea; text-align: center;">
                                        <asp:DropDownList ID="DropDownList_CustomDocumentAdultLTs_ReasonsMostSevereTwo" runat="server"
                                            EnableViewState="false" CssClass="form_dropdown" Width="50px">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="content_tab_bg">
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td colspan="4" style="padding-left: 5px; background-color: #dce5ea; height: 20px;">
                                        <span id="SpanSUICIDALBEHAVIOR" title="SUICIDAL BEHAVIOR" class="form_label"><b>SUICIDAL
                                            BEHAVIOR</b> (Check all that apply, so long as these are separate events; must ask
                                            about all types)</span>
                                    </td>
                                    <td style="width: 8%; background-color: #dce5ea; height: 20px; text-align: center;">
                                        <span id="SpanLifeTime" class="form_label">Lifetime</span>
                                    </td>
                                    <td style="width: 8%; background-color: #dce5ea; height: 20px; text-align: center;">
                                        <span id="SpanPast3Months" class="form_label">Past 3 Months</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" style="width: 84%; padding-left: 5px; border-style: solid; border-width: 1px; border-color: #dce5ea; vertical-align: top;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td style="height: 20px;">
                                                    <span id="SpanActualAttempt" class="form_label"><b>Actual Attempt:</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 30px;">
                                                    <span id="Spanselfinjurious" class="form_label">A potentially self-injurious act committed
                                                        with at least some wish to die, as a result of act. Behavior was in Part thought
                                                        of as method to kill oneself. Intent does not have to be 100%. If there is <b>any</b> intent/desire
                                                        to die associated with the act, then it can be considered an actual suicide attempt.
                                                        <b>There does not have to be any injury or harm</b>, just the potential for injury or harm.
                                                        If person pulls trigger while gun is in mouth but gun is broken so no injury results,
                                                        this is considered an attempt.</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 30px;">
                                                    <span id="SpanInferringIntent" class="form_label">Inferring Intent: Even if an individual
                                                        denies intent/wish to die, it may be inferred clinically from the behavior or circumstances.
                                                        For example, a highly lethal act that is clearly not an accident so no other intent
                                                        but suicide can be inferred (e.g., gunshot to head, jumping from window of a high
                                                        floor/story). Also, if someone denies intent to die, but they thought that what
                                                        they did could be lethal, intent may be inferred.</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;">
                                                    <span id="SpanHaveyoumade" class="form_label"><b>Have you made a suicide attempt?</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;">
                                                    <span id="SpanHaveyoudoneanything" class="form_label"><b>Have you done anything to harm
                                                        yourself?</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;">
                                                    <span id="Spandoneanythingdangerous" class="form_label"><b>Have you done anything dangerous
                                                        where you could have died?</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="padding-left: 15px;">
                                                    <table>
                                                        <tr>
                                                            <td style="height: 20px;">
                                                                <span id="SpanWhatdidyoudo" class="form_label"><b>What did you do?</b></span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="height: 20px;">
                                                                <span id="Spanendyourlife" class="form_label"><b>Did you <u>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                                </u>as a way to end your life?</b></span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="height: 20px;">
                                                                <span id="Spanevenalittle" class="form_label"><b>Did you want to die (even a little)
                                                                    when you <u>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </u>?</b></span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="height: 20px;">
                                                                <span id="Spanyoutryingtoend" class="form_label"><b>where you trying to end your life
                                                                    when you <u>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </u>?</b></span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="height: 20px;">
                                                                <span id="SpanOrDidyouthink" class="form_label"><b>Or Did you think it was possible
                                                                    you could have died from <u>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                                    </u>?</b></span>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 30px;">
                                                    <span id="Spanpurelyfor" class="form_label"><b>Or Did you do it purely for other reasons/
                                                        without ANY intention of killing yourself(like to relieve stress, feel better get
                                                        sympathy, or get something else to happen)?</b> (Self - injurious Behavior without
                                                        suicidal intent)</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;">
                                                    <span id="SpanIfYesSuicidal" class="form_label">If Yes, describe:</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;">
                                                    <textarea class="form_textarea" id="TextArea_CustomDocumentAdultLTs_ActualAttemptDescription"
                                                        name="TextArea_CustomDocumentAdultLTs_ActualAttemptDescription" rows="4" cols="1"
                                                        style="width: 98%;" spellcheck="True" datatype="String"></textarea>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;">
                                                    <span id="SpanNonSuicidal" class="form_label"><b>Has subject engaged in Non-Suicidal
                                                        Self-Injurious Behavior?</b></span>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 8%; border-style: solid; border-width: 1px; border-color: #dce5ea; text-align: center;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td style="text-align: center;" style="height: 20px;">
                                                    <asp:DropDownList ID="DropDownList_CustomDocumentAdultLTs_SuicidalBehaviourLifeTime"
                                                        runat="server" EnableViewState="false" CssClass="form_dropdown" Width="50px">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 30px;"></td>
                                            </tr>
                                            <tr>
                                                <td style="height: 30px;"></td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;"></td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;"></td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;"></td>
                                            </tr>
                                            <tr>
                                                <td style="padding-left: 15px;">
                                                    <table>
                                                        <tr>
                                                            <td style="height: 20px;"></td>
                                                        </tr>
                                                        <tr>
                                                            <td style="text-align: center;" style="height: 20px;">
                                                                <span id="SpanNoOfAttempts" class="form_label">Total # of Attempts</span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="text-align: center;" style="height: 20px;">
                                                                <input type="text" class="form_textbox" name="TextBox_CustomDocumentAdultLTs_SuicidalBehaviourAttemptNoOne"
                                                                    id="TextBox_CustomDocumentAdultLTs_SuicidalBehaviourAttemptNoOne" datatype="String"
                                                                    style="width: 87%" maxlength="8" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="height: 20px;"></td>
                                                        </tr>
                                                        <tr>
                                                            <td style="height: 20px;"></td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 30px;"></td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;"></td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;"></td>
                                            </tr>
                                            <tr>
                                                <td style="text-align: center; height: 20px;">
                                                    <asp:DropDownList ID="DropDownList_CustomDocumentAdultLTs_SelfInjuriesOne" runat="server"
                                                        EnableViewState="false" CssClass="form_dropdown" Width="50px">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 8%; border-style: solid; border-width: 1px; border-color: #dce5ea; text-align: center;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td style="text-align: center;" style="height: 20px;">
                                                    <asp:DropDownList ID="DropDownList_CustomDocumentAdultLTs_SuicidalBehaviourPast3Monts"
                                                        runat="server" EnableViewState="false" CssClass="form_dropdown" Width="50px">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 30px;"></td>
                                            </tr>
                                            <tr>
                                                <td style="height: 30px;"></td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;"></td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;"></td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;"></td>
                                            </tr>
                                            <tr>
                                                <td style="padding-left: 15px;">
                                                    <table>
                                                        <tr>
                                                            <td style="height: 20px;"></td>
                                                        </tr>
                                                        <tr>
                                                            <td style="text-align: center;" style="height: 20px;">
                                                                <span id="SpanTotalNoAttempts" class="form_label">Total # of Attempts</span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="text-align: center;" style="height: 20px;">
                                                                <input type="text" class="form_textbox" name="TextBox_CustomDocumentAdultLTs_SuicidalBehaviourAttemptNoTwo"
                                                                    id="TextBox_CustomDocumentAdultLTs_SuicidalBehaviourAttemptNoTwo" datatype="String"
                                                                    style="width: 87%" maxlength="8" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="height: 20px;"></td>
                                                        </tr>
                                                        <tr>
                                                            <td style="height: 20px;"></td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 30px;"></td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;"></td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;"></td>
                                            </tr>
                                            <tr>
                                                <td style="text-align: center; height: 20px;">
                                                    <asp:DropDownList ID="DropDownList_CustomDocumentAdultLTs_SelfInjuriesTwo" runat="server"
                                                        EnableViewState="false" CssClass="form_dropdown" Width="50px">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" style="width: 84%; padding-left: 5px; border-style: solid; border-width: 1px; border-color: #dce5ea; vertical-align: top;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td style="height: 20px;">
                                                    <span id="SpanInterruptedAttempt" class="form_label"><b>Interrupted Attempt:</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;">
                                                    <span id="Spanoutsidecircumstance" class="form_label">When the person is interrupted
                                                        (by an outside circumstance) from starting the potentially self-injurious act (if
                                                        not for that, actual attempt would have occurred).</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 30px;">
                                                    <span id="SpanOverdose" class="form_label">Overdose: Person has pills in hand but is
                                                        stopped from ingesting. Once they ingest any pills, this becomes an attempt rather
                                                        than an interrupted attempt. Shootin: Person has gun pointed towards self, gun is
                                                        taken away by someone else, or is somehow prevented from pulling trigger. Once they
                                                        pull the trigger, even if the gun fails to fire, it is an attempt. Jumping: Person
                                                        is poised to jump, is grabbed and taken down from ledge. Hanging: Person has noose
                                                        around neck but has not yet started to hang - is stopped from doing so.</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;">
                                                    <span><b>Has there been a time when you started to do something to end your life but
                                                        someone or something stopped you before you actually did anything?</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;">
                                                    <span id="SpanIfYesOverdose" class="form_label">If yes, describe:</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 40px;">
                                                    <textarea class="form_textarea" id="TextArea_CustomDocumentAdultLTs_InterruptedAttemptDescription"
                                                        name="TextArea_CustomDocumentAdultLTs_InterruptedAttemptDescription" rows="4"
                                                        cols="1" style="width: 98%;" spellcheck="True" datatype="String"></textarea>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 8%; border-style: solid; border-width: 1px; border-color: #dce5ea; text-align: center;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td style="height: 20px; text-align: center;">
                                                    <asp:DropDownList ID="DropDownList_CustomDocumentAdultLTs_InterruptedAttemptLifeTime"
                                                        runat="server" EnableViewState="false" CssClass="form_dropdown" Width="50px">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;"></td>
                                            </tr>
                                            <tr>
                                                <td style="height: 30px;"></td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px; text-align: center;">
                                                    <span id="SpanTotalNointerrupted" class="form_label">Total # of interrupted</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px; text-align: center;">
                                                    <input type="text" class="form_textbox" name="TextBox_CustomDocumentAdultLTs_TotalNointerruptedOne"
                                                        id="TextBox_CustomDocumentAdultLTs_TotalNointerruptedOne" datatype="String" style="width: 87%"
                                                        maxlength="8" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 40px;"></td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 8%; border-style: solid; border-width: 1px; border-color: #dce5ea; text-align: center;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td style="height: 20px; text-align: center;">
                                                    <asp:DropDownList ID="DropDownList_CustomDocumentAdultLTs_InterruptedAttemptPast3Months"
                                                        runat="server" EnableViewState="false" CssClass="form_dropdown"
                                                        Width="50px" Height="16px">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;"></td>
                                            </tr>
                                            <tr>
                                                <td style="height: 30px;"></td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px; text-align: center;">
                                                    <span id="Span6" class="form_label">Total # of interrupted</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px; text-align: center;">
                                                    <input type="text" class="form_textbox" name="TextBox_CustomDocumentAdultLTs_TotalNoInterruptedTwo"
                                                        id="TextBox_CustomDocumentAdultLTs_TotalNoInterruptedTwo" datatype="String" style="width: 87%"
                                                        maxlength="8" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 40px;"></td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" style="width: 84%; padding-left: 5px; border-style: solid; border-width: 1px; border-color: #dce5ea; vertical-align: top;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td style="height: 20px;">
                                                    <span id="SpanSelfInterrupted" class="form_label"><b>Aborted or Self-Interrupted Attempt:</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 30px;">
                                                    <span id="SpanWhenPersonbegins" class="form_label">When Person begins to take steps
                                                        towards making a suicide attempt, but stops themselves before they actually have
                                                        engaged in any self-destructive behavior. Examples are similar to interrupted attempts,
                                                        except that the individual stops him/herself, instead of being stopped by something
                                                        else.</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;">
                                                    <span id="SpanHastherebeen" class="form_label"><b>Has there been a time when you started
                                                        to do something to try to end your life but you stopped yourself before you actually
                                                        did anything?</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;">
                                                    <span id="SpanIfYesSelfInterrupted" class="form_label">If yes, describe:</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 40px;">
                                                    <textarea class="form_textarea" id="TextArea_CustomDocumentAdultLTs_AbortedDescription"
                                                        name="TextArea_CustomDocumentAdultLTs_AbortedDescription" rows="4" cols="1" style="width: 98%;"
                                                        spellcheck="True" datatype="String"></textarea>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 8%; border-style: solid; border-width: 1px; border-color: #dce5ea; text-align: center;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td style="height: 20px;"></td>
                                            </tr>
                                            <tr>
                                                <td style="height: 30px; text-align: center;">
                                                    <asp:DropDownList ID="DropDownList_CustomDocumentAdultLTs_AbortedLifeTime" runat="server"
                                                        EnableViewState="false" CssClass="form_dropdown" Width="50px">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px; text-align: center;">
                                                    <span id="Spanaborted" class="form_label">Total # of aborted or self-interrupted</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px; text-align: center;">
                                                    <input type="text" class="form_textbox" name="TextBox_CustomDocumentAdultLTs_AbortedOne"
                                                        id="TextBox_CustomDocumentAdultLTs_AbortedOne" datatype="String" style="width: 87%"
                                                        maxlength="8" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 40px;"></td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 8%; border-style: solid; border-width: 1px; border-color: #dce5ea; text-align: center;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td style="height: 20px; text-align: center;"></td>
                                            </tr>
                                            <tr>
                                                <td style="height: 30px;">
                                                    <asp:DropDownList ID="DropDownList_CustomDocumentAdultLTs_AbortedPast3Months" runat="server"
                                                        EnableViewState="false" CssClass="form_dropdown" Width="50px">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px; text-align: center;">
                                                    <span id="SpanabortedTwo" class="form_label">Total # of aborted or self-interrupted</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px; text-align: center;">
                                                    <input type="text" class="form_textbox" name="TextBox_CustomDocumentAdultLTs_AbortedTwo"
                                                        id="TextBox_CustomDocumentAdultLTs_AbortedTwo" datatype="String" style="width: 87%"
                                                        maxlength="8" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 40px;"></td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" style="width: 84%; padding-left: 5px; border-style: solid; border-width: 1px; border-color: #dce5ea; vertical-align: top;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td style="height: 20px;">
                                                    <span id="SpanPreparatory" class="form_label"><b>Preparatory Acts or Behavior:</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 30px;">
                                                    <span id="SpanActsor" class="form_label">Acts or preparation towards imminently making
                                                        a suicide attempt. This can include anything beyond a verbalization or thought,
                                                        such as assembling a specific method (e.g., buying pills, purchasing a gun) or preparing
                                                        for one's death by suicide (e.g., giving things away, writing a suicide note).</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;">
                                                    <span id="Spanpreparing" class="form_label"><b>Have you taken any steps towards making
                                                        a suicide attempt or preparing to kill yourself (such as collecting pills, getting
                                                        a gun, giving valuables away or writing a suicide note)?</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;">
                                                    <span id="SpanIfYesPreparatory" class="form_label">If yes, describe:</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 40px;">
                                                    <textarea class="form_textarea" id="TextArea_CustomDocumentAdultLTs_PreparatoryDescription"
                                                        name="TextArea_CustomDocumentAdultLTs_PreparatoryDescription" rows="4" cols="1"
                                                        style="width: 98%;" spellcheck="True" datatype="String"></textarea>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 8%; border-style: solid; border-width: 1px; border-color: #dce5ea; text-align: center;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td style="height: 20px;"></td>
                                            </tr>
                                            <tr>
                                                <td style="height: 30px; text-align: center;">
                                                    <asp:DropDownList ID="DropDownList_CustomDocumentAdultLTs_PreparatoryLifeTime" runat="server"
                                                        EnableViewState="false" CssClass="form_dropdown" Width="50px">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px; text-align: center;">
                                                    <span id="SpanTotalNoofpreparatory" class="form_label">Total # of preparatory acts</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px; text-align: center;">
                                                    <input type="text" class="form_textbox" name="TextBox_CustomDocumentAdultLTs_preparatoryOne"
                                                        id="TextBox_CustomDocumentAdultLTs_preparatoryOne" datatype="String" style="width: 87%"
                                                        maxlength="8" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 40px;"></td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 8%; border-style: solid; border-width: 1px; border-color: #dce5ea; text-align: center;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td style="height: 20px; text-align: center;"></td>
                                            </tr>
                                            <tr>
                                                <td style="height: 30px;">
                                                    <asp:DropDownList ID="DropDownList_CustomDocumentAdultLTs_preparatoryPast3Months"
                                                        runat="server" EnableViewState="false" CssClass="form_dropdown" Width="50px">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px; text-align: center;">
                                                    <span id="SpanpreparatoryTwo" class="form_label">Total # of preparatory acts</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px; text-align: center;">
                                                    <input type="text" class="form_textbox" name="TextBox_CustomDocumentAdultLTs_preparatoryTwo"
                                                        id="TextBox_CustomDocumentAdultLTs_preparatoryTwo" datatype="String" style="width: 87%"
                                                        maxlength="8" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 40px;"></td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" style="width: 84%; padding-left: 5px; border-style: solid; border-width: 1px; border-color: #dce5ea; vertical-align: top;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td style="height: 20px;">
                                                    <span id="SpanFinalSuicidalBehavior" class="form_label"><b>Suicidal Behavior:</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;">
                                                    <span id="Spanduringtheassessment" class="form_label">Suicidal behavior was present
                                                        during the assessment period?</span>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 8%; border-style: solid; border-width: 1px; border-color: #dce5ea; text-align: center;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td style="height: 20px;"></td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px; text-align: center;">
                                                    <asp:DropDownList ID="DropDownList_CustomDocumentAdultLTs_SuicidalBehaviorLifeTime"
                                                        runat="server" EnableViewState="false" CssClass="form_dropdown" Width="50px">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 8%; border-style: solid; border-width: 1px; border-color: #dce5ea; text-align: center;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td style="height: 20px;"></td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px; text-align: center;">
                                                    <asp:DropDownList ID="DropDownList_CustomDocumentAdultLTs_SuicidalBehaviorPast3Months"
                                                        runat="server" EnableViewState="false" CssClass="form_dropdown" Width="50px">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="content_tab_bg">
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td colspan="3" style="padding-left: 5px; background-color: #dce5ea; height: 40px; width: 40%;"></td>
                                    <td style="background-color: #dce5ea; height: 40px; width: 20%; text-align: center;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td align="center">
                                                    <span id="SpanRecentAttemptDate" class="form_label">Most Recent Attempt Date:</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="center">
                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                        <tr class="date_Container">
                                                            <td style="text-align: center;">
                                                                <input type="text" datatype="Date" id="TextArea_CustomDocumentAdultLTs_RecentAttemptDate"
                                                                    name="TextArea_CustomDocumentAdultLTs_RecentAttemptDate" />
                                                            </td>
                                                            <td>&nbsp;
                                                            </td>
                                                            <td style="text-align: center;">
                                                                <img id="imgPatientGuradianSigned" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                    alt="Calendar" onclick="return showCalendar('TextArea_CustomDocumentAdultLTs_RecentAttemptDate', '%m/%d/%Y');" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="background-color: #dce5ea; height: 40px; width: 20%;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td align="center">
                                                    <span id="SpanLethalAttemptDate" class="form_label">Most Lethal Attempt Date:</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="center">
                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                        <tr class="date_Container">
                                                            <td style="text-align: center;">
                                                                <input type="text" datatype="Date" id="TextArea_CustomDocumentAdultLTs_LethalAttemptDate"
                                                                    name="TextArea_CustomDocumentAdultLTs_LethalAttemptDate" />
                                                            </td>
                                                            <td>&nbsp;
                                                            </td>
                                                            <td style="text-align: center;">
                                                                <img id="img1" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                    alt="Calendar" onclick="return showCalendar('TextArea_CustomDocumentAdultLTs_LethalAttemptDate', '%m/%d/%Y');" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="background-color: #dce5ea; height: 40px; width: 20%;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td align="center">
                                                    <span id="SpanFirstAttemptDate" class="form_label">Initial/First Attempt Date:</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="center">
                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                        <tr class="date_Container">
                                                            <td style="text-align: center;">
                                                                <input type="text" datatype="Date" id="TextArea_CustomDocumentAdultLTs_FirstAttemptDate"
                                                                    name="TextArea_CustomDocumentAdultLTs_FirstAttemptDate" />
                                                            </td>
                                                            <td>&nbsp;
                                                            </td>
                                                            <td style="text-align: center;">
                                                                <img id="img2" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                    alt="Calendar" onclick="return showCalendar('TextArea_CustomDocumentAdultLTs_FirstAttemptDate', '%m/%d/%Y');" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="3" style="padding-left: 5px; height: 40px; width: 40%;">
                                        <span id="SpanActualLethality" class="form_label"><b>Actual Lethality/Medical Damage:</b></span>
                                    </td>
                                    <td style="width: 20%; height: 40px; text-align: center;">
                                        <asp:DropDownList ID="DropDownList_CustomDocumentAdultLTs_ActualLethality1"
                                            runat="server" EnableViewState="false" CssClass="form_dropdown" Width="125px">
                                        </asp:DropDownList>
                                    </td>
                                    <td style="width: 20%; height: 40px; text-align: center;">
                                        <asp:DropDownList ID="DropDownList_CustomDocumentAdultLTs_ActualLethality2"
                                            runat="server" EnableViewState="false" CssClass="form_dropdown" Width="125px">
                                        </asp:DropDownList>
                                    </td>
                                    <td style="width: 20%; height: 40px; text-align: center;">
                                        <asp:DropDownList ID="DropDownList_CustomDocumentAdultLTs_ActualLethality3"
                                            runat="server" EnableViewState="false" CssClass="form_dropdown" Width="125px">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="3" style="padding-left: 5px; height: 40px; width: 20%;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td style="text-align: right; vertical-align: top;">
                                                    <img style="cursor: default;" src="<%=RelativePath%>App_Themes/Includes/Images/info.png" title="Likely lethality of actual attempt if no medical damage (the following examples, while having no actual medical damage, had potential for very serious lethality: put gun in mouth and pulled the trigger but gun fails to fire so no medical damage; laying on train tracks with oncoming train but pulled away before run over)." id="image_information" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="ChildSpanPotentialLethality" class="form_label"><b>Potential Lethality: Only Answer if Actual Lethality = 0</b></span>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 8%; height: 40px; text-align: center;">
                                        <asp:DropDownList ID="DropDownList_CustomDocumentAdultLTs_PotentialLethality1"
                                            runat="server" EnableViewState="false" CssClass="form_dropdown" Width="125px">
                                        </asp:DropDownList>
                                    </td>
                                    <td style="width: 8%; height: 40px; text-align: center;">
                                        <asp:DropDownList ID="DropDownList_CustomDocumentAdultLTs_PotentialLethality2"
                                            runat="server" EnableViewState="false" CssClass="form_dropdown" Width="125px">
                                        </asp:DropDownList>
                                    </td>
                                    <td style="width: 8%; height: 40px; text-align: center;">
                                        <asp:DropDownList ID="DropDownList_CustomDocumentAdultLTs_PotentialLethality3"
                                            runat="server" EnableViewState="false" CssClass="form_dropdown" Width="125px">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="100%">
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
