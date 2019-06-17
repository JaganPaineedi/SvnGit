var tabobject = null;

var SCPsychiatricService = function () {
    var constructor = function () {
    }
    return constructor
}();
var tabName = '';
var isTabClicked = false;
var tab_index = '';


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
function RefreshDLATabPage(domObject) {

}
function LoadTabPageCallBackComplete(tabClickSender, title, tabUserControlName, selectedTabId, functionname) {

}

function SetScreenSpecificValues(dom, action) {
    try {
        if (typeof tabobject == 'undefined' || tabobject == undefined || tabobject == null || tabobject == "") {
        }
        else {
            var historytabobject = tabobject._selectedIndex;
            if (historytabobject >= 0) {
                selectedTabText = tabobject.get_selectedTab().get_text();

                if (historytabobject == 0 && selectedTabText == 'General') {
                    if ($('#divPreviousDiagnosis').length > 0)
                    {
                        SCPsychiatricService.BindPreviousDiagnosis();
                    }
                    if ($('#divAppointment').length > 0)
                    {
                        SCPsychiatricService.BindNextAppointment();
                    }
                }
                if (historytabobject == 1 && selectedTabText == 'History') {
                    if ($('#divProblemTemplate').length > 0) {
                        if (dom.find("PsychiatricServiceNoteProblemId").length < 10) {
                            $('#table_history_problem').css('display', '');
                            $('#table_problem_loading').css('display', 'none');
                        }
                        else {
                            $('#table_history_problem').css('display', 'none');
                            $('#table_problem_loading').css('display', '');
                        }
                        intialBindProblems();
                    }
                }
                if (historytabobject == 2 && selectedTabText == 'Exam') {
                    if ($('#divVitals').length > 0)
                        loadVitals();
                    if ($('#TextBox_CustomDocumentPsychiatricServiceNoteExams_GeneralAppearanceOtherText').length > 0 && $('#CheckBox_CustomDocumentPsychiatricServiceNoteExams_GeneralAppearanceOther').length > 0) {
                        var GeneralAppearanceOther = 'N';
                        GeneralAppearanceOther = dom.find("CustomDocumentPsychiatricServiceNoteExams:first GeneralAppearanceOther").text();
                        if (!GeneralAppearanceOther)
                            GeneralAppearanceOther = 'N';
                        if (GeneralAppearanceOther == 'Y')
                            $('#TextBox_CustomDocumentPsychiatricServiceNoteExams_GeneralAppearanceOtherText').show();
                        else
                            $('#TextBox_CustomDocumentPsychiatricServiceNoteExams_GeneralAppearanceOtherText').hide();
                    }
                        
                }
                if (historytabobject == 3 && selectedTabText == 'Medical Decision Making') {
                    SCPsychiatricService.BindMedications();
                    SCPsychiatricService.BindProblemsStatus(dom);
                    EnableDisableDropdown(false);
                    $("#CheckBox_CustomDocumentPsychiatricServiceNoteMDMs_Labs").bind('click', function() {
                        EnableDisableDropdown(true);
                    });
                }
                if (selectedTabText == 'Diagnosis') {
                    if (typeof SetDiagnosisIAndIIHiddenOrderField == 'function') {
                        SetDiagnosisIAndIIHiddenOrderField(dom);
                    }
                }
            }
            var myDate = new Date();
            $('[id$=divClientInformationNotesLink] > table tr').each(function() {

                $(this).find('td').each(function() {
                    var obj = $(this).find('span').next();
                    if ($(obj).length > 0) {
                        $.post(GetRelativePath() + "CommonUserControls/AjaxCallForInformationIconToolTip.aspx?ClientInformationNotes=Y&StoredProcedureName=" + $(obj).attr('TooltipSP') + "&Date=" + myDate, function(data) {
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
        }
    }
    catch (err) {
        LogClientSideException(err, 'SetScreenSpecificValues');
    }
}
function RefreshTabPageContents(tabControl, selectedTabTitle) {
 selectedTabTitle = $.trim(selectedTabTitle);
 try {
     if (selectedTabTitle == 'Medical Decision Making') {
         SCPsychiatricService.BindProblemsStatus(AutoSaveXMLDom);
         }
    }
    catch (err) {
    }
}
function AddEventHandlers() {
    var btnOpenCalendar = $('input[id$=Button_CustomDocumentPsychiatricServiceNoteGenerals_OpenCalendar]');
    if (btnOpenCalendar.length > 0) {
        btnOpenCalendar.bind("click", function() {
            if (Dirty == "True" || UnsavedChangeId > 0) {
                ShowMsgBox('Please save the existing unsaved record for this screen prior to opening the Calendar', 'Confirmation', MessageBoxButton.OK, MessageBoxIcon.Information);
                return false;
            }
            else {
                OpenCalendar();
            }
        });
    }
    var buttonPlaceLab = $("input[type=button][id$=Button_OpenFlowSheet]");
    buttonPlaceLab.bind('click', function () {
        var date = (new Date()).format("MM/dd/yyyy  hh:mm:ss tt");
        OpenPage(5761, 716, 'HealthDataTemplateId=110' + '^HealthRecordDate=' + date + '^ClienID=' + ClientID, 2, GetRelativePath());
    });
    $("[id*=imgSort]").css("display", "none");
    $("[id$=imgsort]").css("display", "block");


    var checkBoxGeneralAppearanceOther = $("[id$=CheckBox_CustomDocumentPsychiatricServiceNoteExams_GeneralAppearanceOther]");
    if (checkBoxGeneralAppearanceOther.length > 0) {
        checkBoxGeneralAppearanceOther.unbind('click');
        checkBoxGeneralAppearanceOther.bind('click', function() {
            if ($(this).attr('checked')) {
                $('#TextBox_CustomDocumentPsychiatricServiceNoteExams_GeneralAppearanceOtherText').show();
            }
            else {
                CreateAutoSaveXml("CustomDocumentPsychiatricServiceNoteExams", "GeneralAppearanceOtherText", "");
                $('#TextBox_CustomDocumentPsychiatricServiceNoteExams_GeneralAppearanceOtherText').val('');
                $('#TextBox_CustomDocumentPsychiatricServiceNoteExams_GeneralAppearanceOtherText').hide();
            }
        });
    }


    var buttonOpenSmartCareRX = $("input[type=button][id$=Button_CustomDocumentPsychiatricServiceNoteMDMs_OpenSmartCareRX]");
    if (buttonOpenSmartCareRX.length > 0) {
        buttonOpenSmartCareRX.bind('click', function() {
            OpenPage(5766, 105, 'DocumentNavigationName=Medications', 2, GetRelativePath());
            //OpenPage(5766, 105, 'DocumentNavigationName=Medications^OpenScreen=AddMedication', 2, GetRelativePath());
        });
    }
    var buttonViewMedicationHistoryReport = $("input[type=button][id$=Button_CustomDocumentPsychiatricServiceNoteMDMs_ViewMedicationHistoryReport]");
    if (buttonViewMedicationHistoryReport.length > 0) {
        buttonViewMedicationHistoryReport.bind('click', function() {
            OpenPage(5766, 105, 'DocumentNavigationName=Medications^OpenScreen=MedicationReport', 2, GetRelativePath());
        });
    }

    var buttonPlaceOrder = $("input[type=button][id$=Button_CustomDocumentPsychiatricServiceNoteMDMs_PlaceOrder]");
    if (buttonPlaceOrder.length > 0) {
        buttonPlaceOrder.bind('click', function() {
        OpenPage(5763, 772, 'DocumentNavigationName=Client Order', 2, GetRelativePath(), pageActionEnum.New);
        });
    }
}
SCPsychiatricService.BindNextAppointment = function()
{
 try {
        var ServiceId = GetFielValueFromXMLDom(AutoSaveXMLDom, "Services", "ServiceId");
        $.ajax({
            type: "POST",
            url: GetRelativePath() + "Custom/PsychiatricService/WebPages/PsychiatricServiceNote.aspx",
            data: "action=GetNextAppointment&ServiceId=" + ServiceId,
            success: function(result) {
                if (result != '') {
                    SCPsychiatricService.CreateAppointmentTable(result);
                }
            }
        })
    }
    catch (ex) { }
}
SCPsychiatricService.CreateAppointmentTable = function(result)
{
    var tableHeader = "<table width='100%'><thead><tr>";
    var tableBody = "<tbody>";
    var endTable = "</table>";
    tableHeader += "<th align='left' width='100%'></th>";
    tableHeader += "</tr></thead>";
    var resultNextAppointment = $.xmlDOM(result);
    $(resultNextAppointment).find('Appointments').each(function() {
        tableBody += "<tr>";
        tableBody += "<td align='left'>" + $(this).find('Appointment').text() + "</td>";
        tableBody += "</tr>";
    });
    tableBody += "</tbody>";
 
     $("[id$=divAppointment]").html((tableHeader + tableBody + endTable));
}
SCPsychiatricService.BindPreviousDiagnosis = function() {
    try {
        $.ajax({
            type: "POST",
            url: GetRelativePath() + "Custom/PsychiatricService/WebPages/PsychiatricServiceNote.aspx",
            data: "action=GetPreviousDiagnosis",
            success: function(result) {
                if (result != '') {
                    SCPsychiatricService.CreateDiagnosisTable(result);
                }
            }
        })
    }
    catch (ex) { }
}
SCPsychiatricService.CreateDiagnosisTable = function(result) {
    var tableHeader = "<table width='100%'><thead><tr>";
    var tableBody = "<tbody>";
    var endTable = "</table>";
    tableHeader += "<tr>";
    tableHeader += "<th align='left' colspan='5' style='padding-top:5px;'>Diagnosis List</th>";
    tableHeader += "</tr>";
    tableHeader += "<tr>";
    tableHeader += "<th align='left' width='10%'>Order</th>";
    tableHeader += "<th align='left' width='20%'>DSM V/ICD 10</th>";
    tableHeader += "<th align='left' width='20%'>DSM IV/ICD 9</th>";
    tableHeader += "<th align='left' width='20%'>Description</th>";
    tableHeader += "<th align='left' width='15%'>Type</th>";
    tableHeader += "<th align='left' width='15%'>Severity</th>";
    tableHeader += "</tr></thead>";
    var result1 = $.xmlDOM(result);
    $(result1).find('DocumentDiagnosisCodes').each(function() {
        tableBody += "<tr>";
        tableBody += "<td align='left'>" + $(this).find('DiagnosisOrder').text() + "</td>";
        tableBody += "<td align='left'>" + $(this).find('ICD10Code').text() + "</td>";
        tableBody += "<td align='left'>" + $(this).find('ICD9Code').text() + "</td>";
        var dsmDesciption = $(this).find('DSMDescription').text();
        if (dsmDesciption.length > 30)
            dsmDesciption = "<span style='display:block;width:100px;word-wrap:break-word;' title='" + dsmDesciption + "'>" + dsmDesciption.substring(0, 30) + "..." + "</span>";
        else
            dsmDesciption = "<span style='display:block;width:100px;word-wrap:break-word;'>" + dsmDesciption + "</span>";

        tableBody += "<td align='left'>" + dsmDesciption + "</td>";
        tableBody += "<td align='left'>" + $(this).find('DiagnosisType').text() + "</td>";
        tableBody += "<td align='left'>" + $(this).find('Severity').text() + "</td>";
        tableBody += "</tr>";
    });
    var tableHeaderAxisIII = "<tr>";
    tableHeaderAxisIII += "<td align='left' colspan='5' style='padding-top:5px;'>Psychosocial, Environmental, and Other Factors</td>";
    tableHeaderAxisIII += "</tr>";
    tableHeaderAxisIII += "<tr>";
    tableHeaderAxisIII += "<td align='left' width='55%' colspan='5' style='padding-top:3px;padding-bottom:2px;'>Source</td>";
    tableHeaderAxisIII += "</tr>";
    var result2 = $.xmlDOM(result);
    var tableBodyAxisIII = "";
    $(result2).find('DocumentDiagnosisFactors').each(function() {
        tableBodyAxisIII += "<tr>";
        tableBodyAxisIII += "<td align='left'  colspan='5'>" + $(this).find('Factors').text() + "</td>";
        tableBodyAxisIII += "</tr>";
    });

    var tableHeaderAxisIV = "<tr>";
    tableHeaderAxisIV += "<td align='left' colspan='5' style='padding-top:5px;' >Axis IV</td>";
    tableHeaderAxisIV += "</tr>";
    var result3 = $.xmlDOM(result);
    var tableBodyAxisIV = "";
    $(result3).find('DiagnosesIV').each(function() {
        tableBodyAxisIV += "<tr>";
        //below Changes by made Rahul Aneja ref: task#2129 in Thresholds bugs & features ,show all For Axis IV - single line with comma separate values for what is checked ,
        var specification = $(this).find('Specification').text();
        if (specification.substring(specification.length - 2, specification.length - 1) === ",")
            specification = specification.substring(0, specification.length - 2);

        tableBodyAxisIV += "<td align='left' colspan='5'>" + specification + "</td>";
        //End Chages
        tableBodyAxisIV += "</tr>";
    });

    var tableHeaderAxisV = "<tr>";
    tableHeaderAxisV += "<td align='left'colspan='5'  style='padding-top:5px;'>Level of Functioning Score</td>";
    tableHeaderAxisV += "</tr>";
    var result4 = $.xmlDOM(result);
    var tableBodyAxisV = "";
    $(result4).find('DocumentDiagnosis').each(function() {
        tableBodyAxisV += "<tr>";
        tableBodyAxisV += "<td align='left' colspan='2'>GAF Score: " + $(this).find('GAFScore').text() + "</td>";
        tableBodyAxisV += "<td align='left' colspan='1'>WHODAS Score: " + $(this).find('WHODASScore').text() + "</td>";
        tableBodyAxisV += "<td align='left' colspan='2'>CAFAS Score: " + $(this).find('CAFASScore').text() + "</td>";
        tableBodyAxisV += "</tr>";
    });

    //tableBody += "</tbody>";

    var effectiveDate = $.xmlDOM(result).find('EffectiveDate').text();

    var trEffictiveDate = "<table width='100%'><tr><td align='left' width='20%'>Effective Date: " + effectiveDate + "</td></tr></table>";

    var DiagnosisHTML = trEffictiveDate + tableHeader + tableBody + tableHeaderAxisIII + tableBodyAxisIII + tableHeaderAxisV + tableBodyAxisV + "</tbody>" + endTable;
    $("[id$=divPreviousDiagnosis]").html(DiagnosisHTML);
}
loadVitals = (function () {
    try {
        $.ajax({
            type: "POST",
            url: GetRelativePath() + "Custom/PsychiatricService/WebPages/PsychiatricServiceNote.aspx",
            data: "action=LoadVitals",
            success: function (result) {
                if (result != '') {
                    var divVital = $("[id$=divVitals]");
                    var VitalsHtml = result.split("#8#2#3$");
                    divVital.html(createTable(VitalsHtml));                    
                    //$('#TextBox_CustomDocumentPsychiatricServiceNoteExams_VitalsPrevious').val(VitalsHtml[0]);
                    //$('#TextBox_CustomDocumentPsychiatricServiceNoteExams_VitalsCurrent').val(VitalsHtml[1]);
                    
                }

            }
        })
    }
    catch (ex) { }
});
function createTable(vitalhtml) {
    try {        
        if (vitalhtml.length>0) {
            var tableHeader = "<table width='750px' cellpadding='0' cellspacing='0'>";
            var tableBody = "";
            var endTable = "</table>";
            tableBody += "<tr valign='top'>";
            tableBody += "<td align='center' width='200px' style='padding-bottom:2px;padding-left:5px'> <u><span>Current vitals </span>" + vitalhtml[2] + "</u></td>";
            tableBody += "<td align='center' width='200px' style='padding-bottom:2px;padding-left:5px'><u><span>Previous vitals </span>" + vitalhtml[3] + "</u></td>";
            tableBody += "</tr>";
            tableBody += "<tr valign='top'>";
            tableBody += "<td align='center' width='200px' style='padding-bottom:2px;padding-left:5px'></td>";
            tableBody += "<td align='center' width='200px' style='padding-bottom:2px;padding-left:5px'></td>";
            tableBody += "</tr>";
            tableBody += "<tr valign='top'>";
            tableBody += "<td align='left' width='400px' style='padding-bottom:2px;padding-left:5px'>" + vitalhtml[1] + "</td>";
            tableBody += "<td align='left' width='400px' style='padding-bottom:2px;padding-left:5px'>" + vitalhtml[0] + "</td>";
            tableBody += "</tr>";            
            //$('#Span_CustomDocumentPsychiatricServiceNoteExams_CurreentVitalDate').text(vitalhtml[2]);
            //$('#Span_CustomDocumentPsychiatricServiceNoteExams_PreviousVitalDate').text(vitalhtml[3]);
            return tableHeader + tableBody + endTable;
        }

    }
    catch (err) {
        LogClientSideException(err, 'LoadVitals: createTable');
    }
}
intialBindProblems = (function () {
    try {
        $.ajax({
            type: "POST",
            url: GetRelativePath() + "Custom/PsychiatricService/WebPages/PsychiatricServiceNote.aspx",
            data: "action=getProblemSpan",
            success: function (result) {
                if (result != '') {
                    $('#divMainProblem').html(result);
                    var count = 0;
                    AutoSaveXMLDom.find("PsychiatricServiceNoteProblemId").each(function () {
                        $.ajax({
                            type: "POST",
                            url: GetRelativePath() + "Custom/PsychiatricService/WebPages/PsychiatricServiceNote.aspx",
                            data: "action=bindProblems&PsychiatricServiceNoteProblemId=" + $(this).text(),
                            success: function (result) {
                                count++;
                                if (result != '') {
                                    var problemhtml = $('#divProblemTemplate').html().replace(/s8s2s3s/g, result);
                                    $('#span_' + result + '_problem').before(problemhtml);
                                    var countvalue = $('#span_' + result + '_problem').attr('problemcount');
                                    $('#Span_' + result + '_ProblemNumber').html(countvalue);
                                    SetFieldValue(result);
                                }

                                if (count == AutoSaveXMLDom.find("PsychiatricServiceNoteProblemId").length) {
                                    $('#table_history_problem').css('display', '');
                                    $('#table_problem_loading').css('display', 'none');
                                }
                            }
                        });
                    });

                    if (AutoSaveXMLDom.find("PsychiatricServiceNoteProblemId").length == 0) {
                        $('#table_history_problem').css('display', '');
                        $('#table_problem_loading').css('display', 'none');
                    }
                }
                else {
                    $('#table_history_problem').css('display', '');
                    $('#table_problem_loading').css('display', 'none');
                }
            }
        });
    }
    catch (ex) { }
});

appendNewProblem = (function (mode) {
    try {
        var _PsychiatricServiceNoteProblemId = 0;
        AutoSaveXMLDom.find("CustomPsychiatricServiceNoteProblems").each(function () {
            $(this).children().each(function () {
                if (this.tagName == "PsychiatricServiceNoteProblemId") {
                    if (parseInt($(this).text()) < 0 && _PsychiatricServiceNoteProblemId <= 0 && _PsychiatricServiceNoteProblemId > parseInt($(this).text())) {
                        _PsychiatricServiceNoteProblemId = parseInt($(this).text());
                    }
                }
            });
        });

        if (_PsychiatricServiceNoteProblemId == 0)
            _PsychiatricServiceNoteProblemId = -1
        else
            _PsychiatricServiceNoteProblemId = _PsychiatricServiceNoteProblemId + (-1);

        var _psychiatricservicenoteproblemid;
        var _createdby;
        var _createddate;
        var _modifiedby;
        var _modifieddate;
        var _documentversionid;

        var _xmltable = AutoSaveXMLDom[0].childNodes[0].appendChild(AutoSaveXMLDom[0].createElement('CustomPsychiatricServiceNoteProblems')); //Add Table
        _psychiatricservicenoteproblemid = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('PsychiatricServiceNoteProblemId')); //Add Column
        _psychiatricservicenoteproblemid.text = _PsychiatricServiceNoteProblemId;

        _createdby = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('CreatedBy')); //Add Column
        _createdby.text = objectPageResponse.LoggedInUserCode;

        _createddate = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('CreatedDate')); //Add Column
        _createddate.text = ISODateString(new Date());

        _modifiedby = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('ModifiedBy')); //Add Column
        _modifiedby.text = objectPageResponse.LoggedInUserCode;

        _modifieddate = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('ModifiedDate')); //Add Column
        _modifieddate.text = ISODateString(new Date());

        _documentversionid = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('DocumentVersionId')); //Add Column
        _documentversionid.text = AutoSaveXMLDom.find("CustomPsychiatricServiceNoteProblems:first DocumentVersionId").text();
        AddToUnsavedTables("CustomPsychiatricServiceNoteProblems");
        CreateUnsavedInstanceOnDatasetChange();

        var problemhtml = $('#divProblemTemplate').html().replace(/s8s2s3s/g, _PsychiatricServiceNoteProblemId);
        $('#divMainProblem').append(problemhtml);
        $('#Span_' + _PsychiatricServiceNoteProblemId + '_ProblemNumber').html($('[section=spannumber]').length - 1);
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
                    $('#TextBox_CustomPsychiatricServiceNoteProblems_' + primarykeyvalue + '_ContextOtherText').show();
                }
            }
            else {
                ctrlvalue = 'N';
                if (columnname == 'ContextOther') {
                    $('#TextBox_CustomPsychiatricServiceNoteProblems_' + primarykeyvalue + '_ContextOtherText').hide();
                    $('#TextBox_CustomPsychiatricServiceNoteProblems_' + primarykeyvalue + '_ContextOtherText').val('');
                    SetColumnValueInXMLNodeByKeyValue(tablename, "PsychiatricServiceNoteProblemId", primarykeyvalue, "ContextOtherText", "", AutoSaveXMLDom[0]);
                }
            }
        }
        else {
            ctrlvalue = $(obj).val();
        }

        if (ctrlvalue == undefined || ctrlvalue == '')
            ctrlvalue = '';

        SetColumnValueInXMLNodeByKeyValue(tablename, "PsychiatricServiceNoteProblemId", primarykeyvalue, columnname, ctrlvalue, AutoSaveXMLDom[0]);
        SetColumnValueInXMLNodeByKeyValue("CustomPsychiatricServiceNoteProblems", "PsychiatricServiceNoteProblemId", primarykeyvalue, "ModifiedBy", objectPageResponse.LoggedInUserCode, AutoSaveXMLDom[0]);
        SetColumnValueInXMLNodeByKeyValue("CustomPsychiatricServiceNoteProblems", "PsychiatricServiceNoteProblemId", primarykeyvalue, "ModifiedDate", ISODateString(new Date()), AutoSaveXMLDom[0]);

        if (columnname == 'AssociatedSignsSymptoms') {
            var selectedtext = $(obj).find("option:selected").text();
            if (selectedtext) {
                if (selectedtext == 'Other') {
                    $('#TextBox_CustomPsychiatricServiceNoteProblems_' + primarykeyvalue + '_AssociatedSignsSymptomsOtherText').show();
                }
                else {
                    $('#TextBox_CustomPsychiatricServiceNoteProblems_' + primarykeyvalue + '_AssociatedSignsSymptomsOtherText').hide();
                    $('#TextBox_CustomPsychiatricServiceNoteProblems_' + primarykeyvalue + '_AssociatedSignsSymptomsOtherText').val('');
                    SetColumnValueInXMLNodeByKeyValue(tablename, "PsychiatricServiceNoteProblemId", primarykeyvalue, "AssociatedSignsSymptomsOtherText", "", AutoSaveXMLDom[0]);
                }
            }
            else {
                $('#TextBox_CustomPsychiatricServiceNoteProblems_' + primarykeyvalue + '_AssociatedSignsSymptomsOtherText').hide();
                $('#TextBox_CustomPsychiatricServiceNoteProblems_' + primarykeyvalue + '_AssociatedSignsSymptomsOtherText').val('');
                SetColumnValueInXMLNodeByKeyValue(tablename, "PsychiatricServiceNoteProblemId", primarykeyvalue, "AssociatedSignsSymptomsOtherText", "", AutoSaveXMLDom[0]);
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
        SetColumnValueInXMLNodeByKeyValue("CustomPsychiatricServiceNoteProblems", "PsychiatricServiceNoteProblemId", primarykeyvalue, "RecordDeleted", "Y", AutoSaveXMLDom[0]);
        SetColumnValueInXMLNodeByKeyValue("CustomPsychiatricServiceNoteProblems", "PsychiatricServiceNoteProblemId", primarykeyvalue, "DeletedBy", objectPageResponse.LoggedInUserCode, AutoSaveXMLDom[0]);
        SetColumnValueInXMLNodeByKeyValue("CustomPsychiatricServiceNoteProblems", "PsychiatricServiceNoteProblemId", primarykeyvalue, "DeletedDate", ISODateString(new Date()), AutoSaveXMLDom[0]);
        SetColumnValueInXMLNodeByKeyValue("CustomPsychiatricServiceNoteProblems", "PsychiatricServiceNoteProblemId", primarykeyvalue, "ModifiedBy", objectPageResponse.LoggedInUserCode, AutoSaveXMLDom[0]);
        SetColumnValueInXMLNodeByKeyValue("CustomPsychiatricServiceNoteProblems", "PsychiatricServiceNoteProblemId", primarykeyvalue, "ModifiedDate", ISODateString(new Date()), AutoSaveXMLDom[0]);
        CreateUnsavedInstanceOnDatasetChange();
    }
    catch (ex) {

    }
});

function SetFieldValue(primarykeyvalue) {
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
                 var newxml = AutoSaveXMLDom.find("CustomPsychiatricServiceNoteProblems PsychiatricServiceNoteProblemId[text=" + primarykeyvalue + "]").parent();
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
                                 $('#TextBox_CustomPsychiatricServiceNoteProblems_' + primarykeyvalue + '_ContextOtherText').show();
                             }
                             else {
                                 $('#TextBox_CustomPsychiatricServiceNoteProblems_' + primarykeyvalue + '_ContextOtherText').hide();
                             }
                         }
                     }
                     else {
                         control.val(value);
                         if (ColumnName == 'AssociatedSignsSymptoms') {
                             var selectedtext = control.find("option:selected").text();
                             if (selectedtext) {
                                 if (selectedtext == 'Other') {
                                     $('#TextBox_CustomPsychiatricServiceNoteProblems_' + primarykeyvalue + '_AssociatedSignsSymptomsOtherText').show();
                                 }
                                 else {
                                     $('#TextBox_CustomPsychiatricServiceNoteProblems_' + primarykeyvalue + '_AssociatedSignsSymptomsOtherText').hide();
                                 }
                             }
                             else {
                                 $('#TextBox_CustomPsychiatricServiceNoteProblems_' + primarykeyvalue + '_AssociatedSignsSymptomsOtherText').hide();
                             }
                         }
                     }
                 }
             }
         );
        }
    }
    catch (err) {
        alert(err);

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
    var filter = 'sortColumn=' + sortColumn + '^CustomAction=' + sort + '^AssociatedDocumentCodeId=' + 22300;
    parent.OpenPage(5763, 22301, filter, null, GetRelativePath(), 'T', null, pageActionEnum.CustomAjaxCall, null, null, null);

}


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
        LogClientSideException(err, 'PsychNotes - OpenCalendar'); //Code added by Devinder 
    }
}
SCPsychiatricService.BindMedications = function() {

try {
    var DateOfService = GetFielValueFromXMLDom(AutoSaveXMLDom, "Services", "DateOfService");
    if (DateOfService != null)
        DateOfService = ChangeDateFormat(DateOfService);
        $.ajax({
            type: "POST",
            url: GetRelativePath() + "Custom/PsychiatricService/WebPages/PsychiatricServiceNote.aspx",
            data: "action=GetMedications&DateOfService=" + DateOfService,
            success: function(result) {
                if (result != '') {
                    SCPsychiatricService.CreateMedicationsTables(result);
                }
            }
        })
    }
    catch (ex) { }
}

SCPsychiatricService.CreateMedicationsTables = function(result) {

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

}

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
        $(resultClientMedications).find('CurrentMedications').each(function() {
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
        $(resultClientMedications).find('DiscontinuedMedications').each(function() {
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
        $(resultClientMedications).find('SelfRepotedMedications').each(function() {
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
SCPsychiatricService.BindProblemsStatus = function(domObject) {
  
    var XmlProblems;
    var ProblemsLength;
    var ControlHtml = "";
	 if (AutoSaveXMLDom != undefined || AutoSaveXMLDom != "")
        domObject = AutoSaveXMLDom;
    else if (domObject != undefined && domObject != null && domObject != "")
        domObject = domObject;
    XmlProblems = domObject[0].childNodes[0].selectNodes("CustomPsychiatricServiceNoteProblems")
    ProblemsLength = domObject[0].childNodes[0].selectNodes("CustomPsychiatricServiceNoteProblems").length;
    ControlHtml += "<table border='0' cellspacing='0' cellpadding='0' width='100%'   style='padding-left:0px'>";

    var k = 0;
    for (var i = 0; i < ProblemsLength; i++) {
        var recorddeletedTEXT = 'N';
        if (XmlProblems[i].selectNodes("RecordDeleted")[0] != null) {
            recorddeletedTEXT = XmlProblems[i].selectNodes("RecordDeleted")[0].text;
        }
        if (recorddeletedTEXT != 'Y') {
            k++;
            var ProblemNumber = "Problem " + (k).toString() + ":";
                   
            if (XmlProblems[i].selectNodes("ProblemText")[0] != null) {
                var ProblemText = XmlProblems[i].selectNodes("ProblemText")[0].text;
            }
            if (XmlProblems[i].selectNodes("PsychiatricServiceNoteProblemId")[0] != null) {
                var ProblemId = XmlProblems[i].selectNodes("PsychiatricServiceNoteProblemId")[0].text;
            }
            var ProblemStatusTEXT = '';
            if (XmlProblems[i].selectNodes("ProblemStatus")[0] != null) {
                ProblemStatusTEXT = XmlProblems[i].selectNodes("ProblemStatus")[0].text;
            }
            var ProblemDropdownHtml = "";
            var ProblemsDropdown = $("select[id$=DropDownListCommon_CustomDocumentPsychiatricServiceNoteMDMs_ProblemStatus]").val(ProblemStatusTEXT);
            if (ProblemsDropdown.length > 0) {
                ProblemDropdownHtml = ProblemsDropdown.html();
            }
            ControlHtml += "<tr style='height: 8px;'></tr>";
            ControlHtml += "<tr>";
            ControlHtml += "<td style='width:60%'>";
            ControlHtml += ProblemNumber + ProblemText;
            ControlHtml += "</td>"
            ControlHtml += "<td style='width:7%'>";
            ControlHtml += "Status";
            ControlHtml += "</td>"
            ControlHtml += "<td style='width:33%'>";
            ControlHtml += "<select id='DropDownList_CustomDocumentPsychiatricServiceNoteMDMs_" + ProblemId + "_ProblemStatus' class='form_dropdown'  bindautosaveevents='False' ProblemId = " + ProblemId + " onchange='UpdateProblemStatus(this)';   innerHTML = " + ProblemDropdownHtml + " >"
            ControlHtml += "</select>"
            ControlHtml += "</td>"
            ControlHtml += "</tr>";
        }
    }
    ControlHtml += "</table>"

    $("#ProblemsContainer").html(ControlHtml)

}
function UpdateProblemStatus(ctrl) {
    var nameArray = ctrl.id.split("_");
    var tablename = nameArray[1];
    var primaryKeyColumnName = 'PsychiatricServiceNoteProblemId';
    var columnname = nameArray[3];
    var primaryKey = nameArray[2];
    var ctrlValue = GetControlValue(ctrl, undefined);
    var currentXMLDom = $("CustomPsychiatricServiceNoteProblems>PsychiatricServiceNoteProblemId[text=" + primaryKey + "]", AutoSaveXMLDom[0]).parent();
    CustomSetColumnValueInXMLNodeByKeyValue("CustomPsychiatricServiceNoteProblems", primaryKeyColumnName, primaryKey, columnname, ctrlValue, currentXMLDom);

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


function CallCustomNoteAfterDocumentCallbackComplete() {
    if (openNewpage == true && openNewpage != undefined) {
        EffectiveDate = $('#TextBox_DocumentInformation_EffectiveDate').val();
        var documentstatus = ValidationBeforeUpdate();
        var PastHistryCount = 0;
        if (documentstatus) {

            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricServiceNoteHistory:first MedicalHistoryReviewedNoChanges").text() == 'Y' || AutoSaveXMLDom.find("CustomDocumentPsychiatricServiceNoteHistory:first MedicalHistoryReviewedWithChanges").text() == 'Y') {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryPHMedicalHistory", 'Y');
                PastHistryCount = PastHistryCount + 1;
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryPHMedicalHistory", 'N');
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricServiceNoteHistory:first FamilyHistoryReviewedNoChanges").text() == 'Y' || AutoSaveXMLDom.find("CustomDocumentPsychiatricServiceNoteHistory:first FamilyHistoryReviewedWithChanges").text() == 'Y') {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryPHFamilyHistory", 'Y');
                PastHistryCount = PastHistryCount + 1;
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryPHFamilyHistory", 'N');
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricServiceNoteHistory:first SocialHistoryReviewedNoChanges").text() == 'Y' || AutoSaveXMLDom.find("CustomDocumentPsychiatricServiceNoteHistory:first SocialHistoryReviewedWithChanges").text() == 'Y') {
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


            if (AutoSaveXMLDom.find("CustomPsychiatricServiceNoteProblems Severity").length == 0) {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryHPISeverity", 'N');
            }
            if (AutoSaveXMLDom.find("CustomPsychiatricServiceNoteProblems Duration").length == 0) {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryHPIDuration", 'N');
            }
            if (AutoSaveXMLDom.find("CustomPsychiatricServiceNoteProblems Intensity").length == 0) {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryHPIQualityNature", 'N');
            }
            if (AutoSaveXMLDom.find("CustomPsychiatricServiceNoteProblems AssociatedSignsSymptoms").length == 0) {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryHPIAssociatedSignsSymptoms", 'N');
            }
            if (AutoSaveXMLDom.find("CustomPsychiatricServiceNoteProblems ModifyingFactors").length == 0) {
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
            AutoSaveXMLDom.find("CustomPsychiatricServiceNoteProblems").each(function() {
                $(this).children().each(function() {
                if (this.tagName == "PsychiatricServiceNoteProblemId") {
                    deletedRecord = GetColumnValueInXMLNodeByKeyValue('CustomPsychiatricServiceNoteProblems', 'PsychiatricServiceNoteProblemId', $(this).text(), 'RecordDeleted', AutoSaveXMLDom);
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
                                var newstatus = $("[id$=DropDownListCommon_CustomDocumentPsychiatricServiceNoteMDMs_ProblemStatus]").find('option[text="New"]').val();
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
                            var worseningstatus = $("[id$=DropDownListCommon_CustomDocumentPsychiatricServiceNoteMDMs_ProblemStatus]").find('option[text="Worsening"]').val();
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
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricServiceNoteHistory:first ReviewOfSystemPsych").text() == 'Y') {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSPsychiatric", 'Y');
                ReviewOfSymptoms = ReviewOfSymptoms + 1;
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSPsychiatric", 'N');
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricServiceNoteHistory:first ReviewOfSystemGI").text() == 'Y') {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSGastrointestinal", 'Y');
                ReviewOfSymptoms = ReviewOfSymptoms + 1;
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSGastrointestinal", 'N');
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricServiceNoteHistory:first ReviewOfSystemNeuro").text() == 'Y') {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSNeurological", 'Y');
                ReviewOfSymptoms = ReviewOfSymptoms + 1;
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSNeurological", 'N');
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricServiceNoteHistory:first ReviewOfSystemCardioVascular").text() == 'Y') {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSCardiovascular", 'Y');
                ReviewOfSymptoms = ReviewOfSymptoms + 1;
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSCardiovascular", 'N');
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricServiceNoteHistory:first ReviewOfSystemGU").text() == 'Y') {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSGenitourinary", 'Y');
                ReviewOfSymptoms = ReviewOfSymptoms + 1;
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSGenitourinary", 'N');
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricServiceNoteHistory:first ReviewOfSystemImmune").text() == 'Y') {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSAllergicImmunologic", 'Y');
                ReviewOfSymptoms = ReviewOfSymptoms + 1;
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSAllergicImmunologic", 'N');
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricServiceNoteHistory:first ReviewOfSystemHemLymph").text() == 'Y') {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSHematologicLymphatic", 'Y');
                ReviewOfSymptoms = ReviewOfSymptoms + 1;
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSHematologicLymphatic", 'N');
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricServiceNoteHistory:first ReviewOfSystemConstitutional").text() == 'Y') {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSConstitutional", 'Y');
                ReviewOfSymptoms = ReviewOfSymptoms + 1;
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSConstitutional", 'N');
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricServiceNoteHistory:first ReviewOfSystemIntegumentary").text() == 'Y') {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSSkin", 'Y');
                ReviewOfSymptoms = ReviewOfSymptoms + 1;
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSSkin", 'N');
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricServiceNoteHistory:first ReviewOfSystemEyes").text() == 'Y') {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSEye", 'Y');
                ReviewOfSymptoms = ReviewOfSymptoms + 1;
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSEye", 'N');
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricServiceNoteHistory:first ReviewOfSystemMusculo").text() == 'Y') {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSMusculoskeletal", 'Y');
                ReviewOfSymptoms = ReviewOfSymptoms + 1;
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSMusculoskeletal", 'N');
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricServiceNoteHistory:first ReviewOfSystemEarNoseMouthThroat").text() == 'Y') {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSEarNoseMouthThroat", 'Y');
                ReviewOfSymptoms = ReviewOfSymptoms + 1;
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSEarNoseMouthThroat", 'N');
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricServiceNoteHistory:first ReviewOfSystemEndo").text() == 'Y') {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSEndocrine", 'Y');
                ReviewOfSymptoms = ReviewOfSymptoms + 1;
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSEndocrine", 'N');
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricServiceNoteHistory:first ReviewOfSystemResp").text() == 'Y') {
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

            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricServiceNoteExams:first AppearanceBehavior").text() == 'Y') {
                Examcount = Examcount + 1;
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricServiceNoteExams:first Speech").text() == 'Y') {
                Examcount = Examcount + 1;
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricServiceNoteExams:first ThoughtProcess").text() == 'Y') {
                Examcount = Examcount + 1;
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricServiceNoteExams:first Associations").text() == 'Y') {
                Examcount = Examcount + 1;
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricServiceNoteExams:first AbnormalPsychoticThoughts").text() == 'Y') {
                Examcount = Examcount + 1;
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricServiceNoteExams:first JudgmentAndInsight").text() == 'Y') {
                Examcount = Examcount + 1;
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricServiceNoteExams:first Orientation").text() == 'Y') {
                Examcount = Examcount + 1;
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricServiceNoteExams:first RecentRemoteMemory").text() == 'Y') {
                Examcount = Examcount + 1;
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricServiceNoteExams:first AttentionConcentration").text() == 'Y') {
                Examcount = Examcount + 1;
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricServiceNoteExams:first Language").text() == 'Y') {
                Examcount = Examcount + 1;
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricServiceNoteExams:first FundOfKnowledge").text() == 'Y') {
                Examcount = Examcount + 1;
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricServiceNoteExams:first MoodAndAffect").text() == 'Y') {
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
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricServiceNoteMDMs:first DiagnosticTest").text() == 'Y' || AutoSaveXMLDom.find("CustomDocumentPsychiatricServiceNoteMDMs:first RadiologyOrder").text() == 'Y') {
                CreateAutoSaveXml("NoteEMCodeOptions", "MDMDRRORadiologyTest", 'Y');
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "MDMDRRORadiologyTest", 'N');
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricServiceNoteMDMs:first LabOrder").text() == 'Y' || AutoSaveXMLDom.find("CustomDocumentPsychiatricServiceNoteMDMs:first Labs").text() == 'Y') {
                CreateAutoSaveXml("NoteEMCodeOptions", "MDMDRROClinicalLabs", 'Y');
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "MDMDRROClinicalLabs", 'N');
            }

            if (AutoSaveXMLDom.find("CustomPsychiatricServiceNoteProblems PsychiatricServiceNoteProblemId").length == 1) {
                CreateAutoSaveXml("NoteEMCodeOptions", "MDMDTOProblems1", 'Y');
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "MDMDTOProblems1", 'N');
            }
            if (AutoSaveXMLDom.find("CustomPsychiatricServiceNoteProblems PsychiatricServiceNoteProblemId").length == 2) {
                CreateAutoSaveXml("NoteEMCodeOptions", "MDMDTOProblems2", 'Y');
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "MDMDTOProblems2", 'N');
            }
            if (AutoSaveXMLDom.find("CustomPsychiatricServiceNoteProblems PsychiatricServiceNoteProblemId").length == 3) {
                CreateAutoSaveXml("NoteEMCodeOptions", "MDMDTOProblems3", 'Y');
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "MDMDTOProblems3", 'N');
            }
            if (AutoSaveXMLDom.find("CustomPsychiatricServiceNoteProblems PsychiatricServiceNoteProblemId").length >= 4) {
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
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricServiceNoteMDMs:first OrderedMedications").text() == 'Y') {
                CreateAutoSaveXml("NoteEMCodeOptions", "MDMRCMMMOSMedicationManagement", 'Y');
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "MDMRCMMMOSMedicationManagement", 'N');
            }
            OpenEMCodingPopup = true;
            SavePageData();
        }
        //OpenPage(screenTypeEnum.Detail, 750, 'DocumentVersionId=' + AutoSaveXMLDom.find("Documents:first InProgressDocumentVersionId").text() + '^EffectiveDate=' + EffectiveDate + '^PageFrom=ProgressServieNote', 0, GetRelativePath(), 'T', 'dialogHeight: 550px; dialogWidth: 800px;');
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

function EnableDisableDropdown(clicked) {
    var $LabsDropdown = $("select[id$=DropDownList_CustomDocumentPsychiatricServiceNoteMDMs_LabsSelected]");
    if ($("#CheckBox_CustomDocumentPsychiatricServiceNoteMDMs_Labs").is(':checked')) {
        $LabsDropdown.removeAttr("disabled");
    }
    else {
        $LabsDropdown.attr("disabled", "disabled");
        $LabsDropdown.val('');
        if (clicked == true) {
            CreateAutoSaveXml("CustomDocumentPsychiatricServiceNoteMDMs", "LabsSelected", "");
        }
    }
}