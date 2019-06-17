
var thisObject = "";

//Function is used to Clear the Health History controls.
//Author Priya

function ClearHealthHistory() {
    try {
        $("#TextBox_CustomMedicationHistory_MedicationName").val('');
        $("#TextBox_CustomMedicationHistory_DosageFrequency").val('');
        $("#TextBox_CustomMedicationHistory_PrescribingPhysician").val('');

        // Added by Jitender Kumar Kamboj on 21 July 2010 in ref task # 857
        ClearTable('TableChildControl_CustomMedicationHistory', 'zxTableChildControl_CustomMedicationHistory_ButtonInsert', false);
        $('#HiddenField_CustomMedicationHistory_MedicationHistoryId').val('');

    }
    catch (err) {
        LogClientSideException(err, 'PreScreen'); //Code added by Devinder 
    }
}
//Function is used to Clear the Substance Use Controls
//Author Priya
function ClearSubstance() {
    try {
        $("#TextBox_CustomSUSubstances_SubstanceName").val('');
        $("#TextBox_CustomSUSubstances_Amount").val('');
        $("#TextBox_CustomSUSubstances_Frequency").val('');

        // Added by Jitender Kumar Kamboj on 21 July 2010 in ref task # 857
        ClearTable('TableChildControl_CustomSUSubstances', 'TableChildControl_CustomSUSubstances_ButtonInsert', false);
        $('#HiddenField_CustomSUSubstances_SUSubstanceId').val('');

    }
    catch (err) {
        LogClientSideException(err, 'PreScreen'); //Code added by Devinder 
    }
}

///Function : This Function is used to enable DropDown
///Created Date: July 20, 2010
///Author: Jitender Kumar Kamboj
function SetScreenSpecificValues(dom, action) {
    EnableDisableDropDown();
    //Commented by Vikas Kasyhup- 22/Oct/2011- Ref Task No. 359 to remove Phone Number format from contact field
    //    if ($("#TextBox_CustomAcuteServicesPrescreens_SummaryAlternativeAgencyContactNumber").length > 0) {
    //        $("#TextBox_CustomAcuteServicesPrescreens_SummaryAlternativeAgencyContactNumber").attr("DataType", "PhoneNumber");
    //    }
    if ($("[id$=TextBox_DiagnosesIAndII_DiagnosisOrder]").length > 0) {
        var Initialvalue = $("[id$=TextBox_DiagnosesIAndII_DiagnosisOrder]").val();

        $("#HiddenFieldOrder").val(Initialvalue);

        /* IsDivICDCodesContainVale If else conidtion Added by Mahesh S */
        var IsDivICDCodesContainVale = $('div[id$=divICDCodes] img[id*=ContactButonDelete]').length;
        if (IsDivICDCodesContainVale > 0) {
            $('div[id$=divICDCodes]').show();
        }
        else {
            $('div[id$=divICDCodes]').hide();
        }
    }
    //Addded by sourabh with ref to task#357 to retain diagnosis order
    SetDiagnosisIAndIIHiddenOrderField(dom);
    //end here
    PrescreenReady();
}


//Function is used to Enable DropDown
//Author Priya
function EnableDisableDropDown() {
    try {
        if ($("#RadioButton_CustomAcuteServicesPrescreens_CMHStatus_O").attr('checked') == 'checked' || $("#RadioButton_CustomAcuteServicesPrescreens_CMHStatus_O").attr("checked") == true) {    //Added by Jitender on July 20, 2010
            //if ($("input[Id$=RadioButton_CustomAcuteServicesPrescreens_CMHStatus_O]")[0].checked == true) {      //Commented by Jitender on July 20, 2010
            $("select[Id*=DropDownList_CustomAcuteServicesPrescreens_CMHStatusPrimaryClinician]").removeAttr("disabled");
        }
        else {
            $("select[Id*=DropDownList_CustomAcuteServicesPrescreens_CMHStatusPrimaryClinician]").attr("disabled", "disabled");
        }



    }
    catch (err) {
        LogClientSideException(err); //Code added by Devinder 
    }
}
//To Validate Date Field In General Tab
function handleDateForVenturePrescreen(fromDate, toDate) {
    var _SrartDtRange = new Date("1/Jan/1753");
    var _EndDtRange = new Date("31/Dec/9999");

    var _FromDate = $("#" + fromDate).val();
    if (_FromDate == "") {
        ShowHideErrorMessage("Please enter correct From Date.", 'true');
        $("#" + fromDate).focus();
        return;
    }
    var _ToDate = $("#" + toDate).val();

    if (_ToDate == "") {
        ShowHideErrorMessage("Please enter correct To Date.", 'true');
        $("#" + toDate).focus();
        return;
    }

    if (!Date.parse(_FromDate)) {
        ShowHideErrorMessage("Please enter correct From Date.", 'true');
        $("#" + fromDate).val('');
        $("#" + fromDate).focus();
        return;
    }

    if (!Date.parse(_ToDate)) {
        ShowHideErrorMessage("Please enter correct To Date.", 'true');
        $("#" + toDate).val('');
        $("#" + toDate).focus();
        return;
    }

    /*  if (_SrartDtRange < Date.parse(_FromDate) || _EndDtRange > Date.parse(_FromDate)) {
    ShowHideErrorMessage("Please enter correct From Date.", 'true');
    $("#" + fromDate).val('');
    $("#" + fromDate).focus();
    }

    if (_SrartDtRange < Date.parse(_ToDate) || _EndDtRange > Date.parse(_ToDate)) {
    ShowHideErrorMessage("Please enter correct To Date.", 'true');
    $("#" + toDate).val('');
    $("#" + toDate).focus();
    }*/

    if (Date.parse(_FromDate) <= Date.parse(_ToDate)) {
        GetListPageWithFilters();
        ShowHideErrorMessage("", 'false');

    }
    else {
        ShowHideErrorMessage("From Date should be less than To Date.", 'true');
        $("#" + toDate).focus();
        return;
    }

}


//Description:Format Time fields and convert it into 12 Hours Format on General Tab
//Author:Jitender
//CreatedOn:22-March-2010
function FormatTime(obj) {
    try {
        if (LTrim(RTrim(obj.value)) != "") {
            //var resolveUrl = $("[id$=HiddenFieldRelativePath]");
            var myDate = new Date();
            var time = '';
            var timeofday = '';
            var arrayMonFromDate = null;
            var arrayMonFromDateColonPresence = null;

            if (obj.value.length > 8) {
                $("[id$=" + obj.id + "]").val("");
                return;
            }

            var arrayMonFromDate = obj.value.split(' ');

            if (arrayMonFromDate.length > 1) {
                timeofday = "AM";

                if ((arrayMonFromDate[1].toLowerCase() == "p") || (arrayMonFromDate[1].toLowerCase() == "pm"))
                    timeofday = "PM";
                else if ((arrayMonFromDate[1].toLowerCase() == "a") || (arrayMonFromDate[1].toLowerCase() == "am"))
                    timeofday = "AM";

                time = arrayMonFromDate[0];
                arrayMonFromDateColonPresence = time.split(':');


                if (arrayMonFromDateColonPresence.length > 0) {
                    if ((arrayMonFromDateColonPresence[0] == '') || (isNaN(arrayMonFromDateColonPresence[0]) == true)) {
                        obj.value = '';
                    }
                    //                    else if ((arrayMonFromDateColonPresence[1] == '') || (isNaN(arrayMonFromDateColonPresence[1]) == true)) {
                    //                        obj.value = '';
                    //                    }
                    else if (parseInt(arrayMonFromDateColonPresence[0]) > 23) {
                        obj.value = '';
                    }
                    else if ((arrayMonFromDateColonPresence.length > 1) && ((isNaN(arrayMonFromDateColonPresence[1]) == true) || (parseInt(arrayMonFromDateColonPresence[1]) > 59))) {
                        obj.value = '';
                    }
                    else {
                        if (arrayMonFromDateColonPresence.length >= 1) {
                            if ((isNaN(arrayMonFromDateColonPresence[0]) == false) && (isNaN(arrayMonFromDateColonPresence[1]) == false)) {
                                if ((parseInt(arrayMonFromDateColonPresence[0]) > 12) && (arrayMonFromDateColonPresence[1] == "")) {
                                    obj.value = parseInt(arrayMonFromDateColonPresence[0]) - 12;
                                    timeofday = "PM";
                                    obj.value = obj.value + ":00" + " " + timeofday;
                                    //obj.value = obj.value + ":" + arrayMonFromDateColonPresence[1] + " " + timeofday;
                                }
                                else if (parseInt(arrayMonFromDateColonPresence[0]) > 12 && (arrayMonFromDateColonPresence[1] == 0)) {
                                    obj.value = parseInt(arrayMonFromDateColonPresence[0]) - 12;
                                    timeofday = "PM";
                                    obj.value = obj.value + ":00" + " " + timeofday;
                                    //obj.value = obj.value + ":" + arrayMonFromDateColonPresence[1] + " " + timeofday;
                                }
                                //                                else if (parseInt(arrayMonFromDateColonPresence[0]) > 12 && (parseInt(arrayMonFromDateColonPresence[1]) < 10)) {
                                //                                    obj.value = parseInt(arrayMonFromDateColonPresence[0]) - 12;
                                //                                    timeofday = "PM";
                                //                                    obj.value = obj.value + ":" + "0" + arrayMonFromDateColonPresence[1] + " " + timeofday;
                                //                                    //obj.value = obj.value + ":" + arrayMonFromDateColonPresence[1] + " " + timeofday;
                                //                                }
                                else if (parseInt(arrayMonFromDateColonPresence[0]) > 12) {
                                    obj.value = parseInt(arrayMonFromDateColonPresence[0]) - 12;
                                    timeofday = "PM";
                                    obj.value = obj.value + ":" + arrayMonFromDateColonPresence[1] + " " + timeofday;
                                    //obj.value = obj.value + ":" + arrayMonFromDateColonPresence[1] + " " + timeofday;
                                }
                                else if ((arrayMonFromDateColonPresence[1] == "") || (isNaN(arrayMonFromDateColonPresence[1]) == true) || (arrayMonFromDateColonPresence[1] == "0")) {
                                    obj.value = arrayMonFromDateColonPresence[0] + ":00" + " " + timeofday;
                                }
                                //obj.value = arrayMonFromDateColonPresence[0] + ":" + arrayMonFromDate[1] + " " + timeofday;
                                //                                else if (parseInt(arrayMonFromDateColonPresence[1]) < 10) {
                                //                                    obj.value = arrayMonFromDateColonPresence[0] + ":" + "0" + arrayMonFromDateColonPresence[1] + " " + timeofday;
                                //                                }
                                else {
                                    obj.value = arrayMonFromDateColonPresence[0] + ":" + arrayMonFromDateColonPresence[1] + " " + timeofday;
                                }
                            }
                            else if (parseInt(arrayMonFromDateColonPresence[0]) > 12) {
                                obj.value = parseInt(arrayMonFromDateColonPresence[0]) - 12;
                                timeofday = "PM";
                                obj.value = obj.value + ":00" + " " + timeofday;
                                //obj.value = obj.value + ":" + arrayMonFromDateColonPresence[1] + " " + timeofday;
                            }
                            else
                                obj.value = arrayMonFromDateColonPresence[0] + ":00" + " " + timeofday;
                        }
                    }
                }
            }

            else {
                var datePattern = /am|AM|pm|PM|a|A|p|P/;
                var matchArray = obj.value.match(datePattern);
                timeofday = "AM";


                if (matchArray != null) {

                    if (matchArray.length > 0) {
                        if ((matchArray[0].toLowerCase() == "a") || (matchArray[0].toLowerCase() == "am"))
                            timeofday = "AM";
                        else if ((matchArray[0].toLowerCase() == "p") || (matchArray[0].toLowerCase() == "pm"))
                            timeofday = "PM";
                        time = obj.value.replace(matchArray[0], "");
                    }
                    else {
                        time = obj.value;
                    }
                }
                else { time = obj.value; }



                arrayMonFromDateColonPresence = time.split(':');
                if ((arrayMonFromDateColonPresence[0] == '') || (isNaN(arrayMonFromDateColonPresence[0]) == true)) {
                    obj.value = '';
                }
                else if (parseInt(arrayMonFromDateColonPresence[0]) > 23) {
                    obj.value = '';
                }
                else if ((arrayMonFromDateColonPresence.length > 1) && ((isNaN(arrayMonFromDateColonPresence[1]) == true) || parseInt(arrayMonFromDateColonPresence[1]) > 59)) {
                    obj.value = '';
                }
                else if (parseInt(arrayMonFromDateColonPresence[0]) > 12) {
                    obj.value = parseInt(arrayMonFromDateColonPresence[0]) - 12;

                    timeofday = "PM";
                    if (arrayMonFromDateColonPresence.length == 1)
                        obj.value = obj.value + ":00" + " " + timeofday;
                    else if (arrayMonFromDateColonPresence.length > 1)
                        obj.value = obj.value + ":" + arrayMonFromDateColonPresence[1] + " " + timeofday;

                }
                else {
                    if (arrayMonFromDateColonPresence.length > 1) {
                        if ((isNaN(arrayMonFromDateColonPresence[0]) == false) && (isNaN(arrayMonFromDateColonPresence[1]) == false)) {
                            if (arrayMonFromDateColonPresence[1] == 0) {
                                obj.value = arrayMonFromDateColonPresence[0] + ":00" + " " + timeofday;
                            }

                            //                            else if (arrayMonFromDateColonPresence[1] < 10) {
                            //                                obj.value = arrayMonFromDateColonPresence[0] + ":" + "0" + arrayMonFromDateColonPresence[1] + " " + timeofday;
                            //                            }
                            else {
                                obj.value = arrayMonFromDateColonPresence[0] + ":" + arrayMonFromDateColonPresence[1] + " " + timeofday;
                            }
                        }
                    }
                    else
                        obj.value = arrayMonFromDateColonPresence[0] + ":00" + " " + timeofday;
                }
            }
        }
        //GetDateTimeDifference();
        //FormateTimeForPrescreenGeneral();
        //if (obj.value != "") {
        if (obj.id == "TextBoxTime_CustomAcuteServicesPrescreens_ClientAvailableTimeForScreen" || obj.id == "TextBoxTime_CustomAcuteServicesPrescreens_DispositionTime") {
            dateDiff();
        }
        // }
        return obj;
    }

    catch (err) {
        LogClientSideException(err, 'PreScreen');
    }
}

//Description: To calculate Date, Time difference on General Tab
//Author:Jitender
//CreatedOn:26-March-2010
function dateDiff() {
    try {
        var availableDate = new Date();
        var dispositionDate = new Date();
        var diff = new Date();

        var cObjectAvailableDate = $("#TextBox_CustomAcuteServicesPrescreens_ClientAvailableTimeForScreen");
        var cObjectDispositionDate = $("#TextBox_CustomAcuteServicesPrescreens_DispositionTime");
        ValidateDate(cObjectAvailableDate[0]);
        var firstdate = cObjectAvailableDate[0].value;
        ValidateDate(cObjectDispositionDate[0]);
        var seconddate = cObjectDispositionDate[0].value;


        //var firstdate = $("#TextBox_CustomAcuteServicesPrescreens_ClientAvailableTimeForScreen").val();
        var firsttime = $("#TextBoxTime_CustomAcuteServicesPrescreens_ClientAvailableTimeForScreen").val();
        //var seconddate = $("#TextBox_CustomAcuteServicesPrescreens_DispositionTime").val();
        var secondtime = $("#TextBoxTime_CustomAcuteServicesPrescreens_DispositionTime").val();

        //if (firstdate && isValidTime(firsttime)) { // Validates first date
        // below if condition added by Rakesh-II Task 394 Dated 21 Mar,2012 
        var availableDateTime = '';
        var availableTime = '';
        if (firsttime != '' || isNaN(firsttime)) {
            availableDateTime = new Date(firstdate + " " + firsttime);
            availableTime = availableDate.setTime(availableDateTime.getTime());
        }
        //}
        //else return false; // otherwise exits

        //if (seconddate && isValidTime(secondtime)) { // Validates second date
        // below if condition added by Rakesh-II Task 394 Dated 21 Mar,2012
        var dispositionDateTime = '';
        var dispositionTime = '';
        if (secondtime != '' || isNaN(secondtime)) {
            dispositionDateTime = new Date(seconddate + " " + secondtime);
            dispositionTime = dispositionDate.setTime(dispositionDateTime.getTime());
        }
        //}
        //else return false; // otherwise exits

        // sets difference date to difference of first date and second date
        if (dispositionTime != '' && availableTime != '') {
            if (dispositionTime < availableTime) {
                //alert("Disposition Time should be greater than Prescreen Time.");
                ShowHideErrorMessage("Disposition Time should be greater than Prescreen Time.", 'true');
                $("#TextBox_CustomAcuteServicesPrescreens_ElapsedHours").val('').change();
                $("#TextBox_CustomAcuteServicesPrescreens_ElapsedMinutes").val('').change();
                return false;
            }
        }
        else {
            $("#TextBox_CustomAcuteServicesPrescreens_ElapsedHours").val('').change();
            $("#TextBox_CustomAcuteServicesPrescreens_ElapsedMinutes").val('').change();
            return false;
        }

        diff.setTime(Math.abs(availableDate.getTime() - dispositionDate.getTime()));
        var timediff = diff.getTime();
        var hours = Math.floor(timediff / (1000 * 60 * 60));
        timediff -= hours * (1000 * 60 * 60);
        var mins = Math.floor(timediff / (1000 * 60));
        timediff -= mins * (1000 * 60);

        //secs = Math.floor(timediff / 1000);
        //timediff -= secs * 1000;
        if (isNaN(hours) == false && isNaN(mins) == false) {
            $("#TextBox_CustomAcuteServicesPrescreens_ElapsedHours").val(hours).change();
            $("#TextBox_CustomAcuteServicesPrescreens_ElapsedMinutes").val(mins).change();
            $("#HiddenField_CustomAcuteServicesPrescreens_ElapsedHours").val(hours);
            $("#HiddenField_CustomAcuteServicesPrescreens_ElapsedMinutes").val(mins);
        }
        else {
            $("#TextBox_CustomAcuteServicesPrescreens_ElapsedHours").val('').change();
            $("#TextBox_CustomAcuteServicesPrescreens_ElapsedMinutes").val('').change();
        }
    }
    catch (err) {
        LogClientSideException(err, 'PreScreen');
    }
}

//This is function is required for Telerik tabs
function RefreshTabPageContents(tabControl, selectedTabTitle) {

}

//Description: For Voluntary and Involuntary checkboxes on PreScreen Recommendations/Summary page
//Author: Jitender
//Created On: June 15, 2010

function AddEventHandlers() {
    $("#CheckBox_CustomAcuteServicesPrescreens_SummaryVoluntary").click(function() {
        SetCheckBoxes($(this));
    });

    $("#CheckBox_CustomAcuteServicesPrescreens_SummaryInvoluntary").click(function() {
        SetCheckBoxes($(this));
    });

}

//Description: For Voluntary and Involuntary checkboxes on PreScreen Recommendations/Summary page
//Author: Jitender
//Created On: June 15, 2010
function SetCheckBoxes(sender) {
    try {
        var id = sender.attr("id");
        switch (id) {
            case 'CheckBox_CustomAcuteServicesPrescreens_SummaryVoluntary':
                if ($("#CheckBox_CustomAcuteServicesPrescreens_SummaryInvoluntary").attr('checked') == 'checked' || $("#CheckBox_CustomAcuteServicesPrescreens_SummaryInvoluntary").attr("checked") == true) {
                    $("#CheckBox_CustomAcuteServicesPrescreens_SummaryInvoluntary").removeAttr("checked");
                }
                break;
            case 'CheckBox_CustomAcuteServicesPrescreens_SummaryInvoluntary':
                if ($("#CheckBox_CustomAcuteServicesPrescreens_SummaryVoluntary").attr('checked') == 'checked' || $("#CheckBox_CustomAcuteServicesPrescreens_SummaryVoluntary").attr("checked") == true) {
                    $("#CheckBox_CustomAcuteServicesPrescreens_SummaryVoluntary").removeAttr("checked");
                }
                break;
        }
    }
    catch (err) {
        LogClientSideException(err, 'PreScreen');
    }

}
///Function : This Function is used to resize div of parent child grid
///Created Date: May 03, 2010
///Author: Jitender
function ResizeScreenAfterContainerResize() {

    $("div [id$=InsertGridSubstance]").css("height", "50%");
    $("div [id$=InsertGridHealthHistory]").css("height", "100");
}


///Function : This Function is used to validate date of birth
///Created Date: Nov 01, 2010
///Author: Jitender
function ValidateFutureDate(tableName, columnName, sender) {
    try {
        var todateDate = new Date();
        var time = "12:00 AM";
        var dateDOB = new Date($(sender).val() + " " + time);

        if (dateDOB > todateDate) {
            ShowHideErrorMessage('Future date is invalid for date of birth.', 'true');
            $(sender).val('');
            CreateAutoSaveXml(tableName, columnName, $(sender).val());
            return false;
        }
    }


    catch (err) {
        LogClientSideException(err, 'SUScreen');
    }

}

//Function to Enable the Upload button on PreScreen
//Author  Created By Mahesh on 25-Oct-2010
$("document").ready(function() {
    PrescreenReady();
}
);

function PrescreenReady() {
    //added by priya ref:task no:2072
    //Added by Daman ref: task no:595 'PA'
    //try/catch added by shifali in ref to task# 404 Group Services & Notes
    //Purpose - If PreScreen is opened from Group Services then ProcedureCodeId var undefined error pops up
    try {
        if (ApplicationId != 2 && ApplicationId != 1) {
            if (objectPageResponse.KeyFieldValue == 0) {
                if (ProcedureCodeId != undefined)

                    if (WorkingMode == "new") {
                    $("#ButtonUpload").removeAttr("Disabled");
                    $("#ButtonUpload").bind("click", function() {
                        ServiceNoteTabPage.SetActiveTab(ServiceNoteTabPage.tabs[0]);
                        ServiceNoteTabPage.RaiseTabClick(0, onTabSelected);
                    });
                }
                else {

                    $("#ButtonUpload").attr("Disabled", "true");

                }

            }
        }
    }
    catch (err) {
        $("#ButtonUpload").attr("Disabled", "true");
    }
}

function SetSUCurrentUse(obj, val) {
    if ($(obj).attr("checked")) {
        if (AutoSaveXMLDom != undefined && AutoSaveXMLDom != "null" && AutoSaveXMLDom != "") {
            CreateAutoSaveXml('CustomAcuteServicesPrescreens', 'SUCurrentUse', val);
        }
    }
}





