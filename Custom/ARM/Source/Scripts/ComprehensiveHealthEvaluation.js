function SetScreenSpecificValues(dom, action) {
    if ($('#divPreviousDiagnosis').length > 0) {
        OpenPage(5763, 10977, 'CustomAjaxRequestType=GetCurrentDiagnosis', null, GetRelativePath(), null, null, pageActionEnum.CustomAjaxCall, null, null, null);
    }
}


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

    function ShowCustomToolTip(sender) {
        if ($(sender).attr('title') == '' || ($(sender) == 'undefined')) {
            $(sender).is("td")
            {
                $(sender).attr('title', $(sender).html());
            }
        }
    }

    function AddEventHandlers() {
        var DiagnosisList = $('CurrentDiagnoses', $.xmlDOM($('#hdnDiagnosisListInformation').val())).XMLExtractExactOrder();
        if (DiagnosisList.length > 0) {
            $('#divEmptyDiagnosisTemplate').hide();
            $("#divDiagnosisTemplate").html('');
            $("#TestDiagnosisListTemplate").tmpl(DiagnosisList).appendTo("#divDiagnosisTemplate");
            var _currentMentalHealthDiagnoses = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentHealthHomeHealthEvaluations", "CurrentMentalHealthDiagnoses");
            $("[id$=Span_CurrentMentalHealthDiagnoses]").text(_currentMentalHealthDiagnoses);
        }
        else {

            $('#thDiagnosisTemplate').hide();
            $('#divDiagnosisTemplate').hide();
            $('#divEmptyDiagnosisTemplate').visible = true;
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
        tableHeader += "<th align='left' width='15%'>DSMV</th>";
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
                dsmDesciption = "<span>" + dsmDesciption + "</span>";
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