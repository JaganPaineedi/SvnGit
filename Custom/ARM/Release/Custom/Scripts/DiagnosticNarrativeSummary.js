//Added by Ashwani
//function to Insert Data into the Transfer Services Grid
function InsertGridCustomAssessmentTransferServicesData(obj, tableChildControl, InsertGrid, CustomICDGrid, baseUrl) {
try {InsertGridData(tableChildControl, InsertGrid, CustomICDGrid, obj);}
    catch (err) {
        LogClientSideException(err, 'InsertDiagnosticNarrativeSummaryData');
    }
}

//function to Insert Data into the Referral Services Grid
function InsertGridCustomAssessmentReferralData(CustomGridTableName, InsertGrid, dataGridId, buttonCtrl, baseUrl) {
    try {
        var serviceUnitTypeValue = $("#Span_CustomDocumentAssessmentReferrals_ServiceUnitTypeValue");
        var amount = $('#TextBox_CustomDocumentAssessmentReferrals_ServiceAmount').val();
        //var unitType = $('#Span_CustomDocumentAssessmentReferrals_ServiceUnitTypeValue').text();
        var unitType = serviceUnitTypeValue.text();
        $('#HiddenField_CustomDocumentAssessmentReferrals_ServiceUnitTypeText').val(amount + ' ' + unitType);

        if (!ValidateReferral()) {
            return false;
        }
        InsertGridData(CustomGridTableName, InsertGrid, dataGridId, buttonCtrl);

        //$("#Span_CustomDocumentAssessmentReferrals_ServiceUnitTypeValue")[0].style.display = 'none';
        //$("#Span_CustomDocumentAssessmentReferrals_ServiceUnitTypeValue")[0].innerHTML = '';
        serviceUnitTypeValue.attr("style", "display:none");
        serviceUnitTypeValue[0].innerHTML = '';
        return false;

    }
    catch (err) {
        LogClientSideException(err, 'InsertGridCustomAssessmentReferralData');
    }
}


//This function is used for ajax call to get the Unit Values of AuthorizationCode 
function setUnitType() {
    try {

        var authorizationCodeSelected = $('select[id$=DropDownList_CustomDocumentAssessmentReferrals_ServiceRecommended]').val();
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

         var serviceUnitTypeValue = $("#Span_CustomDocumentAssessmentReferrals_ServiceUnitTypeValue");
        
        $('#TextBox_CustomDocumentAssessmentReferrals_ServiceAmount').val(unitValue[0]);

        if (unitValue[1] != undefined) {
            serviceUnitTypeValue.attr("style", "display:block");
            serviceUnitTypeValue[0].innerHTML = unitValue[1];
            $('#HiddenField_CustomDocumentAssessmentReferrals_ServiceUnitType').val(unitValue[2]);
         }
        else {
            serviceUnitTypeValue.attr("style", "display:none");
            serviceUnitTypeValue[0].innerHTML = '';
            $('#HiddenField_CustomDocumentAssessmentReferrals_ServiceUnitType').val('');
            $('#HiddenField_CustomDocumentAssessmentReferrals_ServiceUnitTypeText').val('');
        }
    }
    catch (err) {
        LogClientSideException(err, 'fillUnitType');
    }
}

//function to show NarrativeSummary Contents
function HideNarrativeSummaryContent() {
    $('#TableServices').hide();
    $('#TableClientExternalSupport').hide();
    $('#TablePrimaryClinicianAssignment').hide();
    $('#TableTransfer').hide();
    $('#TableServicePlan').show();
    
}

//function to Hide NarrativeSummary Contents
function ShowNarrativeSummaryContent() {
    $('#TableServices').show();
    $('#TableClientExternalSupport').show();
    $('#TablePrimaryClinicianAssignment').show();
    $('#TableTransfer').show();
    $('#TableServicePlan').hide();
}

//Function to validate the required fields
function ValidateReferral() {
    try {
        ShowHideErrorMessage('', 'false');
        
        if ($.trim($("#TextBox_CustomDocumentAssessmentReferrals_ServiceAmount").val()) == '') {
            ShowHideErrorMessage('Please enter all required fields.', 'true');
            $("#TextBox_CustomDocumentAssessmentReferrals_ServiceAmount").focus();
            return false;
        }

        var dropdownService = $("select[id$=DropDownList_CustomDocumentAssessmentReferrals_ServiceRecommended]");
        if (dropdownService.length > 0) {
            if (dropdownService[0].selectedIndex == 0) {
                ShowHideErrorMessage('Please enter all required fields.', 'true');
                dropdownService[0].focus();
                return false;
            }
        }

        var dropdownFrequency = $("select[id$=DropDownList_CustomDocumentAssessmentReferrals_ServiceFrequency]");
        if (dropdownFrequency.length > 0) 
        {
            if (dropdownFrequency[0].selectedIndex == 0)
            {
                ShowHideErrorMessage('Please enter all required fields.', 'true');
                dropdownFrequency[0].focus();
                return false;
            }
        }
        var dropdownReceivingStaff = $("#DropDownList_CustomDocumentAssessmentReferrals_ReceivingStaffId");
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
//Function to get the URL which will be opened on click of Folder Icon for Narrative Summary Tab
function GetFolderUrl(dom) {
    var xmlCustomConfigurationsRow = dom[0].childNodes[0].selectNodes("CustomDocumentDiagnosticAssessments");
    if (xmlCustomConfigurationsRow[0].selectNodes("ReferralTransferReferenceURL").length > 0) {
        FolderUrl = xmlCustomConfigurationsRow[0].selectNodes("ReferralTransferReferenceURL")[0].text.trim();
    }
}

//Function is used to set the span value for Unit Type for Narrative Summary Tab
function SetCustomValueOnRadioClick() {
    var ServiceUnitTypeText = $('#HiddenField_CustomDocumentAssessmentReferrals_ServiceUnitTypeText').val();
    var ServiceUnitTypeValue = $("#Span_CustomDocumentAssessmentReferrals_ServiceUnitTypeValue");
    ServiceUnitTypeValue.attr("style", "display:block");
    ServiceUnitTypeValue[0].innerHTML = ServiceUnitTypeText.split(' ')[1];
}

//function to set the ReceivingStaffValue
function SetReceivingStaffValue(AutoSaveXMLDom) {
    var xmlCustomConfigurationsRow = AutoSaveXMLDom[0].childNodes[0].selectNodes("CustomDocumentDiagnosticAssessments");
    if (xmlCustomConfigurationsRow[0].selectNodes("TransferReceivingStaff").length <= 0) {
        var dropdownStaff = $("select[id$=DropDownList_CustomDocumentDiagnosticAssessments_TransferReceivingStaff]");
        if (dropdownStaff.length > 0) {
            dropdownStaff[0].selectedIndex = 0;
        }
    }
}
//function  overridden to set the AssessedNeedReferral Textbox with default value after Insert
function GridRenderCallBackComplete()
{
    SetAssessedNeedReferral();
}
//function to set the TransferAssessedNeed Textbox with default value 
function SetAssessedNeedReferral() {
    var assessedNeedsForReferral = $("#TextBox_CustomDocumentAssessmentReferrals_AssessedNeedForReferral");
    if (assessedNeedsForReferral.length > 0) {
        assessedNeedsForReferral.val('Need identified at the diagnostic assessment.');
    }
}

//function to set the AssessedNeedReferralTextbox with default value
function SetAssessedNeedTransfer(AutoSaveXMLDom) {
    var xmlCustomConfigurationsRow = AutoSaveXMLDom[0].childNodes[0].selectNodes("CustomDocumentDiagnosticAssessments");
    var assessedNeedsForTransfer = $("#TextBox_CustomDocumentDiagnosticAssessments_TransferAssessedNeed");
    if (assessedNeedsForTransfer.length > 0) {

        if (xmlCustomConfigurationsRow.length > 0) {
            if (xmlCustomConfigurationsRow[0].selectNodes("TransferAssessedNeed").length <= 0) {
                assessedNeedsForTransfer.val('Need identified at the diagnostic assessment.');
            }
            else {
                assessedNeedsForTransfer.val(xmlCustomConfigurationsRow[0].selectNodes("TransferAssessedNeed")[0].text.trim());
            }
        }
        else { assessedNeedsForTransfer.val('Need identified at the diagnostic assessment.'); }
    }

}


//function to clear the contents for AssessmentReferrals grid
function ClearAssessmentReferrals() {
    try {

        $("#Span_CustomDocumentAssessmentReferrals_ServiceUnitTypeValue")[0].innerHTML = '';
        $("#Span_CustomDocumentAssessmentReferrals_ServiceUnitTypeValue")[0].style.display = 'none';
        $("#TextBox_CustomDocumentAssessmentReferrals_ServiceAmount").val('');
        
        var dropdownService = $("select[id$=DropDownList_CustomDocumentAssessmentReferrals_ServiceRecommended]");
        if (dropdownService.length > 0) {
            dropdownService[0].selectedIndex = 0;
            dropdownService.focus();
        }

        var dropdownFrequency = $("select[id$=DropDownList_CustomDocumentAssessmentReferrals_ServiceFrequency]");
        if (dropdownFrequency.length > 0) {
            dropdownFrequency[0].selectedIndex = 0;
        }
        
        var dropdownReceivingStaff = $("#DropDownList_CustomDocumentAssessmentReferrals_ReceivingStaffId");
        if (dropdownReceivingStaff.length > 0) {
            dropdownReceivingStaff[0].selectedIndex = 0;
        }

        $("#TableChildControl_CustomDocumentAssessmentReferrals_ButtonInsert").val('Insert');

       
        //UnSelect the Radio Button of the Grid on Clear Button
        var GridViewReferral = 'GridViewInsert';
        $("[id$=GridViewInsert]").find("input[type=radio]").removeAttr('checked');
        
        //Clear the Primary key Value
        $("#HiddenField_CustomDocumentAssessmentReferrals_AssessmentReferralId").val('');
    }
    catch (err) {
        LogClientSideException(err, 'ClearAssessmentReferrals');
    }
}
//function to clear the contents for Assessment Transfer Services grid
function ClearAssessmentTransferServices() {
    var dropdownTransferService = $("select[id$=DropDownList_CustomDocumentAssessmentTransferServices_TransferService]");
    if (dropdownTransferService.length > 0) {
        dropdownTransferService[0].selectedIndex = 0;
        dropdownTransferService.focus();
    }
}
//function is overridden to set the default value for AssessedNeedReferral Textbox
function  AddParentChildEventHandler()
{ 
    SetAssessedNeedReferral();
}
//Function Added By : Amit Kumar Srivastava, #1979, Harbor Go Live, PECIFICATION: Fill Receiving Program Drop-Down Dyanmically
function DropDownFillRecProgramByReceivingStaff() {
    //Below Code Added by Maninder (7/9/2012): Task#2007 in Harbor Go Live
    CreateAutoSaveXml("CustomDocumentDiagnosticAssessments", "TransferReceivingStaff", $("[id$=DropDownList_CustomDocumentDiagnosticAssessments_TransferReceivingStaff]").val());
    CreateAutoSaveXml("CustomDocumentDiagnosticAssessments", "TransferReceivingProgram", "");
    PopupProcessing();
    //Ends
    $.ajax({
        type: "POST",
        url: "../AjaxScript.aspx?functionName=RecProgramByReceivingStaff",
        data: "StaffID=" + $("[id$=DropDownList_CustomDocumentDiagnosticAssessments_TransferReceivingStaff]").val(),
        //async: false,
        success: OnSuccessRecProgramByReceivingStaff
    });
    
}
//Function Added By : Amit Kumar Srivastava, #1979, Harbor Go Live, PECIFICATION: Fill Receiving Program Drop-Down Dyanmically
function OnSuccessRecProgramByReceivingStaff(result) {
    HidePopupProcessing();
    if (result != '') {
        $("select[id$=DropDownList_CustomDocumentDiagnosticAssessments_TransferReceivingProgram]").html(result);
    }
    return;
}