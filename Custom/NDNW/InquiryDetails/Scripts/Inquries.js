//Commented By Davinder Kumar 18 may 2011
//Purpose : To make new button visible on the DrugAllergyInteraction Overrides List page
//function ManageToolbarItems() {
//    ShowToolbarItems('New');
//}

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

//function GetListPageWithFiltersAppoint() {
//    //    var startdate = $("[id$=HiddenField_StartDate]").val();

//    //    $("[id$=TextBox_StartDate]").val(startdate);
//    return GetListPageWithFilters();

//}


function IncludeRequestParametersValues() {
    var filterString = "";
    filterString += GetFilterValues();
    //Remove # from the begning of the string
    filterString = filterString.substring(1, filterString.length);
    filterString = filterString.replace(/#/gi, "&") + "&ExportUsingPageDataSet=Y"
    return filterString;
}