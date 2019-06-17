<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CANSModules.ascx.cs" Inherits="SHS.SmartCare.CANSModules" %>
<%@ Register Assembly="Streamline.DotNetDropDownGlobalCodes" Namespace="Streamline.DotNetDropDownGlobalCodes"
    TagPrefix="DropDownGlobalCodes" %>
<%@ Register Assembly="Streamline.DotNetDropDowns" Namespace="Streamline.DotNetDropDowns"
    TagPrefix="cc2" %>

<div class="DocumentScreen" style="padding-top: 5px" id="divModules">
    <table cellpadding="0" cellspacing="0" border="0" width="100%">
        <tr>
            <td colspan="4" >
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
            <td id="ModuleTabId">
                <table width="100%" class="content_tab_bg">
                    <tr id="SubstanceAbuseModule">
                        <td colspan="4">
                            <table cellpadding="0" cellspacing="0" border="0" width="99%" style="padding: 5px 0px 0px 0px">
                                <tr>
                                    <td>
                                        <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                    <span id="Span1">Substance Abuse Module</span>
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
                                    <td class="content_tab_bg" style="padding-right: 8px">
                                        <table cellpadding="0" cellspacing="0" border="0" style="padding-left: 10px" width="100%">
                                            <tr>
                                                <td colspan="15" align="center">
                                                    <span id="Spanchart" class="form_label"><b>Scoring chart: 0= No Evidence of Problems, 1=History, Mild,
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
                                                    <span class="form_label">Severity of Use: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_SeverityofUse_N" name="RadioButton_CustomDocumentCANSModules_SeverityofUse" value="N"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_SeverityofUse_U" name="RadioButton_CustomDocumentCANSModules_SeverityofUse" value="U"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_SeverityofUse_0" name="RadioButton_CustomDocumentCANSModules_SeverityofUse" value="0"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_SeverityofUse_1" name="RadioButton_CustomDocumentCANSModules_SeverityofUse" value="1"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_SeverityofUse_2" name="RadioButton_CustomDocumentCANSModules_SeverityofUse" value="2"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_SeverityofUse_3" name="RadioButton_CustomDocumentCANSModules_SeverityofUse" value="3"/>
                                                </td>
                                                <td>
                                                </td>
                                                <td>
                                                    <span>Stage of Recovery: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_StageofRecovery_N" name="RadioButton_CustomDocumentCANSModules_StageofRecovery" value="N"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_StageofRecovery_U" name="RadioButton_CustomDocumentCANSModules_StageofRecovery" value="U"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_StageofRecovery_0" name="RadioButton_CustomDocumentCANSModules_StageofRecovery" value="0"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_StageofRecovery_1" name="RadioButton_CustomDocumentCANSModules_StageofRecovery" value="1"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_StageofRecovery_2" name="RadioButton_CustomDocumentCANSModules_StageofRecovery" value="2"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_StageofRecovery_3" name="RadioButton_CustomDocumentCANSModules_StageofRecovery" value="3"/>
                                                </td>
                                            </tr>
                                            <tr style="height: 10px">
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span>Duration of Use: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_DurationofUse_N" name="RadioButton_CustomDocumentCANSModules_DurationofUse" value="N"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_DurationofUse_Y" name="RadioButton_CustomDocumentCANSModules_DurationofUse" value="U"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_DurationofUse_0" name="RadioButton_CustomDocumentCANSModules_DurationofUse" value="0"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_DurationofUse_1" name="RadioButton_CustomDocumentCANSModules_DurationofUse" value="1"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_DurationofUse_2" name="RadioButton_CustomDocumentCANSModules_DurationofUse" value="2"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_DurationofUse_3" name="RadioButton_CustomDocumentCANSModules_DurationofUse" value="3"/>
                                                </td>
                                                <td>
                                                </td>
                                                <td>
                                                    <span>Parental Influences: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_ParentalInfluences_N" name="RadioButton_CustomDocumentCANSModules_ParentalInfluences" value="N"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_ParentalInfluences_U" name="RadioButton_CustomDocumentCANSModules_ParentalInfluences" value="U"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_ParentalInfluences_0" name="RadioButton_CustomDocumentCANSModules_ParentalInfluences" value="0"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_ParentalInfluences_1" name="RadioButton_CustomDocumentCANSModules_ParentalInfluences" value="1"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_ParentalInfluences_2" name="RadioButton_CustomDocumentCANSModules_ParentalInfluences" value="2"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_ParentalInfluences_3" name="RadioButton_CustomDocumentCANSModules_ParentalInfluences" value="3"/>
                                                </td>
                                            </tr>
                                            <tr style="height: 10px">
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span>Peer Influences: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_PeerInfluences_N" name="RadioButton_CustomDocumentCANSModules_PeerInfluences" value="N"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_PeerInfluences_U" name="RadioButton_CustomDocumentCANSModules_PeerInfluences" value="U"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_PeerInfluences_0" name="RadioButton_CustomDocumentCANSModules_PeerInfluences" value="0"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_PeerInfluences_1" name="RadioButton_CustomDocumentCANSModules_PeerInfluences" value="1"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_PeerInfluences_2" name="RadioButton_CustomDocumentCANSModules_PeerInfluences" value="2"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_PeerInfluences_3" name="RadioButton_CustomDocumentCANSModules_PeerInfluences" value="3"/>
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
                    <tr id="TraumaModule">
                        <td colspan="4">
                            <table cellpadding="0" cellspacing="0" border="0" width="99%">
                                <tr>
                                    <td>
                                        <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                    <span id="Span2">Trauma Module</span>
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
                                                    <span id="Span3"><b>Scoring chart: 0= No Evidence of Problems, 1=History, Mild, 2=Moderate,
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
                                                    <span>Physical Abuse: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_PhysicalAbuse_N" name="RadioButton_CustomDocumentCANSModules_PhysicalAbuse" value="N"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_PhysicalAbuse_U" name="RadioButton_CustomDocumentCANSModules_PhysicalAbuse" value="U"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_PhysicalAbuse_0" name="RadioButton_CustomDocumentCANSModules_PhysicalAbuse" value="0"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_PhysicalAbuse_1" name="RadioButton_CustomDocumentCANSModules_PhysicalAbuse" value="1"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_PhysicalAbuse_2" name="RadioButton_CustomDocumentCANSModules_PhysicalAbuse" value="2"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_PhysicalAbuse_3" name="RadioButton_CustomDocumentCANSModules_PhysicalAbuse" value="3"/>
                                                </td>
                                                <td>
                                                </td>
                                                <td>
                                                    <span>Sexual Abuse: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_SexualAbuse_N" name="RadioButton_CustomDocumentCANSModules_SexualAbuse" value="N"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_SexualAbuse_U" name="RadioButton_CustomDocumentCANSModules_SexualAbuse" value="U"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_SexualAbuse_0" name="RadioButton_CustomDocumentCANSModules_SexualAbuse" value="0"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_SexualAbuse_1" name="RadioButton_CustomDocumentCANSModules_SexualAbuse" value="1"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_SexualAbuse_2" name="RadioButton_CustomDocumentCANSModules_SexualAbuse" value="2"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_SexualAbuse_3" name="RadioButton_CustomDocumentCANSModules_SexualAbuse" value="3"/>
                                                </td>
                                            </tr>
                                            <tr style="height: 10px">
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span>Emotional Abuse: </span>
                                                </td>
                                               <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_EmotionalAbuse_N" name="RadioButton_CustomDocumentCANSModules_EmotionalAbuse" value="N"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_EmotionalAbuse_U" name="RadioButton_CustomDocumentCANSModules_EmotionalAbuse" value="U"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_EmotionalAbuse_0" name="RadioButton_CustomDocumentCANSModules_EmotionalAbuse" value="0"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_EmotionalAbuse_1" name="RadioButton_CustomDocumentCANSModules_EmotionalAbuse" value="1"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_EmotionalAbuse_2" name="RadioButton_CustomDocumentCANSModules_EmotionalAbuse" value="2"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_EmotionalAbuse_3" name="RadioButton_CustomDocumentCANSModules_EmotionalAbuse" value="3"/>
                                                </td>
                                                <td>
                                                </td>
                                                <td>
                                                    <span>Medical Trauma: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_MedicalTrauma_N" name="RadioButton_CustomDocumentCANSModules_MedicalTrauma" value="N"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_MedicalTrauma_U" name="RadioButton_CustomDocumentCANSModules_MedicalTrauma" value="U"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_MedicalTrauma_0" name="RadioButton_CustomDocumentCANSModules_MedicalTrauma" value="0"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_MedicalTrauma_1" name="RadioButton_CustomDocumentCANSModules_MedicalTrauma" value="1"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_MedicalTrauma_2" name="RadioButton_CustomDocumentCANSModules_MedicalTrauma" value="2"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_MedicalTrauma_3" name="RadioButton_CustomDocumentCANSModules_MedicalTrauma" value="3"/>
                                                </td>
                                            </tr>
                                            <tr style="height: 10px">
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span>Witness to Family Violence: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_WitnessofViolence_N" name="RadioButton_CustomDocumentCANSModules_WitnessofViolence" value="N"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_WitnessofViolence_U" name="RadioButton_CustomDocumentCANSModules_WitnessofViolence" value="U"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_WitnessofViolence_0" name="RadioButton_CustomDocumentCANSModules_WitnessofViolence" value="0"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_WitnessofViolence_1" name="RadioButton_CustomDocumentCANSModules_WitnessofViolence" value="1"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_WitnessofViolence_2" name="RadioButton_CustomDocumentCANSModules_WitnessofViolence" value="2"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSModules_WitnessofViolence_3" name="RadioButton_CustomDocumentCANSModules_WitnessofViolence" value="3"/>
                                                </td>
                                                <td>
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
