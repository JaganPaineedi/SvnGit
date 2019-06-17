function ValidateCustomPageEventHandler() {
    if ($('[id$=DropDownList_CustomDocumentRevokeReleaseOfInformations_ClientInformationReleaseId]').val() == '') {
        ShowHideErrorMessage('Please select value from "Release To/From"', 'true');
        return false;
    }
    if ($('#TextBox_CustomDocumentRevokeReleaseOfInformations_RevokeEndDate').val() == '') {
        ShowHideErrorMessage('Please enter Revoke Release of information End Date.', 'true');
        return false;
    }
}