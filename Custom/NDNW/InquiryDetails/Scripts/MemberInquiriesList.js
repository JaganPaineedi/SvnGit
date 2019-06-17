
//Added by Minakshi Varma to Display New Button
function ManageToolbarItems() {
    ShowListToolbarItems("New");
}

function ValidateListFilters() {   
    if ($.trim($('#TextBox_InquiriesFrom').val()).length > 0 && $.trim($('#TextBox_InquiriesTo').val()).length > 0) {
        var dateStart = '';
        var dateEnd = '';
        var StartDate = $('#TextBox_InquiriesFrom')[0].value;
        var EndDate = $('#TextBox_InquiriesTo')[0].value;
        if (StartDate != null && StartDate != '') {
            dateStart = new Date(StartDate);

        }
        if (EndDate != null && EndDate != '') {
            dateEnd = new Date(EndDate);
        }
        if (dateStart != null && dateStart != '' && dateEnd != null && dateEnd != '') {
            if (dateStart > dateEnd) {
                $('#TextBox_InquiriesFrom').val('');
                $('#TextBox_InquiriesTo').val('');
                ShowHideErrorMessage('To Date should be greater than From date', 'true');
                return false;
            }
        }
    }
}

function ManageToolbarItems() {
    HideToolbarItems('New');
}