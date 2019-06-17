<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CSSRSAdultLifetimeChild.ascx.cs" 
Inherits="SHS.SmartCare.Custom_Assessment_WebPages_CSSRSAdultLifetimeChild" %>
<% if (HttpContext.Current == null)
   { %>
<link href="../../../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet"
    type="text/css" />
<%} %>
<script language="javascript" type="text/javascript" src="<%=RelativePath%>Custom/Assessment/Scripts/CSSRSAdultLifetimeChild.js"></script>
<style type="text/css">
    .style1
    {
        height: 20px;
    }
    .style2
    {
        font-style: italic;
        font-weight: bold;
    }
    .style3
    {
        font-style: italic;
    }
    .style4
    {
        font-style: normal;
    }
</style>
<div style="overflow-x: hidden">
    <table cellpadding="0" cellspacing="0" border="0" class="DocumentScreen">
        <tr>
            <td>
                <table id="mainTable" border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                        <td class="height1">
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                <tr>
                                    <td class="content_tab_left" align="left" nowrap="nowrap">
                                        <span id="ChildSpanSuicidalIdeationBehavior" title="Suicidal Ideation/ Behavior">Suicidal
                                            Ideation/ Behavior</span>
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
                        <td class="content_tab_bg">
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td colspan="6" style="padding-left: 5px; background-color: #dce5ea; height: 20px;">
                                        <span id="ChildSpanSuicidalIdeation" title="Suicidal Ideation" class="form_label"><b>Suicidal
                                            Ideation</b></span>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" style="width: 84%; padding-left: 5px; border-style: solid; border-width: 1px;
                                        border-color: #dce5ea; vertical-align: top;">
                                        <span id="ChildSpanAskQuestions" class="form_label"><i>Ask questions 1 and 2.If both are negative,
                                            proceed to "Suicidal Behavior" section. If the answer to question 2 is "Yes", ask
                                            </br> questions 3,4 and 5. If the answer to question 1 and/ or 2 is "Yes", complete
                                            "Intensity of Ideation" section below.</i></span>
                                    </td>
                                    <td style="width: 8%; border-style: solid; border-width: 1px; border-color: #dce5ea;">
                                        <span id="ChildSpanLifetine" class="form_label"><b>Lifetime: Time He/She Felt Most Suicidal</b></span>
                                    </td>
                                    <td style="width: 8%; border-style: solid; border-width: 1px; border-color: #dce5ea;">
                                        <span id="ChildSpanPast1Month" class="form_label"><b>Past 1 month</b></span>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" style="width: 84%; padding-left: 3px; padding-bottom: 2px; border-style: solid;
                                        border-width: 1px; border-color: #dce5ea;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td style="text-align: left;">
                                                    <span id="ChildSpanWishtobeDead" class="form_label"><b>1. Wish to be dead</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="ChildSpanSubject" class="form_label">Subject endorses thoughts about a wish to
                                                        be dead or not alive anymore, or wish to fall asleep and wake up.</span>
                                                </td>
                                            </tr>
                                            <tr>
                                             <td class="style3">
                                              <span id="ChildSpanyouthoughtabout" class="style2">Have you thought about being dead or what it would be like to be dead?</span><i>
                                                 </i>
                                             </td>
                                            </tr>
                                            <tr>
                                                <td class="style3">
                                                    <span id="ChildSpamhaveyouwished" class="style2">Have you wished you were dead or
                                                        wised you could go to sleep and never wake up?</span><i> </i>
                                                </td>
                                            </tr>
                                            <tr>
                                             <td class="style3">
                                              <span id="Childspanaliveanymore" class="style2">Do you ever wish you weren't alive anymore?</span><i>
                                                 </i>
                                             </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="ChildSpanIfYes" class="form_label">If yes, describe:</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <textarea class="form_textarea" id="TextArea_CustomDocumentChildLTs_DeadDescription"
                                                        name="TextArea_CustomDocumentChildLTs_DeadDescription" rows="4" cols="1" style="width: 98%;"
                                                        spellcheck="True" datatype="String" disabled="disabled"></textarea>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 8%; border-style: solid; border-width: 1px; border-color: #dce5ea;
                                        text-align: center;">
                                        <asp:DropDownList ID="DropDownList_CustomDocumentChildLTs_DeadLifeTime" runat="server"
                                            EnableViewState="false" CssClass="form_dropdown" Width="50px" onchange="CSSRSAdultLifetimeChildHideandShow('DropDownList_CustomDocumentChildLTs_DeadLifeTime')">
                                        </asp:DropDownList>
                                    </td>
                                    <td style="width: 8%; border-style: solid; border-width: 1px; border-color: #dce5ea;
                                        text-align: center;">
                                        <asp:DropDownList ID="DropDownList_CustomDocumentChildLTs_DeadPast1Month" runat="server"
                                            EnableViewState="false" CssClass="form_dropdown" Width="50px" onchange="CSSRSAdultLifetimeChildHideandShow('DropDownList_CustomDocumentChildLTs_DeadPast1Month')">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" style="width: 84%; padding-left: 3px; padding-top: 2px; border-style: solid;
                                        border-width: 1px; border-color: #dce5ea;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td style="text-align: left;">
                                                    <span id="ChildSpanNonSpecific" class="form_label"><b>2. Non-Specific Active Suicidal Thoughts</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="ChildSpanGeneralNonSpecific" class="form_label">General non-specific thoughts of
                                                        wanting to end one's life/commit suicide (e.g.,"I've thought about killing myself")
                                                        without thoughts of ways</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="ChildSpankilloneself" class="form_label">to kill oneself/associated methods, intent,
                                                        or plan during the assessment period.</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style3">
                                                    <span id="ChildSpanHaveyouactuallyhad" class="style2">Have you thought about doing something to make yourself not alive anymore?</span><i>
                                                    </i>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style3">
                                                    <span id="ChildSpankillingyourself" class="style2">Have you had any thoughts about killing yourself?</span><i>
                                                    </i>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="ChildSpanIfYes2" class="form_label">If yes, describe:</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <textarea class="form_textarea" id="TextArea_CustomDocumentChildLTs_NonSpecificDescription"
                                                        name="TextArea_CustomDocumentChildLTs_NonSpecificDescription" rows="4" cols="1"
                                                        style="width: 98%;" spellcheck="True" datatype="String" disabled="disabled"></textarea>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 8%; padding-top: 2px; border-style: solid; border-width: 1px; border-color: #dce5ea;
                                        text-align: center;">
                                        <asp:DropDownList ID="DropDownList_CustomDocumentChildLTs_NonSpecificLifeTime" runat="server"
                                            EnableViewState="false" CssClass="form_dropdown" Width="50px" onchange="CSSRSAdultLifetimeChildHideandShow('DropDownList_CustomDocumentChildLTs_NonSpecificLifeTime')">
                                        </asp:DropDownList>
                                    </td>
                                    <td style="width: 8%; padding-top: 2px; border-style: solid; border-width: 1px; border-color: #dce5ea;
                                        text-align: center;">
                                        <asp:DropDownList ID="DropDownList_CustomDocumentChildLTs_NonSpecificPast1Month" runat="server"
                                            EnableViewState="false" CssClass="form_dropdown" Width="50px" onchange="CSSRSAdultLifetimeChildHideandShow('DropDownList_CustomDocumentChildLTs_NonSpecificPast1Month')">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr id="3">
                                    <td colspan="4" style="width: 84%; padding-left: 3px; padding-top: 2px; border-style: solid;
                                        border-width: 1px; border-color: #dce5ea;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td>
                                                    <span id="ChildSpanActiveSuicidalIdeation" class="form_label"><b>3.Active Suicidal Ideation
                                                        with Any Methods (Not Plan) without Intent to Act</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="ChildSpanSubjectendorsesthoughts" class="form_label">Subject endorses thoughts
                                                        of suicide and has thought of at least one method during the assessment period.
                                                        This is different than a specific</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="ChildSpanplanwithtime" class="form_label">plan with time, place or method details
                                                        worked out (e.g., thought of method to kill self but not a specific plan). Includes
                                                        person who would</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="Childspanthoughtabouttaking" class="form_label">say, "I thought about taking an
                                                        overdose but I never made a specific plan as to when, where or how I would actually
                                                        do it... and I would never</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="ChildSpangoThroughwithit" class="form_label">go through with it."</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="font-style: italic">
                                                    <span id="ChildSpanyoumightdothis" class="form_label"><b>Have you thought about how you would do that or how you would make yourself not alive anymore (Kill yourself)? What did you think about?</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="ChildSpanIfYes3" class="form_label">If yes, describe:</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <textarea class="form_textarea" id="TextArea_CustomDocumentChildLTs_ActiveSuicidalIdeationDescription"
                                                        name="TextArea_CustomDocumentChildLTs_ActiveSuicidalIdeationDescription" rows="4"
                                                        cols="1" style="width: 98%;" spellcheck="True" datatype="String" disabled="disabled"></textarea>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 8%; padding-top: 2px; border-style: solid; border-width: 1px; border-color: #dce5ea;
                                        text-align: center;">
                                        <asp:DropDownList ID="DropDownList_CustomDocumentChildLTs_ActiveSuicidalIdeationLifeTime"
                                            runat="server" EnableViewState="false" CssClass="form_dropdown" Width="50px" onchange="CSSRSAdultLifetimeChildHideandShow('DropDownList_CustomDocumentChildLTs_ActiveSuicidalIdeationLifeTime')">
                                        </asp:DropDownList>
                                    </td>
                                    <td style="width: 8%; padding-top: 2px; border-style: solid; border-width: 1px; border-color: #dce5ea;
                                        text-align: center;">
                                        <asp:DropDownList ID="DropDownList_CustomDocumentChildLTs_ActiveSuicidalIdeationPast1Month"
                                            runat="server" EnableViewState="false" CssClass="form_dropdown" Width="50px" onchange="CSSRSAdultLifetimeChildHideandShow('DropDownList_CustomDocumentChildLTs_ActiveSuicidalIdeationPast1Month')">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr id="4">
                                    <td colspan="4" style="width: 84%; padding-left: 3px; padding-top: 2px; border-style: solid;
                                        border-width: 1px; border-color: #dce5ea;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td>
                                                    <span id="ChildSpanwithSomeIntenttoAct" class="form_label"><b>4. Active Suicidal Ideation
                                                        with Some Intent to Act, without Specific Plan</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="ChildSpanIhavethethoughts" class="form_label">Active suicidal thoughts of killing
                                                        oneself and subject reports having <u>some intent to act on such thoughts,</u> as
                                                        opposed to "I have the thoughts</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="ChildSpanbutIdefinitelywill" class="form_label">but I definitely will not do anything
                                                        about them."</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style3">
                                                    <span id="ChildspanHaveyouhadthesethoughts" class="style2">When you thought about making yourself not alive anymore (or killing yourself), did you think that this was something you might actually do?</span><i>
                                                    </i>
                                                </td>
                                            </tr>
                                            <tr>
                                             <td class="style3">
                                              <span id="Childspanisdifferentfrom" class="style2">This is different from (as opposed to) having the thoughts but knowing you wouldn't do anything about it.</span><i>
                                                 </i>
                                             </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="ChildSpanIfyes4" class="form_label">If yes, describe:</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <textarea class="form_textarea" id="TextArea_CustomDocumentChildLTs_ASISomeIntentActDescription"
                                                        name="TextArea_CustomDocumentChildLTs_ASISomeIntentActDescription" rows="4" cols="1"
                                                        style="width: 98%;" spellcheck="True" datatype="String" disabled="disabled"></textarea>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 8%; padding-top: 2px; border-style: solid; border-width: 1px; border-color: #dce5ea;
                                        text-align: center;">
                                        <asp:DropDownList ID="DropDownList_CustomDocumentChildLTs_ASILifeTime" runat="server"
                                            EnableViewState="false" CssClass="form_dropdown" Width="50px" onchange="CSSRSAdultLifetimeChildHideandShow('DropDownList_CustomDocumentChildLTs_ASILifeTime')">
                                        </asp:DropDownList>
                                    </td>
                                    <td style="width: 8%; padding-top: 2px; border-style: solid; border-width: 1px; border-color: #dce5ea;
                                        text-align: center;">
                                        <asp:DropDownList ID="DropDownList_CustomDocumentChildLTs_ASIPast1Month" runat="server"
                                            EnableViewState="false" CssClass="form_dropdown" Width="50px" onchange="CSSRSAdultLifetimeChildHideandShow('DropDownList_CustomDocumentChildLTs_ASIPast1Month')">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr id="5">
                                    <td colspan="4" style="width: 84%; padding-left: 3px; padding-top: 2px; border-style: solid;
                                        border-width: 1px; border-color: #dce5ea;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td>
                                                    <span id="ChildSpanSpecificPlanandIntent" class="form_label"><b>5. Active Suicidal Ideation
                                                        with Specific Plan and Intent</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="ChildSpanworkedoutandsubjecthas" class="form_label">Thoughts of killing oneself
                                                        with details of plan fully or Partially worked out and subject has some intent to
                                                        carry it out. </span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style3">
                                                    <span id="ChildSpanDoyouintendtocarryout" class="style2">Have you ever decided how or when you would make yourself not alive anymore/kill yourself? Have you ever planned out (worked out the details of) how you would do it?</span><i>
                                                    </i>
                                                </td>
                                            </tr>
                                            <tr>
                                             <td class="style3">
                                              <span id="ChildSpanWhatwasyourplan" class="style2">What was your plan?</span><i>
                                                 </i>
                                             </td>
                                            </tr>
                                            <tr>
                                             <td class="style3">
                                              <span id="ChildSpanyoumadethis" class="style2">When you made this plan (or worked out these details), was any part of you thinking about actually doing it?</span><i>
                                                 </i>
                                             </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="ChildSpanIfyes5" class="form_label">If Yes, describe:</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <textarea class="form_textarea" id="TextArea_CustomDocumentChildLTs_ASISpecificPlanAndIntentDescription"
                                                        name="TextArea_CustomDocumentChildLTs_ASISpecificPlanAndIntentDescription" rows="4"
                                                        cols="1" style="width: 98%;" spellcheck="True" datatype="String" disabled="disabled"></textarea>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 8%; padding-top: 2px; border-style: solid; border-width: 1px; border-color: #dce5ea;
                                        text-align: center;">
                                        <asp:DropDownList ID="DropDownList_CustomDocumentChildLTs_ASISPILifeTime" runat="server"
                                            EnableViewState="false" CssClass="form_dropdown" Width="50px" onchange="CSSRSAdultLifetimeChildHideandShow('DropDownList_CustomDocumentChildLTs_ASISPILifeTime')">
                                        </asp:DropDownList>
                                    </td>
                                    <td style="width: 8%; padding-top: 2px; border-style: solid; border-width: 1px; border-color: #dce5ea;
                                        text-align: center;">
                                        <asp:DropDownList ID="DropDownList_CustomDocumentChildLTs_ASISPIPast1Month" runat="server"
                                            EnableViewState="false" CssClass="form_dropdown" Width="50px" onchange="CSSRSAdultLifetimeChildHideandShow('DropDownList_CustomDocumentChildLTs_ASISPIPast1Month')">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr id="IID">
                        <td class="content_tab_bg">
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td colspan="6" style="padding-left: 5px; background-color: #dce5ea; height: 20px;">
                                        <span id="ChildSpanINTENSITYOFIDEATION" title="INTENSITY OF IDEATION" class="form_label">
                                            <b>INTENSITY OF IDEATION</b></span>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" style="width: 84%; padding-left: 5px; border-style: solid; border-width: 1px;
                                        border-color: #dce5ea; vertical-align: top;">
                                        <span id="ChildSpanfollowingfeatures" class="form_label"><i>The following features should be
                                            rated with respect to the most severe type of ideation (i.e., 1-5 from above, with
                                            1 being the </br> least severe and 5 being the most severe).</i></span>
                                        <table style="width: 100%;">
                                            <tr>
                                                <td style="width: 30%;">
                                                </td>
                                                <td style="width: 10%;">
                                                </td>
                                                <td style="width: 60%;">
                                                    <span id="ChildSpanEnterDescription" class="form_label">Enter Description of Ideation</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="width: 30%;">
                                                    <span id="ChildSpanLifetimeMostSevere" class="form_label">Lifetime - Most Severe Ideation:</span>
                                                </td>
                                                <td style="width: 10%;">
                                                    <asp:DropDownList ID="DropDownList_CustomDocumentChildLTs_LifeTimeMostSevere" runat="server"
                                                        EnableViewState="false" CssClass="form_dropdown" Width="50px" onchange="CSSRSAdultLifetimeChildHideandShow('DropDownList_CustomDocumentChildLTs_LifeTimeMostSevere')">
                                                    </asp:DropDownList>
                                                </td>
                                                <td style="width: 60%;">
                                                    <input type="text" class="form_textbox" name="TextBox_CustomDocumentChildLTs_MostSevereDescription"
                                                        id="TextBox_CustomDocumentChildLTs_MostSevereDescription" datatype="String" style="width: 87%"
                                                        maxlength="200" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="width: 30%;">
                                                    <span id="ChildSpanRecentMostSevere" class="form_label">Recent - Most Severe Ideation:</span>
                                                </td>
                                                <td style="width: 10%;">
                                                    <asp:DropDownList ID="DropDownList_CustomDocumentChildLTs_RecentMostSevere" runat="server"
                                                        EnableViewState="false" CssClass="form_dropdown" Width="50px" onchange="CSSRSAdultLifetimeChildHideandShow('DropDownList_CustomDocumentChildLTs_RecentMostSevere')">
                                                    </asp:DropDownList>
                                                </td>
                                                <td style="width: 60%;">
                                                    <input type="text" class="form_textbox" name="TextBox_CustomDocumentChildLTs_RecentMostSevereDescription"
                                                        id="TextBox_CustomDocumentChildLTs_RecentMostSevereDescription" datatype="String"
                                                        style="width: 87%" maxlength="2000" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 8%; border-style: solid; border-width: 1px; border-color: #dce5ea;">
                                        <span id="ChildSpanMostSevere1" class="form_label">Most Severe</span>
                                    </td>
                                    <td style="width: 8%; border-style: solid; border-width: 1px; border-color: #dce5ea;">
                                        <span id="ChildSpanMostSevere2" class="form_label">Most Severe</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" style="width: 84%; padding-left: 5px; border-style: solid; border-width: 1px;
                                        border-color: #dce5ea; vertical-align: top;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td>
                                                    <span id="ChildSpanFrequency" class="form_label"><b>Frequency</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="ChildSpanHowmanytimeshave" class="form_label"><b>How many times have you had these
                                                        thoughts?</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="padding-left: 5px;">
                                                    <table>
                                                        <tr>
                                                            <td>
                                                                <span id="ChildSpan1" class="form_label">(1) Only one time </span>
                                                            </td>
                                                            <td>
                                                                <span id="ChildSpan2" class="form_label">(2) A few times</span>
                                                            </td>
                                                            <td>
                                                                <span id="ChildSpan3" class="form_label">(3) A lot</span>
                                                            </td>
                                                            <td>
                                                                <span id="ChildSpan4" class="form_label">(4) All the time</span>
                                                            </td>
                                                            <td>
                                                                <span id="ChildSpan5" class="form_label">(5) Don’t know/Not applicable</span>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 8%; border-style: solid; border-width: 1px; border-color: #dce5ea;
                                        text-align: center;">
                                        <asp:DropDownList ID="DropDownList_CustomDocumentChildLTs_FrequencyMostSevereOne"
                                            runat="server" EnableViewState="false" CssClass="form_dropdown" Width="50px">
                                        </asp:DropDownList>
                                    </td>
                                    <td style="width: 8%; border-style: solid; border-width: 1px; border-color: #dce5ea;
                                        text-align: center;">
                                        <asp:DropDownList ID="DropDownList_CustomDocumentChildLTs_FrequencyMostSevereTwo"
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
                                    <td colspan="4" style="padding-left: 5px; background-color: #dce5ea; height: 20px;">
                                        <span id="ChildSpanSUICIDALBEHAVIOR" title="SUICIDAL BEHAVIOR" class="form_label"><b>SUICIDAL
                                            BEHAVIOR</b></span>
                                    </td>
                                    <td style="width: 8%; background-color: #dce5ea; height: 20px;">
                                        <span id="ChildSpanLifeTime" class="form_label">Lifetime</span>
                                    </td>
                                    <td style="width: 8%; background-color: #dce5ea; height: 20px;">
                                        <span id="ChildSpanPast3Months" class="form_label">Past 3 Months</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" style="width: 84%; padding-left: 5px; border-style: solid; border-width: 1px;
                                        border-color: #dce5ea; vertical-align: top;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td style="height:20px;">
                                                    <span id="ChildSpanActualAttempt" class="form_label"><b>Actual Attempt:</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height:30px;">
                                                    <span id="ChildSpanselfinjurious" class="form_label">A potentially self-injurious act committed
                                                        with at least some wish to die, as a result of act. Behavior was in Part thought
                                                        of as method to kill oneself. Intent does not have to be 100%. If there is 
                                                    <b style="font-style: italic">any</b> intent/desire
                                                        to die associated with the act, then it can be considered an actual suicide attempt.
                                                        <b style="font-style: italic">There does not have to be any injury or harm</b>, just the potential for injury or harm.
                                                        If person pulls trigger while gun is in mouth but gun is broken so no injury results,
                                                        this is considered an attempt.</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td  style="height:30px;">
                                                    <span id="ChildSpanInferringIntent" class="form_label">Inferring Intent: Even if an individual
                                                        denies intent/wish to die, it may be inferred clinically from the behavior or circumstances.
                                                        For example, a highly lethal act that is clearly not an accident so no other intent
                                                        but suicide can be inferred (e.g., gunshot to head, jumping from window of a high
                                                        floor/story). Also, if someone denies intent to die, but they thought that what
                                                        they did could be lethal, intent may be inferred.</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height:20px;">
                                                    <span id="ChildSpanHaveyoumade" class="form_label">
                                                    <b style="font-style: italic">Did you ever <u>do anything</u> to try to kill yourself or make yourself not alive anymore? What did you do?</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height:20px;" class="style3">
                                                    <span id="ChildSpanHaveyoudoneanything" class="style2">Did you ever hurt yourself on purpose? Why did you do that?</span><i>
                                                    </i>
                                                </td>
                                            </tr>

                                            <tr>
                                                <td style="padding-left: 15px;" class="style3">
                                                    <table>
                                                        <tr>
                                                            <td style="height:20px;">
                                                                <span id="ChildSpanWhatdidyoudo" class="form_label"><b>Did you <i> <u>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                                </u> as a way to end your life?</i></b></span><i> </i>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="height:20px;">
                                                                <span id="ChildSpanevenalittle" class="form_label"><b><i>Did you want to die (even a little)
                                                                    when you <u>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </u>?</i></b></span><i>
                                                                </i>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="height:20px;">
                                                                <span id="ChildSpanyoutryingtoend" class="form_label"><b><i>Were you trying to make yourself not alive anymore when you<u>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </u>?</i></b></span><i>
                                                                </i>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="height:20px;">
                                                                <span id="ChildSpanOrDidyouthink" class="form_label"><b><i>Or Did you think it was possible
                                                                    you could have died from <u>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                                    
                                                                    
                                                                    </u>?</i></b></span><i> </i>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 30px;" class="style3">
                                                    <span id="ChildSpanpurelyfor" class="form_label"><b>Or did you do it purely for your
                                                        reasons, <i> <U>not at all</U> to end your life or kill yourself (like to make yourself feel
                                                        better, or get something else to happen)?</i></b><i> </i>
                                                    <span class="style4">(Self - injurious Behavior without
                                                        suicidal intent)</span></span><i> </i>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;">
                                                    <span id="ChildSpanIfYesSuicidal" class="form_label">If Yes, describe</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;">
                                                    <textarea class="form_textarea" id="TextArea_CustomDocumentChildLTs_ActualAttemptDescription"
                                                        name="TextArea_CustomDocumentChildLTs_ActualAttemptDescription" rows="4" cols="1"
                                                        style="width: 98%;" spellcheck="True" datatype="String" disabled></textarea>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;">
                                                    <span id="ChildSpanNonSuicidal" class="form_label"><b>Has subject engaged in Non-Suicidal
                                                        Self-Injurious Behavior?</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;">
                                                    <span id="ChildSpanHassubjectengaged" class="form_label"><b>Has subject engaged in self-Injurious
                                                        Behavior, intent unknown?</b></span>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 8%; border-style: solid; border-width: 1px; border-color: #dce5ea;
                                        text-align: center;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td style="text-align: center;" style="height: 20px;">
                                                    <asp:DropDownList ID="DropDownList_CustomDocumentChildLTs_SuicidalBehaviourLifeTime"
                                                        runat="server" EnableViewState="false" CssClass="form_dropdown" Width="50px" onchange="CSSRSAdultLifetimeChildHideandShow('DropDownList_CustomDocumentChildLTs_SuicidalBehaviourLifeTime')">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 30px;">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 30px;">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="padding-left: 15px;">
                                                    <table>
                                                        <tr>
                                                            <td style="height: 20px;">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="text-align: center;" style="height: 20px;">
                                                                <span id="ChildSpanNoOfAttempts" class="form_label">Total # of Attempts</span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="text-align: center;" style="height: 20px;">
                                                                <input type="text" class="form_textbox" name="TextBox_CustomDocumentChildLTs_SuicidalBehaviourAttemptNoOne"
                                                                    id="TextBox_CustomDocumentChildLTs_SuicidalBehaviourAttemptNoOne" datatype="Numeric"
                                                                    style="width: 87%" maxlength="8" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="height: 20px;">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="height: 20px;">
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 30px;">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="text-align: center; height: 20px;">
                                                    <asp:DropDownList ID="DropDownList_CustomDocumentChildLTs_SelfInjuriesOne" runat="server"
                                                        EnableViewState="false" CssClass="form_dropdown" Width="50px">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="text-align: center; height: 20px;">
                                                    <asp:DropDownList ID="DropDownList_CustomDocumentChildLTs_SelfInjuriesIntentOne"
                                                        runat="server" EnableViewState="false" CssClass="form_dropdown" Width="50px">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 8%; border-style: solid; border-width: 1px; border-color: #dce5ea;
                                        text-align: center;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td style="text-align: center;" style="height: 20px;">
                                                    <asp:DropDownList ID="DropDownList_CustomDocumentChildLTs_SuicidalBehaviourPast3Monts"
                                                        runat="server" EnableViewState="false" CssClass="form_dropdown" Width="50px" onchange="CSSRSAdultLifetimeChildHideandShow('DropDownList_CustomDocumentChildLTs_SuicidalBehaviourPast3Monts')">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 30px;">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 30px;">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="padding-left: 15px;">
                                                    <table>
                                                        <tr>
                                                            <td style="height: 20px;">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="text-align: center;" style="height: 20px;">
                                                                <span id="ChildSpanTotalNoAttempts" class="form_label">Total # of Attempts</span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="text-align: center;" style="height: 20px;">
                                                                <input type="text" class="form_textbox" name="TextBox_CustomDocumentChildLTs_SuicidalBehaviourAttemptNoTwo"
                                                                    id="TextBox_CustomDocumentChildLTs_SuicidalBehaviourAttemptNoTwo" datatype="Numeric"
                                                                    style="width: 87%" maxlength="8" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="height: 20px;">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="height: 20px;">
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 30px;">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="text-align: center; height: 20px;">
                                                    <asp:DropDownList ID="DropDownList_CustomDocumentChildLTs_SelfInjuriesTwo" runat="server"
                                                        EnableViewState="false" CssClass="form_dropdown" Width="50px">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="text-align: center; height: 20px;">
                                                    <asp:DropDownList ID="DropDownList_CustomDocumentChildLTs_SelfInjuriesIntentTwo"
                                                        runat="server" EnableViewState="false" CssClass="form_dropdown" Width="50px">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" style="width: 84%; padding-left: 5px; border-style: solid; border-width: 1px;
                                        border-color: #dce5ea; vertical-align: top;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td style="height: 20px;">
                                                    <span id="ChildSpanInterruptedAttempt" class="form_label"><b>Interrupted Attempt:</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;">
                                                    <span id="ChildSpanoutsidecircumstance" class="form_label">When the person is interrupted
                                                        (by an outside circumstance) from starting the potentially self-injurious act (if
                                                        not for that, actual attempt would have occurred).</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 30px;">
                                                    <span id="ChildSpanOverdose" class="form_label">Overdose: Person has pills in hand but
                                                        is stopped from ingesting. Once they ingest any pills, this becomes an attempt rather
                                                        than an interrupted attempt. Shootin: Person has gun pointed towards self, gun is
                                                        taken away by someone else, or is somehow prevented from pulling trigger. Once they
                                                        pull the trigger, even if the gun fails to fire, it is an attempt. Jumping: Person
                                                        is poised to jump, is grabbed and taken down from ledge. Hanging: Person has noose
                                                        around neck but has not yet started to hang - is stopped from doing so.</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px; font-style: italic;">
                                                    <span><b>Has there been a time when you started to do something to make yourself not
                                                        alive anymore (end your life or kill yourself)</br>but someone or something stopped
                                                        you before you actually did anything? What did you do?</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;">
                                                    <span id="ChildSpanIfYesOverdose" class="form_label">If yes, describe:</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 40px;">
                                                    <textarea class="form_textarea" id="TextArea_CustomDocumentChildLTs_InterruptedAttemptDescription"
                                                        name="TextArea_CustomDocumentChildLTs_InterruptedAttemptDescription" rows="4"
                                                        cols="1" style="width: 98%;" spellcheck="True" datatype="String" disabled></textarea>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 8%; border-style: solid; border-width: 1px; border-color: #dce5ea;
                                        text-align: center;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td style="height: 20px; text-align: center;">
                                                    <asp:DropDownList ID="DropDownList_CustomDocumentChildLTs_InterruptedAttemptLifeTime"
                                                        runat="server" EnableViewState="false" CssClass="form_dropdown" Width="50px" onchange="CSSRSAdultLifetimeChildHideandShow('DropDownList_CustomDocumentChildLTs_InterruptedAttemptLifeTime')">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 30px;">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px; text-align: center;">
                                                    <span id="ChildSpanTotalNointerrupted" class="form_label">Total # of interrupted</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px; text-align: center;">
                                                    <input type="text" class="form_textbox" name="TextBox_CustomDocumentChildLTs_TotalNoInterruptedOne"
                                                        id="TextBox_CustomDocumentChildLTs_TotalNoInterruptedOne" datatype="Numeric" style="width: 87%"
                                                        maxlength="8" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 40px;">
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 8%; border-style: solid; border-width: 1px; border-color: #dce5ea;
                                        text-align: center;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td style="height: 20px; text-align: center;">
                                                    <asp:DropDownList ID="DropDownList_CustomDocumentChildLTs_InterruptedAttemptPast3Months"
                                                        runat="server" EnableViewState="false" CssClass="form_dropdown" Width="50px" onchange="CSSRSAdultLifetimeChildHideandShow('DropDownList_CustomDocumentChildLTs_InterruptedAttemptPast3Months')">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 30px;">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px; text-align: center;">
                                                    <span id="ChildSpan6" class="form_label">Total # of interrupted</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px; text-align: center;">
                                                    <input type="text" class="form_textbox" name="TextBox_CustomDocumentChildLTs_TotalNoInterruptedTwo"
                                                        id="TextBox_CustomDocumentChildLTs_TotalNoInterruptedTwo" datatype="Numeric" style="width: 87%"
                                                        maxlength="8" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 40px;">
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" style="width: 84%; padding-left: 5px; border-style: solid; border-width: 1px;
                                        border-color: #dce5ea; vertical-align: top;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td style="height: 20px;">
                                                    <span id="ChildSpanSelfInterrupted" class="form_label"><b>Aborted or Self-Interrupted
                                                        Attempt:</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 30px;">
                                                    <span id="ChildSpanWhenPersonbegins" class="form_label">When Person begins to take steps
                                                        towards making a suicide attempt, but stops themselves before they actually have
                                                        engaged in any self-destructive behavior. Examples are similar to interrupted attempts,
                                                        except that the individual stops him/herself, instead of being stopped by something
                                                        else.</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px; font-style: italic;">
                                                    <span id="ChildSpanHastherebeen" class="form_label"><b>Has there been a time when you
                                                        started to do something to make yourself not alive anymore (end your life or kill
                                                        yourself)</br>but you changed your mind (stopped yourself) before you actually did
                                                        anything? What did you do?</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;">
                                                    <span id="ChildSpanIfYesSelfInterrupted" class="form_label">If yes, describe:</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 40px;">
                                                    <textarea class="form_textarea" id="TextArea_CustomDocumentChildLTs_AbortedDescription"
                                                        name="TextArea_CustomDocumentChildLTs_AbortedDescription" rows="4" cols="1" style="width: 98%;"
                                                        spellcheck="True" datatype="String" disabled></textarea>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 8%; border-style: solid; border-width: 1px; border-color: #dce5ea;
                                        text-align: center;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td style="height: 20px;">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 30px; text-align: center;">
                                                    <asp:DropDownList ID="DropDownList_CustomDocumentChildLTs_AbortedLifeTime" runat="server"
                                                        EnableViewState="false" CssClass="form_dropdown" Width="50px" onchange="CSSRSAdultLifetimeChildHideandShow('DropDownList_CustomDocumentChildLTs_AbortedLifeTime')">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px; text-align: center;">
                                                    <span id="ChildSpanaborted" class="form_label">Total # of aborted or self-interrupted</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px; text-align: center;">
                                                    <input type="text" class="form_textbox" name="TextBox_CustomDocumentChildLTs_AbortedOne"
                                                        id="TextBox_CustomDocumentChildLTs_AbortedOne" datatype="Numeric" style="width: 87%"
                                                        maxlength="8" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 40px;">
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 8%; border-style: solid; border-width: 1px; border-color: #dce5ea;
                                        text-align: center;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td style="height: 20px; text-align: center;">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 30px;">
                                                    <asp:DropDownList ID="DropDownList_CustomDocumentChildLTs_AbortedPast3Months" runat="server"
                                                        EnableViewState="false" CssClass="form_dropdown" Width="50px" onchange="CSSRSAdultLifetimeChildHideandShow('DropDownList_CustomDocumentChildLTs_AbortedPast3Months')">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px; text-align: center;">
                                                    <span id="ChildSpanabortedTwo" class="form_label">Total # of aborted or self-interrupted</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px; text-align: center;">
                                                    <input type="text" class="form_textbox" name="TextBox_CustomDocumentChildLTs_AbortedTwo"
                                                        id="TextBox_CustomDocumentChildLTs_AbortedTwo" datatype="Numeric" style="width: 87%"
                                                        maxlength="8" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 40px;">
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" style="width: 84%; padding-left: 5px; border-style: solid; border-width: 1px;
                                        border-color: #dce5ea; vertical-align: top;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td style="height: 20px;">
                                                    <span id="ChildSpanPreparatory" class="form_label"><b>Preparatory Acts or Behavior:</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 30px;">
                                                    <span id="ChildSpanActsor" class="form_label">Acts or preparation towards imminently
                                                        making a suicide attempt. This can include anything beyond a verbalization or thought,
                                                        such as assembling a specific method (e.g., buying pills, purchasing a gun) or preparing
                                                        for one's death by suicide (e.g., giving things away, writing a suicide note).</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style1">
                                                    <span id="ChildSpanpreparing" class="form_label"><b style="font-style: italic">Have you done anything to get ready
                                                        to make yourself not alive anymore (to end your life or kill yourself)- like giving</br>things
                                                        away, writing a goodbye note, getting things you need to kill yourself?</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;">
                                                    <span id="ChildSpanIfYesPreparatory" class="form_label">If yes, describe:</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 40px;">
                                                    <textarea class="form_textarea" id="TextArea_CustomDocumentChildLTs_PreparatoryDescription"
                                                        name="TextArea_CustomDocumentChildLTs_PreparatoryDescription" rows="4" cols="1"
                                                        style="width: 98%;" spellcheck="True" datatype="String" disabled></textarea>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 8%; border-style: solid; border-width: 1px; border-color: #dce5ea;
                                        text-align: center;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td style="height: 20px;">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 30px; text-align: center;">
                                                    <asp:DropDownList ID="DropDownList_CustomDocumentChildLTs_PreparatoryLifeTime" runat="server"
                                                        EnableViewState="false" CssClass="form_dropdown" Width="50px" onchange="CSSRSAdultLifetimeChildHideandShow('DropDownList_CustomDocumentChildLTs_PreparatoryLifeTime')">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px; text-align: center;">
                                                    <span id="ChildSpanTotalNoofpreparatory" class="form_label">Total # of preparatory acts</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px; text-align: center;">
                                                    <input type="text" class="form_textbox" name="TextBox_CustomDocumentChildLTs_PreparatoryOne"
                                                        id="TextBox_CustomDocumentChildLTs_PreparatoryOne" datatype="Numeric" style="width: 87%"
                                                        maxlength="8" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 40px;">
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 8%; border-style: solid; border-width: 1px; border-color: #dce5ea;
                                        text-align: center;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td style="height: 20px; text-align: center;">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 30px;">
                                                    <asp:DropDownList ID="DropDownList_CustomDocumentChildLTs_PreparatoryPast3Months"
                                                        runat="server" EnableViewState="false" CssClass="form_dropdown" Width="50px" onchange="CSSRSAdultLifetimeChildHideandShow('DropDownList_CustomDocumentChildLTs_PreparatoryPast3Months')">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px; text-align: center;">
                                                    <span id="ChildSpanpreparatoryTwo" class="form_label">Total # of preparatory acts</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px; text-align: center;">
                                                    <input type="text" class="form_textbox" name="TextBox_CustomDocumentChildLTs_PreparatoryTwo"
                                                        id="TextBox_CustomDocumentChildLTs_PreparatoryTwo" datatype="Numeric" style="width: 87%"
                                                        maxlength="8" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 40px;">
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" style="width: 84%; padding-left: 5px; border-style: solid; border-width: 1px;
                                        border-color: #dce5ea; vertical-align: top;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td style="height: 20px;">
                                                    <span id="ChildSpanFinalSuicidalBehavior" class="form_label"><b>Suicidal Behavior:</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;">
                                                    <span id="ChildSpanduringtheassessment" class="form_label">Suicidal behavior was present
                                                        during the assessment period?</span>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 8%; border-style: solid; border-width: 1px; border-color: #dce5ea;
                                        text-align: center;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td style="height: 20px;">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;">
                                                    <asp:DropDownList ID="DropDownList_CustomDocumentChildLTs_SuicidalBehaviorLifeTime"
                                                        runat="server" EnableViewState="false" CssClass="form_dropdown" Width="50px">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 8%; border-style: solid; border-width: 1px; border-color: #dce5ea;
                                        text-align: center;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td style="height: 20px;">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 20px;">
                                                    <asp:DropDownList ID="DropDownList_CustomDocumentChildLTs_SuicidalBehaviorPast3Months"
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
                                    <td colspan="3" style="padding-left: 5px; background-color: #dce5ea; height: 40px; width:40%;">
                                    </td>
                                    <td style="background-color: #dce5ea; height: 40px; width:20%; text-align: center;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td align="center">
                                                    <span id="ChildSpanRecentAttemptDate" class="form_label">Most Recent Attempt Date:</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="center">
                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                        <tr class="date_Container">
                                                            <td>
                                                                <input type="text" datatype="Date" id="TextArea_CustomDocumentChildLTs_RecentAttemptDate"
                                                                    name="TextArea_CustomDocumentChildLTs_RecentAttemptDate" />
                                                            </td>
                                                            <td>
                                                                &nbsp;
                                                            </td>
                                                            <td>
                                                                <img id="imgPatientGuradianSigned" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                    alt="Calendar" onclick="return showCalendar('TextArea_CustomDocumentChildLTs_RecentAttemptDate', '%m/%d/%Y');" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="background-color: #dce5ea; height: 40px; width:20%; text-align: center;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td align="center">
                                                    <span id="ChildSpanLethalAttemptDate" class="form_label">Most Lethal Attempt Date:</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="center">
                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                        <tr class="date_Container">
                                                            <td style="text-align: center;">
                                                                <input type="text" datatype="Date" id="TextArea_CustomDocumentChildLTs_LethalAttemptDate"
                                                                    name="TextArea_CustomDocumentChildLTs_LethalAttemptDate" />
                                                            </td>
                                                            <td>
                                                                &nbsp;
                                                            </td>
                                                            <td style="text-align: center;">
                                                                <img id="img1" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                    alt="Calendar" onclick="return showCalendar('TextArea_CustomDocumentChildLTs_LethalAttemptDate', '%m/%d/%Y');" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="background-color: #dce5ea; height: 40px; width:20%; text-align: center;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td align="center">
                                                    <span id="ChildSpanFirstAttemptDate" class="form_label">Initial/First Attempt Date:</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="center">
                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                        <tr class="date_Container">
                                                            <td style="text-align: center;">
                                                                <input type="text" datatype="Date" id="TextArea_CustomDocumentChildLTs_FirstAttemptDate"
                                                                    name="TextArea_CustomDocumentChildLTs_FirstAttemptDate" />
                                                            </td>
                                                            <td>
                                                                &nbsp;
                                                            </td>
                                                            <td style="text-align: center;">
                                                                <img id="img2" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                    alt="Calendar" onclick="return showCalendar('TextArea_CustomDocumentChildLTs_FirstAttemptDate', '%m/%d/%Y');" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                     <td colspan="3" style="padding-left: 5px; height: 40px; width: 20%;">
                                        <table style="width: 100%;">

<tr>
                                                <td style="text-align: right; vertical-align: top;">
                                                    <img style="cursor: default;" src="<%=RelativePath%>App_Themes/Includes/Images/info.png"
                                                        id="Img3" />
                                                </td><td style="text-align: right; vertical-align: top;">
                                                   &nbsp;</td>
                                                    </td><td style="text-align: right; vertical-align: top;">
                                                   &nbsp;</td>
                                            </tr>
                                            <tr><td colspan="3" style="padding-left: 5px; height: 40px; width: 40%;">
                                        <span id="ChildSpanActualLethality" class="form_label"><b>Actual Lethality/Medical Damage:</b></span>
                                    </td>
                                            </tr>
</table>
                                    
                                    <td style=" width:20%;  height: 40px; text-align: center;">
                                        <asp:DropDownList ID="DropDownList_CustomDocumentChildLTs_ActualLethality1" runat="server"
                                            EnableViewState="false" CssClass="form_dropdown" Width="125px">
                                        </asp:DropDownList>
                                    </td>
                                    <td style=" width:20%;  height: 40px; text-align: center;">
                                        <asp:DropDownList ID="DropDownList_CustomDocumentChildLTs_ActualLethality2" runat="server"
                                            EnableViewState="false" CssClass="form_dropdown" Width="125px">
                                        </asp:DropDownList>
                                    </td>
                                    <td style=" width:20%;  height: 40px; text-align: center;">
                                        <asp:DropDownList ID="DropDownList_CustomDocumentChildLTs_ActualLethality3" runat="server"
                                            EnableViewState="false" CssClass="form_dropdown" Width="125px">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="3" style="padding-left: 5px; height: 40px; width: 20%;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td style="text-align: right; vertical-align: top;">
                                                    <img style="cursor: default;" src="<%=RelativePath%>App_Themes/Includes/Images/info.png"
                                                        id="image_info" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="ChildSpanPotentialLethality" class="form_label"><b>Potential Lethality: Only
                                                        Answer if Actual Lethality = 0</b></span>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 8%; height: 40px; text-align: center;">
                                        <asp:DropDownList ID="DropDownList_CustomDocumentChildLTs_PotentialLethality1" runat="server"
                                            EnableViewState="false" CssClass="form_dropdown" Width="125px">
                                        </asp:DropDownList>
                                    </td>
                                    <td style="width: 8%; height: 40px; text-align: center;">
                                        <asp:DropDownList ID="DropDownList_CustomDocumentChildLTs_PotentialLethality2" runat="server"
                                            EnableViewState="false" CssClass="form_dropdown" Width="125px">
                                        </asp:DropDownList>
                                    </td>
                                    <td style="width: 8%; height: 40px; text-align: center;">
                                        <asp:DropDownList ID="DropDownList_CustomDocumentChildLTs_PotentialLethality3" runat="server"
                                            EnableViewState="false" CssClass="form_dropdown" Width="125px">
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
                        <td>
                            <input id="ActualLethalityMedicalDamage" name="HiddenFieldPageTables" type="hidden" value="0.  No physical damage or very minor physical damage (e.g., surface scratches).<br/>
1.  Minor physical damage (e.g., lethargic speech; first-degree burns; mild bleeding; sprains).<br/>
2.  Moderate physical damage; medical attention needed<br/>&nbsp&nbsp (e.g., conscious but sleepy, somewhat responsive; second-degree burns; bleeding of major vessel).<br/>
3.  Moderately severe physical damage; medical hospitalization and likely intensive care required<br/>&nbsp&nbsp (e.g., comatose with reflexes intact; third-degree burns less than 20% of body; extensive blood loss but can recover; major fractures).<br/>
4.  Severe physical damage; medical hospitalization with intensive care required<br/>&nbsp&nbsp (e.g., comatose without reflexes; third-degree burns over 20% of body; extensive blood loss with unstable vital signs; major damage to a vital area).<br/>
5.  Death" />
                            <input id="PotentialLethality" name="HiddenFieldPageTables" type="hidden" value="&nbsp Likely lethality of actual attempt if no medical damage <br/>&nbsp (the following examples, while having no actual medical damage, had potential for very serious lethality: <br/>&nbsp put gun in mouth and pulled the trigger but gun fails to fire so no medical damage;<br/>&nbsp laying on train tracks with oncoming train but pulled away before run over)." />
                        </td>
                    </tr>
                </table>
</div>
