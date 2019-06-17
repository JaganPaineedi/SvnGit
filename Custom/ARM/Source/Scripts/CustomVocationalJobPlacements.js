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
// Date:        10 jun 2011
//=========================================================================================

//Purpose : Job Placed Between From and Job Placed Between To Date Validation
function ManageToolbarItems() {
    ShowToolbarItems('New');
   
    
    
}
function JobDevelopment() {
    var _FromDate = $("#TextBox_JobDevelopmentFrom").val();
    var _ToDate = $("#TextBox_JobDevelopmentTo").val();
   
    if (_FromDate == "") {
        ShowHideErrorMessage("Please fill the Job Place From Date.", 'true');
        return false;
    }
    if (_ToDate == "") {
        ShowHideErrorMessage("Please fill the Job Place To Date.", 'true');
        return false;
    }
    
    if (_FromDate == "" || _FromDate == undefined) {
    }
    else {
        if (!Date.parse(_FromDate)) {
            ShowHideErrorMessage("Please enter correct Job Place Between From Date.", 'true');
            $("#TextBox_JobDevelopmentFrom").val('');
            $("#TextBox_JobDevelopmentFrom").focus();
            return false;
        }
        if (isDate(_FromDate, 'Job Place Between From') == false) {
            $("#TextBox_JobDevelopmentFrom").val('');
            $("#TextBox_JobDevelopmentFrom").focus();
            return false;
        }
    }

    if (_ToDate == "" || _ToDate == undefined) {
    }
    else {
        if (isDate(_ToDate, 'Job Place Between TO') == false) {
            $("#TextBox_JobDevelopmentTo").val('');
            $("#TextBox_JobDevelopmentTo").focus();
            return false;
        }
        if (!Date.parse(_ToDate)) {
            ShowHideErrorMessage("Please enter correct Job Place Between To Date.", 'true');
            $("#TextBox_JobDevelopmentTo").val('');
            $("#TextBox_JobDevelopmentTo").focus();
            return false;
        }
    }
    if (_FromDate == "" || _FromDate == undefined || _ToDate == "" || _ToDate == undefined) {
    }
    else {
        if (Date.parse(_FromDate) <= Date.parse(_ToDate)) {
            ShowHideErrorMessage("", 'false');
        }
        else {
            ShowHideErrorMessage("Job Place Between From Date should be less than Job Place Between To Date.", 'true');
            $("#TextBox_JobDevelopmentTo").focus();
            return false;
        }
    }
    return true;
}

//Purpose : Job start  From and Job start Between To Date Validation
function JobDevelopmentStartDate() {
    var _FromDate = $("#TextBox_JobStartBetweenFrom").val();
    var _ToDate = $("#TextBox_JobStartBetweenTo").val();
   // alert(_FromDate);
    if (_FromDate == "") {
        ShowHideErrorMessage("Please fill the Job Start From Date.", 'true');
        return false;
    }
    if (_ToDate == "") {
        ShowHideErrorMessage("Please fill the Job Start To Date.", 'true');
        return false;
    }
    if (_FromDate == "" || _FromDate == undefined) { 
    }
    else {
        if (!Date.parse(_FromDate)) {
            ShowHideErrorMessage("Please enter correct Job Start From Date.", 'true');
            $("#TextBox_JobStartBetweenFrom").val('');
            $("#TextBox_JobStartBetweenFrom").focus();
            return false;
        }
        if (isDate(_FromDate, 'Job Place Between From') == false) {
            $("#TextBox_JobStartBetweenFrom").val('');
            $("#TextBox_JobStartBetweenFrom").focus();
            return false;
        }
    }

    if (_ToDate == "" || _ToDate == undefined) {
    }
    else {
        if (isDate(_ToDate, 'Job Start TO') == false) {
            $("#TextBox_JobStartBetweenTo").val('');
            $("#TextBox_JobStartBetweenTo").focus();
            return false;
        }
        if (!Date.parse(_ToDate)) {
            ShowHideErrorMessage("Please enter correct Job Start To Date.", 'true');
            $("#TextBox_JobStartBetweenTo").val('');
            $("#TextBox_JobStartBetweenTo").focus();
            return false;
        }
    }
    if (_FromDate == "" || _FromDate == undefined || _ToDate == "" || _ToDate == undefined) {
    }
    else {
        if (Date.parse(_FromDate) <= Date.parse(_ToDate)) {
            ShowHideErrorMessage("", 'false');
        }
        else {
            ShowHideErrorMessage("Job Start From Date should be less than Job Start To Date.", 'true');
            $("#TextBox_JobStartBetweenTo").focus();
            return false;
        }
    }
    return true;
}
//This Function calls when apply filter is clicked.
function ValidateListFilters() {
    if (JobDevelopment() == true) {
        return JobDevelopmentStartDate()
    }
    else {
        return false;
    };
}
