<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CSSRSAdultScreeners.ascx.cs" Inherits="SHS.SmartCare.Custom_Assessment_WebPages_CSSRSAdultScreeners" %>
<%@ Register Assembly="Streamline.DotNetDropDownGlobalCodes" Namespace="Streamline.DotNetDropDownGlobalCodes"
    TagPrefix="DropDownGlobalCodes" %>
<% if (HttpContext.Current == null)
   { %>
<link href="../../../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet"
    type="text/css" />
<%} %>
<script src="<%=RelativePath %>Custom/CSSRS/Scripts/CSSRSAdultScreeners.js"></script>
<script src="<%=RelativePath %>JScripts/ApplicationScripts/GeneralArrayHelpers.js"></script>
<script src="<%=RelativePath %>JScripts/ApplicationScripts/GeneralFormFunctions.js"></script>

<div style="overflow-x: hidden" id="divCSSRSAdultScreeners">
    <table cellpadding="0" cellspacing="0" border="0" style="width: 833px" class="CrossBrowserAutoFixChrome_width_847px">
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
                                        <span id="SpanSuicidalIdeationDefinitions" title="Suicidal Ideation Definitions And Prompts"><i></i>Suicidal
                                            Ideation Definitions And Prompts</span>
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
                                    <td colspan="4" style="width: 92%; padding-left: 5px; border-style: solid; border-width: 1px; border-color: #dce5ea; vertical-align: top;">
                                        <span id="SpanAskQuestions" class="form_label"><i>Ask questions 1 and 2.  If YES to 2, ask questions 3,4,5, and 6.   
                                        If NO to 2, go directly to question 6.<br />
                                            Ask the questions that are bolded and underlined.</i></span>
                                    </td>
                                    <td style="width: 8%; border-style: solid; border-width: 1px; border-color: #dce5ea;">
                                        <span id="SpanPast1Month" class="form_label"><b>Past month</b></span>
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
                                                    <span id="SpanPersonEndorses" class="form_label">Person endorses thoughts about a wish to be dead 
                                                    or not alive anymore, or wish to fall asleep and not wake up.</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="SpanHaveyouwished" class="form_label"><i><b><u>Have you wished you were dead or 
                                                    wished you could go to sleep and not wake up? </u></b></i></span>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 8%; border-style: solid; border-width: 1px; border-color: #dce5ea; text-align: center;">
                                        <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentCSSRSAdultScreeners_WishToBeDead"
                                            AppendDataBoundItems="true" runat="server" Category="XCSSRSYESNO" CssClass="form_dropdown" TabIndex="1">
                                        </DropDownGlobalCodes:DropDownGlobalCodes>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" style="width: 92%; padding-left: 3px; padding-top: 2px; border-style: solid; border-width: 1px; border-color: #dce5ea;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td style="text-align: left;">
                                                    <span id="SpanSuicidalThoughts" class="form_label"><b>2.  Suicidal Thoughts</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="SpanGeneralNonSpecific" class="form_label">General non-specific thoughts of wanting 
                                                    to end one’s life/commit suicide, <i>"I’ve thought about killing myself"</i>
                                                        without general thoughts of ways to kill oneself/associated methods, intent, or plan. </span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="SpanHaveyouactuallyhadAny" class="form_label"><b><i><u>Have you actually had any thoughts of killing yourself? </u></i></b></span>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 8%; padding-top: 2px; border-style: solid; border-width: 1px; border-color: #dce5ea; text-align: center;">
                                        <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentCSSRSAdultScreeners_SuicidalThoughts"
                                            AppendDataBoundItems="true" runat="server" Category="XCSSRSYESNO" CssClass="form_dropdown" TabIndex="2" onchange="HideandShowSections()">
                                        </DropDownGlobalCodes:DropDownGlobalCodes>
                                    </td>
                                </tr>
                                <tr class="HideSectionforNo" id="STM">
                                    <td colspan="4" style="width: 92%; padding-left: 3px; padding-top: 2px; border-style: solid; border-width: 1px; border-color: #dce5ea;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td>
                                                    <span id="SpanActiveSuicidalThoughts" class="form_label"><b>3.  Suicidal Thoughts with Method (without Specific Plan or Intent to Act)</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="SpanPersonEndorsesthoughts" class="form_label">Person endorses thoughts of suicide and has thought of a least one method 
                                                    during the assessment period. This is different than a specific plan with time, place or method details worked out. 
                                                    <i>"I thought about taking an overdose but I never made a specific plan as to when where or how I would actually do it….and I 
                                                    would never go through with it."</i> </span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="SpanHaveyoubeenthinking" class="form_label"><b><i><u>Have you been thinking about how you might kill yourself? </u></i></b></span>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 8%; padding-top: 2px; border-style: solid; border-width: 1px; border-color: #dce5ea; text-align: center;">
                                        <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentCSSRSAdultScreeners_SuicidalThoughtsWithMethods"
                                            AppendDataBoundItems="true" runat="server" Category="XCSSRSYESNO" CssClass="form_dropdown" TabIndex="3" >
                                        </DropDownGlobalCodes:DropDownGlobalCodes>
                                    </td>
                                </tr>
                                <tr class="HideSectionforNo" id="SIA">
                                    <td colspan="4" style="width: 92%; padding-left: 3px; padding-top: 2px; border-style: solid; border-width: 1px; border-color: #dce5ea;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td>
                                                    <span id="SpanSuicidalintent" class="form_label"><b>4.  Suicidal Intent (without Specific Plan)</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="Span1" class="form_label">Active suicidal thoughts of killing oneself and patient reports having <u>some intent to act on such thoughts,</u> as opposed to <i>"I have the thoughts but I definitely will not do anything about them."</i></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="SpanHaveyouhadthese" class="form_label"><b><i><u>Have you had these thoughts and had some intention of acting on them? </u></i></b></span>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 8%; padding-top: 2px; border-style: solid; border-width: 1px; border-color: #dce5ea; text-align: center;">
                                        <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentCSSRSAdultScreeners_SuicidalIntentWithoutSpecificPlan"
                                            AppendDataBoundItems="true" runat="server" Category="XCSSRSYESNO" CssClass="form_dropdown" TabIndex="4">
                                        </DropDownGlobalCodes:DropDownGlobalCodes>
                                    </td>
                                </tr>
                                <tr class="HideSectionforNo" id="SISP">
                                    <td colspan="4" style="width: 92%; padding-left: 3px; padding-top: 2px; border-style: solid; border-width: 1px; border-color: #dce5ea;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td>
                                                    <span id="SpanSuicidalIntentwith" class="form_label"><b>5.  Suicidal Intent with Specific Plan </b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="Spanthoughtsofkilling" class="form_label">Thoughts of killing oneself with details of plan fully or partially worked out and person has some intent to carry it out. </span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="SpanHaveyoustartedtowork" class="form_label"><b><i><u>Have you started to work out or worked out the details of how to kill yourself? Do you intend to carry out this plan? </u></i></b></span>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 8%; padding-top: 2px; border-style: solid; border-width: 1px; border-color: #dce5ea; text-align: center;">
                                        <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentCSSRSAdultScreeners_SuicidalIntentWithSpecificPlan"
                                            AppendDataBoundItems="true" runat="server" Category="XCSSRSYESNO" CssClass="form_dropdown" TabIndex="5">
                                        </DropDownGlobalCodes:DropDownGlobalCodes>
                                    </td>
                                </tr>
                                <tr id="SB">
                                    <td colspan="4" style="width: 92%; padding-left: 3px; padding-top: 2px; border-style: solid; border-width: 1px; border-color: #dce5ea;">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td>
                                                    <span id="SpanSuicideBehaviour" class="form_label"><b>6.  Suicide Behavior Question</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="SpanHaveyoueverdone" class="form_label"><b><u><i>Have you ever done anything, started to do anything, or prepared to do anything to end your life?</i></u></b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="SpanCollectedPills" class="form_label">Examples: Collected pills, obtained a gun, gave away valuables, wrote a will or suicide note, took out pills but didn’t swallow any, held a gun but changed your mind or it was grabbed from your hand, went to the roof but didn’t jump; or actually took pills, tried to shoot yourself, cut yourself, tried to hang yourself, etc.</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="Spanhowlongago" class="form_label"><b>If YES, ask: <i><u>How long ago did you do any of these?</u></i> </b></span>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 8%; padding-top: 2px; border-style: solid; border-width: 1px; border-color: #dce5ea; text-align: center;">
                                        <table>
                                            <tr>
                                                <td style="width: 8%; padding-top: 2px; text-align: center;">
                                                    <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentCSSRSAdultScreeners_HowLongAgoSuicidalBehavior"
                                                        AppendDataBoundItems="true" runat="server" Category="XCSSRSYESNO" CssClass="form_dropdown" TabIndex="6">
                                                    </DropDownGlobalCodes:DropDownGlobalCodes>
                                                </td>
                                            </tr>
                                            <tr style="height: 36px;"></tr>
                                            <tr>
                                                <td style="width: 8%; padding-top: 2px; text-align: center;">
                                                    <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentCSSRSAdultScreeners_SuicidalBehaviorQuestion"
                                                        AppendDataBoundItems="true" runat="server" Category="XSUICIDEBEHPERIOD" CssClass="form_dropdown" TabIndex="7">
                                                    </DropDownGlobalCodes:DropDownGlobalCodes>
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