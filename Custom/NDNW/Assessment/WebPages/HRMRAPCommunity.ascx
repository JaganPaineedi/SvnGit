<%@ Control Language="C#" AutoEventWireup="true" CodeFile="HRMRAPCommunity.ascx.cs"
    Inherits="SHS.SmartCare.ActivityPages_Client_Detail_Assessment_HRMRAPCommunity" %>
<% if (HttpContext.Current == null)
   { %>
<link href="../../../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet"
    type="text/css" />
<%} %>
<%@ Register Src="~/Custom/Assessment/WebPages/HRMRAPQuestions.ascx"
    TagName="UCHRMRAPQuestions" TagPrefix="UserControl" %>
<div style="margin: 0px,0px,0px,0px; overflow-x: hidden">
    <table cellpadding="0" cellspacing="0" class="DocumentScreen">
        <tr>
            <td>
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                        <td class="padding_label1">
                            <table border="0" cellpadding="0" cellspacing="0" width="99%">
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                    Instructions
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
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td class="padding_label1">
                                                    <span class="form_label">Use the scale below to determine how often or how well daily
                                                        living activities were performed or managed independently, during the last 30 days.</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="padding_label1">
                                                    <span class="form_label">Enter N/A if the activity was not assessed due to inadequate
                                                        information.</span>
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
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="padding_label1">
                            <table border="0" cellpadding="0" cellspacing="0" width="99%">
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                    Community Inclusion
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
                                                <td class="padding_label1">
                                                    <span class="form_label">With this level of support...</span>
                                                </td>
                                            </tr>
                                            <tr class="height2">
                                                <td>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="padding_label1">
                                                    <UserControl:UCHRMRAPQuestions ID="UserControl_HRMRAPQuestions" runat="server" />
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
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="padding_label1">
                            <table border="0" cellpadding="0" cellspacing="0" width="99%">
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td class="padding_label1">
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td class="LabelText" align="left" nowrap='nowrap'>
                                                    Community Inclusion – Level of intensity:
                                                </td>
                                                <td align="left" width="100%">
                                                    <span type="label" class="form_label" id="label_CustomHRMAssessments_RapCiDomainIntensity">
                                                    </span>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td class="padding_label1">
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="padding_label1">
                            <table id="TableCommunityInclusionSummary" border="0" cellpadding="0" cellspacing="0"
                                width="99%" group="CommunityInclusionSummary">
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                    Community Inclusion Summary
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
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td class="padding_label1">
                                                    <table border="0" cellpadding="0" cellspacing="0" width="97%">
                                                        <tr>
                                                            <td class="height2">
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr class="RadioText">
                                                <td class="padding_label1">
                                                    <span class="form_label">Please address all of the above items that have been identified
                                                        as areas of concern and describe overall community functioning. Be sure to address</span>
                                                </td>
                                            </tr>
                                            <tr class="RadioText">
                                                <td class="padding_label1">
                                                    <span class="form_label">court/legal issues , employment history/current status, and
                                                        educational history/current status. Indicate last grade completed, relevent school</span>
                                                </td>
                                            </tr>
                                            <tr class="RadioText">
                                                <td class="padding_label1">
                                                    <span class="form_label">functioning etc.</span> <span id="Group_CommunityInclusionSummary">
                                                    </span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="7" class="height1">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr class="RadioText">
                                                <td class="padding_label1">
                                                    <textarea class="form_textareaWithoutWidth" id="TextArea_CustomHRMAssessments_RapCiDomainComment"
                                                        name="TextArea_CustomHRMAssessments_RapCiDomainComment" rows="5" spellcheck="True"
                                                        cols="155" onblur="UpdateNeedsXML(131,'CommunityInclusionSummary')"></textarea>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="padding_label1">
                                                    <div id="DivLevelCommunity">
                                                        <table id="CommunityInclusionSummaryNeedList" NotGroup="CommunityInclusionSummary">
                                                            <tr>
                                                                <td class="checkbox_container">
                                                                    <input type="checkbox" id="Checkbox_CustomHRMAssessments_RapCiDomainNeedsList" name="Checkbox_CustomHRMAssessments_RapCiDomainNeedsList"
                                                                        onclick="HRMNeedList('131',this,'RapCommunity','CommunityInclusionSummary')" />
                                                                    <label for="Checkbox_CustomHRMAssessments_RapCiDomainNeedsList">
                                                                        Add Community Inclusion to Needs List</label>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>
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
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</div>
