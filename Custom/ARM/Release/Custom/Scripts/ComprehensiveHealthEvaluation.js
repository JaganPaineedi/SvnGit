// Function to handle the Insert into grid call from insert and modify button
var ComprehensiveHealthEvaluation = ComprehensiveHealthEvaluation || {
    InsertGrid_CustomDocumentHealthHomeCarePlanDiagnosesData: function(gridDatatable, gridDivName, dataGridID, buttonCtrl) {
        var filterval = 'GridDataTable=' + gridDatatable + '^GridDivName=' + gridDivName + '^DataGridID=' + dataGridID + '^ButtonCtrl=' + buttonCtrl.id + '^TableName=CustomDocumentHealthHomeCarePlanDiagnoses'
        OpenPage(5763, 10977, 'CustomAjaxRequestType=CountSequenceNumber^' + filterval, null, GetRelativePath(), null, null, pageActionEnum.CustomAjaxCall, null, null, null);
   },

    CalculateBMI: function() {

        var BMI = 0;

        var height = $("#TextBox_CustomDocumentHealthHomeHealthEvaluations_ClientHeight").val();
        var weight = $("#TextBox_CustomDocumentHealthHomeHealthEvaluations_ClientWeight").val();
        if (weight && height) {
            BMI = (weight / (height * height)) * 703;
            BMI = Math.round(BMI);
            $("#TextBox_CustomDocumentHealthHomeHealthEvaluations_ClientBMI").val(BMI);
        }

    }
};

function onlyNumbers(evt) {
    var s = $("#TextBox_CustomDocumentHealthHomeHealthEvaluations_ClientBloodPressure").val();
    for (var i = 0; i < s.length; i++) {
        var charCode = s.charCodeAt(i);
        if (charCode < 47 || charCode > 57) {
            $("#TextBox_CustomDocumentHealthHomeHealthEvaluations_ClientBloodPressure").val('');
            return false;
        }
    }
    return true;
}


function InsertGrid_CustomDocumentHealthHomeCarePlanPESNeedsData(gridDatatable, gridDivName, dataGridID, buttonCtrl) {
    $("#HiddenField_CustomDocumentHealthHomeCarePlanPESNeeds_SupportNeed").val($('[id$=DropDownList_CustomDocumentHealthHomeCarePlanPESNeeds_PsychosocialSupportNeedType] option:selected').text()); 
   InsertGridData(gridDatatable, gridDivName, dataGridID, buttonCtrl);}

function Clear_CustomDocumentHealthHomeCarePlanPESNeeds_Data() {
        var $clearObject = $("#TableChildControl_CustomDocumentHealthHomeCarePlanPESNeeds");
        $("input[required=true]", $clearObject).removeClass('requiredfield');
        ClearTable('TableChildControl_CustomDocumentHealthHomeCarePlanPESNeeds');
        $('[id$=RadioButtonId]').removeAttr('checked');
        $("[id$=TableChildControl_CustomDocumentHealthHomeCarePlanPESNeeds_ButtonInsert").val('Insert');
    }

    function SetTabUcPath() {
        return "/Custom/WebPages/CustomComprehensiveHealthEvaluation.ascx";
    }

    function Clear_CustomDocumentHealthHomeCarePlanDiagnoses_Data() {
        ClearTable('TableChildControl_CustomDocumentHealthHomeCarePlanDiagnoses');
        $('#TextBox_CustomDocumentHealthHomeCarePlanDiagnoses_ReportedDiagnosis').focus();
        $('[id$=RadioButtonId]').removeAttr('checked');
        $("[id$=TableChildControl_CustomDocumentHealthHomeCarePlanDiagnoses_ButtonInsert").val('Insert');
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