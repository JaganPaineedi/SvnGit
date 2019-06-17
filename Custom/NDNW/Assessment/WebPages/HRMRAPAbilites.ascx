<%@ Control Language="C#" AutoEventWireup="true" CodeFile="HRMRAPAbilites.ascx.cs"
    Inherits="SHS.SmartCare.ActivityPages_Client_Detail_Assessment_HRMRAPAbilites" %>
<% if (HttpContext.Current == null)
   { %>
<link href="../../../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet"
    type="text/css" />
<%} %>
<%@ Register Src="~/Custom/Assessment/WebPages/HRMRAPQuestions.ascx"
    TagName="UCHRMRAPQuestions" TagPrefix="UserControl" %>
<div style="margin: 0px,0px,0px,0px; overflow-x: hidden">
    <table border="0" cellpadding="0" cellspacing="0" class="DocumentScreen">
        <tr>
            <td>
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                        <td>
                        </td>
                    </tr>
                    <tr>
                        <td class="padding_label1">
                            <table border="0" cellpadding="0" cellspacing="0" width="99%">
                                <tr>
                                    <td class="height2">
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                                        <tr>
                                                            <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                                Current Abilities
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
                                                                <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                                                    <tr>
                                                                        <td class="height2">
                                                                            &nbsp;
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <span class="form_label">With this level of support...</span>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height2">
                                                                            &nbsp;
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <%-- Add Dynamic Section here--%>
                                                                            <UserControl:UCHRMRAPQuestions ID="UserControl_HRMRAPQuestions" runat="server" />
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
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td class="height1" colspan="2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="LabelText" align="left" nowrap='nowrap'>
                                                    Current Abilities – Level of intensity:
                                                </td>
                                                <td align="left" width="100%">
                                                    <span type="label" class="form_label" id="label_CustomHRMAssessments_RapCaDomainIntensity">
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
                            <table id="TableCurrentAbilitiesSummary" border="0" cellpadding="0" cellspacing="0"
                                width="99%" group="CurrentAbilitiesSummary">
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                    Current Abilities Summary
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
                                                <td class="height1">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr class="RadioText">
                                                <td class="padding_label1">
                                                    <span class="form_label">Please address all of the above items that have been identified
                                                        as areas of concern. Including gross/fine motor function, sensory/perceptual motor</span>
                                                </td>
                                            </tr>
                                            <tr class="RadioText">
                                                <td class="padding_label1">
                                                    <span class="form_label">function, communicative functioning/expressive and receptive,
                                                        cognitive function, safety/mobility in home/community. </span><span id="Group_CurrentAbilitiesSummary">
                                                        </span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height1">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr class="RadioText">
                                                <td class="padding_label1">
                                                    <textarea class="form_textareaWithoutWidth" id="TextArea_CustomHRMAssessments_RapCaDomainComment"
                                                        name="TextArea_CustomHRMAssessments_RapCaDomainComment" rows="5" spellcheck="True"
                                                        cols="156" onblur="UpdateNeedsXML(133,'RapAbilities')"></textarea>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="padding_label1">
                                                    <div id="DivLevelAbilities">
                                                        <table id="CurrentAbilitiesSummaryNeedList" NotGroup="CurrentAbilitiesSummary">
                                                            <tr class="checkbox_container">
                                                                <td>
                                                                    <input type="checkbox" id="Checkbox_CustomHRMAssessments_RapCaDomainNeedsList" name="Checkbox_CustomHRMAssessments_RapCaDomainNeedsList"
                                                                        onclick="HRMNeedList('133',this,'RapAbilities','AbilitiesSummary')" />
                                                                    <label for="Checkbox_CustomHRMAssessments_RapCaDomainNeedsList">
                                                                        Add Current Abilities to Needs List</label>
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
