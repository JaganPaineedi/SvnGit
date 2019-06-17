// Clear Routine for Parent Child Custom Grid for table CustomDocumentHealthHomeCommPlanProviders
function Clear_CustomDocumentHealthHomeCommPlanProviders_Data() {
    $("[id$=InsertGrid_CustomDocumentHealthHomeCommPlanProviders]").find("input[type=radio]").removeAttr('checked');
    $("[id$=TableChildControl_CustomDocumentHealthHomeCommPlanProviders_ButtonInsert]").val("Insert");
    $("[id$=HiddenField_CustomDocumentHealthHomeCommPlanProviders_HealthHomeCommPlanProviderId]").val(-1);
    $("[id$=HiddenField_CustomDocumentHealthHomeCommPlanProviders_ProviderPhone]").val("");
    $("[id$=HiddenField_CustomDocumentHealthHomeCommPlanProviders_ProviderFax]").val("");
    $("#TextBox_CustomDocumentHealthHomeCommPlanProviders_ProviderName").val("");
    $("[id$=TextBox_CustomDocumentHealthHomeCommPlanProviders_ProviderSpecialty]").val(""); 
    $("[id$=TextBox_CustomDocumentHealthHomeCommPlanProviders_ProviderPhone1]").val("");
    $("[id$=TextBox_CustomDocumentHealthHomeCommPlanProviders_ProviderPhone2]").val("");
    $("[id$=TextBox_CustomDocumentHealthHomeCommPlanProviders_ProviderPhone3]").val("");
    $("[id$=TextBox_CustomDocumentHealthHomeCommPlanProviders_ProviderPhone4]").val("");
    $("[id$=TextBox_CustomDocumentHealthHomeCommPlanProviders_ProviderFax1]").val("");
    $("[id$=TextBox_CustomDocumentHealthHomeCommPlanProviders_ProviderFax2]").val("");
    $("[id$=TextBox_CustomDocumentHealthHomeCommPlanProviders_ProviderFax3]").val("");
    $("[id$=TextBox_CustomDocumentHealthHomeCommPlanProviders_ProviderFax4]").val("");
}

// Function to handle the Insert into grid call from insert and modify button
function InsertGrid_CustomDocumentHealthHomeCommPlanProvidersData(gridDatatable, gridDivName, dataGridID, buttonCtrl) {
    // validate data here
    InsertGridData(gridDatatable, gridDivName, dataGridID, buttonCtrl);
}

// Clear Routine for Parent Child Custom Grid for table CustomDocumentHealthHomeCommPlanFamilyMembers
function Clear_CustomDocumentHealthHomeCommPlanFamilyMembers_Data() {
    $("[id$=InsertGrid_CustomDocumentHealthHomeCommPlanFamilyMembers]").find("input[type=radio]").removeAttr('checked');
    $("[id$=TableChildControl_CustomDocumentHealthHomeCommPlanFamilyMembers_ButtonInsert]").val("Insert");
    $("#HiddenField_CustomDocumentHealthHomeCommPlanFamilyMembers_HealthHomeCommPlanFamilyMemberId").val(-1);  
    $("#TextBox_CustomDocumentHealthHomeCommPlanFamilyMembers_FamilyMemberName").val("");
    $("[id$=TextBox_CustomDocumentHealthHomeCommPlanFamilyMembers_FamilyMemberPhone1]").val("");
    $("[id$=TextBox_CustomDocumentHealthHomeCommPlanFamilyMembers_FamilyMemberPhone2]").val("");
    $("[id$=TextBox_CustomDocumentHealthHomeCommPlanFamilyMembers_FamilyMemberPhone3]").val("");
    $("[id$=TextBox_CustomDocumentHealthHomeCommPlanFamilyMembers_FamilyMemberPhone4]").val("");
}

// Function to handle the Insert into grid call from insert and modify button
function InsertGrid_CustomDocumentHealthHomeCommPlanFamilyMembersData(gridDatatable, gridDivName, dataGridID, buttonCtrl) {
    // validate data here
    InsertGridData(gridDatatable, gridDivName, dataGridID, buttonCtrl);
}

// Clear Routine for Parent Child Custom Grid for table CustomDocumentHealthHomeCommPlanSocialSupports
function Clear_CustomDocumentHealthHomeCommPlanSocialSupports_Data() {
    $("[id$=InsertGrid_CustomDocumentHealthHomeCommPlanSocialSupports]").find("input[type=radio]").removeAttr('checked');
    $("[id$=TableChildControl_CustomDocumentHealthHomeCommPlanSocialSupports_ButtonInsert]").val("Insert");
    $("#HiddenField_CustomDocumentHealthHomeCommPlanSocialSupports_HealthHomeCommPlanSocialSupportId").val(-1); 
    $("#TextBox_CustomDocumentHealthHomeCommPlanSocialSupports_SupportName").val("");
    $("#TextArea_CustomDocumentHealthHomeCommPlanSocialSupports_PurposeOfCollaboration").val("");
}

// Function to handle the Insert into grid call from insert and modify button
function InsertGrid_CustomDocumentHealthHomeCommPlanSocialSupportsData(gridDatatable, gridDivName, dataGridID, buttonCtrl) {
    // validate data here
    InsertGridData(gridDatatable, gridDivName, dataGridID, buttonCtrl);
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
function UpdatePhone(val, TextBoxFrom) {
    if (TextBoxFrom == 'PrimaryCare') {
        PhoneNumber1 = $("[id$=TextBox_CustomDocumentHealthHomeCommPlans_PrimaryCarePhysicianPhone1]").val();
        PhoneNumber2 = $("[id$=TextBox_CustomDocumentHealthHomeCommPlans_PrimaryCarePhysicianPhone2]").val();
        PhoneNumber3 = $("[id$=TextBox_CustomDocumentHealthHomeCommPlans_PrimaryCarePhysicianPhone3]").val();
        PhoneNumber4 = $("[id$=TextBox_CustomDocumentHealthHomeCommPlans_PrimaryCarePhysicianPhone4]").val();
    }
    if (TextBoxFrom == 'DentistPhone') {
        PhoneNumber1 = $("[id$=TextBox_CustomDocumentHealthHomeCommPlans_DentistPhone1]").val();
        PhoneNumber2 = $("[id$=TextBox_CustomDocumentHealthHomeCommPlans_DentistPhone2]").val();
        PhoneNumber3 = $("[id$=TextBox_CustomDocumentHealthHomeCommPlans_DentistPhone3]").val();
        PhoneNumber4 = $("[id$=TextBox_CustomDocumentHealthHomeCommPlans_DentistPhone4]").val();
    }
    if (TextBoxFrom == 'Provider') {
        PhoneNumber1 = $("[id$=TextBox_CustomDocumentHealthHomeCommPlanProviders_ProviderPhone1]").val();
        PhoneNumber2 = $("[id$=TextBox_CustomDocumentHealthHomeCommPlanProviders_ProviderPhone2]").val();
        PhoneNumber3 = $("[id$=TextBox_CustomDocumentHealthHomeCommPlanProviders_ProviderPhone3]").val();
        PhoneNumber4 = $("[id$=TextBox_CustomDocumentHealthHomeCommPlanProviders_ProviderPhone4]").val();
    }   
    if (TextBoxFrom == 'FamilyMember') {
        PhoneNumber1 = $("[id$=TextBox_CustomDocumentHealthHomeCommPlanFamilyMembers_FamilyMemberPhone1]").val();
        PhoneNumber2 = $("[id$=TextBox_CustomDocumentHealthHomeCommPlanFamilyMembers_FamilyMemberPhone2]").val();
        PhoneNumber3 = $("[id$=TextBox_CustomDocumentHealthHomeCommPlanFamilyMembers_FamilyMemberPhone3]").val();
        PhoneNumber4 = $("[id$=TextBox_CustomDocumentHealthHomeCommPlanFamilyMembers_FamilyMemberPhone4]").val();
    }
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
        if (TextBoxFrom == 'PrimaryCare') {
            CreateAutoSaveXml("CustomDocumentHealthHomeCommPlans", "PrimaryCarePhysicianPhone", PhoneNumber);
        }
        if (TextBoxFrom == 'DentistPhone') {
            CreateAutoSaveXml("CustomDocumentHealthHomeCommPlans", "DentistPhone", PhoneNumber);
        }
        if (TextBoxFrom == 'Provider') {
            $("#HiddenField_CustomDocumentHealthHomeCommPlanProviders_ProviderPhone").val(PhoneNumber);
        }
        if (TextBoxFrom == 'FamilyMember') {
            $("#HiddenField_CustomDocumentHealthHomeCommPlanFamilyMembers_FamilyMemberPhone").val(PhoneNumber);
        }
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
    $("[id$=TextBox_CustomDocumentHealthHomeCommPlanProviders_ProviderFax1]").focus();
        return false;
    }
    return true;
}
function CheckPhone2() {
    if (PhoneNumber1 == "" && PhoneNumber2 == "") { }
    else if (PhoneNumber1 != "" && PhoneNumber2.length < 3) {
    $("[id$=TextBox_CustomDocumentHealthHomeCommPlanProviders_ProviderFax1]").focus();
        return false;
    }
    else if (PhoneNumber2.length < 3) {
    $("[id$=TextBox_CustomDocumentHealthHomeCommPlanProviders_ProviderFax1]").focus();
        return false;
    }
    return true;
}
function CheckPhone3() {
    if (PhoneNumber2 == "" && PhoneNumber3 == "") { }
    else if (PhoneNumber2 == "" && PhoneNumber3.length > 0) {
        if (PhoneNumber3.length < 4)
            $("[id$=TextBox_CustomDocumentHealthHomeCommPlanProviders_ProviderFax1]").focus();
        else
            $("[id$=TextBox_CustomDocumentHealthHomeCommPlanProviders_ProviderFax1]").focus();
        return false;
    } else if (PhoneNumber2 != "") {
        if (PhoneNumber3.length == 0) {
            return false;
        }
        else if (PhoneNumber3.length < 4) {
        $("[id$=TextBox_CustomDocumentHealthHomeCommPlanProviders_ProviderFax1]").focus()
            return false;
        }
    }
    return true;
}
function CheckPhone4() {
    if (PhoneNumber2 == "" && PhoneNumber3 == "") {
        $("[id$=TextBox_CustomDocumentHealthHomeCommPlanProviders_ProviderFax1]").val('');
    }
    else {
        if (PhoneNumber2.length == 0) {
            $("[id$=TextBox_CustomDocumentHealthHomeCommPlanProviders_ProviderFax1]").focus();
        }
        else if (PhoneNumber3.length == 0) {
        $("[id$=TextBox_CustomDocumentHealthHomeCommPlanProviders_ProviderFax1]").focus();
        }
    }
    return true;
}

//#region Fax Validation
var Fax;
var Fax1;
var Fax2;
var Fax3;
var Fax4;
function CheckFaxNumber(TextBox, maxlength) {
    var FaxNum = $("[id$=" + TextBox + "]").val();
    if (!FaxNum) { }
    else if (FaxNum.length < maxlength) {
        $("[id$=" + TextBox + "]").focus();
        ShowHideErrorMessage("Please enter valid Fax Number", 'true');
        return false;
    }
    ShowHideErrorMessage("", 'false');
    return true;
}
function ValidateFax(TextBox1, TextBox2, TextBox3, TextBox4,FaxFrom) {
    Fax1 = $("[id$=" + TextBox1 + "]").val();
    Fax2 = $("[id$=" + TextBox2 + "]").val();
    Fax3 = $("[id$=" + TextBox3 + "]").val();
    Fax4 = $("[id$=" + TextBox4 + "]").val();

    if (Fax2 == "" && Fax3 == "") {
        $("[id$=" + TextBox1 + "]").val("");
        $("[id$=" + TextBox4 + "]").val("");
    }
    else if (Fax2 != "" && Fax3 == "") {
        $("[id$=" + TextBox3 + "]").focus();
        ShowHideErrorMessage("Please enter valid Fax Number", 'true');
        return false;
    }
    else if (Fax2 == "" && Fax3 != "") {
        $("[id$=" + TextBox2 + "]").focus();
        ShowHideErrorMessage("Please enter valid Fax Number", 'true');
        return false;
    }
    else {
        Fax = "(" + Fax1 + ") " + Fax2 + "-" + Fax3;
        if (Fax4 != "") {
            Fax += " Ext " + Fax4;
        }
    }
    if (Fax1 == "" && Fax2 == "" && Fax3 == "" && Fax4 == "") {
        Fax = '';
    }
    if (Fax == "undefined" || Fax == null) {
        Fax = '';
    }
    ShowHideErrorMessage("", 'false');
    if (FaxFrom == 'PrimaryCare') {
        CreateAutoSaveXml("CustomDocumentHealthHomeCommPlans", "PrimaryCarePhysicianFax", Fax);
    }
    if (FaxFrom == 'DentistPhone') {
        CreateAutoSaveXml("CustomDocumentHealthHomeCommPlans", "DentistFax", Fax);
    }
    if (FaxFrom == 'Provider') {
        $("#HiddenField_CustomDocumentHealthHomeCommPlanProviders_ProviderFax").val(Fax);
    }
    return true;
}
//#endregion

function SetScreenSpecificValues(dom, action) {
    try {
//        _selectedTabIndex = objectPageResponse.SelectedTabId;
//        if (_selectedTabIndex == 0) {
            SetPhoneAndFaxValues('ExternalProvidersPhysician','');
            SetPhoneAndFaxValues('ExternalProvidersDentist','');
        //}
     }
    catch (err) {
    }
}

//function AddParentChildRadioClickEventHandler(key) {
function AddParentChildRadioClickEventHandlerForCIR(key, rowIndex, obj, customGridTableName, gridPageName, insertButtonId) {
    SetPhoneAndFaxValues(gridPageName,key);
}

function SetTabUcPath() {
    return "/ActivityPages/Client/Detail/Documents/Harbor/HealthHomeCommunicationPlan.ascx";
}

function SetPhoneAndFaxValues(gridPageName,key) {
    var PhoneNum = null;
    var textBox1;
    var textBox2;
    var textBox2;
    var textBox4;
    
    if (gridPageName == 'CustomDocumentHealthHomeCommPlanProviders_Grid') {
        PhoneNum = GetColumnValueInXMLNodeByKeyValue("CustomDocumentHealthHomeCommPlanProviders", "HealthHomeCommPlanProviderId", key, "ProviderPhone", $.xmlDOM(objectPageResponse.ScreenDataSetXml));
        textBox1 = 'TextBox_CustomDocumentHealthHomeCommPlanProviders_ProviderPhone1';
        textBox2 = 'TextBox_CustomDocumentHealthHomeCommPlanProviders_ProviderPhone2';
        textBox3 = 'TextBox_CustomDocumentHealthHomeCommPlanProviders_ProviderPhone3';
        textBox4 = 'TextBox_CustomDocumentHealthHomeCommPlanProviders_ProviderPhone4';
    }
    if (gridPageName == 'CustomDocumentHealthHomeCommPlanFamilyMembers_Grid') {
        PhoneNum = GetColumnValueInXMLNodeByKeyValue("CustomDocumentHealthHomeCommPlanFamilyMembers", "HealthHomeCommPlanFamilyMemberId", key, "FamilyMemberPhone", $.xmlDOM(objectPageResponse.ScreenDataSetXml));
        textBox1 = 'TextBox_CustomDocumentHealthHomeCommPlanFamilyMembers_FamilyMemberPhone1';
        textBox2 = 'TextBox_CustomDocumentHealthHomeCommPlanFamilyMembers_FamilyMemberPhone2';
        textBox3 = 'TextBox_CustomDocumentHealthHomeCommPlanFamilyMembers_FamilyMemberPhone3';
        textBox4 = 'TextBox_CustomDocumentHealthHomeCommPlanFamilyMembers_FamilyMemberPhone4';
    }
    if (gridPageName == 'ExternalProvidersPhysician') {
        PhoneNum = GetFielValueFromXMLDom(objectPageResponse.ScreenDataSetXml, "CustomDocumentHealthHomeCommPlans", "PrimaryCarePhysicianPhone");
        textBox1 = 'TextBox_CustomDocumentHealthHomeCommPlans_PrimaryCarePhysicianPhone1';
        textBox2 = 'TextBox_CustomDocumentHealthHomeCommPlans_PrimaryCarePhysicianPhone2';
        textBox3 = 'TextBox_CustomDocumentHealthHomeCommPlans_PrimaryCarePhysicianPhone3';
        textBox4 = 'TextBox_CustomDocumentHealthHomeCommPlans_PrimaryCarePhysicianPhone4';
    }
    if (gridPageName == 'ExternalProvidersDentist') {
        PhoneNum = GetFielValueFromXMLDom(objectPageResponse.ScreenDataSetXml, "CustomDocumentHealthHomeCommPlans", "DentistPhone");
        textBox1 = 'TextBox_CustomDocumentHealthHomeCommPlans_DentistPhone1';
        textBox2 = 'TextBox_CustomDocumentHealthHomeCommPlans_DentistPhone2';
        textBox3 = 'TextBox_CustomDocumentHealthHomeCommPlans_DentistPhone3';
        textBox4 = 'TextBox_CustomDocumentHealthHomeCommPlans_DentistPhone4';
    }
    
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
        SetFaxNumber(gridPageName,key);
}
function SetFaxNumber(gridPageName,key) {
    var FaxNum = null;
    var Fax1;
    var Fax2;
    var Fax3;
    var Fax4;
    if (gridPageName == 'CustomDocumentHealthHomeCommPlanProviders_Grid') {

        FaxNum = GetColumnValueInXMLNodeByKeyValue("CustomDocumentHealthHomeCommPlanProviders", "HealthHomeCommPlanProviderId", key, "ProviderFax", $.xmlDOM(objectPageResponse.ScreenDataSetXml));
        Fax1 = 'TextBox_CustomDocumentHealthHomeCommPlanProviders_ProviderFax1';
        Fax2 = 'TextBox_CustomDocumentHealthHomeCommPlanProviders_ProviderFax2';
        Fax3 = 'TextBox_CustomDocumentHealthHomeCommPlanProviders_ProviderFax3';
        Fax4 = 'TextBox_CustomDocumentHealthHomeCommPlanProviders_ProviderFax4';
    }
    if (gridPageName == 'ExternalProvidersPhysician') {
        FaxNum = GetFielValueFromXMLDom(objectPageResponse.ScreenDataSetXml, "CustomDocumentHealthHomeCommPlans", "PrimaryCarePhysicianFax");
        Fax1 = 'TextBox_CustomDocumentHealthHomeCommPlans_PrimaryCarePhysicianFax1';
        Fax2 = 'TextBox_CustomDocumentHealthHomeCommPlans_PrimaryCarePhysicianFax2';
        Fax3 = 'TextBox_CustomDocumentHealthHomeCommPlans_PrimaryCarePhysicianFax3';
        Fax4 = 'TextBox_CustomDocumentHealthHomeCommPlans_PrimaryCarePhysicianFax4';
    }
    if (gridPageName == 'ExternalProvidersDentist') {
        FaxNum = GetFielValueFromXMLDom(objectPageResponse.ScreenDataSetXml, "CustomDocumentHealthHomeCommPlans", "DentistFax");
        Fax1 = 'TextBox_CustomDocumentHealthHomeCommPlans_DentistFax1';
        Fax2 = 'TextBox_CustomDocumentHealthHomeCommPlans_DentistFax2';
        Fax3 = 'TextBox_CustomDocumentHealthHomeCommPlans_DentistFax3';
        Fax4 = 'TextBox_CustomDocumentHealthHomeCommPlans_DentistFax4';
    }
    if (FaxNum != null) {
        var newFaxNum = removeSpaces(FaxNum);
        var indexofFax1 = newFaxNum.indexOf('(');
        var indexofFax2 = newFaxNum.indexOf(')');
        if (indexofFax2 - indexofFax1 == 1) {
            $("[id$=" + Fax1 + "]").val();
            $("[id$=" + Fax2 + "]").val(newFaxNum.substring(2, 5));
            $("[id$=" + Fax3 + "]").val(newFaxNum.substring(6, 10));
        }
        else {
            $("[id$=" + Fax1 + "]").val(newFaxNum.substring(1, 4));
            $("[id$=" + Fax2 + "]").val(newFaxNum.substring(5, 8));
            $("[id$=" + Fax3 + "]").val(newFaxNum.substring(9, 13));
        }
        var indexofExt = newFaxNum.indexOf('Ext');
        if (indexofExt != "-1") {
            var FaxNumberLength = newFaxNum.length;
            $("[id$=" + Fax4 + "]").val(newFaxNum.substring(indexofExt + 3, FaxNumberLength));
        }
    }

}

function removeSpaces(string) {
    return string.split(' ').join('');
}
// Accepts a date value and returns a time stamp
function DateString(dateIn) {
    var d;
    if ((typeof (dateIn) === 'date') ? true : (typeof (dateIn) === 'object') ? dateIn.constructor.toString().match(/date/i) !== null : false) {
        d = dateIn;
    } else {
        d = new Date(dateIn);
    }
    function pad(n) {
        n = parseInt(n, 10);
        return n < 10 ? '0' + n : n;
    }
    return d.getFullYear() + '-' + pad(d.getMonth() + 1) + '-' + pad(d.getDate()) + 'T' +
        pad(d.getHours()) + ':' + pad(d.getMinutes()) + ':' + pad(d.getSeconds());
}

function DisableTextbox(control, controltodisable) {
    if ($(control).attr("checked") == true) {
        $('[id$=' + controltodisable + ']').attr('disabled', true);
        $('[id$=' + controltodisable + ']').attr('disabled', '');
    }
    else {
        $('[id$=' + controltodisable + ']').attr('disabled', '');
    }
}