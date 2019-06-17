<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CSSRSAdultSinceLT.ascx.cs" Inherits="SHS.SmartCare.Custom_Assessment_WebPages_CSSRSAdultSinceLT" %>
<% if (HttpContext.Current == null)
   { %>
<link href="../../../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet"
    type="text/css" />
<%} %>
 <%@ Register Assembly="Streamline.DotNetDropDowns" Namespace="Streamline.DotNetDropDowns"
        TagPrefix="cc1" %>
<style type="text/css">
    .auto-style3
    {
        font-weight: bold;
        text-decoration: underline;
        font-style: italic;
    }

    .auto-style5
    {
        width: 11%;
        font-weight: bold;
        text-align: center;
    }

    .styel6
    {
        border: 0px solid #dce5ea;
        padding-left: 5px;
        vertical-align: top;
    }
    .auto-style6
    {
        border: 0px solid #dce5ea;
        padding-left: 5px;
        vertical-align: top;
        font-weight: bold;
        font-style: italic;
        text-decoration: underline;
    }
</style>
<div style="overflow-x: hidden" >
<table cellpadding="0" cellspacing="0" border="0"  style="width: 833px" class="CrossBrowserAutoFixChrome_width_847px">
    <tr>
        <td class="height1">&nbsp;</td>
    </tr>
    <tr>
        <td>
            <table cellspacing="0" cellpadding="0" border="0" width="100%">
                <tr>
                    <td class="toplt_curve" style="width: 6px"></td>
                    <td class="top_brd" style="width: 100%"></td>
                    <td class="toprt_curve" style="width: 6px"></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class="content_tab_bg">
            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                <tr>
                    <td colspan="6" style="padding-left: 5px; background-color: #dce5ea; height: 20px;">
                        <span id="SpanSuicidalIdeationBehavior0" title="Suicidal Ideation/ Behavior">SUICIDAL IDEATION DEFINITIONS AND PROMPTS</span>
                    </td>
                </tr>
                <tr>
                    <td colspan="4" class="styel6" style="width: 80%; border: 1px solid #dce5ea;">
                        <i>Ask questions 1 and 2. if YES to 2, ask questions 3,4,5, and 6. If NO to 2, go directly to question 6.<br />
                            Ask the questions that are bolded and underlined.</i></td>
                    <td style="border: 1px solid #dce5ea;" class="auto-style5">Since Last Visit</td>
                </tr>
                <tr>
                    <td></td>
                </tr>
                <tr>
                    <td colspan="4" style="border: 1px solid #dce5ea; padding-left: 3px; padding-bottom: 2px;" class="auto-style2">
                        <table style="width: 100%; height: 47px;">
                            <tr>
                                <td class="styel6">
                                    <span><b>1. Wish to be dead</b></span></td>
                            </tr>
                            <tr>
                                <td class="styel6">Person endorses thoughts about a wish to be dead or not alive anymore, or wish to fall asleep and not wake up.
                                </td>
                            </tr>
                            <tr>
                                <td></td>
                            </tr>

                            <tr>
                                <td class="styel6">
                                    <span class="auto-style3">Have you wished you were dead or wished you could go to sleep and not wake up?
                                                        of killing yourself?</span>
                                </td>
                            </tr>
                           

                        </table>
                    </td>

                    <td style="width: 8%; padding-top: 2px; border-style: solid; border-width: 1px; border-color: #dce5ea; text-align: center;">
                        <asp:DropDownList ID="DropDownList_CustomDocumentCSSRSAdultSinceLastVisits_WishToBeDead" runat="server"
                            EnableViewState="false" CssClass="form_dropdown" Width="50px" Style="margin-top:25px;margin-left:5px">
                        </asp:DropDownList>
                    </td>


                </tr>
                <tr>
                    <td colspan="4" style="border: 1px solid #dce5ea; padding-left: 3px; padding-top: 2px;" class="auto-style2">
                        <table style="width: 100%; height: 66px;">
                           
                            <tr>
                                <td class="styel6">
                                    <span id="SpanNonSpecific" class="form_label"><b>2. </b></span><b>Suicidal Thoughts&nbsp;</b>
                                </td>
                            </tr>
                            <tr>
                                <td class="styel6">General non-specific thoughts of wanting to end one&#39;s life/commit suicide, &quot;I&#39;ve thought about killing myself&quot; without general thoughts of ways to kill oneself/associated methods, intent, or plan.</td>
                            </tr>
                            <tr>
                                <td></td>
                            </tr>
                            <tr>
                                <td class="styel6">
                                    <span id="SpanHaveyouactuallyhad" class="auto-style3">Have you actually had any thoughts
                                                        of killing yourself?</span>
                                </td>
                            </tr>
                          

                        </table>
                    </td>

                    <td style="width: 8%; padding-top: 2px; border-style: solid; border-width: 1px; border-color: #dce5ea; text-align: center;">
                        <asp:DropDownList ID="DropDownList_CustomDocumentCSSRSAdultSinceLastVisits_SuicidalThoughts" runat="server"
                            EnableViewState="false" CssClass="form_dropdown" Width="50px" Style="margin-top:40px;margin-left:5px" onchange="HideandShow()">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr id="STM">
                    <td colspan="4" style="border: 1px solid #dce5ea; padding-left: 3px; padding-top: 2px;" class="auto-style2">
                        <table style="width: 100%;">
                            <tr>
                                <td class="styel6">
                                    <span><b>3.Suicidal Thoughts with Method (without Specific Plan or Intent to Act) </b></span>
                                </td>
                            </tr>
                            <tr>
                                <td class="styel6">Person endorses thoughts of suicide and has thought of a least one method during the assessment period. This is different than a specific plan with time, place or method details worked out. &quot;I thought about taking an overdose but I never made a specific plan as to when where or how I would actually do it....and I would never go through with it.&quot;
                                </td>
                            </tr>
                            <tr>
                                <td></td>
                            </tr>
                            <tr>
                                <td class="styel6">
                                    <i><b style="text-decoration: underline">Have you been thinking about how you might kill yourself?
                                    </b></i>

                                </td>
                            </tr>
                            <tr>
                                <td></td>
                            </tr>

                        </table>
                    </td>

                    <td style="width: 8%; padding-top: 2px; border-style: solid; border-width: 1px; border-color: #dce5ea; text-align: center;">
                        <asp:DropDownList ID="DropDownList_CustomDocumentCSSRSAdultSinceLastVisits_SuicidalThoughtsWithMethods"
                            runat="server" EnableViewState="false" CssClass="form_dropdown" Width="50px" Style="margin-top:50px;margin-left:5px">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr id="SIA">
                    <td colspan="4" style="border: 1px solid #dce5ea; padding-left: 3px; padding-top: 2px;" class="auto-style2">
                        <table style="width: 100%;">
                            <tr>
                                <td class="styel6">
                                    <span><b>4. Suicidal Intent (without Specific Plan) </b></span>
                                </td>
                            </tr>
                            <tr>
                                <td class="styel6">Active suicidal thoughts of killing oneself and patient reports having some intent to act on such thoughts as opposed to &quot;( hove the thoughts but I definitely will not do anything about them.&quot;
                                </td>
                            </tr>
                            <tr>
                                <td></td>
                            </tr>
                            <tr>
                                <td class="styel6">
                                    <span class="auto-style3">Have you had these thoughts
                                                        and had some intention of acting on them?</span>
                                </td>
                            </tr>
                           

                        </table>
                    </td>

                    <td style="width: 8%; padding-top: 2px; border-style: solid; border-width: 1px; border-bottom-width: 0px; border-color: #dce5ea; text-align: center;">
                        <asp:DropDownList ID="DropDownList_CustomDocumentCSSRSAdultSinceLastVisits_SuicidalIntentWithoutSpecificPlan" runat="server"
                            EnableViewState="false" CssClass="form_dropdown" Width="50px" Style="margin-top:40px;margin-left:5px">
                        </asp:DropDownList>
                    </td>
                </tr>

                <tr id="SISP">
                    <td colspan="4" style="border: 1px solid #dce5ea; padding-left: 3px; padding-top: 2px;" class="auto-style2">
                        <table style="width: 100%;">
                            <tr>
                                <td class="styel6">
                                    <span><b>5. </b></span><b>Suicidal Intent with Specific Plan
                                    </b>
                                </td>
                            </tr>
                            <tr>
                                <td class="styel6">Thoughts of killing oneself with details of plan fully or partially worked out and person has some intent to carry it out.
                                </td>
                            </tr>
                            <tr>
                                <td></td>
                            </tr>
                            <tr>
                                <td class="styel6">
                                    <span class="auto-style3">Have you started to work
                                                        out or worked out the details of how to kill yourself? Do you intend to carry out
                                                        this plan?</span><i> </i>

                                </td>
                            </tr>
                           

                        </table>
                    </td>

                    <td style="width: 8%; padding-top: 2px; border-style: solid; border-width: 1px; border-color: #dce5ea; text-align: center;">
                        <asp:DropDownList ID="DropDownList_CustomDocumentCSSRSAdultSinceLastVisits_SuicidalIntentWithSpecificPlan" runat="server"
                            EnableViewState="false" CssClass="form_dropdown" Width="50px" Style="margin-top:25px;margin-left:5px">
                        </asp:DropDownList>
                    </td>
                </tr>

                <tr id="SB">
                    <td colspan="4" style="border: 1px solid #dce5ea; padding-left: 3px; padding-top: 2px;" class="auto-style2">
                        <table style="width: 100%;">
                            <tr>
                                <td class="styel6">
                                    <b>6</b><span><b>. </b></span><b>Suicide Behavior
                                    </b>
                                </td>
                            </tr>
                            <tr>
                                <td class="auto-style6">Have you done anything, started to do anything, or prepared to do anything to end your life?</td>

                            </tr>
                            <tr>
                                <td></td>
                            </tr>
                            <tr>
                                <td class="styel6">Examples: Collected pills, obtained a gun, gave away valuables, wrote a will or suicide note, took out pills but didn&#39;t swallow any, held a gun but changed your mind or it was grabbed from your hand, went to the roof but didn&#39;t jump; or actually took pills, tried to shoot yourself, cut yourself, tried to hang yourself, etc.
                                </td>
                            </tr>
                           

                        </table>
                    </td>

                    <td style="width: 8%; padding-top: 2px; border-style: solid; border-width: 1px; border-color: #dce5ea;">
                        <asp:DropDownList ID="DropDownList_CustomDocumentCSSRSAdultSinceLastVisits_SuicidalBehaviorQuestion" runat="server"
                            EnableViewState="false" CssClass="form_dropdown" Width="50px" Style="margin-left:26px">
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
    </div>