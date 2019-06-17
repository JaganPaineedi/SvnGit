//Added by Jagdeep
//function to Insert Data into the Referral Services Grid
function InsertGridCustomPsychiatricReferralData(CustomGridTableName, InsertGrid, dataGridId, buttonCtrl, baseUrl) {
    try {
        var serviceUnitTypeValue = $("#Span_CustomDocumentPsychiatricEvaluationReferrals_ServiceUnitTypeValue");
        var amount = $('#TextBox_CustomDocumentPsychiatricEvaluationReferrals_ServiceAmount').val();
        var unitType = serviceUnitTypeValue.text();
        $('#HiddenField_CustomDocumentPsychiatricEvaluationReferrals_ServiceUnitTypeText').val(amount + ' ' + unitType);

        if (!ValidateReferral()) {
            return false;
        }
        InsertGridData(CustomGridTableName, InsertGrid, dataGridId, buttonCtrl);
        serviceUnitTypeValue.attr("style", "display:none");
        serviceUnitTypeValue[0].innerHTML = '';
        return false;

    }
    catch (err) {
        LogClientSideException(err, 'InsertGridCustomPsychiatricReferralData');
    }
}

//This function is used for ajax call to get the Unit Values of AuthorizationCode 
function setUnitType() {
    try {
        var authorizationCodeSelected = $('select[id$=DropDownList_CustomDocumentPsychiatricEvaluationReferrals_ServiceRecommended]').val();
        $.ajax({
            type: "POST",
            url: GetRelativePath() + "AjaxScript.aspx?FunctionName=GetUnitTypeValue",
            data: 'authorizationCodeSelected=' + authorizationCodeSelected,
            success: fillUnitType
        });
    }
    catch (err) {
        LogClientSideException(err, 'setUnitType');
    }
}

//This function is used to Fill the Unit Value of AuthorizationCode in the Text box
function fillUnitType(result) {

    try {
        var replaceString = result;
        var unitValue = replaceString.split("$$$");

        var serviceUnitTypeValue = $("#Span_CustomDocumentPsychiatricEvaluationReferrals_ServiceUnitTypeValue");

        $('#TextBox_CustomDocumentPsychiatricEvaluationReferrals_ServiceAmount').val(unitValue[0]);

        if (unitValue[1] != undefined) {
            serviceUnitTypeValue.attr("style", "display:block");
            serviceUnitTypeValue[0].innerHTML = unitValue[1];
            $('#HiddenField_CustomDocumentPsychiatricEvaluationReferrals_ServiceUnitType').val(unitValue[2]);
        }
        else {
            serviceUnitTypeValue.attr("style", "display:none");
            serviceUnitTypeValue[0].innerHTML = '';
            $('#HiddenField_CustomDocumentPsychiatricEvaluationReferrals_ServiceUnitType').val('');
            $('#HiddenField_CustomDocumentPsychiatricEvaluationReferrals_ServiceUnitTypeText').val('');
        }
    }
    catch (err) {
        LogClientSideException(err, 'fillUnitType');
    }
}
//Function to validate the required fields
function ValidateReferral() {
    try {
        ShowHideErrorMessage('', 'false');

        if ($.trim($("#TextBox_CustomDocumentPsychiatricEvaluationReferrals_ServiceAmount").val()) == '') {
            ShowHideErrorMessage('Please enter all required fields.', 'true');
            $("#TextBox_CustomDocumentPsychiatricEvaluationReferrals_ServiceAmount").focus();
            return false;
        }
        var dropdownService = $("select[id$=DropDownList_CustomDocumentPsychiatricEvaluationReferrals_ServiceRecommended]");
        if (dropdownService.length > 0) {
            if (dropdownService[0].selectedIndex == 0) {
                ShowHideErrorMessage('Please enter all required fields.', 'true');
                dropdownService[0].focus();
                return false;
            }
        }
        var dropdownFrequency = $("select[id$=DropDownList_CustomDocumentPsychiatricEvaluationReferrals_ServiceFrequency]");
        if (dropdownFrequency.length > 0) {
            if (dropdownFrequency[0].selectedIndex == 0) {
                ShowHideErrorMessage('Please enter all required fields.', 'true');
                dropdownFrequency[0].focus();
                return false;
            }
        }
        var dropdownReceivingStaff = $("#DropDownList_CustomDocumentPsychiatricEvaluationReferrals_ReceivingStaffId");
        if (dropdownReceivingStaff.length > 0) {
            if (dropdownReceivingStaff[0].selectedIndex == 0) {
                ShowHideErrorMessage('Please enter all required fields.', 'true');
                dropdownReceivingStaff[0].focus();
                return false;
            }
        }
        return true;
    }
    catch (err) {
        LogClientSideException(err, 'ValidateReferral');
    }
}
//Function to get the URL which will be opened on click of Folder Icon
function GetFolderUrl(dom) {
    var xmlCustomConfigurationsRow = dom[0].childNodes[0].selectNodes("CustomDocumentPsychiatricEvaluations");
    if (xmlCustomConfigurationsRow[0].selectNodes("ReferralTransferReferenceURL").length > 0) {
        FolderUrl = xmlCustomConfigurationsRow[0].selectNodes("ReferralTransferReferenceURL")[0].text.trim();
    }
}

//Function is used to set the span value for Unit Type 
function SetCustomValueOnRadioClick() {
    var ServiceUnitTypeText = $('#HiddenField_CustomDocumentPsychiatricEvaluationReferrals_ServiceUnitTypeText').val();
    var ServiceUnitTypeValue = $("#Span_CustomDocumentPsychiatricEvaluationReferrals_ServiceUnitTypeValue");
    ServiceUnitTypeValue.attr("style", "display:block");
    ServiceUnitTypeValue[0].innerHTML = ServiceUnitTypeText.split(' ')[1];
}

//function  overridden to set the AssessedNeedReferral Textbox with default value after Insert
function GridRenderCallBackComplete() {
    SetAssessedNeedReferral();
}
//function to set the Textbox with default value 
function SetAssessedNeedReferral() {
    var assessedNeedsForReferral = $("#TextBox_CustomDocumentPsychiatricEvaluationReferrals_AssessedNeedForReferral");
    if (assessedNeedsForReferral.length > 0) {
        assessedNeedsForReferral.val('Need assessed at Psychiatric Evaluation.');
    }
}

//function to clear the contents for PsychiatricReferrals grid
function ClearPsychiatricReferrals() {
    try {

        $("#Span_CustomDocumentPsychiatricEvaluationReferrals_ServiceUnitTypeValue")[0].innerHTML = '';
        $("#Span_CustomDocumentPsychiatricEvaluationReferrals_ServiceUnitTypeValue")[0].style.display = 'none';
        $("#TextBox_CustomDocumentPsychiatricEvaluationReferrals_ServiceAmount").val('');

        var dropdownService = $("select[id$=DropDownList_CustomDocumentPsychiatricEvaluationReferrals_ServiceRecommended]");
        if (dropdownService.length > 0) {
            dropdownService[0].selectedIndex = 0;
            dropdownService.focus();
        }

        var dropdownFrequency = $("select[id$=DropDownList_CustomDocumentPsychiatricEvaluationReferrals_ServiceFrequency]");
        if (dropdownFrequency.length > 0) {
            dropdownFrequency[0].selectedIndex = 0;
        }

        var dropdownReceivingStaff = $("#DropDownList_CustomDocumentPsychiatricEvaluationReferrals_ReceivingStaffId");
        if (dropdownReceivingStaff.length > 0) {
            dropdownReceivingStaff[0].selectedIndex = 0;
        }

        $("#TableChildControl_CustomDocumentPsychiatricEvaluationReferrals_ButtonInsert").val('Insert');


        //UnSelect the Radio Button of the Grid on Clear Button
        var GridViewReferral = 'GridViewInsert';
        $("[id$=GridViewInsert]").find("input[type=radio]").removeAttr('checked');

        //Clear the Primary key Value
        $("#HiddenField_CustomDocumentPsychiatricEvaluationReferrals_ReferralId").val('');
    }
    catch (err) {
        LogClientSideException(err, 'ClearPsychiatricReferrals');
    }
}
//function is overridden to set the default value for AssessedNeedReferral Textbox
function AddParentChildEventHandler() {
    SetAssessedNeedReferral();
}