<%@ Control Language="C#" AutoEventWireup="true" CodeFile="MedNoteMedications.ascx.cs"
    Inherits="ActivityPages_Harbor_Client_Detail_Documents_MedNote_MedNoteMedications" %>
<table border="0" cellpadding="0" cellspacing="0" width="100%" style="margin-top: 5px">
    <tr>
        <td>
            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                <tr>
                    <td class="content_tab_left" align="left" width="30%">
                        Medication Education
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
        <td class="content_tab_bg" style="padding-left: 8px">
            <table cellpadding="0" cellspacing="0">
                <tr>
                    <td >
                        <table cellpadding="0" cellspacing="0">
                            <tr class="checkbox_container">
                                <td>
                                    <input type="checkbox" id="CheckBox_CheckAll" name="CheckBox_CheckAll" tabindex="20" onclick="CheckCheckAll();" />
                                </td>
                                <td align="left">
                                    <label for="CheckBox_CheckAll">
                                        Check All
                                    </label>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2" colspan="2">
                                </td>
                            </tr>
                            <tr class="checkbox_container">
                                <td>
                                    <input type="checkbox" id="CheckBox_CustomDocumentMedicationReviewNotes_MedEducationSideEffectsDiscussed"
                                        name="CheckBox_CustomDocumentMedicationReviewNotes_MedEducationSideEffectsDiscussed" tabindex="20" />
                                </td>
                                <td align="left">
                                    <label for="CheckBox_CustomDocumentMedicationReviewNotes_MedEducationSideEffectsDiscussed">
                                        Reasons, potential benefits, and interactions, and side effects of all medications
                                        were discussed.
                                    </label>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2" colspan="2">
                                </td>
                            </tr>
                            <tr class="checkbox_container">
                                <td>
                                    <input type="checkbox" id="CheckBox_CustomDocumentMedicationReviewNotes_MedEducationAlternativesReviewed"
                                        name="CheckBox_CustomDocumentMedicationReviewNotes_MedEducationAlternativesReviewed" tabindex="20" />
                                </td>
                                <td align="left">
                                    <label for="CheckBox_CustomDocumentMedicationReviewNotes_MedEducationAlternativesReviewed">
                                        Alternatives and the expected course of treatment were reviewed.
                                    </label>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2" colspan="2">
                                </td>
                            </tr>
                            <tr class="checkbox_container">
                                <td>
                                    <input type="checkbox" id="CheckBox_CustomDocumentMedicationReviewNotes_MedEducationAgreedRegimen"
                                        name="CheckBox_CustomDocumentMedicationReviewNotes_MedEducationAgreedRegimen" tabindex="20" />
                                </td>
                                <td align="left">
                                    <label for="CheckBox_CustomDocumentMedicationReviewNotes_MedEducationAgreedRegimen">
                                        The patient/ guardian asked appropriate questions, appeared to understand the answers,
                                        and decided to accept the treatment and continue the treatment regimen being followed.
                                    </label>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2" colspan="2">
                                </td>
                            </tr>
                            <tr class="checkbox_container">
                                <td>
                                    <input type="checkbox" id="CheckBox_CustomDocumentMedicationReviewNotes_MedEducationAwareOfSubstanceUseRisks"
                                        name="CheckBox_CustomDocumentMedicationReviewNotes_MedEducationAwareOfSubstanceUseRisks" tabindex="20" />
                                </td>
                                <td align="left">
                                    <label for="CheckBox_CustomDocumentMedicationReviewNotes_MedEducationAwareOfSubstanceUseRisks">
                                        The patient/ guardian is aware of the risks of using alcohol and/or substances and
                                        of the risk of combining alcohol and/or substances with the medications that are
                                        currently being prescribed.
                                    </label>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2" colspan="2">
                                </td>
                            </tr>                            
                            <tr class="checkbox_container">
                                <td>
                                    <input type="checkbox" id="CheckBox_CustomDocumentMedicationReviewNotes_MedEducationAwareOfEmergencySymptoms"
                                        name="CheckBox_CustomDocumentMedicationReviewNotes_MedEducationAwareOfEmergencySymptoms" tabindex="20" />
                                </td>
                                <td align="left">
                                    <label for="CheckBox_CustomDocumentMedicationReviewNotes_MedEducationAwareOfEmergencySymptoms">
                                        The patient/ guardian is aware of the need to refer to the closest emergency room
                                        or call 911 if new symptoms arise or existing symptoms worsen. The patient is aware
                                        that this would apply to symptoms like: suicidal ideation, homicidal ideation, high
                                        risk behaviors, manic symptoms, psychotic symptoms, physical symptoms, or any other
                                        symptoms that may be dangerous to self or others.
                                    </label>
                                </td>
                            </tr>
                            <tr>
                                <td class="height3" colspan="2">
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td >
                        <table cellpadding="0" cellspacing="0">
                            <tr>
                                <td>
                                    <span class="form_label">Treatment Recommendations / Orders</span>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <textarea rows="4" cols="160" id="TextArea_CustomDocumentMedicationReviewNotes_TreatmentRecommendationsAndOrders"
                                        class="form_textarea">
                        </textarea>
                                </td>
                            </tr>
                           <tr>
                                <td class="height3">
                                </td>
                            </tr>
                            <tr class="checkbox_container">
                                <td>
                                    <input type="checkbox" id="CheckBox_CustomDocumentMedicationReviewNotes_MoreThan50PercentTimeSpentCounseling"
                                        name="CheckBox_CustomDocumentMedicationReviewNotes_MoreThan50PercentTimeSpentCounseling" />
                                        <label for="CheckBox_CustomDocumentMedicationReviewNotes_MoreThan50PercentTimeSpentCounseling">
                                        More than 50% of this visit was spent counseling or coordinating care with the patient or family/ guardian.
                                    </label>
                                </td>
                            </tr>
                            <tr>
                                <td class="height3"
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <table cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td>
                                                <span class="form_label">Medications Prescribed</span>
                                            </td>
                                            <td style="width: 20px">
                                            </td>
                                            <td>
                                                <a href="javascript:OpenPage(5766, 105, 'DocumentNavigationName=Medications',2, '<%=RelativePath%>');"
                                                    border="0" id="Medications" style="text-decoration: underline;"><span class="form_label">
                                                        Medications</span></a>
                                            </td>
                                            <td style="width: 20px">
                                            </td>
                                            <td>
                                                <table border="0" cellspacing="0" cellpadding="0" id="TableBtn">
                                                    <tbody>
                                                        <tr>
                                                            <td class="glow_lt">
                                                                &nbsp;
                                                            </td>
                                                            <td class="glow_mid">
                                                                <input id="MedicationNote" style="width: auto;" value="Pull Medications into Note"
                                                                    type="button" class="Button" onclick="PullMedicationNoteAjax()" />
                                                            </td>
                                                            <td class="glow_rt">
                                                                &nbsp;
                                                            </td>
                                                        </tr>
                                                    </tbody>
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
                                    <textarea rows="4" cols="160" id="TextArea_CustomDocumentMedicationReviewNotes_MedicationsPrescribed"
                                        class="form_textarea">
    </textarea>
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
