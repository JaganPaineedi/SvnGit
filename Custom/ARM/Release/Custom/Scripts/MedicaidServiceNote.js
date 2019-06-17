function SetTabUcPath() {
    return "/ActivityPages/Client/Detail/Documents/Harbor/MedicaidHealthHomeServiceNote.ascx";
}
function InsertGrid_CustomDocumentHealthHomeCarePlanDiagnosesData(gridDatatable, gridDivName, dataGridID, buttonCtrl) {
    var filterval = 'GridDataTable=' + gridDatatable + '^GridDivName=' + gridDivName + '^DataGridID=' + dataGridID + '^ButtonCtrl=' + buttonCtrl.id + '^TableName=CustomDocumentHealthHomeCarePlanDiagnoses'
    OpenPage(5763, 10981, 'CustomAjaxRequestType=CountSequenceNumber^' + filterval, null, GetRelativePath(), null, null, pageActionEnum.CustomAjaxCall, null, null, null);
}
function Clear_CustomDocumentHealthHomeCarePlanDiagnoses_Data() {
    ClearTable('TableChildControl_CustomDocumentHealthHomeCarePlanDiagnoses');
    $('#TextBox_CustomDocumentHealthHomeCarePlanDiagnoses_ReportedDiagnosis').focus();
    $('[id$=RadioButtonId]').removeAttr('checked');
    $("[id$=TableChildControl_CustomDocumentHealthHomeCarePlanDiagnoses_ButtonInsert").val('Insert');
    ShowHideErrorMessage(" ", 'false');
}

function CustomAjaxRequestCallback(result, CutomAjaxRequest) {
    var pageResponse = result;
    var start = pageResponse.indexOf("###StartUc###") + 13;
    var end = pageResponse.indexOf("###EndUc###");
    var htmlResponse = pageResponse.substr(start, end - start);
    var splitval = [];
    splitval = htmlResponse.split('^');
    $("#HiddenField_CustomDocumentHealthHomeCarePlanDiagnoses_SequenceNumber").val(splitval[4]);
    InsertGridData(splitval[0], splitval[1], splitval[2], splitval[3]);
}

function CheckDateRange(start, end, content) {
    // Parse the entries
    var sDate = new Date($('[id$=' + start + ']').val());
    var eDate = new Date($('[id$=' + end + ']').val());
    // end - start returns difference in milliseconds
    var difference = eDate - sDate;

    // get days
    var days = Math.floor(difference / 1000 / 60 / 60 / 24);
    // Make sure they are valid
    if (sDate == 'NaN' || sDate == "") {
        switch (content) {
            case 'Physical':
                ShowHideErrorMessage("Please enter Physical Mental Health Discharge Date", 'true');
                break;
            case 'Emergency':
                ShowHideErrorMessage("Please enter Emergency Mental Health Encounter Date", 'true');
                break;
            case 'Psychiatric':
                ShowHideErrorMessage("Please enter Psychiatric Mental Health Discharge Date", 'true');
                break;
            case 'Rescue':
                ShowHideErrorMessage("Please enter Rescue Mental Health Encounter Date", 'true');
                break;

        }
        return false;
    }
    if (eDate == 'NaN') {
        ShowHideErrorMessage("Please enter " + content + " Mental Health Follow up Date", 'true');
        return false;
    }

    
    
    if (days < 0) {
        switch (content) {
            case 'Physical':
                ShowHideErrorMessage("Discharge Date should come before Follow up Date", 'true');
                break;
            case 'Emergency':
                ShowHideErrorMessage("Encounter Date should come before Follow up Date", 'true');
                break;
            case 'Psychiatric':
                ShowHideErrorMessage("Discharge Date should come before Follow up Date", 'true');
                break;
            case 'Rescue':
                ShowHideErrorMessage("Encounter Date should come before Follow up Date", 'true');
                break;

        }
        $('[id$=' + end + ']').val('');
        return false;
    }
    else {
        switch (content) {
            case 'Physical':
                if (days >= 14) {
                    ShowHideErrorMessage("Discharge Date and Follow up Date munsh be within 14 days", 'true');
                    $('[id$=' + end + ']').val('');
                }
                break;
            case 'Emergency':
                if (days >= 14) {
                    ShowHideErrorMessage("Encounter Date and Follow up Date munsh be within 14 days", 'true');
                    $('[id$=' + end + ']').val('');
                }
                break;
            case 'Psychiatric':
                if (days >= 7) {
                    ShowHideErrorMessage("Discharge Date and Follow up Date munsh be within 7 days", 'true');
                    $('[id$=' + end + ']').val('');
                }
                break;
            case 'Rescue':
                if (days >= 7) {
                    ShowHideErrorMessage("Encounter Date and Follow up Date munsh be within 7 days", 'true');
                    $('[id$=' + end + ']').val('');
                }
                break;

        }
        return false;
    }
       return true;
   }
   function EnableOrDisableControls() {
       if ($('#RadioButton_CustomDocumentHealthHomeServiceNotes_RescueMentalHealthEncounter_N').is(':checked')) {
               $("[id$=RescueEncounter").attr('disabled', true);
               $("[id$=TextBox_CustomDocumentHealthHomeServiceNotes_RescueMentalHealthEncounterDate").attr('disabled', 'disabled');
               $("[id$=TextBox_CustomDocumentHealthHomeServiceNotes_RescueMentalHealthEncounterDate").val('');
               $("[id$=Img15").attr('disabled', true);
               $("[id$=TextBox_CustomDocumentHealthHomeServiceNotes_RescueMentalHealthFollowUpDate").attr('disabled', true);
               $("[id$=TextBox_CustomDocumentHealthHomeServiceNotes_RescueMentalHealthFollowUpDate").val('');
               $("[id$=Img16").attr('disabled', true);
           }
           if ($('#RadioButton_CustomDocumentHealthHomeServiceNotes_RescueMentalHealthEncounter_Y').is(':checked')) {
               $("[id$=RescueEncounter").attr('disabled', false);
               $("[id$=TextBox_CustomDocumentHealthHomeServiceNotes_RescueMentalHealthEncounterDate").attr('disabled', '');
               $("[id$=Img15").attr('disabled', '');
               $("[id$=TextBox_CustomDocumentHealthHomeServiceNotes_RescueMentalHealthFollowUpDate").attr('disabled', '');
               $("[id$=Img16").attr('disabled', '');
           }
           if ($('#RadioButton_CustomDocumentHealthHomeServiceNotes_RecentPsychHospitalDischarge_N').is(':checked')) {

               $("[id$=psychiatric1").attr('disabled', true);
               $("[id$=psychiatric2").attr('disabled', true);
               $("[id$=psychiatric3").attr('disabled', true);
             $("[id$=TextBox_CustomDocumentHealthHomeServiceNotes_RecentPsychHospitalDischargeDate").attr('disabled', true);
             $("[id$=TextBox_CustomDocumentHealthHomeServiceNotes_RecentPsychHospitalDischargeDate").val('');
               $("[id$=Img17").attr('disabled', true);
               $("[id$=TextBox_CustomDocumentHealthHomeServiceNotes_RecentPsychHospitalFollowUpDate").attr('disabled', true);
               $("[id$=TextBox_CustomDocumentHealthHomeServiceNotes_RecentPsychHospitalFollowUpDate").val('');
               $("[id$=Img18").attr('disabled', true);
           }
           if ($('#RadioButton_CustomDocumentHealthHomeServiceNotes_RecentPsychHospitalDischarge_Y').is(':checked')) {
               $("[id$=psychiatric1").attr('disabled', false);
               $("[id$=psychiatric2").attr('disabled', false);
               $("[id$=psychiatric3").attr('disabled', false);
               $("[id$=TextBox_CustomDocumentHealthHomeServiceNotes_RecentPsychHospitalDischargeDate").attr('disabled', '');
               $("[id$=Img17").attr('disabled', '');
               $("[id$=TextBox_CustomDocumentHealthHomeServiceNotes_RecentPsychHospitalFollowUpDate").attr('disabled', '');
               $("[id$=Img18").attr('disabled', '');
           }
           if ($('#RadioButton_CustomDocumentHealthHomeServiceNotes_RecentEmergencyDeptEncounter_N').is(':checked')) {
               $("[id$=EmergencyTr").attr('disabled', true);
               $("[id$=TextBox_CustomDocumentHealthHomeServiceNotes_RecentEmergencyDeptEncounterDate").attr('disabled', true);
              $("[id$=TextBox_CustomDocumentHealthHomeServiceNotes_RecentEmergencyDeptEncounterDate").val('');
               $("[id$=Img19").attr('disabled', true);
               $("[id$=TextBox_CustomDocumentHealthHomeServiceNotes_RecentEmergencyDeptFollowUpDate").attr('disabled', true);
               $("[id$=TextBox_CustomDocumentHealthHomeServiceNotes_RecentEmergencyDeptFollowUpDate").val('');
               $("[id$=Img20").attr('disabled', true);
           }
           if ($('#RadioButton_CustomDocumentHealthHomeServiceNotes_RecentEmergencyDeptEncounter_Y').is(':checked')) {
               $("[id$=EmergencyTr").attr('disabled', false);
               $("[id$=TextBox_CustomDocumentHealthHomeServiceNotes_RecentEmergencyDeptEncounterDate").attr('disabled', '');
               $("[id$=Img19").attr('disabled', '');
               $("[id$=TextBox_CustomDocumentHealthHomeServiceNotes_RecentEmergencyDeptFollowUpDate").attr('disabled', '');
               $("[id$=Img20").attr('disabled', '');
           }
           if ($('#RadioButton_CustomDocumentHealthHomeServiceNotes_RecentPhysicalHospitalDischarge_N').is(':checked')) {
               $("[id$=Physical2").attr('disabled', true);
               $("[id$=Physical1").attr('disabled', true);
               $("[id$=TextBox_CustomDocumentHealthHomeServiceNotes_RecentPhysicalHospitalDischargeDate").attr('disabled', true);
               $("[id$=TextBox_CustomDocumentHealthHomeServiceNotes_RecentPhysicalHospitalDischargeDate").val('');
               $("[id$=Img21").attr('disabled', true);
               $("[id$=TextBox_CustomDocumentHealthHomeServiceNotes_RecentPhysicalHospitalFollowUpDate").attr('disabled', true);
               $("[id$=TextBox_CustomDocumentHealthHomeServiceNotes_RecentPhysicalHospitalFollowUpDate").val('');
               $("[id$=Img22").attr('disabled', true);
           }
           if ($('#RadioButton_CustomDocumentHealthHomeServiceNotes_RecentPhysicalHospitalDischarge_Y').is(':checked')) {
               $("[id$=Physical2").attr('disabled', false);
               $("[id$=Physical1").attr('disabled', false);
               $("[id$=TextBox_CustomDocumentHealthHomeServiceNotes_RecentPhysicalHospitalDischargeDate").attr('disabled', '');
               $("[id$=Img21").attr('disabled', '');
               $("[id$=TextBox_CustomDocumentHealthHomeServiceNotes_RecentPhysicalHospitalFollowUpDate").attr('disabled', '');
               $("[id$=Img22").attr('disabled', '');
           }
           if ($('#RadioButton_CustomDocumentHealthHomeServiceNotes_PlannedTransitionsLongTermCareAOD_N').is(':checked')) {
               $("[id$=AODComments1").attr('disabled', true);
               $("[id$=AODComments2").attr('disabled', true);
               $("[id$=TextArea_CustomDocumentHealthHomeServiceNotes_PlannedTransitionsLongTermCareAODComment").attr('disabled', true);
               $("[id$=RadioButton_CustomDocumentHealthHomeServiceNotes_PlannedTransitionsLongTermCareAODTransitionCompleted").attr('checked', false);
               $("[id$=TextArea_CustomDocumentHealthHomeServiceNotes_PlannedTransitionsLongTermCareAODComment").val('');
               $("[id$=RadioButton_CustomDocumentHealthHomeServiceNotes_PlannedTransitionsLongTermCareAODTransitionCompleted").attr('disabled', true);
           }
           if ($('#RadioButton_CustomDocumentHealthHomeServiceNotes_PlannedTransitionsLongTermCareAOD_Y').is(':checked')) {
               $("[id$=AODComments1").attr('disabled', false);
               $("[id$=AODComments2").attr('disabled', false);
               $("[id$=TextArea_CustomDocumentHealthHomeServiceNotes_PlannedTransitionsLongTermCareAODComment").attr('disabled', false);
               $("[id$=RadioButton_CustomDocumentHealthHomeServiceNotes_PlannedTransitionsLongTermCareAODTransitionCompleted").attr('disabled', false);
            
           }
       }

       function AddEventHandlers() {
           EnableOrDisableControls();
           DisableRow();
       }

       function DisableRow() {
           if ($('#CheckBox_CustomDocumentHealthHomeServiceNotes_LDLNA').is(':checked')) {
               $("[id$=SpanLDL").attr('disabled', true);
               $("[id$=SpanLDLDate").attr('disabled', true);
               $("[id$=TextBox_CustomDocumentHealthHomeServiceNotes_LDLDate").attr('disabled', true);
               $("[id$=TextBox_CustomDocumentHealthHomeServiceNotes_LDLValue").attr('disabled', true);
               $("[id$=TextBox_CustomDocumentHealthHomeServiceNotes_LDLValue").val('');
               $("[id$=TextBox_CustomDocumentHealthHomeServiceNotes_LDLDate").val('');
               $("[id$=Img1").attr('disabled', true);
           }
           else {
               $("[id$=SpanLDL").attr('disabled', false);
               $("[id$=SpanLDLDate").attr('disabled', false);
               $("[id$=TextBox_CustomDocumentHealthHomeServiceNotes_LDLDate").attr('disabled', false);
               $("[id$=TextBox_CustomDocumentHealthHomeServiceNotes_LDLValue").attr('disabled', false);
               $("[id$=Img1").attr('disabled', false);

           }
           if ($('#CheckBox_CustomDocumentHealthHomeServiceNotes_ALCNA').is(':checked')) {
               $("[id$=SpanALC").attr('disabled', true);
               $("[id$=SpanALCDate").attr('disabled', true);
               $("[id$=TextBox_CustomDocumentHealthHomeServiceNotes_ALCDate").attr('disabled', true);
               $("[id$=TextBox_CustomDocumentHealthHomeServiceNotes_ALCValue").attr('disabled', true);
               $("[id$=TextBox_CustomDocumentHealthHomeServiceNotes_ALCValue").val('');
               $("[id$=TextBox_CustomDocumentHealthHomeServiceNotes_ALCDate").val('');
               $("[id$=Img2").attr('disabled', true);
           }
           else {
               $("[id$=SpanALC").attr('disabled', false);
               $("[id$=SpanALCDate").attr('disabled', false);
               $("[id$=TextBox_CustomDocumentHealthHomeServiceNotes_ALCDate").attr('disabled', false);
               $("[id$=TextBox_CustomDocumentHealthHomeServiceNotes_ALCValue").attr('disabled', false);
               $("[id$=Img2").attr('disabled', false);
           }
       }