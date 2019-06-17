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