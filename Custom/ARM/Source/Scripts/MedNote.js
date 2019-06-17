//Function to Bind need list data on updating need list .
function SetScreenSpecificValues(dom, action) {
    try {

        GetDateofService(AutoSaveXMLDom);
    }
    catch (err) {
        LogClientSideException(err, 'Medication Review Notes: SetScreenSpecificValues');
    }
}

//Modify by Rohitk Task# 1829(PM Web Bugs) Check the GetFielValueFromXMLDom method if it return null or value. 
function GetDateofService(AutoSaveXMLDom) {
    try {
        var DateOfService = '';
        var control = $("input[type='text'][id$=TextBox_DateofService]");
        if (GetFielValueFromXMLDom(AutoSaveXMLDom, "Services", "DateOfService") != null) {
            DateOfService = GetFielValueFromXMLDom(AutoSaveXMLDom, "Services", "DateOfService");
            DateOfService = ChangeDateFormat(DateOfService);
        }
        if (control != null) {
            if (DateOfService.length > 0) {
                control.val(DateOfService);
            }
        }
    }
    catch (err) {
        LogClientSideException(err, 'Medication Review Notes:GetDateofService');
    }
}


//function AddEventHandlers() {

//    try {
//        $("#CheckBox_CheckAll").click(function() {
//        CheckCheckAll();
//        });

//    }
//    catch (err) {
//        LogClientSideException(err, 'Medication Review Notes:AddEventHandlers');
//    }
//}


function PullMedicationNoteAjax() {
    //OpenPage(5763, 10673, 'action=pullmedicationnote', null, GetRelativePath(), null, null, pageActionEnum.CustomAjaxCall, null, null, null);
    try {
        //Added By: Amit Kumar Srivastava, #47, Harbor Development, Med Review Note and Psych Eval Pull Medications, for passing DOS
        var DOB = GetFielValueFromXMLDom(AutoSaveXMLDom, "Services", "DateOfService");
        var timeOfService = null;
        timeOfService = GetFielValueFromXMLDom(AutoSaveXMLDom, "Services", "StartTimeDateOfService");

        if (DOB != null) {
            if (DOB != "") {
                DOB = ChangeDateFormat(GetFielValueFromXMLDom(AutoSaveXMLDom, "Services", "DateOfService"));
            }

            if (timeOfService != null && timeOfService != "") {
                DOB = DOB + " " + timeOfService;
            }
        }
      
        
        $.ajax({
            url: GetRelativePath() + "ActivityPages/Client/Detail/ServiceNote/ServiceNoteAjaxScript.aspx",
            type: "POST",
            data: "action=pullmedicationnote&DOS=" + DOB,
            success: function(result) { CustomAjaxRequestCallback(result); }

        });
    }
    catch (err) {
        LogClientSideException(err, 'Medication Review Notes: PullMedicationNoteAjax');
    }

}

function CustomAjaxRequestCallback(result) {
    try {
        if (result.toString() != '') {
            $('#TextArea_CustomDocumentMedicationReviewNotes_MedicationsPrescribed').text(result);
            //Added by Sudhir in ref. to task#19 Harbor Development
            $('#TextArea_CustomDocumentMedicationReviewNotes_MedicationsPrescribed').removeAttr('readonly');
            CreateAutoSaveXml('CustomDocumentMedicationReviewNotes', 'MedicationsPrescribed', result);
        }
    }
    catch (err) {
        LogClientSideException(err, 'Medication Review Notes: CustomAjaxRequestCallback');
    }
}



//function to enable/disable checkbox based on corresponding checkbox
function CheckCheckAll() {
    try {
        if ($('#CheckBox_CheckAll').length > 0) {

            var checkAll = $("#CheckBox_CheckAll").is(":checked")

            if (checkAll) {
                CheckUncheckCheckBox(true);
            }
            else {
                CheckUncheckCheckBox(false);
            }

        }
    }
    catch (err) {
        LogClientSideException(err, 'Medication Review Notes: CheckCheckAll');
    }

}
function CheckUncheckCheckBox(checked) {
    try {
        var MedEducationSideEffectsDiscussed = $('#CheckBox_CustomDocumentMedicationReviewNotes_MedEducationSideEffectsDiscussed');
        var MedEducationAlternativesReviewed = $('#CheckBox_CustomDocumentMedicationReviewNotes_MedEducationAlternativesReviewed');
        var MedEducationAgreedRegimen = $('#CheckBox_CustomDocumentMedicationReviewNotes_MedEducationAgreedRegimen');
        var MedEducationAwareOfSubstanceUseRisks = $('#CheckBox_CustomDocumentMedicationReviewNotes_MedEducationAwareOfSubstanceUseRisks');
        var MedEducationAwareOfEmergencySymptoms = $('#CheckBox_CustomDocumentMedicationReviewNotes_MedEducationAwareOfEmergencySymptoms');
        if (checked == true) {
            if (MedEducationSideEffectsDiscussed.length > 0) {
                MedEducationSideEffectsDiscussed.attr("checked", true);
                SetColumnValueInXMLNode('MedEducationSideEffectsDiscussed', 'Y');
            }
            if (MedEducationAlternativesReviewed.length > 0) {
                MedEducationAlternativesReviewed.attr("checked", true);
                SetColumnValueInXMLNode('MedEducationAlternativesReviewed', 'Y');
            }
            if (MedEducationAgreedRegimen.length > 0) {
                MedEducationAgreedRegimen.attr("checked", true);
                SetColumnValueInXMLNode('MedEducationAgreedRegimen', 'Y');
            }
            if (MedEducationAwareOfSubstanceUseRisks.length > 0) {
                MedEducationAwareOfSubstanceUseRisks.attr("checked", true);
                SetColumnValueInXMLNode('MedEducationAwareOfSubstanceUseRisks', 'Y');
            }
            if (MedEducationAwareOfEmergencySymptoms.length > 0) {
                MedEducationAwareOfEmergencySymptoms.attr("checked", true);
                SetColumnValueInXMLNode('MedEducationAwareOfEmergencySymptoms', 'Y');
            }
        }
        else {
            if (MedEducationSideEffectsDiscussed.length > 0) {
                MedEducationSideEffectsDiscussed.attr("checked", false);
                SetColumnValueInXMLNode('MedEducationSideEffectsDiscussed', 'N');
            }
            if (MedEducationAlternativesReviewed.length > 0) {
                MedEducationAlternativesReviewed.attr("checked", false);
                SetColumnValueInXMLNode('MedEducationAlternativesReviewed', 'N');
            }
            if (MedEducationAgreedRegimen.length > 0) {
                MedEducationAgreedRegimen.attr("checked", false);
                SetColumnValueInXMLNode('MedEducationAgreedRegimen', 'N');
            }
            if (MedEducationAwareOfSubstanceUseRisks.length > 0) {
                MedEducationAwareOfSubstanceUseRisks.attr("checked", false);
                SetColumnValueInXMLNode('MedEducationAwareOfSubstanceUseRisks', 'N');
            }
            if (MedEducationAwareOfEmergencySymptoms.length > 0) {
                MedEducationAwareOfEmergencySymptoms.attr("checked", false);
                SetColumnValueInXMLNode('MedEducationAwareOfEmergencySymptoms', 'N');
            }
        }
    }
    catch (err) {
        LogClientSideException(err, 'Medication Review Notes: CheckUncheckCheckBox');
    }
}


function SetColumnValueInXMLNode(colName, colvalue) {

    try {
        var CustomDocumentMedicationReviewNotes = "";
        CustomDocumentMedicationReviewNotes = $("CustomDocumentMedicationReviewNotes", AutoSaveXMLDom);
        if (CustomDocumentMedicationReviewNotes.length > 0) {
            var documentVersionId = $('DocumentVersionId', CustomDocumentMedicationReviewNotes).text();
            SetColumnValueInXMLNodeByKeyValue('CustomDocumentMedicationReviewNotes', 'DocumentVersionId', documentVersionId, colName, colvalue, AutoSaveXMLDom[0]);
            parent.CreateUnsavedInstanceOnDatasetChange();
        }
    }
    catch (err) {
        LogClientSideException(err, 'Medication Review Notes: SetColumnValueInXMLNode');
    }
}

function SetTabUcPath() {
    if (ParentUserControlName == "Diagnosis") {
        return Path = "/ICD10Diagnosis/Documents/ICDTenDiagnosis.ascx";
    }
}