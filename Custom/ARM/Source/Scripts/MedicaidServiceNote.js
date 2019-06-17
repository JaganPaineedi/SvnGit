function SetScreenSpecificValues(dom, action) {
    if ($('#divPreviousDiagnosis').length > 0) {
        OpenPage(5763, 10981, 'CustomAjaxRequestType=GetCurrentDiagnosis', null, GetRelativePath(), null, null, pageActionEnum.CustomAjaxCall, null, null, null);
    }
}

function SetTabUcPath() {
    return "/Custom/WebPages/MedicaidHealthHomeServiceNote.ascx";
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

    if (result.indexOf("###StartCurrentDiagnosisUc###") >= 0) {
        var pageResponse = result;
        var start = pageResponse.indexOf("###StartCurrentDiagnosisUc###") + 29;
        var end = pageResponse.indexOf("###EndCurrentDiagnosisUc###");
        var htmlResponse = pageResponse.substr(start, end - start);
        CreateDiagnosisTable(htmlResponse);
    }
    if (result.indexOf("###StartUc###") >= 0) {
        var pageResponse = result;
        var start = pageResponse.indexOf("###StartUc###") + 13;
        var end = pageResponse.indexOf("###EndUc###");
        var htmlResponse = pageResponse.substr(start, end - start);
        var splitval = [];
        splitval = htmlResponse.split('^');
        $("#HiddenField_CustomDocumentHealthHomeCarePlanDiagnoses_SequenceNumber").val(splitval[4]);
        InsertGridData(splitval[0], splitval[1], splitval[2], splitval[3]);
    }
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

    var DiagnosisList = $('CurrentDiagnoses', $.xmlDOM($('#hdnDiagnosisListInformation').val())).XMLExtractExactOrder();
    if (DiagnosisList.length > 0) {
        $('#divEmptyDiagnosisTemplate').hide();
        $("#divDiagnosisTemplate").html('');
        $("#TestDiagnosisListTemplate").tmpl(DiagnosisList).appendTo("#divDiagnosisTemplate");
        var _currentMentalHealthDiagnoses = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentHealthHomeServiceNotes", "CurrentMentalHealthDiagnoses");
        $("[id$=Span_CurrentMentalHealthDiagnoses]").text(_currentMentalHealthDiagnoses);
    }
    else {

        $('#thDiagnosisTemplate').hide();
        $('#divDiagnosisTemplate').hide();
        $('#divEmptyDiagnosisTemplate').visible = true;
    }

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

function ShowCustomToolTip(sender) {
    if ($(sender).attr('title') == '' || ($(sender) == 'undefined')) {
        $(sender).is("td")
        {
            $(sender).attr('title', $(sender).html());
        }
    }
}

function CreateDiagnosisTable(result) {
    var tableHeader = "<table width='100%'><thead><tr>";
    var tableBody = "<tbody>";
    var endTable = "</table>";
    tableHeader += "<tr>";
    tableHeader += "<th align='left' width='15%'>Type</th>";
    tableHeader += "<th align='left' width='10%'>ICD 9</th>";
    tableHeader += "<th align='left' width='15%'>ICD 10</th>";
    tableHeader += "<th align='left' width='15%'>DSM5</th>";
    tableHeader += "<th align='left' width='30%'>Description</th>";
    tableHeader += "</tr></thead>";
    var result1 = $.xmlDOM(result);
    $(result1).find('DocumentDiagnosisCodes').each(function() {
        tableBody += "<tr>";
        tableBody += "<td align='left'>" + $(this).find('DiagnosisType').text() + "</td>";
        tableBody += "<td align='left'>" + $(this).find('ICD9Code').text() + "</td>";
        tableBody += "<td align='left'>" + $(this).find('ICD10Code').text() + "</td>";
        tableBody += "<td align='left'>" + $(this).find('DSMVCode').text() + "</td>";

        var dsmDesciption = $(this).find('DSMDescription').text();
        if (dsmDesciption.length > 40)
            dsmDesciption = "<span title='" + dsmDesciption + "'>" + dsmDesciption.substring(0, 40) + "..." + "</span>";
        else
            dsmDesciption = "<span title='" + dsmDesciption + "'>" + dsmDesciption.substring(0, 40) + "..." + "</span>";
        tableBody += "<td align='left'>" + dsmDesciption + "</td>";
        tableBody += "</tr>";
    });
    var tableHeaderAxisIII = "<tr>";
    tableHeaderAxisIII += "<td align='left' colspan='5' style='padding-top:5px;'>Psychosocial, Environmental, and Other Factors</td>";
    tableHeaderAxisIII += "</tr>";
    tableHeaderAxisIII += "<tr>";
    tableHeaderAxisIII += "<td align='left' width='5%' style='padding-top:5px;'>&nbsp;</td>";
    tableHeaderAxisIII += "<td align='left' width='55%' style='padding-top:5px;'>Source</td>";
    tableHeaderAxisIII += "</tr>";
    var result2 = $.xmlDOM(result);
    var tableBodyAxisIII = "";
    $(result2).find('DocumentDiagnosisFactors').each(function() {
        tableBodyAxisIII += "<tr>";
        tableBodyAxisIII += "<td align='left'>&nbsp;</td>";
        tableBodyAxisIII += "<td align='left'>" + $(this).find('Factors').text() + "</td>";
        tableBodyAxisIII += "</tr>";
    });

    var tableHeaderAxisIV = "<tr>";
    tableHeaderAxisIV += "<td align='left' colspan='5' style='padding-top:5px;' >Axis IV</td>";
    tableHeaderAxisIV += "</tr>";
    var result3 = $.xmlDOM(result);
    var tableBodyAxisIV = "";
    $(result3).find('DiagnosesIV').each(function() {
        tableBodyAxisIV += "<tr>";
        //below Changes by made Rahul Aneja ref: task#2129 in Thresholds bugs & features ,show all For Axis IV - single line with comma separate values for what is checked ,
        var specification = $(this).find('Specification').text();
        if (specification.substring(specification.length - 2, specification.length - 1) === ",")
            specification = specification.substring(0, specification.length - 2);

        tableBodyAxisIV += "<td align='left' colspan='5'>" + specification + "</td>";
        //End Chages
        tableBodyAxisIV += "</tr>";
    });

    var tableHeaderAxisV = "<tr>";
    tableHeaderAxisV += "<td align='left'colspan='5'  style='padding-top:5px;'>Level of Functioning Score</td>";
    tableHeaderAxisV += "</tr>";
    var result4 = $.xmlDOM(result);
    var tableBodyAxisV = "";
    $(result4).find('DocumentDiagnosis').each(function() {
        tableBodyAxisV += "<tr>";
        tableBodyAxisV += "<td align='left' colspan='2'>GAF Score: " + $(this).find('GAFScore').text() + "</td>";
        tableBodyAxisV += "<td align='left' colspan='1'>WHODAS Score: " + $(this).find('WHODASScore').text() + "</td>";
        tableBodyAxisV += "<td align='left' colspan='2'>CAFAS Score: " + $(this).find('CAFASScore').text() + "</td>";
        tableBodyAxisV += "</tr>";
    });

    //tableBody += "</tbody>";

    var effectiveDate = $.xmlDOM(result).find('EffectiveDate').text();

    var trEffictiveDate = "<table width='100%'><tr><td align='left' width='20%'>Effective Date: " + effectiveDate + "</td></tr></table>";

    var DiagnosisHTML = trEffictiveDate + tableHeader + tableBody + "</tbody>" + endTable;
    $("[id$=divPreviousDiagnosis]").html(DiagnosisHTML);
}