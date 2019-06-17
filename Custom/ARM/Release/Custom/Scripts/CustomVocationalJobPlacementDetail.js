//=========================================================================================
// Copyright (C) 2010 Streamline Healthcare Solutions Inc.
//
// All rights are reserved. Reproduction or transmission in whole or in part, in
// any form or by any means, electronic, mechanical or otherwise, is prohibited
// without the prior written consent of the copyright owner.
//
// Filename:    CustomVocationalJobPlacements.js
//
// Author:      Vaibhav Khare
// Date:        14 jun 2011
//=========================================================================================
var CustomVocationalJobPlacementId;
function ManageToolbarItems() {
    ShowToolbarItems('New');
    ShowToolbarItems('Save');
}
//function SetScreenSpecificValues(dom) {

//    CustomVocationalJobPlacementId = GetFielValueFromXMLDom(dom, "CustomVocationalJobPlacements", "CustomVocationalJobPlacementId")
//}
//function SetFilterParameterValueOnSave() {
//    return 'CustomVocationalJobPlacementId=' + CustomVocationalJobPlacementId;
//}
//Purpose : Job Placed Between From and Job Placed Between To Date Validation
function JobDevelopment() {
    var _JobDevelopmentStartDate = $("#TextBox_CustomVocationalJobPlacements_JobDevelopmentStartDate").val();
    var _JobShift = $('[id$=DropDownList_CustomVocationalJobPlacements_JobShift] option:selected').text();    //$("#DropDownList_CustomVocationalJobPlacements_JobShift option:selected").text();
    //var _JobLossReason = $('[id$=DropDownList_CustomVocationalJobPlacements_JobLossReason] option:selected').text();
    // var _JobPlacementDate = $("#TextBox_CustomVocationalJobPlacements_JobPlacementDate").val();
    var _JobStartDate = $("#TextBox_CustomVocationalJobPlacements_JobStartDate").val();
    var hours1 = $("[id$=TextBox_CustomVocationalJobPlacements_JobHoursPerWeek]").val();
    var hour21 = Math.floor(hours1); //hours.indexOf('.');
    var hour11 = hour21.toString();
    if (_JobDevelopmentStartDate == "" || _JobDevelopmentStartDate == undefined) {
         ShowHideErrorMessage("Please enter Job Development Start Date .", 'true');
         $("#TextBox_CustomVocationalJobPlacements_JobDevelopmentStartDate").focus();
        return false;
    }else if (_JobShift == "" || _JobShift == undefined)     {
         ShowHideErrorMessage("Please enter Job Shift .", 'true');
         $("#DropDownList_CustomVocationalJobPlacements_JobShift").focus();
        return false;
//    }else if (_JobLossReason == "" || _JobLossReason == undefined)     {
//         ShowHideErrorMessage("Please Job LossReason .", 'true');
//          $("#DropDownList_CustomVocationalJobPlacements_JobLossReason").focus();
//        return false;
//    } else if (_JobPlacementDate == "" || _JobPlacementDate == undefined) {
//        ShowHideErrorMessage("Please Job Placement Date.", 'true');
        //        $("#TextBox_CustomVocationalJobPlacements_JobPlacementDate").focus();
//        return false;
    } else if (_JobStartDate == "" || _JobStartDate == undefined) {
        ShowHideErrorMessage("Please Job Start Date.", 'true');
        $("#TextBox_CustomVocationalJobPlacements_JobStartDate").focus();
        return false;
    }
    
    else  if (hour11.length > 2) {
        ShowHideErrorMessage("Please Enter valid Hours per week.", 'true');
        $("[id$=TextBox_CustomVocationalJobPlacements_JobHoursPerWeek]").val('');
        return false;
    }
   
    
     else
    {
        return true;
    }
    
   

   
}


//This Function calls when apply filter is clicked.
function ValidateCustomPageEventHandler() {
    
    return JobDevelopment();

}

function validateHours() {
var hours = $("[id$=TextBox_CustomVocationalJobPlacements_JobHoursPerWeek]").val();
var hour2 = Math.floor(hours); //hours.indexOf('.');
var hour1 = hour2.toString();
    if (hour1.length > 2) {
        ShowHideErrorMessage("Please Enter valid Hours per week.", 'true');
        $("[id$=TextBox_CustomVocationalJobPlacements_JobHoursPerWeek]").val('');
    }
    else {
        ShowHideErrorMessage("Please Enter valid Hours per week.", 'false');
    }

}

function maxLength(field, maxChars) {
    if (field.value.length >= maxChars) {
        event.returnValue = false;
        return false;
    }
}

function maxLengthPaste(field, maxChars) {
    event.returnValue = false;
    if ((field.value.length + window.clipboardData.getData("Text").length) > maxChars) {
        return false;
    }
    event.returnValue = true;
}
   
   
   