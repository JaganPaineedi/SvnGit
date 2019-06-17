<%@ Control Language="C#" AutoEventWireup="true" CodeFile="HarborTPGeneral.ascx.cs"
    Inherits="SHS.SmartCare.ActivityPages_Client_Detail_HarborTreatmentPlan_HarborTPGeneral" %>
<% if (HttpContext.Current == null)
   { %>
<link href="../../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet"
    type="text/css" />
<%} %>

<script type="text/javascript" language="javascript" src="<%=RelativePath%>Custom/Scripts/HarborTreatmetPlan.js"></script>

<div style="overflow: hidden;">
    <table border="0" cellpadding="0" cellspacing="0" id="TableHRMTPGeneralPage" name="TableHRMTPGeneralPage" width="100%">
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
                                <tr id="tdReasonForUpdate" updateReason="updateReason">
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
                                            <tr class="content_tab_bg" style="padding-left: 8px; padding-right: 8px;" >
                                                <td >
                                                    <table border="0" cellpadding="0" cellspacing="0" width="100%" height="100px">
                                                        <tr>
                                                            <td class="padding_Label" align="center" width="100%" style="border-right: #a8a8a8 1px solid;border-left: #a8a8a8 1px solid" >
                                                                <textarea id="TextArea_CustomTreatmentPlans_ReasonForUpdate" name="TextArea_CustomTreatmentPlans_ReasonForUpdate"
                                                                    rows="5" cols="50" class="form_textarea"></textarea>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr  updateReason="updateReason">
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
                                <tr updateReason="updateReason">
                                    <td class="height4">
                                    </td>
                                </tr>
                                <tr updateReason="updateReason">
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
                                    <td class="content_tab_bg" style="padding-left: 8px; padding-right: 8px;">
                                        <table style="height: 100px" border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr>
                                                <td class="padding_Label" align="center">
                                                    <textarea name="TextArea_CustomTreatmentPlans_CurrentDiagnosis" id="TextArea_CustomTreatmentPlans_CurrentDiagnosis" rows="5"
                                                        cols="10"  class="form_textarea" tabindex="8" disabled="disabled"
                                                        datatype="String"></textarea>
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
                                        <table style="height: 100px" border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr>
                                                <td class="padding_Label" align="center">
                                                
                                                <div class="form_textarea">
                                                    <textarea name="TextArea_CustomTreatmentPlans_DischargeTransitionCriteria" id="TextArea_CustomTreatmentPlans_DischargeTransitionCriteria" rows="5"
                                                        cols="10"  class="form_textarea" disabled="disabled"
                                                        datatype="String"></textarea>
                                                        <a onclick="OpenModelDialogueQuickTxPlan('','');" style="text-decoration:underline;cursor:hand;color:Black;font-size:11px;" >Use Quick Transition</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a onclick="OpenModelDialogueQuickTxPlan('','');" style=' text-decoration:underline;cursor:hand;color:Black;font-size:11px;'> Add This Quick Transition</a>


</div>                                                </td>
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
    </table>
    <asp:HiddenField ID="HiddenFieldRelativePath" runat="server" />
</div>

<script language="javascript" type="text/javascript">
    function EnableDisableTextBox() {

        var radioButtonPlanOfAddendum = $("input[type='radio']:checked");
        alert(radioButtonPlanOfAddendum);
    }
</script>

 