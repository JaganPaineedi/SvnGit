var DocumentVersionId;

function ManageToolbarItems() {
    ShowToolbarItems('Save');
    ShowToolbarItems('Help');
    HideToolbarItems('Delete');

}

function SetFilterParameterValueOnSave() {
    return 'DocumentVersionId=' + DocumentVersionId;
}

function fnOnChange() {
    CreateUnsavedInstanceOnDatasetChange();
}

function SetScreenSpecificValues(dom) {
    DocumentVersionId = GetFielValueFromXMLDom(dom, "CustomDocumentReferrals", "DocumentVersionId");
    //alert(DocumentVersionId);
}

//This Function calls when apply filter is clicked.
function ValidateCustomPageEventHandler() {
    return ValidateCustomDocumentReferrals();
}

function ValidateCustomDocumentReferrals() {
    
    //referring date
    var _referringDate = $('[id$=TextBox_CustomDocumentReferrals_ReferralSentDate]').val();
    if (_referringDate == '' || _referringDate == null) {
        ShowHideErrorMessage("Please add the Referral Date", 'true');
        $('[id$=TextBox_CustomDocumentReferrals_ReferralSentDate]').focus();
        return false;
    }

    //referring staff
    var _referringStaff = $('[id$=DropDownList_CustomDocumentReferrals_ReferringStaff]').val();
    if (_referringStaff == '' || _referringStaff == null || _referringStaff == '-1') {
        ShowHideErrorMessage("Please select the Referring Staff", 'true');
        $('[id$=DropDownList_CustomDocumentReferrals_ReferringStaff]').focus();
        return false;
    }

    //receiving staff
    var _receivingStaff = $('[id$=DropDownList_CustomDocumentReferrals_ReceivingStaff]').val();
    if (_receivingStaff == '' || _receivingStaff == null || _receivingStaff == '-1') {
        ShowHideErrorMessage("Please select the Receiving Staff", 'true');
        $('[id$=DropDownList_CustomDocumentReferrals_ReceivingStaff]').focus();
        return false;
    }

    //service
    var _service = $('[id$=DropDownList_CustomDocumentReferralServices_AuthorizationCodeId]').val();
    if (_service == '' || _service == null || _service == '-1') {
        ShowHideErrorMessage("Please select the Service", 'true');
        $('[id$=DropDownList_CustomDocumentReferralServices_AuthorizationCodeId]').focus();
        return false;
    }

//    //service
//    var _serviceGrid = $('[id$=CustomGrid]').val();
//    if (_serviceGrid == '' || _serviceGrid == null) {
//        ShowHideErrorMessage("Please insert the Service", 'true');
//        $('[id$=ButtonInsert]').focus();
//        return false;
//    }

    return true;
}