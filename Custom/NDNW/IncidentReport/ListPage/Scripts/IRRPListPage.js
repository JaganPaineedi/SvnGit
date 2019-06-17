
function ManageToolbarItems() {
    HideToolbarItems('New');
}

function IncludeRequestParametersValues() {
    var filterString = "";
    filterString += GetFilterValues();
    //Remove # from the begning of the string
    filterString = filterString.substring(1, filterString.length);
    filterString = filterString.replace(/#/gi, "&") + "&ExportUsingPageDataSet=Y";
    return filterString;
}


function ClearClick() {
    if ($('#TextBox_ClientNameFilter').val() != undefined) {
        $('#TextBox_ClientNameFilter').val('');
    }

}

function OpenIRPages() {
    if (objectPageResponse.UnsavedChangeId == 0) {
        if (parseInt(ClientID) == 0) {
            OpenClientSearchPopUp(GetRelativePath(), "IR");
        }
        else {
            OpenPage(5761, 62004, 'ClientId=' + parseInt(ClientID), 1, GetRelativePath(), null, null, pageActionEnum.New, null, null, null, null);
        }
    }

}
//OpenPage(5761, '62004', 'Flag=List', '1', GetRelativePath(), null, '', pageActionEnum.New);


function ProcessClientInfo(ClientId, ClientName, functionCalledFrom) {
    try {
        if (parseInt(ClientId) > 0) {
            if (functionCalledFrom == "IR") {
                OpenPage(5761, 62004, 'ClientId=' + ClientId, 1, GetRelativePath(), null, null, pageActionEnum.New, null, null, null, null);
                $('[id$=Span_CustomIncidentReports_ClientId]').html(ClientId);
                $('[id$=Span_CustomIncidentReports_Individual]').html(ClientName);
            }
            else {
                $('#HiddenField_CustomRestrictiveProcedures_ClientId').val(ClientId);
                OpenPage(5761, 40058, 'ClientId=' + ClientId, 2, GetRelativePath(), null, null, pageActionEnum.New, null, null, null, null);
            }
        }

    }
    catch (err) {
        LogClientSideException(err, 'ProcessClientInfo Ajax Error');
    }
}

function OpenRPPages() {
    if (objectPageResponse.UnsavedChangeId == 0) {
        if (parseInt(ClientID) == 0) {
            OpenClientSearchPopUp(GetRelativePath(), "RP");
        }
        else {
            OpenPage(5761, 40058, 'ClientId=' + ClientID, 2, GetRelativePath(), null, null, pageActionEnum.New, null, null, null, null);
        }
    }
    
}
//function ProcessClientInfo(ClientId, ClientName, functionCalledFrom) {
//    debugger;
//    try {
//        if (parseInt(ClientId) > 0) {
//            $('#HiddenField_CustomRestrictiveProcedures_ClientId').val(ClientId);
//            OpenPage(5761, 40058, 'ClientId=' + ClientId, null, GetRelativePath(), null, null, pageActionEnum.New, null, null, null);
//            //SetClientDetailsinXML(ClientId);
//        }

//    }
//    catch (err) {
//        LogClientSideException(err, 'ProcessClientInfo Ajax Error');
//    }
//}


// To Validate the date fields
function IRValidateDate() {
    if ($.trim($('#TextBox_StartDate').val()).length > 0 && $.trim($('#TextBox_EndDate').val()).length > 0) {
        var dateStart = '';
        var dateEnd = '';
        var StartDate = $('#TextBox_StartDate')[0].value;
        var EndDate = $('#TextBox_EndDate')[0].value;
        if (StartDate.trim() == '' && EndDate.trim() == '') {
            ShowHideErrorMessage('From Date and To Date is required', 'true');
            return false;
        }
        else if (StartDate.trim() == '') {
            ShowHideErrorMessage('From Date is required', 'true');
            return false;
        }
        else if (EndDate.trim() == '') {
            ShowHideErrorMessage('To Date is required', 'true');
            return false;
        }



        if (StartDate != null && StartDate != '') {
            dateStart = new Date(StartDate);

        }
        if (EndDate != null && EndDate != '') {
            dateEnd = new Date(EndDate);
        }
        if (dateStart != null && dateStart != '' && dateEnd != null && dateEnd != '') {
            if (dateStart > dateEnd) {
                $('#TextBox_StartDate').val('');
                $('#TextBox_EndDate').val('');
                ShowHideErrorMessage('To Date should be greater than From Date', 'true');
                return false;
            }
        }
    }
    if ($.trim($('#TextBox_StartDate').val()).length > 0) {
        if ($.trim($('#TextBox_EndDate').val()).length > 0) {
            var StartDate1 = $('#TextBox_StartDate')[0].value;
            var EndDate1 = $('#TextBox_EndDate')[0].value;
            if (StartDate1.trim() == '' && EndDate1.trim() == '') {
                ShowHideErrorMessage('From Date and To Date is required', 'true');
                return false;
            }
            else if (StartDate1.trim() == '') {
                ShowHideErrorMessage('From Date is required', 'true');
                return false;
            }
            else if (EndDate1.trim() == '') {
                ShowHideErrorMessage('To Date is required', 'true');
                return false;
            }
        }
    }
}
function OpenIRRPPage(obj, IncidentReportId, RestrictiveProcedureId, ClientId) {
    if (IncidentReportId != -1) {
        OpenPage(5761, 62004, 'IncidentReportId=' + IncidentReportId + '^ClientId=' + ClientId, 1, GetRelativePath());
    }
    else {
        OpenPage(5761, 40058, 'RestrictiveProcedureId=' + RestrictiveProcedureId + '^ClientId=' + ClientId, 2, GetRelativePath());
    }
}
function CompletedByChange() {
    var Recorder = $('[id$=CheckBox_Recorder]')[0].checked;
    var Nursing = $('[id$=CheckBox_Nursing]')[0].checked;
    var Supervisor = $('[id$=CheckBox_Supervisior]')[0].checked;
    var Administrator = $('[id$=CheckBox_Administrator]')[0].checked;
    if (Recorder == true) {
        $('[id$=HiddenField_Recorder]').val("Y");
    }
    else {
        $('[id$=HiddenField_Recorder]').val("N");
    }
    if (Nursing == true) {
        $('[id$=HiddenField_Nursing]').val("Y");
    }
    else {
        $('[id$=HiddenField_Nursing]').val("N");
    }
    if (Supervisor == true) {
        $('[id$=HiddenField_Supervisior]').val("Y");
    }
    else {
        $('[id$=HiddenField_Supervisior]').val("N");
    }
    if (Administrator == true) {
        $('[id$=HiddenField_Administrator]').val("Y");
    }
    else {
        $('[id$=HiddenField_Administrator]').val("N");
    }
}


function BindSecondaryIncident() {
    var IncidentCategoryValue= $("select[id$=DropDownList_CustomIncidentReportGenerals_GeneralIncidentCategory] :selected").val();
    var GlobalCodeId = IncidentCategoryValue;
    var SecondaryIncident = "";
    try {
        $.ajax({
            type: "POST",
            url: GetRelativePath() + "Custom/IncidentReport/DetailPage/WebPages/IncidentReport.aspx?functionName=GetSubGlobalCodes&GlobalCodeId=" + GlobalCodeId,
            data: '',
            async: false,
            success: function (result) {
                UpdateDropDown(result);
            }
        });
    }
    catch (err) {
        LogClientSideException(err, 'IncidentReport-BindSecondaryIncident');
    }
}

function UpdateDropDown(result) {
    $("[id$=DropDownList_CustomIncidentReportGenerals_GeneralSecondaryCategory]").html("");
    if (result != null || result != '') {
        if (result.xml != null || result.xml != '') {
            $("<option value=" + '' + ">" + '' + "</option>").prependTo("[id$=DropDownList_CustomIncidentReportGenerals_GeneralSecondaryCategory]");
            $.xmlDOM(result.xml).find("IncidentSubCodes").each(function () {
                $("<option value=" + this.childNodes[1].text + ">" + this.childNodes[0].text + "</option>").attr("Code", this.childNodes[2].text).appendTo("[id$=DropDownList_CustomIncidentReportGenerals_GeneralSecondaryCategory]");
            });
        }
    }
    var SelectedSecondaryCategory =$.xmlDOM(objectPageResponse.ScreenFiltersXml).find("GeneralSecondaryCategory").text();
    if(SelectedSecondaryCategory!="")
    $("[id$=DropDownList_CustomIncidentReportGenerals_GeneralSecondaryCategory]").val(SelectedSecondaryCategory);
}

function AddEventHandlers() {
    $('[id$=DropDownList_CustomIncidentReportGenerals_GeneralIncidentCategory]').unbind('change').bind('change', function () { BindSecondaryIncident(); });
}


function LispPageCallBackComplete() {
    BindSecondaryIncident();
}