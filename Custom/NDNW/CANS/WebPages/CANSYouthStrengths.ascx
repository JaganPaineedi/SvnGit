<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CANSYouthStrengths.ascx.cs" Inherits="SHS.SmartCare.CANSYouthStrengths" %>
<%--<%@ Register Assembly="Streamline.DotNetDropDownGlobalCodes" Namespace="Streamline.DotNetDropDownGlobalCodes"
    TagPrefix="DropDownGlobalCodes" %>--%>
<%--<%@ Register Assembly="Streamline.DotNetDropDowns" Namespace="Streamline.DotNetDropDowns"
    TagPrefix="cc2" %>--%>

<div class="DocumentScreen" style="padding-top: 5px">
    <table cellpadding="0" cellspacing="0" border="0" width="100%">
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
                <table width="100%" class="content_tab_bg" id="YouthStrengthTabTable">
                    <tr>
                        <td colspan="4">
                            <table cellpadding="0" cellspacing="0" border="0" width="99%" style="padding: 5px 0px 0px 0px">
                                <tr>
                                    <td>
                                        <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                                    <span id="Span1">Youth Strengths </span>
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
                                                    <span id="Spanchart"><b>Scoring chart: 0= No Evidence of Problems, 1=History, Mild, 2=Moderate, 3=Severe</b></span>
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
                                                    <span>Family:  </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_Family_N" name="RadioButton_CustomDocumentCANSYouthStrengths_Family" value="N"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_Family_U" name="RadioButton_CustomDocumentCANSYouthStrengths_Family" value="U"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_Family_0" name="RadioButton_CustomDocumentCANSYouthStrengths_Family" value="0"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_Family_1" name="RadioButton_CustomDocumentCANSYouthStrengths_Family" value="1"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_Family_2" name="RadioButton_CustomDocumentCANSYouthStrengths_Family" value="2"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_Family_3" name="RadioButton_CustomDocumentCANSYouthStrengths_Family" value="3"/>
                                                </td>
                                                <td>
                                                </td>
                                                <td>
                                                    <span>Interpersonal: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_Interpersonal_N" name="RadioButton_CustomDocumentCANSYouthStrengths_Interpersonal" value="N"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_Interpersonal_U" name="RadioButton_CustomDocumentCANSYouthStrengths_Interpersonal" value="U"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_Interpersonal_0" name="RadioButton_CustomDocumentCANSYouthStrengths_Interpersonal" value="0"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_Interpersonal_1" name="RadioButton_CustomDocumentCANSYouthStrengths_Interpersonal" value="1"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_Interpersonal_2" name="RadioButton_CustomDocumentCANSYouthStrengths_Interpersonal" value="2"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_Interpersonal_3" name="RadioButton_CustomDocumentCANSYouthStrengths_Interpersonal" value="3"/>
                                                </td>
                                            </tr>
                                            <tr style="height: 10px">
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span>Optimism: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_Optimism_N" name="RadioButton_CustomDocumentCANSYouthStrengths_Optimism" value="N"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_Optimism_U" name="RadioButton_CustomDocumentCANSYouthStrengths_Optimism" value="U"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_Optimism_0" name="RadioButton_CustomDocumentCANSYouthStrengths_Optimism" value="0"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_Optimism_1" name="RadioButton_CustomDocumentCANSYouthStrengths_Optimism" value="1"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_Optimism_2" name="RadioButton_CustomDocumentCANSYouthStrengths_Optimism" value="2"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_Optimism_3" name="RadioButton_CustomDocumentCANSYouthStrengths_Optimism" value="3"/>
                                                </td>
                                                <td>
                                                </td>
                                                <td>
                                                    <span>Resourcefulness: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_Resourcefulness_N" name="RadioButton_CustomDocumentCANSYouthStrengths_Resourcefulness" value="N"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_Resourcefulness_U" name="RadioButton_CustomDocumentCANSYouthStrengths_Resourcefulness" value="U"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_Resourcefulness_0" name="RadioButton_CustomDocumentCANSYouthStrengths_Resourcefulness" value="0"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_Resourcefulness_1" name="RadioButton_CustomDocumentCANSYouthStrengths_Resourcefulness" value="1"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_Resourcefulness_2" name="RadioButton_CustomDocumentCANSYouthStrengths_Resourcefulness" value="2"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_Resourcefulness_3" name="RadioButton_CustomDocumentCANSYouthStrengths_Resourcefulness" value="3"/>
                                                </td>
                                            </tr>
                                            <tr style="height: 10px">
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span>Vocational: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_Vocational_N" name="RadioButton_CustomDocumentCANSYouthStrengths_Vocational" value="N"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_Vocational_U" name="RadioButton_CustomDocumentCANSYouthStrengths_Vocational" value="U"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_Vocational_0" name="RadioButton_CustomDocumentCANSYouthStrengths_Vocational" value="0"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_Vocational_1" name="RadioButton_CustomDocumentCANSYouthStrengths_Vocational" value="1"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_Vocational_2" name="RadioButton_CustomDocumentCANSYouthStrengths_Vocational" value="2"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_Vocational_3" name="RadioButton_CustomDocumentCANSYouthStrengths_Vocational" value="3"/>
                                                </td>
                                                <td>
                                                </td>
                                                <td>
                                                    <span>Community Life: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_CommunityLife_N" name="RadioButton_CustomDocumentCANSYouthStrengths_CommunityLife" value="N"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_CommunityLife_U" name="RadioButton_CustomDocumentCANSYouthStrengths_CommunityLife" value="U"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_CommunityLife_0" name="RadioButton_CustomDocumentCANSYouthStrengths_CommunityLife" value="0"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_CommunityLife_1" name="RadioButton_CustomDocumentCANSYouthStrengths_CommunityLife" value="1"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_CommunityLife_2" name="RadioButton_CustomDocumentCANSYouthStrengths_CommunityLife" value="2"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_CommunityLife_3" name="RadioButton_CustomDocumentCANSYouthStrengths_CommunityLife" value="3"/>
                                                </td>
                                            </tr>
                                            <tr style="height: 10px">
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span>Resiliency: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_Resiliency_N" name="RadioButton_CustomDocumentCANSYouthStrengths_Resiliency" value="N"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_Resiliency_U" name="RadioButton_CustomDocumentCANSYouthStrengths_Resiliency" value="U"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_Resiliency_0" name="RadioButton_CustomDocumentCANSYouthStrengths_Resiliency" value="0"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_Resiliency_1" name="RadioButton_CustomDocumentCANSYouthStrengths_Resiliency" value="1"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_Resiliency_2" name="RadioButton_CustomDocumentCANSYouthStrengths_Resiliency" value="2"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_Resiliency_3" name="RadioButton_CustomDocumentCANSYouthStrengths_Resiliency" value="3"/>
                                                </td>
                                                <td>
                                                </td>
                                                <td>
                                                    <span>Talents/Interests: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_TalentInterests_N" name="RadioButton_CustomDocumentCANSYouthStrengths_TalentInterests" value="N"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_TalentInterests_U" name="RadioButton_CustomDocumentCANSYouthStrengths_TalentInterests" value="U"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_TalentInterests_0" name="RadioButton_CustomDocumentCANSYouthStrengths_TalentInterests" value="0"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_TalentInterests_1" name="RadioButton_CustomDocumentCANSYouthStrengths_TalentInterests" value="1"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_TalentInterests_2" name="RadioButton_CustomDocumentCANSYouthStrengths_TalentInterests" value="2"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_TalentInterests_3" name="RadioButton_CustomDocumentCANSYouthStrengths_TalentInterests" value="3"/>
                                                </td>
                                            </tr>
                                            <tr style="height: 10px">
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span>Educational: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_Educational_N" name="RadioButton_CustomDocumentCANSYouthStrengths_Educational" value="N"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_Educational_U" name="RadioButton_CustomDocumentCANSYouthStrengths_Educational" value="U"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_Educational_0" name="RadioButton_CustomDocumentCANSYouthStrengths_Educational" value="0"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_Educational_1" name="RadioButton_CustomDocumentCANSYouthStrengths_Educational" value="1"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_Educational_2" name="RadioButton_CustomDocumentCANSYouthStrengths_Educational" value="2"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_Educational_3" name="RadioButton_CustomDocumentCANSYouthStrengths_Educational" value="3"/>
                                                </td>
                                                <td>
                                                </td>
                                                <td>
                                                    <span>Spiritual/Religious: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_SpiritualReligious_N" name="RadioButton_CustomDocumentCANSYouthStrengths_SpiritualReligious" value="N"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_SpiritualReligious_U" name="RadioButton_CustomDocumentCANSYouthStrengths_SpiritualReligious" value="U"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_SpiritualReligious_0" name="RadioButton_CustomDocumentCANSYouthStrengths_SpiritualReligious" value="0"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_SpiritualReligious_1" name="RadioButton_CustomDocumentCANSYouthStrengths_SpiritualReligious" value="1"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_SpiritualReligious_2" name="RadioButton_CustomDocumentCANSYouthStrengths_SpiritualReligious" value="2"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_SpiritualReligious_3" name="RadioButton_CustomDocumentCANSYouthStrengths_SpiritualReligious" value="3"/>
                                                </td>
                                            </tr>
                                            <tr style="height: 10px">
                                            </tr>
                                            <tr>
                                                <td colspan="8">
                                                </td>
                                                <td>
                                                    <span>Relation Permanence: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_RelationPerformance_N" name="RadioButton_CustomDocumentCANSYouthStrengths_RelationPerformance" value="N"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_RelationPerformance_U" name="RadioButton_CustomDocumentCANSYouthStrengths_RelationPerformance" value="U"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_RelationPerformance_0" name="RadioButton_CustomDocumentCANSYouthStrengths_RelationPerformance" value="0"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_RelationPerformance_1" name="RadioButton_CustomDocumentCANSYouthStrengths_RelationPerformance" value="1"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_RelationPerformance_2" name="RadioButton_CustomDocumentCANSYouthStrengths_RelationPerformance" value="2"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_RelationPerformance_3" name="RadioButton_CustomDocumentCANSYouthStrengths_RelationPerformance" value="3"/>
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
                                                    <span id="Span2">Risk Behaviors</span>
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
                                                    <span id="Span3"><b>Scoring chart: 0= No Evidence of Problems, 1=History, Mild, 2=Moderate, 3=Severe</b></span>
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
                                                    <span>Danger to Self: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_DangertoSelf_N" name="RadioButton_CustomDocumentCANSYouthStrengths_DangertoSelf" value="N"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_DangertoSelf_U" name="RadioButton_CustomDocumentCANSYouthStrengths_DangertoSelf" value="U"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_DangertoSelf_0" name="RadioButton_CustomDocumentCANSYouthStrengths_DangertoSelf" value="0"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_DangertoSelf_1" name="RadioButton_CustomDocumentCANSYouthStrengths_DangertoSelf" value="1"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_DangertoSelf_2" name="RadioButton_CustomDocumentCANSYouthStrengths_DangertoSelf" value="2"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_DangertoSelf_3" name="RadioButton_CustomDocumentCANSYouthStrengths_DangertoSelf" value="3"/>
                                                </td>
                                                <td>
                                                </td>
                                                <td>
                                                    <span>Danger to Others: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_DangertoOthers_N" name="RadioButton_CustomDocumentCANSYouthStrengths_DangertoOthers" value="N"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_DangertoOthers_U" name="RadioButton_CustomDocumentCANSYouthStrengths_DangertoOthers" value="U"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_DangertoOthers_0" name="RadioButton_CustomDocumentCANSYouthStrengths_DangertoOthers" value="0"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_DangertoOthers_1" name="RadioButton_CustomDocumentCANSYouthStrengths_DangertoOthers" value="1"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_DangertoOthers_2" name="RadioButton_CustomDocumentCANSYouthStrengths_DangertoOthers" value="2"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_DangertoOthers_3" name="RadioButton_CustomDocumentCANSYouthStrengths_DangertoOthers" value="3"/>
                                                </td>
                                            </tr>
                                            <tr style="height: 10px">
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span>Violent Thinking: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_ViolentThinking_N" name="RadioButton_CustomDocumentCANSYouthStrengths_ViolentThinking" value="N"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_ViolentThinking_U" name="RadioButton_CustomDocumentCANSYouthStrengths_ViolentThinking" value="U"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_ViolentThinking_0" name="RadioButton_CustomDocumentCANSYouthStrengths_ViolentThinking" value="0"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_ViolentThinking_1" name="RadioButton_CustomDocumentCANSYouthStrengths_ViolentThinking" value="1"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_ViolentThinking_2" name="RadioButton_CustomDocumentCANSYouthStrengths_ViolentThinking" value="2"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_ViolentThinking_3" name="RadioButton_CustomDocumentCANSYouthStrengths_ViolentThinking" value="3"/>
                                                </td>
                                                <td>
                                                </td>
                                                <td>
                                                    <span>Crime/Delinquency: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_CrimeDelinquency_N" name="RadioButton_CustomDocumentCANSYouthStrengths_CrimeDelinquency" value="N"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_CrimeDelinquency_U" name="RadioButton_CustomDocumentCANSYouthStrengths_CrimeDelinquency" value="U"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_CrimeDelinquency_0" name="RadioButton_CustomDocumentCANSYouthStrengths_CrimeDelinquency" value="0"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_CrimeDelinquency_1" name="RadioButton_CustomDocumentCANSYouthStrengths_CrimeDelinquency" value="1"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_CrimeDelinquency_2" name="RadioButton_CustomDocumentCANSYouthStrengths_CrimeDelinquency" value="2"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_CrimeDelinquency_3" name="RadioButton_CustomDocumentCANSYouthStrengths_CrimeDelinquency" value="3"/>
                                                </td>
                                            </tr>
                                            <tr style="height: 10px">
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span>Elopement: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_Elopement_N" name="RadioButton_CustomDocumentCANSYouthStrengths_Elopement" value="N"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_Elopement_U" name="RadioButton_CustomDocumentCANSYouthStrengths_Elopement" value="U"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_Elopement_0" name="RadioButton_CustomDocumentCANSYouthStrengths_Elopement" value="0"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_Elopement_1" name="RadioButton_CustomDocumentCANSYouthStrengths_Elopement" value="1"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_Elopement_2" name="RadioButton_CustomDocumentCANSYouthStrengths_Elopement" value="2"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_Elopement_3" name="RadioButton_CustomDocumentCANSYouthStrengths_Elopement" value="3"/>
                                                </td>
                                                <td>
                                                </td>
                                                <td>
                                                    <span>Commitment to Self-Control: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_Commitment_N" name="RadioButton_CustomDocumentCANSYouthStrengths_Commitment" value="N"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_Commitment_U" name="RadioButton_CustomDocumentCANSYouthStrengths_Commitment" value="U"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_Commitment_0" name="RadioButton_CustomDocumentCANSYouthStrengths_Commitment" value="0"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_Commitment_1" name="RadioButton_CustomDocumentCANSYouthStrengths_Commitment" value="1"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_Commitment_2" name="RadioButton_CustomDocumentCANSYouthStrengths_Commitment" value="2"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_Commitment_3" name="RadioButton_CustomDocumentCANSYouthStrengths_Commitment" value="3"/>
                                                </td>
                                            </tr>
                                            <tr style="height: 10px">
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span>Social Behavior: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_SocialBehavior_N" name="RadioButton_CustomDocumentCANSYouthStrengths_SocialBehavior" value="N"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_SocialBehavior_U" name="RadioButton_CustomDocumentCANSYouthStrengths_SocialBehavior" value="U"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_SocialBehavior_0" name="RadioButton_CustomDocumentCANSYouthStrengths_SocialBehavior" value="0"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_SocialBehavior_1" name="RadioButton_CustomDocumentCANSYouthStrengths_SocialBehavior" value="1"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_SocialBehavior_2" name="RadioButton_CustomDocumentCANSYouthStrengths_SocialBehavior" value="2"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_SocialBehavior_3" name="RadioButton_CustomDocumentCANSYouthStrengths_SocialBehavior" value="3"/>
                                                </td>
                                                <td>
                                                </td>
                                                <td>
                                                    <span>Sexually Abusive Behavior: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_SexuallyAbusive_N" name="RadioButton_CustomDocumentCANSYouthStrengths_SexuallyAbusive" value="N"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_SexuallyAbusive_U" name="RadioButton_CustomDocumentCANSYouthStrengths_SexuallyAbusive" value="U"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_SexuallyAbusive_0" name="RadioButton_CustomDocumentCANSYouthStrengths_SexuallyAbusive" value="0"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_SexuallyAbusive_1" name="RadioButton_CustomDocumentCANSYouthStrengths_SexuallyAbusive" value="1"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_SexuallyAbusive_2" name="RadioButton_CustomDocumentCANSYouthStrengths_SexuallyAbusive" value="2"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_SexuallyAbusive_3" name="RadioButton_CustomDocumentCANSYouthStrengths_SexuallyAbusive" value="3"/>
                                                </td>
                                            </tr>
                                            <tr style="height: 10px">
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span>Other Self Harm: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_OtherSelfHarm_N" name="RadioButton_CustomDocumentCANSYouthStrengths_OtherSelfHarm" value="N"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_OtherSelfHarm_U" name="RadioButton_CustomDocumentCANSYouthStrengths_OtherSelfHarm" value="U"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_OtherSelfHarm_0" name="RadioButton_CustomDocumentCANSYouthStrengths_OtherSelfHarm" value="0"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_OtherSelfHarm_1" name="RadioButton_CustomDocumentCANSYouthStrengths_OtherSelfHarm" value="1"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_OtherSelfHarm_2" name="RadioButton_CustomDocumentCANSYouthStrengths_OtherSelfHarm" value="2"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_OtherSelfHarm_3" name="RadioButton_CustomDocumentCANSYouthStrengths_OtherSelfHarm" value="3"/>
                                                </td>
                                                <td>
                                                </td>
                                                <td>
                                                    <span>School Behavior: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_SchoolBehavior_N" name="RadioButton_CustomDocumentCANSYouthStrengths_SchoolBehavior" value="N"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_SchoolBehavior_U" name="RadioButton_CustomDocumentCANSYouthStrengths_SchoolBehavior" value="U"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_SchoolBehavior_0" name="RadioButton_CustomDocumentCANSYouthStrengths_SchoolBehavior" value="0"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_SchoolBehavior_1" name="RadioButton_CustomDocumentCANSYouthStrengths_SchoolBehavior" value="1"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_SchoolBehavior_2" name="RadioButton_CustomDocumentCANSYouthStrengths_SchoolBehavior" value="2"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_SchoolBehavior_3" name="RadioButton_CustomDocumentCANSYouthStrengths_SchoolBehavior" value="3"/>
                                                </td>
                                            </tr>
                                            <tr style="height: 10px">
                                            </tr>
                                            <tr>
                                                <td colspan="8">
                                                </td>
                                                <td>
                                                    <span>Sexual Development: </span>
                                                </td>
                                                <td style="width: 30px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_SexualDevelopment_N" name="RadioButton_CustomDocumentCANSYouthStrengths_SexualDevelopment" value="N"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_SexualDevelopment_U" name="RadioButton_CustomDocumentCANSYouthStrengths_SexualDevelopment" value="U"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_SexualDevelopment_0" name="RadioButton_CustomDocumentCANSYouthStrengths_SexualDevelopment" value="0"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_SexualDevelopment_1" name="RadioButton_CustomDocumentCANSYouthStrengths_SexualDevelopment" value="1"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_SexualDevelopment_2" name="RadioButton_CustomDocumentCANSYouthStrengths_SexualDevelopment" value="2"/>
                                                </td>
                                                <td style="width: 25px;">
                                                    <input type="radio" id="RadioButton_CustomDocumentCANSYouthStrengths_SexualDevelopment_3" name="RadioButton_CustomDocumentCANSYouthStrengths_SexualDevelopment" value="3"/>
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
