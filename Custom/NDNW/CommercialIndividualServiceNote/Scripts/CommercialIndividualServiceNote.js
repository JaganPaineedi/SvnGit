function ValidateCustomPageEventHandler() {
    if ($('#TextArea_CustomDocumentCommercialIndividualServiceNotes_SituationInterventionPlan').val() == "") {
        ShowHideErrorMessage('Please Enter Situation Intervention Plan', 'true');
        return false;
    }
    else {
        ShowHideErrorMessage("", 'false');
    }
    if ($('#TextArea_CustomDocumentCommercialIndividualServiceNotes_AddressProgressToGoal').val() == "") {
        ShowHideErrorMessage('Please Enter Address Progress to Goal', 'true');
        return false;
    }
    else {
        ShowHideErrorMessage("", 'false');
    }
}