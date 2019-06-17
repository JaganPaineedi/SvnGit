<%@ Control Language="C#" AutoEventWireup="true" CodeFile="InfectiousDiseaseRiskAssessment.ascx.cs"
    Inherits="Custom_SUAdmission_WebPages_InfectiousDiseaseRiskAssessment" %>
<% if (HttpContext.Current == null)
   { %>
<link href="../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet" type="text/css" />
<%} %>
<%@ Register Assembly="Streamline.DotNetDropDownGlobalCodes" Namespace="Streamline.DotNetDropDownGlobalCodes"
    TagPrefix="cc2" %>
<div>
    <table border="0" cellpadding="0" cellspacing="0" class="DocumentScreen">
        <tr>
            <td class="height2">
            </td>
        </tr>
        <tr>
            <td>
                <table width="98%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td class="height1">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="content_tab_left" nowrap='nowrap'>
                                        General
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
                        <td class="content_tab_bg" style="padding-left: 10px">
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr>
                                                <td style="width: 80%">
                                                    Have you seen a doctor or other health care provider in the past 3 months?
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_AnyHealthCareProvider_Y"
                                                        value="Y" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_AnyHealthCareProvider"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_AnyHealthCareProvider_Y"
                                                        style="cursor: default">
                                                        Yes</label>
                                                </td>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_AnyHealthCareProvider_N"
                                                        value="N" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_AnyHealthCareProvider"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_AnyHealthCareProvider_N"
                                                        style="cursor: default">
                                                        No</label>
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_AnyHealthCareProvider_U"
                                                        value="U" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_AnyHealthCareProvider"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_AnyHealthCareProvider_U"
                                                        style="cursor: default">
                                                        Don't Know</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Do you live or have you lived on the street or in a shelter?
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_LivedStreetOrShelter_Y"
                                                        value="Y" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_LivedStreetOrShelter"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_LivedStreetOrShelter_Y"
                                                        style="cursor: default">
                                                        Yes</label>
                                                </td>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_LivedStreetOrShelter_N"
                                                        value="N" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_LivedStreetOrShelter"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_LivedStreetOrShelter_N"
                                                        style="cursor: default">
                                                        No</label>
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_LivedStreetOrShelter_U"
                                                        value="U" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_LivedStreetOrShelter"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_LivedStreetOrShelter_U"
                                                        style="cursor: default">
                                                        Don't Know</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Have you ever been in jail/prison/juvenile detention?
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenJailPrisonJuvenile_Y"
                                                        value="Y" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenJailPrisonJuvenile"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenJailPrisonJuvenile_Y"
                                                        style="cursor: default">
                                                        Yes</label>
                                                </td>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenJailPrisonJuvenile_N"
                                                        value="N" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenJailPrisonJuvenile"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenJailPrisonJuvenile_N"
                                                        style="cursor: default">
                                                        No</label>
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenJailPrisonJuvenile_U"
                                                        value="U" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenJailPrisonJuvenile"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenJailPrisonJuvenile_U"
                                                        style="cursor: default">
                                                        Don't Know</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Have you ever been in a long-term care facility (nursing home, mental health hospital,
                                                    or other hospital)?
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenCareFacility_Y"
                                                        value="Y" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenCareFacility"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenCareFacility_Y"
                                                        style="cursor: default">
                                                        Yes</label>
                                                </td>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenCareFacility_N"
                                                        value="N" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenCareFacility"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenCareFacility_N"
                                                        style="cursor: default">
                                                        No</label>
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenCareFacility_U"
                                                        value="U" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenCareFacility"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenCareFacility_U"
                                                        style="cursor: default">
                                                        Don't Know</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Where were you born?
                                                    <input class="form_textbox" type="text" name="TextBox_CustomDocumentInfectiousDiseaseRiskAssessments_WhereBorn"
                                                        maxlength="100" id="TextBox_CustomDocumentInfectiousDiseaseRiskAssessments_WhereBorn"
                                                        style="width: 150px;" />
                                                </td>
                                                <%-- <td>
                                                    <input class="form_textbox" type="text" name="TextBox_CustomDocumentInfectiousDiseaseRiskAssessments_WhereBorn"
                                                        maxlength="100" id="TextBox_CustomDocumentInfectiousDiseaseRiskAssessments_WhereBorn"
                                                        style="width: 150px;" />
                                                </td>--%>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    In the past 3 years have you traveled/lived outside the U.S. (except Canada, Australia,
                                                    New Zealand, Japan, Western Europe, or Great Britain)?
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_TraveledOrLivedOutsideUS_Y"
                                                        value="Y" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_TraveledOrLivedOutsideUS"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_TraveledOrLivedOutsideUS_Y"
                                                        style="cursor: default">
                                                        Yes</label>
                                                </td>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_TraveledOrLivedOutsideUS_N"
                                                        value="N" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_TraveledOrLivedOutsideUS"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_TraveledOrLivedOutsideUS_N"
                                                        style="cursor: default">
                                                        No</label>
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_TraveledOrLivedOutsideUS_U"
                                                        value="U" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_TraveledOrLivedOutsideUS"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_TraveledOrLivedOutsideUS_U"
                                                        style="cursor: default">
                                                        Don't Know</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    How long have you been in the U.S.?
                                                    <input class="form_textbox" type="text" name="TextBox_CustomDocumentInfectiousDiseaseRiskAssessments_HowLongBeenInUS"
                                                        maxlength="100" id="TextBox_CustomDocumentInfectiousDiseaseRiskAssessments_HowLongBeenInUS"
                                                        style="width: 75px;" />
                                                </td>
                                                <%--<td>
                                                    <input class="form_textbox" type="text" name="TextBox_CustomDocumentInfectiousDiseaseRiskAssessments_HowLongBeenInUS"
                                                        maxlength="100" id="TextBox_CustomDocumentInfectiousDiseaseRiskAssessments_HowLongBeenInUS"
                                                        style="width: 150px;" />
                                                </td>--%>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Are you a combat veteran?
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_CombatVeteran_Y"
                                                        value="Y" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_CombatVeteran"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_CombatVeteran_Y"
                                                        style="cursor: default">
                                                        Yes</label>
                                                </td>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_CombatVeteran_N"
                                                        value="N" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_CombatVeteran"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_CombatVeteran_N"
                                                        style="cursor: default">
                                                        No</label>
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_CombatVeteran_U"
                                                        value="U" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_CombatVeteran"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_CombatVeteran_U"
                                                        style="cursor: default">
                                                        Don't Know</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    In the past 12 months have you had a tattoo, ear/body piercing, acupuncture or come
                                                    into contact with someone else’s blood?
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_HadTatooEarPiercingAcupunture_Y"
                                                        value="Y" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_HadTatooEarPiercingAcupunture"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_HadTatooEarPiercingAcupunture_Y"
                                                        style="cursor: default">
                                                        Yes</label>
                                                </td>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_HadTatooEarPiercingAcupunture_N"
                                                        value="N" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_HadTatooEarPiercingAcupunture"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_HadTatooEarPiercingAcupunture_N"
                                                        style="cursor: default">
                                                        No</label>
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_HadTatooEarPiercingAcupunture_U"
                                                        value="U" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_HadTatooEarPiercingAcupunture"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_HadTatooEarPiercingAcupunture_U"
                                                        style="cursor: default">
                                                        Don't Know</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height1">
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2">
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
                        <td class="height2">
                        </td>
                    </tr>
                    <tr>
                        <td class="height2">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="content_tab_left" nowrap='nowrap'>
                                        TB Questions
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
                        <td class="content_tab_bg" style="padding-left: 10px">
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr>
                                                <td style="width: 80%">
                                                    Have you ever been told you have TB? Has anybody you know or have lived with been
                                                    diagnosed with TB in the past year?
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenToldYouHaveTB_Y"
                                                        value="Y" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenToldYouHaveTB"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenToldYouHaveTB_Y"
                                                        style="cursor: default">
                                                        Yes</label>
                                                </td>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenToldYouHaveTB_N"
                                                        value="N" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenToldYouHaveTB"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenToldYouHaveTB_N"
                                                        style="cursor: default">
                                                        No</label>
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenToldYouHaveTB_U"
                                                        value="U" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenToldYouHaveTB"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenToldYouHaveTB_U"
                                                        style="cursor: default">
                                                        Don't Know</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Have you ever had a positive skin test for TB? (A test where they gave you a shot
                                                    in your forearm, and a few days later a hard lump appeared.)
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenHadPositiveSkinTestTB_Y"
                                                        value="Y" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenHadPositiveSkinTestTB"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenHadPositiveSkinTestTB_Y"
                                                        style="cursor: default">
                                                        Yes</label>
                                                </td>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenHadPositiveSkinTestTB_N"
                                                        value="N" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenHadPositiveSkinTestTB"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenHadPositiveSkinTestTB_N"
                                                        style="cursor: default">
                                                        No</label>
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenHadPositiveSkinTestTB_U"
                                                        value="U" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenHadPositiveSkinTestTB"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenHadPositiveSkinTestTB_U"
                                                        style="cursor: default">
                                                        Don't Know</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Have you ever been treated for TB?
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenTreatedForTB_Y"
                                                        value="Y" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenTreatedForTB"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenTreatedForTB_Y"
                                                        style="cursor: default">
                                                        Yes</label>
                                                </td>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenTreatedForTB_N"
                                                        value="N" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenTreatedForTB"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenTreatedForTB_N"
                                                        style="cursor: default">
                                                        No</label>
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenTreatedForTB_U"
                                                        value="U" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenTreatedForTB"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenTreatedForTB_U"
                                                        style="cursor: default">
                                                        Don't Know</label>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2">
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
                        <td class="height2">
                        </td>
                    </tr>
                    <tr>
                        <td class="height2">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="content_tab_left" nowrap='nowrap'>
                                        Symptoms
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
                        <td class="content_tab_bg" style="padding-left: 10px">
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr>
                                                <td>
                                                    Within the last 30 days, have you had any of the following symptoms lasting for
                                                    more than 2 weeks:
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="padding-left: 15px">
                                                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                        <tr class="checkbox_container">
                                                            <td style="width: 14%" valign="top">
                                                                <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentInfectiousDiseaseRiskAssessments_Nausea"
                                                                    name="CheckBox_CustomDocumentInfectiousDiseaseRiskAssessments_Nausea" />
                                                                <label for="CheckBox_CustomDocumentInfectiousDiseaseRiskAssessments_Nausea">
                                                                    Nausea</label>
                                                            </td>
                                                            <td width="1%">
                                                                &nbsp;
                                                            </td>
                                                            <td style="width: 9%" valign="top">
                                                                <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentInfectiousDiseaseRiskAssessments_Fever"
                                                                    name="CheckBox_CustomDocumentInfectiousDiseaseRiskAssessments_Fever" />
                                                                <label for="CheckBox_CustomDocumentInfectiousDiseaseRiskAssessments_Fever">
                                                                    Fever
                                                                </label>
                                                            </td>
                                                            <td width="1%">
                                                                &nbsp;
                                                            </td>
                                                            <td style="width: 19%" valign="bottom">
                                                                <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentInfectiousDiseaseRiskAssessments_DrenchingNightSweats"
                                                                    name="CheckBox_CustomDocumentInfectiousDiseaseRiskAssessments_DrenchingNightSweats" />
                                                                <label for="CheckBox_CustomDocumentInfectiousDiseaseRiskAssessments_DrenchingNightSweats">
                                                                    Drenching night sweats that were so bad you had to change your clothes or the sheets
                                                                    on the bed
                                                                </label>
                                                            </td>
                                                            <td width="1%">
                                                                &nbsp;
                                                            </td>
                                                            <td style="width: 17%" valign="top">
                                                                <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentInfectiousDiseaseRiskAssessments_DiarrheaLastingMoreThanWeek"
                                                                    name="CheckBox_CustomDocumentInfectiousDiseaseRiskAssessments_DiarrheaLastingMoreThanWeek" />
                                                                <label for="CheckBox_CustomDocumentInfectiousDiseaseRiskAssessments_DiarrheaLastingMoreThanWeek">
                                                                    Diarrhea (runs) lasting more than a week
                                                                </label>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr class="checkbox_container">
                                                            <td valign="top">
                                                                <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentInfectiousDiseaseRiskAssessments_CoughingUpBlood"
                                                                    name="CheckBox_CustomDocumentInfectiousDiseaseRiskAssessments_CoughingUpBlood" />
                                                                <label for="CheckBox_CustomDocumentInfectiousDiseaseRiskAssessments_CoughingUpBlood">
                                                                    Coughing up blood</label>
                                                            </td>
                                                            <td width="8px">
                                                                &nbsp;
                                                            </td>
                                                            <td valign="top">
                                                                <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentInfectiousDiseaseRiskAssessments_ShortnessOfBreath"
                                                                    name="CheckBox_CustomDocumentInfectiousDiseaseRiskAssessments_ShortnessOfBreath" />
                                                                <label for="CheckBox_CustomDocumentInfectiousDiseaseRiskAssessments_ShortnessOfBreath">
                                                                    Shortness of breath
                                                                </label>
                                                            </td>
                                                            <td width="8px">
                                                                &nbsp;
                                                            </td>
                                                            <td valign="top">
                                                                <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentInfectiousDiseaseRiskAssessments_LumpsSwollenGlands"
                                                                    name="CheckBox_CustomDocumentInfectiousDiseaseRiskAssessments_LumpsSwollenGlands" />
                                                                <label for="CheckBox_CustomDocumentInfectiousDiseaseRiskAssessments_LumpsSwollenGlands">
                                                                    Lumps or swollen glands in the neck or armpits
                                                                </label>
                                                            </td>
                                                            <td width="8px">
                                                                &nbsp;
                                                            </td>
                                                            <td valign="top">
                                                                <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentInfectiousDiseaseRiskAssessments_ProductiveCough"
                                                                    name="CheckBox_CustomDocumentInfectiousDiseaseRiskAssessments_ProductiveCough" />
                                                                <label for="CheckBox_CustomDocumentInfectiousDiseaseRiskAssessments_ProductiveCough">
                                                                    Productive cough
                                                                </label>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr class="checkbox_container">
                                                            <td valign="top" width="10px">
                                                                <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentInfectiousDiseaseRiskAssessments_LosingWeightWithoutMeaning"
                                                                    name="CheckBox_CustomDocumentInfectiousDiseaseRiskAssessments_LosingWeightWithoutMeaning" />
                                                                <label for="CheckBox_CustomDocumentInfectiousDiseaseRiskAssessments_LosingWeightWithoutMeaning">
                                                                    Losing weight without meaning to
                                                                </label>
                                                            </td>
                                                            <td width="8px">
                                                                &nbsp;
                                                            </td>
                                                            <td valign="top">
                                                                <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentInfectiousDiseaseRiskAssessments_BrownTingedUrine"
                                                                    name="CheckBox_CustomDocumentInfectiousDiseaseRiskAssessments_BrownTingedUrine" />
                                                                <label for="CheckBox_CustomDocumentInfectiousDiseaseRiskAssessments_BrownTingedUrine">
                                                                    Brown tinged urine
                                                                </label>
                                                            </td>
                                                            <td width="8px">
                                                                &nbsp;
                                                            </td>
                                                            <td valign="top">
                                                                <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentInfectiousDiseaseRiskAssessments_ExtremeFatigue"
                                                                    name="CheckBox_CustomDocumentInfectiousDiseaseRiskAssessments_ExtremeFatigue" />
                                                                <label for="CheckBox_CustomDocumentInfectiousDiseaseRiskAssessments_ExtremeFatigue">
                                                                    Extreme fatigue
                                                                </label>
                                                            </td>
                                                            <td width="8px">
                                                                &nbsp;
                                                            </td>
                                                            <td valign="top">
                                                                <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentInfectiousDiseaseRiskAssessments_Jaundice"
                                                                    name="CheckBox_CustomDocumentInfectiousDiseaseRiskAssessments_Jaundice" />
                                                                <label for="CheckBox_CustomDocumentInfectiousDiseaseRiskAssessments_Jaundice">
                                                                    Jaundice (yellow skin) or yellow eyes
                                                                </label>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr class="checkbox_container">
                                                            <td valign="top">
                                                                <input class="cursor_default" type="checkbox" id="CheckBox_CustomDocumentInfectiousDiseaseRiskAssessments_NoSymptoms"
                                                                    name="CheckBox_CustomDocumentInfectiousDiseaseRiskAssessments_NoSymptoms" />
                                                                <label for="CheckBox_CustomDocumentInfectiousDiseaseRiskAssessments_NoSymptoms">
                                                                    None
                                                                </label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                        <tr>
                                                            <td style="width: 40%">
                                                                Women: Have you missed your last two periods?
                                                            </td>
                                                            <td align="left">
                                                                <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_MissedLastTwoPeriods_Y"
                                                                    value="Y" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_MissedLastTwoPeriods"
                                                                    style="cursor: default" />
                                                            </td>
                                                            <td>
                                                                <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_MissedLastTwoPeriods_Y"
                                                                    style="cursor: default">
                                                                    Yes</label>
                                                            </td>
                                                            <td>
                                                                <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_MissedLastTwoPeriods_N"
                                                                    value="N" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_MissedLastTwoPeriods"
                                                                    style="cursor: default" />
                                                            </td>
                                                            <td>
                                                                <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_MissedLastTwoPeriods_N"
                                                                    style="cursor: default">
                                                                    No</label>
                                                            </td>
                                                            <td align="left">
                                                                <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_MissedLastTwoPeriods_A"
                                                                    value="A" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_MissedLastTwoPeriods"
                                                                    style="cursor: default" />
                                                            </td>
                                                            <td>
                                                                <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_MissedLastTwoPeriods_A"
                                                                    style="cursor: default">
                                                                    N/A</label>
                                                            </td>
                                                            <td>
                                                                <input class="form_textbox" type="text" name="TextBox_CustomDocumentInfectiousDiseaseRiskAssessments_WomanMissedLast2Periods"
                                                                    maxlength="100" id="TextBox_CustomDocumentInfectiousDiseaseRiskAssessments_WomanMissedLast2Periods"
                                                                    style="width: 150px;" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
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
                        <td class="height2">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="content_tab_left" nowrap='nowrap'>
                                        Hepatitis
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
                        <td class="content_tab_bg" style="padding-left: 10px">
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr>
                                                <td style="width: 80%">
                                                    Have you ever been told you have Hepatitis A?
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenToldYouHaveHepatitisA_Y"
                                                        value="Y" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenToldYouHaveHepatitisA"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenToldYouHaveHepatitisA_Y"
                                                        style="cursor: default">
                                                        Yes</label>
                                                </td>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenToldYouHaveHepatitisA_N"
                                                        value="N" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenToldYouHaveHepatitisA"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenToldYouHaveHepatitisA_N"
                                                        style="cursor: default">
                                                        No</label>
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenToldYouHaveHepatitisA_U"
                                                        value="U" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenToldYouHaveHepatitisA"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenToldYouHaveHepatitisA_U"
                                                        style="cursor: default">
                                                        Don't Know</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Have you ever been told you have Hepatitis B?
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenToldYouHaveHepatitisB_Y"
                                                        value="Y" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenToldYouHaveHepatitisB"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenToldYouHaveHepatitisB_Y"
                                                        style="cursor: default">
                                                        Yes</label>
                                                </td>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenToldYouHaveHepatitisB_N"
                                                        value="N" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenToldYouHaveHepatitisB"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenToldYouHaveHepatitisB_N"
                                                        style="cursor: default">
                                                        No</label>
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenToldYouHaveHepatitisB_U"
                                                        value="U" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenToldYouHaveHepatitisB"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenToldYouHaveHepatitisB_U"
                                                        style="cursor: default">
                                                        Don't Know</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Have you ever been told you have Hepatitis C?
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenToldYouHaveHepatitisC_Y"
                                                        value="Y" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenToldYouHaveHepatitisC"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenToldYouHaveHepatitisC_Y"
                                                        style="cursor: default">
                                                        Yes</label>
                                                </td>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenToldYouHaveHepatitisC_N"
                                                        value="N" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenToldYouHaveHepatitisC"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenToldYouHaveHepatitisC_N"
                                                        style="cursor: default">
                                                        No</label>
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenToldYouHaveHepatitisC_U"
                                                        value="U" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenToldYouHaveHepatitisC"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenToldYouHaveHepatitisC_U"
                                                        style="cursor: default">
                                                        Don't Know</label>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2">
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
                        <td class="height2">
                        </td>
                    </tr>
                    <tr>
                        <td class="height2">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="content_tab_left" nowrap='nowrap'>
                                        Drug/Sexual Related Questions
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
                        <td class="content_tab_bg" style="padding-left: 10px">
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr>
                                                <td style="width: 80%">
                                                    Have you ever used needles to shoot drugs?
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverUsedNeedlesToShootDrugs_Y"
                                                        value="Y" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverUsedNeedlesToShootDrugs"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverUsedNeedlesToShootDrugs_Y"
                                                        style="cursor: default">
                                                        Yes</label>
                                                </td>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverUsedNeedlesToShootDrugs_N"
                                                        value="N" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverUsedNeedlesToShootDrugs"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverUsedNeedlesToShootDrugs_N"
                                                        style="cursor: default">
                                                        No</label>
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverUsedNeedlesToShootDrugs_U"
                                                        value="U" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverUsedNeedlesToShootDrugs"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverUsedNeedlesToShootDrugs_U"
                                                        style="cursor: default">
                                                        Don't Know</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Have you ever shared needles or syringes (“rigs”) to inject drugs?
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverSharedNeedlesSyringesToInjectDrugs_Y"
                                                        value="Y" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverSharedNeedlesSyringesToInjectDrugs"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverSharedNeedlesSyringesToInjectDrugs_Y"
                                                        style="cursor: default">
                                                        Yes</label>
                                                </td>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverSharedNeedlesSyringesToInjectDrugs_N"
                                                        value="N" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverSharedNeedlesSyringesToInjectDrugs"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverSharedNeedlesSyringesToInjectDrugs_N"
                                                        style="cursor: default">
                                                        No</label>
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverSharedNeedlesSyringesToInjectDrugs_U"
                                                        value="U" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverSharedNeedlesSyringesToInjectDrugs"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverSharedNeedlesSyringesToInjectDrugs_U"
                                                        style="cursor: default">
                                                        Don't Know</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Have you ever had a job that put you in danger of needle stick injuries or other
                                                    types of blood contact?
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverHadNeedleStickInjuriesOrBloodContact_Y"
                                                        value="Y" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverHadNeedleStickInjuriesOrBloodContact"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverHadNeedleStickInjuriesOrBloodContact_Y"
                                                        style="cursor: default">
                                                        Yes</label>
                                                </td>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverHadNeedleStickInjuriesOrBloodContact_N"
                                                        value="N" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverHadNeedleStickInjuriesOrBloodContact"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverHadNeedleStickInjuriesOrBloodContact_N"
                                                        style="cursor: default">
                                                        No</label>
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverHadNeedleStickInjuriesOrBloodContact_U"
                                                        value="U" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverHadNeedleStickInjuriesOrBloodContact"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverHadNeedleStickInjuriesOrBloodContact_U"
                                                        style="cursor: default">
                                                        Don't Know</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Do you use stimulants (cocaine/methamphetamine)?
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_UseStimulants_Y"
                                                        value="Y" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_UseStimulants"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_UseStimulants_Y"
                                                        style="cursor: default">
                                                        Yes</label>
                                                </td>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_UseStimulants_N"
                                                        value="N" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_UseStimulants"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_UseStimulants_N"
                                                        style="cursor: default">
                                                        No</label>
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_UseStimulants_U"
                                                        value="U" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_UseStimulants"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_UseStimulants_U"
                                                        style="cursor: default">
                                                        Don't Know</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    In the past 12 months, have you, or anyone you have had sex with, had: syphilis,
                                                    gonorrhea, herpes, Chlamydia, nongonoccal urethritis, other sexually transmitted
                                                    diseases, or hepatitis?
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_PastTwelveMonthsHadSexWithAnyWithHepatitis_Y"
                                                        value="Y" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_PastTwelveMonthsHadSexWithAnyWithHepatitis"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_PastTwelveMonthsHadSexWithAnyWithHepatitis_Y"
                                                        style="cursor: default">
                                                        Yes</label>
                                                </td>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_PastTwelveMonthsHadSexWithAnyWithHepatitis_N"
                                                        value="N" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_PastTwelveMonthsHadSexWithAnyWithHepatitis"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_PastTwelveMonthsHadSexWithAnyWithHepatitis_N"
                                                        style="cursor: default">
                                                        No</label>
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_PastTwelveMonthsHadSexWithAnyWithHepatitis_U"
                                                        value="U" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_PastTwelveMonthsHadSexWithAnyWithHepatitis"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_PastTwelveMonthsHadSexWithAnyWithHepatitis_U"
                                                        style="cursor: default">
                                                        Don't Know</label>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2">
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
                        <td class="height2">
                        </td>
                    </tr>
                    <tr>
                        <td class="height2">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="content_tab_left" nowrap='nowrap'>
                                        Additional Questions
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
                        <td class="content_tab_bg" style="padding-left: 10px">
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr>
                                                <td style="width: 80%">
                                                    Did you receive a blood transfusion before 1992?
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_ReceiveBloodTransfusionBefore1992_Y"
                                                        value="Y" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_ReceiveBloodTransfusionBefore1992"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_ReceiveBloodTransfusionBefore1992_Y"
                                                        style="cursor: default">
                                                        Yes</label>
                                                </td>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_ReceiveBloodTransfusionBefore1992_N"
                                                        value="N" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_ReceiveBloodTransfusionBefore1992"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_ReceiveBloodTransfusionBefore1992_N"
                                                        style="cursor: default">
                                                        No</label>
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_ReceiveBloodTransfusionBefore1992_U"
                                                        value="U" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_ReceiveBloodTransfusionBefore1992"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_ReceiveBloodTransfusionBefore1992_U"
                                                        style="cursor: default">
                                                        Don't Know</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Have you received blood products produced before 1987 for clotting problems?
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_ReceivedBloodProductsBefore1987_Y"
                                                        value="Y" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_ReceivedBloodProductsBefore1987"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_ReceivedBloodProductsBefore1987_Y"
                                                        style="cursor: default">
                                                        Yes</label>
                                                </td>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_ReceivedBloodProductsBefore1987_N"
                                                        value="N" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_ReceivedBloodProductsBefore1987"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_ReceivedBloodProductsBefore1987_N"
                                                        style="cursor: default">
                                                        No</label>
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_ReceivedBloodProductsBefore1987_U"
                                                        value="U" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_ReceivedBloodProductsBefore1987"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_ReceivedBloodProductsBefore1987_U"
                                                        style="cursor: default">
                                                        Don't Know</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Was your birth mother infected with Hepatitis C virus during the time of your birth?
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_BirthMotherInfectedWithHepatitisC_Y"
                                                        value="Y" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_BirthMotherInfectedWithHepatitisC"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_BirthMotherInfectedWithHepatitisC_Y"
                                                        style="cursor: default">
                                                        Yes</label>
                                                </td>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_BirthMotherInfectedWithHepatitisC_N"
                                                        value="N" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_BirthMotherInfectedWithHepatitisC"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_BirthMotherInfectedWithHepatitisC_N"
                                                        style="cursor: default">
                                                        No</label>
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_BirthMotherInfectedWithHepatitisC_U"
                                                        value="U" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_BirthMotherInfectedWithHepatitisC"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_BirthMotherInfectedWithHepatitisC_U"
                                                        style="cursor: default">
                                                        Don't Know</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Have you been, or are your currently, on long-term kidney dialysis?
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenLongTermKidneyDialysis_Y"
                                                        value="Y" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenLongTermKidneyDialysis"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenLongTermKidneyDialysis_Y"
                                                        style="cursor: default">
                                                        Yes</label>
                                                </td>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenLongTermKidneyDialysis_N"
                                                        value="N" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenLongTermKidneyDialysis"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenLongTermKidneyDialysis_N"
                                                        style="cursor: default">
                                                        No</label>
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenLongTermKidneyDialysis_U"
                                                        value="U" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenLongTermKidneyDialysis"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenLongTermKidneyDialysis_U"
                                                        style="cursor: default">
                                                        Don't Know</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Have you had unprotected sex with someone who has the blood disease hemophilia?
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_UnprotectedSexWithHemophiliaPatient_Y"
                                                        value="Y" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_UnprotectedSexWithHemophiliaPatient"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_UnprotectedSexWithHemophiliaPatient_Y"
                                                        style="cursor: default">
                                                        Yes</label>
                                                </td>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_UnprotectedSexWithHemophiliaPatient_N"
                                                        value="N" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_UnprotectedSexWithHemophiliaPatient"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_UnprotectedSexWithHemophiliaPatient_N"
                                                        style="cursor: default">
                                                        No</label>
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_UnprotectedSexWithHemophiliaPatient_U"
                                                        value="U" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_UnprotectedSexWithHemophiliaPatient"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_UnprotectedSexWithHemophiliaPatient_U"
                                                        style="cursor: default">
                                                        Don't Know</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Have you had unprotected sex with a man who has sex with other men?
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_UnprotectedSexWithManWithOtherMen_Y"
                                                        value="Y" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_UnprotectedSexWithManWithOtherMen"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_UnprotectedSexWithManWithOtherMen_Y"
                                                        style="cursor: default">
                                                        Yes</label>
                                                </td>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_UnprotectedSexWithManWithOtherMen_N"
                                                        value="N" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_UnprotectedSexWithManWithOtherMen"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_UnprotectedSexWithManWithOtherMen_N"
                                                        style="cursor: default">
                                                        No</label>
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_UnprotectedSexWithManWithOtherMen_U"
                                                        value="U" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_UnprotectedSexWithManWithOtherMen"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_UnprotectedSexWithManWithOtherMen_U"
                                                        style="cursor: default">
                                                        Don't Know</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Have you had sex in exchange for money or drugs, or in order to survive?
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_HadSexExchangeMoneyOrDrugs_Y"
                                                        value="Y" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_HadSexExchangeMoneyOrDrugs"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_HadSexExchangeMoneyOrDrugs_Y"
                                                        style="cursor: default">
                                                        Yes</label>
                                                </td>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_HadSexExchangeMoneyOrDrugs_N"
                                                        value="N" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_HadSexExchangeMoneyOrDrugs"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_HadSexExchangeMoneyOrDrugs_N"
                                                        style="cursor: default">
                                                        No</label>
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_HadSexExchangeMoneyOrDrugs_U"
                                                        value="U" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_HadSexExchangeMoneyOrDrugs"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_HadSexExchangeMoneyOrDrugs_U"
                                                        style="cursor: default">
                                                        Don't Know</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Have you had sex with more than one person in the past 6 months? Any type of vaginal,
                                                    rectal or oral contact without protection (condom or other barrier) with or without
                                                    your consent?
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_HadSexMoreThanOnePersonPastSixMonths_Y"
                                                        value="Y" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_HadSexMoreThanOnePersonPastSixMonths"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_HadSexMoreThanOnePersonPastSixMonths_Y"
                                                        style="cursor: default">
                                                        Yes</label>
                                                </td>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_HadSexMoreThanOnePersonPastSixMonths_N"
                                                        value="N" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_HadSexMoreThanOnePersonPastSixMonths"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_HadSexMoreThanOnePersonPastSixMonths_N"
                                                        style="cursor: default">
                                                        No</label>
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_HadSexMoreThanOnePersonPastSixMonths_U"
                                                        value="U" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_HadSexMoreThanOnePersonPastSixMonths"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_HadSexMoreThanOnePersonPastSixMonths_U"
                                                        style="cursor: default">
                                                        Don't Know</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Have you had sex or shared needles to inject drugs with a person who has AIDS or
                                                    who tested positive on the antibody test for AIDS/HIV disease or Hepatitis C?
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_HadSexWithAIDSPersonOrHepatitisC_Y"
                                                        value="Y" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_HadSexWithAIDSPersonOrHepatitisC"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_HadSexWithAIDSPersonOrHepatitisC_Y"
                                                        style="cursor: default">
                                                        Yes</label>
                                                </td>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_HadSexWithAIDSPersonOrHepatitisC_N"
                                                        value="N" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_HadSexWithAIDSPersonOrHepatitisC"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_HadSexWithAIDSPersonOrHepatitisC_N"
                                                        style="cursor: default">
                                                        No</label>
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_HadSexWithAIDSPersonOrHepatitisC_U"
                                                        value="U" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_HadSexWithAIDSPersonOrHepatitisC"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_HadSexWithAIDSPersonOrHepatitisC_U"
                                                        style="cursor: default">
                                                        Don't Know</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Have you ever injected drugs, even once?
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverInjectedDrugsEvenOnce_Y"
                                                        value="Y" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverInjectedDrugsEvenOnce"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverInjectedDrugsEvenOnce_Y"
                                                        style="cursor: default">
                                                        Yes</label>
                                                </td>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverInjectedDrugsEvenOnce_N"
                                                        value="N" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverInjectedDrugsEvenOnce"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverInjectedDrugsEvenOnce_N"
                                                        style="cursor: default">
                                                        No</label>
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverInjectedDrugsEvenOnce_U"
                                                        value="U" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverInjectedDrugsEvenOnce"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverInjectedDrugsEvenOnce_U"
                                                        style="cursor: default">
                                                        Don't Know</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Have you ever been pricked by a needle or syringe that may have been infected with
                                                    HIV or Hepatitis C virus?
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EvenBeenPrickedByNeedle_Y"
                                                        value="Y" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EvenBeenPrickedByNeedle"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EvenBeenPrickedByNeedle_Y"
                                                        style="cursor: default">
                                                        Yes</label>
                                                </td>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EvenBeenPrickedByNeedle_N"
                                                        value="N" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EvenBeenPrickedByNeedle"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EvenBeenPrickedByNeedle_N"
                                                        style="cursor: default">
                                                        No</label>
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EvenBeenPrickedByNeedle_U"
                                                        value="U" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EvenBeenPrickedByNeedle"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EvenBeenPrickedByNeedle_U"
                                                        style="cursor: default">
                                                        Don't Know</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Have you ever had a drinking problem that required medical care or counseling?
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverHadDrinkingProblemCounselling_Y"
                                                        value="Y" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverHadDrinkingProblemCounselling"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverHadDrinkingProblemCounselling_Y"
                                                        style="cursor: default">
                                                        Yes</label>
                                                </td>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverHadDrinkingProblemCounselling_N"
                                                        value="N" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverHadDrinkingProblemCounselling"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverHadDrinkingProblemCounselling_N"
                                                        style="cursor: default">
                                                        No</label>
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverHadDrinkingProblemCounselling_U"
                                                        value="U" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverHadDrinkingProblemCounselling"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverHadDrinkingProblemCounselling_U"
                                                        style="cursor: default">
                                                        Don't Know</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Have you ever been told or thought that you have a drinking problem?
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenToldDrinkingProblem_Y"
                                                        value="Y" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenToldDrinkingProblem"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenToldDrinkingProblem_Y"
                                                        style="cursor: default">
                                                        Yes</label>
                                                </td>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenToldDrinkingProblem_N"
                                                        value="N" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenToldDrinkingProblem"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenToldDrinkingProblem_N"
                                                        style="cursor: default">
                                                        No</label>
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenToldDrinkingProblem_U"
                                                        value="U" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenToldDrinkingProblem"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverBeenToldDrinkingProblem_U"
                                                        style="cursor: default">
                                                        Don't Know</label>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2">
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
                        <td class="height2">
                        </td>
                    </tr>
                    <tr>
                        <td class="height2">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="content_tab_left" nowrap='nowrap'>
                                        Blood Test
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
                        <td class="content_tab_bg" style="padding-left: 10px">
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellpadding="0" cellspacing="0" width="80%">
                                            <tr>
                                                <td style="width: 90%">
                                                    Have you ever had a blood test for the HIV antibody?
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverHadBloodTestForHIVAntibody_Y"
                                                        value="Y" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverHadBloodTestForHIVAntibody"
                                                        style="cursor: default" onclick="showCurrentBloodTestHIV('Y')"/>
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverHadBloodTestForHIVAntibody_Y"
                                                        style="cursor: default">
                                                        Yes</label>
                                                </td>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverHadBloodTestForHIVAntibody_N"
                                                        value="N" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverHadBloodTestForHIVAntibody"
                                                        style="cursor: default" onclick="showCurrentBloodTestHIV('N')"/>
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverHadBloodTestForHIVAntibody_N"
                                                        style="cursor: default">
                                                        No</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr id="trEverHadBloodTestForHIVAntibody" style="display:none">
                                                <td style="padding-left: 10px">
                                                    Have you been tested within the last six months?
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_BeenTestedWithinLastSixMonthsHIV_Y"
                                                        value="Y" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_BeenTestedWithinLastSixMonthsHIV"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_BeenTestedWithinLastSixMonthsHIV_Y"
                                                        style="cursor: default">
                                                        Yes</label>
                                                </td>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_BeenTestedWithinLastSixMonthsHIV_N"
                                                        value="N" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_BeenTestedWithinLastSixMonthsHIV"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_BeenTestedWithinLastSixMonthsHIV_N"
                                                        style="cursor: default">
                                                        No</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr id="trEverHadBloodTestForHIVAntibody1" style="display:none">
                                                <td style="padding-left: 10px">
                                                    Would you like a blood test?
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_WouldYouLikeBloodTestHIV_Y"
                                                        value="Y" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_WouldYouLikeBloodTestHIV"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_WouldYouLikeBloodTestHIV_Y"
                                                        style="cursor: default">
                                                        Yes</label>
                                                </td>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_WouldYouLikeBloodTestHIV_N"
                                                        value="N" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_WouldYouLikeBloodTestHIV"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_WouldYouLikeBloodTestHIV_N"
                                                        style="cursor: default">
                                                        No</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Have you ever had a blood test for Hepatitis C virus?
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverHadBloodTestForHepatitisC_Y"
                                                        value="Y" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverHadBloodTestForHepatitisC"
                                                        style="cursor: default" onclick="showCurrentBloodTestHepatitis('Y')"/>
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverHadBloodTestForHepatitisC_Y"
                                                        style="cursor: default">
                                                        Yes</label>
                                                </td>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverHadBloodTestForHepatitisC_N"
                                                        value="N" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverHadBloodTestForHepatitisC"
                                                        style="cursor: default" onclick="showCurrentBloodTestHepatitis('N')"/>
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_EverHadBloodTestForHepatitisC_N"
                                                        style="cursor: default">
                                                        No</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr id="trEverHadBloodTestForHepatitisAntibody" style="display:none">
                                                <td style="padding-left: 10px">
                                                    Have you been tested within the last six months?
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_BeenTestedWithinLastSixMonthsHepatitisC_Y"
                                                        value="Y" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_BeenTestedWithinLastSixMonthsHepatitisC"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_BeenTestedWithinLastSixMonthsHepatitisC_Y"
                                                        style="cursor: default">
                                                        Yes</label>
                                                </td>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_BeenTestedWithinLastSixMonthsHepatitisC_N"
                                                        value="N" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_BeenTestedWithinLastSixMonthsHepatitisC"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_BeenTestedWithinLastSixMonthsHepatitisC_N"
                                                        style="cursor: default">
                                                        No</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr id="trEverHadBloodTestForHepatitisAntibody1" style="display:none">
                                                <td style="padding-left: 10px">
                                                    Would you like a blood test?
                                                </td>
                                                <td align="left">
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_WouldYouLikeBloodTestHepatitisC_Y"
                                                        value="Y" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_WouldYouLikeBloodTestHepatitisC"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_WouldYouLikeBloodTestHepatitisC_Y"
                                                        style="cursor: default">
                                                        Yes</label>
                                                </td>
                                                <td>
                                                    <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_WouldYouLikeBloodTestHepatitisC_N"
                                                        value="N" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_WouldYouLikeBloodTestHepatitisC"
                                                        style="cursor: default" />
                                                </td>
                                                <td>
                                                    <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_WouldYouLikeBloodTestHepatitisC_N"
                                                        style="cursor: default">
                                                        No</label>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2">
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
                        <td class="height2">
                        </td>
                    </tr>
                    <tr>
                        <td class="height2">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="content_tab_left" nowrap='nowrap'>
                                        Assess
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
                        <td class="content_tab_bg" style="padding-left: 10px">
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr>
                                                <td>
                                                    How would you judge your own risk for being infected with HIV (the AIDS virus)?
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="padding-left: 10px;">
                                                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                        <tr>
                                                            <td>
                                                                <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_JudgeOwnRiskInfectedWithHIV_I"
                                                                    value="I" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_JudgeOwnRiskInfectedWithHIV"
                                                                    style="cursor: default" />
                                                            </td>
                                                            <td>
                                                                <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_JudgeOwnRiskInfectedWithHIV_I"
                                                                    style="cursor: default">
                                                                    I know I am infected</label>
                                                            </td>
                                                            <td>
                                                                <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_JudgeOwnRiskInfectedWithHIV_H"
                                                                    value="H" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_JudgeOwnRiskInfectedWithHIV"
                                                                    style="cursor: default" />
                                                            </td>
                                                            <td>
                                                                <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_JudgeOwnRiskInfectedWithHIV_H"
                                                                    style="cursor: default">
                                                                    I think I am at high risk</label>
                                                            </td>
                                                            <td>
                                                                <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_JudgeOwnRiskInfectedWithHIV_L"
                                                                    value="L" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_JudgeOwnRiskInfectedWithHIV"
                                                                    style="cursor: default" />
                                                            </td>
                                                            <td>
                                                                <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_JudgeOwnRiskInfectedWithHIV_L"
                                                                    style="cursor: default">
                                                                    I think I am at low risk</label>
                                                            </td>
                                                            <td>
                                                                <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_JudgeOwnRiskInfectedWithHIV_N"
                                                                    value="N" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_JudgeOwnRiskInfectedWithHIV"
                                                                    style="cursor: default" />
                                                            </td>
                                                            <td>
                                                                <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_JudgeOwnRiskInfectedWithHIV_N"
                                                                    style="cursor: default">
                                                                    I think I am at NO risk</label>
                                                            </td>
                                                            <td>
                                                                <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_JudgeOwnRiskInfectedWithHIV_S"
                                                                    value="S" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_JudgeOwnRiskInfectedWithHIV"
                                                                    style="cursor: default" />
                                                            </td>
                                                            <td>
                                                                <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_JudgeOwnRiskInfectedWithHIV_S"
                                                                    style="cursor: default">
                                                                    I am not sure what my risk is</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    How would you judge your own risk for being infected with Hepatitis C?
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="padding-left: 10px;">
                                                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                        <tr>
                                                            <td>
                                                                <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_JudgeOwnRiskInfectedWithHepatitisC_I"
                                                                    value="I" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_JudgeOwnRiskInfectedWithHepatitisC"
                                                                    style="cursor: default" />
                                                            </td>
                                                            <td>
                                                                <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_JudgeOwnRiskInfectedWithHepatitisC_I"
                                                                    style="cursor: default">
                                                                    I know I am infected</label>
                                                            </td>
                                                            <td>
                                                                <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_JudgeOwnRiskInfectedWithHepatitisC_H"
                                                                    value="H" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_JudgeOwnRiskInfectedWithHepatitisC"
                                                                    style="cursor: default" />
                                                            </td>
                                                            <td>
                                                                <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_JudgeOwnRiskInfectedWithHepatitisC_H"
                                                                    style="cursor: default">
                                                                    I think I am at high risk</label>
                                                            </td>
                                                            <td>
                                                                <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_JudgeOwnRiskInfectedWithHepatitisC_L"
                                                                    value="L" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_JudgeOwnRiskInfectedWithHepatitisC"
                                                                    style="cursor: default" />
                                                            </td>
                                                            <td>
                                                                <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_JudgeOwnRiskInfectedWithHepatitisC_L"
                                                                    style="cursor: default">
                                                                    I think I am at low risk</label>
                                                            </td>
                                                            <td>
                                                                <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_JudgeOwnRiskInfectedWithHepatitisC_N"
                                                                    value="N" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_JudgeOwnRiskInfectedWithHepatitisC"
                                                                    style="cursor: default" />
                                                            </td>
                                                            <td>
                                                                <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_JudgeOwnRiskInfectedWithHepatitisC_N"
                                                                    style="cursor: default">
                                                                    I think I am at NO risk</label>
                                                            </td>
                                                            <td>
                                                                <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_JudgeOwnRiskInfectedWithHepatitisC_S"
                                                                    value="S" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_JudgeOwnRiskInfectedWithHepatitisC"
                                                                    style="cursor: default" />
                                                            </td>
                                                            <td>
                                                                <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_JudgeOwnRiskInfectedWithHepatitisC_S"
                                                                    style="cursor: default">
                                                                    I am not sure what my risk is</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="padding-left: 10px;">
                                                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                        <tr>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <table border="0" cellpadding="0" cellspacing="0" width="50%">
                                                        <tr>
                                                            <td style="width: 78%">
                                                                Was client assessed?
                                                            </td>
                                                            <td style="width: 5%">
                                                                <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_ClientAssessed_Y"
                                                                    value="Y" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_ClientAssessed"
                                                                    style="cursor: default" />
                                                            </td>
                                                            <td style="width: 8%">
                                                                <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_ClientAssessed_Y"
                                                                    style="cursor: default">
                                                                    Yes</label>
                                                            </td>
                                                            <td style="width: 5%">
                                                                <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_ClientAssessed_N"
                                                                    value="N" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_ClientAssessed"
                                                                    style="cursor: default" />
                                                            </td>
                                                            <td>
                                                                <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_ClientAssessed_N"
                                                                    style="cursor: default">
                                                                    No</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <table border="0" cellpadding="0" cellspacing="0" width="50%">
                                                        <tr>
                                                            <td>
                                                                Client was referred to health department or other agency?
                                                            </td>
                                                            <td style="width: 5%">
                                                                <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_ClientReferredHealthOrAgency_Y"
                                                                    value="Y" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_ClientReferredHealthOrAgency"
                                                                    style="cursor: default" onclick="showClientReferred('Y')"/>
                                                            </td>
                                                            <td style="width: 8%">
                                                                <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_ClientReferredHealthOrAgency_Y"
                                                                    style="cursor: default">
                                                                    Yes</label>
                                                            </td>
                                                            <td style="width: 5%">
                                                                <input type="radio" id="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_ClientReferredHealthOrAgency_N"
                                                                    value="N" name="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_ClientReferredHealthOrAgency"
                                                                    style="cursor: default" onclick="showClientReferred('N')"/>
                                                            </td>
                                                            <td>
                                                                <label for="RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_ClientReferredHealthOrAgency_N"
                                                                    style="cursor: default">
                                                                    No</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr id="trshowClientReferred">
                                                <td style="padding-left: 10px;">
                                                    Where client was referred
                                                    <input class="form_textbox" type="text" name="TextBox_CustomDocumentInfectiousDiseaseRiskAssessments_ClientReferredWhere"
                                                        maxlength="100" id="TextBox_CustomDocumentInfectiousDiseaseRiskAssessments_ClientReferredWhere"
                                                        style="width: 150px;" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2">
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
                        <td class="height2">
                        </td>
                    </tr>
                    <tr>
                        <td class="height2">
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</div>
