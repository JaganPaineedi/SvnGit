<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Risk.ascx.cs" Inherits="SHS.SmartCare.ActivityPages_Client_CMDocuments_Risk" %>
<%@ Register Src="~/CommonUserControls/DynamicForms.ascx" TagName="DynamicForms"
    TagPrefix="uc1" %>
<%@ Register Assembly="Streamline.DotNetDropDownGlobalCodes" Namespace="Streamline.DotNetDropDownGlobalCodes"
    TagPrefix="cc4" %>
<%@ Register Src="~/ActivityPages/Client/Detail/IndividualServiceNote/ServiceNoteInformation.ascx"
    TagName="Information" TagPrefix="uc3" %>
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
                        <td class="height2">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="content_tab_left" nowrap='nowrap'>
                                        Suicide/Homicide Risk Assesssment
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
                            <table cellpadding="0" cellspacing="0" width="100%" border="0">
                                <tr>
                                    <td>
                                        <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                            <tr>
                                                <td>
                                                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                        <tr>
                                                            <td align="left" style="padding-left: 5px; width: 50%">
                                                                <label style="cursor: default">
                                                                    1. Suicide/Homicide Plan Details</label>
                                                            </td>
                                                            <td align="left" style="width: 50%">
                                                                <cc4:DropDownGlobalCodes ID="DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomicidePlanDetails"
                                                                    AddBlankRow="true" onchange="CalculateTotalScore();" name="DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomicidePlanDetails"
                                                                    Category="xCrisisNoteQ1" runat="server" Width="99%">
                                                                </cc4:DropDownGlobalCodes>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td align="left" style="padding-left: 5px; width: 50%">
                                                                <label style="cursor: default">
                                                                    2. Suicide/Homicide Plan Availability of Means</label>
                                                            </td>
                                                            <td align="left" style="width: 50%">
                                                                <cc4:DropDownGlobalCodes ID="DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomicidePlanAvailability"
                                                                    AddBlankRow="true" onchange="CalculateTotalScore();" name="DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomicidePlanAvailability"
                                                                    Category="xCrisisNoteQ2" runat="server" Width="99%">
                                                                </cc4:DropDownGlobalCodes>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td align="left" style="padding-left: 5px; width: 50%">
                                                                <label style="cursor: default">
                                                                    3. Suicide/Homicide Plan Time</label>
                                                            </td>
                                                            <td align="left" style="width: 50%">
                                                                <cc4:DropDownGlobalCodes ID="DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomicidePlanTime"
                                                                    AddBlankRow="true" onchange="CalculateTotalScore();" name="DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomicidePlanTime"
                                                                    Category="xCrisisNoteQ3" runat="server" Width="99%">
                                                                </cc4:DropDownGlobalCodes>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td align="left" style="padding-left: 5px; width: 50%">
                                                                <label style="cursor: default">
                                                                    4. Suicide/Homicide Plan Lethality of Method</label>
                                                            </td>
                                                            <td align="left" style="width: 50%">
                                                                <cc4:DropDownGlobalCodes ID="DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomicidePlanLethalityMethod"
                                                                    AddBlankRow="true" onchange="CalculateTotalScore();" name="DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomicidePlanLethalityMethod"
                                                                    Category="xCrisisNoteQ4" runat="server" Width="99%">
                                                                </cc4:DropDownGlobalCodes>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td align="left" style="padding-left: 5px; width: 50%">
                                                                <label style="cursor: default">
                                                                    5. Previous Suicide/Homicide Attempts</label>
                                                            </td>
                                                            <td align="left" style="width: 50%">
                                                                <cc4:DropDownGlobalCodes ID="DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideAttempts"
                                                                    AddBlankRow="true" onchange="CalculateTotalScore();" name="DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideAttempts"
                                                                    Category="xCrisisNoteQ5" runat="server" Width="99%">
                                                                </cc4:DropDownGlobalCodes>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td align="left" style="padding-left: 5px; width: 50%">
                                                                <label style="cursor: default">
                                                                    6. Isolation</label>
                                                            </td>
                                                            <td align="left" style="width: 50%">
                                                                <cc4:DropDownGlobalCodes ID="DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideIsolation"
                                                                    AddBlankRow="true" onchange="CalculateTotalScore();" name="DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideIsolation"
                                                                    Category="xCrisisNoteQ6" runat="server" Width="99%">
                                                                </cc4:DropDownGlobalCodes>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td align="left" style="padding-left: 5px; width: 50%">
                                                                <label style="cursor: default">
                                                                    7. Intervention Probability/Timing</label>
                                                            </td>
                                                            <td align="left" style="width: 50%">
                                                                <cc4:DropDownGlobalCodes ID="DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideProbabilityTiming"
                                                                    AddBlankRow="true" onchange="CalculateTotalScore();" name="DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideProbabilityTiming"
                                                                    Category="xCrisisNoteQ7" runat="server" Width="99%">
                                                                </cc4:DropDownGlobalCodes>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td align="left" style="padding-left: 5px; width: 50%">
                                                                <label style="cursor: default">
                                                                    8. Precautions against discovery/interventions</label>
                                                            </td>
                                                            <td align="left" style="width: 50%">
                                                                <cc4:DropDownGlobalCodes ID="DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisidePrecaution"
                                                                    AddBlankRow="true" onchange="CalculateTotalScore();" name="DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisidePrecaution"
                                                                    Category="xCrisisNoteQ8" runat="server" Width="99%">
                                                                </cc4:DropDownGlobalCodes>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td align="left" style="padding-left: 5px; width: 50%">
                                                                <label style="cursor: default">
                                                                    9. Acting to get help during/after attempt</label>
                                                            </td>
                                                            <td align="left" style="width: 50%">
                                                                <cc4:DropDownGlobalCodes ID="DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideActingToGetHelp"
                                                                    AddBlankRow="true" onchange="CalculateTotalScore();" name="DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideActingtoGetHelp"
                                                                    Category="xCrisisNoteQ9" runat="server" Width="99%">
                                                                </cc4:DropDownGlobalCodes>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td align="left" style="padding-left: 5px; width: 50%">
                                                                <label style="cursor: default">
                                                                    10. Final acts in anticipation of death (e.g. will, gifts,insurance)</label>
                                                            </td>
                                                            <td align="left" style="width: 50%">
                                                                <cc4:DropDownGlobalCodes ID="DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideFinalAct"
                                                                    AddBlankRow="true" onchange="CalculateTotalScore();" name="DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideFinalAct"
                                                                    Category="xCrisisNoteQ10" runat="server" Width="99%">
                                                                </cc4:DropDownGlobalCodes>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td align="left" style="padding-left: 5px; width: 50%">
                                                                <label style="cursor: default">
                                                                    11. Active preparation for attempt (e.g. note, messages/texts, noose, recent purchase
                                                                    of lethal items)</label>
                                                            </td>
                                                            <td align="left" style="width: 50%">
                                                                <cc4:DropDownGlobalCodes ID="DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideActiveForAttempt"
                                                                    AddBlankRow="true" onchange="CalculateTotalScore();" name="DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideActiveForAttempt"
                                                                    Category="xCrisisNoteQ11" runat="server" Width="99%">
                                                                </cc4:DropDownGlobalCodes>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td align="left" style="padding-left: 5px; width: 50%">
                                                                <label style="cursor: default">
                                                                    12. Suicide Note/Message</label>
                                                            </td>
                                                            <td align="left" style="width: 50%">
                                                                <cc4:DropDownGlobalCodes ID="DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideSucideNote"
                                                                    AddBlankRow="true" onchange="CalculateTotalScore();" name="DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideSucideNote"
                                                                    Category="xCrisisNoteQ12" runat="server" Width="99%">
                                                                </cc4:DropDownGlobalCodes>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td align="left" style="padding-left: 5px; width: 50%">
                                                                <label style="cursor: default">
                                                                    13. Overt communication of intent before attempt</label>
                                                            </td>
                                                            <td align="left" style="width: 50%">
                                                                <cc4:DropDownGlobalCodes ID="DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideOvertCommunication"
                                                                    AddBlankRow="true" onchange="CalculateTotalScore();" name="DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideOvertCommunication"
                                                                    Category="xCrisisNoteQ13" runat="server" Width="99%">
                                                                </cc4:DropDownGlobalCodes>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td align="left" style="padding-left: 5px; width: 50%">
                                                                <label style="cursor: default">
                                                                    14. Alleged purpose of intent</label>
                                                            </td>
                                                            <td align="left" style="width: 50%">
                                                                <cc4:DropDownGlobalCodes ID="DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideAllegedPurposed"
                                                                    onchange="CalculateTotalScore();" name="DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideAllegedPurposed"
                                                                    AddBlankRow="true" Category="xCrisisNoteQ14" runat="server" Width="99%">
                                                                </cc4:DropDownGlobalCodes>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td align="left" style="padding-left: 5px; width: 50%">
                                                                <label style="cursor: default">
                                                                    15. Expectations of fatality</label>
                                                            </td>
                                                            <td align="left" style="width: 50%">
                                                                <cc4:DropDownGlobalCodes ID="DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideExpectationFatality"
                                                                    onchange="CalculateTotalScore();" AddBlankRow="true" name="DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideExpectationFatality"
                                                                    Category="xCrisisNoteQ15" runat="server" Width="99%">
                                                                </cc4:DropDownGlobalCodes>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td align="left" style="padding-left: 5px; width: 50%">
                                                                <label style="cursor: default">
                                                                    16. Conception of method’s lethality</label>
                                                            </td>
                                                            <td align="left" style="width: 50%">
                                                                <cc4:DropDownGlobalCodes ID="DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideConceptionOfMethod"
                                                                    onchange="CalculateTotalScore();" AddBlankRow="true" name="DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideConceptionOfMethod"
                                                                    Category="xCrisisNoteQ16" runat="server" Width="99%">
                                                                </cc4:DropDownGlobalCodes>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td align="left" style="padding-left: 5px; width: 50%">
                                                                <label style="cursor: default">
                                                                    17. Seriousness of attempt</label>
                                                            </td>
                                                            <td align="left" style="width: 50%">
                                                                <cc4:DropDownGlobalCodes ID="DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideSeriousnessOfAttempt"
                                                                    onchange="CalculateTotalScore();" AddBlankRow="true" name="DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideSeriousnessOfAttempt"
                                                                    Category="xCrisisNoteQ17" runat="server" Width="99%">
                                                                </cc4:DropDownGlobalCodes>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td align="left" style="padding-left: 5px; width: 50%">
                                                                <label style="cursor: default">
                                                                    18. Attitude toward living/dying</label>
                                                            </td>
                                                            <td align="left" style="width: 50%">
                                                                <cc4:DropDownGlobalCodes ID="DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideAttitudeLivingDying"
                                                                    onchange="CalculateTotalScore();" AddBlankRow="true" name="DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideAttitudeLivingDying"
                                                                    Category="xCrisisNoteQ18" runat="server" Width="99%">
                                                                </cc4:DropDownGlobalCodes>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td align="left" style="padding-left: 5px; width: 50%">
                                                                <label style="cursor: default">
                                                                    19. Medical Status</label>
                                                            </td>
                                                            <td align="left" style="width: 50%">
                                                                <cc4:DropDownGlobalCodes ID="DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideMedicalStatus"
                                                                    AddBlankRow="true" name="DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideMedicalStatus"
                                                                    onchange="CalculateTotalScore();" Category="xCrisisNoteQ26" runat="server" Width="99%">
                                                                </cc4:DropDownGlobalCodes>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td align="left" style="padding-left: 5px; width: 50%">
                                                                <label style="cursor: default">
                                                                    20. Conception of medical rescue ability</label>
                                                            </td>
                                                            <td align="left" style="width: 50%">
                                                                <cc4:DropDownGlobalCodes ID="DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideConceptMedicalRescue"
                                                                    onchange="CalculateTotalScore();" AddBlankRow="true" name="DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideConceptMedicalRescue"
                                                                    Category="xCrisisNoteQ19" runat="server" Width="99%">
                                                                </cc4:DropDownGlobalCodes>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td align="left" style="padding-left: 5px; width: 50%">
                                                                <label style="cursor: default">
                                                                    21. Degree of premeditation</label>
                                                            </td>
                                                            <td align="left" style="width: 50%">
                                                                <cc4:DropDownGlobalCodes ID="DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideDegreePremeditation"
                                                                    onchange="CalculateTotalScore();" AddBlankRow="true" name="DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideDegreePremeditation"
                                                                    Category="xCrisisNoteQ20" runat="server" Width="99%">
                                                                </cc4:DropDownGlobalCodes>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td align="left" style="padding-left: 5px; width: 50%">
                                                                <label style="cursor: default">
                                                                    22. Stress</label>
                                                            </td>
                                                            <td align="left" style="width: 50%">
                                                                <cc4:DropDownGlobalCodes ID="DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideStress"
                                                                    onchange="CalculateTotalScore();" AddBlankRow="true" name="DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideStress"
                                                                    Category="xCrisisNoteQ21" runat="server" Width="99%">
                                                                </cc4:DropDownGlobalCodes>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td align="left" style="padding-left: 5px; width: 50%">
                                                                <label style="cursor: default">
                                                                    23. Copying Behavior</label>
                                                            </td>
                                                            <td align="left" style="width: 50%">
                                                                <cc4:DropDownGlobalCodes ID="DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideCopingBehavior"
                                                                    onchange="CalculateTotalScore();" AddBlankRow="true" name="DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideCopingBehavior"
                                                                    Category="xCrisisNoteQ22" runat="server" Width="99%">
                                                                </cc4:DropDownGlobalCodes>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td align="left" style="padding-left: 5px; width: 50%">
                                                                <label style="cursor: default">
                                                                    24. Depression</label>
                                                            </td>
                                                            <td align="left" style="width: 50%">
                                                                <cc4:DropDownGlobalCodes ID="DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideDepression"
                                                                    onchange="CalculateTotalScore();" AddBlankRow="true" name="DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideDepression"
                                                                    Category="xCrisisNoteQ23" runat="server" Width="99%">
                                                                </cc4:DropDownGlobalCodes>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td align="left" style="padding-left: 5px; width: 50%">
                                                                <label style="cursor: default">
                                                                    25. Resource</label>
                                                            </td>
                                                            <td align="left" style="width: 50%">
                                                                <cc4:DropDownGlobalCodes ID="DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideResource"
                                                                    AddBlankRow="true" name="DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideResource"
                                                                    onchange="CalculateTotalScore();" Category="xCrisisNoteQ24" runat="server" Width="99%">
                                                                </cc4:DropDownGlobalCodes>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td align="left" style="padding-left: 5px; width: 50%">
                                                                <label style="cursor: default">
                                                                    26. Life Style</label>
                                                            </td>
                                                            <td align="left" style="width: 50%">
                                                                <cc4:DropDownGlobalCodes ID="DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideLifeStyle"
                                                                    AddBlankRow="true" name="DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideLifeStyle"
                                                                    onchange="CalculateTotalScore();" Category="xCrisisNoteQ25" runat="server" Width="99%">
                                                                </cc4:DropDownGlobalCodes>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2" colspan="2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <table cellpadding="0" cellspacing="0" width="100%" border="0">
                                                                    <tr>
                                                                        <td style="width: 40%">
                                                                        </td>
                                                                        <td style="width: 10%">
                                                                            <label style="cursor: default; font-weight: bold;">
                                                                                Total</label>
                                                                        </td>
                                                                        <td>
                                                                            <input type="text" style="width: 30%;" id="TextBox_CustomAcuteServicesPrescreens_RiskSuicideHomisideTotalScore"
                                                                                class="form_textbox" maxlength="5" disabled="disabled" datatype="Numeric" />
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2" colspan="2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <table cellpadding="0" cellspacing="0" width="100%" border="0">
                                                                    <tr>
                                                                        <td align="left" style="padding-left: 5px;">
                                                                            <label style="cursor: default">
                                                                                Comments</label>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2" colspan="2">
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
                                        <table cellpadding="0" cellpadding="0" width="100%" border="0">
                                            <tr>
                                                <td style="padding-left: 5px">
                                                    <textarea id="TextArea_CustomAcuteServicesPrescreens_RiskSuicideHomisideComments"
                                                        runat="server" name="TextArea_CustomAcuteServicesPrescreens_RiskSuicideHomisideComments"
                                                        spellcheck="True" cols="20" rows="3" class="form_textarea" style="width: 98%"></textarea>
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
                                        Recommendations
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
                            <table cellpadding="0" cellspacing="0" width="100%" border="0">
                                <tr>
                                    <td align="left" valign="top" style="height: 15px;">
                                        <uc3:Information ID="InformationUC" runat="server"></uc3:Information>
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
                                    <td align="left" style="padding-left: 5px;">
                                        <label style="cursor: default">
                                            Recommendations</label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table cellpadding="0" cellpadding="0" width="100%" border="0">
                                            <tr>
                                                <td style="padding-left: 5px">
                                                    <textarea id="TextArea_CustomAcuteServicesPrescreens_Recommendations" runat="server"
                                                        name="TextArea_CustomAcuteServicesPrescreens_Recommendations" spellcheck="True"
                                                        cols="20" rows="3" class="form_textarea" style="width: 98%"></textarea>
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
                                        Action Taken
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
                            <table cellpadding="0" cellspacing="0" width="100%" border="0">
                                <tr>
                                    <td align="left" style="padding-left: 5px;">
                                        <label style="cursor: default">
                                            Admitted/Placed</label>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left">
                                        <table cellpadding="0" cellspacing="0" width="100%">
                                            <tr class="checkbox_container">
                                                <td style="padding-left: 20px">
                                                    <input type="checkbox" id="CheckBox_CustomAcuteServicesPrescreens_RiskActionTakenMedicalER"
                                                        name="CheckBox_CustomAcuteServicesPrescreens_RiskActionTakenMedicalER"  />
                                                    <label for="CheckBox_CustomAcuteServicesPrescreens_RiskActionTakenMedicalER">
                                                        Medical/ER (Hospitalized)</label>
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
                                    <td align="left">
                                        <table cellpadding="0" cellspacing="0" width="100%">
                                            <tr class="checkbox_container">
                                                <td style="padding-left: 20px; width: 40%;">
                                                    <input onclick="EnableDisableControls();" type="checkbox"  id="CheckBox_CustomAcuteServicesPrescreens_RiskActionTakenPsychiatricPlacement"
                                                        name="CheckBox_CustomAcuteServicesPrescreens_RiskActionTakenPsychiatricPlacement" />
                                                    <label for="CheckBox_CustomAcuteServicesPrescreens_RiskActionTakenPsychiatricPlacement">
                                                        Psychiatric Placement (where,voluntary or involuntary)</label>
                                                </td>
                                                <td>
                                                    <table>
                                                        <tr class="checkbox_container">
                                                            <td align="left" style="padding-left: 4px;">
                                                                <input type="radio" id="RadioButton_CustomAcuteServicesPrescreens_RiskActionTakenPsychiatricPlacementVoluntary_Y"
                                                                    name="RadioButton_CustomAcuteServicesPrescreens_RiskActionTakenPsychiatricPlacementVoluntary"
                                                                    value="Y" class="padding_label1" />
                                                            </td>
                                                            <td>
                                                                <label for="RadioButton_CustomAcuteServicesPrescreens_RiskActionTakenPsychiatricPlacementVoluntary_Y">
                                                                    Voluntary</label>
                                                            </td>
                                                            <td style="width: 2px;">
                                                            </td>
                                                            <td align="left">
                                                                <input type="radio" id="RadioButton_CustomAcuteServicesPrescreens_RiskActionTakenPsychiatricPlacementInVoluntary_Y"
                                                                    name="RadioButton_CustomAcuteServicesPrescreens_RiskActionTakenPsychiatricPlacementVoluntary"
                                                                    value="Y" />
                                                            </td>
                                                            <td>
                                                                <label for="RadioButton_CustomAcuteServicesPrescreens_RiskActionTakenPsychiatricPlacementInVoluntary_Y">
                                                                    Involuntary</label>
                                                            </td>
                                                        </tr>
                                                    </table>
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
                                        <table cellpadding="0" cellspacing="0" width="100%">
                                            <tr>
                                                <td style="padding-left: 25px">
                                                    <asp:DropDownList Width="260px" Enabled="false" AppendDataBoundItems="true" ID="DropDownList_CustomAcuteServicesPrescreens_ActionTakenPsychiatricPlacementHospital"
                                                        runat="server">
                                                    </asp:DropDownList>
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
                                    <td align="left">
                                        <table cellpadding="0" cellspacing="0" width="100%">
                                            <tr class="checkbox_container">
                                                <td style="padding-left: 20px">
                                                    <input type="checkbox"  id="CheckBox_CustomAcuteServicesPrescreens_RiskActionDirectorsHoldPlaced"
                                                        name="CheckBox_CustomAcuteServicesPrescreens_RiskActionDirectorsHoldPlaced" />
                                                    <label for="CheckBox_CustomAcuteServicesPrescreens_RiskActionDirectorsHoldPlaced">
                                                        Directors Hold Placed</label>
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
                                    <td align="left">
                                        <table cellpadding="0" cellspacing="0" width="100%">
                                            <tr class="checkbox_container">
                                                <td style="padding-left: 20px; width: 30%;">
                                                    <input type="checkbox"  onclick="EnableDisableControls();" id="CheckBox_CustomAcuteServicesPrescreens_RiskActionSecureTransport"
                                                        name="CheckBox_CustomAcuteServicesPrescreens_RiskActionSecureTransport" />
                                                    <label for="CheckBox_CustomAcuteServicesPrescreens_RiskActionSecureTransport">
                                                        Secure Transport Used (which company)</label>
                                                </td>
                                                <td>
                                                    <input type="text" style="width: 70%;" id="TextBox_CustomAcuteServicesPrescreens_RiskActionSecureTransportCompanyName"
                                                        class="form_textbox" disabled="disabled" />
                                                </td>
                                                <td>
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
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left">
                                        <table cellpadding="0" cellspacing="0" width="100%">
                                            <tr class="checkbox_container">
                                                <td style="padding-left: 20px; width: 20%;">
                                                    <input onclick="EnableDisableControls();" type="checkbox" id="CheckBox_CustomAcuteServicesPrescreens_RiskActionTakenCrisisRespiteBed"
                                                        name="CheckBox_CustomAcuteServicesPrescreens_RiskActionTakenCrisisRespiteBed" />
                                                    <label for="CheckBox_CustomAcuteServicesPrescreens_RiskActionTakenCrisisRespiteBed">
                                                        Crisis Respite Bed</label>
                                                </td>
                                                <td>
                                                    <table>
                                                        <tr class="checkbox_container">
                                                            <td align="left" style="padding-left: 4px;">
                                                                <input type="radio" id="RadioButton_CustomAcuteServicesPrescreens_RiskActionTakenCrisisRespiteBedWithPsych_Y"
                                                                    name="RadioButton_CustomAcuteServicesPrescreens_RiskActionTakenCrisisRespiteBedWithPsych"
                                                                    value="Y" class="padding_label1" />
                                                            </td>
                                                            <td>
                                                                <label for="RadioButton_CustomAcuteServicesPrescreens_RiskActionTakenCrisisRespiteBedWithPsych_Y">
                                                                    With Psych Sitter</label>
                                                            </td>
                                                            <td style="width: 2px;">
                                                            </td>
                                                            <td align="left">
                                                                <input type="radio" id="RadioButton_CustomAcuteServicesPrescreens_RiskActionTakenCrisisRespiteBedWithoutPsych_Y"
                                                                    name="RadioButton_CustomAcuteServicesPrescreens_RiskActionTakenCrisisRespiteBedWithPsych"
                                                                    value="Y" />
                                                            </td>
                                                            <td>
                                                                <label for="RadioButton_CustomAcuteServicesPrescreens_RiskActionTakenCrisisRespiteBedWithoutPsych_Y">
                                                                    Without Psych Sitter</label>
                                                            </td>
                                                        </tr>
                                                    </table>
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
                                    <td align="left">
                                        <table cellpadding="0" cellspacing="0" width="100%">
                                            <tr class="checkbox_container">
                                                <td style="padding-left: 20px">
                                                    <input type="checkbox"  id="CheckBox_CustomAcuteServicesPrescreens_RiskActionTakenJail"
                                                        name="CheckBox_CustomAcuteServicesPrescreens_RiskActionTakenJail" />
                                                    <label for="CheckBox_CustomAcuteServicesPrescreens_RiskActionTakenJail">
                                                        Jail</label>
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
                                    <td align="left">
                                        <table cellpadding="0" cellspacing="0" width="100%">
                                            <tr class="checkbox_container">
                                                <td style="padding-left: 20px">
                                                    <input type="checkbox" id="CheckBox_CustomAcuteServicesPrescreens_RiskActionSocialDextorBed"
                                                         name="CheckBox_CustomAcuteServicesPrescreens_RiskActionSocialDextorBed" />
                                                    <label for="CheckBox_CustomAcuteServicesPrescreens_RiskActionSocialDextorBed">
                                                        Social Dextor Bed</label>
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
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" style="padding-left: 5px;">
                                        <label style="cursor: default">
                                            Sent Home</label>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left">
                                        <table cellpadding="0" cellspacing="0" width="100%">
                                            <tr class="checkbox_container">
                                                <td style="padding-left: 20px">
                                                    <input type="checkbox" id="CheckBox_CustomAcuteServicesPrescreens_RiskSentHomeAlone"
                                                        name="CheckBox_CustomAcuteServicesPrescreens_RiskSentHomeAlone" />
                                                    <label for="CheckBox_CustomAcuteServicesPrescreens_RiskSentHomeAlone">
                                                        Alone</label>
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
                                    <td align="left">
                                        <table cellpadding="0" cellspacing="0" width="100%">
                                            <tr class="checkbox_container">
                                                <td style="padding-left: 20px">
                                                    <input type="checkbox"  id="CheckBox_CustomAcuteServicesPrescreens_RiskSentHomeWithRelative"
                                                        name="CheckBox_CustomAcuteServicesPrescreens_RiskSentHomeWithRelative" />
                                                    <label for="CheckBox_CustomAcuteServicesPrescreens_RiskSentHomeWithRelative">
                                                        With relative/friend</label>
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
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" style="padding-left: 5px;">
                                        <label style="cursor: default">
                                            Referred To</label>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left">
                                        <table cellpadding="0" cellspacing="0" width="100%">
                                            <tr class="checkbox_container">
                                                <td style="padding-left: 20px">
                                                    <input type="checkbox"  id="CheckBox_CustomAcuteServicesPrescreens_RiskRefferedToFollowNextDay"
                                                        name="CheckBox_CustomAcuteServicesPrescreens_RiskRefferedToFollowNextDay" />
                                                    <label for="CheckBox_CustomAcuteServicesPrescreens_RiskRefferedToFollowNextDay">
                                                        CMHP - For follow up next day</label>
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
                                    <td align="left">
                                        <table cellpadding="0" cellspacing="0" width="100%">
                                            <tr class="checkbox_container">
                                                <td style="padding-left: 20px; width: 30%;">
                                                    <input onclick="EnableDisableControls();"  type="checkbox" id="CheckBox_CustomAcuteServicesPrescreens_RiskReferedToPrivateProvider"
                                                        name="CheckBox_CustomAcuteServicesPrescreens_RiskReferedToPrivateProvider" />
                                                    <label for="CheckBox_CustomAcuteServicesPrescreens_RiskReferedToPrivateProvider">
                                                        Private Provider for follow-up (who)</label>
                                                </td>
                                                <td>
                                                    <input type="text" style="width: 70%;" id="TextBox_CustomAcuteServicesPrescreens_RiskReferedToPrivateProviderName"
                                                        class="form_textbox" disabled="disabled" />
                                                </td>
                                                <td>
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
                                    <td align="left">
                                        <table cellpadding="0" cellspacing="0" width="100%">
                                            <tr class="checkbox_container">
                                                <td style="padding-left: 20px">
                                                    <input type="checkbox"  id="CheckBox_CustomAcuteServicesPrescreens_RiskRefferedPyschiatristPMNHP"
                                                        name="CheckBox_CustomAcuteServicesPrescreens_RiskRefferedPyschiatristPMNHP" />
                                                    <label for="CheckBox_CustomAcuteServicesPrescreens_RiskRefferedPyschiatristPMNHP">
                                                        Psychiatrist or PMNHP</label>
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
                                    <td align="left">
                                        <table cellpadding="0" cellspacing="0" width="100%">
                                            <tr class="checkbox_container">
                                                <td style="padding-left: 20px; width: 30%;">
                                                    <input onclick="EnableDisableControls();" type="checkbox" id="CheckBox_CustomAcuteServicesPrescreens_RiskReferedToOther"
                                                         name="CheckBox_CustomAcuteServicesPrescreens_RiskReferedToOther" />
                                                    <label for="CheckBox_CustomAcuteServicesPrescreens_RiskReferedToOther">
                                                        Other (specify)
                                                    </label>
                                                </td>
                                                <td>
                                                    <input type="text" style="width: 70%;" id="TextBox_CustomAcuteServicesPrescreens_RiskReferedToOtherSpecify"
                                                        class="form_textbox" disabled="disabled" />
                                                </td>
                                                <td>
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
                                        Suicide/Homicide Risk Assessment
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
                            <table cellpadding="0" cellspacing="0" width="100%" border="0">
                                <tr>
                                    <td align="left" style="padding-left: 5px; width: 50%">
                                        <label style="cursor: default">
                                            Presenting Dangers - Self</label>
                                    </td>
                                    <td align="left" style="width: 50%">
                                        <cc4:DropDownGlobalCodes ID="DropDownList_CustomAcuteServicesPrescreens_RiskSuicidePresentingDangersSuicide"
                                            AddBlankRow="true" name="DropDownList_CustomAcuteServicesPrescreens_RiskSuicidePresentingDangersSuicide"
                                            Category="Xcrisisdangers" runat="server" Width="99%">
                                        </cc4:DropDownGlobalCodes>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" style="padding-left: 5px; width: 50%">
                                        <label style="cursor: default">
                                            Presenting Dangers - Other Harm To Self</label>
                                    </td>
                                    <td align="left" style="width: 50%">
                                        <cc4:DropDownGlobalCodes ID="DropDownList_CustomAcuteServicesPrescreens_RiskSuicidePresentingDangersOtherHarmToSelf"
                                            AddBlankRow="true" name="DropDownList_CustomAcuteServicesPrescreens_RiskSuicidePresentingDangersOtherHarmToSelf"
                                            Category="Xcrisisdangers" runat="server" Width="99%">
                                        </cc4:DropDownGlobalCodes>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" style="padding-left: 5px; width: 50%">
                                        <label style="cursor: default">
                                            Presenting Dangers - Harm To Others</label>
                                    </td>
                                    <td align="left" style="width: 50%">
                                        <cc4:DropDownGlobalCodes ID="DropDownList_CustomAcuteServicesPrescreens_RiskSuicidePresentingDangersHarmToOthers"
                                            AddBlankRow="true" name="DropDownList_CustomAcuteServicesPrescreens_RiskSuicidePresentingDangersHarmToOthers"
                                            Category="Xcrisisdangers" runat="server" Width="99%">
                                        </cc4:DropDownGlobalCodes>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" style="padding-left: 5px; width: 50%">
                                        <label style="cursor: default">
                                            Presenting Dangers - Harm To Property</label>
                                    </td>
                                    <td align="left" style="width: 50%">
                                        <cc4:DropDownGlobalCodes ID="DropDownList_CustomAcuteServicesPrescreens_RiskSuicidePresentingDangersHarmToProperty"
                                            AddBlankRow="true" name="DropDownList_CustomAcuteServicesPrescreens_RiskSuicidePresentingDangersHarmToProperty"
                                            Category="Xcrisisdangers" runat="server" Width="99%">
                                        </cc4:DropDownGlobalCodes>
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
                </table>
            </td>
        </tr>
    </table>
</div>
