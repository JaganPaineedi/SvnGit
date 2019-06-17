var tabobject = null;
var psychiatricEvaluationProblemIdArray = [];

function SetCurrentTab(sender, e) {
    try {
        TabIndex = sender.activeTabIndex;
    }
    catch (err) { }
}

function onTabSelectedClient(sender, args) {
    onTabSelected(sender, args);
}

function onChildTabSelected(sender, arg) {
    tabobjectChild = sender;
}

function disableTabClick(index, name) {
    subtabindex = index;
}

function StoreTabstripClientObject(sender) {
    try {
        tabobject = sender;
    }
    catch (err) { }
}

function SetScreenSpecificValues(dom, action) {
    try {
        psychiatricEvaluationProblemIdArray = [];
        if (typeof tabobject == 'undefined' || tabobject == undefined || tabobject == null || tabobject == "") {
        }
        else {
            var historytabobject = tabobject._selectedIndex;
            if (historytabobject >= 0) {
                selectedTabText = tabobject.get_selectedTab().get_text();
                if (historytabobject == 0 && selectedTabText == 'General') {
                    var myDate = new Date();
                    $('[id$=divClientInformationNotesLink] > table tr').each(function () {
                        $(this).find('td').each(function () {
                            var obj = $(this).find('span').next();
                            if ($(obj).length > 0) {
                                $.post(GetRelativePath() + "CommonUserControls/AjaxCallForInformationIconToolTip.aspx?ClientInformationNotes=Y&StoredProcedureName=" + $(obj).attr('TooltipSP') + "&Date=" + myDate, function (data) {
                                    $(obj).wTooltip({
                                        content: data,
                                        style: {
                                            border: "1px solid black",
                                            background: "yellow",
                                            color: "black",
                                            padding: "1px,1px,10px,1px",
                                            top: "5px"
                                        }
                                    });

                                });
                            }
                        });
                    });


                    var controlCollection = $("img", $("#tbl_lifeevent")[0]);
                    if (controlCollection) {
                        controlCollection.each(
                         function () {
                             $(this).css('width', '16px');
                             $(this).css('height', '16px');
                             $('#divlifeevent').html($(this));
                         }
                     );
                    }

                    if ($('#divPreviousDiagnosis').length > 0) {
                        BindPreviousDiagnosis();
                    }

                    if ($('#divAppointment').length > 0) {
                        BindNextAppointment();
                    }
                }
                else if (historytabobject == 1 && selectedTabText == 'History') {
                    if ($('#divProblemTemplate').length > 0)
                        appendExistingProblems(dom, 1, 0);
                }
                else if (historytabobject == 2 && selectedTabText == 'Exam') {
                    if ($('#divVitals').length > 0)
                        loadVitals();

                    if ($('#TextBox_CustomDocumentPsychiatricEvaluations_GeneralAppearanceOtherText').length > 0 && $('#CheckBox_CustomDocumentPsychiatricEvaluations_GeneralAppearanceOther').length > 0) {                       
                        var GeneralAppearanceOther = 'N';
                        GeneralAppearanceOther = dom.find("CustomDocumentPsychiatricEvaluations:first GeneralAppearanceOther").text();
                        if (!GeneralAppearanceOther)
                            GeneralAppearanceOther = 'N';
                        if (GeneralAppearanceOther == 'Y')
                            $('#TextBox_CustomDocumentPsychiatricEvaluations_GeneralAppearanceOtherText').show();
                        else
                            $('#TextBox_CustomDocumentPsychiatricEvaluations_GeneralAppearanceOtherText').hide();
                    }
                }
                else if (historytabobject == 3 && selectedTabText == 'Medical Decision Making') {
                    BindMedications();
                    BindProblemsStatus(dom);
                    showHideLabsSelected('setscreen', dom);
                }
                else if (historytabobject == 4 && selectedTabText == 'Diagnosis') {
                    if (typeof SetDiagnosisIAndIIHiddenOrderField == 'function') {
                        SetDiagnosisIAndIIHiddenOrderField(dom);
                    }
                }
            }
        }
    }
    catch (err) {

    }
}

function AddEventHandlers() {
    try {
        var btnOpenCalendar = $('input[id$=Button_CustomDocumentPsychiatricEvaluations_OpenCalendar]');
        if (btnOpenCalendar.length > 0) {
            btnOpenCalendar.unbind('click');
            btnOpenCalendar.bind("click", function () {
                if (Dirty == "True" || UnsavedChangeId > 0) {
                    ShowMsgBox('Please save the existing unsaved record for this screen prior to opening the calendar', 'Confirmation', MessageBoxButton.OK, MessageBoxIcon.Information);
                    return false;
                }
                else {
                    OpenCalendar();
                }
            });
        }

        if ($("[id*=imgSort]").length > 0)
            $("[id*=imgSort]").css("display", "none");
        if ($("[id$=imgsort]").length > 0)
            $("[id$=imgsort]").css("display", "block");

        if ($('#divProblemTemplate').length > 0) {
            if (AutoSaveXMLDom.find("PsychiatricEvaluationProblemId").length > 1) {
                bindFocusEventHistory('History');
                bindHistoryTabScrollEvent();
            }
        }

        var buttonPlaceLab = $("input[type=button][id$=Button_OpenFlowSheet]");
        if (buttonPlaceLab.length > 0) {
            buttonPlaceLab.unbind('click');
            buttonPlaceLab.bind('click', function () {
                var date = (new Date()).format("MM/dd/yyyy  hh:mm:ss tt");
                OpenPage(5761, 716, 'HealthDataTemplateId=110' + '^HealthRecordDate=' + date + '^ClienID=' + ClientID, 2, GetRelativePath());
            });
        }

        var checkBoxGeneralAppearanceOther = $("[id$=CheckBox_CustomDocumentPsychiatricEvaluations_GeneralAppearanceOther]");
        if (checkBoxGeneralAppearanceOther.length > 0) {
            checkBoxGeneralAppearanceOther.unbind('click');
            checkBoxGeneralAppearanceOther.bind('click', function () {
                if ($(this).attr('checked')) {
                    $('#TextBox_CustomDocumentPsychiatricEvaluations_GeneralAppearanceOtherText').show();
                }
                else {
                    CreateAutoSaveXml("CustomDocumentPsychiatricEvaluations", "GeneralAppearanceOtherText", "");
                    $('#TextBox_CustomDocumentPsychiatricEvaluations_GeneralAppearanceOtherText').val('');
                    $('#TextBox_CustomDocumentPsychiatricEvaluations_GeneralAppearanceOtherText').hide();
                }
            });
        }



        var buttonOpenSmartCareRX = $("input[type=button][id$=Button_CustomDocumentPsychiatricEvaluations_OpenSmartCareRX]");
        if (buttonOpenSmartCareRX.length > 0) {
            buttonOpenSmartCareRX.bind('click', function () {
                OpenPage(5766, 105, 'DocumentNavigationName=Medications', 2, GetRelativePath());
            });
        }
        var buttonViewMedicationHistoryReport = $("input[type=button][id$=Button_CustomDocumentPsychiatricEvaluations_ViewMedicationHistoryReport]");
        if (buttonViewMedicationHistoryReport.length > 0) {
            buttonViewMedicationHistoryReport.bind('click', function () {
                OpenPage(5766, 105, 'DocumentNavigationName=Medications^OpenScreen=MedicationReport', 2, GetRelativePath());
            });
        }

        var buttonPlaceOrder = $("input[type=button][id$=Button_CustomDocumentPsychiatricEvaluations_PlaceOrder]");
        if (buttonPlaceOrder.length > 0) {
            buttonPlaceOrder.unbind('click');
            buttonPlaceOrder.bind('click', function () {
                OpenPage(5763, 772, 'DocumentNavigationName=Client Order', 2, GetRelativePath());
            });
        }
    }
    catch (ex) {

    }
}

BindPreviousDiagnosis = (function () {
    try {
        var requestParametersValues = "FunctionName=GetPreviousDiagnosis";
        $.ajax({
            type: "POST",
            url: _ApplicationBasePath + "Custom/PsychiatricEvaluation/WebPages/PsychiatricEvaluation.ashx",
            data: requestParametersValues,
            success: function (data) {
                if (data != '') {
                    CreateDiagnosisTable(data);
                }
            },
            error: function (result, err, Message) {
            }
        });
    }
    catch (ex) {

    }
});

CreateDiagnosisTable = (function (result) {
    var tableHeader = "<table width='100%' border='0'><thead><tr>";
    var tableBody = "<tbody>";
    var endTable = "</table>";
    tableHeader += "<tr>";
    tableHeader += "<th align='left' colspan='6' style='padding-top:5px;padding-bottom:5px;'>Diagnosis List</th>";
    tableHeader += "</tr>";
    tableHeader += "<tr>";
    tableHeader += "<th align='left' style='width:10%'>Order</th>";
    tableHeader += "<th align='left' style='width:15%'>DSM 5/ICD 10</th>";
    tableHeader += "<th align='left' style='width:15%'>DSM IV/ICD 9</th>";
    tableHeader += "<th align='left' style='width:30%'>Description</th>";
    tableHeader += "<th align='left' style='width:15%'>Type</th>";
    tableHeader += "<th align='left' style='width:15%'>Severity</th>";
    tableHeader += "</tr></thead>";
    var result1 = $.xmlDOM(result);
    $(result1).find('DocumentDiagnosisCodes').each(function () {
        tableBody += "<tr>";
        tableBody += "<td align='left'>" + $(this).find('DiagnosisOrder').text() + "</td>";
        tableBody += "<td align='left'>" + $(this).find('ICD10Code').text() + "</td>";
        tableBody += "<td align='left'>" + $(this).find('ICD9Code').text() + "</td>";
        var dsmDesciption = $(this).find('DSMDescription').text();
        if (dsmDesciption.length > 30)
            dsmDesciption = "<span title='" + dsmDesciption + "'>" + dsmDesciption.substring(0, 30) + "..." + "</span>";
        else
            dsmDesciption = "<span>" + dsmDesciption + "</span>";

        tableBody += "<td align='left'>" + dsmDesciption + "</td>";
        tableBody += "<td align='left'>" + $(this).find('DiagnosisType').text() + "</td>";
        tableBody += "<td align='left'>" + $(this).find('Severity').text() + "</td>";
        tableBody += "</tr>";
    });
    var tableHeaderAxisIII = "<tr>";
    tableHeaderAxisIII += "<td align='left' colspan='6' style='padding-top:5px;padding-bottom:5px;'>Psychosocial, Environmental, and Other Factors</td>";
    tableHeaderAxisIII += "</tr>";
    tableHeaderAxisIII += "<tr>";
    tableHeaderAxisIII += "<td align='left' style='padding-top:5px;'>&nbsp;</td>";
    tableHeaderAxisIII += "<td align='left' colspan='5' style='padding-top:5px;'>Source</td>";
    tableHeaderAxisIII += "</tr>";
    var result2 = $.xmlDOM(result);
    var tableBodyAxisIII = "";
    $(result2).find('DocumentDiagnosisFactors').each(function () {
        tableBodyAxisIII += "<tr>";
        tableBodyAxisIII += "<td align='left'>&nbsp;</td>";
        tableBodyAxisIII += "<td align='left' colspan='5' style='padding-top:5px;'>" + $(this).find('Factors').text() + "</td>";
        tableBodyAxisIII += "</tr>";
    });

    var tableHeaderAxisIV = "<tr>";
    tableHeaderAxisIV += "<td align='left' colspan='6' style='padding-top:5px;' >Axis IV</td>";
    tableHeaderAxisIV += "</tr>";
    var result3 = $.xmlDOM(result);
    var tableBodyAxisIV = "";
    $(result3).find('DiagnosesIV').each(function () {
        tableBodyAxisIV += "<tr>";
        //below Changes by made Rahul Aneja ref: task#2129 in Thresholds bugs & features ,show all For Axis IV - single line with comma separate values for what is checked ,
        var specification = $(this).find('Specification').text();
        if (specification.substring(specification.length - 2, specification.length - 1) === ",")
            specification = specification.substring(0, specification.length - 2);

        tableBodyAxisIV += "<td align='left' colspan='6'>" + specification + "</td>";
        //End Chages
        tableBodyAxisIV += "</tr>";
    });

    var tableHeaderAxisV = "<tr>";
    tableHeaderAxisV += "<td align='left'colspan='6'  style='padding-top:5px;padding-bottom:5px;'>Level of Functioning Score</td>";
    tableHeaderAxisV += "</tr>";
    var result4 = $.xmlDOM(result);
    var tableBodyAxisV = "";
    $(result4).find('DocumentDiagnosis').each(function () {
        tableBodyAxisV += "<tr>";
        tableBodyAxisV += "<td align='right' colspan='2' style='padding-right:38px;'>GAF Score: " + $(this).find('GAFScore').text() + "</td>";
        tableBodyAxisV += "<td align='center' colspan='2'>WHODAS Score: " + $(this).find('WHODASScore').text() + "</td>";
        tableBodyAxisV += "<td align='left' colspan='2' style='padding-left:0px;'>CAFAS Score: " + $(this).find('CAFASScore').text() + "</td>";
        tableBodyAxisV += "</tr>";
    });

    //tableBody += "</tbody>";

    var effectiveDate = $.xmlDOM(result).find('EffectiveDate').text();

    var trEffictiveDate = "<table width='100%'><tr><td align='left' width='20%'>Effective Date: " + effectiveDate + "</td></tr></table>";

    var DiagnosisHTML = trEffictiveDate + tableHeader + tableBody + tableHeaderAxisIII + tableBodyAxisIII + tableHeaderAxisV + tableBodyAxisV + "</tbody>" + endTable;
    $("[id$=divPreviousDiagnosis]").html(DiagnosisHTML);
});

function OpenCalendar() {
    try {
        var ServiceId = null;
        var ClientId = null;
        var ClientName = null;
        var StaffId = null;
        var DocumentId = null;
        var StaffName = null;
        if ($('Services > ServiceId', AutoSaveXMLDom[0]).length > 0 && parseInt($('Services ServiceId', AutoSaveXMLDom[0]).text()) > 0) {
            DateOfService = GetFielValueFromXMLDom(AutoSaveXMLDom, "Services", "DateOfService");
            DateOfService = ChangeDateFormat(DateOfService);
            ServiceId = GetFielValueFromXMLDom(AutoSaveXMLDom, "Services", "ServiceId");
            StaffId = GetFielValueFromXMLDom(AutoSaveXMLDom, "Services", "ClinicianId");
            DocumentId = GetFielValueFromXMLDom(AutoSaveXMLDom, "Documents", "DocumentId");
            ClientId = ClientID;
            ClientName = CurrentClientName;
            OpenPage(5765, 28, "ClientId=" + ClientId + "^ClientName=" + ClientName + "^ServiceId=" + ServiceId + "^DateOfService=" + DateOfService + "^StaffId=" + StaffId + "^associatedNoteScreenId=" + 21300 + "^FollowUp=Y^ScreenIdToOpen=29^ScreenTypeToOpen=5763^keyscreenid=29^keyfieldvalue=" + ServiceId, 2, GetRelativePath());
        }
    }
    catch (err) {
        LogClientSideException(err, 'PsychEval - OpenCalendar'); //Code added by Devinder 
    }
}

BindNextAppointment = (function () {
    try {
        try {
            var ServiceId = GetFielValueFromXMLDom(AutoSaveXMLDom, "Services", "ServiceId");
            var requestParametersValues = "FunctionName=GetNextAppointment&ServiceId=" + ServiceId;
            $.ajax({
                type: "POST",
                url: _ApplicationBasePath + "Custom/PsychiatricEvaluation/WebPages/PsychiatricEvaluation.ashx",
                data: requestParametersValues,
                success: function (data) {
                    if (data != '') {
                        CreateAppointmentTable(data);
                    }
                },
                error: function (result, err, Message) {
                }
            });
        }
        catch (ex) {

        }
    }
    catch (ex) { }
});

CreateAppointmentTable = (function (result) {
    var tableHeader = "<table width='100%'><thead><tr>";
    var tableBody = "<tbody>";
    var endTable = "</table>";
    tableHeader += "<th align='left' width='100%'></th>";
    tableHeader += "</tr></thead>";
    var resultNextAppointment = $.xmlDOM(result);
    $(resultNextAppointment).find('Appointments').each(function () {
        tableBody += "<tr>";
        tableBody += "<td align='left'>" + $(this).find('Appointment').text() + "</td>";
        tableBody += "</tr>";
    });
    tableBody += "</tbody>";

    $("[id$=divAppointment]").html((tableHeader + tableBody + endTable));
});

function showDiv(divId, img) {

    var path = GetRelativePath();
    if (img.alt.trim() == 'show') {
        $('[id$=' + divId + ']').show();
        img.alt = 'hide';
        img.src = path + 'MySkins/Grid/SortAsc.gif';
    }
    else {
        $('[id$=' + divId + ']').hide();
        img.alt = 'show';
        img.src = path + 'MySkins/Grid/SortDesc.gif';
    }
    return false;
}

var isApplyFilter = "No";
var imgId = "imgsort";
var sort = "desc";
var prevImgId = "imgsort";

function CustomAjaxRequestCallback(result, CutomAjaxRequest) {
    $("[id$=PnlServiceGrid]").html(result);
    var path = GetRelativePath();

    $("[id*=imgSort]").css("display", "none");
    $("[id$=" + imgId + "]").css("display", "block");
    if (isApplyFilter == "No") {
        if ($("[id$=" + imgId + "]")[0] != undefined) {
            if (sort == "desc" && prevImgId == imgId) {
                sort = "asc";
                $("[id$=" + imgId + "]")[0].src = path + 'MySkins/Grid/SortAsc.gif';
            } else {
                sort = "desc";
                $("[id$=" + imgId + "]")[0].src = path + 'MySkins/Grid/SortDesc.gif';
            }
        }
        prevImgId = imgId;
    }
}

function SortColumn(sortColumn, imageID) {
    imgId = imageID;
    isApplyFilter = "No";
    var relativePath = GetRelativePath();
    if (prevImgId != imgId) {
        sort = "asc";
    }
    var filter = 'sortColumn=' + sortColumn + '^CustomAction=' + sort + '^AssociatedDocumentCodeId=' + 22400;
    parent.OpenPage(5763, 22401, filter, null, GetRelativePath(), 'T', null, pageActionEnum.CustomAjaxCall, null, null, null);

}

loadVitals = (function () {
    try {
        var requestParametersValues = "FunctionName=LoadVitals";
        $.ajax({
            type: "POST",
            url: _ApplicationBasePath + "Custom/PsychiatricEvaluation/WebPages/PsychiatricEvaluation.ashx",
            data: requestParametersValues,
            success: function (data) {
                if (data != '') {
                    var divVital = $("[id$=divVitals]");
                    var VitalsHtml = data.split("#8#2#3$");
                    $("[id$=divVitalsHead]").html(createVitalHeadTable(VitalsHtml));
                    divVital.html(createTable(VitalsHtml));

                }
            },
            error: function (result, err, Message) {
            }
        });
    }
    catch (ex) {

    }
});

function createVitalHeadTable(vitalhtml) {
    try {
        if (vitalhtml.length > 0) {
            var tableHeader = "<table width='100%' cellpadding='0' cellspacing='0' border='0'>";
            var tableBody = "";
            var endTable = "</table>";
            tableBody += "<tr valign='top'>";
            tableBody += "<td align='center' width='50%' style='padding:3px 3px 3px 3px;'> <u><span>Current vitals </span>" + vitalhtml[2] + "</u></td>";
            tableBody += "<td align='center' width='50%' style='padding:3px 3px 3px 3px;'><u><span>Previous vitals </span>" + vitalhtml[3] + "</u></td>";
            tableBody += "</tr>";
            return tableHeader + tableBody + endTable;
        }

    }
    catch (err) {
        LogClientSideException(err, 'LoadVitals: createTable');
    }
}

function createTable(vitalhtml) {
    try {
        if (vitalhtml.length > 0) {
            var tableHeader = "<table width='100%' cellpadding='0' cellspacing='0' border='0'>";
            var tableBody = "";
            var endTable = "</table>";
            tableBody += "<tr valign='top'>";
            tableBody += "<td align='center' width='50%' style='padding-bottom:2px;padding-left:5px'></td>";
            tableBody += "<td align='center' width='50%' style='padding-bottom:2px;padding-left:5px'></td>";
            tableBody += "</tr>";
            tableBody += "<tr valign='top'>";
            tableBody += "<td align='left' width='50%' style='padding-bottom:2px;padding-left:5px'>" + vitalhtml[1] + "</td>";
            tableBody += "<td align='left' width='50%' style='padding-bottom:2px;padding-left:5px'>" + vitalhtml[0] + "</td>";
            tableBody += "</tr>";
            return tableHeader + tableBody + endTable;
        }

    }
    catch (err) {
        LogClientSideException(err, 'LoadVitals: createTable');
    }
}

BindMedications = (function () {
    try {
        var DateOfService = GetFielValueFromXMLDom(AutoSaveXMLDom, "Services", "DateOfService");
        if (DateOfService != null)
            DateOfService = ChangeDateFormat(DateOfService);
        var requestParametersValues = "FunctionName=GetMedications&DateOfService=" + DateOfService;

        $.ajax({
            type: "POST",
            url: _ApplicationBasePath + "Custom/PsychiatricEvaluation/WebPages/PsychiatricEvaluation.ashx",
            data: requestParametersValues,
            success: function (data) {
                if (data != '') {
                    CreateMedicationsTablesMain(data);
                }
            },
            error: function (result, err, Message) {
            }
        });
    }
    catch (ex) {

    }
});

CreateMedicationsTablesMain = (function (result) {
    var medicationResult = null;
    if (result != "") {
        medicationResult = result;
    }

    var resultCurrentMedication = "";
    var resultDiscontinuedMedication = "";
    var resultSelfMedication = "";
    if (medicationResult && medicationResult.length > 0) {
        resultCurrentMedication = medicationResult;
        resultDiscontinuedMedication = medicationResult;
        resultSelfMedication = medicationResult;
    }
    if (resultCurrentMedication != undefined && resultCurrentMedication.length > 0) {
        var divCurrentMedications = $('#divCurrentMedications');
        if (divCurrentMedications) {
            divCurrentMedications.html('');
        }
        divCurrentMedications.html(createMedicationsTable(resultCurrentMedication, 'O'));
    }

    if (resultDiscontinuedMedication != undefined && resultDiscontinuedMedication.length > 0) {
        var divMedicationsDiscontinued = $('#divMedicationsDiscontinued');
        if (divMedicationsDiscontinued) {
            divMedicationsDiscontinued.html('');
        }
        divMedicationsDiscontinued.html(createMedicationsTable(resultDiscontinuedMedication, 'DC'));
    }

    if (resultSelfMedication != undefined && resultSelfMedication.length > 0) {
        var divSelfReported = $('#divSelfReported');
        if (divSelfReported) {
            divSelfReported.html('');
        }
        divSelfReported.html(createMedicationsTable(resultSelfMedication, 'SM'));
    }

});

function createMedicationsTable(result, medGroup) {
    var tableHeader = "<table width='100%'><thead><tr>";
    var tableBody = "<tbody>";
    var endTable = "</table>";
    tableHeader += "<th align='left' width='15%'>Medication Name</th>";
    tableHeader += "<th align='left' width='32%'>Instruction</th>";
    tableHeader += "<th align='left' width='17%'>Prescriber</th>";
    tableHeader += "<th align='left' width='8%'>Source</th>";
    //    if (medGroup === 'O')
    //        tableHeader += "<th align='left' width='13%'>Last Ordered</th>";
    tableHeader += "<th align='left' width='13%'>Instruction Start</th>";
    tableHeader += "<th align='left' width='10%'>Rx End Date</th>";
    //if (medGroup === 'DC')
    tableHeader += "<th align='left' width='5%'>Script</th>";
    //    if (medGroup === 'SM')
    //        tableHeader += "<th align='left' width='5%'>Source</th>";
    tableHeader += "</tr></thead>";
    var resultClientMedications = $.xmlDOM(result);
    if (medGroup === 'O') {
        $(resultClientMedications).find('CurrentMedications').each(function () {
            tableBody += "<tr>";
            tableBody += "<td align='left'>" + $(this).find('MedicationName').text() + "</td>";
            tableBody += "<td align='left'>" + $(this).find('Instructions').text() + "</td>";
            tableBody += "<td align='left'>" + $(this).find('PrescriberName').text() + "</td>";
            tableBody += "<td align='left'>" + $(this).find('Source').text() + "</td>";
            //            if (medGroup === 'O')
            //                tableBody += "<td align='left'>" + $(this).find('LastOrdered').text() + "</td>";
            tableBody += "<td align='left'>" + $(this).find('MedicationStartDate').text() + "</td>";
            tableBody += "<td align='left'>" + $(this).find('MedicationEndDate').text() + "</td>";
            if (medGroup === 'DC')
                tableBody += "<td align='left'>" + $(this).find('Script').text() + "</td>";
            //            if (medGroup === 'SM')
            //                tableBody += "<td align='left'>" + $(this).find('Source').text() + "</td>";
            tableBody += "</tr>";
        });
    }
    if (medGroup === 'DC') {
        $(resultClientMedications).find('DiscontinuedMedications').each(function () {
            tableBody += "<tr>";
            tableBody += "<td align='left'>" + $(this).find('MedicationName').text() + "</td>";
            tableBody += "<td align='left'>" + $(this).find('Instructions').text() + "</td>";
            tableBody += "<td align='left'>" + $(this).find('PrescriberName').text() + "</td>";
            tableBody += "<td align='left'>" + $(this).find('Source').text() + "</td>";
            //            if (medGroup === 'O')
            //                tableBody += "<td align='left'>" + $(this).find('LastOrdered').text() + "</td>";
            tableBody += "<td align='left'>" + $(this).find('MedicationStartDate').text() + "</td>";
            tableBody += "<td align='left'>" + $(this).find('MedicationEndDate').text() + "</td>";
            if (medGroup === 'DC')
                tableBody += "<td align='left'>" + $(this).find('Script').text() + "</td>";
            //            if (medGroup === 'SM')
            //                tableBody += "<td align='left'>" + $(this).find('Source').text() + "</td>";
            tableBody += "</tr>";
        });
    }
    if (medGroup === 'SM') {
        $(resultClientMedications).find('SelfRepotedMedications').each(function () {
            tableBody += "<tr>";
            tableBody += "<td align='left'>" + $(this).find('MedicationName').text() + "</td>";
            tableBody += "<td align='left'>" + $(this).find('Instructions').text() + "</td>";
            tableBody += "<td align='left'>" + $(this).find('PrescriberName').text() + "</td>";
            tableBody += "<td align='left'>" + $(this).find('Source').text() + "</td>";
            //            if (medGroup === 'O')
            //                tableBody += "<td align='left'>" + $(this).find('LastOrdered').text() + "</td>";
            tableBody += "<td align='left'>" + $(this).find('MedicationStartDate').text() + "</td>";
            tableBody += "<td align='left'>" + $(this).find('MedicationEndDate').text() + "</td>";
            if (medGroup === 'DC')
                tableBody += "<td align='left'>" + $(this).find('Script').text() + "</td>";
            //            if (medGroup === 'SM')
            //                tableBody += "<td align='left'>" + $(this).find('Source').text() + "</td>";
            tableBody += "</tr>";
        });
    }
    tableBody += "</tbody>";
    return tableHeader + tableBody + endTable;
}

BindProblemsStatus = (function (domObject) {
    var XmlProblems;
    var ProblemsLength;
    var ControlHtml = "";
    XmlProblems = domObject[0].childNodes[0].selectNodes("CustomPsychiatricEvaluationProblems")
    ProblemsLength = domObject[0].childNodes[0].selectNodes("CustomPsychiatricEvaluationProblems").length;
    ControlHtml += "<table border='0' cellspacing='0' cellpadding='0' width='98.5%'  style='padding-left:0px'>";

    var k = 0;
    for (var i = 0; i < ProblemsLength; i++) {
        var recorddeletedTEXT = 'N';
        if (XmlProblems[i].selectNodes("RecordDeleted")[0] != null) {
            recorddeletedTEXT = XmlProblems[i].selectNodes("RecordDeleted")[0].text;
        }
        if (recorddeletedTEXT != 'Y') {
            k++;
            var ProblemNumber = "Problem " + (k).toString() + ": ";
            var ProblemText = XmlProblems[i].selectNodes("ProblemText")[0] == null ? '' : XmlProblems[i].selectNodes("ProblemText")[0].text;
            var ProblemId = XmlProblems[i].selectNodes("PsychiatricEvaluationProblemId")[0].text;
            var ProblemStatusTEXT = '';
            if (XmlProblems[i].selectNodes("ProblemStatus")[0] != null) {
                ProblemStatusTEXT = XmlProblems[i].selectNodes("ProblemStatus")[0].text;
            }
            var ProblemDropdownHtml = "";
            var ProblemsDropdown = $("select[id$=DropDownListCommon_CustomDocumentPsychiatricEvaluations_ProblemStatus]").val(ProblemStatusTEXT);
            if (ProblemsDropdown.length > 0) {
                ProblemDropdownHtml = ProblemsDropdown.html();
            }
            ControlHtml += "<tr style='height: 8px;'></tr>";
            ControlHtml += "<tr>";
            ControlHtml += "<td style='width:80%'>";
            ControlHtml += ProblemNumber + ProblemText;
            ControlHtml += "</td>"
            ControlHtml += "<td align='right' style='width:20%'>";
            ControlHtml += "<span id='Span_Status'>Status</span>&nbsp;&nbsp;&nbsp;<select style='width:60%' id='DropDownList_CustomPsychiatricEvaluationProblems_" + ProblemId + "_ProblemStatus' class='form_dropdown'  bindautosaveevents='False' ProblemId = " + ProblemId + " onchange='UpdateProblemStatus(this)';   innerHTML = " + ProblemDropdownHtml + " >"
            ControlHtml += "</select>"
            ControlHtml += "</td>"
            ControlHtml += "</tr>";
        }
    }
    ControlHtml += "</table>"

    $("#ProblemsContainer").html(ControlHtml)

});

function UpdateProblemStatus(ctrl) {
    var nameArray = ctrl.id.split("_");
    var tablename = nameArray[1];
    var primaryKeyColumnName = 'PsychiatricEvaluationProblemId';
    var columnname = nameArray[3];
    var primaryKey = nameArray[2];
    var ctrlValue = GetControlValue(ctrl, undefined);
    var currentXMLDom = $("CustomPsychiatricEvaluationProblems>PsychiatricEvaluationProblemId[text=" + primaryKey + "]", AutoSaveXMLDom[0]).parent();
    CustomSetColumnValueInXMLNodeByKeyValue("CustomPsychiatricEvaluationProblems", primaryKeyColumnName, primaryKey, columnname, ctrlValue, currentXMLDom);

}

function CustomSetColumnValueInXMLNodeByKeyValue(tableName, primaryKeyColumnName, primaryKeyValue, changeColumnName, changeColumnValue, xmlDom) {
    if ($(changeColumnName, xmlDom).length == 0) {
        xmlDom[0].appendChild(AutoSaveXMLDom[0].createElement(changeColumnName));
    }
    var _xmlNode = $(changeColumnName, xmlDom);
    if (changeColumnValue == "") {
        _xmlNode.attr("xsi:nil", 'true');
    }
    _xmlNode.text(changeColumnValue);
    AddToUnsavedTables(tableName);
    CreateUnsavedInstanceOnDatasetChange();
}

function RefreshTabPageContentFromExternalScreenURL(pageAction, filtersData) {
    try {
        if (pageAction.toLowerCase() == 'update') {
            if (typeof tabobject == 'undefined' || tabobject == undefined || tabobject == null || tabobject == "") {
            }
            else {
                historytabobject = tabobject._selectedIndex;
                if (historytabobject >= 0) {
                    selectedTabText = tabobject.get_selectedTab().get_text();
                    if (historytabobject == 3 && selectedTabText == 'Medical Decision Making') {
                        BindMedications();
                    }
                }
            }
        }
    }
    catch (err) {
        LogClientSideException(err, 'Psychiatric Evaluations :RefreshTabPageContentFromExternalScreenURL');
    }
}

function RefreshTabPageContents(tabControl, selectedTabTitle) {
    selectedTabTitle = $.trim(selectedTabTitle);
    try {
        if (selectedTabTitle == 'Medical Decision Making') {
            BindProblemsStatus(AutoSaveXMLDom);
        }
    }
    catch (err) {
    }
}

function showHideLabsSelected(mode, dom) {
    var Labs = 'N';
    if (mode == 'ctrl') {
        if ($('#CheckBox_CustomDocumentPsychiatricEvaluations_Labs').attr('checked'))
            Labs = 'Y';
        else
            Labs = 'N';
    }
    else {
        Labs = dom.find("CustomDocumentPsychiatricEvaluations:first Labs").text();
        if (!Labs)
            Labs = 'N';
    }

    if (Labs == 'N') {
        $('[id$=DropDownList_CustomDocumentPsychiatricEvaluations_LabsSelected]').hide();
        if (mode == 'ctrl') {
            if ($("[id$=DropDownList_CustomDocumentPsychiatricEvaluations_LabsSelected] option").length > 0) {
                if ($('[id$=DropDownList_CustomDocumentPsychiatricEvaluations_LabsSelected]').val() != "") {
                    $('[id$=DropDownList_CustomDocumentPsychiatricEvaluations_LabsSelected]').val('');
                    CreateAutoSaveXml("CustomDocumentPsychiatricEvaluations", "LabsSelected", "");
                }
            }
        }
    }
    else {
        $('[id$=DropDownList_CustomDocumentPsychiatricEvaluations_LabsSelected]').show();
    }

}

function CallCustomNoteAfterDocumentCallbackComplete() {
    if (openNewpage == true && openNewpage != undefined) {
        EffectiveDate = $('#TextBox_DocumentInformation_EffectiveDate').val();
        var documentstatus = ValidationBeforeUpdate();
        var PastHistryCount = 0;
        if (documentstatus) {
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricEvaluations:first MedicalHistory").text() != '') {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryPHMedicalHistory", 'Y');
                PastHistryCount = PastHistryCount + 1;
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryPHMedicalHistory", 'N');
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricEvaluations:first FamilyHistory").text() != '') {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryPHFamilyHistory", 'Y');
                PastHistryCount = PastHistryCount + 1;
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryPHFamilyHistory", 'N');
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricEvaluations:first SocialHistory").text() != '') {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryPHSocialHistory", 'Y');
                PastHistryCount = PastHistryCount + 1;
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryPHSocialHistory", 'N');
            }

            CreateAutoSaveXml("NoteEMCodeOptions", "HistoryPHTotalCount", PastHistryCount);
            if (PastHistryCount == 1 || PastHistryCount == 2) {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryPHResults", 'P');
            }
            if (PastHistryCount == 3) {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryPHResults", 'C');
            }

            if (AutoSaveXMLDom.find("CustomPsychiatricEvaluationProblems Severity").length == 0) {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryHPISeverity", 'N');
            }
            if (AutoSaveXMLDom.find("CustomPsychiatricEvaluationProblems Duration").length == 0) {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryHPIDuration", 'N');
            }
            if (AutoSaveXMLDom.find("CustomPsychiatricEvaluationProblems Intensity").length == 0) {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryHPIQualityNature", 'N');
            }
            if (AutoSaveXMLDom.find("CustomPsychiatricEvaluationProblems AssociatedSignsSymptoms").length == 0) {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryHPIAssociatedSignsSymptoms", 'N');
            }
            if (AutoSaveXMLDom.find("CustomPsychiatricEvaluationProblems ModifyingFactors").length == 0) {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryHPIModifyingFactors", 'N');
            }

            var severityFound = false;
            var durationFound = false;
            var intensityFound = false
            var timingFound = false;
            var contextFound = false;
            var signFound = false;
            var factorFound = false;
            var newProblem = false;
            var worseningCount = 0;
            var deletedRecord = 'N';
            var HistoryofPresentIllnessCount = 0;
            AutoSaveXMLDom.find("CustomPsychiatricEvaluationProblems").each(function () {
                $(this).children().each(function () {
                    if (this.tagName == "PsychiatricEvaluationProblemId") {
                        deletedRecord = GetColumnValueInXMLNodeByKeyValue('CustomPsychiatricEvaluationProblems', 'PsychiatricEvaluationProblemId', $(this).text(), 'RecordDeleted', AutoSaveXMLDom);
                    }
                    if (deletedRecord != 'Y') {
                        if (this.tagName == "Severity") {
                            if (severityFound == false) {
                                if ($(this).text() != "") {
                                    severityFound = true;
                                    CreateAutoSaveXml("NoteEMCodeOptions", "HistoryHPISeverity", 'Y');
                                    HistoryofPresentIllnessCount = HistoryofPresentIllnessCount + 1
                                }
                                else {
                                    CreateAutoSaveXml("NoteEMCodeOptions", "HistoryHPISeverity", 'N');
                                }
                            }
                        }
                        if (this.tagName == "Duration") {
                            if (durationFound == false) {
                                if ($(this).text() != "") {
                                    durationFound = true;
                                    CreateAutoSaveXml("NoteEMCodeOptions", "HistoryHPIDuration", 'Y');
                                    HistoryofPresentIllnessCount = HistoryofPresentIllnessCount + 1
                                }
                                else {
                                    CreateAutoSaveXml("NoteEMCodeOptions", "HistoryHPIDuration", 'N');
                                }
                            }
                        }
                        if (this.tagName == "Intensity") {
                            if (intensityFound == false) {
                                if ($(this).text() != "") {
                                    intensityFound = true;
                                    CreateAutoSaveXml("NoteEMCodeOptions", "HistoryHPIQualityNature", 'Y');
                                    HistoryofPresentIllnessCount = HistoryofPresentIllnessCount + 1
                                }
                                else {
                                    CreateAutoSaveXml("NoteEMCodeOptions", "HistoryHPIQualityNature", 'N');
                                }
                            }
                        }
                        if (this.tagName == "TimeOfDayMorning" || this.tagName == "TimeOfDayNoon" || this.tagName == "TimeOfDayAfternoon" || this.tagName == "TimeOfDayEvening" || this.tagName == "TimeOfDayNight") {
                            if (timingFound == false) {
                                if ($(this).text() == "Y") {
                                    timingFound = true;
                                    CreateAutoSaveXml("NoteEMCodeOptions", "HistoryHPITimingFrequency", 'Y');
                                    HistoryofPresentIllnessCount = HistoryofPresentIllnessCount + 1
                                }
                                else {
                                    CreateAutoSaveXml("NoteEMCodeOptions", "HistoryHPITimingFrequency", 'N');
                                }
                            }
                        }
                        if (this.tagName == "ContextHome" || this.tagName == "ContextSchool" || this.tagName == "ContextWork" || this.tagName == "ContextCommunity") {
                            if (contextFound == false) {
                                if ($(this).text() == "Y") {
                                    contextFound = true;
                                    CreateAutoSaveXml("NoteEMCodeOptions", "HistoryHPIContextOnset", 'Y');
                                    HistoryofPresentIllnessCount = HistoryofPresentIllnessCount + 1
                                }
                                else {
                                    CreateAutoSaveXml("NoteEMCodeOptions", "HistoryHPIContextOnset", 'N');
                                }
                            }
                        }
                        if (this.tagName == "AssociatedSignsSymptoms") {
                            if (signFound == false) {
                                if ($(this).text() != "") {
                                    signFound = true;
                                    CreateAutoSaveXml("NoteEMCodeOptions", "HistoryHPIAssociatedSignsSymptoms", 'Y');
                                    HistoryofPresentIllnessCount = HistoryofPresentIllnessCount + 1
                                }
                                else {
                                    CreateAutoSaveXml("NoteEMCodeOptions", "HistoryHPIAssociatedSignsSymptoms", 'N');
                                }
                            }
                        }
                        if (this.tagName == "ModifyingFactors") {
                            if (factorFound == false) {
                                if ($(this).text() != "") {
                                    factorFound = true;
                                    CreateAutoSaveXml("NoteEMCodeOptions", "HistoryHPIModifyingFactors", 'Y');
                                    HistoryofPresentIllnessCount = HistoryofPresentIllnessCount + 1
                                }
                                else {
                                    CreateAutoSaveXml("NoteEMCodeOptions", "HistoryHPIModifyingFactors", 'N');
                                }
                            }
                        }
                        if (this.tagName == "ProblemStatus") {
                            if (newProblem == false) {
                                var newstatus = $("[id$=DropDownListCommon_CustomDocumentPsychiatricEvaluations_ProblemStatus]").find('option[text="New"]').val();
                                if ($(this).text() && newstatus) {
                                    if ($(this).text() == newstatus) {
                                        newProblem = true;
                                        CreateAutoSaveXml("NoteEMCodeOptions", "MDMDTONewProblem", 'Y');
                                    }
                                    else {
                                        CreateAutoSaveXml("NoteEMCodeOptions", "MDMDTONewProblem", 'N');
                                    }
                                }
                                else {
                                    CreateAutoSaveXml("NoteEMCodeOptions", "MDMDTONewProblem", 'N');
                                }
                            }
                        }
                        if (this.tagName == "ProblemStatus") {
                            var worseningstatus = $("[id$=DropDownListCommon_CustomDocumentPsychiatricEvaluations_ProblemStatus]").find('option[text="Worsening"]').val();
                            if ($(this).text() && worseningstatus) {
                                if ($(this).text() == worseningstatus) {
                                    worseningCount = worseningCount + 1;
                                }
                            }
                        }
                    }
                });

            });

            CreateAutoSaveXml("NoteEMCodeOptions", "HistoryHPITotalCount", HistoryofPresentIllnessCount);
            if (HistoryofPresentIllnessCount > 0 && HistoryofPresentIllnessCount <= 3) {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryHPIResults", 'B');
            }
            if (HistoryofPresentIllnessCount >= 3) {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryHPIResults", 'E');
            }


            var ReviewOfSymptoms = 0;
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricEvaluations:first ReviewOfSystemPsych").text() == 'Y') {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSPsychiatric", 'Y');
                ReviewOfSymptoms = ReviewOfSymptoms + 1;
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSPsychiatric", 'N');
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricEvaluations:first ReviewOfSystemGI").text() == 'Y') {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSGastrointestinal", 'Y');
                ReviewOfSymptoms = ReviewOfSymptoms + 1;
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSGastrointestinal", 'N');
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricEvaluations:first ReviewOfSystemNeuro").text() == 'Y') {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSNeurological", 'Y');
                ReviewOfSymptoms = ReviewOfSymptoms + 1;
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSNeurological", 'N');
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricEvaluations:first ReviewOfSystemCardioVascular").text() == 'Y') {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSCardiovascular", 'Y');
                ReviewOfSymptoms = ReviewOfSymptoms + 1;
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSCardiovascular", 'N');
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricEvaluations:first ReviewOfSystemGU").text() == 'Y') {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSGenitourinary", 'Y');
                ReviewOfSymptoms = ReviewOfSymptoms + 1;
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSGenitourinary", 'N');
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricEvaluations:first ReviewOfSystemImmune").text() == 'Y') {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSAllergicImmunologic", 'Y');
                ReviewOfSymptoms = ReviewOfSymptoms + 1;
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSAllergicImmunologic", 'N');
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricEvaluations:first ReviewOfSystemHemLymph").text() == 'Y') {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSHematologicLymphatic", 'Y');
                ReviewOfSymptoms = ReviewOfSymptoms + 1;
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSHematologicLymphatic", 'N');
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricEvaluations:first ReviewOfSystemConstitutional").text() == 'Y') {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSConstitutional", 'Y');
                ReviewOfSymptoms = ReviewOfSymptoms + 1;
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSConstitutional", 'N');
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricEvaluations:first ReviewOfSystemIntegumentary").text() == 'Y') {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSSkin", 'Y');
                ReviewOfSymptoms = ReviewOfSymptoms + 1;
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSSkin", 'N');
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricEvaluations:first ReviewOfSystemEyes").text() == 'Y') {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSEye", 'Y');
                ReviewOfSymptoms = ReviewOfSymptoms + 1;
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSEye", 'N');
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricEvaluations:first ReviewOfSystemMusculo").text() == 'Y') {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSMusculoskeletal", 'Y');
                ReviewOfSymptoms = ReviewOfSymptoms + 1;
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSMusculoskeletal", 'N');
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricEvaluations:first ReviewOfSystemEarNoseMouthThroat").text() == 'Y') {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSEarNoseMouthThroat", 'Y');
                ReviewOfSymptoms = ReviewOfSymptoms + 1;
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSEarNoseMouthThroat", 'N');
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricEvaluations:first ReviewOfSystemEndo").text() == 'Y') {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSEndocrine", 'Y');
                ReviewOfSymptoms = ReviewOfSymptoms + 1;
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSEndocrine", 'N');
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricEvaluations:first ReviewOfSystemResp").text() == 'Y') {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSRespiratory", 'Y');
                ReviewOfSymptoms = ReviewOfSymptoms + 1;
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSRespiratory", 'N');
            }

            CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSTotalCount", ReviewOfSymptoms);
            if (ReviewOfSymptoms == 1) {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSResults", 'P');
            }
            if (ReviewOfSymptoms > 1) {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSResults", 'E');
            }
            if (ReviewOfSymptoms > 9) {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSResults", 'C');
            }

            var Examcount = 0;

            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricEvaluations:first AppearanceBehavior").text() == 'Y') {
                Examcount = Examcount + 1;
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricEvaluations:first Speech").text() == 'Y') {
                Examcount = Examcount + 1;
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricEvaluations:first ThoughtProcess").text() == 'Y') {
                Examcount = Examcount + 1;
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricEvaluations:first Associations").text() == 'Y') {
                Examcount = Examcount + 1;
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricEvaluations:first AbnormalPsychoticThoughts").text() == 'Y') {
                Examcount = Examcount + 1;
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricEvaluations:first JudgmentAndInsight").text() == 'Y') {
                Examcount = Examcount + 1;
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricEvaluations:first Orientation").text() == 'Y') {
                Examcount = Examcount + 1;
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricEvaluations:first RecentRemoteMemory").text() == 'Y') {
                Examcount = Examcount + 1;
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricEvaluations:first AttentionConcentration").text() == 'Y') {
                Examcount = Examcount + 1;
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricEvaluations:first Language").text() == 'Y') {
                Examcount = Examcount + 1;
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricEvaluations:first FundOfKnowledge").text() == 'Y') {
                Examcount = Examcount + 1;
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricEvaluations:first MoodAndAffect").text() == 'Y') {
                Examcount = Examcount + 1;
            }
            if (Examcount > 0) {
                CreateAutoSaveXml("NoteEMCodeOptions", "ExamOSPsychiatric", 'Y');
                CreateAutoSaveXml("NoteEMCodeOptions", "ExamOSPsychiatricCount", Examcount);
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "ExamOSPsychiatric", 'N');
                CreateAutoSaveXml("NoteEMCodeOptions", "ExamOSPsychiatricCount", Examcount);
            }

            // MDM
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricEvaluations:first DiagnosticTest").text() == 'Y' || AutoSaveXMLDom.find("CustomDocumentPsychiatricEvaluations:first RadiologyOrder").text() == 'Y') {
                CreateAutoSaveXml("NoteEMCodeOptions", "MDMDRRORadiologyTest", 'Y');
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "MDMDRRORadiologyTest", 'N');
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricEvaluations:first LabOrder").text() == 'Y' || AutoSaveXMLDom.find("CustomDocumentPsychiatricEvaluations:first Labs").text() == 'Y') {
                CreateAutoSaveXml("NoteEMCodeOptions", "MDMDRROClinicalLabs", 'Y');
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "MDMDRROClinicalLabs", 'N');
            }

            if (AutoSaveXMLDom.find("CustomPsychiatricEvaluationProblems PsychiatricEvaluationProblemId").length == 1) {
                CreateAutoSaveXml("NoteEMCodeOptions", "MDMDTOProblems1", 'Y');
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "MDMDTOProblems1", 'N');
            }
            if (AutoSaveXMLDom.find("CustomPsychiatricEvaluationProblems PsychiatricEvaluationProblemId").length == 2) {
                CreateAutoSaveXml("NoteEMCodeOptions", "MDMDTOProblems2", 'Y');
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "MDMDTOProblems2", 'N');
            }
            if (AutoSaveXMLDom.find("CustomPsychiatricEvaluationProblems PsychiatricEvaluationProblemId").length == 3) {
                CreateAutoSaveXml("NoteEMCodeOptions", "MDMDTOProblems3", 'Y');
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "MDMDTOProblems3", 'N');
            }
            if (AutoSaveXMLDom.find("CustomPsychiatricEvaluationProblems PsychiatricEvaluationProblemId").length >= 4) {
                CreateAutoSaveXml("NoteEMCodeOptions", "MDMDTOProblems4Plus", 'Y');
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "MDMDTOProblems4Plus", 'N');
            }
            if (worseningCount == 1) {
                CreateAutoSaveXml("NoteEMCodeOptions", "MDMDTOProblemWorsening1", 'Y');
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "MDMDTOProblemWorsening1", 'N');
            }
            if (worseningCount >= 2) {
                CreateAutoSaveXml("NoteEMCodeOptions", "MDMDTOProblemWorsening2", 'Y');
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "MDMDTOProblemWorsening2", 'N');
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricEvaluations:first OrderedMedications").text() == 'Y') {
                CreateAutoSaveXml("NoteEMCodeOptions", "MDMRCMMMOSMedicationManagement", 'Y');
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "MDMRCMMMOSMedicationManagement", 'N');
            }
            OpenEMCodingPopup = true;
            SavePageData();
        }
    }

}

function OpenCustomPopUpAfterDocumentCallbackComplete() {
    if (OpenEMCodingPopup == true && AutoSaveXMLDom.find("Documents:first InProgressDocumentVersionId").text() && !objectPageResponse.ValidationInfoHTML) {
        openNewpage = false;
        OpenEMCodingPopup = false;
        OpenPage(screenTypeEnum.Detail, 750, 'DocumentVersionId=' + AutoSaveXMLDom.find("Documents:first InProgressDocumentVersionId").text() + '^EffectiveDate=' + EffectiveDate + '^PageFrom=ProgressServieNote', 0, GetRelativePath(), 'T', 'dialogHeight: 550px; dialogWidth: 800px;');
    } else {
        openNewpage = false;
    }
}

function OpenSignPopupForPsychiatricProgressNote() {
    ActionSignOrComplete = true;
    ActionValidateDocumentPageData = false;
    SavePageDataSet(AutoSaveXMLDom[0].xml);
}

function OpenDocumentPage(keyFieldValue, documentId) {
    OpenPage(5763, 29, "keyscreenid=29^TabId=2^keyfieldvalue=" + keyFieldValue + "^DocumentId=" + documentId + "^ClientId=" + ClientID, 2, GetRelativePath());
}

//**********Problems Section Manipulation**************//
appendExistingProblems = (function (dom, problemcount, index) {
    try {
        if (dom.find("PsychiatricEvaluationProblemId").length > 0) {
            var PsychiatricEvaluationProblemId = dom.find("PsychiatricEvaluationProblemId")[index].text;

            var c = 0;
            var currentindex = index;
            start: while (true) {
                c = 0;
                var indexvalue = $.inArray(parseInt(PsychiatricEvaluationProblemId), psychiatricEvaluationProblemIdArray);
                if (indexvalue > -1) {
                    currentindex++;
                    PsychiatricEvaluationProblemId = dom.find("PsychiatricEvaluationProblemId")[currentindex].text;
                }
                else
                    c = 1;
                if (c < 1)
                    continue start;
                break;
            }

            if (PsychiatricEvaluationProblemId) {
                var problemhtml = $('#divProblemTemplate').html().replace(/s8s2s3s/g, PsychiatricEvaluationProblemId);
                $('#divMainProblem').append(problemhtml);
                $('#Span_' + PsychiatricEvaluationProblemId + '_ProblemNumber').html(problemcount);
                SetFieldValue(PsychiatricEvaluationProblemId, dom);
                var indexvalue = $.inArray(parseInt(PsychiatricEvaluationProblemId), psychiatricEvaluationProblemIdArray);
                if (indexvalue == -1) {
                    psychiatricEvaluationProblemIdArray.push(parseInt(PsychiatricEvaluationProblemId));
                    bindFocusEventHistory('table_' + PsychiatricEvaluationProblemId + '_Problem');
                }
            }
        }
        else {
            $('[section=AfterProblem]').show();
        }

        if (psychiatricEvaluationProblemIdArray.length == dom.find("PsychiatricEvaluationProblemId").length) {
            $('[section=AfterProblem]').show();
            $('[id$=History]').unbind('scroll');
        }
    }
    catch (ex) { }
});

bindHistoryTabScrollEvent = (function () {
    try {
        var objScroll = $('[id$=History]');
        if (objScroll.length > 0) {
            scrollElem = $(objScroll)[0];

            $(scrollElem).unbind('keyup');
            $(scrollElem).keyup(function (e) {
                if ($('#trAfterProblem').css('display') == 'none') {
                    $(scrollElem).unbind('scroll');
                    $(scrollElem).scroll(function () {
                        if ($(this)[0].scrollHeight == $(this).height() + $(this).scrollTop()) {
                            appendNextExistingProblems();
                        }
                    });
                }
                else {
                    $(this).unbind('keyup');
                    $(this).unbind('scroll');
                }
            });

            $(scrollElem).unbind('scroll');
            $(scrollElem).scroll(function () {
                if ($(this)[0].scrollHeight == $(this).height() + $(this).scrollTop()) {
                    appendNextExistingProblems();
                }
            });
        }
    }
    catch (ex) { }
});

appendNewProblem = (function () {
    try {
        var _PsychiatricEvaluationProblemId = 0;
        AutoSaveXMLDom.find("CustomPsychiatricEvaluationProblems").each(function () {
            $(this).children().each(function () {
                if (this.tagName == "PsychiatricEvaluationProblemId") {
                    if (parseInt($(this).text()) < 0 && _PsychiatricEvaluationProblemId <= 0 && _PsychiatricEvaluationProblemId > parseInt($(this).text())) {
                        _PsychiatricEvaluationProblemId = parseInt($(this).text());
                    }
                }
            });
        });

        if (_PsychiatricEvaluationProblemId == 0)
            _PsychiatricEvaluationProblemId = -1
        else
            _PsychiatricEvaluationProblemId = _PsychiatricEvaluationProblemId + (-1);

        var _psychiatricevaluationproblemid;
        var _createdby;
        var _createddate;
        var _modifiedby;
        var _modifieddate;
        var _documentversionid;

        var _xmltable = AutoSaveXMLDom[0].childNodes[0].appendChild(AutoSaveXMLDom[0].createElement('CustomPsychiatricEvaluationProblems')); //Add Table
        _psychiatricevaluationproblemid = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('PsychiatricEvaluationProblemId')); //Add Column
        _psychiatricevaluationproblemid.text = _PsychiatricEvaluationProblemId;

        _createdby = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('CreatedBy')); //Add Column
        _createdby.text = objectPageResponse.LoggedInUserCode;

        _createddate = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('CreatedDate')); //Add Column
        _createddate.text = ISODateString(new Date());

        _modifiedby = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('ModifiedBy')); //Add Column
        _modifiedby.text = objectPageResponse.LoggedInUserCode;

        _modifieddate = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('ModifiedDate')); //Add Column
        _modifieddate.text = ISODateString(new Date());

        _documentversionid = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('DocumentVersionId')); //Add Column
        _documentversionid.text = AutoSaveXMLDom.find("CustomDocumentPsychiatricEvaluations:first DocumentVersionId").text();
        AddToUnsavedTables("CustomPsychiatricEvaluationProblems");
        CreateUnsavedInstanceOnDatasetChange();

        var problemhtml = $('#divProblemTemplate').html().replace(/s8s2s3s/g, _PsychiatricEvaluationProblemId);
        $('#divMainProblem').append(problemhtml);
        $('#Span_' + _PsychiatricEvaluationProblemId + '_ProblemNumber').html($('[section=spannumber]').length - 1);
    }
    catch (ex) {

    }
});

updateProblem = (function (primarykeyvalue, obj, tablename, columnname, mode) {
    try {
        var ctrlvalue = '';
        if (mode == 'checkbox') {
            if ($(obj).attr('checked')) {
                ctrlvalue = 'Y';
                if (columnname == 'ContextOther') {
                    $('#TextBox_CustomPsychiatricEvaluationProblems_' + primarykeyvalue + '_ContextOtherText').show();
                }
            }
            else {
                ctrlvalue = 'N';
                if (columnname == 'ContextOther') {
                    $('#TextBox_CustomPsychiatricEvaluationProblems_' + primarykeyvalue + '_ContextOtherText').hide();
                    $('#TextBox_CustomPsychiatricEvaluationProblems_' + primarykeyvalue + '_ContextOtherText').val('');
                    SetColumnValueInXMLNodeByKeyValue(tablename, "PsychiatricEvaluationProblemId", primarykeyvalue, "ContextOtherText", "", AutoSaveXMLDom[0]);
                }
            }
        }
        else {
            ctrlvalue = $(obj).val();
        }

        if (ctrlvalue == undefined || ctrlvalue == '')
            ctrlvalue = '';

        SetColumnValueInXMLNodeByKeyValue(tablename, "PsychiatricEvaluationProblemId", primarykeyvalue, columnname, ctrlvalue, AutoSaveXMLDom[0]);
        SetColumnValueInXMLNodeByKeyValue("CustomPsychiatricEvaluationProblems", "PsychiatricEvaluationProblemId", primarykeyvalue, "ModifiedBy", objectPageResponse.LoggedInUserCode, AutoSaveXMLDom[0]);
        SetColumnValueInXMLNodeByKeyValue("CustomPsychiatricEvaluationProblems", "PsychiatricEvaluationProblemId", primarykeyvalue, "ModifiedDate", ISODateString(new Date()), AutoSaveXMLDom[0]);

        if (columnname == 'AssociatedSignsSymptoms') {
            var selectedtext = $(obj).find("option:selected").text();
            if (selectedtext) {
                if (selectedtext == 'Other') {
                    $('#TextBox_CustomPsychiatricEvaluationProblems_' + primarykeyvalue + '_AssociatedSignsSymptomsOtherText').show();
                }
                else {
                    $('#TextBox_CustomPsychiatricEvaluationProblems_' + primarykeyvalue + '_AssociatedSignsSymptomsOtherText').hide();
                    $('#TextBox_CustomPsychiatricEvaluationProblems_' + primarykeyvalue + '_AssociatedSignsSymptomsOtherText').val('');
                    SetColumnValueInXMLNodeByKeyValue(tablename, "PsychiatricEvaluationProblemId", primarykeyvalue, "AssociatedSignsSymptomsOtherText", "", AutoSaveXMLDom[0]);
                }
            }
            else {
                $('#TextBox_CustomPsychiatricEvaluationProblems_' + primarykeyvalue + '_AssociatedSignsSymptomsOtherText').hide();
                $('#TextBox_CustomPsychiatricEvaluationProblems_' + primarykeyvalue + '_AssociatedSignsSymptomsOtherText').val('');
                SetColumnValueInXMLNodeByKeyValue(tablename, "PsychiatricEvaluationProblemId", primarykeyvalue, "AssociatedSignsSymptomsOtherText", "", AutoSaveXMLDom[0]);
            }
        }
        CreateUnsavedInstanceOnDatasetChange();
    }
    catch (ex) {

    }
});

deleteProblem = (function (primarykeyvalue) {
    try {
        removeProblem(primarykeyvalue);
        $('#table_' + primarykeyvalue + '_Problem').remove();
        var sectionobj = $('[section=spannumber]');
        for (var j = 0; j < sectionobj.length; j++) {
            if (j > 0) {
                $('[section=spannumber]')[j].innerHTML = '';
                $('[section=spannumber]')[j].innerHTML = j;
            }
        }


    }
    catch (ex) { }
});

removeProblem = (function (primarykeyvalue) {
    try {
        SetColumnValueInXMLNodeByKeyValue("CustomPsychiatricEvaluationProblems", "PsychiatricEvaluationProblemId", primarykeyvalue, "RecordDeleted", "Y", AutoSaveXMLDom[0]);
        SetColumnValueInXMLNodeByKeyValue("CustomPsychiatricEvaluationProblems", "PsychiatricEvaluationProblemId", primarykeyvalue, "DeletedBy", objectPageResponse.LoggedInUserCode, AutoSaveXMLDom[0]);
        SetColumnValueInXMLNodeByKeyValue("CustomPsychiatricEvaluationProblems", "PsychiatricEvaluationProblemId", primarykeyvalue, "DeletedDate", ISODateString(new Date()), AutoSaveXMLDom[0]);
        SetColumnValueInXMLNodeByKeyValue("CustomPsychiatricEvaluationProblems", "PsychiatricEvaluationProblemId", primarykeyvalue, "ModifiedBy", objectPageResponse.LoggedInUserCode, AutoSaveXMLDom[0]);
        SetColumnValueInXMLNodeByKeyValue("CustomPsychiatricEvaluationProblems", "PsychiatricEvaluationProblemId", primarykeyvalue, "ModifiedDate", ISODateString(new Date()), AutoSaveXMLDom[0]);
        CreateUnsavedInstanceOnDatasetChange();
    }
    catch (ex) {

    }
});

function SetFieldValue(primarykeyvalue, dom) {
    try {
        var controlCollection = $("select, input[type=checkbox], textarea, input[type=text]", $("table[id$='table_" + primarykeyvalue + "_Problem']")[0]);
        if (controlCollection) {
            controlCollection.each(
             function () {
                 var Names = $(this).attr('id').split('_');
                 var ColumnName = Names[3];
                 var TableName = Names[1];
                 var ControlType = this.type;
                 if (ControlType.indexOf('select') != -1) {
                     ColumnName = Names[Names.length - 1];
                     TableName = Names[Names.length - 3];
                 }
                 var control = $(this);

                 if (TableName == "" || ColumnName == "") {
                     return;
                 }
                 var newxml = dom.find("CustomPsychiatricEvaluationProblems PsychiatricEvaluationProblemId[text=" + primarykeyvalue + "]").parent();
                 var value = GetFielValueFromXMLDom($.xmlDOM(newxml[0].xml), TableName, ColumnName);
                 if (value != null) {
                     if (ControlType == "checkbox") {
                         if (value == "Y") {
                             control.attr('checked', true);
                         }
                         else {
                             control.attr('checked', false);
                         }

                         if (ColumnName == 'ContextOther') {
                             if (value == 'Y') {
                                 $('#TextBox_CustomPsychiatricEvaluationProblems_' + primarykeyvalue + '_ContextOtherText').show();
                             }
                             else {
                                 $('#TextBox_CustomPsychiatricEvaluationProblems_' + primarykeyvalue + '_ContextOtherText').hide();
                             }
                         }
                     }
                     else {
                         control.val(value);
                         if (ColumnName == 'AssociatedSignsSymptoms') {
                             var selectedtext = control.find("option:selected").text();
                             if (selectedtext) {
                                 if (selectedtext == 'Other') {
                                     $('#TextBox_CustomPsychiatricEvaluationProblems_' + primarykeyvalue + '_AssociatedSignsSymptomsOtherText').show();
                                 }
                                 else {
                                     $('#TextBox_CustomPsychiatricEvaluationProblems_' + primarykeyvalue + '_AssociatedSignsSymptomsOtherText').hide();
                                 }
                             }
                             else {
                                 $('#TextBox_CustomPsychiatricEvaluationProblems_' + primarykeyvalue + '_AssociatedSignsSymptomsOtherText').hide();
                             }
                         }
                     }
                 }
             }
         );
        }
    }
    catch (err) {

    }
}

ISODateString = (function (dateIn) {
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
});

bindFocusEventHistory = (function (controlname) {
    try {
        if ($('#trAfterProblem').css('display') == 'none') {
            var controlCollection = $("select, input[type=checkbox], textarea, input[type=text]", $("[id$=" + controlname + "]")[0]);
            if (controlCollection) {
                controlCollection.each(
                 function () {
                     $(this).unbind('focus');
                     $(this).focus(function () {
                         if ($('#trAfterProblem').css('display') == 'none') {
                             appendNextExistingProblems();

                             $("[id$=History]").unbind('scroll');
                             $("[id$=History]").scroll(function () {
                                 if ($(this)[0].scrollHeight == $(this).height() + $(this).scrollTop()) {
                                     appendNextExistingProblems();
                                 }
                             });
                         }
                         else {
                             $("[id$=History]").unbind('keyup');
                             $("[id$=History]").unbind('scroll');
                             var controlCollection = $("select, input[type=checkbox], textarea, input[type=text]", $("[id$=History]")[0]);
                             if (controlCollection) {
                                 controlCollection.each(
                                  function () {
                                      $(this).unbind('focus');
                                  }
                              );
                             }
                         }
                     });
                 }
             );
            }
        }
        else {
            $("[id$=History]").unbind('keyup');
            $("[id$=History]").unbind('scroll');
            var controlCollection = $("select, input[type=checkbox], textarea, input[type=text]", $("[id$=History]")[0]);
            if (controlCollection) {
                controlCollection.each(
                 function () {
                     $(this).unbind('focus');
                 }
             );
            }
        }
    }
    catch (err) {

    }
});

appendNextExistingProblems = (function () {
    var index = $('[section=spannumber]').length - 1;
    if (index < AutoSaveXMLDom.find("PsychiatricEvaluationProblemId").length) {
        appendExistingProblems(AutoSaveXMLDom, index + 1, index);
    }
    else {
        $('[section=AfterProblem]').show();
        $("[id$=History]").unbind('scroll');
    }
});