function SetScreenSpecificValues(dom, action) {
    if ($('#divPreviousDiagnosis').length > 0) {
        OpenPage(5763, 10979, 'CustomAjaxRequestType=GetCurrentDiagnosis', null, GetRelativePath(), null, null, pageActionEnum.CustomAjaxCall, null, null, null);
    }
}

function removeSpaces(string) {
    return string.split(' ').join('');
}

var isNN = (navigator.appName.indexOf("Netscape") != -1);
function autoTab(input, len, e) {
    var keyCode = (isNN) ? e.which : e.keyCode;
    var filter = (isNN) ? [0, 8, 9] : [0, 8, 9, 16, 17, 18, 37, 38, 39, 40, 46];
    if (input.value.length >= len && !containsElement(filter, keyCode)) {
        input.value = input.value.slice(0, len);
        input.form[(getIndex(input) + 1) % input.form.length].focus();
    }

    function containsElement(arr, ele) {
        var found = false, index = 0;
        while (!found && index < arr.length)
            if (arr[index] == ele)
            found = true;
        else
            index++;
        return found;
    }

    function getIndex(input) {
        var index = -1, i = 0, found = false;
        while (i < input.form.length && index == -1)
            if (input.form[i] == input) index = i;
        else i++;
        return index;
    }
    return true;
}

//#region PhoneNumber Validation 
var PhoneNumber;
var PhoneNumber1;
var PhoneNumber2;
var PhoneNumber3;
var PhoneNumber4;
function UpdatePhone(val) {
    PhoneNumber1 = $("[id$=TextBox_CustomDocumentHealthHomeCommPlanFamilyMembers_FamilyMemberPhone1]").val();
    PhoneNumber2 = $("[id$=TextBox_CustomDocumentHealthHomeCommPlanFamilyMembers_FamilyMemberPhone2]").val();
    PhoneNumber3 = $("[id$=TextBox_CustomDocumentHealthHomeCommPlanFamilyMembers_FamilyMemberPhone3]").val();
    PhoneNumber4 = $("[id$=TextBox_CustomDocumentHealthHomeCommPlanFamilyMembers_FamilyMemberPhone4]").val();
    var isValid;
    switch (val) {
        case '1':
            if (CheckPhone1())
                isValid = true;
            else
                isValid = false;
            break;
        case '2':
            if (CheckPhone2())
                isValid = true;
            else
                isValid = false;
            break;
        case '3':
            if (CheckPhone3())
                isValid = true;
            else
                isValid = false;
            break;
        case '4':
            if (CheckPhone4())
                isValid = true;
            else
                isValid = false;
            break;
    }
    if (isValid) {
        if (PhoneNumber1 == "" && PhoneNumber2 == "" && PhoneNumber3 == "" && PhoneNumber4 == "")
            PhoneNumber = "";
        else {
            PhoneNumber = "(" + PhoneNumber1 + ") " + PhoneNumber2 + "-" + PhoneNumber3;
            if (PhoneNumber4 != "") {
                PhoneNumber += " Ext " + PhoneNumber4;
            }
        }
        CreateAutoSaveXml("CustomDocumentHealthHomeCommPlanFamilyMembers", "FamilyMemberPhone", PhoneNumber);
        $("#HiddenField_CustomDocumentHealthHomeCommPlanFamilyMembers_FamilyMemberPhone").val(PhoneNumber);
        ShowHideErrorMessage("", 'false');
        return true;
    }
    else {
        ShowHideErrorMessage("Please enter valid Phone Number", 'true');
        return false;
    }
}

function CheckPhone1() {
    if (PhoneNumber1 == "") { }
    else if (PhoneNumber1.length < 3) {
        $("[id$=TextBox_CustomDocumentHealthHomeCommPlanFamilyMembers_FamilyMemberPhone1]").focus();
        return false;
    }
    return true;
}
function CheckPhone2() {
    if (PhoneNumber1 == "" && PhoneNumber2 == "") { }
    else if (PhoneNumber1 != "" && PhoneNumber2.length < 3) {
        $("[id$=TextBox_CustomDocumentHealthHomeCommPlanFamilyMembers_FamilyMemberPhone1]").focus();
        return false;
    }
    else if (PhoneNumber2.length < 3) {
        $("[id$=TextBox_CustomDocumentHealthHomeReferrals_Phone1]").focus();
        return false;
    }
    return true;
}
function CheckPhone3() {
    if (PhoneNumber2 == "" && PhoneNumber3 == "") { }
    else if (PhoneNumber2 == "" && PhoneNumber3.length > 0) {
        if (PhoneNumber3.length < 4)
            $("[id$=TextBox_CustomDocumentHealthHomeCommPlanFamilyMembers_FamilyMemberPhone1]").focus();
        else
            $("[id$=TextBox_CustomDocumentHealthHomeCommPlanFamilyMembers_FamilyMemberPhone1]").focus();
        return false;
    } else if (PhoneNumber2 != "") {
        if (PhoneNumber3.length == 0) {
            return false;
        }
        else if (PhoneNumber3.length < 4) {
            $("[id$=TextBox_CustomDocumentHealthHomeCommPlanFamilyMembers_FamilyMemberPhone1]").focus()
            return false;
        }
    }
    return true;
}
function CheckPhone4() {
    if (PhoneNumber2 == "" && PhoneNumber3 == "") {
        $("[id$=TextBox_CustomDocumentHealthHomeCommPlanFamilyMembers_FamilyMemberPhone1]").val('');
    }
    else {
        if (PhoneNumber2.length == 0) {
            $("[id$=TextBox_CustomDocumentHealthHomeCommPlanFamilyMembers_FamilyMemberPhone1]").focus();
        }
        else if (PhoneNumber3.length == 0) {
            $("[id$=TextBox_CustomDocumentHealthHomeCommPlanFamilyMembers_FamilyMemberPhone1]").focus();
        }
    }
    return true;
}

function AddParentChildRadioClickEventHandlerForCIR(key, rowIndex, obj, customGridTableName, gridPageName, insertButtonId) {
    SetPhoneValues(gridPageName, key);
}

function SetPhoneValues(gridPageName, key) {
    var PhoneNum = null;
    var textBox1;
    var textBox2;
    var textBox2;
    var textBox4;
    PhoneNum = GetColumnValueInXMLNodeByKeyValue("CustomDocumentHealthHomeCommPlanFamilyMembers", "HealthHomeCommPlanFamilyMemberId", key, "FamilyMemberPhone", $.xmlDOM(objectPageResponse.ScreenDataSetXml));
    textBox1 = 'TextBox_CustomDocumentHealthHomeCommPlanFamilyMembers_FamilyMemberPhone1';
    textBox2 = 'TextBox_CustomDocumentHealthHomeCommPlanFamilyMembers_FamilyMemberPhone2';
    textBox3 = 'TextBox_CustomDocumentHealthHomeCommPlanFamilyMembers_FamilyMemberPhone3';
    textBox4 = 'TextBox_CustomDocumentHealthHomeCommPlanFamilyMembers_FamilyMemberPhone4';

    if (PhoneNum != null) {
        var newPhoneNum = removeSpaces(PhoneNum);
        var PhoneNumberLength = newPhoneNum.length;
        var indexofPHN1 = newPhoneNum.indexOf('(');
        var indexofPHN2 = newPhoneNum.indexOf(')');
        var indexofPHN3 = newPhoneNum.indexOf('-');
        if (indexofPHN2 - indexofPHN1 == 1) {
            $("[id$=" + textBox1 + "]").val();
            $("[id$=" + textBox2 + "]").val(newPhoneNum.substring(2, 5));
            $("[id$=" + textBox3 + "]").val(newPhoneNum.substring(6, 10));
        }
        else {
            $("[id$=" + textBox1 + "]").val(newPhoneNum.substring(1, 4));
            $("[id$=" + textBox2 + "]").val(newPhoneNum.substring(5, 8));
            $("[id$=" + textBox3 + "]").val(newPhoneNum.substring(9, 13));
        }
        var indexofExt = newPhoneNum.indexOf('Ext');
        if (indexofExt != "-1") {
            $("[id$=" + textBox4 + "]").val(newPhoneNum.substring(indexofExt + 3, PhoneNumberLength));
        }
    }
}

function InsertGrid_CustomDocumentHealthHomeCommPlanFamilyMembersData(gridDatatable, gridDivName, dataGridID, buttonCtrl) {
    InsertGridData(gridDatatable, gridDivName, dataGridID, buttonCtrl);
}

function Clear_CustomDocumentHealthHomeCommPlanFamilyMembers_Data() {
    ClearTable('TableChildControl_CustomDocumentHealthHomeCommPlanFamilyMembers');
    $("[id$=InsertGrid_CustomDocumentHealthHomeCommPlanFamilyMembers]").find("input[type=radio]").removeAttr('checked');
    $("[id$=TableChildControl_CustomDocumentHealthHomeCommPlanFamilyMembers_ButtonInsert]").val("Insert");
    $("#HiddenField_CustomDocumentHealthHomeCommPlanFamilyMembers_HealthHomeCommPlanFamilyMemberId").val(-1);
}

function InsertGrid_CustomDocumentHealthHomeMentalHealthCrisisPlanStepsData(gridDatatable, gridDivName, dataGridID, buttonCtrl) {
    InsertGridData(gridDatatable, gridDivName, dataGridID, buttonCtrl);
}

function Clear_CustomDocumentHealthHomeMentalHealthCrisisPlanSteps_Data() {
    ClearTable('TableChildControl_CustomDocumentHealthHomeMentalHealthCrisisPlanSteps');
    $("[id$=InsertGrid_CustomDocumentHealthHomeMentalHealthCrisisPlanSteps]").find("input[type=radio]").removeAttr('checked');
    $("[id$=TableChildControl_CustomDocumentHealthHomeMentalHealthCrisisPlanSteps_ButtonInsert]").val("Insert");
}

function InsertGrid_CustomDocumentHealthHomeCrisisPlanTypesData(gridDatatable, gridDivName, dataGridID, buttonCtrl) {
    $('[id$=HiddenFieldCustomAjaxCallType]').val('PlanTypes');
    var filterval = 'GridDataTable=' + gridDatatable + '^GridDivName=' + gridDivName + '^DataGridID=' + dataGridID + '^ButtonCtrl=' + buttonCtrl.id + '^TableName=CustomDocumentHealthHomeCrisisPlanTypes'
    OpenPage(5763, 10979, 'CustomAjaxRequestType=CountSequenceNumber^' + filterval, null, GetRelativePath(), null, null, pageActionEnum.CustomAjaxCall, null, null, null);
}

function Clear_CustomDocumentHealthHomeCrisisPlanTypes_Data() {
    ClearTable('TableChildControl_CustomDocumentHealthHomeCrisisPlanTypes');
    $("[id$=InsertGrid_CustomDocumentHealthHomeCrisisPlanTypes]").find("input[type=radio]").removeAttr('checked');
    $("[id$=TableChildControl_CustomDocumentHealthHomeCrisisPlanTypes_ButtonInsert]").val("Insert");
}

function SetTabUcPath() {
    return "/Custom/WebPages/HealthHomeCrisisPlan.ascx";
}
function InsertGrid_CustomDocumentHealthHomeCarePlanDiagnosesData(gridDatatable, gridDivName, dataGridID, buttonCtrl) {
    $('[id$=HiddenFieldCustomAjaxCallType]').val('PlanDiagnoses');
    var filterval = 'GridDataTable=' + gridDatatable + '^GridDivName=' + gridDivName + '^DataGridID=' + dataGridID + '^ButtonCtrl=' + buttonCtrl.id + '^TableName=CustomDocumentHealthHomeCarePlanDiagnoses'
    OpenPage(5763, 10979, 'CustomAjaxRequestType=CountSequenceNumber^' + filterval, null, GetRelativePath(), null, null, pageActionEnum.CustomAjaxCall, null, null, null);
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
        CustomAjaxRequestType = $('[id$=HiddenFieldCustomAjaxCallType]').val();
        var pageResponse = result;
        var start = pageResponse.indexOf("###StartUc###") + 13;
        var end = pageResponse.indexOf("###EndUc###");
        var htmlResponse = pageResponse.substr(start, end - start);
        var splitval = [];
        splitval = htmlResponse.split('^');
        if (CustomAjaxRequestType == 'PlanTypes') {
            $("#HiddenField_CustomDocumentHealthHomeCrisisPlanTypes_SequenceNumber").val(splitval[4]);
        }
        else {
            $("#HiddenField_CustomDocumentHealthHomeCarePlanDiagnoses_SequenceNumber").val(splitval[4]);
        }
        InsertGridData(splitval[0], splitval[1], splitval[2], splitval[3]);
    }
}

function AddEventHandlers() {
    var DiagnosisList = $('CurrentDiagnoses', $.xmlDOM($('#hdnDiagnosisListInformation').val())).XMLExtractExactOrder();
    if (DiagnosisList.length > 0) {
        $('#divEmptyDiagnosisTemplate').hide();
        $("#divDiagnosisTemplate").html('');
        $("#TestDiagnosisListTemplate").tmpl(DiagnosisList).appendTo("#divDiagnosisTemplate");
        var _currentMentalHealthDiagnoses = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentHealthHomeCrisisPlans", "CurrentMentalHealthDiagnoses");
        $("[id$=Span_CurrentMentalHealthDiagnoses]").text(_currentMentalHealthDiagnoses);
    }
    else {

        $('#thDiagnosisTemplate').hide();
        $('#divDiagnosisTemplate').hide();
        $('#divEmptyDiagnosisTemplate').visible = true;
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