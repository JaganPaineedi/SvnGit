<%@ Control Language="C#" AutoEventWireup="true" CodeFile="InitialTxPlan.ascx.cs" 
    Inherits="SHS.SmartCare.Custom_WebPages_InitialTxPlan" %>


<link href="<%=RelativePath %>App_Themes/Styles/calendar-blue2.css" rel="stylesheet"
    type="text/css" />

<script src="<%=RelativePath %>JScripts/SystemScripts/CalCode.js" type="text/javascript"></script>

<script type="text/javascript" language="javascript" src="<%=RelativePath%>Custom/Scripts/DiagnosticTreatmentPlan.js"></script>

<script src="<%=RelativePath%>JScripts/ApplicationScripts/jquery.tmpl.min.js" type="text/javascript"></script>

<script language="javascript" type="text/javascript" src="<%=RelativePath%>JScripts/ApplicationScripts/GeneralFormFunctions.js"></script>

<% if (HttpContext.Current == null)
   { %>
<link href="../../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet"
    type="text/css" />
<%} %>
<style>
    .ellipsis
    {
        max-width: 250px;
        text-overflow: ellipsis;
    }
</style>
<table id="TableMain" cellpadding="0" cellspacing="0" border="0" width="830px">
    <tr>
        <td>
            <table border="0" cellpadding="0" cellspacing="0" id="TableHRMTPGeneralPage" width="830px">
                <tr>
                    <td valign="top">
                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                            <tr>
                                <td>
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td class="height1">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height1">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height1">
                                            </td>
                                        </tr>
                                        <tr id="tdReasonForUpdate" updatereason="updateReason">
                                            <td>
                                                <table cellspacing="0" cellpadding="0" border="0" style="width: 100%">
                                                    <tr>
                                                        <td>
                                                            <table cellspacing="0" cellpadding="0" border="0">
                                                                <tr>
                                                                    <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                                        Reason for Update
                                                                    </td>
                                                                    <td width="17" style="overflow: hidden">
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
                                                    <tr class="content_tab_bg" style="padding-left: 8px; padding-right: 8px;">
                                                        <td>
                                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                <tr>
                                                                    <td class="padding_Label" align="center" width="100%" style="border-right: #a8a8a8 1px solid;
                                                                        border-left: #a8a8a8 1px solid">
                                                                        <textarea id="TextArea_CustomTreatmentPlans_ReasonForUpdate" name="TextArea_CustomTreatmentPlans_ReasonForUpdate"
                                                                            rows="5" cols="158" class="form_textareaWithoutWidth" spellcheck="True"></textarea>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr updatereason="updateReason">
                                            <td>
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
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
                                        <tr updatereason="updateReason">
                                            <td class="height4">
                                            </td>
                                        </tr>
                                        <tr updatereason="updateReason">
                                            <td class="height4">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr>
                                                        <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                            Diagnosis
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
                                                <table border="0" cellspacing="0" cellpadding="0">
                                                    <tr>
                                                        <td align="left" style="width: 800px; padding-left: 10px;">
                                                            <div id="divPreviousDiagnosis" style="border: solid 1px #b1b1b1; background-color: #f5f5f5;
                                                                overflow-y: scroll; min-height: 100px; width: 98%">
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
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
                                <td class="height4">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                Client Strengths
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
                                <td class="content_tab_bg" style="padding-left: 8px; padding-right: 8px;">
                                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                        <tr>
                                            <td class="padding_Label" align="center">
                                                <textarea name="TextArea_CustomTreatmentPlans_ClientStrengths" id="TextArea_CustomTreatmentPlans_ClientStrengths"
                                                    rows="5" cols="158" class="form_textareaWithoutWidth" datatype="String" spellcheck="True"></textarea>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
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
                                <td class="height4">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                Discharge/Transition Criteria
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
                                <td class="content_tab_bg" style="padding-left: 8px; padding-right: 8px;">
                                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                        <tr>
                                            <td class="padding_Label" align="center">
                                                <%-- <div class="form_textarea">--%>
                                                <textarea name="TextArea_CustomTreatmentPlans_DischargeTransitionCriteria" id="TextArea_CustomTreatmentPlans_DischargeTransitionCriteria"
                                                    rows="5" cols="158" class="form_textareaWithoutWidth" datatype="String" spellcheck="True"></textarea>
                                                <%--&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a
                                                        onclick="OpenModelDialogueAddQuickTransitions('CustomTPGlobalQuickTransitionPlans','TextArea_CustomTreatmentPlans_DischargeTransitionCriteria');"
                                                        style='text-decoration: underline; cursor: hand; color: Black; font-size: 11px;'>
                                                        Add This Quick Transition</a>--%>
                                                <%--</div>--%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="padding_Label" align="center">
                                                <a onclick="OpenModelDialogueQuickTransitonPlans('TextArea_CustomTreatmentPlans_DischargeTransitionCriteria');"
                                                    style="text-decoration: underline; cursor: hand; color: Black; font-size: 11px;">
                                                    Use Quick Transition</a>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
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
                                <td class="height4">
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
            <table style="width: 100%;" cellpadding="0" cellspacing="0" border="0">
                <%--<tr>
                    <td>
                        <table  border="0" cellspacing="0" cellpadding="0" style="width: 800px;">
                            <tr>
                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                    Goals/Objectives/Services
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
                </tr>--%>
                <tr>
                    <td>
                        <asp:Panel ID="PanelTxPlanMain" runat="server" CssClass="DocumentScreen" ParentChildControls='True'
                            Style="width: 100%;">
                        </asp:Panel>
                        <asp:HiddenField ID="HiddenFiedNeedCount" runat="server" />
                        <asp:HiddenField ID="HiddenFieldRelativePath" runat="server" />
                    </td>
                </tr>
                <%--<tr>
                    <td>
                        <table  border="0" cellspacing="0" cellpadding="0" style=width:800px;>
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
                </tr>--%>
            </table>
        </td>
    </tr>
    <tr>
        <td style="height: 15px;" colspan="3">
        </td>
    </tr>
    <tr>
        <td colspan="3">
            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                <tr>
                    <td width="1%">
                        &nbsp;
                    </td>
                    <td align="left">
                        <input id="CheckBox_CustomTreatmentPlans_ClientParticipatedAndIsInAgreement" class="form_checkbox"
                            onclick="EnableDisableCommentTextArea(this);" type="checkbox" name="CheckBox_CustomTreatmentPlans_ClientParticipatedAndIsInAgreement" />
                        <label for="CheckBox_CustomTreatmentPlans_ClientParticipatedAndIsInAgreement">
                            Client/guardian has participated and is in agreement with this plan.</label>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td style="height: 15px;" colspan="3">
        </td>
    </tr>
    <tr>
        <td colspan="3">
            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                <tr>
                    <td width="1%">
                        &nbsp;
                    </td>
                    <td align="left">
                        <input id="CheckBox_CustomTreatmentPlans_ClientParticpatedPreviousDocumentation"
                            class="form_checkbox" onclick="EnableDisableCommentTextArea(this);" type="checkbox"
                            name="CheckBox_CustomTreatmentPlans_ClientParticpatedPreviousDocumentation" />
                        <label for="CheckBox_CustomTreatmentPlans_ClientParticpatedPreviousDocumentation">
                            Per previous documentation, client/guardian has participated and is in agreement
                            with this plan.
                        </label>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td style="height: 15px;" colspan="3">
        </td>
    </tr>
    <tr>
        <td colspan="3">
            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                <tr>
                    <td width="1%">
                        &nbsp;
                    </td>
                    <td align="left">
                        <input id="CheckBox_CustomTreatmentPlans_ClientDidNotParticipate" class="form_checkbox"
                            onclick="EnableDisableCommentTextArea(this);" type="checkbox" name="CheckBox_CustomTreatmentPlans_ClientDidNotParticipate" />
                        <label for="CheckBox_CustomTreatmentPlans_ClientDidNotParticipate">
                            Client/guardian did not participate in the development of this plan.</label>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td style="height: 15px;" colspan="3">
        </td>
    </tr>
    <tr>
        <td colspan="3">
            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                <tr>
                    <td width="5%">
                        &nbsp;
                    </td>
                    <td width="10%">
                        Comment :
                    </td>
                    <td align="left">
                        <textarea id="TextArea_CustomTreatmentPlans_ClientDidNotParticpateComment" class="form_textareaWithoutWidth"
                            rows="4" cols="125" readonly="readOnly" name="TextArea_CustomTreatmentPlans_ClientDidNotParticpateComment"
                            spellcheck="True"></textarea>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
<asp:Panel ID="PanelLoadUC" runat="server">
</asp:Panel>
