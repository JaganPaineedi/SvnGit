function AddEventHandlers() {
    if ($("#CheckBox_CustomDocumentHealthHomeTransitionPlans_TransitionFromNA").attr("checked") == false) {
        $('[id$=TransitionFrom]').attr('disabled', '');        
    }
    else {
        $('[id$=TransitionFrom]').attr('disabled', true);
        $('[id$=TextArea_CustomDocumentHealthHomeTransitionPlans_TransitionFromEntityTypeComment]').attr('disabled','disabled');
    }
    if ($("#CheckBox_CustomDocumentHealthHomeTransitionPlans_TransitionToNA").attr("checked") == false) {
        $('[id$=TransitionTo]').attr('disabled', '');
    }
    else {
        $('[id$=TransitionTo]').attr('disabled', true);
        $('[id$=TextArea_CustomDocumentHealthHomeTransitionPlans_TransitionToEntityTypeComment]').attr('disabled','disabled');
    }
    if ($("#RadioButton_CustomDocumentHealthHomeTransitionPlans_HasRerralsToAdditionalProvider_Y").attr("checked") == true) {
        $('[id$=Referrals]').show();
    }
    else {
        $('[id$=Referrals]').hide();
    }
    if ($("#RadioButton_CustomDocumentHealthHomeTransitionPlans_RequiresAuthsForAdditionalProvider_Y").attr("checked") == true) {
        $('[id$=PriorAuthorization]').show();
    }
    else {
        $('[id$=PriorAuthorization]').hide();
    }

    if ($("#CheckBox_CustomDocumentHealthHomeTransitionPlans_ResidenceFollowingDischargeNA").attr("checked") == false) {
        $('[id$=divresidence]').attr('disabled', '');
    }
    else {
        $('[id$=divresidence]').attr('disabled', true);
        $('[id$=TextArea_CustomDocumentHealthHomeTransitionPlans_ResidencePlanForLongTerm]').attr('disabled', 'disabled');
    }
}

function HideTable(control, controltodisable,controlTextArea) {
    if ($(control).attr("checked") == true) {
        $('[id$=' + controltodisable + ']').attr('disabled', true);
        $('[id$=' + controlTextArea + ']').attr('disabled', 'disabled');
    }
    else {
        $('[id$=' + controltodisable + ']').attr('disabled', '');
        $('[id$=' + controlTextArea + ']').attr('disabled', '');
    }
}

function ShowHideReferrals() {
    if ($("#RadioButton_CustomDocumentHealthHomeTransitionPlans_HasRerralsToAdditionalProvider_Y").attr("checked") == true) {
        $('[id$=Referrals]').show();
    }
    else {
        $('[id$=Referrals]').hide();
    }
}

function ShowHidePriorAuthorization() {
    if ($("#RadioButton_CustomDocumentHealthHomeTransitionPlans_RequiresAuthsForAdditionalProvider_Y").attr("checked") == true) {
        $('[id$=PriorAuthorization]').show();
    }
    else {
        $('[id$=PriorAuthorization]').hide();
    }
}
function maxLength(field, maxChars) {
    if (field.value.length >= maxChars) {
        event.returnValue = false;
        return false;
    }
}

function maxLengthPaste(field, maxChars) {
    event.returnValue = false;
    if ((field.value.length + window.clipboardData.getData("Text").length) > maxChars) {
        return false;
    }
    event.returnValue = true;
}

//$('[Id$=TextBox_CustomDocumentHealthHomeTransitionPlans_Referral]').focus();

function Clear_CustomDocumentHealthHomePriorAuthorizations_Data() {
    ClearTable('TableChildControl_CustomDocumentHealthHomePriorAuthorizations');
    $('[id$=RadioButtonId]').removeAttr('checked');
    $("[id$=TableChildControl_CustomDocumentHealthHomePriorAuthorizations_ButtonInsert").val('Insert');
    $('[Id$=TextBox_CustomDocumentHealthHomePriorAuthorizations_ServiceDescription]').focus();
}

function SetTabUcPath() {
    return "/ActivityPages/Client/Detail/Documents/Harbor/TransitionPlan.ascx";
}

function insertCustomDocumentHealthHomePriorAuthorizations(gridDatatable, gridDivName, dataGridID, buttonCtrl) {
//    if ($("[id$=TableChildControl_CustomDocumentHealthHomePriorAuthorizations_ButtonInsert").val() == "Insert") {
//        $.ajax({
//            type: "POST",
//            async: false,
//            url: "../AjaxScript.aspx?functionName=CountSequenceNumber",
//            data: 'TableName=CustomDocumentHealthHomePriorAuthorizations',
//            success: function(result) {
//            $("#HiddenField_CustomDocumentHealthHomePriorAuthorizations_SequenceNumber").val(result);
//            }
//        });
//    }
    $('[id$=HiddenFieldCustomAjaxCallType]').val('PriorAuthorizations');
    var filterval = 'GridDataTable=' + gridDatatable + '^GridDivName=' + gridDivName + '^DataGridID=' + dataGridID + '^ButtonCtrl=' + buttonCtrl.id + '^TableName=CustomDocumentHealthHomePriorAuthorizations'
    OpenPage(5763, 10978, 'CustomAjaxRequestType=CountSequenceNumber^' + filterval, null, GetRelativePath(), null, null, pageActionEnum.CustomAjaxCall, null, null, null);
}

function Clear_CustomDocumentHealthHomeReferrals_Data() {
    ClearTable('TableChildControl_CustomDocumentHealthHomeReferrals');
    $('[id$=RadioButtonId]').removeAttr('checked');
    $("[id$=TableChildControl_CustomDocumentHealthHomeReferrals_ButtonInsert").val('Insert');
    $('[Id$=TextBox_CustomDocumentHealthHomeTransitionPlans_Referral]').focus();
}
function insertCustomDocumentHealthHomeReferrals(gridDatatable, gridDivName, dataGridID, buttonCtrl) {
//    if ($("[id$=TableChildControl_CustomDocumentHealthHomeReferrals_ButtonInsert").val() == "Insert") {
//        $.ajax({
//            type: "POST",
//            async: false,
//            url: "../AjaxScript.aspx?functionName=CountSequenceNumber",
//            data: 'TableName=CustomDocumentHealthHomeReferrals',
//            success: function(result) {
//                $("#HiddenField_CustomDocumentHealthHomeReferrals_SequenceNumber").val(result);
//            }
//        });
//    }
    $('[id$=HiddenFieldCustomAjaxCallType]').val('HomeReferrals');
    var filterval = 'GridDataTable=' + gridDatatable + '^GridDivName=' + gridDivName + '^DataGridID=' + dataGridID + '^ButtonCtrl=' + buttonCtrl.id + '^TableName=CustomDocumentHealthHomeReferrals'
    OpenPage(5763, 10978, 'CustomAjaxRequestType=CountSequenceNumber^' + filterval, null, GetRelativePath(), null, null, pageActionEnum.CustomAjaxCall, null, null, null);
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
    PhoneNumber1 = $("[id$=TextBox_CustomDocumentHealthHomeReferrals_Phone1]").val();
    PhoneNumber2 = $("[id$=TextBox_CustomDocumentHealthHomeReferrals_Phone2]").val();
    PhoneNumber3 = $("[id$=TextBox_CustomDocumentHealthHomeReferrals_Phone3]").val();
    PhoneNumber4 = $("[id$=TextBox_CustomDocumentHealthHomeReferrals_Phone4]").val();
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
        CreateAutoSaveXml("CustomDocumentHealthHomeReferrals", "Phone", PhoneNumber);
        $("#HiddenField_CustomDocumentHealthHomeReferrals_Phone").val(PhoneNumber); 
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
    $("[id$=TextBox_CustomDocumentHealthHomeReferrals_Phone1]").focus();
        return false;
    }
    return true;
}
function CheckPhone2() {
    if (PhoneNumber1 == "" && PhoneNumber2 == "") { }
    else if (PhoneNumber1 != "" && PhoneNumber2.length < 3) {
    $("[id$=TextBox_CustomDocumentHealthHomeReferrals_Phone1]").focus();
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
            $("[id$=TextBox_CustomDocumentHealthHomeReferrals_Phone1]").focus();
        else
            $("[id$=TextBox_CustomDocumentHealthHomeReferrals_Phone1]").focus();
        return false;
    } else if (PhoneNumber2 != "") {
        if (PhoneNumber3.length == 0) {
            return false;
        }
        else if (PhoneNumber3.length < 4) {
        $("[id$=TextBox_CustomDocumentHealthHomeReferrals_Phone1]").focus()
            return false;
        }
    }
    return true;
}
function CheckPhone4() {
    if (PhoneNumber2 == "" && PhoneNumber3 == "") {
        $("[id$=TextBox_CustomDocumentHealthHomeReferrals_Phone1]").val('');
    }
    else {
        if (PhoneNumber2.length == 0) {
            $("[id$=TextBox_CustomDocumentHealthHomeReferrals_Phone1]").focus();
        }
        else if (PhoneNumber3.length == 0) {
        $("[id$=TextBox_CustomDocumentHealthHomeReferrals_Phone1]").focus();
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
    PhoneNum = GetColumnValueInXMLNodeByKeyValue("CustomDocumentHealthHomeReferrals", "HealthHomeReferralId", key, "Phone", $.xmlDOM(objectPageResponse.ScreenDataSetXml));
    textBox1 = 'TextBox_CustomDocumentHealthHomeReferrals_Phone1';
    textBox2 = 'TextBox_CustomDocumentHealthHomeReferrals_Phone2';
    textBox3 = 'TextBox_CustomDocumentHealthHomeReferrals_Phone3';
    textBox4 = 'TextBox_CustomDocumentHealthHomeReferrals_Phone4';

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

function removeSpaces(string) {
    return string.split(' ').join('');
}

function CustomAjaxRequestCallback(result, CutomAjaxRequest) {
    CustomAjaxRequestType = $('[id$=HiddenFieldCustomAjaxCallType]').val();
    var pageResponse = result;
    var start = pageResponse.indexOf("###StartUc###") + 13;
    var end = pageResponse.indexOf("###EndUc###");
    var htmlResponse = pageResponse.substr(start, end - start);
    var splitval = [];
    splitval = htmlResponse.split('^');
    if (CustomAjaxRequestType == 'PriorAuthorizations') {
        $("#HiddenField_CustomDocumentHealthHomePriorAuthorizations_SequenceNumber").val(splitval[4]);
    }
    else {
        $("#HiddenField_CustomDocumentHealthHomeReferrals_SequenceNumber").val(splitval[4]);
    }
    InsertGridData(splitval[0], splitval[1], splitval[2], splitval[3]);
}