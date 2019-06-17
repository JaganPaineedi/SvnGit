function SetCurrentTab(sender, e) {
    try {
        TabIndex = sender.activeTabIndex;

    }
    catch (err) { }
}


function StoreTabstripClientObject(sender) {
    tabobject = sender;
}

function ChangeTobaccoUse() {
    //debugger;
    //if ($('[id$=DropDownList_CustomDocumentSUAdmissions_TobaccoUse] :selected').val() != '') {

    if ($('[id$=DropDownList_CustomDocumentSUAdmissions_TobaccoUse]').length > 0) {
        var Globalcodeid = $('[id$=DropDownList_CustomDocumentSUAdmissions_TobaccoUse] :selected').val();
        if (Globalcodeid != '') {
            var requestParametersValues = "action=GetTobaccoUse&Globalcodeid=" + Globalcodeid;
            $.ajax({
                type: "POST",
                url: _ApplicationBasePath + "Custom/SUAdmission/WebPages/SUAdmissionServiceNote.aspx",
                data: requestParametersValues,
                success: function(result) {
                    //debugger;
                    if (result == '1' || result == '97' || result == '98' || result == '99') {
                        //Code
                        $('[id$=text_CustomDocumentSUAdmissions_AgeOfFirstTobaccoText]').attr("disabled", "disabled");
                        $("#RadioButton_CustomDocumentSUAdmissions_AgeOfFirstTobacco_N").attr('checked', 'checked');

                    }
                    else {
                        $('[id$=text_CustomDocumentSUAdmissions_AgeOfFirstTobaccoText]').removeAttr("disabled");
                        $("#RadioButton_CustomDocumentSUAdmissions_AgeOfFirstTobacco_N").attr('checked', false);

                    }
                }
            });
        }
        else {
            $('[id$=text_CustomDocumentSUAdmissions_AgeOfFirstTobaccoText]').removeAttr("disabled");
            $("#RadioButton_CustomDocumentSUAdmissions_AgeOfFirstTobacco_N").attr('checked', false);
        }
    }
}

function ChangeGender() {
    
    if ($('[id$=DropDownList_CustomDocumentSUAdmissions_Gender]').length > 0) {
        var Gender = $('[id$=DropDownList_CustomDocumentSUAdmissions_Gender] :selected').text();
        if (Gender == "Male") {

            $("#RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_MissedLastTwoPeriods_A").attr('checked', 'checked');
            CreateAutoSaveXml("CustomDocumentInfectiousDiseaseRiskAssessments", "MissedLastTwoPeriods", 'A');
        } else {
            $("#RadioButton_CustomDocumentInfectiousDiseaseRiskAssessments_MissedLastTwoPeriods_A").removeAttr("checked");
            CreateAutoSaveXml("CustomDocumentInfectiousDiseaseRiskAssessments", "MissedLastTwoPeriods", 'N');
        }
        if (Gender == "Other") {
            $("#trGenderOther").attr("style", "display:block");
        }
        else {
            $("#trGenderOther").attr("style", "display:none");
            CreateAutoSaveXml("CustomDocumentSUAdmissions", "GenderOther", '');
        }
    }
}
function ChangeAdmittedPopulation() {
    //debugger;   
    if ($('[id$=DropDownList_CustomDocumentSUAdmissions_AdmittedPopulation]').length > 0) {
        var Globalcodeid = $('[id$=DropDownList_CustomDocumentSUAdmissions_AdmittedPopulation] :selected').val();
        if (Globalcodeid != '') {
            var requestParametersValues = "action=GetAdmittedPopulation&Globalcodeid=" + Globalcodeid;
            $.ajax({
                type: "POST",
                url: _ApplicationBasePath + "Custom/SUAdmission/WebPages/SUAdmissionServiceNote.aspx",
                data: requestParametersValues,
                success: function(result) {
                    //debugger;
                    if (result == '4' || result == '20' || result == '21' || result == '24') {
                        //Code
                        $("#RadioButton_CustomDocumentSUAdmissions_CoDependent_Y").attr('checked', 'checked');
                        CreateAutoSaveXml("CustomDocumentSUAdmissions", "CoDependent", 'Y');

                    }
                    else {
                        $("#RadioButton_CustomDocumentSUAdmissions_CoDependent_N").attr('checked', 'checked');
                        CreateAutoSaveXml("CustomDocumentSUAdmissions", "CoDependent", 'N');

                    }
                }
            });
        }
        else {
            $("#RadioButton_CustomDocumentSUAdmissions_CoDependent_Y").attr('checked', false);
            $("#RadioButton_CustomDocumentSUAdmissions_CoDependent_N").attr('checked', false);
        }
    }
}

AddEventHandlers = (function() {

    try {
        var EverHadBloodTestForHepatitisC = AutoSaveXMLDom.find("CustomDocumentInfectiousDiseaseRiskAssessments:first EverHadBloodTestForHepatitisC").text();
        if (EverHadBloodTestForHepatitisC) {
            if (EverHadBloodTestForHepatitisC == 'Y') {
                $("#trEverHadBloodTestForHepatitisAntibody").attr("style", "display:block");
                $("#trEverHadBloodTestForHepatitisAntibody1").attr("style", "display:none");
            }
            else {
                $("#trEverHadBloodTestForHepatitisAntibody").attr("style", "display:none");
                $("#trEverHadBloodTestForHepatitisAntibody1").attr("style", "display:block");
            }
        }
        else {
            $("#trEverHadBloodTestForHepatitisAntibody").attr("style", "display:none");
            $("#trEverHadBloodTestForHepatitisAntibody1").attr("style", "display:none");
        }

        var EverHadBloodTestForHIVAntibody = AutoSaveXMLDom.find("CustomDocumentInfectiousDiseaseRiskAssessments:first EverHadBloodTestForHIVAntibody").text();
        if (EverHadBloodTestForHIVAntibody) {
            if (EverHadBloodTestForHIVAntibody == 'Y') {
                $("#trEverHadBloodTestForHIVAntibody").attr("style", "display:block");
                $("#trEverHadBloodTestForHIVAntibody1").attr("style", "display:none");
            }
            else {
                $("#trEverHadBloodTestForHIVAntibody").attr("style", "display:none");
                $("#trEverHadBloodTestForHIVAntibody1").attr("style", "display:block");
            }
        }
        else {
            $("#trEverHadBloodTestForHIVAntibody").attr("style", "display:none");
            $("#trEverHadBloodTestForHIVAntibody1").attr("style", "display:none");
        }

        var ClientReferredHealthOrAgency = AutoSaveXMLDom.find("CustomDocumentInfectiousDiseaseRiskAssessments:first ClientReferredHealthOrAgency").text();
        if (ClientReferredHealthOrAgency) {
            if (ClientReferredHealthOrAgency == 'Y') {
                $("#trshowClientReferred").attr("style", "display:block");

            }
            else {
                $("#trshowClientReferred").attr("style", "display:none");

            }
        }
        else {
            $("#trshowClientReferred").attr("style", "display:none");

        }
        if ($('[id$=DropDownList_CustomDocumentSUAdmissions_Gender] :selected').text() != '') {
            ChangeGender();
        }

    }
    catch (ex) {
    }
});
showCurrentBloodTestHepatitis = (function(obj) {

    if (obj == 'Y') {

        $("#trEverHadBloodTestForHepatitisAntibody").attr("style", "display:block");
        $("#trEverHadBloodTestForHepatitisAntibody1").attr("style", "display:none");
    }
    else {
        $("#trEverHadBloodTestForHepatitisAntibody").attr("style", "display:none");
        $("#trEverHadBloodTestForHepatitisAntibody1").attr("style", "display:block");
    }
});

showCurrentBloodTestHIV = (function(obj) {

    if (obj == 'Y') {

        $("#trEverHadBloodTestForHIVAntibody").attr("style", "display:block");
        $("#trEverHadBloodTestForHIVAntibody1").attr("style", "display:none");
    }
    else {
        $("#trEverHadBloodTestForHIVAntibody").attr("style", "display:none");
        $("#trEverHadBloodTestForHIVAntibody1").attr("style", "display:block");
    }
});

showClientReferred = (function(obj) {

    if (obj == 'Y') {

        $("#trshowClientReferred").attr("style", "display:block");

    }
    else {
        $("#trshowClientReferred").attr("style", "display:none");

    }
});

function SetScreenSpecificValues(dom, action) {
    //debugger;
    try {
        var historytabobject = tabobject._selectedIndex;
        if (historytabobject >= 0) {
            selectedTabText = tabobject.get_selectedTab().get_text();
            if (historytabobject == 2 && selectedTabText == 'Diagnosis') {
                if ($('#divPreviousDiagnosis').length > 0) {
                    BindPreviousDiagnosis();
                }
            }
            if (historytabobject == 1 && selectedTabText == 'Substanceuse') {
                if ($('[id$=DropDownList_CustomDocumentSUAdmissions_AdmittedPopulation] :selected').val() != '') {
                    ChangeAdmittedPopulation();
                }
                if ($('[id$=DropDownList_CustomDocumentSUAdmissions_Gender] :selected').text() != '') {
                    ChangeGender();
                }
            }

        }
    }
    catch (err) {
    }
}


function BindPreviousDiagnosis() {
    try {
        $.ajax({
            type: "POST",
            url: GetRelativePath() + "Custom/SUAdmission/WebPages/SUAdmissionServiceNote.aspx",
            data: "action=GetPreviousDiagnosis",
            success: function(result) {
                if (result != '') {
                    CreateDiagnosisTable(result);
                }
            }
        })
    }
    catch (ex) { }
}

function CreateDiagnosisTable(result) {
    var tableHeader = "<table width='100%'><thead><tr>";
    var tableBody = "<tbody>";
    var endTable = "</table>";
    tableHeader += "<tr>";
    tableHeader += "<th align='left' colspan='5' style='padding-top:5px;'>Diagnosis List</th>";
    tableHeader += "</tr>";
    tableHeader += "<tr>";
    tableHeader += "<th align='left' width='10%'>Order</th>";
    tableHeader += "<th align='left' width='20%'>DSM V/ICD 10</th>";
    tableHeader += "<th align='left' width='20%'>DSM IV/ICD 9</th>";
    tableHeader += "<th align='left' width='20%'>Description</th>";
    tableHeader += "<th align='left' width='15%'>Type</th>";
    tableHeader += "<th align='left' width='15%'>Severity</th>";
    tableHeader += "</tr></thead>";
    var result1 = $.xmlDOM(result);
    $(result1).find('DocumentDiagnosisCodes').each(function() {
        tableBody += "<tr>";
        tableBody += "<td align='left'>" + $(this).find('DiagnosisOrder').text() + "</td>";
        tableBody += "<td align='left'>" + $(this).find('ICD10Code').text() + "</td>";
        tableBody += "<td align='left'>" + $(this).find('ICD9Code').text() + "</td>";
        var dsmDesciption = $(this).find('DSMDescription').text();
        if (dsmDesciption.length > 30)
            dsmDesciption = "<span title='" + dsmDesciption + "'>" + dsmDesciption.substring(0, 30) + "..." + "</span>";
        else
            dsmDesciption = "<span>" + dsmDesciption + "</span>";

        tableBody += "<td align='left'>" + dsmDesciption + "</td>";
        tableBody += "<td align='left'>" + $(this).find('DiagnosisType').text() + "</td>";
        tableBody += "<td align='left'>" + $(this).find('Severity').text() + "</td>";
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

    var DiagnosisHTML = trEffictiveDate + tableHeader + tableBody + tableHeaderAxisIII + tableBodyAxisIII + tableHeaderAxisV + tableBodyAxisV + "</tbody>" + endTable;
    $("[id$=divPreviousDiagnosis]").html(DiagnosisHTML);
}