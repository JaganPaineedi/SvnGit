<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CSSRSChildAdolescentSinceLT.ascx.cs" Inherits="SHS.SmartCare.Custom_Assessment_WebPages_CSSRSChildAdolescentSinceLT" %>
<% if (HttpContext.Current == null)
   { %>
<link href="../../../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet"
    type="text/css" />
<%} %>
<style type="text/css">
    p.MsoNormal
    {
        margin-top: 0in;
        margin-right: 0in;
        margin-bottom: 10.0pt;
        margin-left: 0in;
        line-height: 115%;
        font-size: 11.0pt;
        font-family: "Calibri","sans-serif";
    }


    .auto-style1
    {
        font-weight: bold;
    }

    .auto-style2
    {
        font-weight: bold;
        font-style: italic;
    }

    #SpanNoOfAttempts
    {
    }

    .auto-style5
    {
        font-weight: 700;
        font-style: italic;
    }

    .auto-style6
    {
        font-weight: bold;
        font-style: normal;
    }
</style>
<div style="overflow-x: hidden">
    <table cellpadding="0" cellspacing="0" border="0" style="width: 832px" class="CrossBrowserAutoFixChrome_width_847px">
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
                            <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                <tr>
                                    <td colspan="6" style="padding-left: 5px; background-color: #dce5ea; height: 20px;">
                                        <span id="SpanSuicidalIdeation" title="Suicidal Ideation" class="form_label"><b>Suicidal
                                            Ideation</b></span>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" style="border: 1px solid #dce5ea; padding-left: 5px; vertical-align: top;" class="auto-style4">
                                       Ask questions 1 and 2.If both are negative,
                                            proceed to "Suicidal Behavior" section. If the answer to question 2 is "Yes", ask
                                            questions 3,4 and 5. If the answer to question 1 and/ or 2 is "Yes", complete
                                            "Intensity of Ideation" section below.
                                    </td>

                                    <td style="width: 16%; border-style: solid; border-width: 1px; border-color: #dce5ea;">
                                        <p class="MsoNormal" style="text-align: center">
                                            Since Last Visit<o:p></o:p>
                                        </p>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" style="border: 1px solid #dce5ea; padding-left: 3px; padding-bottom: 2px;" class="auto-style4">
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
                                                    <span id="Span6" class="auto-style2">Have you thought about being dead or what it would be like to be dead?</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="Spamhaveyouwished" class="auto-style2">Have you wished you were dead or wished you could go to sleep and never wake up?</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="font-style: italic">
                                                    <span id="Span7" class="form_label"><b>Do you ever wish you weren't alive anymore? If yes, describe:</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="SpanIfYes" class="form_label">If yes, describe:</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <textarea class="form_textarea" id="TextArea_CustomDocumentCSSRSChildSinceLastVisits_WishToBeDeadDescription"
                                                        name="TextArea_CustomDocumentCSSRSChildSinceLastVisits_DeadDescription" rows="4" cols="1" style="width: 98%;"
                                                        spellcheck="True" datatype="String" disabled="disabled"></textarea>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 8%; border-style: solid; border-width: 1px; border-color: #dce5ea; text-align: center;">
                                        <asp:DropDownList ID="DropDownList_CustomDocumentCSSRSChildSinceLastVisits_WishToBeDead" runat="server"
                                            EnableViewState="false" CssClass="form_dropdown" Width="50px" onchange="CSSRSChildAdolescentSinceLTHideandShow('DropDownList_CustomDocumentCSSRSChildSinceLastVisits_WishToBeDead')">
                                        </asp:DropDownList>
                                    </td>

                                </tr>
                                <tr>
                                    <td colspan="4" style="border: 1px solid #dce5ea; padding-left: 3px; padding-top: 2px;" class="auto-style4">
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
                                                <td class="auto-style5">
                                                    <span id="SpanHaveyouactuallyhad" class="auto-style5">Have you thought about doing something to make yourself not alive anymore? </span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="auto-style5">
                                                    <span id="Span8" class="auto-style5">Have you had any thoughts about killing yourself? If yes, describe:
                                                    </span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="SpanIfYes2" class="form_label">If yes, describe:</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <textarea class="form_textarea" id="TextArea_CustomDocumentCSSRSChildSinceLastVisits_NonSpecificActiveSuicidalThoughtsDescription"
                                                        name="TextArea_CustomDocumentCSSRSChildSinceLastVisits_NonSpecificDescription" rows="4" cols="1"
                                                        style="width: 98%;" spellcheck="True" datatype="String" disabled="disabled"></textarea>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 8%; padding-top: 2px; border-style: solid; border-width: 1px; border-color: #dce5ea; text-align: center;">
                                        <asp:DropDownList ID="DropDownList_CustomDocumentCSSRSChildSinceLastVisits_NonSpecificActiveSuicidalThoughts" runat="server"
                                            EnableViewState="false" CssClass="form_dropdown" Width="50px" onchange="CSSRSChildAdolescentSinceLTHideandShow('DropDownList_CustomDocumentCSSRSChildSinceLastVisits_NonSpecificActiveSuicidalThoughts')">
                                        </asp:DropDownList>
                                    </td>

                                </tr>
                                <tr id="3">
                                    <td colspan="4" style="border: 1px solid #dce5ea; padding-left: 3px; padding-top: 2px;" class="auto-style4">
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
                                                        do it... and I would never go through with it&quot;.</span>
                                                </td>
                                            </tr>

                                            <tr>
                                                <td>
                                                    <span id="Spanyoumightdothis" class="auto-style5">Have you thought about how you would do that or how you would make yourself not alive anymore (kill yourself)? What did you think about? If yes, describe: </span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="SpanIfYes3" class="form_label">If yes, describe:</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <textarea class="form_textarea" id="TextArea_CustomDocumentCSSRSChildSinceLastVisits_ActiveSuicidalIdeationWithAnyMethodsWithoutIntentToActDescription"
                                                        name="TextArea_CustomDocumentCSSRSChildSinceLastVisits_ActiveSuicidalIdeationDescription" rows="4"
                                                        cols="1" style="width: 98%;" spellcheck="True" datatype="String" disabled="disabled"></textarea>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 8%; padding-top: 2px; border-style: solid; border-width: 1px; border-color: #dce5ea; text-align: center;">
                                        <asp:DropDownList ID="DropDownList_CustomDocumentCSSRSChildSinceLastVisits_ActiveSuicidalIdeationWithAnyMethodsWithoutIntentToAct"
                                            runat="server" EnableViewState="false" CssClass="form_dropdown" Width="50px" onchange="CSSRSChildAdolescentSinceLTHideandShow('DropDownList_CustomDocumentCSSRSChildSinceLastVisits_ActiveSuicidalIdeationWithAnyMethodsWithoutIntentToAct')">
                                        </asp:DropDownList>
                                    </td>

                                </tr>
                                <tr id="4">
                                    <td colspan="4" style="border: 1px solid #dce5ea; padding-left: 3px; padding-top: 2px;" class="auto-style4">
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
                                                        opposed to "I have the thoughts but I definitely will not do anything
                                                        about them."</span>
                                                </td>
                                            </tr>

                                            <tr>
                                                <td class="auto-style5">
                                                    <span id="spanHaveyouhadthesethoughts" class="auto-style5">When you thought about making yourself not alive anymore (or killing yourself), did you think that this was something you might actually do? </span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="auto-style5">
                                                    <span id="span9" class="auto-style5">This is different from (as opposed to) having the thoughts but knowing you wouldn't do anything about it If yes, describe:
                                                    </span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="SpanIfyes4" class="form_label">If yes, describe:</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <textarea class="form_textarea" id="TextArea_CustomDocumentCSSRSChildSinceLastVisits_ActiveSuicidalIdeationWithSomeIntentToActWithoutSpecificPlanDescription"
                                                        name="TextArea_CustomDocumentCSSRSChildSinceLastVisits_ActiveSuicidalIdeationWithSomeIntentToActWithoutSpecificPlanDescription" rows="4" cols="1"
                                                        style="width: 98%;" spellcheck="True" datatype="String" disabled="disabled"></textarea>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 8%; padding-top: 2px; border-style: solid; border-width: 1px; border-color: #dce5ea; text-align: center;">
                                        <asp:DropDownList ID="DropDownList_CustomDocumentCSSRSChildSinceLastVisits_ActiveSuicidalIdeationWithSomeIntentToActWithoutSpecificPlan" runat="server"
                                            EnableViewState="false" CssClass="form_dropdown" Width="50px" onchange="CSSRSChildAdolescentSinceLTHideandShow('DropDownList_CustomDocumentCSSRSChildSinceLastVisits_ActiveSuicidalIdeationWithSomeIntentToActWithoutSpecificPlan')">
                                        </asp:DropDownList>
                                    </td>

                                </tr>
                                <tr id="5">
                                    <td colspan="4" style="border: 1px solid #dce5ea; padding-left: 3px; padding-top: 2px;" class="auto-style4">
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
                                                <td class="auto-style6">
                                                    <span id="SpanDoyouintendtocarryout" class="auto-style5">Have you ever decided how or when you would make yourself not olive anymore/kill yourself? Have you ever planned out (worked out the details of) how you would do it?</span><i> </i>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="auto-style5">
                                                    <span id="Span10" class="auto-style5">What was your plan? When you made this plan (or worked out these details), was any part of you thinking about actually doing it? </span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="SpanIfyes5" class="form_label">If Yes, describe:</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <textarea class="form_textarea" id="TextArea_CustomDocumentCSSRSChildSinceLastVisits_AciveSuicidalIdeationWithSpecificPlanAndIntentDescription"
                                                        name="TextArea_CustomDocumentCSSRSChildSinceLastVisits_ASISpecificPlanAndIntentDescription" rows="4"
                                                        cols="1" style="width: 98%;" spellcheck="True" datatype="String" disabled="disabled"></textarea>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 8%; padding-top: 2px; border-style: solid; border-width: 1px; border-color: #dce5ea; text-align: center;">
                                        <asp:DropDownList ID="DropDownList_CustomDocumentCSSRSChildSinceLastVisits_AciveSuicidalIdeationWithSpecificPlanAndIntent" runat="server"
                                            EnableViewState="false" CssClass="form_dropdown" Width="50px" onchange="CSSRSChildAdolescentSinceLTHideandShow('DropDownList_CustomDocumentCSSRSChildSinceLastVisits_AciveSuicidalIdeationWithSpecificPlanAndIntent')">
                                        </asp:DropDownList>
                                    </td>

                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                    </tr>
                    <tr id="IID">
                        <td class="content_tab_bg">
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td colspan="2" style="padding-left: 5px; background-color: #dce5ea; height: 20px;">
                                        <span id="SpanINTENSITYOFIDEATION" title="INTENSITY OF IDEATION" class="form_label">
                                            <b>INTENSITY OF IDEATION</b></span>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 84%; padding-left: 5px; border-style: solid; border-width: 1px; border-color: #dce5ea; vertical-align: top;">
                                        <span id="Spanfollowingfeatures" class="form_label">The following features should be
                                            rated with respect to the most severe type of ideation (i.e., 1-5 from above, with
                                            1 being the least severe and 5 being the most severe). Ask about time he/she
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
                                                <td style="width: 30%;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span id="SpanLifetimeMostSevere" class="form_label">&nbsp;Most Severe Ideation:</span>
                                                </td>
                                                <td style="width: 10%;">
                                                    <asp:DropDownList ID="DropDownList_CustomDocumentCSSRSChildSinceLastVisits_MostSevereIdeation" runat="server"
                                                        EnableViewState="false" CssClass="form_dropdown" Width="50px" onchange="CSSRSChildAdolescentSinceLTHideandShow('DropDownList_CustomDocumentCSSRSChildSinceLastVisits_MostSevereIdeation')">
                                                    </asp:DropDownList>
                                                </td>
                                                <td style="width: 60%;">
                                                    <input type="text" class="form_textbox" name="TextBox_CustomDocumentCSSRSChildSinceLastVisits_MostSevereIdeationDescription"
                                                        id="TextBox_CustomDocumentCSSRSChildSinceLastVisits_MostSevereIdeationDescription" datatype="String" style="width: 87%"
                                                        maxlength="200" disabled="disabled" />
                                                </td>
                                            </tr>

                                        </table>
                                    </td>

                                    <td style="width: 16%; border-style: solid; border-width: 1px; border-color: #dce5ea;" class="auto-style3"><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Most Severe </span></td>
                                </tr>
                                <tr>
                                    <td style="width: 84%; padding-left: 5px; border-style: solid; border-width: 1px; border-color: #dce5ea; vertical-align: top;">
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
                                                                <span id="Span1" class="form_label">(1) </span><span>Only one time </span>&nbsp;</td>
                                                            <td>
                                                                <span id="Span2" class="form_label">(2)</span><span>A few times </span>&nbsp;</td>
                                                            <td>
                                                                <span id="Span3" class="form_label">(3) </span><span>A lot </span>&nbsp;</td>
                                                            <td>
                                                                <span id="Span4" class="form_label">(4) </span><span>All the time </span>&nbsp;</td>
                                                            <td>
                                                                <span id="Span5" class="form_label">(5) </span><span>Don&#39;t know/Not applicable </span>&nbsp;</td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 16%; border-style: solid; border-width: 1px; border-color: #dce5ea; text-align: center;">
                                        <asp:DropDownList ID="DropDownList_CustomDocumentCSSRSChildSinceLastVisits_Frequency"
                                            runat="server" EnableViewState="false" CssClass="form_dropdown" Width="50px">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr id="SB1">
                        <td class="content_tab_bg">
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td colspan="4" style="width: 84%; padding-left: 5px; background-color: #dce5ea;">
                                        <span id="SpanSUICIDALBEHAVIOR" title="SUICIDAL BEHAVIOR" class="form_label"><b>SUICIDAL
                                            BEHAVIOR</b> (Check all that apply, so long as these are separate events; must ask
                                            about all types)</span>
                                    </td>

                                    <td style="width: 16%; background-color: #dce5ea; height: 20px; text-align: center;">
                                        <span id="SpanPast3Months" class="form_label">Past 3 Months</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" style="border: 1px solid #dce5ea; padding-left: 5px; vertical-align: top;">
                                        <table>
                                            <tr>
                                                <td style="height: 20px;">
                                                    <span id="SpanActualAttempt" class="form_label"><b>Actual Attempt:</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 30px;">
                                                    A potentially self-injurious act committed
                                                        with at least some wish to die, as a result of act. Behavior was in Part thought
                                                        of as method to kill oneself. Intent does not have to be 100%. If there is <i><b>any</b></i> intent/desire
                                                        to die associated with the act, then it can be considered an actual suicide attempt.
                                                        <i>
                                                            <b>There does not have to be any injury or harm</b></i>, just the potential for injury or harm.
                                                        If person pulls trigger while gun is in mouth but gun is broken so no injury results,
                                                        this is considered an attempt.
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 30px;">
                                                    Inferring Intent: Even if an individual
                                                        denies intent/wish to die, it may be inferred clinically from the behavior or circumstances.
                                                        For example, a highly lethal act that is clearly not an accident so no other intent
                                                        but suicide can be inferred (e.g., gunshot to head, jumping from window of a high
                                                        floor/story). Also, if someone denies intent to die, but they thought that what
                                                        they did could be lethal, intent may be inferred.
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;">
                                                    <span id="SpanHaveyoumade" class="form_label"><b>Did you ever </b><span class="auto-style1">do anything</span><i><b> to try to kill yourself or make yourself not alive anymore? What did you do?</b> </i></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;" class="auto-style5">
                                                    <span id="SpanHaveyoudoneanything" class="auto-style5"><b>Did you ever hurt yourself on purpose? Why did you do that?</b> </span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;" class="auto-style6">
                                                    <span id="Spandoneanythingdangerous" class="auto-style2">Did you ______as a way to end your life?</span><i> </i>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="padding-left: 15px;">
                                                    <table>
                                                        <tr>
                                                            <td style="height: 20px;" class="auto-style5">
                                                                <span id="SpanWhatdidyoudo" class="auto-style5"><i><b>Did you want to die (even a little) when you_______  ?</b></i> </span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="height: 20px;" class="auto-style6">
                                                                <span id="Spanendyourlife" class="auto-style2">Were you trying to make yourself not alive anymore when you _______?</span><i> </i>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="height: 20px;" class="auto-style5">
                                                                <span id="Spanevenalittle" class="auto-style5"><i><b>Or did you think it was possible you could have died from________?</b></i> </span>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 30px;">
                                                    <span id="Spanpurelyfor" class="form_label"><b><i>Or did you do it purely for other reasons,</i><span class="auto-style7"> not at all</span><i> to end your life or kill yourself (like to make yourself feel better, or get something else to happen)?</i></b> (Self - injurious Behavior without
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
                                                    <textarea class="form_textarea" id="TextArea_CustomDocumentCSSRSChildSinceLastVisits_ActualAttemptDescription"
                                                        name="TextArea_CustomDocumentCSSRSChildSinceLastVisits_ActualAttemptDescription" rows="4" cols="1"
                                                        style="width: 98%;" spellcheck="True" datatype="String" disabled="disabled"></textarea>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;">
                                                    <span id="SpanNonSuicidal" class="form_label"><b>Has subject engaged in Non-Suicidal Self-Injurious Behavior?</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;">
                                                    <span id="Span11" class="form_label"><b>Has subject engaged in Self-Injurious Behavior, intent unknown?</b></span>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 18%; border-style: solid; border-width: 1px; border-color: #dce5ea; text-align: center;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td style="height: 25px;"></td>
                                            </tr>
                                            <tr>
                                                <td style="text-align: center;" style="height: 20px;">
                                                    <asp:DropDownList ID="DropDownList_CustomDocumentCSSRSChildSinceLastVisits_ActualAttempt"
                                                        runat="server" EnableViewState="false" CssClass="form_dropdown" Width="50px" onchange="CSSRSChildAdolescentSinceLTHideandShow('DropDownList_CustomDocumentCSSRSChildSinceLastVisits_ActualAttempt')">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>

                                            <tr>
                                                <td style="text-align: center; height: 80px;"></td>
                                            </tr>
                                            <tr>
                                                <td style="padding-left: 5px;">
                                                    <table>

                                                        <tr>
                                                            <td style="text-align: center;" style="height: 20px;">
                                                                <span id="SpanNoOfAttempts" class="form_label">Total # of Attempts</span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="text-align: center;" style="height: 20px;">
                                                                <input type="text" class="form_textbox" name="TextBox_CustomDocumentCSSRSChildSinceLastVisits_TotalNumberOfAttempts"
                                                                    id="TextBox_CustomDocumentCSSRSChildSinceLastVisits_TotalNumberOfAttempts" datatype="Numeric"
                                                                    style="width: 87%" maxlength="8" disabled="disabled" />
                                                            </td>
                                                        </tr>

                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="text-align: center; height: 210px;"></td>
                                            </tr>
                                            <tr>
                                                <td style="text-align: center; height: 0px;"></td>
                                            </tr>
                                            <tr>
                                                <td style="text-align: center; height: 10px;">
                                                    <asp:DropDownList ID="DropDownList_CustomDocumentCSSRSChildSinceLastVisits_HasSubjectEngagedInNonSuicidalSelfInjuriousBehavior" runat="server"
                                                        EnableViewState="false" CssClass="form_dropdown" Width="50px">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>

                                            <tr>
                                                <td style="text-align: center; height: 10px;">
                                                    <asp:DropDownList ID="DropDownList_CustomDocumentCSSRSChildSinceLastVisits_HasSubjectEngagedInSelfInjuriousBehaviorIntentUnknown" runat="server"
                                                        EnableViewState="false" CssClass="form_dropdown" Width="50px">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>

                                        </table>
                                    </td>

                                </tr>
                                <tr>
                                    <td colspan="4" style="border: 1px solid #dce5ea; padding-left: 5px; vertical-align: top;" class="auto-style11">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td style="height: 20px;">
                                                    <span id="SpanInterruptedAttempt" class="form_label"><b>Interrupted Attempt:</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;">
                                                    When the person is interrupted
                                                        (by an outside circumstance) from starting the potentially self-injurious act (if
                                                        not for that, actual attempt would have occurred).
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 30px;">
                                                    Overdose: Person has pills in hand but is
                                                        stopped from ingesting. Once they ingest any pills, this becomes an attempt rather
                                                        than an interrupted attempt. Shootin: Person has gun pointed towards self, gun is
                                                        taken away by someone else, or is somehow prevented from pulling trigger. Once they
                                                        pull the trigger, even if the gun fails to fire, it is an attempt. Jumping: Person
                                                        is poised to jump, is grabbed and taken down from ledge. Hanging: Person has noose
                                                        around neck but has not yet started to hang - is stopped from doing so.
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="auto-style8"><i><b>Has there been a time when you started to do something to make yourself not alive anymore (end your life or kill yourself) but someone or something stopped you before you actually did anything? What did you do?</b></i> 
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;">
                                                    <span id="SpanIfYesOverdose" class="form_label">If yes, describe:</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 40px;">
                                                    <textarea class="form_textarea" id="TextArea_CustomDocumentCSSRSChildSinceLastVisits_InterruptedAttemptDescription"
                                                        name="TextArea_CustomDocumentCSSRSChildSinceLastVisits_InterruptedAttemptDescription" rows="4"
                                                        cols="1" style="width: 98%;" spellcheck="True" datatype="String" disabled="disabled"></textarea>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 8%; border-style: solid; border-width: 1px; border-color: #dce5ea; text-align: center;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td style="height: 20px; text-align: center;">
                                                    <asp:DropDownList ID="DropDownList_CustomDocumentCSSRSChildSinceLastVisits_InterruptedAttempt"
                                                        runat="server" EnableViewState="false" CssClass="form_dropdown" Width="50px" onchange="CSSRSChildAdolescentSinceLTHideandShow('DropDownList_CustomDocumentCSSRSChildSinceLastVisits_InterruptedAttempt')">
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
                                                    <input type="text" class="form_textbox" name="TextBox_CustomDocumentCSSRSChildSinceLastVisits_TotalNumberOfAttemptsInterrupted"
                                                        id="TextBox_CustomDocumentCSSRSChildSinceLastVisits_TotalNumberOfAttemptsInterrupted" datatype="Numeric" style="width: 87%"
                                                        maxlength="8" disabled="disabled" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 40px;"></td>
                                            </tr>
                                        </table>
                                    </td>

                                </tr>
                                <tr>
                                    <td colspan="4" style="border: 1px solid #dce5ea; padding-left: 5px; vertical-align: top;" class="auto-style11">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td style="height: 20px;">
                                                    <span id="SpanSelfInterrupted" class="form_label"><b>Aborted or Self-Interrupted Attempt:</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 30px;">
                                                    When Person begins to take steps
                                                        towards making a suicide attempt, but stops themselves before they actually have
                                                        engaged in any self-destructive behavior. Examples are similar to interrupted attempts,
                                                        except that the individual stops him/herself, instead of being stopped by something
                                                        else.
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;">
                                                    <span id="SpanHastherebeen" class="auto-style5">Has there been a time when you started to do something to make yourself not alive anymore (end your life or kill yourself) but you changed your mind (stopped yourself) before you actually did anything? What did you do? 
                                                    </span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;">
                                                    <span id="SpanIfYesSelfInterrupted" class="form_label">If yes, describe:</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 40px;">
                                                    <textarea class="form_textarea" id="TextArea_CustomDocumentCSSRSChildSinceLastVisits_AbortedOrSelfInterruptedAttemptDescription"
                                                        name="TextArea_CustomDocumentCSSRSChildSinceLastVisits_AbortedOrSelfInterruptedAttemptDescription" rows="4" cols="1" style="width: 98%;"
                                                        spellcheck="True" datatype="String" disabled="disabled"></textarea>
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
                                                    <asp:DropDownList ID="DropDownList_CustomDocumentCSSRSChildSinceLastVisits_AbortedOrSelfInterruptedAttempt" runat="server"
                                                        EnableViewState="false" CssClass="form_dropdown" Width="50px" onchange="CSSRSChildAdolescentSinceLTHideandShow('DropDownList_CustomDocumentCSSRSChildSinceLastVisits_AbortedOrSelfInterruptedAttempt')">
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
                                                    <input type="text" class="form_textbox" name="TextBox_CustomDocumentCSSRSChildSinceLastVisits_TotalNumberAttemptsAbortedOrSelfInterrupted"
                                                        id="TextBox_CustomDocumentCSSRSChildSinceLastVisits_TotalNumberAttemptsAbortedOrSelfInterrupted" datatype="Numeric" style="width: 87%"
                                                        maxlength="8" disabled="disabled" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 40px;"></td>
                                            </tr>
                                        </table>
                                    </td>

                                </tr>
                                <tr>
                                    <td colspan="4" style="border: 1px solid #dce5ea; padding-left: 5px; vertical-align: top;" class="auto-style11">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td style="height: 20px;">
                                                    <span id="SpanPreparatory" class="form_label"><b>Preparatory Acts or Behavior:</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 30px;">
                                                  Acts or preparation towards imminently making
                                                        a suicide attempt. This can include anything beyond a verbalization or thought,
                                                        such as assembling a specific method (e.g., buying pills, purchasing a gun) or preparing
                                                        for one's death by suicide (e.g., giving things away, writing a suicide note).
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;">
                                                    <span id="Spanpreparing" class="auto-style5">Have you done anything to get ready to make yourself not alive anymore (to end your life or kill yourself/- like giving things away, writing a goodbye note, getting things you need to kill yourself? </span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;">
                                                    <span id="SpanIfYesPreparatory" class="form_label">If yes, describe:</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 40px;">
                                                    <textarea class="form_textarea" id="TextArea_CustomDocumentCSSRSChildSinceLastVisits_PreparatoryActsOrBehaviorDescription"
                                                        name="TextArea_CustomDocumentCSSRSChildSinceLastVisits_PreparatoryActsOrBehaviorDescription" rows="4" cols="1"
                                                        style="width: 98%;" spellcheck="True" datatype="String" disabled="disabled"></textarea>
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
                                                    <asp:DropDownList ID="DropDownList_CustomDocumentCSSRSChildSinceLastVisits_PreparatoryActsOrBehavior" runat="server"
                                                        EnableViewState="false" CssClass="form_dropdown" Width="50px" onchange="CSSRSChildAdolescentSinceLTHideandShow('DropDownList_CustomDocumentCSSRSChildSinceLastVisits_PreparatoryActsOrBehavior')">
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
                                                    <input type="text" class="form_textbox" name="TextBox_CustomDocumentCSSRSChildSinceLastVisits_TotalNumberOfPreparatoryActs"
                                                        id="TextBox_CustomDocumentCSSRSChildSinceLastVisits_TotalNumberOfPreparatoryActs" datatype="Numeric" style="width: 87%"
                                                        maxlength="8" disabled="disabled" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 40px;"></td>
                                            </tr>
                                        </table>
                                    </td>

                                </tr>
                                <tr>
                                    <td colspan="4" style="border: 1px solid #dce5ea; padding-left: 5px; vertical-align: top;" class="auto-style11">
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
                                                    <asp:DropDownList ID="DropDownList_CustomDocumentCSSRSChildSinceLastVisits_SuicidalBehavior"
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
                    <tr id="SB2">
                        <td class="content_tab_bg">
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td colspan="3" style="padding-left: 5px; background-color: #dce5ea; height: 40px; width: 0%;"></td>
                                    <td style="background-color: #dce5ea; height: 40px; width: 40%; text-align: center;"></td>
                                    <td style="background-color: #dce5ea; height: 40px; width: 20%;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td align="center">
                                                    <span id="SpanFirstAttemptDate" class="form_label">Most Lethal Attempt Date:</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="center">
                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                        <tr class="date_Container">
                                                            <td style="text-align: center;">
                                                                <input type="text" datatype="Date" id="TextArea_CustomDocumentCSSRSChildSinceLastVisits_MostLethalAttemptDate"
                                                                    name="TextArea_CustomDocumentCSSRSChildSinceLastVisits_MostLethalAttemptDate" />
                                                            </td>
                                                            <td>&nbsp;
                                                            </td>
                                                            <td style="text-align: center;">
                                                                <img id="imgPatientGuradianSigned" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                    alt="Calendar" onclick="return showCalendar('TextArea_CustomDocumentCSSRSChildSinceLastVisits_MostLethalAttemptDate', '%m/%d/%Y');" />
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
                                        <table style="width: 100%;">
                                            <tr>
                                                <%-- <td style="text-align: right; vertical-align: top;width: 180px;" >--%>
                                                <td style="text-align: right; vertical-align: top;width: 208px;" >
                                                    <img style="cursor: default;" src="<%=RelativePath%>App_Themes/Includes/Images/info.png" 
                             id="Img1" />
                                                </td>
                                                <td></td>
                                            </tr>
                                            <tr>
                                                <td class="auto-style2">
                                        <span id="SpanActualLethality" class="auto-style6">Actual Lethality/Medical Damage:</span>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 8%; height: 40px; text-align: center;"></td>
                                    <td style="width: 8%; height: 40px; text-align: center;">
                                        <asp:DropDownList ID="DropDownList_CustomDocumentCSSRSChildSinceLastVisits_ActualLethalityMedicalDamage"
                                            runat="server" EnableViewState="false" CssClass="form_dropdown" Width="125px">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="3" style="padding-left: 5px; height: 40px; width: 40%;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td style="text-align: right; vertical-align: top;" class="auto-style2">
                                                    <img style="cursor: default;" src="<%=RelativePath%>App_Themes/Includes/Images/info.png" id="image_information" />
                                                </td>
                                                <td></td>
                                            </tr>
                                            <tr>
                                                <td class="auto-style2">
                                                    <span id="ChildSpanPotentialLethality" class="auto-style6">Potential Lethality: Only Answer if Actual Lethality = 0</span>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 8%; height: 40px; text-align: center;"></td>
                                    <td style="width: 8%; height: 40px; text-align: center;">
                                        <asp:DropDownList ID="DropDownList_CustomDocumentCSSRSChildSinceLastVisits_PotentialLethality"
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
