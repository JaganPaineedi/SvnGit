<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CANSGeneral.ascx.cs" Inherits="SHS.SmartCare.CANSGeneral" %>
<%@ Register Assembly="Streamline.DotNetDropDownGlobalCodes" Namespace="Streamline.DotNetDropDownGlobalCodes"
    TagPrefix="DropDownGlobalCodes" %>
<%@ Register Assembly="Streamline.DotNetDropDowns" Namespace="Streamline.DotNetDropDowns"
    TagPrefix="cc2" %>
<style type="text/css">
    .style1
    {
        height: 21px;
    }
    .style2
    {
        width: 30px;
        height: 21px;
    }
    .style3
    {
        width: 25px;
        height: 21px;
    }
</style>
<div class="DocumentScreen" style="padding-top: 5px" id="divscreenid">
    <table cellpadding="0" cellspacing="0" border="0" width="100%" id="GeneralTabTable">
        <tr>
            <td colspan="4">
                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                    <tr>
                        <%-- <td class="content_tab_left" align="left" nowrap='nowrap'>
                            <span id="Span4">General</span>
                        </td>--%>
                        <td width="17px">
                            <img style="vertical-align: top;" height="26" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_left1.gif" />
                        </td>
                        <td class="content_tab_top" width="100%">
                        </td>
                        <td width="7">
                            <img style="vertical-align: top;" height="26" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                        </td>
                        <%--<td width="7">
                            <img style="vertical-align: top;" height="26" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_left.gif" />
                        </td>--%>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td>
                <table width="100%" class="content_tab_bg">
                    <tr>
                        <td style="padding-left: 10px; width: 100px;">
                            Document Type:
                        </td>
                        <td>
                            <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentCANSGenerals_DocumentType"
                                Width="150px" AppendDataBoundItems="true" runat="server" onchange="" TabIndex="0"
                                CssClass="form_dropdowns" Category="XCANSDocType">
                            </DropDownGlobalCodes:DropDownGlobalCodes>
                            <%--<input type="text" class="form_textbox" id="TextBox_CustomDocumentParentGuardians_ClientContact" name="TextBox_CustomDocumentParentGuardians_ClientContact" runat="server" style="visibility:hidden;">
                                                    </input>--%>
                        </td>
                        <td style="width: 250px">
                        </td>
                        <td>
                            <span>Living Situation: </span><span id="Span_CustomDocumentCANSGenerals_LivingArrangement">
                            </span>
                        </td>
                    </tr>
                    <tr style="height: 10px">
                    </tr>
                    <tr>
                        <td colspan="4">
                            <table cellpadding="0" cellspacing="0" border="0" width="99%">
                                <tr>
                                    <td>
                                        <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                    <span id="Span1">Problem Presentation</span>
                                                </td>
                                                <td width="17px">
                                                    <img style="vertical-align: top;" height="26" width="17px" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                                                </td>
                                                <td class="content_tab_top" width="99%">
                                                </td>
                                                <td width="7">
                                                    <img style="vertical-align: top;" height="26" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="content_tab_bg" style="padding-right: 8px" id="firsttd">
                                        <table cellpadding="0" cellspacing="0" border="0" style="padding-left: 10px" width="100%"
                                            id="table1">
                                            <tr>
                                                <td colspan="15" align="center">
                                                    <span id="Spanchart"><b>Scoring chart: 0= No Evidence of Problems, 1=History, Mild,
                                                        2=Moderate, 3=Severe</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2" colspan="15">
                                                </td>
                                            </tr>
                                            <tr style="height: 10px">
                                            </tr>
                                            <tr>
                                                <td style="width: 110px;">
                                                </td>
                                                <td style="width: 30px;">
                                                    <span><b>N/A</b></span>
                                                </td>
                                                <td style="width: 25px;">
                                                    <span class="form_label"><b>U</b></span>
                                                </td>
                                                <td style="width: 25px;">
                                                    <span class="form_label"><b>0</b></span>
                                                </td>
                                                <td style="width: 25px;">
                                                    <span class="form_label"><b>1</b></span>
                                                </td>
                                                <td style="width: 25px;">
                                                    <span class="form_label"><b>2</b></span>
                                                </td>
                                                <td style="width: 25px;">
                                                    <span class="form_label"><b>3</b></span>
                                                </td>
                                                <td style="width: 60px;">
                                                </td>
                                                <td style="width: 140px;">
                                                </td>
                                                <td style="width: 30px;">
                                                    <span><b>N/A</b></span>
                                                </td>
                                                <td style="width: 25px;">
                                                    <span class="form_label"><b>U</b></span>
                                                </td>
                                                <td style="width: 25px;">
                                                    <span class="form_label"><b>0</b></span>
                                                </td>
                                                <td style="width: 25px;">
                                                    <span class="form_label"><b>1</b></span>
                                                </td>
                                                <td style="width: 25px;">
                                                    <span class="form_label"><b>2</b></span>
                                                </td>
                                                <td style="width: 25px;">
                                                    <span class="form_label"><b>3</b></span>
                                                </td>
                                            </tr>
                                            <tr style="height: 10px">
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span>Psychosis: </span>
                                                </td>
                                                <td style="width: 30px; cursor: default;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Psychosis_N" name="RadioButton_CustomDocumentCANSGenerals_Psychosis"
                                                        value="N" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Psychosis_U" name="RadioButton_CustomDocumentCANSGenerals_Psychosis"
                                                        value="U" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Psychosis_0" name="RadioButton_CustomDocumentCANSGenerals_Psychosis"
                                                        value="0" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Psychosis_1" name="RadioButton_CustomDocumentCANSGenerals_Psychosis"
                                                        value="1" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Psychosis_2" name="RadioButton_CustomDocumentCANSGenerals_Psychosis"
                                                        value="2" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Psychosis_3" name="RadioButton_CustomDocumentCANSGenerals_Psychosis"
                                                        value="3" />
                                                </td>
                                                <td>
                                                </td>
                                                <td>
                                                    <span>Attention Deficit/Impulse: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_AttentionDefictImpluse_N"
                                                        name="RadioButton_CustomDocumentCANSGenerals_AttentionDefictImpluse" value="N" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_AttentionDefictImpluse_U"
                                                        name="RadioButton_CustomDocumentCANSGenerals_AttentionDefictImpluse" value="U" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_AttentionDefictImpluse_0"
                                                        name="RadioButton_CustomDocumentCANSGenerals_AttentionDefictImpluse" value="0" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_AttentionDefictImpluse_1"
                                                        name="RadioButton_CustomDocumentCANSGenerals_AttentionDefictImpluse" value="1" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_AttentionDefictImpluse_2"
                                                        name="RadioButton_CustomDocumentCANSGenerals_AttentionDefictImpluse" value="2" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_AttentionDefictImpluse_3"
                                                        name="RadioButton_CustomDocumentCANSGenerals_AttentionDefictImpluse" value="3" />
                                                </td>
                                            </tr>
                                            <tr style="height: 10px">
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span>Anger Management: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_AngerManagement_N"
                                                        name="RadioButton_CustomDocumentCANSGenerals_AngerManagement" value="N" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_AngerManagement_U"
                                                        name="RadioButton_CustomDocumentCANSGenerals_AngerManagement" value="U" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_AngerManagement_0"
                                                        name="RadioButton_CustomDocumentCANSGenerals_AngerManagement" value="0" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_AngerManagement_1"
                                                        name="RadioButton_CustomDocumentCANSGenerals_AngerManagement" value="1" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_AngerManagement_2"
                                                        name="RadioButton_CustomDocumentCANSGenerals_AngerManagement" value="2" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_AngerManagement_3"
                                                        name="RadioButton_CustomDocumentCANSGenerals_AngerManagement" value="3" />
                                                </td>
                                                <td>
                                                </td>
                                                <td>
                                                    <span>Adjustment to Trauma: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_AdjustmenttoTrauma_N"
                                                        name="RadioButton_CustomDocumentCANSGenerals_AdjustmenttoTrauma" value="N" onclick="showhideModules(); showhideTraumaModule();" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_AdjustmenttoTrauma_U"
                                                        name="RadioButton_CustomDocumentCANSGenerals_AdjustmenttoTrauma" value="U" onclick="showhideModules(); showhideTraumaModule();" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_AdjustmenttoTrauma_0"
                                                        name="RadioButton_CustomDocumentCANSGenerals_AdjustmenttoTrauma" value="0" onclick="showhideModules(); showhideTraumaModule();" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_AdjustmenttoTrauma_1"
                                                        name="RadioButton_CustomDocumentCANSGenerals_AdjustmenttoTrauma" value="1" onclick="showhideModules(); showhideTraumaModule();" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_AdjustmenttoTrauma_2"
                                                        name="RadioButton_CustomDocumentCANSGenerals_AdjustmenttoTrauma" value="2" onclick="showhideModules(); showhideTraumaModule();" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_AdjustmenttoTrauma_3"
                                                        name="RadioButton_CustomDocumentCANSGenerals_AdjustmenttoTrauma" value="3" onclick="showhideModules(); showhideTraumaModule();" />
                                                </td>
                                            </tr>
                                            <tr style="height: 10px">
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span>Substance Abuse: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_SubstanceAbuse_N"
                                                        name="RadioButton_CustomDocumentCANSGenerals_SubstanceAbuse" value="N" onclick="showhideModules(); showhideSubstanceAbuseModule();" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_SubstanceAbuse_U"
                                                        name="RadioButton_CustomDocumentCANSGenerals_SubstanceAbuse" value="U" onclick="showhideModules(); showhideSubstanceAbuseModule();" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_SubstanceAbuse_0"
                                                        name="RadioButton_CustomDocumentCANSGenerals_SubstanceAbuse" value="0" onclick="showhideModules(); showhideSubstanceAbuseModule();" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_SubstanceAbuse_1"
                                                        name="RadioButton_CustomDocumentCANSGenerals_SubstanceAbuse" value="1" onclick="showhideModules(); showhideSubstanceAbuseModule();" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_SubstanceAbuse_2"
                                                        name="RadioButton_CustomDocumentCANSGenerals_SubstanceAbuse" value="2" onclick="showhideModules(); showhideSubstanceAbuseModule();" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_SubstanceAbuse_3"
                                                        name="RadioButton_CustomDocumentCANSGenerals_SubstanceAbuse" value="3" onclick="showhideModules(); showhideSubstanceAbuseModule();" />
                                                </td>
                                                <td>
                                                </td>
                                                <td>
                                                    <span>Oppositional Behavior: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_OppositionalBehavior_N"
                                                        name="RadioButton_CustomDocumentCANSGenerals_OppositionalBehavior" value="N" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_OppositionalBehavior_U"
                                                        name="RadioButton_CustomDocumentCANSGenerals_OppositionalBehavior" value="U" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_OppositionalBehavior_0"
                                                        name="RadioButton_CustomDocumentCANSGenerals_OppositionalBehavior" value="0" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_OppositionalBehavior_1"
                                                        name="RadioButton_CustomDocumentCANSGenerals_OppositionalBehavior" value="1" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_OppositionalBehavior_2"
                                                        name="RadioButton_CustomDocumentCANSGenerals_OppositionalBehavior" value="2" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_OppositionalBehavior_3"
                                                        name="RadioButton_CustomDocumentCANSGenerals_OppositionalBehavior" value="3" />
                                                </td>
                                            </tr>
                                            <tr style="height: 10px">
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span>Depression/Anxiety: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_DepressionAnxiety_N"
                                                        name="RadioButton_CustomDocumentCANSGenerals_DepressionAnxiety" value="N" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_DepressionAnxiety_U"
                                                        name="RadioButton_CustomDocumentCANSGenerals_DepressionAnxiety" value="U" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_DepressionAnxiety_0"
                                                        name="RadioButton_CustomDocumentCANSGenerals_DepressionAnxiety" value="0" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_DepressionAnxiety_1"
                                                        name="RadioButton_CustomDocumentCANSGenerals_DepressionAnxiety" value="1" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_DepressionAnxiety_2"
                                                        name="RadioButton_CustomDocumentCANSGenerals_DepressionAnxiety" value="2" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_DepressionAnxiety_3"
                                                        name="RadioButton_CustomDocumentCANSGenerals_DepressionAnxiety" value="3" />
                                                </td>
                                                <td>
                                                </td>
                                                <td>
                                                    <span>Antisocial Behavior: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_AntisocialBehavior_N"
                                                        name="RadioButton_CustomDocumentCANSGenerals_AntisocialBehavior" value="N" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_AntisocialBehavior_U"
                                                        name="RadioButton_CustomDocumentCANSGenerals_AntisocialBehavior" value="U" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_AntisocialBehavior_0"
                                                        name="RadioButton_CustomDocumentCANSGenerals_AntisocialBehavior" value="0" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_AntisocialBehavior_1"
                                                        name="RadioButton_CustomDocumentCANSGenerals_AntisocialBehavior" value="1" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_AntisocialBehavior_2"
                                                        name="RadioButton_CustomDocumentCANSGenerals_AntisocialBehavior" value="2" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_AntisocialBehavior_3"
                                                        name="RadioButton_CustomDocumentCANSGenerals_AntisocialBehavior" value="3" />
                                                </td>
                                            </tr>
                                            <tr style="height: 10px">
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span>Attachment: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Attachment_N" name="RadioButton_CustomDocumentCANSGenerals_Attachment"
                                                        value="N" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Attachment_U" name="RadioButton_CustomDocumentCANSGenerals_Attachment"
                                                        value="U" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Attachment_0" name="RadioButton_CustomDocumentCANSGenerals_Attachment"
                                                        value="0" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Attachment_1" name="RadioButton_CustomDocumentCANSGenerals_Attachment"
                                                        value="1" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Attachment_2" name="RadioButton_CustomDocumentCANSGenerals_Attachment"
                                                        value="2" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Attachment_3" name="RadioButton_CustomDocumentCANSGenerals_Attachment"
                                                        value="3" />
                                                </td>
                                                <td colspan="8">
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding: 0 0 5px 0;">
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                                <td width="1%" class="right_bottom_cont_bottom_bg">
                                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                                                        height="7" alt="" />
                                                </td>
                                                <td class="right_bottom_cont_bottom_bg" width="98%">
                                                </td>
                                                <td width="1%" class="right_bottom_cont_bottom_bg" align="right">
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
                    <%--        <tr class="height2">
        </tr>--%>
                    <%--        <tr style="height: 10px">
        </tr>--%>
                    <tr>
                        <td colspan="4">
                            <table cellpadding="0" cellspacing="0" border="0" width="99%">
                                <tr>
                                    <td>
                                        <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                    <span id="Span6">Life Domain Functioning</span>
                                                </td>
                                                <td width="17px">
                                                    <img style="vertical-align: top;" height="26" width="17px" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                                                </td>
                                                <td class="content_tab_top" width="100%">
                                                </td>
                                                <td width="7">
                                                    <img style="vertical-align: top;" height="26" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="content_tab_bg" style="padding-right: 8px">
                                        <table cellpadding="0" cellspacing="0" border="0" style="padding-left: 10px" width="100%">
                                            <tr>
                                                <td colspan="15" align="center">
                                                    <span id="Span7"><b>Scoring chart: 0= No Evidence of Problems, 1=History, Mild, 2=Moderate,
                                                        3=Severe</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2" colspan="15">
                                                </td>
                                            </tr>
                                            <tr style="height: 10px">
                                            </tr>
                                            <tr>
                                                <td style="width: 110px;">
                                                </td>
                                                <td style="width: 30px;">
                                                    <span><b>N/A</b></span>
                                                </td>
                                                <td style="width: 25px;">
                                                    <span class="form_label"><b>U</b></span>
                                                </td>
                                                <td style="width: 25px;">
                                                    <span class="form_label"><b>0</b></span>
                                                </td>
                                                <td style="width: 25px;">
                                                    <span class="form_label"><b>1</b></span>
                                                </td>
                                                <td style="width: 25px;">
                                                    <span class="form_label"><b>2</b></span>
                                                </td>
                                                <td style="width: 25px;">
                                                    <span class="form_label"><b>3</b></span>
                                                </td>
                                                <td style="width: 60px;">
                                                </td>
                                                <td style="width: 140px;">
                                                </td>
                                                <td style="width: 30px;">
                                                    <span><b>N/A</b></span>
                                                </td>
                                                <td style="width: 25px;">
                                                    <span class="form_label"><b>U</b></span>
                                                </td>
                                                <td style="width: 25px;">
                                                    <span class="form_label"><b>0</b></span>
                                                </td>
                                                <td style="width: 25px;">
                                                    <span class="form_label"><b>1</b></span>
                                                </td>
                                                <td style="width: 25px;">
                                                    <span class="form_label"><b>2</b></span>
                                                </td>
                                                <td style="width: 25px;">
                                                    <span class="form_label"><b>3</b></span>
                                                </td>
                                            </tr>
                                            <tr style="height: 10px">
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span>Job Functioning: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFJobFunctioning_N"
                                                        name="RadioButton_CustomDocumentCANSGenerals_LDFJobFunctioning" value="N" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFJobFunctioning_U"
                                                        name="RadioButton_CustomDocumentCANSGenerals_LDFJobFunctioning" value="U" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFJobFunctioning_0"
                                                        name="RadioButton_CustomDocumentCANSGenerals_LDFJobFunctioning" value="0" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFJobFunctioning_1"
                                                        name="RadioButton_CustomDocumentCANSGenerals_LDFJobFunctioning" value="1" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFJobFunctioning_2"
                                                        name="RadioButton_CustomDocumentCANSGenerals_LDFJobFunctioning" value="2" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFJobFunctioning_3"
                                                        name="RadioButton_CustomDocumentCANSGenerals_LDFJobFunctioning" value="3" />
                                                </td>
                                                <td>
                                                </td>
                                                <td>
                                                    <span>Sleep: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFSleep_N" name="RadioButton_CustomDocumentCANSGenerals_LDFSleep"
                                                        value="N" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFSleep_U" name="RadioButton_CustomDocumentCANSGenerals_LDFSleep"
                                                        value="U" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFSleep_0" name="RadioButton_CustomDocumentCANSGenerals_LDFSleep"
                                                        value="0" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFSleep_1" name="RadioButton_CustomDocumentCANSGenerals_LDFSleep"
                                                        value="1" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFSleep_2" name="RadioButton_CustomDocumentCANSGenerals_LDFSleep"
                                                        value="2" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFSleep_3" name="RadioButton_CustomDocumentCANSGenerals_LDFSleep"
                                                        value="3" />
                                                </td>
                                            </tr>
                                            <tr style="height: 10px">
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span>Physical/Medical: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFPhysicalMedical_N"
                                                        name="RadioButton_CustomDocumentCANSGenerals_LDFPhysicalMedical" value="N" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFPhysicalMedical_U"
                                                        name="RadioButton_CustomDocumentCANSGenerals_LDFPhysicalMedical" value="U" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFPhysicalMedical_0"
                                                        name="RadioButton_CustomDocumentCANSGenerals_LDFPhysicalMedical" value="0" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFPhysicalMedical_1"
                                                        name="RadioButton_CustomDocumentCANSGenerals_LDFPhysicalMedical" value="1" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFPhysicalMedical_2"
                                                        name="RadioButton_CustomDocumentCANSGenerals_LDFPhysicalMedical" value="2" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFPhysicalMedical_3"
                                                        name="RadioButton_CustomDocumentCANSGenerals_LDFPhysicalMedical" value="3" />
                                                </td>
                                                <td>
                                                </td>
                                                <td>
                                                    <span>Family: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFFamily_N" name="RadioButton_CustomDocumentCANSGenerals_LDFFamily"
                                                        value="N" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFFamily_U" name="RadioButton_CustomDocumentCANSGenerals_LDFFamily"
                                                        value="U" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFFamily_0" name="RadioButton_CustomDocumentCANSGenerals_LDFFamily"
                                                        value="0" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFFamily_1" name="RadioButton_CustomDocumentCANSGenerals_LDFFamily"
                                                        value="1" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFFamily_2" name="RadioButton_CustomDocumentCANSGenerals_LDFFamily"
                                                        value="2" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFFamily_3" name="RadioButton_CustomDocumentCANSGenerals_LDFFamily"
                                                        value="3" />
                                                </td>
                                            </tr>
                                            <tr style="height: 10px">
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span>Living Situation: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFLivingSituation_N"
                                                        name="RadioButton_CustomDocumentCANSGenerals_LDFLivingSituation" value="N" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFLivingSituation_U"
                                                        name="RadioButton_CustomDocumentCANSGenerals_LDFLivingSituation" value="U" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFLivingSituation_0"
                                                        name="RadioButton_CustomDocumentCANSGenerals_LDFLivingSituation" value="0" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFLivingSituation_1"
                                                        name="RadioButton_CustomDocumentCANSGenerals_LDFLivingSituation" value="1" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFLivingSituation_2"
                                                        name="RadioButton_CustomDocumentCANSGenerals_LDFLivingSituation" value="2" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFLivingSituation_3"
                                                        name="RadioButton_CustomDocumentCANSGenerals_LDFLivingSituation" value="3" />
                                                </td>
                                                <td>
                                                </td>
                                                <td>
                                                    <span>School Achievement: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFSchoolAchievement_N"
                                                        name="RadioButton_CustomDocumentCANSGenerals_LDFSchoolAchievement" value="N" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFSchoolAchievement_U"
                                                        name="RadioButton_CustomDocumentCANSGenerals_LDFSchoolAchievement" value="U" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFSchoolAchievement_0"
                                                        name="RadioButton_CustomDocumentCANSGenerals_LDFSchoolAchievement" value="0" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFSchoolAchievement_1"
                                                        name="RadioButton_CustomDocumentCANSGenerals_LDFSchoolAchievement" value="1" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFSchoolAchievement_2"
                                                        name="RadioButton_CustomDocumentCANSGenerals_LDFSchoolAchievement" value="2" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFSchoolAchievement_3"
                                                        name="RadioButton_CustomDocumentCANSGenerals_LDFSchoolAchievement" value="3" />
                                                </td>
                                            </tr>
                                            <tr style="height: 10px">
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span>School Behavior: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFSchoolBehavior_N"
                                                        name="RadioButton_CustomDocumentCANSGenerals_LDFSchoolBehavior" value="N" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFSchoolBehavior_U"
                                                        name="RadioButton_CustomDocumentCANSGenerals_LDFSchoolBehavior" value="U" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFSchoolBehavior_0"
                                                        name="RadioButton_CustomDocumentCANSGenerals_LDFSchoolBehavior" value="0" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFSchoolBehavior_1"
                                                        name="RadioButton_CustomDocumentCANSGenerals_LDFSchoolBehavior" value="1" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFSchoolBehavior_2"
                                                        name="RadioButton_CustomDocumentCANSGenerals_LDFSchoolBehavior" value="2" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFSchoolBehavior_3"
                                                        name="RadioButton_CustomDocumentCANSGenerals_LDFSchoolBehavior" value="3" />
                                                </td>
                                                <td>
                                                </td>
                                                <td>
                                                    <span>School Attendance: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFSchoolAttendance_N"
                                                        name="RadioButton_CustomDocumentCANSGenerals_LDFSchoolAttendance" value="N" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFSchoolAttendance_U"
                                                        name="RadioButton_CustomDocumentCANSGenerals_LDFSchoolAttendance" value="U" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFSchoolAttendance_0"
                                                        name="RadioButton_CustomDocumentCANSGenerals_LDFSchoolAttendance" value="0" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFSchoolAttendance_1"
                                                        name="RadioButton_CustomDocumentCANSGenerals_LDFSchoolAttendance" value="1" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFSchoolAttendance_2"
                                                        name="RadioButton_CustomDocumentCANSGenerals_LDFSchoolAttendance" value="2" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFSchoolAttendance_3"
                                                        name="RadioButton_CustomDocumentCANSGenerals_LDFSchoolAttendance" value="3" />
                                                </td>
                                            </tr>
                                            <tr style="height: 6px">
                                            </tr>
                                            <tr>
                                                <td class="style1">
                                                    <span>Sexual Development: </span>
                                                </td>
                                                <td class="style2">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFSexualDevelopment_N"
                                                        name="RadioButton_CustomDocumentCANSGenerals_LDFSexualDevelopment" value="N" />
                                                </td>
                                                <td class="style3">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFSexualDevelopment_U"
                                                        name="RadioButton_CustomDocumentCANSGenerals_LDFSexualDevelopment" value="U" />
                                                </td>
                                                <td class="style3">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFSexualDevelopment_0"
                                                        name="RadioButton_CustomDocumentCANSGenerals_LDFSexualDevelopment" value="0" />
                                                </td>
                                                <td class="style3">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFSexualDevelopment_1"
                                                        name="RadioButton_CustomDocumentCANSGenerals_LDFSexualDevelopment" value="1" />
                                                </td>
                                                <td class="style3">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFSexualDevelopment_2"
                                                        name="RadioButton_CustomDocumentCANSGenerals_LDFSexualDevelopment" value="2" />
                                                </td>
                                                <td class="style3">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFSexualDevelopment_3"
                                                        name="RadioButton_CustomDocumentCANSGenerals_LDFSexualDevelopment" value="3" />
                                                </td>
                                                <td class="style1">
                                                </td>
                                                <td class="style1">
                                                    <span>Intellectual/Developmental: </span>
                                                </td>
                                                <td class="style2">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFIntellectualDevelopmental_N"
                                                        name="RadioButton_CustomDocumentCANSGenerals_LDFIntellectualDevelopmental" value="N" />
                                                </td>
                                                <td class="style3">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFIntellectualDevelopmental_U"
                                                        name="RadioButton_CustomDocumentCANSGenerals_LDFIntellectualDevelopmental" value="U" />
                                                </td>
                                                <td class="style3">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFIntellectualDevelopmental_0"
                                                        name="RadioButton_CustomDocumentCANSGenerals_LDFIntellectualDevelopmental" value="0" />
                                                </td>
                                                <td class="style3">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFIntellectualDevelopmental_1"
                                                        name="RadioButton_CustomDocumentCANSGenerals_LDFIntellectualDevelopmental" value="1" />
                                                </td>
                                                <td class="style3">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFIntellectualDevelopmental_2"
                                                        name="RadioButton_CustomDocumentCANSGenerals_LDFIntellectualDevelopmental" value="2" />
                                                </td>
                                                <td class="style3">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_LDFIntellectualDevelopmental_3"
                                                        name="RadioButton_CustomDocumentCANSGenerals_LDFIntellectualDevelopmental" value="3" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding: 0 0 5px 0;">
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                                <td width="1%" class="right_bottom_cont_bottom_bg">
                                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                                                        height="7" alt="" />
                                                </td>
                                                <td class="right_bottom_cont_bottom_bg" width="98%">
                                                </td>
                                                <td width="1%" class="right_bottom_cont_bottom_bg" align="right">
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
                        <td colspan="4">
                            <table cellpadding="0" cellspacing="0" border="0" width="99%">
                                <tr>
                                    <td>
                                        <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                    <span id="Span2">Caregiver Needs & Strengths</span>
                                                </td>
                                                <td width="17px">
                                                    <img style="vertical-align: top;" height="26" width="17px" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                                                </td>
                                                <td class="content_tab_top" width="100%">
                                                </td>
                                                <td width="7">
                                                    <img style="vertical-align: top;" height="26" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="content_tab_bg" style="padding-right: 8px">
                                        <table cellpadding="0" cellspacing="0" border="0" style="padding-left: 10px" width="100%">
                                            <tr>
                                                <td colspan="15" align="center">
                                                    <span id="Span3"><b>Scoring chart: 0= No Evidence, 1=Minimal Needs, 2=Moderate Needs,
                                                        3=Severe Needs</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2" colspan="15">
                                                </td>
                                            </tr>
                                            <tr style="height: 10px">
                                            </tr>
                                            <tr>
                                                <td style="width: 110px;">
                                                </td>
                                                <td style="width: 30px;">
                                                    <span><b>N/A</b></span>
                                                </td>
                                                <td style="width: 25px;">
                                                    <span class="form_label"><b>U</b></span>
                                                </td>
                                                <td style="width: 25px;">
                                                    <span class="form_label"><b>0</b></span>
                                                </td>
                                                <td style="width: 25px;">
                                                    <span class="form_label"><b>1</b></span>
                                                </td>
                                                <td style="width: 25px;">
                                                    <span class="form_label"><b>2</b></span>
                                                </td>
                                                <td style="width: 25px;">
                                                    <span class="form_label"><b>3</b></span>
                                                </td>
                                                <td style="width: 60px;">
                                                </td>
                                                <td style="width: 140px;">
                                                </td>
                                                <td style="width: 30px;">
                                                    <span><b>N/A</b></span>
                                                </td>
                                                <td style="width: 25px;">
                                                    <span class="form_label"><b>U</b></span>
                                                </td>
                                                <td style="width: 25px;">
                                                    <span class="form_label"><b>0</b></span>
                                                </td>
                                                <td style="width: 25px;">
                                                    <span class="form_label"><b>1</b></span>
                                                </td>
                                                <td style="width: 25px;">
                                                    <span class="form_label"><b>2</b></span>
                                                </td>
                                                <td style="width: 25px;">
                                                    <span class="form_label"><b>3</b></span>
                                                </td>
                                            </tr>
                                            <tr style="height: 10px">
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span>Safety: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Safety_N" name="RadioButton_CustomDocumentCANSGenerals_Safety"
                                                        value="N" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Safety_U" name="RadioButton_CustomDocumentCANSGenerals_Safety"
                                                        value="U" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Safety_0" name="RadioButton_CustomDocumentCANSGenerals_Safety"
                                                        value="0" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Safety_1" name="RadioButton_CustomDocumentCANSGenerals_Safety"
                                                        value="1" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Safety_2" name="RadioButton_CustomDocumentCANSGenerals_Safety"
                                                        value="2" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Safety_3" name="RadioButton_CustomDocumentCANSGenerals_Safety"
                                                        value="3" />
                                                </td>
                                                <td>
                                                </td>
                                                <td>
                                                    <span>Involvement: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Involvement_N" name="RadioButton_CustomDocumentCANSGenerals_Involvement"
                                                        value="N" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Involvement_U" name="RadioButton_CustomDocumentCANSGenerals_Involvement"
                                                        value="U" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Involvement_0" name="RadioButton_CustomDocumentCANSGenerals_Involvement"
                                                        value="0" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Involvement_1" name="RadioButton_CustomDocumentCANSGenerals_Involvement"
                                                        value="1" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Involvement_2" name="RadioButton_CustomDocumentCANSGenerals_Involvement"
                                                        value="2" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Involvement_3" name="RadioButton_CustomDocumentCANSGenerals_Involvement"
                                                        value="3" />
                                                </td>
                                            </tr>
                                            <tr style="height: 10px">
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span>Resources: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Resources_N" name="RadioButton_CustomDocumentCANSGenerals_Resources"
                                                        value="N" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Resources_U" name="RadioButton_CustomDocumentCANSGenerals_Resources"
                                                        value="U" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Resources_0" name="RadioButton_CustomDocumentCANSGenerals_Resources"
                                                        value="0" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Resources_1" name="RadioButton_CustomDocumentCANSGenerals_Resources"
                                                        value="1" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Resources_2" name="RadioButton_CustomDocumentCANSGenerals_Resources"
                                                        value="2" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Resources_3" name="RadioButton_CustomDocumentCANSGenerals_Resources"
                                                        value="3" />
                                                </td>
                                                <td>
                                                </td>
                                                <td>
                                                    <span>Organization: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Organization_N" name="RadioButton_CustomDocumentCANSGenerals_Organization"
                                                        value="N" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Organization_U" name="RadioButton_CustomDocumentCANSGenerals_Organization"
                                                        value="U" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Organization_0" name="RadioButton_CustomDocumentCANSGenerals_Organization"
                                                        value="0" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Organization_1" name="RadioButton_CustomDocumentCANSGenerals_Organization"
                                                        value="1" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Organization_2" name="RadioButton_CustomDocumentCANSGenerals_Organization"
                                                        value="2" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Organization_3" name="RadioButton_CustomDocumentCANSGenerals_Organization"
                                                        value="3" />
                                                </td>
                                            </tr>
                                            <tr style="height: 10px">
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span>Supervision: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Supervision_N" name="RadioButton_CustomDocumentCANSGenerals_Supervision"
                                                        value="N" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Supervision_U" name="RadioButton_CustomDocumentCANSGenerals_Supervision"
                                                        value="U" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Supervision_0" name="RadioButton_CustomDocumentCANSGenerals_Supervision"
                                                        value="0" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Supervision_1" name="RadioButton_CustomDocumentCANSGenerals_Supervision"
                                                        value="1" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Supervision_2" name="RadioButton_CustomDocumentCANSGenerals_Supervision"
                                                        value="2" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Supervision_3" name="RadioButton_CustomDocumentCANSGenerals_Supervision"
                                                        value="3" />
                                                </td>
                                                <td>
                                                </td>
                                                <td>
                                                    <span>Development: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Development_N" name="RadioButton_CustomDocumentCANSGenerals_Development"
                                                        value="N" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Development_U" name="RadioButton_CustomDocumentCANSGenerals_Development"
                                                        value="U" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Development_0" name="RadioButton_CustomDocumentCANSGenerals_Development"
                                                        value="0" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Development_1" name="RadioButton_CustomDocumentCANSGenerals_Development"
                                                        value="1" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Development_2" name="RadioButton_CustomDocumentCANSGenerals_Development"
                                                        value="2" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Development_3" name="RadioButton_CustomDocumentCANSGenerals_Development"
                                                        value="3" />
                                                </td>
                                            </tr>
                                            <tr style="height: 10px">
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span>Knowledge: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Knowledge_N" name="RadioButton_CustomDocumentCANSGenerals_Knowledge"
                                                        value="N" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Knowledge_U" name="RadioButton_CustomDocumentCANSGenerals_Knowledge"
                                                        value="U" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Knowledge_0" name="RadioButton_CustomDocumentCANSGenerals_Knowledge"
                                                        value="0" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Knowledge_1" name="RadioButton_CustomDocumentCANSGenerals_Knowledge"
                                                        value="1" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Knowledge_2" name="RadioButton_CustomDocumentCANSGenerals_Knowledge"
                                                        value="2" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Knowledge_3" name="RadioButton_CustomDocumentCANSGenerals_Knowledge"
                                                        value="3" />
                                                </td>
                                                <td>
                                                </td>
                                                <td>
                                                    <span>Physical/Behavioral Health: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_PhysicalBehavioralHealth_N"
                                                        name="RadioButton_CustomDocumentCANSGenerals_PhysicalBehavioralHealth" value="N" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_PhysicalBehavioralHealth_U"
                                                        name="RadioButton_CustomDocumentCANSGenerals_PhysicalBehavioralHealth" value="U" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_PhysicalBehavioralHealth_0"
                                                        name="RadioButton_CustomDocumentCANSGenerals_PhysicalBehavioralHealth" value="0" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_PhysicalBehavioralHealth_1"
                                                        name="RadioButton_CustomDocumentCANSGenerals_PhysicalBehavioralHealth" value="1" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_PhysicalBehavioralHealth_2"
                                                        name="RadioButton_CustomDocumentCANSGenerals_PhysicalBehavioralHealth" value="2" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_PhysicalBehavioralHealth_3"
                                                        name="RadioButton_CustomDocumentCANSGenerals_PhysicalBehavioralHealth" value="3" />
                                                </td>
                                            </tr>
                                            <tr style="height: 10px">
                                            </tr>
                                            <tr>
                                                <td colspan="8">
                                                </td>
                                                <td>
                                                    <span>Residential Stability: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_ResidentialStability_N"
                                                        name="RadioButton_CustomDocumentCANSGenerals_ResidentialStability" value="N" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_ResidentialStability_U"
                                                        name="RadioButton_CustomDocumentCANSGenerals_ResidentialStability" value="U" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_ResidentialStability_0"
                                                        name="RadioButton_CustomDocumentCANSGenerals_ResidentialStability" value="0" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_ResidentialStability_1"
                                                        name="RadioButton_CustomDocumentCANSGenerals_ResidentialStability" value="1" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_ResidentialStability_2"
                                                        name="RadioButton_CustomDocumentCANSGenerals_ResidentialStability" value="2" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_ResidentialStability_3"
                                                        name="RadioButton_CustomDocumentCANSGenerals_ResidentialStability" value="3" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding: 0 0 5px 0;">
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                                <td width="1%" class="right_bottom_cont_bottom_bg">
                                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                                                        height="7" alt="" />
                                                </td>
                                                <td class="right_bottom_cont_bottom_bg" width="98%">
                                                </td>
                                                <td width="1%" class="right_bottom_cont_bottom_bg" align="right">
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
                    <%--        <tr class="height2">
        </tr>--%>
                    <tr>
                        <td colspan="4">
                            <table cellpadding="0" cellspacing="0" border="0" width="99%">
                                <tr>
                                    <td>
                                        <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                    <span id="Span4">Child Safety</span>
                                                </td>
                                                <td width="17px">
                                                    <img style="vertical-align: top;" height="26" width="17px" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                                                </td>
                                                <td class="content_tab_top" width="100%">
                                                </td>
                                                <td width="7">
                                                    <img style="vertical-align: top;" height="26" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="content_tab_bg" style="padding-right: 8px">
                                        <table cellpadding="0" cellspacing="0" border="0" style="padding-left: 10px" width="100%">
                                            <tr>
                                                <td colspan="15" align="center">
                                                    <span id="Span5"><b>Scoring chart: 0= No Evidence of Problems, 1=History, Mild, 2=Moderate,
                                                        3=Severe</b></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2" colspan="15">
                                                </td>
                                            </tr>
                                            <tr style="height: 10px">
                                            </tr>
                                            <tr>
                                                <td style="width: 110px;">
                                                </td>
                                                <td style="width: 30px;">
                                                    <span><b>N/A</b></span>
                                                </td>
                                                <td style="width: 25px;">
                                                    <span class="form_label"><b>U</b></span>
                                                </td>
                                                <td style="width: 25px;">
                                                    <span class="form_label"><b>0</b></span>
                                                </td>
                                                <td style="width: 25px;">
                                                    <span class="form_label"><b>1</b></span>
                                                </td>
                                                <td style="width: 25px;">
                                                    <span class="form_label"><b>2</b></span>
                                                </td>
                                                <td style="width: 25px;">
                                                    <span class="form_label"><b>3</b></span>
                                                </td>
                                                <td style="width: 60px;">
                                                </td>
                                                <td style="width: 140px;">
                                                </td>
                                                <td style="width: 30px;">
                                                    <span><b>N/A</b></span>
                                                </td>
                                                <td style="width: 25px;">
                                                    <span class="form_label"><b>U</b></span>
                                                </td>
                                                <td style="width: 25px;">
                                                    <span class="form_label"><b>0</b></span>
                                                </td>
                                                <td style="width: 25px;">
                                                    <span class="form_label"><b>1</b></span>
                                                </td>
                                                <td style="width: 25px;">
                                                    <span class="form_label"><b>2</b></span>
                                                </td>
                                                <td style="width: 25px;">
                                                    <span class="form_label"><b>3</b></span>
                                                </td>
                                            </tr>
                                            <tr style="height: 10px">
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span>Abuse: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Abuse_N" name="RadioButton_CustomDocumentCANSGenerals_Abuse"
                                                        value="N" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Abuse_U" name="RadioButton_CustomDocumentCANSGenerals_Abuse"
                                                        value="U" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Abuse_0" name="RadioButton_CustomDocumentCANSGenerals_Abuse"
                                                        value="0" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Abuse_1" name="RadioButton_CustomDocumentCANSGenerals_Abuse"
                                                        value="1" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Abuse_2" name="RadioButton_CustomDocumentCANSGenerals_Abuse"
                                                        value="2" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Abuse_3" name="RadioButton_CustomDocumentCANSGenerals_Abuse"
                                                        value="3" />
                                                </td>
                                                <td>
                                                </td>
                                                <td>
                                                    <span>Permanency: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Permanency_N" name="RadioButton_CustomDocumentCANSGenerals_Permanency"
                                                        value="N" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Permanency_U" name="RadioButton_CustomDocumentCANSGenerals_Permanency"
                                                        value="U" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Permanency_0" name="RadioButton_CustomDocumentCANSGenerals_Permanency"
                                                        value="0" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Permanency_1" name="RadioButton_CustomDocumentCANSGenerals_Permanency"
                                                        value="1" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Permanency_2" name="RadioButton_CustomDocumentCANSGenerals_Permanency"
                                                        value="2" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Permanency_3" name="RadioButton_CustomDocumentCANSGenerals_Permanency"
                                                        value="3" />
                                                </td>
                                            </tr>
                                            <tr style="height: 10px">
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span>Neglect: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Neglect_N" name="RadioButton_CustomDocumentCANSGenerals_Neglect"
                                                        value="N" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Neglect_U" name="RadioButton_CustomDocumentCANSGenerals_Neglect"
                                                        value="U" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Neglect_0" name="RadioButton_CustomDocumentCANSGenerals_Neglect"
                                                        value="0" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Neglect_1" name="RadioButton_CustomDocumentCANSGenerals_Neglect"
                                                        value="1" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Neglect_2" name="RadioButton_CustomDocumentCANSGenerals_Neglect"
                                                        value="2" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Neglect_3" name="RadioButton_CustomDocumentCANSGenerals_Neglect"
                                                        value="3" />
                                                </td>
                                                <td>
                                                </td>
                                                <td>
                                                    <span>Child Safety: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_ChildSafety_N" name="RadioButton_CustomDocumentCANSGenerals_ChildSafety"
                                                        value="N" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_ChildSafety_U" name="RadioButton_CustomDocumentCANSGenerals_ChildSafety"
                                                        value="U" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_ChildSafety_0" name="RadioButton_CustomDocumentCANSGenerals_ChildSafety"
                                                        value="0" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_ChildSafety_1" name="RadioButton_CustomDocumentCANSGenerals_ChildSafety"
                                                        value="1" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_ChildSafety_2" name="RadioButton_CustomDocumentCANSGenerals_ChildSafety"
                                                        value="2" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_ChildSafety_3" name="RadioButton_CustomDocumentCANSGenerals_ChildSafety"
                                                        value="3" />
                                                </td>
                                            </tr>
                                            <tr style="height: 10px">
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span>Exploitation: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Exploitation_N" name="RadioButton_CustomDocumentCANSGenerals_Exploitation"
                                                        value="N" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Exploitation_U" name="RadioButton_CustomDocumentCANSGenerals_Exploitation"
                                                        value="U" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Exploitation_0" name="RadioButton_CustomDocumentCANSGenerals_Exploitation"
                                                        value="0" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Exploitation_1" name="RadioButton_CustomDocumentCANSGenerals_Exploitation"
                                                        value="1" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Exploitation_2" name="RadioButton_CustomDocumentCANSGenerals_Exploitation"
                                                        value="2" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_Exploitation_3" name="RadioButton_CustomDocumentCANSGenerals_Exploitation"
                                                        value="3" />
                                                </td>
                                                <td>
                                                </td>
                                                <td>
                                                    <span>Emotional Closeness to Perpetrator:</span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_EmotionalCloseness_N"
                                                        name="RadioButton_CustomDocumentCANSGenerals_EmotionalCloseness" value="N" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_EmotionalCloseness_U"
                                                        name="RadioButton_CustomDocumentCANSGenerals_EmotionalCloseness" value="U" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_EmotionalCloseness_0"
                                                        name="RadioButton_CustomDocumentCANSGenerals_EmotionalCloseness" value="0" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_EmotionalCloseness_1"
                                                        name="RadioButton_CustomDocumentCANSGenerals_EmotionalCloseness" value="1" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_EmotionalCloseness_2"
                                                        name="RadioButton_CustomDocumentCANSGenerals_EmotionalCloseness" value="2" />
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSGenerals_EmotionalCloseness_3"
                                                        name="RadioButton_CustomDocumentCANSGenerals_EmotionalCloseness" value="3" />
                                                </td>
                                            </tr>
                                            <tr style="height: 10px">
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding: 0 0 5px 0;">
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                                <td width="1%" class="right_bottom_cont_bottom_bg">
                                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                                                        height="7" alt="" />
                                                </td>
                                                <td class="right_bottom_cont_bottom_bg" width="98%">
                                                </td>
                                                <td width="1%" class="right_bottom_cont_bottom_bg" align="right">
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
        <tr>
            <td style="padding: 0 0 5px 0;" colspan="4">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td width="1%" class="right_bottom_cont_bottom_bg">
                            <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                                height="7" alt="" />
                        </td>
                        <td class="right_bottom_cont_bottom_bg" width="98%">
                        </td>
                        <td width="1%" class="right_bottom_cont_bottom_bg" align="right">
                            <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif"
                                height="7" alt="" />
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</div>
